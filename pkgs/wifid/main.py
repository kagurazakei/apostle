#!/usr/bin/env python3
import signal
import sys
import time
import subprocess
from datetime import datetime
import dbus
from dbus.mainloop.glib import DBusGMainLoop
from gi.repository import GLib

# Constants
IWD_SERVICE = "net.connman.iwd"
IWD_AGENT_MANAGER_INTERFACE = "net.connman.iwd.AgentManager"
IWD_DEVICE_INTERFACE = "net.connman.iwd.Device"
IWD_STATION_INTERFACE = "net.connman.iwd.Station"
IWD_NETWORK_INTERFACE = "net.connman.iwd.Network"
DBUS_PROPERTIES_INTERFACE = "org.freedesktop.DBus.Properties"

# Global variables
keep_running = True
connected_stations = {}  # Dict mapping station_path to ssid
mainloop = None

def cleanup_connected_ssids():
    """Clear all connected SSIDs using initctl before exiting"""
    global connected_stations
    timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")

    for station_path, ssid in connected_stations.items():
        sanitized_ssid = sanitize_ssid(ssid)
        try:
            cmd = ["initctl", "cond", "clear", sanitized_ssid]
            result = subprocess.run(cmd, capture_output=True, text=True)
            if result.returncode == 0:
                print(f"[{timestamp}] Cleanup - Executed: {' '.join(cmd)}")
            else:
                print(f"[{timestamp}] Cleanup - Failed to execute: {' '.join(cmd)} - {result.stderr}")
        except Exception as e:
            print(f"[{timestamp}] Cleanup - Error executing command: {e}")
        sys.stdout.flush()

def signal_handler(sig, frame):
    global keep_running, mainloop
    print(f"\nReceived signal {sig}, shutting down...")
    cleanup_connected_ssids()
    keep_running = False
    if mainloop:
        mainloop.quit()

def sanitize_ssid(ssid):
    """Convert SSID to contain only alphanumeric characters and allowed special characters (+, -, _, ,)"""
    import re
    # Replace non-alphanumeric characters (except +, -, _, and ,) with underscores
    sanitized = re.sub(r'[^a-zA-Z0-9+\-_,]', '_', ssid)
    # Remove consecutive underscores and strip leading/trailing underscores
    sanitized = re.sub(r'_+', '_', sanitized).strip('_')
    return sanitized

def log_event(event_type, ssid):
    timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    sanitized_ssid = sanitize_ssid(ssid)
    print(f"[{timestamp}] {event_type}: {ssid} (sanitized: {sanitized_ssid})")
    sys.stdout.flush()

    # Execute initctl commands based on event type
    try:
        if event_type == "CONNECTED" or event_type == "ALREADY CONNECTED":
            cmd = [ "initctl", "cond", "set", sanitized_ssid]
            result = subprocess.run(cmd, capture_output=True, text=True)
            if result.returncode == 0:
                print(f"[{timestamp}] Executed: {' '.join(cmd)}")
            else:
                print(f"[{timestamp}] Failed to execute: {' '.join(cmd)} - {result.stderr}")
        elif event_type == "DISCONNECTED":
            cmd = ["initctl", "cond", "clear", sanitized_ssid]
            result = subprocess.run(cmd, capture_output=True, text=True)
            if result.returncode == 0:
                print(f"[{timestamp}] Executed: {' '.join(cmd)}")
            else:
                print(f"[{timestamp}] Failed to execute: {' '.join(cmd)} - {result.stderr}")
    except Exception as e:
        print(f"[{timestamp}] Error executing command: {e}")

    sys.stdout.flush()

def check_iwd_service(bus):
    try:
        dbus_obj = bus.get_object("org.freedesktop.DBus", "/org/freedesktop/DBus")
        dbus_iface = dbus.Interface(dbus_obj, "org.freedesktop.DBus")
        return IWD_SERVICE in dbus_iface.ListNames()
    except dbus.DBusException as e:
        print(f"Error checking for iwd service: {e}")
        return False

def get_property(bus, service, object_path, interface, property_name):
    try:
        obj = bus.get_object(service, object_path)
        props = dbus.Interface(obj, DBUS_PROPERTIES_INTERFACE)
        return props.Get(interface, property_name)
    except dbus.DBusException:
        return None

def get_connected_networks(bus):
    connected_networks = []

    try:
        obj = bus.get_object(IWD_SERVICE, "/")
        manager = dbus.Interface(obj, "org.freedesktop.DBus.ObjectManager")
        objects = manager.GetManagedObjects()

        for path, interfaces in objects.items():
            if IWD_STATION_INTERFACE in interfaces:
                state = get_property(bus, IWD_SERVICE, path, IWD_STATION_INTERFACE, "State")

                if state == "connected":
                    connected_network_path = get_property(bus, IWD_SERVICE, path,
                                                        IWD_STATION_INTERFACE, "ConnectedNetwork")

                    if connected_network_path:
                        ssid = get_property(bus, IWD_SERVICE, connected_network_path,
                                          IWD_NETWORK_INTERFACE, "Name")

                        if ssid:
                            print(f"Found connected network: {connected_network_path} (SSID: {ssid})")
                            connected_networks.append((connected_network_path, ssid))
                            connected_stations[path] = ssid

    except dbus.DBusException as e:
        print(f"Error getting managed objects: {e}")

    return connected_networks

def on_properties_changed(interface_name, changed_properties, invalidated_properties, path):
    if interface_name != IWD_STATION_INTERFACE:
        return

    if "State" in changed_properties:
        state = changed_properties["State"]

        if state == "connected":
            bus = dbus.SystemBus()
            connected_network_path = get_property(bus, IWD_SERVICE, path,
                                                IWD_STATION_INTERFACE, "ConnectedNetwork")

            if connected_network_path:
                ssid = get_property(bus, IWD_SERVICE, connected_network_path,
                                  IWD_NETWORK_INTERFACE, "Name")

                if ssid:
                    log_event("CONNECTED", ssid)
                    connected_stations[path] = ssid

        elif state == "disconnected":
            ssid = connected_stations.get(path, "Unknown WiFi network")
            log_event("DISCONNECTED", ssid)
            if path in connected_stations:
                del connected_stations[path]

def main():
    global mainloop

    print("D-Bus iwd WiFi Network Monitor Daemon")
    print("=====================================\n")

    # Set up signal handlers
    signal.signal(signal.SIGINT, signal_handler)
    signal.signal(signal.SIGTERM, signal_handler)

    # Set up D-Bus connection
    DBusGMainLoop(set_as_default=True)
    bus = dbus.SystemBus()

    print("Successfully connected to system D-Bus")

    # Check if iwd service is running
    if not check_iwd_service(bus):
        print("iwd service is not running on this system")
        return 1

    print("iwd service is running\n")

    # Check currently connected networks
    print("Checking currently connected WiFi networks...")
    connected_networks = get_connected_networks(bus)

    if connected_networks:
        print("\nCurrently connected networks:")
        for _, ssid in connected_networks:
            print(f"  - {ssid}")
            log_event("ALREADY CONNECTED", ssid)
    else:
        print("No WiFi networks currently connected")

    # Subscribe to property changes
    bus.add_signal_receiver(on_properties_changed,
                          dbus_interface=DBUS_PROPERTIES_INTERFACE,
                          signal_name="PropertiesChanged",
                          bus_name=IWD_SERVICE,
                          path_keyword="path")

    print("\nMonitoring for WiFi connect/disconnect events (Press Ctrl+C to stop)...\n")

    # Run the main loop
    mainloop = GLib.MainLoop()
    try:
        mainloop.run()
    except KeyboardInterrupt:
        pass

    # Clean up connected SSIDs before exiting
    cleanup_connected_ssids()

    print("\nShutdown complete")
    return 0

if __name__ == "__main__":
    sys.exit(main())
