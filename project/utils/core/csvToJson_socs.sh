#!/bin/bash
# Software Name: Tips'n'tools
# SPDX-FileCopyrightText: Copyright (c) 2016-2023 Pierre-Yves Lapersonne
# SPDX-License-Identifier: MIT
#
# Author..............: Pierre-Yves Lapersonne
# Version.............: 3.0.2
# Since...............: 06/03/2018
# Description.........: Process a file/an input (mainly in CSV format) to JSON
#			This file must contain several columns: Constructor, Target, Name, Gravure, Modem, Peak download speed, Peak upload speed, Bluetooth, NFC, USB, Camera support max., Video capture max., Video playback max., Display max., CPU, CPU cores number, CPU clock speed max., CPU architecture, GPU, GPU API support, AI support
#
# Usage: bash csvToJson_socs.sh --help
# Usage: cat myFileToProcess.csv | bash csvToJson_socs.sh > myOutputFile.html
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
	echo "USAGE: cat myFileToProcess.csv | bash csvToJson_socs.sh [ --help ]"
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
			0) # Constructor
				echo -e "\"constructorName\": \"$cleanItem\", \c" >> $TEMP_FILE_FOR_OUTPUTS;
				;;
			1) # Target
				echo -e "\"target\": \"$cleanItem\", \c" >> $TEMP_FILE_FOR_OUTPUTS;
				;;
			2) # Name
				echo -e "\"name\": \"$cleanItem\", \c" >> $TEMP_FILE_FOR_OUTPUTS;
				;;
			3) # Gravure
				echo -e "\"gravure\": \"$cleanItem\", \c" >> $TEMP_FILE_FOR_OUTPUTS;
				;;
			4) # Modem
				echo -e "\"modem\": \"$cleanItem\", \c" >> $TEMP_FILE_FOR_OUTPUTS;
				;;
			5) # Peak download speed
				echo -e "\"peakdownloadspeed\": \"$cleanItem\", \c" >> $TEMP_FILE_FOR_OUTPUTS;
				;;
			6) # Peak upload speed
				echo -e "\"peakuploadspeed\": \"$cleanItem\", \c" >> $TEMP_FILE_FOR_OUTPUTS;
				;;
			7) # Bluetooth
				echo -e "\"bluetooth\": \"$cleanItem\", \c" >> $TEMP_FILE_FOR_OUTPUTS;
				;;
			8) # NFC
				echo -e "\"nfc\": \"$cleanItem\", \c" >> $TEMP_FILE_FOR_OUTPUTS;
				;;
			9) # USB
				echo -e "\"usb\": \"$cleanItem\", \c" >> $TEMP_FILE_FOR_OUTPUTS;
				;;
			10) # Camera support max.
				echo -e "\"camerasupportmax\": \"$cleanItem\", \c" >> $TEMP_FILE_FOR_OUTPUTS;
				;;
			11) # Video capture max.
				echo -e "\"videocapturemax\": \"$cleanItem\", \c" >> $TEMP_FILE_FOR_OUTPUTS;
				;;
			12) # Video playback max.
				echo -e "\"videoplaybackmax\": \"$cleanItem\", \c" >> $TEMP_FILE_FOR_OUTPUTS;
				;;
			13) # Display max.
				echo -e "\"displaymax\": \"$cleanItem\", \c" >> $TEMP_FILE_FOR_OUTPUTS;
				;;
			14) # CPU
				echo -e "\"cpu\": \"$cleanItem\", \c" >> $TEMP_FILE_FOR_OUTPUTS;
				;;
			15) # CPU core's number
				echo -e "\"cpucoresnumber\": \"$cleanItem\", \c" >> $TEMP_FILE_FOR_OUTPUTS;
				;;
			16) # CPU closk speed max.
				echo -e "\"cpuclockspeedmax\": \"$cleanItem\", \c" >> $TEMP_FILE_FOR_OUTPUTS;
				;;
			17) # ICPU architecture
				echo -e "\"cpuarchitecture\": \"$cleanItem\", \c" >> $TEMP_FILE_FOR_OUTPUTS;
				;;
			18) # GPU
				echo -e "\"gpu\": \"$cleanItem\", \c" >> $TEMP_FILE_FOR_OUTPUTS;
				;;
			19) # GPU API Support
				echo -e "\"gpuapisupport\": \"$cleanItem\", \c" >> $TEMP_FILE_FOR_OUTPUTS;
				;;
			20) # AI Support
				echo -e "\"aisupport\": \"$cleanItem\"\c" >> $TEMP_FILE_FOR_OUTPUTS;
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
