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
# Version.............: 6.0.0
# Since...............: 13/12/2017
# Description.........: Process a file/an input (mainly in CSV format) to HTML with CSS if needed.
#			This file must contain several columns: Plateform, Name, Description, Keywords, URL
#
# Usage: bash csvToHtml_references.sh --help
# Usage: cat myFileToProcess.csv | bash csvToHtml_references.sh > myOutputFile.html
#


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
	echo "USAGE: cat myFileToProcess.csv | bash csvToHtml_references.sh [ --help ]"
	exit 0
fi

currentRowIndex=0;

# ***** Step 1: Prepare the header of the output
echo "<table id=\"tableReferences\">"

# Proces each line of the input
while read -r line; do

	# ***** Step 2: Ignore the useless rows
	if [ $currentRowIndex -lt $NUMBER_OF_LINES_TO_IGNORE ]
	then
		# Get the line of the document where the headers of the columns are
		if [ $currentRowIndex -eq $(($NUMBER_OF_LINES_TO_IGNORE - 1)) ]; then
			echo -e "\t<thead>"
			echo -e "\t\t<tr>"
			# For GNU/Linux (good and best) systems
			#echo $line | sed 's/;/\n/g' | while read -r item; do
			# For macOS (not so best) systems	
			echo $line | sed 's/;/\'$'\n/g' | while read -r item; do
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
	fieldIndex=0;
	# For GNU/Linux (good and best) systems
	#echo $line | sed 's/;/\n/g' | while read -r item; do
	# For macOS (not so best) systems	
	echo $line | sed 's/;/\'$'\n/g' | while read -r item; do
		cleanItem=`echo $item | sed 's/\"//g'`
		# Add an good CSS class
		case "$fieldIndex" in
			0)
				case "$cleanItem" in
					*Android*)
						echo -e "\t\t\t<td class=\"subjectReferencesAndroid\">" $cleanItem "</td>"
					;;
					*Design*)
						echo -e "\t\t\t<td class=\"subjectReferencesDesign\">" $cleanItem "</td>"
					;;
					*JavaScript*)
						echo -e "\t\t\t<td class=\"subjectReferencesJavaScript\">" $cleanItem "</td>"
					;;
					*Java*)
						echo -e "\t\t\t<td class=\"subjectReferencesJava\">" $cleanItem "</td>"
					;;
					*Kotlin*)
						echo -e "\t\t\t<td class=\"subjectReferencesKotlin\">" $cleanItem "</td>"
					;;
					*Web*)
						echo -e "\t\t\t<td class=\"subjectReferencesWeb\">" $cleanItem "</td>"
					;;
					*Swift*)
						echo -e "\t\t\t<td class=\"subjectReferencesSwift\">" $cleanItem "</td>"
					;;
					*Go*)
						echo -e "\t\t\t<td class=\"subjectReferencesGo\">" $cleanItem "</td>"
					;;
					*Scala*)
						echo -e "\t\t\t<td class=\"subjectReferencesScala\">" $cleanItem "</td>"
					;;
					*Groovy*)
						echo -e "\t\t\t<td class=\"subjectReferencesGroovy\">" $cleanItem "</td>"
					;;
					*Python*)
						echo -e "\t\t\t<td class=\"subjectReferencesPython\">" $cleanItem "</td>"
					;;
					*DevTool*)
						echo -e "\t\t\t<td class=\"subjectReferencesDevTool\">" $cleanItem "</td>"
					;;
					*Bots*)
						echo -e "\t\t\t<td class=\"subjectReferencesBots\">" $cleanItem "</td>"
					;;
					*Rust*)
						echo -e "\t\t\t<td class=\"subjectReferencesRust\">" $cleanItem "</td>"
					;;
					*Dart*)
						echo -e "\t\t\t<td class=\"subjectReferencesDart\">" $cleanItem "</td>"
					;;
					*AI*)
						echo -e "\t\t\t<td class=\"subjectReferencesAi\">" $cleanItem "</td>"
					;;
					*Humanism*)
						echo -e "\t\t\t<td class=\"subjectReferencesHumanism\">" $cleanItem "</td>"
					;;
					*Fuchsia*)
						echo -e "\t\t\t<td class=\"subjectReferencesFuchsia\">" $cleanItem "</td>"
					;;
					*CryptoCurrency*)
						echo -e "\t\t\t<td class=\"subjectReferencesCryptoCurrency\">" $cleanItem "</td>"
					;;
					*Agile*)
						echo -e "\t\t\t<td class=\"subjectReferencesAgile\">" $cleanItem "</td>"
					;;
					*Blockchain*)
						echo -e "\t\t\t<td class=\"subjectReferencesBlockchain\">" $cleanItem "</td>"
					;;
					*Ðapp*)
						echo -e "\t\t\t<td class=\"subjectReferencesDapp\">" $cleanItem "</td>"
					;;
					*Data*)
						echo -e "\t\t\t<td class=\"subjectReferencesData\">" $cleanItem "</td>"
					;;
					*Test*)
						echo -e "\t\t\t<td class=\"subjectReferencesTest\">" $cleanItem "</td>"
					;;
					*Security*)
						echo -e "\t\t\t<td class=\"subjectReferencesSecurity\">" $cleanItem "</td>"
					;;
					*Ruby*)
						echo -e "\t\t\t<td class=\"subjectReferencesRuby\">" $cleanItem "</td>"
					;;					
					*)
						echo -e "\t\t\t<td class=\"subjectReferencesOther\">" $cleanItem "</td>"
					;;
				esac
				;;
			1)
				echo -e "\t\t\t<td class=\"nameReferences\">" $cleanItem "</td>"
				;;
			2)
				echo -e "\t\t\t<td class=\"descriptionReferences\">" $cleanItem "</td>"
				;;
			3)
				echo -e "\t\t\t<td class=\"keywordsReferences\">" $cleanItem "</td>"
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
