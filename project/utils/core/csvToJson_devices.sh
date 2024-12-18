#!/bin/bash
# Software Name: Tips'n'tools
# SPDX-FileCopyrightText: Copyright (c) 2016-2024 Pierre-Yves Lapersonne
# SPDX-License-Identifier: MIT
#
# Author..............: Pierre-Yves Lapersonne
# Version.............: 3.0.2
# Since...............: 06/03/2018
# Description.........: Process a file/an input (mainly in CSV format) to JSON
#			This CSV file must contain several columns: Type, OS, Constructor, Name, Screen size, Sreen type, Screen resolution, SoC, GPU, Sensors, Batery, Storage, RAM, Camera, Dimensions, Weight, IP, USB Type, SD Card, SIM , UI
#
# Usage: bash csvToJson_devices.sh --help
# Usage: cat myFileToProcess.csv | bash csvToJson_devices.sh > myOutputFile.json
#
# ✿✿✿✿ ʕ •ᴥ•ʔ/ ︻デ═一

# Debug purposes
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
	echo "USAGE: cat myFileToProcess.csv | bash csvToJson_devices.sh [ --help ]"
	exit 0
fi

touch $TEMP_FILE_FOR_OUTPUTS;

currentRowIndex=0;

# ***** Step 1: Prepare the header of the output
echo -e "[" >> $TEMP_FILE_FOR_OUTPUTS;

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
			0) # Type
				echo -e "\"type\": \"$cleanItem\", \c" >> $TEMP_FILE_FOR_OUTPUTS;
				;;
			1) # OS
				echo -e "\"os\": \"$cleanItem\", \c" >> $TEMP_FILE_FOR_OUTPUTS;
				;;
			2) # Constructor
				echo -e "\"constructorName\": \"$cleanItem\", \c" >> $TEMP_FILE_FOR_OUTPUTS;
				;;
			3) # Name
				echo -e "\"name\": \"$cleanItem\", \c" >> $TEMP_FILE_FOR_OUTPUTS;
				;;
			4) # Screen size
				echo -e "\"screensize\": \"$cleanItem\", \c" >> $TEMP_FILE_FOR_OUTPUTS;
				;;
			5) # Screen type
				echo -e "\"screentype\": \"$cleanItem\", \c" >> $TEMP_FILE_FOR_OUTPUTS;
				;;
			6) # Screen resolution
				echo -e "\"screenresolution\": \"$cleanItem\", \c" >> $TEMP_FILE_FOR_OUTPUTS;
				;;
			7) # SoC
				echo -e "\"soc\": \"$cleanItem\", \c" >> $TEMP_FILE_FOR_OUTPUTS;
				;;
			8) # GPU
				echo -e "\"gpu\": \"$cleanItem\", \c" >> $TEMP_FILE_FOR_OUTPUTS;
				;;
			9) # Sensors
				echo -e "\"sensors\": \"$cleanItem\", \c" >> $TEMP_FILE_FOR_OUTPUTS;
				;;
			10) # Battery
				echo -e "\"battery\": \"$cleanItem\", \c" >> $TEMP_FILE_FOR_OUTPUTS;
				;;
			11) # Storage
				echo -e "\"storage\": \"$cleanItem\", \c" >> $TEMP_FILE_FOR_OUTPUTS;
				;;
			12) # RAM
				echo -e "\"ram\": \"$cleanItem\", \c" >> $TEMP_FILE_FOR_OUTPUTS;
				;;
			13) # Camera
				echo -e "\"camera\": \"$cleanItem\", \c" >> $TEMP_FILE_FOR_OUTPUTS;
				;;
			14) # Dimensions
				echo -e "\"dimensions\": \"$cleanItem\", \c" >> $TEMP_FILE_FOR_OUTPUTS;
				;;
			15) # USB
				echo -e "\"usbtype\": \"$cleanItem\", \c" >> $TEMP_FILE_FOR_OUTPUTS;
				;;
			16) # Weight
				echo -e "\"weight\": \"$cleanItem\", \c" >> $TEMP_FILE_FOR_OUTPUTS;
				;;
			17) # IP certification
				echo -e "\"ip\": \"$cleanItem\", \c" >> $TEMP_FILE_FOR_OUTPUTS;
				;;
			18) # SD card
				echo -e "\"sdcard\": \"$cleanItem\", \c" >> $TEMP_FILE_FOR_OUTPUTS;
				;;
			19) # SIM card
				echo -e "\"sim\": \"$cleanItem\", \c" >> $TEMP_FILE_FOR_OUTPUTS;
				;;
			20) # UI
				echo -e "\"ui\": \"$cleanItem\"\c" >> $TEMP_FILE_FOR_OUTPUTS;
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
