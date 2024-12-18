#!/bin/bash
# Software Name: Tips'n'tools
# SPDX-FileCopyrightText: Copyright (c) 2016-2023 Pierre-Yves Lapersonne
# SPDX-License-Identifier: MIT
#
# Author..............: Pierre-Yves Lapersonne
# Version.............: 3.0.0
# Since...............: 06/03/2018
# Description.........: Process a file/an input (mainly in CSV format) to JSON
#			This file must contain several columns: Plateform, Name, Description, Keywords, URL
#
# Usage: bash csvToJson_references.sh --help
# Usage: cat myFileToProcess.csv | bash csvToJson_references.sh > myOutputFile.json
#
# ✿✿✿✿ ʕ •ᴥ•ʔ/ ︻デ═一

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
	echo "USAGE: cat myFileToProcess.csv | bash csvToJson_references.sh [ --help ]"
	exit 0
fi

touch $TEMP_FILE_FOR_OUTPUTS;

currentRowIndex=0;

# ***** Step 1: Prepare the header of the output
echo "[" >> $TEMP_FILE_FOR_OUTPUTS;

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
	echo $line | tr ';' '\n' | while read -r item; do
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
