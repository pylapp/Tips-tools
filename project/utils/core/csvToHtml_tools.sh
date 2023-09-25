#!/bin/bash
# Software Name: Tips'n'tools
# SPDX-FileCopyrightText: Copyright (c) 2016-2023 Pierre-Yves Lapersonne
# SPDX-License-Identifier: MIT
#
# Author..............: Pierre-Yves Lapersonne
# Version.............: 29.0.0
# Since...............: 21/06/2016
# Description.........: Process a file/an input (mainly in CSV format) to HTML with CSS if needed.
#			This file must contain several columns: Plateform, Name, Description, Keywords, URL
#
# Usage: bash csvToHtml_tools.sh --help
# Usage: cat myFileToProcess.csv | bash csvToHtml_tools.sh > myOutputFile.html
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

# ######### #
# MAIN CODE #
# ######### #

# Check args
if [ "$#" -ne 0 ]; then
	echo "USAGE: cat myFileToProcess.csv | bash csvToHtml_tools.sh [ --help ]"
	exit 0
fi

currentRowIndex=0;

# ***** Step 1: Prepare the header of the output
echo "<table id=\"tableTools\">"

# Proces each line of the input
while read -r line; do

	# ***** Step 2: Ignore the useless rows
	if [ $currentRowIndex -lt $NUMBER_OF_LINES_TO_IGNORE ]
	then
		# Get the line of the document where the headers of the columns are
		if [ $currentRowIndex -eq $(($NUMBER_OF_LINES_TO_IGNORE - 1)) ]; then
			echo -e "\t<thead>"
			echo -e "\t\t<tr>"
			regex="s/;/\n/g" # Should work well both on macOS and GNU/Linux		
			echo $line | sed $regex | while read -r item; do
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
	regex="s/;/\n/g" # Should work well both on macOS and GNU/Linux
	echo $line | sed $regex | while read -r item; do
		cleanItem=`echo $item | sed 's/\"//g'`
		# Add an good CSS class
		case "$fieldIndex" in
			0)
				case "$cleanItem" in
					*Android*)
						echo -e "\t\t\t<td class=\"subjectToolsAndroid\">" $cleanItem "</td>"
					;;
					*Design*)
						echo -e "\t\t\t<td class=\"subjectToolsDesign\">" $cleanItem "</td>"
					;;
					*JavaScript*)
						echo -e "\t\t\t<td class=\"subjectToolsJavaScript\">" $cleanItem "</td>"
					;;
					*Java*)
						echo -e "\t\t\t<td class=\"subjectToolsJava\">" $cleanItem "</td>"
					;;
					*Kotlin*)
						echo -e "\t\t\t<td class=\"subjectToolsKotlin\">" $cleanItem "</td>"
					;;
					*Web*)
						echo -e "\t\t\t<td class=\"subjectToolsWeb\">" $cleanItem "</td>"
					;;
					*Swift*)
						echo -e "\t\t\t<td class=\"subjectToolsSwift\">" $cleanItem "</td>"
					;;
					*Go*)
						echo -e "\t\t\t<td class=\"subjectToolsGo\">" $cleanItem "</td>"
					;;
					*Scala*)
						echo -e "\t\t\t<td class=\"subjectToolsScala\">" $cleanItem "</td>"
					;;
					*Groovy*)
						echo -e "\t\t\t<td class=\"subjectToolsGroovy\">" $cleanItem "</td>"
					;;
					*Python*)
						echo -e "\t\t\t<td class=\"subjectPython\">" $cleanItem "</td>"
					;;
					*DevTool*)
						echo -e "\t\t\t<td class=\"subjectToolsDevTool\">" $cleanItem "</td>"
					;;
					*Bots*)
						echo -e "\t\t\t<td class=\"subjectToolsBots\">" $cleanItem "</td>"
					;;
					*Rust*)
						echo -e "\t\t\t<td class=\"subjectToolsRust\">" $cleanItem "</td>"
					;;
					*Dart*)
						echo -e "\t\t\t<td class=\"subjectToolsDart\">" $cleanItem "</td>"
					;;
					*AI*)
						echo -e "\t\t\t<td class=\"subjectToolsAi\">" $cleanItem "</td>"
					;;
					*Humanism*)
						echo -e "\t\t\t<td class=\"subjectToolsHumanism\">" $cleanItem "</td>"
					;;
					*Fuchsia*)
						echo -e "\t\t\t<td class=\"subjectToolsFuchsia\">" $cleanItem "</td>"
					;;
					*CryptoCurrency*)
						echo -e "\t\t\t<td class=\"subjectToolsCryptoCurrency\">" $cleanItem "</td>"
					;;
					*Agile*)
						echo -e "\t\t\t<td class=\"subjectToolsAgile\">" $cleanItem "</td>"
					;;
					*Blockchain*)
						echo -e "\t\t\t<td class=\"subjectToolsBlockchain\">" $cleanItem "</td>"
					;;
					*Ðapp*)
						echo -e "\t\t\t<td class=\"subjectToolsDapp\">" $cleanItem "</td>"
					;;
					*Data*)
						echo -e "\t\t\t<td class=\"subjectToolsData\">" $cleanItem "</td>"
					;;
					*Test*)
						echo -e "\t\t\t<td class=\"subjectToolsTest\">" $cleanItem "</td>"
					;;
					*Security*)
						echo -e "\t\t\t<td class=\"subjectToolsSecurity\">" $cleanItem "</td>"
					;;
					*Ruby*)
						echo -e "\t\t\t<td class=\"subjectToolsRuby\">" $cleanItem "</td>"
					;;					
					*)
						echo -e "\t\t\t<td class=\"subjectToolsOther\">" $cleanItem "</td>"
					;;
				esac
				;;
			1)
				echo -e "\t\t\t<td class=\"nameTools\">" $cleanItem "</td>"
				;;
			2)
				echo -e "\t\t\t<td class=\"descriptionTools\">" $cleanItem "</td>"
				;;
			3)
				echo -e "\t\t\t<td class=\"keywordsTools\">" $cleanItem "</td>"
				;;
			4)
				echo -e "\t\t\t<td class=\"url\"> <a href=\""$cleanItem"\">" $cleanItem "</a></td>"
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
