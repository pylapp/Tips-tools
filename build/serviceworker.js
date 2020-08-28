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
* @file serviceworker.js
* @brief A service worker to use as a cache system in case of missing Internet / data / network connection
*       Please note that you must serve this web app through HTTPS or localhost so as to use Service Workers.
* @author Pierre-Yves Lapersonne
* @version 2.1.0
* @since 22/03/2018
*/

"use strict";

let CACHE_NAME = 'tipsntools-cache-v3';
let urlsToCache = [

  './',

  './webapp/styles/devices.css',
  './webapp/styles/filter.css',
  './webapp/styles/global.css',
  './webapp/styles/header.css',
  './webapp/styles/medias.css',
  './webapp/styles/navigationButtons.css',
  './webapp/styles/references.css',
  './webapp/styles/socs.css',
  './webapp/styles/tables.css',
  './webapp/styles/tools.css',

  './webapp/pictures/favicon.png',
  './webapp/pictures/logo.svg',
  './webapp/pictures/navigation-down.svg',
  './webapp/pictures/navigation-up.svg',

  './webapp/logic/adapter.js',
  './webapp/logic/config.js',
  './webapp/logic/strings.js',
  './webapp/logic/glue.js',
  './webapp/logic/indexeddb.js',
  './webapp/logic/scrollButtons.js',
  './webapp/logic/smoothScroll.js',
  './webapp/logic/webworker.js',
  './webapp/logic/window.js'

];

/**
 * When the Service Worker in installing
 */
self.addEventListener('install', function(event) {
  event.waitUntil(
      caches.open(CACHE_NAME).then(function(cache) {
          console.log('Service Worker: opened cache');
          return cache.addAll(urlsToCache);
        })
    );
});

/**
 * When the Service Worker is fetching resources
 */
self.addEventListener('fetch', function(event) {
  event.respondWith(
    caches.match(event.request).then(function(response) {
        console.log('Service Worker: fetch something - '+event.request);
        // Cache hit - return response
        if (response) {
          return response;
        }
        // Clone it to consume the request 2 times (by cache and by browser)
        let fetchRequest = event.request.clone();
        console.log('Service Worker: fetch something - '+fetchRequest);
        return fetch(fetchRequest).then(
          function(response) {
            // Check if we received a valid response
            if(!response || response.status !== 200 || response.type !== 'basic') {
              console.log('Service Worker: fetch response '+response);
              return response;
            }
            // Clone it to consume the reponse 2 times (by cache and by browser)
            var responseToCache = response.clone();
            caches.open(CACHE_NAME).then(function(cache) {
                console.log('Service Worker: response to cache - '+responseToCache);
                cache.put(event.request, responseToCache);
            });
            return response;
          } // End of function(response)
        ); // End of return fetch(fetchRequest).then
      })
    ); // End of event.respondWith
  });
