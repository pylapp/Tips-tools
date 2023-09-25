/*
 * Software Name: Tips'n'tools
 * SPDX-FileCopyrightText: Copyright (c) 2016-2023 Pierre-Yves Lapersonne
 * SPDX-License-Identifier: MIT
 */
// ✿✿✿✿ ʕ •ᴥ•ʔ/ ︻デ═一

  /**
  * @file glue.js
  * @brief JavaScript glue, with quite useful functions so as to do some things (display messages, ...)
  * @author Pierre-Yves Lapersonne
  * @version 2.1.0
  * @since 29/01/2018
  */

  "use strict";

  /**
  * Displays a message in the page
  */
  function display( message, color ){
    let output = getDisplayedField("output");
    output.style.color = color;
    output.textContent = message;
    output.style.fontWeight = "normal";
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

/**
 * Checks if the web browsers is suitable or not
 * @return boolean - True if suitable and can be used as for the web app, false is buggy or too old and should use the global file
 */
 function checkWebBrowserInUse(){

   let magicString  = navigator.sayswho= (function(){
     var ua= navigator.userAgent, tem,
     M= ua.match(/(opera|chrome|safari|firefox|msie|trident(?=\/))\/?\s*(\d+)/i) || [];
     if(/trident/i.test(M[1])){
       tem=  /\brv[ :]+(\d+)/g.exec(ua) || [];
       return 'IE '+(tem[1] || '');
     }
     if(M[1]=== 'Chrome'){
       tem= ua.match(/\b(OPR|Edge)\/(\d+)/);
       if(tem!= null) return tem.slice(1).join(' ').replace('OPR', 'Opera');
     }
     M= M[2]? [M[1], M[2]]: [navigator.appName, navigator.appVersion, '-?'];
     if((tem= ua.match(/version\/(\d+)/i))!= null) M.splice(1, 1, tem[1]);
     return M.join(' ');
   })();

   let browserName = magicString.split(" ")[0];
   let browserVersion = magicString.split(" ")[1];

   // Case 1: Chrome or Chromium with version 38+
   // (lower version supporting, in theory, Service Workers, Manifests, Web Workers, IndexedDB, ES 6)
   if ( (browserName.includes("Chromium") || browserName.includes("Chrome"))
        && (browserVersion >= 38) ){
      return true;
   }

   // WARNING: It seems Firefox 58 on Linux and Android have bugs with IndexedDB O_ô; or maybe it's the guy in front of the keyboard
   if ( (navigator.appVersion.indexOf("Linux") != -1)
      || (navigator.appVersion.indexOf("X11") != -1) ){
     return false
   }

   // Case 2: Firefox with version 44+
   // (lower version supporting, in theory, Service Workers, Manifests, Web Workers, IndexedDB, ES 6)
   if ( browserName.includes("Firefox") && browserVersion >= 44 ){
      return true;
   }

   // Othewise: Nope.
   return false;

 }

 /**
 * Displays a message saying the web browser is not suitable
 */
 function displayNotSuitableBrowser(){
   let output = getDisplayedField("output");
   output.style.color = "#FFEB3B";
   output.style.fontWeight = "bold";
   output.innerHTML = STRING_ERROR_NOT_SUITABLE_BROWSER;
 } // End of function displayNotSuitableBrowser()

 /**
 * Displays a message saying  problem occured with the feed API
 */
 function displayFeedError(){
   let output = getDisplayedField("output");
   output.style.color = MESSAGE_COLOR_ERROR;
   output.style.fontWeight = "bold";
   output.innerHTML = STRING_ERROR_WITH_FEED;
} // End of function displayFeedError(feedUrl)

/**
* Displays a message saying an error occured with a JSON content
* @param error - The error
*/
function displayErrorWithJsonContent(error){
  let output = getDisplayedField("output");
  output.style.color = MESSAGE_COLOR_ERROR;
  output.style.fontWeight = "bold";
  output.innerHTML = STRING_ERROR_WITH_JSON;
} // End of function displayErrorWithJsonContent(error)

/**
* Displays a message saying an error occured
* @param error - The error meessage
*/
function displayError(error){
  let output = getDisplayedField("output");
  output.style.color = MESSAGE_COLOR_ERROR;
  output.style.fontWeight = "bold";
  output.innerHTML = error;
} // End of function displayError(error)
