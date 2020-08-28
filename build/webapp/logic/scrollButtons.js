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
