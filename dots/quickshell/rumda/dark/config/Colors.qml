pragma Singleton
import Quickshell
import QtQuick

Singleton {

  property color backgroundColor: "#1a1826"  //bar color - deep rose pine base
  property color indicatorBGColor: "#eb6f92"  //rose pine love accent
  property color borderColor: "#393552"  //oxocarbon muted border
  property color moduleBG: "#2a273f"  //oxocarbon module background
  property color accentColor: "#eb6f92"  //rose pine love pink
  property color accent2Color: "#f6c177"  //rose pine gold/warm
  property color gradientAccent2Color: "#c4a7e7"  //rose pine iris - bottom/right of volume bar
  property color errorColor: "#eb6f92"  //rose pine love error
  property color shadowColor: "#CC1a1826"  //shadow using base color

  // dashboard related colors
  property color dashBGColor: "#191724"  //rose pine base
  property color dashModulesColor: "#2a273f"  //oxocarbon modules
  property color dashBorderColor: "#393552"  //oxocarbon border
  property color dashPFPColor: "#191724"  //rose pine base for pfp circle
  
  // contribution squares in the commit graph
  property color level0Contrib: "#2a273f"  //oxocarbon dark
  property color level1Contrib: "#eb6f92"  //rose pine love - light
  property color level2Contrib: "#f6c177"  //rose pine gold
  property color level3Contrib: "#c4a7e7"  //rose pine iris
  property color level4Contrib: "#9ccfd8"  //rose pine subtle blue
  
  // bg color of the buttons
  property color powerButtons: "#191724"  //rose pine base
  
  // ignore this
  property color dashAccentColor: "#3A2D00"
}
