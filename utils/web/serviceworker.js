/*
 * Software Name: Tips'n'tools
 * SPDX-FileCopyrightText: Copyright (c) 2016-2023 Pierre-Yves Lapersonne
 * SPDX-License-Identifier: MIT
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
