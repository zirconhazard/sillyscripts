#!/bin/bash

#MIT License

#Copyright (c) 2023 zirconhazard

#Permission is hereby granted, free of charge, to any person obtaining a copy
#of this software and associated documentation files (the "Software"), to deal
#in the Software without restriction, including without limitation the rights
#to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#copies of the Software, and to permit persons to whom the Software is
#furnished to do so, subject to the following conditions:

#The above copyright notice and this permission notice shall be included in all
#copies or substantial portions of the Software.

#THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
#SOFTWARE.

## physics constants
gravity=3	 # mm/ms^2
fric_ground=998  # C [1/nm]
fric_air=1000  #  C [1/nm]
ground_height=10000 # mm
## player physics variable
speed_y=25   # mm/ms
speed_x=12  # mm/ms
player_x=0	   # mm
player_y=0     # mm
vel_x=0		# mm/ms
vel_y=0		# mm/ms
fric_x=0
fric_y=0
on_ground=false
## display settiongs
display_t1=$(( (`date +%s%N`)/1000000 ))
display_t0="$display_t1"
display_size=( 22 42 )
display_h=$(( ${display_size[0]} - 7 )) 
display_w=$(( ${display_size[1]} - 5 ))
#display_size=`stty size`
display_string=""
zeroos="0000"
display_boarderline="--------------------------------------------------------------------------------------------------------------------------------------------------------------------"
display_boarderline_curr="${display_boarderline:0:( $(( display_w+1 )) )}"

while true; do
	## get  milliseconds
	display_t0="$display_t1"
	display_t1=$(( (`date +%s%N`)/1000000 ))
	display_dt=$(( display_t1 - display_t0 ))
	
	## update physics
	vel_y=$(( vel_y+gravity ))
	vel_x=$(( vel_x*fric_x/1000 ))
	player_x=$(( player_x + ((vel_x)*display_dt) ))
	player_y=$(( player_y + ((vel_y)*display_dt) ))
	
	## resize display check ( many rows and cols make game slow )
	#if [ "$display_size" != "$(stty size)" ]; then
		#display_size=( `stty size` )
		#display_h=$(( ${display_size[0]} - 8 )) 
		#display_w=$(( ${display_size[1]} - 6 ))
		#display_size=`stty size`
		#display_boarderline_curr="${display_boarderline:0:( $(( display_w+1 )) )}"
	#fi
	
	## check bounds and ground
	if [ "$player_y" -ge "$ground_height" ]; then
		on_ground=true
		player_y="$ground_height"
		fric_x=fric_ground
		(( vel_y = vel_y<0?vel_y:0 ));		
	else
		fric_x=fric_air
		on_ground=false
	fi
	
	if [ "$player_x" -gt $(( display_w*1000 )) ]; then
		player_x=0;
	elif [ "$player_x" -lt 0 ]; then
		player_x=$(( display_w*1000 ));
	fi
	
	## show display
	display_string=""
	for y in `seq 0 $display_h`; do
		display_string+=" |"
		for x in `seq 0 $display_w`; do
			player_ym=$(( player_y/1000 ))
			player_xm=$(( player_x/1000 ))	
			if [ "$x" -eq "$player_xm" ] && [ "$y" -eq "$player_ym" ]; then
				display_string+="@";
			elif [ "$y" -ge $(( ground_height/1000 )) ]; then
				display_string+=".";
			else
				display_string+=" ";
			fi
		done
		display_string+=$'|\n'
	done
	
	clear
	echo ""
	echo "  GAME - CONTROLS: WASD, EXIT: ESC"
	echo "  $display_boarderline_curr "
	echo -n "$display_string"
	echo "  $display_boarderline_curr "
	## determin refresh delay time 30FPS=33ms 24FPS=42ms 16FPS=62ms
	display_dtmid=$(( ((`date +%s%N`)/1000000) - display_t1 ))
	display_wait=$(( 42 - display_dtmid ))
	(( display_wait = display_wait>0?display_wait:0 ))
	## show info
	echo "  Vx: $vel_x mm/ms, Vy: $vel_y mm/ms, dt: $display_dt ms, WAIT: $display_wait ms"
	echo "  X: $player_x mm, Y: $player_y mm, GROUND: $on_ground, INPUT: '$userinput' "
	## ...
	display_wait="$zeroos$display_wait"
	display_wait="${display_wait:(-3)}"
	display_wait="${display_wait:0:1}.${display_wait:0:4}"
	
	## get input
	read -s -n 2 -t "$display_wait" userinput
	for (( i=0; i<${#userinput}; i++ )); do 
		usrinp="${userinput:$i:1}"
		if [ "$usrinp" == $'\e' ]; then
			exit;
		elif [ "$usrinp" == "a" ]; then
			vel_x="-$speed_x"
		elif [ "$usrinp" == "d" ]; then
			vel_x="$speed_x"
		elif [ "$usrinp" == "w" ] && "$on_ground" ; then
			vel_y="-$speed_y"
		elif [ "$usrinp" == "s" ]; then
			vel_y="$speed_y"
		fi;
	done
done
