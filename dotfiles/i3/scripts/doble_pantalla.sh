#!/bin/bash
IN="eDP1"
EXT="HDMI2"
if (xrandr | grep "$EXT disconnected")
then
    xrandr --output $IN --auto --output $EXT --off
else
    xrandr --output $IN --auto --output $EXT --auto --primary --left-of $IN 
fi
feh --bg-scale --random /home/ziko/Imagenes/Wallmine/
