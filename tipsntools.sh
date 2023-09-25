#!/bin/bash
#
#    MIT License
#    Copyright (c) 2016-2023 Pierre-Yves Lapersonne (Mail: dev@pylapersonne.info)
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
# Version.............: 14.1.0
# Since...............: 05/10/2016
# Description.........: Provides some features about this update/technical watch/... project: find some elements or build HTML files from CSV files to update another file
#
# Usage: bash tipsntools.sh {--help | --version |--count | --md5 | --sha1 | --update | --stats | --check | --full | {--findAll | --findWeb | --findTools | --findDevices | --findSocs} yourRegexp [--json | --csv]}
# Usage: bash tipsntools.sh {-h | -v | -c | -m | -s1 | -u | -st | -ch | -f | {-a | -w | -t | -d | -s } yourRegexp [-json | -csv] }
#

# Debug purposes
#set -euxo pipefail
set -euo pipefail

VERSION="15.0.0"

# ############# #
# CONFIGURATION #
# ############# #

# Some configuration things
UTILS_DIR="utils/core"
CSV2GLOBAL_SCRIPT="csvToGlobal.sh"
CSV2HTMLDEVICES_SCRIPT="csvToHtml_devices.sh"
CSV2HTMLWEBS_SCRIPT="csvToHtml_references.sh"
CSV2HTMLTOOLS_SCRIPT="csvToHtml_tools.sh"
CSV2HTMLSOCS_SCRIPT="csvToHtml_socs.sh"

# The folders and files about the libraries and tools
TOOLS_DIR="contents/toolz"
CSV_TOOLS_FILE="$TOOLS_DIR/Tips-n-tools_Tools.csv"
JSON_TOOLS_FILE="$TOOLS_DIR/Tips-n-tools_Tools.json"

# The folder and files about some publications, articles, blogs...
WEB_DIR="contents/webz"
CSV_WEBS_FILE="$WEB_DIR/Tips-n-tools_WebLinks.csv"
JSON_WEBS_FILE="$WEB_DIR/Tips-n-tools_WebLinks.json"

# The folder and files about the devices (smartphones, phablets, tablets, wearables, smartwatches...)
DEVICE_DIR="contents/devz"
CSV_DEVICES_FILE="$DEVICE_DIR/Tips-n-tools_Devices.csv"
JSON_DEVICES_FILE="$DEVICE_DIR/Tips-n-tools_Devices.json"

# The folder and files about the SoC
SOC_DIR="contents/socz"
CSV_SOC_FILE="$SOC_DIR/Tips-n-tools_SoC.csv"
JSON_SOC_FILE="$SOC_DIR/Tips-n-tools_SoC.json"

# The folder where the HTML pages (web app / pwa / spa and global page) are
BUILD_DIR="build"

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
# FUNCTIONS #
# ######### #

# \fn fUsageAndExit
# \brief Displays the usage and exits
fUsageAndExit(){
	echo "*********************"
	echo "Tips-n-tools (macOS) $VERSION"
	echo "*********************"
	echo "Feel free to get the version 14.3.3 for macOS usages"
	echo "USAGE:"
	echo "bash tipsntools.sh {--help | --version | --count | --md5 | sha1 | --update | --check | --stats | --full | {--findAll | --findWeb | --findTools | --findDevices | --findSocs} yourRegexp [--json | --csv]}"
	echo "bash tipsntools.sh {-h | -v | -c | -m | -s1 | -u | -ch | -st | -f | {-a | -w | -t | -d | -s} yourRegexp [-json | -csv]}"
	echo -e "\t --help (-h)......................: display the help, i.e. this usage"
	echo -e "\t --version (-v)...................: display the verison of this tool"
	echo -e "\t --count (-c).....................: count the number of items"
	echo -e "\t --md5 (-m).......................: compute the MD5 checksum"
	echo -e "\t --sha1 (-s)......................: compute the SHA1 checksum"
	echo -e "\t --update (-u) ...................: update the defined result file with HTML files built thanks to CSV files and scripts in .utils/ folder"
	echo -e "\t --check (-ch)....................: check for not found URL, i.e. not anymore reachable content (404 error code)"
	echo -e "\t --stats (-st)....................: compute some metrics about the subject or category of each row"
	echo -e "\t --full (-f)......................: get all the data, without filter, returns JSON objects"
	echo -e "\t --findAll (-a) yourRegexp........: find in all the CSV source files the rows which contain elements matching yourRegexp"
	echo -e "\t --findWeb (-w) yourRegexp........: find in the web links CSV source file the rows which contain elements matching yourRegexp"
	echo -e "\t --findTools (-t) yourRegexp......: find in the tools CSV source file the rows which contain elements matching yourRegexp"
	echo -e "\t --findDevices (-d) yourRegexp....: find in the devices CSV source file the rows which contain elements matching yourRegexp"
	echo -e "\t --findSocs (-s) yourRegexp.......: find in the SoC CSV source file the rows which contain elements matching yourRegexp"
	echo -e "\t --json (-json)...................: for 'find' commands, produce results in JSON format, not plain text"
	echo -e "\t --csv (-csv).....................: for 'find' commands, produce results in CSV format, not plain text"
	exit 0
}

# \fn fVersion
# \brief Displays the version of this tool
fVersion(){
	echo "Tips-n-Tools version $VERSION"
	exit 0
}

# \fn fUpdate
# \brief Updates the result file with HTML files built with CSV soruce files
fUpdate(){
	echo "*******************************"
	echo "* Updating destination files..."
	echo "*******************************"
	cd $UTILS_DIR
	sh $CSV2GLOBAL_SCRIPT
	cd ../..
}

# \fn errBadCommand
# \brief Displays an error message saying there is a bad command
errBadCommand(){
	echo "ERROR: Bad command, see help to use the script."
}

# \fn errBadCommandAndExit
# \brief Displays an error message saying there is a bad command and exists
errBadCommandandExit(){
	errBadCommand
	exit 1
}

# \fn errBadDirectory
# \param directory - The missing/bad directory
# \brief Displays an error message saying there is a bad/unexisting directory and exits
errBadDirectory(){
	echo "ERROR: The directory '$1' does not exist."
	exit 1
}

# \fn errBadFile
# \param file - The missing/bad file
# \brief Displays an error message saying there is a bad/unexisting file and exits
errBadFile(){
	echo "ERROR: The file '$1' does not exist."
	exit 1
}

# \fn fGetFullData
# \brief Get all the stored data in the project (tools, webs, devices and SoCs) without filtering anything
# To do so will process only the JSON data.
fGetFullData(){
	# Prepare...
	tempFileForAll="./.results-all.tmp.json"
	touch $tempFileForAll
	echo "["  > $tempFileForAll
	cat $JSON_TOOLS_FILE >> $tempFileForAll
	echo "," >> $tempFileForAll
	cat $JSON_WEBS_FILE >> $tempFileForAll
	echo "," >> $tempFileForAll
	cat $JSON_DEVICES_FILE >> $tempFileForAll
	echo "," >> $tempFileForAll
	cat $JSON_SOC_FILE >> $tempFileForAll
	echo "]" >> $tempFileForAll
	# Clean up
	cat $tempFileForAll
	rm $tempFileForAll
}

# \fn fFindInAllCsvFiles
# \param regexp - The regex to use
# \brief Finds in CSV source files some items
fFindInAllCsvFiles(){
	echo "**********************************"
	echo "* Find in all CSV files for '$1'..."
	echo "*********************************"
	regex=$1
	# The tools file
	fFindInCsvFile $CSV_TOOLS_FILE $regex
	# The web things file
	fFindInCsvFile $CSV_WEBS_FILE $regex
	# The devices file
	fFindInCsvFile $CSV_DEVICES_FILE $regex
	# The SoC file
	fFindInCsvFile $CSV_SOC_FILE $regex
	echo "End of search."
}

# \fn fFindInAllJsonFiles
# \param regexp - The regex to use
# \brief Finds in JSON source files some items
fFindInAllJsonFiles(){
	# Prepare...
	regex=$1
	tempFileForAll="./.results-all.tmp.json"
	touch $tempFileForAll
	echo "["  > $tempFileForAll
	# The tools file
	fFindInJsonFile $JSON_TOOLS_FILE $regex  >> $tempFileForAll
	echo "," >> $tempFileForAll
	# The web things file
	fFindInJsonFile $JSON_WEBS_FILE $regex >> $tempFileForAll
	echo "," >> $tempFileForAll
	# The devices file
	fFindInJsonFile $JSON_DEVICES_FILE $regex >> $tempFileForAll
	echo "," >> $tempFileForAll
	# The SoC file
	fFindInJsonFile $JSON_SOC_FILE $regex >> $tempFileForAll
	echo "]" >> $tempFileForAll
	# Clean up
	cat $tempFileForAll
	rm $tempFileForAll
}

# \fn fFindInCsvFile
# \param file - The file to use
# \param regex - The regex to use
# \brief Find a dedicated CSV file items wich match the regex
fFindInCsvFile(){
	echo "****************************"
	echo "* Find in '$1' for '$2'..."
	echo "****************************"
	file=$1
	regex=$2
	cat $file | while read -r line; do
		case "$line" in
			*$regex*)
			if [ $(DoesRunOnGNULinux) == "yes" ]; then # GNU/Linux
				regex="s/;/\'$'\n/g"
			else # macOS
				regex="s/;/\'$'\n/g"
			fi
			echo $line | sed $regex | while read -r item; do
				if [ "$item" = "" ]; then
					echo -e "\t <null>"
				else						
					echo -e "\t" $item
				fi
			done
			echo -e "\n"
			;;
			*)
			;;
		esac
	done
}

# \fn fFindInJsonFile
# \param file - The file to use
# \param regex - The regex to use
# \brief Find in dedicated JSON file items which match the regex
# WARNING: Not working on macOS, truncate command is not available. Love apples.
fFindInJsonFile(){
	file=$1
	regex=$2
	tempFile="./.results.temp.json"
	touch $tempFile
	currentRowIndex=0
	echo "[" > $tempFile
	cat $file | while read -r line; do
		case "$line" in
			*$regex*)
				echo "$line" >> $tempFile
				currentRowIndex=$(($currentRowIndex + 1))
				truncate -s -1 $tempFile # Remove last polluting symbol, useless for last JSON item
			;;
			*)
			;;
		esac
	done
	truncate -s -1 $tempFile
	echo -e "\n]" >> $tempFile
	cat $tempFile
	rm $tempFile
}

# \fn fMd5sum
# \brief Make an MD5 checksum for each file and display them in the standard ouput
# WARNING: For GNU/Linux, the command is 'md5sum', for macOS the command is 'md5'
fMd5sum(){
	echo "******************"
	echo "* MD5 checksums..."
	echo "******************"
	# Utils folder...
	echo -e "\tMD5 checksum for .sh files:\\n`md5 utils/core/*.sh`"
	# CSV files
	echo -e "\tMD5 checksum for .csv files:\\n`md5 contents/*/*.csv`"
	# HTML files
	echo -e "\tMD5 checksum for .html files:\\n`md5 contents/*/*.html`"
	# JSON files
	echo -e "\tMD5 checksum for .json files:\\n`md5 contents/*/*.json`"
	# Assets files
	echo -e "\tMD5 checksum for pictures:\\n`md5 utils/web/webapp/pictures/*`"
	echo -e "\tMD5 checksum for stylesheets:\\n`md5 utils/web/webapp/styles/*`"
	echo -e "\tMD5 checksum for JavaScript glue:\\n`md5 utils/web/webapp/logic/*`"
	echo -e "\tMD5 checksum for HTML patterns:\\n`md5 utils/web/webapp/patterns/*`"
	# Main script, readme file and sheet file
	echo -e "\tMD5 checksum for main files:\\n`md5 *.*`"
}

# \fn fSha1sum
# \brief Make a SHA1 checksum for each file and display them in the standard ouput
# WARNING: For GNU/Linux, the command is 'sha1sum', for macOS the command is 'shasum'
fSha1sum(){
	echo "*******************"
	echo "* SHA1 checksums..."
	echo "*******************"
	# Utils folder...
	echo -e "\tSHA1 checksum for .sh files:\\n`shasum utils/core/*.sh`"
	# CSV files
	echo -e "\tSHA1 checksum for .csv files:\\n`shasum contents/*/*.csv`"
	# HTML files
	echo -e "\tSHA1 checksum for .html files:\\n`shasum contents/*/*.html`"
	# JSON files
	echo -e "\tSHA1 checksum for .json files:\\n`shasum contents/*/*.json`"
	# Assets files
	echo -e "\tSHA1 checksum for pictures:\\n`shasum utils/web/webapp/pictures/*`"
	echo -e "\tSHA1 checksum for stylesheets:\\n`shasum utils/web/webapp/styles/*`"
	echo -e "\tSHA1 checksum for JavaScript glue:\\n`shasum utils/web/webapp/logic/*`"
	echo -e "\tSHA1 checksum for HTML patterns:\\n`shasum utils/web/webapp/patterns/*`"
	# Main script, readme file and sheet file
	echo -e "\tSHA1 checksum for main files:\\n`shasum *.*`"
}

# \fn fCountItems
# \brief Computes the number of items listed in each CSV file
fCountItems(){

	# Files and constants
	CSV_TOOLS_FILE_USELESS_ROWS=6
	HTML_TOOLS_FILE="$TOOLS_DIR/Tips-n-tools_Tools.html"
	CSV_WEB_FILE_USELESS_ROWS=6
	HTML_WEB_FILE="$WEB_DIR/Tips-n-tools_WebLinks.html"
	CSV_DEVICES_FILE_USELESS_ROWS=6
	HTML_DEVICES_FILE="$DEVICE_DIR/Tips-n-tools_Devices.html"
	CSV_SOC_FILE_USELESS_ROWS=6
	HTML_SOC_FILE="$SOC_DIR/Tips-n-tools_SoC.html"

	# Count in CSV file
	if [ -f $CSV_TOOLS_FILE ]; then
		csvToolsRows=`cat $CSV_TOOLS_FILE | wc -l`
		csvToolsRowsCleaned=$(($csvToolsRows - $CSV_TOOLS_FILE_USELESS_ROWS))
		echo "Items as TOOLS..........: $csvToolsRowsCleaned items in $CSV_TOOLS_FILE"
	else
		echo "WARNING: $CSV_TOOLS_FILE does not exist"
	fi
	if [ -f $CSV_WEBS_FILE ]; then
		csvWebRows=`cat $CSV_WEBS_FILE | wc -l`
		csvWebRowsCleaned=$(($csvWebRows - $CSV_WEB_FILE_USELESS_ROWS))
		echo "Items as WEB THINGS.....: $csvWebRowsCleaned items in $CSV_WEBS_FILE"
	else
		echo "WARNING: $CSV_WEBS_FILE does not exist"
	fi
	if [ -f $CSV_DEVICES_FILE ]; then
		csvDevicesRows=`cat $CSV_DEVICES_FILE | wc -l`
		csvDevicesRowsCleaned=$(($csvDevicesRows - $CSV_DEVICES_FILE_USELESS_ROWS))
		echo "Items in DEVICES........: $csvDevicesRowsCleaned items in $CSV_DEVICES_FILE"
	else
		echo "WARNING: $CSV_DEVICES_FILE does not exist"
	fi
	if [ -f $CSV_SOC_FILE ]; then
		csvSoczRows=`cat $CSV_SOC_FILE | wc -l`
		csvSoczRowsCleaned=$(($csvSoczRows - $CSV_SOC_FILE_USELESS_ROWS))
		echo "Items in SoC............: $csvSoczRowsCleaned items in $CSV_SOC_FILE"
	else
		echo "WARNING: $CSV_SOC_FILE does not exist"
	fi
	
}

# \fn fCheckForNotFound
# \brief Checks in all URL if there are dead / ghost URL with 404 error code (i.e. not anymore reachable content)
# \param file - The file to parse, ion CSV format, using ';' as separator
fCheckForNotFound(){

	if [ "$#" -ne 1 ]; then
		echo "ERROR: Bad number of parameters, you must give 1 file in CSV-;-as-separator format"
		exit 1
	fi

	fileName="$1"

	code000=0
	code1xx=0
	code2xx=0
	code3xx=0
	code4xx=0
	code5xx=0
	checkedUrls=0
	notUrlObject=0;

	DIFF=6 # There are $DIFF useless rows in base ODT file, so if a CSV line is not convenient, if may be the line+DIFF rows in the ODT file
	cpt=$DIFF

	echo "This operation can take a lot of time..."

	# Processing URL in tools
	echo "Processing $fileName..."
	urlsToTest=`cat $fileName | awk -F ';' '{print $5}'`

	# While loop runs in sub-shell, so modified variables will lost their new states once the sub-shell of the loop exits
	# Thus the URL to test parsed with sed will be injected with <<<
	if [ $(DoesRunOnGNULinux) == "yes" ]; then # GNU/Linux
		regex="s/ /\n/g"
	else # macOS
		regex="s/ /\'$'\n/g"
	fi
	parsedUrlToTest=`echo $urlsToTest | sed $regex`
	while read item; do
		#echo "Checking item at rank $cpt: $item..."
		httpStatus=`curl --write-out '%{http_code}' --silent --output /dev/null $item` # Deal with failed CURL commands
		if [ "$httpStatus" == "000" ]; then
			echo "The line $cpt has a URL ($item) returning undefined HTTP status code"
			code5xx=$((code000+1))
		else		
			if [ "$httpStatus" ]; then
				checkedUrls=$((checkedUrls+1))
				if [ "$httpStatus" -ge 100 -a "$httpStatus" -le 199 ]; then
					code1xx=$((code1xx+1))
				elif [ "$httpStatus" -ge 200 -a "$httpStatus" -le 299 ]; then
					code2xx=$((code2xx+1))
				elif [ "$httpStatus" -ge 300 -a "$httpStatus" -le 399 ]; then
					code3xx=$((code3xx+1))
				elif [ "$httpStatus" -ge 400 -a "$httpStatus" -le 499 ]; then
					code4xx=$((code4xx+1))
					if [ "$httpStatus" -eq "404" ]; then
						echo "The line $cpt has a URL ($item) returning $httpStatus HTTP status code"
					fi
				elif [ "$httpStatus" -ge "500" -a "$httpStatus" -le "599" ]; then
					echo "The line $cpt has a URL ($item) returning $httpStatus HTTP status code"
					code5xx=$((code5xx+1))
				else
					echo "WARNING: What is this HTTP status code (O_o)\" $httpStatus"
				fi
			else
				echo "WARNING: It seems it is not a URL at row $cpt: \"$item\""
				notUrlObject=$((notUrlObject+1))
			fi
		fi
		cpt=$((cpt+1))
		# Display a message each 50 items to say to the user the task is still running
		if [ "$((cpt%50))" -eq "0" ]; then
			echo "Task still running... $cpt items checked"
		fi
	done <<< "$(echo "$parsedUrlToTest")"

	# Some metrics
	echo "NOTE: For file $fileName - HTTP 1xx status: $code1xx"
	echo "NOTE: For file $fileName - HTTP 2xx status: $code2xx"
	echo "NOTE: For file $fileName - HTTP 3xx status: $code3xx"
	echo "NOTE: For file $fileName - HTTP 4xx status: $code4xx"
	echo "NOTE: For file $fileName - HTTP 5xx status: $code5xx"

}

# \fn fComputeMetrics
# \brief Compute metrics about cattegories in use (i.e. first column of each .CSV file)
# \param file - The CSV file to process, its 1st column will be the counted element
fComputeMetrics(){

	if [ "$#" -ne 1 ]; then
		echo "ERROR: Bad number of parameters, you must give 1 file in CSV-;-as-separator format"
		exit 1
	fi

	fileName="$1"

	DIFF=7 # There are $DIFF useless rows in base ODT file, so if a CSV line is not convenient, if may be the line+DIFF rows in the ODT file

	echo "Processing $fileName..."
	categoriesToCompute=`cat $fileName | tail -n +$DIFF | awk -F ';' '{print $1 }' | sort | uniq -c | sort -nr`
	echo "$categoriesToCompute"

}


# ######### #
# MAIN CODE #
# ######### #

# Check the args and display usage if needed
if [ "$#" -lt 1 -o "$#" -gt 3 ]; then
	fUsageAndExit
# Need some help?
elif [ "$1" = "--help" -o "$1" = "-h" ]; then
		fUsageAndExit
fi

# Check id the directories containing the data and the script exist
if [ ! -d "$UTILS_DIR" ]; then
	errBadDirectory $UTILS_DIR
fi

if [ ! -d "$TOOLS_DIR" ]; then
	errBadDirectory $TOOLS_DIR
fi

if [ ! -d "$WEB_DIR" ]; then
	errBadDirectory $WEB_DIR
fi

if [ ! -d "$DEVICE_DIR" ]; then
	errBadDirectory $DEVICE_DIR
fi

if [ ! -d "$SOC_DIR" ]; then
	errBadDirectory $SOC_DIR
fi

# Check if all the files to use exist
if [ ! -e "$CSV_TOOLS_FILE" ]; then
	errBadFile $CSV_TOOLS_FILE
fi

if [ ! -e "$CSV_WEBS_FILE" ]; then
	errBadFile $CSV_WEBS_FILE
fi

if [ ! -e "$CSV_DEVICES_FILE" ]; then
	errBadFile $CSV_DEVICES_FILE
fi

if [ ! -e "$CSV_SOC_FILE" ]; then
	errBadFile $CSV_SOC_FILE
fi

if [ ! -e "$UTILS_DIR/$CSV2GLOBAL_SCRIPT" ]; then
	errBadFile "$UTILS_DIR/$CSV2GLOBAL_SCRIPT"
fi

# Let's work !
if [ $1 ]; then
# FIXME Cyclomatic number of McCabe is burning...
	# Get the version
	if [ "$1" = "--version" -o "$1" = "-v" ]; then
		if [ "$#" -ne 1 ]; then
			errBadCommand
			fUsageAndExit
		else
			fVersion
		fi
	# Update the output files and web contents?
	elif [ "$1" = "--update" -o "$1" = "-u" ]; then
		if [ "$#" -ne 1 ]; then
			errBadCommand
			fUsageAndExit
		else
			START_DATE=`date +"%s"`
			fUpdate
			END_DATE=`date +"%s"`
			DURATION=$(( END_DATE - START_DATE ))
			echo "Update done during $DURATION seconds"
		fi
	# Get all the data?
elif [ "$1" = "--full" -o "$1" = "-f" ]; then
		if [ "$#" -gt 2 ]; then
			errBadCommand
			fUsageAndExit
		else
			fGetFullData
		fi
	# Find some data in all files?
	elif [ "$1" = "--findAll" -o "$1" = "-a" ]; then
		if [ "$#" -ne 3 ]; then
			errBadCommand
			fUsageAndExit
		fi
		regexp="$2"
		if [ "$3" = "--json" -o "$3" = "-json" ]; then
			fFindInAllJsonFiles $regexp
		elif [ "$3" = "--csv" -o "$3" = "-csv" ]; then
			fFindInAllCsvFiles $regexp
		else
			errBadCommand
			fUsageAndExit
		fi
	# Find some data in web file?
	elif [ "$1" = "--findWeb" -o "$1" = "-w" ]; then
		if [ "$2" ]; then
			regexp="$2"
			if [ "$3" = "--json" -o "$3" = "-json" ]; then
				fFindInJsonFile $JSON_WEBS_FILE $regexp
			else
				fFindInCsvFile $CSV_WEBS_FILE $regexp
			fi
		else
			errBadCommand
			fUsageAndExit
		fi
	# Find some data in the tools file?
	elif [ "$1" = "--findTools" -o "$1" = "-t" ]; then
		if [ "$2" ]; then
			regexp="$2"
			if [ "$3" = "--json" -o "$3" = "-json" ]; then
				fFindInJsonFile $JSON_TOOLS_FILE $regexp
			else
				fFindInCsvFile $CSV_TOOLS_FILE $regexp
			fi
		else
			errBadCommand
			fUsageAndExit
		fi
	# Find some data in devices file?
	elif [ "$1" = "--findDevices" -o "$1" = "-d" ]; then
		if [ "$2" ]; then
			regexp="$2"
			if [ "$3" = "--json" -o "$3" = "-json" ]; then
				fFindInJsonFile $JSON_DEVICES_FILE $regexp
			else
				fFindInCsvFile $CSV_DEVICES_FILE $regexp
			fi
		else
			errBadCommand
			fUsageAndExit
		fi
	# Find some data in SoC file?
	elif [ "$1" = "--findSocs" -o "$1" = "-s" ]; then
		if [ "$2" ]; then
			regexp="$2"
			if [ "$3" = "--json" -o "$3" = "-json" ]; then
				fFindInJsonFile $JSON_SOC_FILE $regexp
			else
				fFindInCsvFile $CSV_SOC_FILE $regexp
			fi
		else
			errBadCommand
			fUsageAndExit
		fi
	# Need some help?
	elif [ "$1" = "--help" -o "$1" = "-h" ]; then
		fUsageAndExit
	# Compute MD5 checksums
	elif [ "$1" = "--md5" -o "$1" = "-m" ]; then
		if [ "$#" -ne 1 ]; then
			errBadCommand
			fUsageAndExit
		else
			fMd5sum
		fi
	# Compute SHA1 checksums
	elif [ "$1" = "--sha1" -o "$1" = "-s1" ]; then
			if [ "$#" -ne 1 ]; then
				errBadCommand
				fUsageAndExit
			else
				fSha1sum
			fi
	# Compute the number of items in each file
	elif [ "$1" = "--count" -o "$1" = "-c" ]; then
		if [ "$#" -ne 1 ]; then
			errBadCommand
			fUsageAndExit
		else
			fCountItems
		fi
	# Check for not found URL / not anymore reachable content
	elif [ "$1" = "--check" -o "$1" = "-ch" ]; then
		if [ "$#" -ne 1 ]; then
			errBadCommand
			fUsageAndExit
		else
			startTime=`date +%s`
			fCheckForNotFound $CSV_TOOLS_FILE
			fCheckForNotFound $CSV_WEBS_FILE
			endTime=`date +%s`
			echo "Check process done in $((endTime-startTime)) seconds"
		fi
	# Compute metrics about the category for each row
	elif [ "$1" = "--stats" -o "$1" = "-st" ]; then
		if [ "$#" -ne 1 ]; then
			errBadCommand
			fUsageAndExit
		else
			fComputeMetrics $CSV_TOOLS_FILE
			fComputeMetrics $CSV_WEBS_FILE
			fComputeMetrics $CSV_DEVICES_FILE
			fComputeMetrics $CSV_SOC_FILE
		fi
	# Stop jumping on your keyboard...
	else
		errBadCommand
		fUsageAndExit
	fi
else
	fUsageAndExit
fi