#!/bin/bash
# Software Name: Tips'n'tools
# SPDX-FileCopyrightText: Copyright (c) 2016-2024 Pierre-Yves Lapersonne
# SPDX-License-Identifier: MIT
#
# Author..............: Pierre-Yves Lapersonne
# Version.............: 17.0.1
# Since...............: 18/08/2016
# Description.........: Process a file/an input (mainly in CSV format) to HTML with CSS if needed
#			This file must contain several columns: Type, OS, Constructor, Name, Screen size, Sreen type, Screen resolution, SoC, GPU, Sensors, Batery, Storage, RAM, Camera, Dimensions, Weight, IP, USB Type, SD Card, SIM , UI
#
# Usage: bash csvToHtml_devices.sh --help
# Usage: cat myFileToProcess.csv | bash csvToHtml_devices.sh > myOutputFile.html
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
	echo "USAGE: cat myFileToProcess.csv | bash csvToHtml_devices.sh [ --help ]"
	exit 0
fi

currentRowIndex=0;

# ***** Step 1: Prepare the header of the output
echo "<table id=\"tableDevices\">"

# Proces each line of the input
while read -r line; do

	# ***** Step 2: Ignore the useless rows
	if [ $currentRowIndex -lt $NUMBER_OF_LINES_TO_IGNORE ]
	then
		# Get the line of the document where the headers of the columns are
		if [ $currentRowIndex -eq $(($NUMBER_OF_LINES_TO_IGNORE - 1)) ]; then
			echo -e "\t<thead>"
			echo -e "\t\t<tr>"
			echo $line | tr ';' '\n' | while read -r item; do
				echo -e "\t\t\t<td class=\"header\">" $item "</td>"
			done
			echo -e "\t\t</tr>"
			echo -e "\t</thead>"
		fi
		currentRowIndex=$(($currentRowIndex + 1))
		continue
	fi

	# ***** Step 3: Prepare the header of the line
	echo -e "\t\t<tr>"

	# ***** Step 4: Split the line and replace ; by \n, and delete useless "
	fieldIndex=0
	echo $line | tr ';' '\n' | while read -r item; do
		cleanItem=`echo $item | sed 's/\"//g'`
		# Add an good CSS class
		case "$fieldIndex" in
			0)
				case "$cleanItem" in
					*smartphone*)
						echo -e "\t\t\t<td class=\"typeSmartphone\">" $cleanItem "</td>"
					;;
					*watch*)
						echo -e "\t\t\t<td class=\"typeWatch\">" $cleanItem "</td>"
					;;
					*band*)
						echo -e "\t\t\t<td class=\"typeBand\">" $cleanItem "</td>"
					;;
					*box*)
						echo -e "\t\t\t<td class=\"typeBox\">" $cleanItem "</td>"
					;;
					*)
						echo -e "\t\t\t<td class=\"typeOther\">" $cleanItem "</td>"
					;;
				esac
				;;
			1)
				case "$cleanItem" in
					*Android*)
						echo -e "\t\t\t<td class=\"pfAndroid\">" $cleanItem "</td>"
					;;
					*Cyanogen*)
						echo -e "\t\t\t<td class=\"pfCyanogen\">" $cleanItem "</td>"
					;;
					*OxygenOS*)
						echo -e "\t\t\t<td class=\"pfOxygenOS\">" $cleanItem "</td>"
					;;
					*iOS*)
						echo -e "\t\t\t<td class=\"pfIOS\">" $cleanItem "</td>"
					;;
					*Windows*)
						echo -e "\t\t\t<td class=\"pfWindows\">" $cleanItem "</td>"
					;;
					*FirefoxOS*)
						echo -e "\t\t\t<td class=\"pfFirefoxOS\">" $cleanItem "</td>"
					;;
					*UbuntuTouch*)
						echo -e "\t\t\t<td class=\"pfUbuntuTouch\">" $cleanItem "</td>"
					;;
					*Tizen*)
						echo -e "\t\t\t<td class=\"pfTizen\">" $cleanItem "</td>"
					;;
					*watchOS*)
						echo -e "\t\t\t<td class=\"pfWatchOS\">" $cleanItem "</td>"
					;;
					*)
						echo -e "\t\t\t<td class=\"pfOther\">" $cleanItem "</td>"
					;;
				esac
				;;
			2)
				echo -e "\t\t\t<td class=\"constructor\">" $cleanItem "</td>"
				;;
			3)
				echo -e "\t\t\t<td class=\"name\">" $cleanItem "</td>"
				;;
			4)
				echo -e -e "\t\t\t<td class=\"screensize\">" $cleanItem "</td>"
				;;
			5)
				echo -e "\t\t\t<td class=\"screentype\">" $cleanItem "</td>"
				;;
			6)
				echo -e "\t\t\t<td class=\"screenresolution\">" $cleanItem "</td>"
				;;
			7)
				echo -e "\t\t\t<td class=\"soc\">" $cleanItem "</td>"
				;;
			8)
				echo -e "\t\t\t<td class=\"gpu\">" $cleanItem "</td>"
				;;
			9)
				echo -e "\t\t\t<td class=\"sensors\">" $cleanItem "</td>"
				;;
			10)
				echo -e "\t\t\t<td class=\"battery\">" $cleanItem "</td>"
				;;
			11)
				echo -e "\t\t\t<td class=\"storage\">" $cleanItem "</td>"
				;;
			12)
				echo -e "\t\t\t<td class=\"ram\">" $cleanItem "</td>"
				;;
			13)
				echo -e "\t\t\t<td class=\"camera\">" $cleanItem "</td>"
				;;
			14)
				echo -e "\t\t\t<td class=\"dimensions\">" $cleanItem "</td>"
				;;
			15)
				echo -e "\t\t\t<td class=\"usbtype\">" $cleanItem "</td>"
				;;
			16)
				echo -e "\t\t\t<td class=\"weight\">" $cleanItem "</td>"
				;;
			17)
				echo -e "\t\t\t<td class=\"ip\">" $cleanItem "</td>"
				;;
			18)
				echo -e "\t\t\t<td class=\"sdcard\">" $cleanItem "</td>"
				;;
			19)
				echo -e "\t\t\t<td class=\"sim\">" $cleanItem "</td>"
				;;
			20)
				echo -e "\t\t\t<td class=\"ui\">" $cleanItem "</td>"
				;;
		esac
		fieldIndex=$(($fieldIndex + 1))
	done

	# ***** Step 5: Prepare the footer of the line
	echo -e "\t\t</tr>"

done

# ***** Step 6: Prepare the footer of the output
echo -e "\t</tbody>"
echo "</table>"
