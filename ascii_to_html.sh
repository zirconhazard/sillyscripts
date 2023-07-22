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

## Dictionary of character numbers to replace
declare -A mydict=( [X10]=$'<br>\n' [X38]="&amp;" [X45]="&#8208" [X60]="&lt;" [X62]="&gt;" [X160]="&nbsp;" [X161]="&iexcl;" [X162]="&cent;" [X163]="&pound;" [X164]="&curren;" [X165]="&yen;" [X166]="&brvbar;" [X167]="&sect;" [X168]="&uml;" [X169]="&copy;" [X170]="&ordf;" [X171]="&laquo;" [X172]="&not;" [X178]="&shy;" [X179]="&reg;" [X175]="&macr;" [X176]="&deg;" [X177]="&plusmn;" [X178]="&sup2;" [X179]="&sup3;" [X180]="&acute;" [X181]="&micro;" [X182]="&para;" [X183]="&middot;" [X184]="&cedil;" [X185]="&sup1;" [X186]="&ordm;" [X187]="&raquo;" [X188]="&frac14;" [X189]="&frac12;" [X190]="&frac34;" [X191]="&iquest;" [X192]="&Agrave;" [X193]="&Aacute;" [X194]="&Acirc;" [X195]="&Atilde;" [X196]="&Auml;" [X197]="&Aring;" [X198]="&AElig;" [X199]="&Ccedil;" [X200]="&Egrave;" [X201]="&Eacute;" [X202]="&Ecirc;" [X203]="&Euml;" [X204]="&Igrave;" [X205]="&Iacute;" [X206]="&Icirc;" [X207]="&Iuml;" [X208]="&ETH;" [X209]="&Ntilde;" [X210]="&Ograve;" [X211]="&Oacute;" [X212]="&Ocirc;" [X213]="&Otilde;" [X214]="&Ouml;" [X215]="&times;" [X216]="&Oslash;" [X217]="&Ugrave;" [X218]="&Uacute;" [X219]="&Ucirc;" [X220]="&Uuml;" [X221]="&Yacute;" [X222]="&THORN;" [X223]="&szlig;" [X224]="&agrave;" [X225]="&aacute;" [X226]="&acirc;" [X227]="&atilde;" [X228]="&auml;" [X229]="&aring;" [X230]="&aelig;" [X231]="&ccedil;" [X232]="&egrave;" [X233]="&eacute;" [X234]="&ecirc;" [X235]="&euml;" [X236]="&igrave;" [X237]="&iacute;" [X238]="&icirc;" [X239]="&iuml;" [X240]="&eth;" [X241]="&ntilde;" [X242]="&ograve;" [X243]="&oacute;" [X244]="&ocirc;" [X245]="&otilde;" [X246]="&ouml;" [X247]="&divide;" [X248]="&oslash;" [X249]="&ugrave;" [X250]="&uacute;" [X251]="&ucirc;" [X252]="&uuml;" [X253]="&yacute;" [X254]="&thorn;" [X255]="&yuml;" )

## if no arguments passed get filepath from user
if [ $# -eq 0 ]; then
	echo -n "No arguments: Input file: "
	read inputfile;
elif [ $# -eq 0 ]; then
	inputfile="$1"
else 
	inputfile="$1"
	outputfile="$2";
fi

## check if file exists
if [ "$inputfile" == "--help" ]; then
	echo "HELP!!!!!!!!!!"
	exit;
elif [ ! -f "$inputfile" ]; then
	echo "File not found!"
	exit;
else
	## load text from file
	echo "Loading text from '$inputfile'."
	text=`cat $inputfile`

	## replace certain characters/output html friendly text
	output=""
	for ((i=1;i<=${#text};i++)); do
		c=${text:$i-1:1}
		num=`printf "%d" "'$c"`
		xnum="X$num"
		if [ ${mydict[$xnum]+_} ]; then
			output+="${mydict[$xnum]}"
		else
			output+="$c"
		fi
	done

	## show output
	beginfile=$'<p style="line-height:1; font-family:monospace; white-space:pre;" >\n'
	endfile=$'\n</p>'
	output="$beginfile$output$endfile"
	echo "---------------------------output--------------------------------"
	echo "$output"
	echo "-----------------------------------------------------------------"

	## save output?
	if [ "$outputfile" != "" ] && touch "$outputfile"; then
		echo "$output" > "$outputfile"
		echo "Created file '$outputfile'.";
	else
		read -e -p "Save to file? [y/N] " choice
		if [[ "$choice" == [Yy]* ]]; then
			echo -n "Specify Output file: "
			read outputfile;
			if touch "$outputfile"; then
				echo "$output" > "$outputfile"
				echo "Created file '$outputfile'.";
			else
				echo "Could not create file '$outputfile'!"
				exit;
			fi
		else
			exit;
		fi
	fi
fi
