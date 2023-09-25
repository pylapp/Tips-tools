/*
 * Software Name: Tips'n'tools
 * SPDX-FileCopyrightText: Copyright (c) 2016-2023 Pierre-Yves Lapersonne
 * SPDX-License-Identifier: MIT
 */
// ✿✿✿✿ ʕ •ᴥ•ʔ/ ︻デ═一

/**
* @file scrollButtons.js
* @brief JavaScript glue for button to use to scroll to top or bottom
* @author Pierre-Yves Lapersonne
* @version 1.0.0
* @since 10/12/2017
*/

"use strict";

/**
 * Displays or hides the scroll-to-top button
 */
function initNavigationButtons() {
    let threshold = 20;
    if ( document.body.scrollTop > threshold || document.documentElement.scrollTop > threshold ){
        document.getElementById("navigationToBottomButton").style.display = "none";
        document.getElementById("navigationToTopButton").style.display = "block";
    } else {
        document.getElementById("navigationToTopButton").style.display = "none";
        document.getElementById("navigationToBottomButton").style.display = "block";
    }
}

/**
 * Scrolls to the top of the document
 */
function scrollToTop() {
    scrollTo(document.getElementById("padder").offsetTop, 2000);
}

/**
 * Scrolls to the bottom of the document
 */
function scrollToBottom() {
    scrollTo(document.getElementById("footer").offsetTop, 2000);
}
