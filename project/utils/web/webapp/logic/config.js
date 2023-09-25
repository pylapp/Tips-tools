/*
 * Software Name: Tips'n'tools
 * SPDX-FileCopyrightText: Copyright (c) 2016-2023 Pierre-Yves Lapersonne
 * SPDX-License-Identifier: MIT
 */
// ✿✿✿✿ ʕ •ᴥ•ʔ/ ︻デ═一

  /**
  * @file glue.js
  * @brief JavaScript file containing configuration elements
  * @author Pierre-Yves Lapersonne
  * @version 2.1.0
  * @since 29/01/2018
  */

  "use strict";

  /* **************************** *
  * Things related to filter bar *
  * **************************** */

  // Special commands
  let COMMAND_DISPLAY_ALL = "*all*";
  let COMMAND_HELP = "?";

  // Keywords for the filter bar
  let FILTER_TOOLS = "tools";
  let FILTER_REFERENCES ="refs";
  let FILTER_DEVICES = "devices";
  let FILTER_SOCS = "socs";
  let FILTER_SYMBOL = "->";

  // Regex to check the input of the user
  let REGEX_TOOLS_FILTER = /tools ->/;
  let REGEX_REFERENCES_FILTER = /refs ->/;
  let REGEX_DEVICES_FILTER = /devices ->/;
  let REGEX_SOCS_FILTER = /socs ->/;
  let REGEX_SYMBOL_FILTER = /->/;

  /* ************************************* *
  * Things related to database (IndexedDB) *
  * ************************************** */

  // Configuration for the database
  const DATABASE_NAME = "Tips-N-Tools_database";
  const DATABASE_VERSION = 1;

  // The stores in use, can be seens as SQL tables (but are not!:)
  const OBJECT_STORE_TOOLS = "tools";
  const OBJECT_STORE_REFERENCES = "references";
  const OBJECT_STORE_DEVICES = "devices";
  const OBJECT_STORE_SOCS = "socs";

  // Web API providing the data to feed
  const DATA_FEED_API = "http://localhost:4343/getAll"

  /* ***************************** *
  * Things related to CSS classes *
  * ***************************** */

  // The CSS classes to apply in the table containing references of tools
  const CSS_CLASSES_FOR_TOOLS = {
    "platform": {
      "Android": "subjectToolsAndroid",
      "Design": "subjectToolsDesign",
      "JavaScript": "subjectToolsJavaScript",
      "Java": "subjectToolsJava",
      "Kotlin": "subjectToolsKotlin",
      "Web": "subjectToolsWeb",
      "Swift": "subjectToolsSwift",
      "Go": "subjectToolsGo",
      "Scala": "subjectToolsScala",
      "Groovy": "subjectToolsGroovy",
      "Python": "subjectToolsPython",
      "DevTool": "subjectToolsDevTool",
      "Bots": "subjectToolsBots",
      "Rust": "subjectToolsRust",
      "Dart": "subjectToolsDart",
      "AI": "subjectToolsAi",
      "Humanism": "subjectToolsHumanism",
      "Fuchsia": "subjectToolsFuchsia",
      "CryptoCurrency": "subjectToolsCryptoCurrency",
      "Agile": "subjectToolsAgile",
      "Blockchain": "subjectToolsBlockchain",
      "Ðapp": "subjectToolsÐapp",
      "Data": "subjectToolsData",
      "Test": "subjectToolsTest",
      "Security": "subjectToolsSecurity",
      "Ruby": "subjectToolsRuby",
      "/": "subjectToolsOther"
    },
    "name": "nameTools",
    "description": "descriptionTools",
    "keywords": "keywordsTools",
    "url": "url"
  };

  // The CSS classes to apply in the table containing references of... web references
  const CSS_CLASSES_FOR_REFERENCES = {
    "platform": {
      "Android": "subjectReferencesAndroid",
      "Design": "subjectReferencesDesign",
      "JavaScript": "subjectReferencesJavaScript",
      "Java": "subjectReferencesJava",
      "Kotlin": "subjectReferencesKotlin",
      "Web": "subjectReferencesWeb",
      "Swift": "subjectReferencesSwift",
      "Go": "subjectReferencesGo",
      "Scala": "subjectReferencesScala",
      "Groovy": "subjectReferencesGroovy",
      "Python": "subjectReferencesPython",
      "DevTool": "subjectReferencesDevTool",
      "Bots": "subjectReferencesBots",
      "Rust": "subjectReferencesRust",
      "Dart": "subjectReferencesDart",
      "AI": "subjectReferencesAi",
      "Humanism": "subjectReferencesHumanism",
      "Fuchsia": "subjectReferencesFuchsia",
      "CryptoCurrency": "subjectReferencesCryptoCurrency",
      "Agile": "subjectReferencesAgile",
      "Blockchain": "subjectReferencesBlockchain",
      "Ðapp": "subjectReferencesDapp",
      "Data": "subjectReferencesData",
      "Test": "subjectReferencesTest",
      "Security": "subjectReferencesSecurity",
      "Ruby": "subjectReferencesRuby",
      "/": "subjectReferencesOther"
    },
    "name": "nameReferences",
    "description": "descriptionReferences",
    "keywords": "keywordsReferences",
    "url": "url"
  };

  // The CSS classes to apply in the table containing references of devices
  const CSS_CLASSES_FOR_DEVICES = {
    "type": {
      "smartphone": "typeSmartphone",
      "watch": "typeWatch",
      "band": "typeBand",
      "box": "typeBox",
      "/": "typeOther"
    },
    "os": {
      "Android": "pfAndroid",
      "Cyanogen": "pfCyanogen",
      "OxygenOS": "pfOxygenOS",
      "iOS": "pfIOS",
      "Windows": "pfWindows",
      "FirefoxOS": "pfFirefoxOS",
      "UbuntuTouch": "pfUbuntuTouch",
      "Tizen": "pfTizen",
      "watchOS": "pfWatchOS",
      "/": "pfOther"
    },
    "constructorName": "constructor",
    "name": "name",
    "screensize": "screensize",
    "screentype": "screentype",
    "screenresolution": "screenresolution",
    "soc": "soc",
    "gpu": "gpu",
    "sensors": "sensors",
    "battery": "battery",
    "storage": "storage",
    "ram": "ram",
    "camera": "camera",
    "dimensions": "dimensions",
    "usbtype": "usbtype",
    "weight": "weight",
    "ip": "ip",
    "sdcard": "sdcard",
    "sim": "sim",
    "ui": "ui"
  };

  // The CSS classes to apply in the table containing references of SoC
  const CSS_CLASSES_FOR_SOCS = {
    "constructorName": {
      "Qualcomm": "constructorQualcomm",
      "Samsung": "constructorSamsung",
      "Apple": "constructorApple",
      "MediaTek": "constructorMediaTek",
      "Huawei": "constructorHuawei",
      "Xiaomi": "constructorXiaomi",
      "/": "constructorOther"
    },
    "target": {
      "smartphone / tablet": "targetSmartphoneTablet",
      "smartphone": "targetSmartphone",
      "iPhone": "targetIphone",
      "/": "targetOther"
    },
    "name": "name",
    "gravure": "name",
    "modem": "modem",
    "peakdownloadspeed": "pds",
    "peakuploadspeed": "pus",
    "bluetooth": "bluetooth",
    "nfc": "nfc",
    "usb": "usb",
    "camerasupportmax": "csm",
    "videocapturemax": "vcm",
    "videoplaybackmax": "vpm",
    "displaymax": "dm",
    "cpu": "cpu",
    "cpucoresnumber": "cpucn",
    "cpuclockspeedmax": "cpucsm",
    "cpuarchitecture": "cpua",
    "gpu": "gpu",
    "gpuapisupport": "gpuas",
    "aisupport": "ais"
  };

  /* ************ *
  * Other things *
  * ************ */

  let ID_TABLE_TOOLS = "tableTools";
  let ID_TABLE_REFERENCES = "tableReferences";
  let ID_TABLE_DEVICES = "tableDevices";
  let ID_TABLE_SOCS = "tableSocs";

  let MESSAGE_HELP = "[{"+FILTER_TOOLS+" | "+FILTER_REFERENCES+" | "+FILTER_DEVICES
  +" | "+FILTER_SOCS+"} "+FILTER_SYMBOL+" ] keyword-1 keyword-2 ... keyword-n | "
  +COMMAND_HELP+" | "+COMMAND_DISPLAY_ALL;

  /* ************************************ *
  * Things related to errors and messages *
  * ************************************* */

  let MESSAGE_COLOR_RESULTS = "#8BC34A";
  let MESSAGE_COLOR_HELP = "white";
  let MESSAGE_COLOR_ERROR = "#FF9800";

  let ERROR_BAD_JSON = 1;
  let ERROR_WEB_API_UNREACHABLE = 2;
  let ERROR_WITH_DATABASE = 3;
  let ERROR_MISSING_DATA = 4;

  let ERROR_TRANSACTION_POPULATE_TOOLS = 11;
  let ERROR_TRANSACTION_POPULATE_REFERENCES = 12;
  let ERROR_TRANSACTION_POPULATE_DEVICES = 13;
  let ERROR_TRANSACTION_POPULATE_SOCS = 14;

  let ERROR_NETWORK_REQUEST_DURING_SEND = 21;

  let ERROR_READ_STORES = 31;
