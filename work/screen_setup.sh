#!/bin/sh
xrandr --output DP1 --primary --mode 1920x1080 --pos 1920x0 --rotate normal 

xrandr --output DP2 --mode 1920x1080 --pos 3850x0 --rotate normal --output DP3 --off 

xrandr --output HDMI1 --mode 1920x1080 --pos 0x0 --rotate normal --output HDMI2 --off 
