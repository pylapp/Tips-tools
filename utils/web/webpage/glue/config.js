/*
MIT License
Copyright (c) 2016-2018 Pierre-Yves Lapersonne (Mail: dev@pylapersonne.info)
Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
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
