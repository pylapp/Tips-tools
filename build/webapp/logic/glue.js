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

   // WARNING: It seems Firefox 58 on Linux and Android has bugs with IndexedDB O_ô
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
