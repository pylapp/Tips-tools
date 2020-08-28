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
