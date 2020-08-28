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
  * @file webworker.js
  * @brief JavaScript file defining the web worker which processes a filtering operation in a copy of the DOM
  * @author Pierre-Yves Lapersonne
  * @version 1.0.0
  * @since 06/03/2018
  */

  "use strict";

  importScripts("config.js");

  /**
  * An error message to use if there are parameters is not suitable number
  */
  const ERROR_BAD_NUMBER_OF_PARAMETERS = "Error: bad number of parameters for this worker"

  /**
  * The possible actions to do with this web workers
  */
  let ActionsEnum = Object.freeze({
    RESET_CONTENT: "filter-webworker.RESET_CONTENT",
    FILTER_ALL_CONTENT: "filter-webworker.FILTER_ALL_CONTENT",
    FILTER_PART_OF_CONTENT: "filter-webworker.FILTER_PART_OF_CONTENT"
  });

  /**
  * The possible targets / stores of data
  */
  let StoresEnum = Object.freeze({
    TOOLS: "filter-webworker.TOOLS",
    REFERENCES: "filter-webworker.REFERENCES",
    DEVICES: "filter-webworker.DEVICES",
    SOCS: "filter-webworker.SOCS"
  });

  /**
  * Callback triggered when the web worker receives a message.
  * The arguments must have several elements :
  *  1 - the name of the operation to process (in ActionsEnum)
  *  2 - an addtionnal elements if needed, or null
  *  3 - an addtionnal elements if needed, or null
  */
  onmessage = function(args) {

    if (args.length < 1 || args.length > 3) {
      console.log(ERROR_BAD_NUMBER_OF_PARAMETERS);
      postMessage(ERROR_BAD_NUMBER_OF_PARAMETERS);
      return;
    }

    let action = args.data[0];

    // Reset the document
    if (action == ActionsEnum.RESET_CONTENT) {

      let tools, references, devices, socs;
      // Get asynchronously the data
      readTools().then(function(resTools){
        tools = resTools;
        return readReferences();
      }).then(function(resRefs){
        references = resRefs;
        return readDevices();
      }).then(function(resDevices){
        devices = resDevices;
        return readSocs();
      }).then(function(resSocs){
        socs = resSocs;
        // Post the results to the main thread
        postMessage([tools, references, devices, socs]);
      });

    }

    // Filter all the document's tables
    if (action == ActionsEnum.FILTER_ALL_CONTENT) {

      let filterPattern = args.data[1];

      let tools, references, devices, socs;

      // Get asynchronously the data
      readTools().then(function(res){
        tools = res;
        tools = filterTools(tools, filterPattern);
        return readReferences();
      }).then(function(res){
        references = res;
        references = filterReferences(references, filterPattern);
        return readDevices();
      }).then(function(res){
        devices = res;
        devices = filterDevices(devices, filterPattern);
        return readSocs();
      }).then(function(res){
        socs = res;
        socs = filterSocs(socs, filterPattern);
        // Post the results to the main thread
        postMessage([tools, references, devices, socs]);
      });

    } // End of if (action == ActionsEnum.FILTER_ALL_CONTENT)

    // Filter a certain table in the document
    if (action == ActionsEnum.FILTER_PART_OF_CONTENT) {

      let target = args.data[1];
      let filter = args.data[2];

      // Get the good data
      let dataPromise;
      switch (target){
        case StoresEnum.TOOLS:
          dataPromise = readTools();
          break;
        case StoresEnum.REFERENCES:
          dataPromise = readReferences();
          break;
        case StoresEnum.DEVICES:
          dataPromise = readDevices();
          break;
        case StoresEnum.SOCS:
          dataPromise = readSocs();
          break;
      }

      dataPromise.then(function(res){
        let data;
        // Filter the data
        switch (target){
          case StoresEnum.TOOLS:
            data = filterTools(res, filter);
            break;
          case StoresEnum.REFERENCES:
            data = filterReferences(res, filter);
            break;
          case StoresEnum.DEVICES:
            data = filterDevices(res, filter);
            break;
          case StoresEnum.SOCS:
            data = filterSocs(res, filter);
            break;
        }
        // Post the results
        postMessage([data]);
      });

    }

  } // End of if (action == ActionsEnum.FILTER_PART_OF_CONTENT)

  /**
  * Reads the store containing the tools objects in the database
  * @return Promise - The promise which encapsulates the future-and-asynchronously-gotten the data
  */
  function readTools(){
    return readInStore(OBJECT_STORE_TOOLS);
  } // End of function readTools()

  /**
  * Reads the store containing the references objects in the database
  * @return Promise - The promise which encapsulates the future-and-asynchronously-gotten the data
  */
  function readReferences(){
    return readInStore(OBJECT_STORE_REFERENCES);
  } // End of function readReferences()

  /**
  * Reads the store containing the devices objects in the database
  * @return Promise - The promise which encapsulates the future-and-asynchronously-gotten the data
  */
  function readDevices(){
    return readInStore(OBJECT_STORE_DEVICES);
  } // End of function readDevices()

  /**
  * Reads the store containing the SoC objects in the database
  * @return Promise - The promise which encapsulates the future-and-asynchronously-gotten the data
  */
  function readSocs(){
    return readInStore(OBJECT_STORE_SOCS);
  } // End of function readSocs()

  /**
  * Reads in the good store
  * @param store - The store of the database to read in
  * @return Promise - The readd operation encapsulated in a promise
  */
  function readInStore(store){
    return new Promise(function(resolve, reject){

      // Open the database
      let openRequest = indexedDB.open(DATABASE_NAME, DATABASE_VERSION);

      openRequest.onerror = function(event) {
        console.error("Database error: "+event)
      };

      // When access granted, read the content of the database
      openRequest.onsuccess = function(event) {

        let database = event.target.result;
        database.onerror = function(event) {
          console.error("Database error: " + event.target.errorCode);
        };

        // Create the transaction
        let transaction = database.transaction([store]);
        let objectStore = transaction.objectStore(store);
        let readRequest = objectStore.getAll();
        readRequest.onerror = function(event) {
          console.error("Database error: during read of store: "+event);
          reject(ERROR_READ_STORES);
        };
        readRequest.onsuccess = function(event) {
          let results = readRequest.result;
          resolve(results);
        }

      }; // End of openRequest.onsuccess = function(event)

    }); // End of return new Promise(function(resolve, reject)

  }// End of function readInStore(store)

  /**
  * Filter in a set of tools using a filter
  * @param data - The data to process (tools gotten from database as JSON objets)
  * @param filterPattern - The filter to apply
  */
  function filterTools(data, filterPattern){

    let keywords;
    // Several worlds
    if (filterPattern.includes(" ")){
      keywords = filterPattern.split(" ");
      // One word
    } else {
      keywords = [filterPattern];
    }

    let resultingData = data.filter(
      (tool) => {
        let bigString = toolAsString(tool);
        let matchFound = true;
        for (let keyword in keywords){
          if (!bigString.toLowerCase().includes(keywords[keyword].toLowerCase())){
            matchFound = false;
            break;
          }
        }
        return matchFound;
      }
    );

    return resultingData;

  } // End of function filterTools(data, filter)

  /**
  * Filter in a set of references using a filter
  * @param data - The data to process (references gotten from database as JSON objets)
  * @param filterPattern - The filter to apply
  */
  function filterReferences(data, filterPattern){

    let keywords;
    // Several worlds
    if (filterPattern.includes(" ")){
      keywords = filterPattern.split(" ");
      // One word
    } else {
      keywords = [filterPattern];
    }

    let resultingData = data.filter(
      (reference) => {
        let bigString = referenceAsString(reference);
        let matchFound = true;
        for (let keyword in keywords){
          if (!bigString.toLowerCase().includes(keywords[keyword].toLowerCase())){
            matchFound = false;
            break;
          }
        }
        return matchFound;
      }
    );

    return resultingData;

  } // End of function filterReferences(data, filter)

  /**
  * Filter in a set of devices using a filter
  * @param data - The data to process (devices gotten from database as JSON objets)
  * @param filterPattern - The filter to apply
  */
  function filterDevices(data, filterPattern){

    let keywords;
    // Several worlds
    if (filterPattern.includes(" ")){
      keywords = filterPattern.split(" ");
      // One word
    } else {
      keywords = [filterPattern];
    }

    let resultingData = data.filter(
      (device) => {
        let bigString = deviceAsString(device);
        let matchFound = true;
        for (let keyword in keywords){
          if (!bigString.toLowerCase().includes(keywords[keyword].toLowerCase())){
            matchFound = false;
            break;
          }
        }
        return matchFound;
      }
    );

    return resultingData;

  } // End of function filterDevices(data, filter)

  /**
  * Filter in a set of SoCs using a filter
  * @param data - The data to process (SoCs gotten from database as JSON objets)
  * @param filterPattern - The filter to apply
  */
  function filterSocs(data, filterPattern){

    let keywords;
    // Several worlds
    if (filterPattern.includes(" ")){
      keywords = filterPattern.split(" ");
      // One word
    } else {
      keywords = [filterPattern];
    }

    let resultingData = data.filter(
      (soc) => {
        let bigString = socAsString(soc);
        let matchFound = true;
        for (let keyword in keywords){
          if (!bigString.toLowerCase().includes(keywords[keyword].toLowerCase())){
            matchFound = false;
            break;
          }
        }
        return matchFound;
      }
    );

    return resultingData;

  } // End of function filterSocs(data, filter)

  /**
  * Converts a tool object, as JSON object, to a searchable string
  * @param tool - The object to convert
  */
  function toolAsString(tool){
    return JSON.stringify(tool);
  } // End of function toolAsString(tool)

  /**
  * Converts a reference object, as JSON object, to a searchable string
  * @param reference - The object to convert
  */
  function referenceAsString(reference){
    return JSON.stringify(reference);
  } // End of function referenceAsString(reference)

  /**
  * Converts a device object, as JSON object, to a searchable string
  * @param device - The object to convert
  */
  function deviceAsString(device){
    return JSON.stringify(device);
  } // End of function deviceAsString(device)

  /**
  * Converts a SoC object, as JSON object, to a searchable string
  * @param soc - The object to convert
  */
  function socAsString(soc){
    return JSON.stringify(soc);
  } // End of function socAsString(soc)
