#!/bin/bash

# if [ $(xtitle) == 'Kitty' ]; then
# 	xtitle
# else
# 	xtitle | awk 'NF>0{print $(NF)}'
# fi

# if [ $(xdotool getactivewindow getwindowname | awk 'NF>0 {print $(NF-1)}')='Obsidian']
# 	xdotool getactivewindow getwindowname
# else
# 	xdotool getactivewindow getwindowname | awk 'NF>0 { print $(NF)}'
# fi

xdotool getactivewindow getwindowname | awk 'NF>0 { print $(NF)}'
