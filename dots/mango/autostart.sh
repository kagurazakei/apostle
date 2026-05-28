#!/usr/bin/env bash
uwsm finalize

# services
app2unit -t service -s a qs -c mango
app2unit -t service -s s hjem-impure
app2unit -t service -s b foot --server
app2unit -t service -s b stash watch
app2unit -t service -s a nm-applet
