#!/bin/bash

## if no arguments passed get filepath from user
if [ $# -eq 0 ]; then
	echo -n "No arguments: Input file: "
	read inputfile;
else
	inputfile="$1";
fi

## check if file exists
if [ ! -f "$inputfile" ]; then
	echo "File not found"
	exit;
else
	## load text from file
	echo "Loading text from $inputfile"
	text=`cat $inputfile`

	## replace certain characters/output html friendly text
	output=""
	for ((i=1;i<=${#text};i++)); do
		c=${text:$i-1:1}
		if [ "$c" == "<" ]; then
			output+="&lt;"
		elif [ "$c" == ">" ]; then
			output+="&gt;"
		elif [ "$c" == "-" ]; then
			output+="&#8208;"
		elif [ "$c" == "°" ]; then
			output+="&deg;"
		elif [ "$c" == "´" ]; then
			output+="&acute;"
		elif [ "$c" == $'\n' ]; then
			output+=$'<br>\n'
		else
			output+="$c"
		fi
	done

	## show output
	echo "---------------------------output--------------------------------"
	echo "$output"
	echo "-----------------------------------------------------------------"

	## save output?
	beginfile=$'<!DOCTYPE html>\n<html>\n<head>\n\t<title>NameMe</title>\n\t<style>\n\t\tbody {\n\t\t\tline-height: 1;\n\t\t\tfont-family: monospace;\n\t\t\twhite-space: pre;\n\t\t}\n\t</style>\n</head>\n\n<body>'
	endfile=$'</body>\n\n</html>'
	read -e -p "Save to file? [y/N] " choice
	if [[ "$choice" == [Yy]* ]]; then
		echo -n "Specify Output file: "
		read outputfile;
		if touch "$outputfile"; then
			echo "$beginfile" > "$outputfile";
			echo "$output" >> "$outputfile";
			echo "$endfile" >> "$outputfile";
		else
			echo "could not create file."
			exit;
		fi
	else
		exit;
	fi
fi

