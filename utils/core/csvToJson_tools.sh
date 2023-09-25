#!/bin/bash
#
#    MIT License
#    Copyright (c) 2016-2020 Pierre-Yves Lapersonne (Mail: dev@pylapersonne.info)
#    Permission is hereby granted, free of charge, to any person obtaining a copy
#    of this software and associated documentation files (the "Software"), to deal
#    in the Software without restriction, including without limitation the rights
#    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#    copies of the Software, and to permit persons to whom the Software is
#    furnished to do so, subject to the following conditions:
#    The above copyright notice and this permission notice shall be included in all
#    copies or substantial portions of the Software.
#    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
#    SOFTWARE.
#
#
# Author..............: Pierre-Yves Lapersonne
# Version.............: 3.0.0
# Since...............: 06/03/2018
# Description.........: Process a file/an input (mainly in CSV format) to JSON
#			This file must contain several columns: Plateform, Name, Description, Keywords, URL
#
# Usage: bash csvToJson_tools.sh --help
# Usage: cat myFileToProcess.csv | bash csvToJson_tools.sh > myOutputFile.html

# Debug purposses
#set -euxo pipefail
set -euo pipefail

# ###### #
# CONFIG #
# ###### #

# CSV separator...
CSV_SEPARATOR=';'

# Empty or useless rows
NUMBER_OF_LINES_TO_IGNORE=6

# Temporary file containing the JSON outputs
TEMP_FILE_FOR_OUTPUTS="./.outputs.temp.json"

# ##### #
# Utils #
# ##### #

DoesRunOnGNULinux(){
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        echo "yes"
    else
        echo "no"
    fi
}

# ######### #
# MAIN CODE #
# ######### #

# Check args
if [ "$#" -ne 0 ]; then
	echo "USAGE: cat myFileToProcess.csv | bash csvToJson_tools.sh [ --help ]"
	exit 0
fi

touch $TEMP_FILE_FOR_OUTPUTS;

currentRowIndex=0;

# ***** Step 1: Prepare the header of the output
echo "[" > $TEMP_FILE_FOR_OUTPUTS;

# Proces each line of the input
while read -r line; do

	# ***** Step 2: Ignore the useless rows
	currentRowIndex=$(($currentRowIndex + 1))
	if [ $currentRowIndex -le $NUMBER_OF_LINES_TO_IGNORE ]
	then
		continue # New turn in the loop
	fi

	# ***** Step 3: Prepare new entry
	echo -e "{\c" >> $TEMP_FILE_FOR_OUTPUTS;

	# ***** Step 4: Split the line and replace ; by \n, and delete useless "
	fieldIndex=0
	regex="s/;/\n/g" # Should work well both on macOS and GNU/Linux	
	echo $line | sed $regex | while read -r item; do
		cleanItem=`echo $item | sed 's/\"//g'`
		# Update entry
		case "$fieldIndex" in
			0) # Platform
				echo -e "\"platform\": \"$cleanItem\", \c" >> $TEMP_FILE_FOR_OUTPUTS;
				;;
			1) # Name
				echo -e "\"name\": \"$cleanItem\", \c" >> $TEMP_FILE_FOR_OUTPUTS;
				;;
			2) # Description
				echo -e "\"description\": \"$cleanItem\", \c" >> $TEMP_FILE_FOR_OUTPUTS;
				;;
			3) # Keywords
				echo -e "\"keywords\": \"$cleanItem\", \c" >> $TEMP_FILE_FOR_OUTPUTS;
				;;
			4) # URL
				echo -e "\"url\": \"$cleanItem\"\c" >> $TEMP_FILE_FOR_OUTPUTS;
				;;
		esac
		fieldIndex=$(($fieldIndex + 1))
	done

	# ***** Step 5: Prepare the footer of the line
	echo "}," >> $TEMP_FILE_FOR_OUTPUTS;

done

# ***** Step 6: Prepare the footer of the output
if [ $(DoesRunOnGNULinux) == "yes" ]; then # GNU/Linux
	truncate -s-2 $TEMP_FILE_FOR_OUTPUTS;
else # macOS
	truncate -s -2 $TEMP_FILE_FOR_OUTPUTS;
fi	

echo -e "\n]" >> $TEMP_FILE_FOR_OUTPUTS

# ***** Step 7: Display content
outputs=`cat $TEMP_FILE_FOR_OUTPUTS`;
rm $TEMP_FILE_FOR_OUTPUTS;
echo "$outputs"
