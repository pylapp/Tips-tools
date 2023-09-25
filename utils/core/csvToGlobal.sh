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
# Version.............: 14.0.0
# Since...............: 28/09/2017
# Description.........: Parses the CSV files (previously generated from the ODS file) to HTML and JSON files,
#	and concatenate them to the global web page file, and update the web app.
#
# Usage: bash csvToGlobal.sh
#

# Debug purposses
#set -euxo pipefail
set -euo pipefail

# ############# #
# CONFIGURATION #
# ############# #

# The build folder
BUILD_FOLDER="../../build"
# The Progressive Web App / Single Page App
BUILD_WEBAPP_GLOBAL_FILE="$BUILD_FOLDER/webapp.html"
# A global web page, more simple, less user-friendly
BUILD_WEBPAGE_GLOBAL_FILE="$BUILD_FOLDER/webpage.html"

# Some configuration things
UTILS_FOLDER=".";
CSV2HTML_TOOLS_SCRIPT="$UTILS_FOLDER/csvToHtml_tools.sh"
CSV2JSON_TOOLS_SCRIPT="$UTILS_FOLDER/csvToJson_tools.sh"
CSV2HTML_WEBS_SCRIPT="$UTILS_FOLDER/csvToHtml_references.sh"
CSV2JSON_WEBS_SCRIPT="$UTILS_FOLDER/csvToJson_references.sh"
CSV2HTML_DEVICES_SCRIPT="$UTILS_FOLDER/csvToHtml_devices.sh"
CSV2JSON_DEVICES_SCRIPT="$UTILS_FOLDER/csvToJson_devices.sh"
CSV2HTML_SOCS_SCRIPT="$UTILS_FOLDER/csvToHtml_socs.sh"
CSV2JSON_SOCS_SCRIPT="$UTILS_FOLDER/csvToJson_socs.sh"

# Some metedata
CONTENT_DIR="../../contents"
META_DATA_FILE="$CONTENT_DIR/metadata.json"

# The folders and files about the libraries and tools
TOOLS_DIR="$CONTENT_DIR/toolz"
CSV_TOOLS_FILE="$TOOLS_DIR/Tips-n-tools_Tools.csv"
CSV_TOOLS_FILE_USELESS_ROWS=6
JSON_TOOLS_FILE="$TOOLS_DIR/Tips-n-tools_Tools.json"
HTML_TOOLS_FILE="$TOOLS_DIR/Tips-n-tools_Tools.html"

# The folder and files about some publications, articles, blogs...
WEB_DIR="$CONTENT_DIR/webz"
CSV_WEB_FILE="$WEB_DIR/Tips-n-tools_WebLinks.csv"
CSV_WEB_FILE_USELESS_ROWS=6
JSON_WEB_FILE="$WEB_DIR/Tips-n-tools_WebLinks.json"
HTML_WEB_FILE="$WEB_DIR/Tips-n-tools_WebLinks.html"

# The folder and files about the devices (smartphones, phablets, tablets, wearables, smartwatches...)
DEVICE_DIR="$CONTENT_DIR/devz"
CSV_DEVICE_FILE="$DEVICE_DIR/Tips-n-tools_Devices.csv"
CSV_DEVICE_FILE_USELESS_ROWS=6
JSON_DEVICE_FILE="$DEVICE_DIR/Tips-n-tools_Devices.json"
HTML_DEVICE_FILE="$DEVICE_DIR/Tips-n-tools_Devices.html"

# The folder and files about the SoC
SOC_DIR="$CONTENT_DIR/socz"
CSV_SOC_FILE="$SOC_DIR/Tips-n-tools_SoC.csv"
CSV_SOC_FILE_USELESS_ROWS=6
JSON_SOC_FILE="$SOC_DIR/Tips-n-tools_SoC.json"
HTML_SOC_FILE="$SOC_DIR/Tips-n-tools_SoC.html"

WEBCLIENTS_ASSETS="../web"

# Some references to assets to include to other file(s): for the Progressive Web App
WEBAPP_ASSETS_FOLDER="$WEBCLIENTS_ASSETS/webapp"
WEBAPP_ASSETS_HTML_BEGIN="$WEBAPP_ASSETS_FOLDER/patterns/begin.html"
WEBAPP_ASSETS_HTML_LINKS="$WEBAPP_ASSETS_FOLDER/patterns/includes.html"
WEBAPP_ASSETS_HTML_HEADER="$WEBAPP_ASSETS_FOLDER/patterns/header.html"
WEBAPP_ASSETS_HTML_NAVIGATION="$WEBAPP_ASSETS_FOLDER/patterns/navigationButtons.html"
WEBAPP_ASSETS_HTML_TABLES="$WEBAPP_ASSETS_FOLDER/patterns/tables.html"
WEBAPP_ASSETS_HTML_END="$WEBAPP_ASSETS_FOLDER/patterns/end.html"

# Some references to assets to include to other file(s): for the Simple Web Page
WEBPAGE_ASSETS_FOLDER="$WEBCLIENTS_ASSETS/webpage"
WEBPAGE_ASSETS_HTML_BEGIN="$WEBPAGE_ASSETS_FOLDER/patterns/begin.html"
WEBPAGE_ASSETS_HTML_LINKS="$WEBPAGE_ASSETS_FOLDER/patterns/includes.html"
WEBPAGE_ASSETS_HTML_HEADER="$WEBPAGE_ASSETS_FOLDER/patterns/header.html"
WEBPAGE_ASSETS_HTML_NAVIGATION="$WEBPAGE_ASSETS_FOLDER/patterns/navigationButtons.html"
WEBPAGE_ASSETS_HTML_END="$WEBPAGE_ASSETS_FOLDER/patterns/end.html"

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

# ##########################################
# Check the args and display usage if needed
# ##########################################

if [ "$#" -ne 0 ]; then
	echo "USAGE: bash csvToGlobal.sh"
	exit 0
fi

# ############################
# Create directories if needed
# ############################

if [ ! -d "$TOOLS_DIR" ]; then
	echo "Create directory '$TOOLS_DIR' for libraries, tools and frameworks things..."
	mkdir $TOOLS_DIR
else
	echo "NOTE: Directory '$TOOLS_DIR' already created"
fi

if [ ! -d "$WEB_DIR" ]; then
	echo "Create directory '$WEB_DIR' for web things..."
	mkdir $WEB_DIR
else
	echo "NOTE: Directory '$WEB_DIR' already created"
fi

if [ ! -d "$DEVICE_DIR" ]; then
	echo "Create directory '$DEVICE_DIR' for devices things..."
	mkdir $DEVICE_DIR
else
	echo "NOTE: Directory '$DEVICE_DIR' already created"
fi

if [ ! -d "$SOC_DIR" ]; then
	echo "Create directory '$SOC_DIR' for SoC things..."
	mkdir $DEVICE_DIR
else
	echo "NOTE: Directory '$SOC_DIR' already created"
fi

# #######################################
# Check if all the CSV files to use exist
# #######################################

echo "Check if all the CSV files exist..."

if [ ! -e "$CSV_TOOLS_FILE" ]; then
	echo "ERROR: The file '$CSV_TOOLS_FILE' does not exist. Impossible to parse it to HTML. Exit now."
	exit 1;
fi

if [ ! -e "$CSV_WEB_FILE" ]; then
	echo "ERROR: The file '$CSV_WEB_FILE' does not exist. Impossible to parse it to HTML. Exit now."
	exit 1;
fi

if [ ! -e "$CSV_DEVICE_FILE" ]; then
	echo "ERROR: The file '$CSV_DEVICE_FILE' does not exist. Impossible to parse it to HTML. Exit now."
	exit 1;
fi

if [ ! -e "$CSV_SOC_FILE" ]; then
	echo "ERROR: The file '$CSV_SOC_FILE' does not exist. Impossible to parse it to HTML. Exit now."
	exit 1;
fi

# ##############################################
# Get some stats to compare with new stats later
# ##############################################

# HTML

echo "Prepare metrics for HTML contents..."

if [ -e $HTML_TOOLS_FILE ]; then
	htmlToolsRowsOld=`cat $HTML_TOOLS_FILE | wc -l`
else
	htmlToolsRowsOld=0
fi

if [ -e $HTML_WEB_FILE ]; then
	htmlWebRowsOld=`cat $HTML_WEB_FILE | wc -l`
else
	htmlWebRowsOld=0
fi

if [ -e $HTML_DEVICE_FILE ]; then
	htmlDevicesRowsOld=`cat $HTML_DEVICE_FILE | wc -l`
else
	htmlDevicesRowsOld=0
fi

if [ -e $HTML_SOC_FILE ]; then
	htmlSocsRowsOld=`cat $HTML_SOC_FILE | wc -l`
else
	htmlSocsRowsOld=0
fi

# JSON

echo "Prepare metrics for JSON contents..."

if [ -e $JSON_TOOLS_FILE ]; then
	jsonToolsRowsOld=`cat $JSON_TOOLS_FILE | wc -l`
else
	jsonToolsRowsOld=0
fi

if [ -e $JSON_WEB_FILE ]; then
	jsonWebRowsOld=`cat $JSON_WEB_FILE | wc -l`
else
	jsonWebRowsOld=0
fi

if [ -e $JSON_DEVICE_FILE ]; then
	jsonDevicesRowsOld=`cat $JSON_DEVICE_FILE | wc -l`
else
	jsonDevicesRowsOld=0
fi

if [ -e $JSON_SOC_FILE ]; then
	jsonSocsRowsOld=`cat $JSON_SOC_FILE | wc -l`
else
	jsonSocsRowsOld=0
fi

# #############################
# Update files related to tools
# #############################

echo "Dealing with tools..."
if [ $(DoesRunOnGNULinux) == "yes" ]; then # GNU/Linux
	COMPUTED_CHECKSUM_CSV_TOOLZ_FILE=`md5sum $CSV_TOOLS_FILE | awk '{ print $1}'`
else # macOS
	COMPUTED_CHECKSUM_CSV_TOOLZ_FILE=`md5 $CSV_TOOLS_FILE | awk '{ print $4 }'`
fi

if [ -e $META_DATA_FILE ]; then

	STORED_CHECKSUM_CSV_TOOLZ_FILE=`cat $META_DATA_FILE | grep checksumTools | awk '{ print $2 }' | tr -d '",'`

	echo "Dealing with checksums ($STORED_CHECKSUM_CSV_TOOLZ_FILE,$COMPUTED_CHECKSUM_CSV_TOOLZ_FILE) (stored, computed)"
	if [ $STORED_CHECKSUM_CSV_TOOLZ_FILE != $COMPUTED_CHECKSUM_CSV_TOOLZ_FILE ]; then
		echo "Checksums are not the same, we need to generated new files"
		echo "Write HTML file from CSV file about libraries, frameworks and tools..."
		cat $CSV_TOOLS_FILE | bash $CSV2HTML_TOOLS_SCRIPT > $HTML_TOOLS_FILE
		echo "Write JSON file from CSV file about libraries, frameworks and tools..."
		cat $CSV_TOOLS_FILE | bash $CSV2JSON_TOOLS_SCRIPT > $JSON_TOOLS_FILE
	else
		echo "Checksums are the same, no update needed"
	fi

else
	echo "WARNING: metadata file does not exist or has been removed. Will update files..."
	echo "Generating HTML content..."
	cat $CSV_TOOLS_FILE | bash $CSV2HTML_TOOLS_SCRIPT > $HTML_TOOLS_FILE
	echo "Generating JSON content..."
	cat $CSV_TOOLS_FILE | bash $CSV2JSON_TOOLS_SCRIPT > $JSON_TOOLS_FILE
fi


# ##################################
# Update files related to references
# ##################################

echo "Dealing with web references..."
if [ $(DoesRunOnGNULinux) == "yes" ]; then # GNU/Linux
	COMPUTED_CHECKSUM_CSV_WEBZ_FILE=`md5sum $CSV_WEB_FILE | awk '{ print $1}'`
else # macOS
	COMPUTED_CHECKSUM_CSV_WEBZ_FILE=`md5 $CSV_WEB_FILE | awk '{ print $4 }'`
fi

if [ -e $META_DATA_FILE ]; then

	STORED_CHECKSUM_CSV_WEBZ_FILE=`cat $META_DATA_FILE | grep checksumWeb | awk '{ print $2 }' | tr -d '",'`

	echo "Dealing with checksums ($STORED_CHECKSUM_CSV_WEBZ_FILE,$COMPUTED_CHECKSUM_CSV_WEBZ_FILE) (stored, computed)"
	if [ $STORED_CHECKSUM_CSV_WEBZ_FILE != $COMPUTED_CHECKSUM_CSV_WEBZ_FILE ]; then
		echo "Checksums are not the same, we need to generated new files"
		echo "Write HTML file from CSV file about web links..."
		cat $CSV_WEB_FILE | bash $CSV2HTML_WEBS_SCRIPT > $HTML_WEB_FILE
		echo "Write JSON file from CSV file about web links..."
		cat $CSV_WEB_FILE | bash $CSV2JSON_WEBS_SCRIPT > $JSON_WEB_FILE
	else
		echo "Checksums are the same, no update needed"
	fi

else
	echo "WARNING: metadata file does not exist or has been removed. Will update files..."
	echo "Generating HTML content..."
	cat $CSV_WEB_FILE | bash $CSV2HTML_WEBS_SCRIPT > $HTML_WEB_FILE
	echo "Generating JSON content..."
	cat $CSV_WEB_FILE | bash $CSV2JSON_WEBS_SCRIPT > $JSON_WEB_FILE
fi

# ###############################
# Update files related to devices
# ###############################

echo "Dealing with devices..."
if [ $(DoesRunOnGNULinux) == "yes" ]; then # GNU/Linux
	COMPUTED_CHECKSUM_CSV_DEVZ_FILE=`md5sum $CSV_DEVICE_FILE | awk '{ print $1}'`
else # macOS
	COMPUTED_CHECKSUM_CSV_DEVZ_FILE=`md5 $CSV_DEVICE_FILE | awk '{ print $4 }'`
fi

if [ -e $META_DATA_FILE ]; then

	STORED_CHECKSUM_CSV_DEVZ_FILE=`cat $META_DATA_FILE | grep checksumDevices | awk '{ print $2 }' | tr -d '",'`

	echo "Dealing with checksums ($STORED_CHECKSUM_CSV_DEVZ_FILE,$COMPUTED_CHECKSUM_CSV_DEVZ_FILE) (stored, computed)"
	if [ $STORED_CHECKSUM_CSV_DEVZ_FILE != $COMPUTED_CHECKSUM_CSV_DEVZ_FILE ]; then
		echo "Checksums are not the same, we need to generated new files"
		echo "Write HTML file from CSV file about devices..."
		cat $CSV_DEVICE_FILE | bash $CSV2HTML_DEVICES_SCRIPT > $HTML_DEVICE_FILE
		echo "Write JSON file from CSV file about devices..."
		cat $CSV_DEVICE_FILE | bash $CSV2JSON_DEVICES_SCRIPT > $JSON_DEVICE_FILE
	else
		echo "Checksums are the same, no update needed"
	fi

else
	echo "WARNING: metadata file does not exist or has been removed. Will update files..."
	echo "Generating HTML content..."
	cat $CSV_DEVICE_FILE | bash $CSV2HTML_DEVICES_SCRIPT > $HTML_DEVICE_FILE
	echo "Generating JSON content..."
	cat $CSV_DEVICE_FILE | bash $CSV2JSON_DEVICES_SCRIPT > $JSON_DEVICE_FILE
fi


# ###########################
# Update files related to SoC
# ###########################

echo "Dealing with SoC..."
if [ $(DoesRunOnGNULinux) == "yes" ]; then # GNU/Linux
	COMPUTED_CHECKSUM_CSV_SOCZ_FILE=`md5sum $CSV_SOC_FILE | awk '{ print $1}'`
else # macOS
	COMPUTED_CHECKSUM_CSV_SOCZ_FILE=`md5 $CSV_SOC_FILE | awk '{ print $4 }'`
fi

if [ -e $META_DATA_FILE ]; then

	STORED_CHECKSUM_CSV_SOCZ_FILE=`cat $META_DATA_FILE | grep checksumSocs | awk '{ print $2 }' | tr -d '",'`

	echo "Dealing with checksums ($STORED_CHECKSUM_CSV_SOCZ_FILE,$COMPUTED_CHECKSUM_CSV_SOCZ_FILE) (stored, computed)"
	if [ $STORED_CHECKSUM_CSV_SOCZ_FILE != $COMPUTED_CHECKSUM_CSV_SOCZ_FILE ]; then
		echo "Checksums are not the same, we need to generated new files"
		echo "Write HTML file from CSV file about SoC..."
		cat $CSV_SOC_FILE | bash $CSV2HTML_SOCS_SCRIPT > $HTML_SOC_FILE
		echo "Write JSON file from CSV file about SoC..."
		cat $CSV_SOC_FILE | bash $CSV2JSON_SOCS_SCRIPT > $JSON_SOC_FILE
	else
		echo "Checksums are the same, no update needed"
	fi

else
	echo "WARNING: metadata file does not exist or has been removed. Will update files..."
	echo "Generating HTML content..."
	cat $CSV_SOC_FILE | bash $CSV2HTML_SOCS_SCRIPT > $HTML_SOC_FILE
	echo "Generating JSON content..."
	cat $CSV_SOC_FILE | bash $CSV2JSON_SOCS_SCRIPT > $JSON_SOC_FILE
fi

# ########
# Clean up
# ########

if [ -d $BUILD_FOLDER ]; then
	echo "Clean build folder $BUILD_FOLDER..."
	rm -rf $BUILD_FOLDER
fi
local=`pwd`
echo "Creating build folder $BUILD_FOLDER in $local"
mkdir $BUILD_FOLDER

# ###################
# Prepare web clients
# ###################

echo "Prepare web clients..."
cp -r $WEBCLIENTS_ASSETS/* $BUILD_FOLDER

# ###############
# Update web page
# ###############

echo "Prepare web page..."

echo "Update the simple web page at $BUILD_WEBPAGE_GLOBAL_FILE..."
cat $WEBPAGE_ASSETS_HTML_BEGIN >> $BUILD_WEBPAGE_GLOBAL_FILE
cat $WEBPAGE_ASSETS_HTML_LINKS >> $BUILD_WEBPAGE_GLOBAL_FILE
cat $WEBPAGE_ASSETS_HTML_HEADER >> $BUILD_WEBPAGE_GLOBAL_FILE
cat $WEBPAGE_ASSETS_HTML_NAVIGATION >> $BUILD_WEBPAGE_GLOBAL_FILE
echo "<h1> Tools </h1><br/>" >> $BUILD_WEBPAGE_GLOBAL_FILE
cat $HTML_TOOLS_FILE >> $BUILD_WEBPAGE_GLOBAL_FILE
echo "<br/>" >> $BUILD_WEBPAGE_GLOBAL_FILE
echo "<h1> References </h1><br/>" >> $BUILD_WEBPAGE_GLOBAL_FILE
cat $HTML_WEB_FILE >> $BUILD_WEBPAGE_GLOBAL_FILE
echo "<br/>" >> $BUILD_WEBPAGE_GLOBAL_FILE
echo "<h1> Devices' specifications </h1><br/>" >> $BUILD_WEBPAGE_GLOBAL_FILE
cat $HTML_DEVICE_FILE >> $BUILD_WEBPAGE_GLOBAL_FILE
echo "<br/>" >> $BUILD_WEBPAGE_GLOBAL_FILE
echo "<h1> SoC's specifications </h1><br/>" >> $BUILD_WEBPAGE_GLOBAL_FILE
cat $HTML_SOC_FILE >> $BUILD_WEBPAGE_GLOBAL_FILE
cat $WEBPAGE_ASSETS_HTML_END >> $BUILD_WEBPAGE_GLOBAL_FILE

# ###########################
# Update Progressive Web App
# ###########################

echo "Prepare web app..."

echo "Update the progressive web app at $BUILD_WEBAPP_GLOBAL_FILE..."
cat $WEBAPP_ASSETS_HTML_BEGIN >> $BUILD_WEBAPP_GLOBAL_FILE
cat $WEBAPP_ASSETS_HTML_LINKS >> $BUILD_WEBAPP_GLOBAL_FILE
cat $WEBAPP_ASSETS_HTML_HEADER >> $BUILD_WEBAPP_GLOBAL_FILE
cat $WEBAPP_ASSETS_HTML_NAVIGATION >> $BUILD_WEBAPP_GLOBAL_FILE
cat $WEBAPP_ASSETS_HTML_TABLES >> $BUILD_WEBAPP_GLOBAL_FILE
cat $WEBAPP_ASSETS_HTML_END >> $BUILD_WEBAPP_GLOBAL_FILE

# #####################################
# Some stats about the number of fields
# #####################################

# CSV

csvToolsRows=`cat $CSV_TOOLS_FILE | wc -l`
csvWebRows=`cat $CSV_WEB_FILE | wc -l`
csvDevicesRows=`cat $CSV_DEVICE_FILE | wc -l`
csvSocsRows=`cat $CSV_SOC_FILE | wc -l`
csvToolsRowsCleaned=$(($csvToolsRows - $CSV_TOOLS_FILE_USELESS_ROWS))
csvWebRowsCleaned=$(($csvWebRows - $CSV_WEB_FILE_USELESS_ROWS))
csvDevicesRowsCleaned=$(($csvDevicesRows - $CSV_DEVICE_FILE_USELESS_ROWS))
csvSocsRowsCleaned=$(($csvSocsRows - $CSV_SOC_FILE_USELESS_ROWS))

# HTML

htmlToolsRowsNew=`cat $HTML_TOOLS_FILE | wc -l`
htmlWebRowsNew=`cat $HTML_WEB_FILE | wc -l`
htmlDevicesRowsNew=`cat $HTML_DEVICE_FILE | wc -l`
htmlSocsRowsNew=`cat $HTML_SOC_FILE | wc -l`

# JSON

jsonToolsRowsNew=`cat $JSON_TOOLS_FILE | wc -l`
jsonWebRowsNew=`cat $JSON_WEB_FILE | wc -l`
jsonDevicesRowsNew=`cat $JSON_DEVICE_FILE | wc -l`
jsonSocsRowsNew=`cat $JSON_SOC_FILE | wc -l`

# ############
# Some outputs
# ############

echo "Now we have $csvToolsRowsCleaned items in $CSV_TOOLS_FILE (HTML: $htmlToolsRowsOld -> $htmlToolsRowsNew, JSON: $jsonToolsRowsOld -> $jsonToolsRowsNew)."
echo "Now we have $csvWebRowsCleaned items in $CSV_WEB_FILE (HTML: $htmlWebRowsOld -> $htmlWebRowsNew, JSON: $jsonWebRowsOld -> $jsonWebRowsNew)."
echo "Now we have $csvDevicesRowsCleaned items in $CSV_DEVICE_FILE (HTML: $htmlDevicesRowsOld -> $htmlDevicesRowsNew, JSON: $jsonDevicesRowsOld -> $jsonDevicesRowsNew)."
echo "Now we have $csvSocsRowsCleaned items in $CSV_SOC_FILE (HTML: $htmlSocsRowsOld -> $htmlSocsRowsNew, JSON: $jsonSocsRowsOld -> $jsonSocsRowsNew)."

# HTML

if [ $htmlToolsRowsNew -lt $htmlToolsRowsOld ]; then
	echo "WARNING: The new file $HTML_TOOLS_FILE has now a smaller size than its previous version."
elif [ $htmlToolsRowsNew -eq $htmlToolsRowsOld ]; then
	echo "NOTE: The new file $HTML_TOOLS_FILE has the same size as its previous version."
fi

if [ $htmlWebRowsNew -lt $htmlWebRowsOld ]; then
	echo "WARNING: The new file $HTML_WEB_FILE has now a smaller size than its previous version."
elif [ $htmlWebRowsNew -eq $htmlWebRowsOld ]; then
	echo "NOTE: The new file $HTML_WEB_FILE has the same size as its previous version."
fi

if [ $htmlDevicesRowsNew -lt $htmlDevicesRowsOld ]; then
	echo "WARNING: The new file $HTML_DEVICE_FILE has now a smaller size than its previous version."
elif [ $htmlDevicesRowsNew -eq $htmlDevicesRowsOld ]; then
	echo "NOTE: The new file $HTML_DEVICE_FILE has the same size as its previous version."
fi

if [ $htmlSocsRowsNew -lt $htmlSocsRowsOld ]; then
	echo "WARNING: The new file $HTML_SOC_FILE has now a smaller size than its previous version."
elif [ $htmlSocsRowsNew -eq $htmlSocsRowsOld ]; then
	echo "NOTE: The new file $HTML_SOC_FILE has the same size as its previous version."
fi

# JSON

if [ $jsonToolsRowsNew -lt $jsonToolsRowsOld ]; then
	echo "WARNING: The new file $JSON_TOOLS_FILE has now a smaller size than its previous version."
elif [ $jsonToolsRowsOld -eq $jsonToolsRowsNew ]; then
	echo "NOTE: The new file $JSON_TOOLS_FILE has the same size as its previous version."
fi

if [ $jsonWebRowsNew -lt $jsonWebRowsOld ]; then
	echo "WARNING: The new file $JSON_WEB_FILE has now a smaller size than its previous version."
elif [ $jsonWebRowsOld -eq $jsonWebRowsNew ]; then
	echo "NOTE: The new file $JSON_WEB_FILE has the same size as its previous version."
fi

if [ $jsonDevicesRowsNew -lt $jsonDevicesRowsOld ]; then
	echo "WARNING: The new file $JSON_DEVICE_FILE has now a smaller size than its previous version."
elif [ $jsonDevicesRowsNew -eq $jsonDevicesRowsOld ]; then
	echo "NOTE: The new file $JSON_DEVICE_FILE has the same size as its previous version."
fi

if [ $jsonSocsRowsNew -lt $jsonSocsRowsOld ]; then
	echo "WARNING: The new file $JSON_SOC_FILE has now a smaller size than its previous version."
elif [ $jsonSocsRowsNew -eq $jsonSocsRowsOld ]; then
	echo "NOTE: The new file $JSON_SOC_FILE has the same size as its previous version."
fi

# Update the metadata file

TIMESTAMP=`date +"%s"`
echo "{" > $META_DATA_FILE
echo "\"buildTimestamp\": \"$TIMESTAMP\"," >> $META_DATA_FILE
echo "\"checksumTools\": \"$COMPUTED_CHECKSUM_CSV_TOOLZ_FILE\"," >> $META_DATA_FILE
echo "\"checksumWeb\": \"$COMPUTED_CHECKSUM_CSV_WEBZ_FILE\"," >> $META_DATA_FILE
echo "\"checksumDevices\": \"$COMPUTED_CHECKSUM_CSV_DEVZ_FILE\"," >> $META_DATA_FILE
echo "\"checksumSocs\": \"$COMPUTED_CHECKSUM_CSV_SOCZ_FILE\"" >> $META_DATA_FILE
echo "}" >> $META_DATA_FILE

# Finish!
echo "csvToGlobal.sh	TERMINATED !"
