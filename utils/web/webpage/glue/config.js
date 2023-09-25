/*
 * Software Name: Tips'n'tools
 * SPDX-FileCopyrightText: Copyright (c) 2016-2023 Pierre-Yves Lapersonne
 * SPDX-License-Identifier: MIT
 */
/*
✿✿✿✿ ʕ •ᴥ•ʔ/ ︻デ═一
*/

/**
* @file glue.js
* @brief JavaScript glue
* @author Pierre-Yves Lapersonne
* @version 1.0.0
* @since 29/01/2018
*/

"use strict";

let COMMAND_DISPLAY_ALL = "*all*";
let COMMAND_HELP = "?";

let FILTER_TOOLS = "tools";
let FILTER_REFERENCES ="refs";
let FILTER_DEVICES = "devices";
let FILTER_SOCS = "socs";
let FILTER_SYMBOL = "->";

let REGEX_TOOLS_FILTER = /tools ->/;
let REGEX_REFERENCES_FILTER = /refs ->/;
let REGEX_DEVICES_FILTER = /devices ->/;
let REGEX_SOCS_FILTER = /socs ->/;
let REGEX_SYMBOL_FILTER = /->/;

let ID_TABLE_TOOLS = "tableTools";
let ID_TABLE_REFERENCES = "tableReferences";
let ID_TABLE_DEVICES = "tableDevices";
let ID_TABLE_SOCS = "tableSocs";

let MESSAGE_HELP = "[{"+FILTER_TOOLS+" | "+FILTER_REFERENCES+" | "+FILTER_DEVICES+" | "+FILTER_SOCS+"} "+FILTER_SYMBOL+" ] keyword-1 keyword-2 ... keyword-n | "+COMMAND_HELP+" | "+COMMAND_DISPLAY_ALL;

let MESSAGE_COLOR_RESULTS = "#8BC34A";
let MESSAGE_COLOR_HELP = "white";
