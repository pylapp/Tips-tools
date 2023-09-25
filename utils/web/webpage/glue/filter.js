/*
 * Software Name: Tips'n'tools
 * SPDX-FileCopyrightText: Copyright (c) 2016-2023 Pierre-Yves Lapersonne
 * SPDX-License-Identifier: MIT
 */
/*
✿✿✿✿ ʕ •ᴥ•ʔ/ ︻デ═一
*/

/**
* @file filter.js
* @brief JavaScript glue for the filter
* @author Pierre-Yves Lapersonne
* @version 4.0.0
* @since 10/12/2017
*/

"use strict";

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
      processCommand(); // Wait a bit befoire processing the command, because the UI is not updated enough early
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
  display("Pattern to follow for the commands", MESSAGE_COLOR_HELP);
} // End of function commandHelp()

/**
 * Show all results
 */
function commandShowAll(){
  refresh();
  display("", MESSAGE_COLOR_RESULTS);
} // End of function commandShowAll()

/**
 * Filters the content of the table with this id.
 * Will get all the keywords separated by a ' ', and keep only the good parts (at the right) if the '->' symbol is found.
 * Then will process the good table's rows so as to check in all the keywords matches the rows.
 * If so, the row is visible, otherwise the row is hidden.
 */
function commandFilterInTableWithId(id){

  let startDate = new Date();

  refresh();

  // Get the written keywords
  let keywordsField = getDisplayedField("keywords");
  if ( keywordsField == null || keywordsField.value == "" ){
    return;
  }

  let keywords = "";
  if ( keywordsField.value.search(REGEX_SYMBOL_FILTER) >= 0 ){
    keywords = keywordsField.value.split(FILTER_SYMBOL)[1];
  }
  keywords = keywords.split(" ");

  let foundItems = 0;

  // Get the <table> with the good id
  let table = document.getElementById(id);

  // Get each row
  let rows = table.rows;
  for ( let i = 1; i < rows.length; i++ ){ // Escape the first line contaning the headers of the table
    let row = rows[i];

    // Get each table's row's cells value and contatenate them to one searchable string
    let cells = row.cells;
    let searchableString = "";
    for ( let j = 0; j < cells.length; j++ ){
      searchableString += cells[j].innerText;
    }
    searchableString = searchableString.toLowerCase();

    // Iterate on each keyword to find one keyword which is not in the global string
    let keywordIndex = 0;
    let unmatchedKeywordFound = false;
    let endOfKeywords = false;

    while ( !unmatchedKeywordFound && !endOfKeywords ){

      // All keywords  have been checked?
      if ( keywordIndex >= keywords.length ){
        endOfKeywords = true;
        continue;
      }

      // Check the current keyword
      let input = keywords[keywordIndex].toLowerCase();
      if ( searchableString.indexOf(input) <= -1 ){ // Keyword not found in the row. Use regex instead.
        unmatchedKeywordFound = true;
        rows[i].style.display = 'none';
        continue;
      }

      keywordIndex++;

    } // End of while ( !unmatchedKeywordFound && !endOfKeywords )

    // Increase countor if, and only if, all the keywords have been parsed and no unmatched keywords were found
    if ( endOfKeywords && !unmatchedKeywordFound ) foundItems++;

  } // End of for ( let i = 1; i < rows.length; i++ )

  let endDate = new Date();
  let timeDiff = endDate - startDate;
  timeDiff /= 1000;
  let elapsedTime = Math.round(timeDiff % 60); // in seconds

  // Display more results
  let foundItemsMessages = "Found "+foundItems+" item";
  foundItemsMessages += (foundItems > 1 ? "s" : "")
  foundItemsMessages += " in " + elapsedTime + " second"
  foundItemsMessages += (elapsedTime > 1 ? "s" : "")
  display(foundItemsMessages, MESSAGE_COLOR_RESULTS);

} // End of function commandFilterInTableWithId(id)

/**
 * Filters the content of tall the tables.
 * Will get all the keywords separated by a ' '.
 * Then will process each table's rows so as to check in all the keywords matches the rows.
 * If so, the row is visible, otherwise the row is hidden.
 */
function commandFilterInAllTables(){

  let startDate = new Date();

  refresh();

  // Get the written keywords
  let keywordsField = getDisplayedField("keywords");
  if ( keywordsField == null || keywordsField.value == "" ){
    return;
  }
  let keywords = keywordsField.value.split(" ");

  let foundItems = 0;

  // Get all the <table> elements in the page
  let tables = document.getElementsByTagName("table");
  for ( let i = 0; i < tables.length; i++ ){

    // Get each table row
    let rows = tables[i].rows;
    for ( let j = 1; j < rows.length; j++ ){ // Escape the first line contaning the headers of the table
      let row = rows[j];

      // Get each table's row's cells value and contatenate them to one searchable string
      let cells = row.cells;
      let searchableString = "";
      for ( let k = 0; k < cells.length; k++ ){
        searchableString += cells[k].innerText;
      }
      searchableString = searchableString.toLowerCase();

      // Iterate on each keyword to find one keyword which is not in the global string
      let keywordIndex = 0;
      let unmatchedKeywordFound = false;
      let endOfKeywords = false;
      while ( !unmatchedKeywordFound && !endOfKeywords ){

        // All keywords  have been checked?
        if ( keywordIndex >= keywords.length ){
          endOfKeywords = true;
          continue;
        }

        // Check the current keyword
        let input = keywords[keywordIndex].toLowerCase();
        if ( searchableString.indexOf(input) <= -1 ){ // Keyword not found in the row. Use regex instead.
          unmatchedKeywordFound = true;
          rows[j].style.display = 'none';
          continue;
        }

        keywordIndex++;

      } // End of while ( !unmatchedKeywordFound && !endOfKeywords )

      // Increase countor if, and only if, all the keywords have been parsed and no unmatched keywords were found
      if ( endOfKeywords && !unmatchedKeywordFound ) foundItems++;

    } // End of for ( let j = 1; j < rows.length; j++ )

  } // End of for ( let i = 0; i < tables.length; i++ )

  let endDate = new Date();
  let timeDiff = endDate - startDate;
  timeDiff /= 1000;
  let elapsedTime = Math.round(timeDiff % 60); // in seconds

  // Display more results
  let foundItemsMessages = "Found "+foundItems+" item";
  foundItemsMessages += (foundItems > 1 ? "s" : "")
  foundItemsMessages += " in " + elapsedTime + " second"
  foundItemsMessages += (elapsedTime > 1 ? "s" : "")
  display(foundItemsMessages, false);

} // End of function commandFilterInAllTables()
