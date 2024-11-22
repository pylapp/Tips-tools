#!/bin/bash
# Software Name: Tips'n'tools
# SPDX-FileCopyrightText: Copyright (c) 2016-2024 Pierre-Yves Lapersonne
# SPDX-License-Identifier: MIT
#
# Author..............: Pierre-Yves Lapersonne
# Version.............: 13.0.1
# Since...............: 28/11/2016
# Description.........: Process a file/an input (mainly in CSV format) to HTML with CSS if needed
#			This file must contain several columns: Constructor, Target, Name, Gravure, Modem, Peak download speed, Peak upload speed, Bluetooth, NFC, USB, Camera support max., Video capture max., Video playback max., Display max., CPU, CPU cores number, CPU clock speed max., CPU architecture, GPU, GPU API support, AI support
#
# Usage: bash csvToHtml_socs.sh --help
# Usage: cat myFileToProcess.csv | bash csvToHtml_socs.sh > myOutputFile.html
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
	echo "USAGE: cat myFileToProcess.csv | bash csvToHtml_socs.sh [ --help ]"
	exit 0
fi

currentRowIndex=0;

# ***** Step 1: Prepare the header of the output
echo "<table id=\"tableSocs\">"

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
			echo -e "\t<tbody>"
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
		# Add a good CSS class
		case "$fieldIndex" in
			0)
				case "$cleanItem" in
					*Qualcomm*)
						echo -e "\t\t\t<td class=\"constructorQualcomm\">" $cleanItem "</td>"
					;;
					*Samsung*)
						echo -e "\t\t\t<td class=\"constructorSamsung\">" $cleanItem "</td>"
					;;
					*Apple*)
						echo -e "\t\t\t<td class=\"constructorApple\">" $cleanItem "</td>"
					;;
					*MediaTek*)
						echo -e "\t\t\t<td class=\"constructorMediaTek\">" $cleanItem "</td>"
					;;
					*Huawei*)
						echo -e "\t\t\t<td class=\"constructorHuawei\">" $cleanItem "</td>"
					;;
					*Xiaomi*)
						echo -e "\t\t\t<td class=\"constructorXiaomi\">" $cleanItem "</td>"
					;;
					*)
						echo -e "\t\t\t<td class=\"constructorOther\">" $cleanItem "</td>"
					;;
				esac
				;;
			1)
				case "$cleanItem" in
					*tablet*)
						echo -e "\t\t\t<td class=\"targetSmartphoneTablet\">" $cleanItem "</td>"
					;;
					*smartphone*)
						echo -e "\t\t\t<td class=\"targetSmartphone\">" $cleanItem "</td>"
					;;
					*iPhone*)
						echo -e "\t\t\t<td class=\"targetIphone\">" $cleanItem "</td>"
					;;
					*)
						echo -e "\t\t\t<td class=\"targetOther\">" $cleanItem "</td>"
					;;
				esac
				;;
			2)
				echo -e "\t\t\t<td class=\"name\">" $cleanItem "</td>"
				;;
			3)
				echo -e "\t\t\t<td class=\"gravure\">" $cleanItem "</td>"
				;;
			4)
				echo -e "\t\t\t<td class=\"modem\">" $cleanItem "</td>"
				;;
			5)
				echo -e "\t\t\t<td class=\"pds\">" $cleanItem "</td>"
				;;
			6)
				echo -e "\t\t\t<td class=\"pus\">" $cleanItem "</td>"
				;;
			7)
				echo -e "\t\t\t<td class=\"bluetooth\">" $cleanItem "</td>"
				;;
			8)
				echo -e "\t\t\t<td class=\"nfc\">" $cleanItem "</td>"
				;;
			9)
				echo -e "\t\t\t<td class=\"usb\">" $cleanItem "</td>"
				;;
			10)
				echo -e "\t\t\t<td class=\"csm\">" $cleanItem "</td>"
				;;
			11)
				echo -e "\t\t\t<td class=\"vcm\">" $cleanItem "</td>"
				;;
			12)
				echo -e "\t\t\t<td class=\"vpm\">" $cleanItem "</td>"
				;;
			13)
				echo -e "\t\t\t<td class=\"dm\">" $cleanItem "</td>"
				;;
			14)
				echo -e "\t\t\t<td class=\"cpu\">" $cleanItem "</td>"
				;;
			15)
				echo -e "\t\t\t<td class=\"cpucn\">" $cleanItem "</td>"
				;;
			16)
				echo -e "\t\t\t<td class=\"cpucsm\">" $cleanItem "</td>"
				;;
			17)
				echo -e "\t\t\t<td class=\"cpua\">" $cleanItem "</td>"
				;;
			18)
				echo -e "\t\t\t<td class=\"gpu\">" $cleanItem "</td>"
				;;
			19)
				echo -e "\t\t\t<td class=\"gpuas\">" $cleanItem "</td>"
				;;
			20)
				echo -e "\t\t\t<td class=\"ais\">" $cleanItem "</td>"
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
