#!/bin/bash
# Software Name: Tips'n'tools
# SPDX-FileCopyrightText: Copyright (c) 2023 Pierre-Yves Lapersonne
# SPDX-License-Identifier: MIT
#
# Author..............: Pierre-Yves Lapersonne
# Version.............: 1.0.0
# Since...............: 25/09/2023
# Description.........: Helps to check if environment is ready
#
# Usage: bash dry-run.sh
#

set -euo pipefail # set -euxo pipefail

# Exit codes
# ----------

NORMAL_EXIT=0
BAD_PRECONDITION_EXIT=1

# Functions
# ---------

UsageAndExit(){
	echo "USAGE:"
	echo "bash doctor.sh"
	exit $NORMAL_EXIT
}

CheckIfFileExistsOrWarning(){
    if [ ! -f "$1" ]; then
        echo "⚠️  WARNING: The file '$1' does not exist"
        warningPointsCount=$(($warningPointsCount + 1))
    else
        echo "✅  Cool! The file '$1' exists"
        goodPointsCount=$(($goodPointsCount + 1))
    fi
}

CheckIfDirectoryExistsOrWarning(){
    if [ ! -d "$1" ]; then
        echo "⚠️  WARNING: The directory '$1' does not exist"
        warningPointsCount=$(($warningPointsCount + 1))
    else
        echo "✅  Cool! The directory '$1' exists"
        goodPointsCount=$(($goodPointsCount + 1))
    fi
}

CheckIfFileExists(){
    if [ ! -f "$1" ]; then
        echo "⛔  ERROR: The file '$1' does not exist"
        badPointsCount=$(($badPointsCount + 1))
        exit $BAD_PRECONDITION_EXIT
    else
        echo "✅  Cool! The file '$1' exists"
        goodPointsCount=$(($goodPointsCount + 1))
    fi
}

CheckIfDirectoryExists(){
    if [ ! -d "$1" ]; then
        echo "⛔  ERROR: The directory '$1' does not exist"
        badPointsCount=$(($badPointsCount + 1))
        exit $BAD_PRECONDITION_EXIT
    else
        echo "✅  Cool! The directory '$1' exists"
        goodPointsCount=$(($goodPointsCount + 1))
    fi
}

IsCommandAvailable(){
    if ! command -v $1 &> /dev/null ; then
        return "yes"
    else
        return "no"
    fi
}

DoesRunOnGNULinux(){
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        echo "yes"
    else
        echo "no"
    fi
}

DoesRunOnMacOS(){
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "yes"
    else
        echo "no"
    fi
}

# Metrics
# -------

goodPointsCount=0
warningPointsCount=0
badPointsCount=0

# Check preconditions
# -------------------

if [ "$#" -ne 0 ]; then
    UsageAndExit
    exit $NORMAL_EXIT
fi

read -p "✋ Press any key to dry run DIVER module"

# Step 1 - Check the shell
# ------------------------

if [ -d "/proc" ]; then
    shellInUse=`/proc/$$/cmdline`
    if [ -f "$shellInUse" ]; then # Maybe on GNU/Linux
        echo "It seems you are in a GNU/Linux operating system"
        if ! grep -q "bash" /proc/$$/cmdline ; then
            echo "This script should be run with bash shell"
    	    warningPointsCount=$(($warningPointsCount + 1))
        else
            echo "It seems you are on GNU/Linux system, great!"
            goodPointsCount=$(($goodPointsCount + 1))
        fi
    else
        echo "Don't know on which OS you are"
        warningPointsCount=$(($warningPointsCount + 1))
    fi
else # Maybe on macOS
    echo "Supposing you are in macOS operating system (don(t say you are on Windows)"
    if ! grep -q "bash" "$SHELL" ; then
        echo "This script should be run with bash shell (zsh is fine too)"
    	warningPointsCount=$(($warningPointsCount + 1))
    else
        echo "Seems good!"
        goodPointsCount=$(($goodPointsCount + 1))
    fi
fi

# Step 2 - Check files
# --------------------

CheckIfFileExists "AUTHORS.txt"
CheckIfFileExists "CHANGELOG.md"
CheckIfFileExists "CODEOWNERS"
CheckIfFileExists "CONTRIBUTORS.txt"
CheckIfFileExists "CREDITS.md"
CheckIfFileExists "datafeed.rb"
CheckIfFileExists "LICENSE.txt"
CheckIfFileExists "picture.png"
CheckIfFileExists "README.md"
CheckIfFileExists "template.ods"
CheckIfFileExists "tipsntools.sh"

CheckIfDirectoryExists "utils"
CheckIfFileExists "utils/README.md"

CheckIfDirectoryExists "utils/core"
CheckIfFileExists "utils/core/csvToGlobal.sh"
CheckIfFileExists "utils/core/csvToHtml_devices.sh"
CheckIfFileExists "utils/core/csvToHtml_references.sh"
CheckIfFileExists "utils/core/csvToHtml_tools.sh"
CheckIfFileExists "utils/core/csvToHtml_socs.sh"
CheckIfFileExists "utils/core/csvToJson_devices.sh"
CheckIfFileExists "utils/core/csvToJson_references.sh"
CheckIfFileExists "utils/core/csvToJson_socs.sh"
CheckIfFileExists "utils/core/csvToJson_tools.sh"
CheckIfFileExists "utils/core/README.md"

CheckIfDirectoryExists "utils/web"
CheckIfDirectoryExists "utils/web/webapp"

CheckIfDirectoryExists "utils/web/webapp/logic"
CheckIfFileExists "utils/web/webapp/logic/adapter.js"
CheckIfFileExists "utils/web/webapp/logic/config.js"
CheckIfFileExists "utils/web/webapp/logic/glue.js"
CheckIfFileExists "utils/web/webapp/logic/indexeddb.js"
CheckIfFileExists "utils/web/webapp/logic/scrollButtons.js"
CheckIfFileExists "utils/web/webapp/logic/strings.js"
CheckIfFileExists "utils/web/webapp/logic/webworker.js"
CheckIfFileExists "utils/web/webapp/logic/window.js"
CheckIfFileExists "utils/web/webapp/logic/README.md"

CheckIfDirectoryExists "utils/web/webapp/patterns"
CheckIfFileExists "utils/web/webapp/patterns/begin.html"
CheckIfFileExists "utils/web/webapp/patterns/end.html"
CheckIfFileExists "utils/web/webapp/patterns/header.html"
CheckIfFileExists "utils/web/webapp/patterns/includes.html"
CheckIfFileExists "utils/web/webapp/patterns/navigationButtons.html"
CheckIfFileExists "utils/web/webapp/patterns/tables.html"
CheckIfFileExists "utils/web/webapp/patterns/README.md"

CheckIfDirectoryExists "utils/web/webapp/pictures"
CheckIfFileExists "utils/web/webapp/pictures/favicon.png"
CheckIfFileExists "utils/web/webapp/pictures/logo-96.png"
CheckIfFileExists "utils/web/webapp/pictures/logo-144.png"
CheckIfFileExists "utils/web/webapp/pictures/logo-192.png"
CheckIfFileExists "utils/web/webapp/pictures/logo.svg"
CheckIfFileExists "utils/web/webapp/pictures/navigation-down.svg"
CheckIfFileExists "utils/web/webapp/pictures/navigation-up.svg"
CheckIfFileExists "utils/web/webapp/pictures/README.md"

CheckIfDirectoryExists "utils/web/webapp/styles"
CheckIfFileExists "utils/web/webapp/styles/devices.css"
CheckIfFileExists "utils/web/webapp/styles/filter.css"
CheckIfFileExists "utils/web/webapp/styles/global.css"
CheckIfFileExists "utils/web/webapp/styles/header.css"
CheckIfFileExists "utils/web/webapp/styles/medias.css"
CheckIfFileExists "utils/web/webapp/styles/navigationButtons.css"
CheckIfFileExists "utils/web/webapp/styles/references.css"
CheckIfFileExists "utils/web/webapp/styles/socs.css"
CheckIfFileExists "utils/web/webapp/styles/tables.css"
CheckIfFileExists "utils/web/webapp/styles/tools.css"

CheckIfDirectoryExists "utils/web/webpage"
CheckIfDirectoryExists "utils/web/webpage/glue"
CheckIfFileExists "utils/web/webpage/glue/config.js"
CheckIfFileExists "utils/web/webpage/glue/filter.js"
CheckIfFileExists "utils/web/webpage/glue/glue.js"
CheckIfFileExists "utils/web/webpage/glue/README.md"
CheckIfFileExists "utils/web/webpage/glue/scrollButtons.js"
CheckIfFileExists "utils/web/webpage/glue/smoothScroll.js"
CheckIfFileExists "utils/web/webpage/glue/window.js"

CheckIfDirectoryExists "utils/web/webpage/patterns"
CheckIfFileExists "utils/web/webpage/patterns/begin.html"
CheckIfFileExists "utils/web/webpage/patterns/end.html"
CheckIfFileExists "utils/web/webpage/patterns/header.html"
CheckIfFileExists "utils/web/webpage/patterns/includes.html"
CheckIfFileExists "utils/web/webpage/patterns/navigationButtons.html"
CheckIfFileExists "utils/web/webpage/patterns/README.md"

CheckIfDirectoryExists "utils/web/webpage/pictures"
CheckIfFileExists "utils/web/webpage/pictures/favicon.png"
CheckIfFileExists "utils/web/webpage/pictures/logo.svg"
CheckIfFileExists "utils/web/webpage/pictures/navigation-down.svg"
CheckIfFileExists "utils/web/webpage/pictures/navigation-up.svg"
CheckIfFileExists "utils/web/webpage/pictures/README.md"

CheckIfDirectoryExists "utils/web/webpage/styles"
CheckIfFileExists "utils/web/webpage/styles/devices.css"
CheckIfFileExists "utils/web/webpage/styles/filter.css"
CheckIfFileExists "utils/web/webpage/styles/global.css"
CheckIfFileExists "utils/web/webpage/styles/header.css"
CheckIfFileExists "utils/web/webpage/styles/medias.css"
CheckIfFileExists "utils/web/webpage/styles/navigationButtons.css"
CheckIfFileExists "utils/web/webpage/styles/README.md"
CheckIfFileExists "utils/web/webpage/styles/references.css"
CheckIfFileExists "utils/web/webpage/styles/socs.css"
CheckIfFileExists "utils/web/webpage/styles/tables.css"
CheckIfFileExists "utils/web/webpage/styles/tools.css"

CheckIfFileExists "utils/web/manifest.json"
CheckIfFileExists "utils/web/serviceworker.js"

CheckIfDirectoryExistsOrWarning "contents"
CheckIfFileExistsOrWarning "contents/toolz"
CheckIfFileExistsOrWarning "contents/toolz/Tips-n-tools_Tools.csv"
CheckIfFileExistsOrWarning "contents/toolz/Tips-n-tools_Tools.json"

CheckIfDirectoryExistsOrWarning "contents/webz"
CheckIfFileExistsOrWarning "contents/webz/Tips-n-tools_WebLinks.csv"
CheckIfFileExistsOrWarning "contents/webz/Tips-n-tools_WebLinks.json"

CheckIfDirectoryExistsOrWarning "contents/devz"
CheckIfFileExistsOrWarning "contents/devz/Tips-n-tools_Devices.csv"
CheckIfFileExistsOrWarning "contents/devz/Tips-n-tools_Devices.json"

CheckIfDirectoryExistsOrWarning "contents/socz"
CheckIfFileExistsOrWarning "contents/socz/Tips-n-tools_SoC.csv"
CheckIfFileExistsOrWarning "contents/socz/Tips-n-tools_SoC.json"

# Check commands
# --------------

# Check OS
# --------

onGNULinux=$(DoesRunOnGNULinux)

onMacOS=$(DoesRunOnMacOS)

if [ $onGNULinux != "yes" -a $onMacOS != "yes" ]; then
    echo "⚠️  WARNING: Not sure your operating system is supported (nether GNU/Linux nor macOS)"
    warningPointsCount=$(($warningPointsCount + 1))
else
    echo "✅  Cool! It seems your operating system is supported"
    goodPointsCount=$(($goodPointsCount + 1))
fi

# Conclusion
# ----------

echo -e "\n----------"
echo "Conclusion"
echo "----------"

globalCount=$(($goodPointsCount + $warningPointsCount + $badPointsCount))
echo -e "\nJob done! See the logs above to check all points controls."
echo -e "\tNumber of controls.......: $globalCount"
echo -e "\tNumber of success........: $goodPointsCount"
echo -e "\tNumber of warnings.......: $warningPointsCount"
echo -e "\tNumber of errors.........: $badPointsCount"

exit $NORMAL_EXIT