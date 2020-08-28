  /*
  MIT License
  Copyright (c) 2016-2020 Pierre-Yves Lapersonne (Mail: dev@pylapersonne.info)
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
  * @file indexeddb.js
  * @brief JavaScript file which handles storage features with IndexedDB
  * @author Pierre-Yves Lapersonne
  * @version 1.1.0
  * @since 06/03/2018
  */

 "use strict";

 /* ********* *
 * Functions *
 * ********* */

 /**
 * Initiliazes the database by creating it and populating it
 * @return The promise which will initilaizes the database and populate it
 */
 function initDatabase(){

   return new Promise(function(resolve, reject){

     console.log("Database: initializing");

     let request = indexedDB.open(DATABASE_NAME, DATABASE_VERSION);

     // Defines a clalback in case of error
     request.onerror = function(event) {
       console.error("Database error: "+event)
     };

     // Defines a callback in case of success
     request.onsuccess = function(event) {
       //console.log("Database: [on init] success of request " + database);

       let database = event.target.result;

       database.onerror = function(event) {
         console.error("Database error: " + event.target.errorCode);
         reject(ERROR_WITH_DATABASE);
       };

       let feedData = null;

       // Step 1 - Get the data
       getDataFromFeed()
       .then(
         // In case of success of the previous promise (network request)
         function(gottenDataAsTextJson){
           // Step 2 - Clean up the database before add new data
           resetDataStores(database);
           // Step 3 - Populate the tools
           try {
             if ( gottenDataAsTextJson == "" ){
               console.error("No JSON data has been picked");
               displayErrorWithJsonContent(STRING_ERROR_NO_DATA_FOUND);
               reject(ERROR_MISSING_DATA);
               return;
             }
             feedData = JSON.parse(gottenDataAsTextJson);
             // Should be an array with 4 items (for the 4 types of data whicha re tools, web things, devices, and SoC)
             if ( feedData == null || feedData.length <= 0 ){
               console.error("JSON data (tools) has been picked but parsing returns empty or undefined content");
               displayErrorWithJsonContent(STRING_ERROR_NO_DATA_FOUND);
               reject(ERROR_MISSING_DATA);
               return;
             }
           } catch (error) {
             console.error("An unexpected error occured");
             console.error(error);
             displayErrorWithJsonContent(error);
             reject(ERROR_BAD_JSON);
             return;
           }
           console.log("Feed: gotten data from Web API");
           return populateDatabaseOfTools(database, feedData[0]);
         },
         // In case of failure of the previous promise (network request)
         function (error){
             console.error("An unexpected error occured: " + error);
             displayErrorWithJsonContent(STRING_ERROR_WITH_JSON);
             reject(ERROR_WEB_API_UNREACHABLE);
         }
       )
       // Step 4 - Populate the references of web things
       .then(
         function(res){
           if ( feedData == null || feedData.length <= 0 ){
             console.error("JSON data (web references) has been picked but parsing returns empty or undefined content");
             displayErrorWithJsonContent(STRING_ERROR_NO_DATA_FOUND);
             reject(ERROR_MISSING_DATA);
             return;
           } else {
             console.log("Database: store of tools populated");
             return populateDatabaseOfReferences(database, feedData[1]);
           }
         },
         function (error){
           reject(error);
         }
       )
       // Step 5 - Populate the devices
       .then(
         function(res){
           if ( feedData == null || feedData.length <= 0 ){
             console.error("JSON data (devices) has been picked but parsing returns empty or undefined content");
             displayErrorWithJsonContent(STRING_ERROR_NO_DATA_FOUND);
             reject(ERROR_MISSING_DATA);
             return;
           } else {
             console.log("Database: store of references populated");
             return populateDatabaseOfDevices(database, feedData[2]);
           }
         },
         function (error){
           reject(error);
         }
       )
       // Step 6 - Populate the SoCs
       .then(
         function(res){
           if ( feedData == null || feedData.length <= 0 ){
             console.error("JSON data (SoC) has been picked but parsing returns empty or undefined content");
             displayErrorWithJsonContent(STRING_ERROR_NO_DATA_FOUND);
             reject(ERROR_MISSING_DATA);
             return;
           } else {
             console.log("Database: store of devices populated");
             return populateDatabaseOfSocs(database, feedData[3]);
           }
         },
         function (error){
           reject(error);
         }
       )
       // All is done :)
       .then(
         function(res){
           console.log("Database: store of SoCs populated");
           resolve();
         },
         function (error){
           console.error("Unexpected error");
           console.error(error);
           reject(error);
         }
       );

     };

     // Defines a callback triggered when the database is being created or being updated
     request.onupgradeneeded = function(event) {
       let database = event.target.result;
       //console.log("Database: [on init] update needed: "+database)
       defineStoreForTools(database);
       defineStoreForReferences(database);
       defineStoreForDevices(database);
       defineStoreForSocs(database);
     };

   });

 }

 /**
 * Checks if the browser in use can deal with storage, here based on IndexedDB
 * @return True if supporte, false otherwise
 */
 function checkIfStorageSupported(){
   return indexedDB;
 }

 /**
 * Defines the store in the database which will contain the tools' references.
 * It will define an indexed using the schema of the dedicated JSON file.
 * @param database - The reference to the database to use
 */
 function defineStoreForTools(database){
   console.log("Database: defining store for tools");
   let objectStore = database.createObjectStore(OBJECT_STORE_TOOLS, {autoIncrement: true});
   objectStore.createIndex("ToolsIndex",[
     "platform",
     "name",
     "description",
     "keywords",
     "url"
   ]);
 }

 /**
 * Defines the store in the database which will contain the references' references
 * It will define an indexed using the schema of the dedicated JSON file.
 * @param database - The reference to the database to use
 */
 function defineStoreForReferences(database){
   console.log("Database: defining store for references");
   let objectStore = database.createObjectStore(OBJECT_STORE_REFERENCES, {autoIncrement: true});
   objectStore.createIndex("ReferencesIndex",[
     "platform",
     "name",
     "description",
     "keywords",
     "url"
   ]);
 }

 /**
 * Defines the store in the database which will contain the devices' references
 * It will define an indexed using the schema of the dedicated JSON file.
 * @param database - The reference to the database to use
 */
 function defineStoreForDevices(database){
   console.log("Database: defining store for devices");
   let objectStore = database.createObjectStore(OBJECT_STORE_DEVICES, {autoIncrement: true});
   objectStore.createIndex("DevicesIndex",[
     "type",
     "os",
     "constructorName",
     "name",
     "screensize",
     "screentype",
     "screenresolution",
     "soc",
     "gpu",
     "sensors",
     "battery",
     "storage",
     "ram",
     "camera",
     "dimensions",
     "usbtype",
     "weight",
     "ip",
     "sdcard",
     "sim",
     "ui"
   ]);
 }

 /**
 * Defines the store in the database which will contain the SoC' references
 * It will define an indexed using the schema of the dedicated JSON file.
 * @param database - The reference to the database to use
 */
 function defineStoreForSocs(database){
   console.log("Database: defining store for SoCs");
   let objectStore = database.createObjectStore(OBJECT_STORE_SOCS, {autoIncrement: true});
   objectStore.createIndex("SocsIndex",[
     "constructorName",
     "target",
     "name",
     "gravure",
     "modem",
     "peakdownloadspeed",
     "peakuploadspeed",
     "bluetooth",
     "nfc",
     "usb",
     "camerasupportmax",
     "videocapturemax",
     "videoplaybackmax",
     "displaymax",
     "cpu",
     "cpucoresnumber",
     "cpuclockspeedmax",
     "cpuarchitecture",
     "gpu",
     "gpuapisupport",
     "aisupport"
   ]);
 }

 /**
 * Populates the database of "tools" objects using a JSON file in ressources
 * @param database - The database to use
 * @param dataToAdd - The data to add in the database, as JSON object
 * @return The promise which will process all these things
 */
 function populateDatabaseOfTools(database, dataToAdd){
   console.log("Database: populating database of tools");
   return new Promise(function(resolve,reject){
       for (var i = 0; i < dataToAdd.length; i++) {
         // Prepare the transaction
         let transaction = database.transaction([OBJECT_STORE_TOOLS], "readwrite");
         let store = transaction.objectStore(OBJECT_STORE_TOOLS);
         // Push data in the dataabse using the JSON loaded from the resource file
         var request = store.put({
           id:i,
           platform: dataToAdd[i].platform,
           name:dataToAdd[i].name,
           description:dataToAdd[i].description,
           keywords:dataToAdd[i].keywords,
           url:dataToAdd[i].url
         });
         request.onsuccess = function(event) {
           //console.log("Database: [on populating tools] new entry added")
           resolve();
         };
         transaction.oncomplete = function(event){
           //console.log("Database: [on populating tools] transaction done");
           //database.close();
         }
         transaction.onerror = function(event) {
           console.error("Database error: [on populating tools] with transaction:"+event);
           reject(ERROR_TRANSACTION_POPULATE_TOOLS);
           database.close();
         };
       }
   });
 }

 /**
 * Populates the database of "references" objects using a JSON file in ressources
 * @param database - The database to use
 * @param dataToAdd - The data to add in the database, as JSON object
 * @return The promise which will process all these things
 */
 function populateDatabaseOfReferences(database, dataToAdd){
   console.log("Database: populating database of references");
   return new Promise(function(resolve,reject){
       for (var i=0; i < dataToAdd.length; i++) {
         let element = dataToAdd[i];
         // Prepare the transaction
         let transaction = database.transaction([OBJECT_STORE_REFERENCES], "readwrite");
         let store = transaction.objectStore(OBJECT_STORE_REFERENCES);
         // Push data in the database using the JSON loaded from the resource file
         var request = store.put({
           id:i,
           platform: element.platform,
           name: element.name,
           description: element.description,
           keywords: element.keywords,
           url: element.url
         });
         request.onsuccess = function(event) {
           //console.log("Database: [on populating references] new entry added")
           resolve();
         };
         transaction.oncomplete = function(event){
           //console.log("Database: [on populating references] transaction done");
           //database.close();
         }
         transaction.onerror = function(event) {
           console.error("Database error: [on populating references] with transaction:"+event);
           reject(ERROR_TRANSACTION_POPULATE_REFERENCES);
           database.close();
         };
       }
   });
 }

 /**
 * Populates the database of "devices" objects using a JSON file in ressources
 * @param database - The database to use
 * @param dataToAdd - The data to add in the database, as JSON object
 * @return The promise which will process all these things
 */
 function populateDatabaseOfDevices(database, dataToAdd){
   console.log("Database: populating database of devices");
   return new Promise(function(resolve,reject){
       for (var i=0; i < dataToAdd.length; i++) {
         let element = dataToAdd[i];
         // Prepare the transaction
         let transaction = database.transaction([OBJECT_STORE_DEVICES], "readwrite");
         let store = transaction.objectStore(OBJECT_STORE_DEVICES);
         // Push data in the dataabse using the JSON loaded from the resource file
         var request = store.put({
           id:i,
           type: element.type,
           os: element.os,
           constructorName: element.constructorName,
           name: element.name,
           screensize: element.screensize,
           screentype: element.screentype,
           screenresolution: element.screenresolution,
           soc: element.soc,
           gpu: element.gpu,
           sensors: element.sensors,
           battery: element.battery,
           storage: element.storage,
           ram: element.ram,
           camera: element.camera,
           dimensions: element.dimensions,
           usbtype: element.usbtype,
           weight: element.weight,
           ip: element.ip,
           sdcard: element.sdcard,
           sim: element.sim,
           ui: element.ui
         });
         request.onsuccess = function(event) {
           //console.log("Database: [on populating devices] new entry added")
           resolve();
         };
         transaction.oncomplete = function(event){
           //console.log("Database: [on populating devices] transaction done");
           //database.close();
         }
         transaction.onerror = function(event) {
           console.error("Database error: [on populating devices] with transaction:"+event);
           reject(ERROR_TRANSACTION_POPULATE_DEVICES);
           database.close();
         };
       }
   });
 }

 /**
 * Populates the database of "socs" objects
 * @param database - The database to use
 * @param dataToAdd - The data to add in the database, as JSON object
 * @return The promise which will process all these things
 */
 function populateDatabaseOfSocs(database, dataToAdd){
   console.log("Database: populating database of SoCs");
   return new Promise(function(resolve,reject){
       for (var i=0; i < dataToAdd.length; i++) {
         // Prepare the transaction
         let transaction = database.transaction([OBJECT_STORE_SOCS], "readwrite");
         let store = transaction.objectStore(OBJECT_STORE_SOCS);
         // Push data in the dataabse using the JSON loaded from the resource file
         let element = dataToAdd[i];
         var request = store.put({
           id:i,
           constructorName: element.constructorName,
           target: element.target,
           name: element.name,
           gravure: element.gravure,
           modem: element.modem,
           peakdownloadspeed: element.peakdownloadspeed,
           peakuploadspeed: element.peakuploadspeed,
           bluetooth: element.bluetooth,
           nfc: element.nfc,
           usb: element.usb,
           camerasupportmax: element.camerasupportmax,
           videocapturemax: element.videocapturemax,
           videoplaybackmax: element.videoplaybackmax,
           displaymax: element.displaymax,
           cpu: element.cpu,
           cpucoresnumber: element.cpucoresnumber,
           cpuclockspeedmax: element.cpuclockspeedmax,
           cpuarchitecture: element.cpuarchitecture,
           gpu: element.gpu,
           gpuapisupport: element.gpuapisupport,
           aisupport: element.aisupport
         });
         request.onsuccess = function(event) {
           //console.log("Database: [on populating socs] new entry added")
           resolve();
         };
         transaction.oncomplete = function(event){
           //console.log("Database: [on populating socs] transaction done");
           //database.close();
         }
         transaction.onerror = function(event) {
           console.error("Database error: [on populating socs] with transaction:"+event);
           database.close();
           reject(ERROR_TRANSACTION_POPULATE_SOCS);
         };
       }
   });
 }

 /**
 * Resets the stores of the database containg the references of tools,w eb links, devices and SoCs
 * @param database - The database to reset
 */
 function resetDataStores(database){

   console.log("Database: reseting...");

   database.transaction([OBJECT_STORE_TOOLS],"readwrite").objectStore(OBJECT_STORE_TOOLS).clear();
   database.transaction([OBJECT_STORE_REFERENCES],"readwrite").objectStore(OBJECT_STORE_REFERENCES).clear();
   database.transaction([OBJECT_STORE_DEVICES],"readwrite").objectStore(OBJECT_STORE_DEVICES).clear();
   database.transaction([OBJECT_STORE_SOCS],"readwrite").objectStore(OBJECT_STORE_SOCS).clear();

 } // End of function resetDataStores()

 /**
 * Retrieves a JSON ressource from a web API which feeds all the data to store
 * @return Promise - The promise which encapsulates the request
 */
 function getDataFromFeed(){
   return new Promise(function(resolve, reject) {
     // Prepare the request to get the ressources file
     var xobj = new XMLHttpRequest();
     xobj.overrideMimeType("application/json");
     xobj.open('GET', DATA_FEED_API, true);
     xobj.responseType = 'text';
     xobj.onreadystatechange = function() {
       if (xobj.readyState == 4) {
         if (xobj.status == 200){
           let jsonDataAsText = xobj.responseText;
           resolve(jsonDataAsText);
         } else {
           reject(ERROR_NETWORK_REQUEST_DURING_SEND);
         }
       }
     }
     xobj.onerror = function(){
         console.error("Error during request sending");
         displayFeedError();
         reject(ERROR_NETWORK_REQUEST_DURING_SEND);
     }
     // Send the request to get the data
     try {
         xobj.send(null);
     } catch (error){
         console.error("Error during request sending: "+error);
         reject(ERROR_NETWORK_REQUEST_DURING_SEND);
     }
   });
 }

 // NOTE: In future versions, filtering request may come ;-)
