/*
 * Software Name: Tips'n'tools
 * SPDX-FileCopyrightText: Copyright (c) 2016-2023 Pierre-Yves Lapersonne
 * SPDX-License-Identifier: MIT
 */
// ✿✿✿✿ ʕ •ᴥ•ʔ/ ︻デ═一

  /**
  * @file adapter.js
  * @brief JavaScript glue for the filter feature. Makes the bridge, as a kind of adapter, between the Web Worker and the GUI components.
  * @author Pierre-Yves Lapersonne
  * @version 5.0.0
  * @since 10/12/2017
  */

  "use strict";

  /**
  * The web workers which makes filtering process
  */
  let filteringWebWorker = new Worker("./webapp/logic/webworker.js");

  /**
  * If the key event is ENTER, filter the content of the tables
  */
  function filterBarOnKeyDown( event ){
    let keycode = 0;
    if (window.event) keycode = window.event.keyCode;
    else if (event) keycode = event.which;
    if (keycode == 13){
      display("Processing...", MESSAGE_COLOR_RESULTS);
      setTimeout(function(){
        processCommand(); // Wait a bit before processing the command, because the UI is not updated enough early
      }, 500);
    }
  }

  /**
  * Process the commands written by the user
  */
  function processCommand(){

    // Get the command
    let keywordsField = getDisplayedField("keywords");
    if ( keywordsField == null || keywordsField.value == "" ){
      return;
    }
    let command = keywordsField.value;

    // Help command?
    if ( command == COMMAND_HELP ){
      commandHelp();
      return;
    }

    // Filter command: for tools only ?
    if ( command.search(REGEX_TOOLS_FILTER) >= 0 ){
      commandFilterInTableWithId(ID_TABLE_TOOLS);
      showOnlyTableWithId(ID_TABLE_TOOLS);
      return;
    }

    // Filter command: for references only ?
    if ( command.search(REGEX_REFERENCES_FILTER) >= 0 ){
      commandFilterInTableWithId(ID_TABLE_REFERENCES);
      showOnlyTableWithId(ID_TABLE_REFERENCES);
      return;
    }

    // Filter command: for devices only ?
    if ( command.search(REGEX_DEVICES_FILTER) >= 0 ){
      commandFilterInTableWithId(ID_TABLE_DEVICES);
      showOnlyTableWithId(ID_TABLE_DEVICES);
      return;
    }

    // Filter command: for SoC only ?
    if ( command.search(REGEX_SOCS_FILTER) >= 0 ){
      commandFilterInTableWithId(ID_TABLE_SOCS);
      showOnlyTableWithId(ID_TABLE_SOCS);
      return;
    }

    showAllTables();

    // "Show all" command?
    if ( command == COMMAND_DISPLAY_ALL ){
      commandShowAll();
      return;
    }

    // Otherwise process filtering operation
    commandFilterInAllTables();

  } // End of function processCommand()

  /**
  * Displays an help in the input field
  */
  function commandHelp(){
    let keywordsField = getDisplayedField("keywords");
    keywordsField.value = MESSAGE_HELP;
    display(STRING_MESSAGE_COMMANDS_HELP, MESSAGE_COLOR_HELP);
  } // End of function commandHelp()

  /**
  * Show all results
  */
  function commandShowAll(){
    refresh();
  } // End of function commandShowAll()

  /**
  * Filters the content of the table with this id.
  * Will get all the keywords separated by a ' ', and keep only the good parts (at the right) if the '->' symbol is found.
  * Then will process the good table's rows so as to check in all the keywords matches the rows.
  * If so, the row is visible, otherwise the row is hidden.
  */
  function commandFilterInTableWithId(id){

    // Get the written keywords
    let keywordsField = getDisplayedField("keywords");
    if ( keywordsField == null || keywordsField.value == "" ){
      return;
    }

    let keywords = "";
    if ( keywordsField.value.search(REGEX_SYMBOL_FILTER) >= 0 ){
      keywords = keywordsField.value.split(FILTER_SYMBOL)[1];
    }

    // Get the constant to use for WebWorkers according to the table to filter
    let target;
    switch (id){
      case ID_TABLE_TOOLS:
        target = "filter-webworker.TOOLS";
        break;
      case ID_TABLE_REFERENCES:
        target = "filter-webworker.REFERENCES";
        break;
      case ID_TABLE_DEVICES:
        target = "filter-webworker.DEVICES";
        break;
      case ID_TABLE_SOCS:
        target = "filter-webworker.SOCS";
        break;
      default:
        console.error("Error with filtering process: which target is "+id+" ?");
        return;
    }

    let startTime = new Date().getTime();

    filteringWebWorker.postMessage(["filter-webworker.FILTER_PART_OF_CONTENT", target, keywords]);

    filteringWebWorker.onmessage = function(args){

      let endTime = new Date().getTime();
      let elapsedTime = (endTime - startTime) / 1000;

      // Step 1: get the data loaded by web worker in storage
      let foundObjects = args.data[0];

      // Step 2: Update the views
      emptyViews();

      switch (target){
        case "filter-webworker.TOOLS":
          addToolsInView(foundObjects);
          break;
        case "filter-webworker.REFERENCES":
          addReferencesInView(foundObjects);
          break;
        case "filter-webworker.DEVICES":
          addDevicesInView(foundObjects);
          break;
        case "filter-webworker.SOCS":
          addSocsInView(foundObjects);
          break;
      }

      // Step 3: count the number of elements
      let foundElements = foundObjects.length;
      let foundItemsMessages = "Found "+foundElements+" item";
      foundItemsMessages += (foundElements > 1 ? "s" : "")
      foundItemsMessages += " in " + elapsedTime + " second"
      foundItemsMessages += (elapsedTime > 1 ? "s" : "")
      display(foundItemsMessages, MESSAGE_COLOR_RESULTS);

    }

  } // End of function commandFilterInTableWithId(id)

  /**
  * Filters the content of tall the tables.
  * Will get all the keywords separated by a ' '.
  * Then will process each table's rows so as to check in all the keywords matches the rows.
  * If so, the row is visible, otherwise the row is hidden.
  */
  function commandFilterInAllTables(){

    // Get the written keywords
    let keywordsField = getDisplayedField("keywords");
    if ( keywordsField == null || keywordsField.value == "" ){
      return;
    }
    let keywords = keywordsField.value;

    let startTime = new Date().getTime();

    filteringWebWorker.postMessage(["filter-webworker.FILTER_ALL_CONTENT", keywords]);

    filteringWebWorker.onmessage = function(args){

      let endTime = new Date().getTime();
      let elapsedTime = (endTime - startTime) / 1000;

      // Step 1: get the data loaded by web worker in storage

      let foundTools = args.data[0];
      let foundReferences = args.data[1];
      let foundDevices = args.data[2];
      let foundSocs = args.data[3];

      // Step 2: Update the views
      emptyViews();
      addToolsInView(foundTools);
      addReferencesInView(foundReferences);
      addDevicesInView(foundDevices);
      addSocsInView(foundSocs);

      // Step 3: count the number of elements
      let foundElements = foundTools.length + foundReferences.length + foundDevices.length + foundSocs.length;
      let foundItemsMessages = "Found "+foundElements+" item";
      foundItemsMessages += (foundElements > 1 ? "s" : "")
      foundItemsMessages += " in " + elapsedTime + " second"
      foundItemsMessages += (elapsedTime > 1 ? "s" : "")
      display(foundItemsMessages, MESSAGE_COLOR_RESULTS);

    }

  } // End of function commandFilterInAllTables()

  /**
  * Refreshes the page and its table so as to have all the items.
  * @return Promise - The promise wich will do the job
  */
  function refresh(){
    return new Promise(function(resolve, reject){

      display("Processing...", MESSAGE_COLOR_RESULTS);

      let startTime = new Date().getTime();

      filteringWebWorker.postMessage(["filter-webworker.RESET_CONTENT"]);

      filteringWebWorker.onmessage = function(args){

        let endTime = new Date().getTime();
        let elapsedTime = (endTime - startTime) / 1000;

        // Step 1: get the data loaded by web worker in storage

        let foundTools = args.data[0];
        let foundReferences = args.data[1];
        let foundDevices = args.data[2];
        let foundSocs = args.data[3];

        // Step 2: Update the page with the CSS styles, and the HTML table's code
        emptyViews();
        addToolsInView(foundTools);
        addReferencesInView(foundReferences);
        addDevicesInView(foundDevices);
        addSocsInView(foundSocs);

        // Step 3: count the number of elements

        let foundElements = foundTools.length + foundReferences.length + foundDevices.length + foundSocs.length;
        let foundItemsMessages = "Found "+foundElements+" item";
        foundItemsMessages += (foundElements > 1 ? "s" : "")
        foundItemsMessages += " in " + elapsedTime + " second"
        foundItemsMessages += (elapsedTime > 1 ? "s" : "")
        display(foundItemsMessages, MESSAGE_COLOR_RESULTS);

        resolve();

      }

    });

  } // End of function refresh()

  /**
  * Makes the views (tables) empty
  */
  function emptyViews(){
    let tables = [ID_TABLE_TOOLS, ID_TABLE_REFERENCES, ID_TABLE_SOCS, ID_TABLE_DEVICES];
    for (let table in tables){
      let emptyTableBody = document.createElement('tbody');
      let oldBody = document.getElementById(tables[table]).getElementsByTagName('tbody')[0];
      oldBody.parentNode.replaceChild(emptyTableBody, oldBody);
    }
  } // End of function emptyViews()

  /**
  * Add tools ojbects in the page
  * @param tools - A JSON array object with the tools
  */
  function addToolsInView(tools){

    // Get the table
    let table = document.getElementById(ID_TABLE_TOOLS).getElementsByTagName('tbody')[0]

    // Parse the results
    for (let tool in tools){
      let item = tools[tool];
      let keys = Object.keys(item);
      let row = table.insertRow();
      for (let i = 1; i < keys.length; i++){ // Start to 1, do not forget to skip the 1 field, which is the index in the database
        let key = keys[i];
        let cell = row.insertCell(i-1);
        // If we are in the case of the platform, with CSS class depending to it
        if (key == "platform"){
          cell.className = CSS_CLASSES_FOR_TOOLS[key][item[key]];
        } else {
          cell.className = CSS_CLASSES_FOR_TOOLS[key];
        }
        // In the case of we process a URL, add another cell inside this one
        if (i == keys.length-1){
          cell.innerHTML = "<a href=\""+item[key]+"\">"+item[key]+"</a>"
        } else {
          cell.innerHTML = item[key];
        }
      }
    }

  } // End of function addToolsInView(tools)

  /**
  * Add references ojbects in the page
  * @param references - A JSON array object with the references
  */
  function addReferencesInView(references){

    // Get the table
    let table = document.getElementById(ID_TABLE_REFERENCES).getElementsByTagName('tbody')[0]

    // Parse the results
    for (let ref in references){
      let item = references[ref];
      let keys = Object.keys(item);
      let row = table.insertRow();
      for (let i = 1; i < keys.length; i++){ // Start to 1, do not forget to skip the 1 field, which is the index in the database
        let key = keys[i];
        let cell = row.insertCell(i-1);
        // If we are in the case of the platform, with CSS class depending to it
        if (key == "platform"){
          cell.className = CSS_CLASSES_FOR_REFERENCES[key][item[key]];
        } else {
          cell.className = CSS_CLASSES_FOR_REFERENCES[key];
        }
        // In the case of we process a URL, add another cell inside this one
        if (i == keys.length-1){
          cell.innerHTML = "<a href=\""+item[key]+"\">"+item[key]+"</a>"
        } else {
          cell.innerHTML = item[key];
        }
      }
    }

  } // End of function addReferencesInView(references)

  /**
  * Add devices ojbects in the page
  * @param devices - A JSON array object with the devices
  */
  function addDevicesInView(devices){

    // Get the table
    let table = document.getElementById(ID_TABLE_DEVICES).getElementsByTagName('tbody')[0]

    // Parse the results
    for (let device in devices){
      let item = devices[device];
      let keys = Object.keys(item);
      let row = table.insertRow();
      for (let i = 1; i < keys.length; i++){ // Start to 1, do not forget to skip the 1 field, which is the index in the database
        let key = keys[i];
        let cell = row.insertCell(i-1);
        // We have to deal with the type of the device, known or unknown
        if (key == "type" || key == "os"){
          let value = item[key];
          if (CSS_CLASSES_FOR_DEVICES[key].hasOwnProperty(value)){ // Knwon type or OS
            cell.className = CSS_CLASSES_FOR_DEVICES[key][value];
          } else { // Unknown type or OS, "/" is the entry of the default classes
            cell.className = CSS_CLASSES_FOR_DEVICES[key]["/"];
          }
        } else {
          cell.className = CSS_CLASSES_FOR_DEVICES[key];
        }
        cell.innerHTML = item[key];
      }
    }

  } // End of function addDevicesInView(devices)

  /**
  * Add SoC ojbects in the page
  * @param socs - A JSON array object with the socs
  */
  function addSocsInView(socs){

      // Get the table
      let table = document.getElementById(ID_TABLE_SOCS).getElementsByTagName('tbody')[0]

      // Parse the results
      for (let soc in socs){
        let item = socs[soc];
        let keys = Object.keys(item);
        let row = table.insertRow();
        for (let i = 1; i < keys.length; i++){ // Start to 1, do not forget to skip the 1 field, which is the index in the database
          let key = keys[i];
          let cell = row.insertCell(i-1);
          // We have to deal with the constructor of the SoC and its target, known or unknown
          if (key == "constructorName" || key == "target"){
            let value = item[key];
            if (CSS_CLASSES_FOR_SOCS[key].hasOwnProperty(value)){ // Knwon constructor or target
              cell.className = CSS_CLASSES_FOR_SOCS[key][value];
            } else { // Unknown constructor or target, "/" is the entry of the default classes
            cell.className = CSS_CLASSES_FOR_SOCS[key]["/"];
          }
        } else {
          cell.className = CSS_CLASSES_FOR_SOCS[key];
        }
        cell.innerHTML = item[key];
      }

    }

  } // End of function addSocsInView(socs)
