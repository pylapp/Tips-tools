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

/**
* Refreshes the page and its table so as to have all the items
*/
function refresh(){
  let tables = document.getElementsByTagName("table");
  for ( let i = 0; i < tables.length; i++ ){
    let rows = tables[i].rows;
    for ( let j = 0; j < rows.length; j++ ){
      rows[j].style.display = 'table-row';
      rows[j].style.visibility = 'visible';
    }
  }
} // End of function refresh()

/**
 * Displays a message in the page
 */
 function display( message, color ){
    let output = getDisplayedField("output");
    output.style.color = color;
    output.textContent = message;
 } // End of function display( message, isError )

/**
 * Notifies the user of a more important message, returns the previous message;
 */
function notify( message, color ){
   let fields = document.getElementsByClassName("message");
   for ( let i = 0; i < fields.length; i++ ){
     element = fields[i];
     element.style.color = color;
     let previousMessage = element.textContent;
     element.textContent = message;
     return previousMessage;
   }
} // End of function notify( message, color )

/**
 * Returns the displayed field (in one of the headers) with the class defined in paramter
 * @param class - The class of the displayed-or-not field
 */
function getDisplayedField(classField){
  let element;
  // Is the main header displayed?
  let mainheader = document.getElementById("mainHeader");
  if ( window.getComputedStyle(mainHeader).getPropertyValue("display") != "none" ){
    element = document.getElementsByClassName(classField)[0];
  // Main header hidden
  } else {
    element = document.getElementsByClassName(classField)[1];
  }
  return element;
} // End of function getDisplayedField(classField)

/**
 * Displays only the table with this id, and hides the others
 */
function showOnlyTableWithId( id ){
  let tables = document.getElementsByTagName("table");
  for ( let i = 0; i < tables.length; i++ ){
    if ( tables[i].id == id ){
      tables[i].tBodies[0].style.display = "";
      tables[i].tBodies[0].style.visibility = 'visible';
    } else {
      tables[i].tBodies[0].style.display = 'none';
    }
  }
} // End of function showOnlyTableWithId( id )

/**
 * Displays all the tables
 */
function showAllTables(){
  let tables = document.getElementsByTagName("table");
  for ( let i = 0; i < tables.length; i++ ){
    tables[i].tBodies[0].style.display = "";
    tables[i].tBodies[0].style.visibility = 'visible';
  }
} // End of function showAllTables()
