/*
 * Software Name: Tips'n'tools
 * SPDX-FileCopyrightText: Copyright (c) 2016-2023 Pierre-Yves Lapersonne
 * SPDX-License-Identifier: MIT
 */
// ✿✿✿✿ ʕ •ᴥ•ʔ/ ︻デ═一

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
