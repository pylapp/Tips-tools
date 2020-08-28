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
* @file smoothScroll.js
* @brief JavaScript glue for smooth scrolling. Picked from (http://www.trucsweb.com/tutoriels/javascript/defilement_doux/)
* @author Pierre-Yves Lapersonne
* @version 1.0.0
* @since 10/12/2017
*/

"use strict";

/**
 * Scrolls to _element_ in _duration_ milliseconds
 */
function scrollTo( element, duration ){
  let e = document.documentElement;
  if ( e.scrollTop === 0 ){
    let t = e.scrollTop;
    ++e.scrollTop;
    e = t+1 === e.scrollTop-- ? e : document.body;
  }
  scrollToC(e, e.scrollTop, element, duration);
}

/**
 *
 */
function scrollToC( element, from, to, duration ){
  if (duration < 0) return;
  if (typeof from === "object") from = from.offsetTop;
  if (typeof to === "object") to = to.offsetTop;
  scrollToX(element, from, to, 0, 1/duration, 20, easeOutCuaic);
}

/**
 *
 */
function scrollToX( element, x1, x2, t, v, step, animation ){
  if (t < 0 || t > 1 || v <= 0) return;
  element.scrollTop = x1 - (x1-x2)*animation(t);
  t += v * step;
  setTimeout(function() {
    scrollToX(element, x1, x2, t, v, step, animation);
  }, step);
}

/**
 *
*/
function easeOutCuaic(t){
  t--;
  return t*t*t+1;
}
