/*
 * Software Name: Tips'n'tools
 * SPDX-FileCopyrightText: Copyright (c) 2016-2023 Pierre-Yves Lapersonne
 * SPDX-License-Identifier: MIT
 */
// ✿✿✿✿ ʕ •ᴥ•ʔ/ ︻デ═一

  /**
  * @file window.js
  * @brief JavaScript glue for windows management
  * @author Pierre-Yves Lapersonne
  * @version 4.0.0
  * @since 19/12/2017
  */

  "use strict";

  /* ***************** *
  * Defines variables *
  * ***************** */

  // A timer to reset each time a scroll event is triggered. When the timer runs, the scroll has been ended
  let endOfScrollTimer = null;

  // A delay fo the scroll event's timer
  let SCROLL_THRESHOLD = 300;

  /* ***************** *
  * Defines listeners *
  * ***************** */

  window.onresize = function(event) {
    moveVolatileFieldsValues();
  }

  window.onscroll = function(){
    if (endOfScrollTimer !== null) clearTimeout(endOfScrollTimer);
    endOfScrollTimer = setTimeout(function() {
      initNavigationButtons()
    }, SCROLL_THRESHOLD);
  }

  window.onload = function(event) {
    // Check the web browser
    if (checkWebBrowserInUse() && checkIfStorageSupported()){
      initDatabase().then(
        // In this case, Promise resolved because Web API has been fetched, so refresh
        function(res){
          refresh();
        },
        // In this case, Promise rejected because Web API not reachable, but we still may have data in the local database
        function(res){
          refresh().then( function(){
            switch (res){
              case ERROR_BAD_JSON:
                displayError(STRING_ERROR_WITH_JSON);
                break;
              case ERROR_WEB_API_UNREACHABLE:
                displayError(STRING_FEED_WEB_API_NOT_REACHABLE);
                break;
              case ERROR_WITH_DATABASE:
                displayError(STRING_ERROR_WITH_DATABASE);
                break;
              case ERROR_MISSING_DATA:
                displayError(STRING_ERROR_MISSING_DATA);
                break;
            }
          });
        }
      );
    } else {
      displayNotSuitableBrowser();
    }
    // Start the service worker
    if ('serviceWorker' in navigator){
      navigator.serviceWorker.register('./serviceworker.js')
      .then(function(registration) {
        console.log('Service Worker: registration successful with scope: ', registration.scope);
      }, function(err) {
        console.error('Service Worker: registration failed: ', err);
      });
    }
  }


  /* **************** *
  * Define functions *
  * **************** *

  /**
  * Cut and pate valeus of fields which can be displaye dor hidden according to the screen size.
  */
  function moveVolatileFieldsValues(){

    // Save the previously-used values : input field
    let inputKeywordBigScreen = document.getElementsByClassName("keywords")[0];
    let inputKeywordSmallScreen = document.getElementsByClassName("keywords")[1];
    let keywords = (inputKeywordBigScreen.value != "" ? inputKeywordBigScreen.value : inputKeywordSmallScreen.value );

    // Save the previously-used values : output paragraph
    let outputSearchBigScreen = document.getElementsByClassName("output")[0];
    let outputSearchSmallScreen = document.getElementsByClassName("output")[1];
    let outputsColor = (outputSearchBigScreen.style.color != "" ? outputSearchBigScreen.style.color : outputSearchSmallScreen.style.color );
    let outputsFontWeight = (outputSearchBigScreen.style.fontWeight != "" ? outputSearchBigScreen.style.fontWeight : outputSearchSmallScreen.style.fontWeight );
    let outputs = (outputSearchBigScreen.innerHTML != "" ? outputSearchBigScreen.innerHTML : outputSearchSmallScreen.innerHTML );

    // Is the main header displayed?
    let mainHeader = document.getElementById("mainHeader");
    let isMainheaderDisplayed = (window.getComputedStyle(mainHeader).getPropertyValue("display") != "none");

    inputKeywordBigScreen.value = (isMainheaderDisplayed ? keywords : "");
    outputSearchBigScreen.innerHTML = (isMainheaderDisplayed ? outputs : "");
    outputSearchBigScreen.style.color = (isMainheaderDisplayed ? outputsColor : "");
    outputSearchBigScreen.style.fontWeight = (isMainheaderDisplayed ? outputsFontWeight : "");
    inputKeywordSmallScreen.value = (!isMainheaderDisplayed ? keywords : "");
    outputSearchSmallScreen.innerHTML = (!isMainheaderDisplayed ? outputs : "");
    outputSearchSmallScreen.style.color = (!isMainheaderDisplayed ? outputsColor : "");
    outputSearchSmallScreen.style.fontWeight = (!isMainheaderDisplayed ? outputsFontWeight : "");

  } // End of function moveVolatileFieldsValues()
