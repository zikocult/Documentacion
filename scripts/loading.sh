#!/bin/bash

init() {
	percent=$1
	bar_count=0
	printf "\033[s"
}

update() {
	bar_count=$((bar_count + 100))

	# Añade un símbolo a cada delimitador
	if [ $(($bar_count % $percent)) -lt 100 ];then
		bar="$bar#"
	fi
	
	# Print progress bar and percentage
	printf "\033[u $bar\033[u \033[100C $(($bar_count / $percent))%%"
}

init 500

count=0
while [[ $count -lt 500 ]]; do
	sleep .005
	count=$((count + 1))
	update
done
printf "\n"



