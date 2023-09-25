# CHANGELOG

## v15.0.0

### Bugs

- [#7](https://github.com/pylapp/Tips-tools/issues/7) Pick hard-coded fixes and improve versions

### Changes

- [#15](https://github.com/pylapp/Tips-tools/issues/15) Add dry-run script 
- [#10](https://github.com/pylapp/Tips-tools/issues/10) Deal with GNU/Linux and macOS primitives
- Improve check of URL in CSV files
- Update sources headers

## v14.3.3

_This version is dedicated to macOS users, and is based on v14.3.2_

New bug fixes:

	* More details in help message and documentation
	* More logs in case of errors for web app logic
	* More logs during scripts executions
	* Add controls for script executions and failures

Related issues:

	* #5

## v14.3.2

_This version is dedicated to macOS users, and is based on v14.3.1_

Some bug fixes and improvements have been brought to make the project working on macOS:

	* Resume the macOS migration for the other scripts (uses of 'sed' command to produce HTML files)

_However following improvements can be brought for GNU/Linux users_ 

	* In _tipsntools.sh_ script: refactor of "count" feature
	* In _tipsntools.sh_ script: improve help

## v14.3.1

_This version is dedicated to macOS users, and is based on v14.3.0_

Some bug fixes and improvements have been brought to make the project working on macOS:

	* Refactor functions based on 'sed' command
	* Refactor functions based on MD5 and SHA1 checksums commands
	* Refactor functions based on 'truncate' commands
	* Check if metadata file exist before dealing with it

## v14.3.0

_This version id dedicated to GNU/Linux users_

Data generation time may be faster:

	* HTML and JSON files are updated if and only if their original content has been changed
	* to do so, checksums are registered in a metadata file to check if produced data (in CSV) have been updated or not

The data generation time is computed and displayed.

## v14.2.0
  - Feat: Deal with Ruby-related items

## v14.1.1
  - Fix: Cache and manifest so as to make the web app installable

## v14.1.0
  - Feature: now use local database's contents if feed Web API unreachable. More offline.
  - Refactor: icons
  - Style: cleaner sources

## v14.0.0
  - Feature: generate JSON files besides HTML files based from CSV files
  - Feature: Progressive Web App (PWA) / Single Page Application (SPA) / Web App (WA) / shiny-buzzword-web-app-from-hell (SBWAFH) to make queries
  - Chore: controls to checks browsers in both web app and global web page
  - Note: cooler, smarter, more beautiful

## v13.0.0
  - Feature: elapsed time is displyaed after each request
  - Feature: "help" feature when typing '?' in the web view's search bar
  - Feature: "show all" feature when typing '\*' in the web view's search bar
  - Feature: filter contents by sections
  - Documentation: whatsnew

## v12.3.0
  - Feature: "Test" topic is now referenced  
  - Feature: "Security" topic is now referenced

## v12.2.0
  - Feature: "Data" topic is now referenced

## v12.1.0
  - Chore: optimized HTML code
  - Feature: Small screens are managed with web view
  - Feature: "Dapp" topic is now referenced

## v12.0.0  
  - Refactor: file tree
  - Refacor: web view with a more material design rendering
  - Chore: improved source code

## v11.0.0  
  - Feature: better web view, more W3C compliant

## v10.0.0  
  - Feature: web page providing search bar

## v9.1.1  
  - Documentation: improved README.md

## v9.1.0  
  - Feature: controls of Shell  

## v9.0.3  
  - Feature: better metrics / statistics

## v9.0.2  
 - Feature: compute metrics / statistics about subjects
 - Feature: URL checking (if the content is still reachable)
 - Feature: move to bash
