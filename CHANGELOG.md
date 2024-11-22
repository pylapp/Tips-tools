# Tips'n'tools library changelog

All notable changes to this project will be documented in this file.
The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased](https://github.com/pylapp/Tips-tools/compare/15.1.1...dev)

### Changed

- Various little cleanings ([#28](https://github.com/pylapp/Tips-tools/issues/28))

## [15.1.1](https://github.com/pylapp/Tips-tools/compare/15.1.0...15.1.1) - 2024-08-10

### Fixed

- Hotfix: polluted output results for socz and devz because of regex with $ symbol

### Changed

- Add FUNDING
- Semver for CHANGELOG

## [15.1.0] - 2023-09-26

### Fixed

- Fix doctor script

### Changed

- Update documentation (doctor, licenses, support, wiki)

## [15.0.0] - 2023-09-25

### Fixed

- Pick hard-coded fixes and improve versions ([#7](https://github.com/pylapp/Tips-tools/issues/7))

### Changed

- Add dry-run script ([#15](https://github.com/pylapp/Tips-tools/issues/15))
- Deal with GNU/Linux and macOS primitives ([#10](https://github.com/pylapp/Tips-tools/issues/10))
- Add CC-BY license for generated and ODS file ([#14](https://github.com/pylapp/Tips-tools/issues/14))
- Improve check of URL in CSV files
- Update sources headers
- Refactor file tree
- Add DCO, codes of conduct and conflict, security and citation files

## [14.3.3] - 2023-08-28

_This version is dedicated to macOS users, and is based on v14.3.2_

### Changed

- More details in help message and documentation
- More logs in case of errors for web app logic
- More logs during scripts executions
- Add controls for script executions and failures

## [14.3.2] - 2023-08-28

_This version is dedicated to macOS users, and is based on v14.3.1_

### Changed

- Resume the macOS migration for the other scripts (uses of 'sed' command to produce HTML files)
- In _tipsntools.sh_ script: refactor of "count" feature
- In _tipsntools.sh_ script: improve help

## [14.3.1]

_This version is dedicated to macOS users, and is based on v14.3.0_

### Changed

- Refactor functions based on 'sed' command
- Refactor functions based on MD5 and SHA1 checksums commands
- Refactor functions based on 'truncate' commands
- Check if metadata file exist before dealing with it

## [14.3.0] - 2023-08-28

_This version is dedicated to GNU/Linux users_

### Changed

- HTML and JSON files are updated if and only if their original content has been changed
- The data generation time is computed and displayed.

## [14.2.0]

### Added

- Deal with Ruby-related items

## [14.1.1]

### Added

- Cache and manifest so as to make the web app installable

## [14.1.0]

### Added

Now use local database's contents if feed Web API unreachable. More offline.

### Changed

- Refactor icons
- Cleaner sources

## [14.0.0]

### Added

- Generate JSON files besides HTML files based from CSV files
- Progressive Web App (PWA) / Single Page Application (SPA) / Web App (WA) / shiny-buzzword-web-app-from-hell (SBWAFH) to make queries

### Changed

- Controls to checks browsers in both web app and global web page

## [13.0.0]

### Added

- Elapsed time is displayed after each request
- "help" feature when typing '?' in the web view's search bar
- "show all" feature when typing '\*' in the web view's search bar
- filter contents by sections

### Changed

- whatsnew

## [12.3.0]

### Added

- "Test" topic is now referenced  
- "Security" topic is now referenced

## [12.2.0]

### Added

- "Data" topic is now referenced

## [12.1.0]

### Added

- Small screens are managed with web view
- "Dapp" topic is now referenced

### Changed

- Optimized HTML code

## [12.0.0]

### Changed

- File tree
- Web view with a more material design rendering
- Improved source code

## [11.0.0]

### Added

- Better web view, more W3C compliant

## [10.0.0]

### Added

- Web page providing search bar

## [9.1.1]

### Changed

- Improved README.md

## [9.1.0]

### Added

- Controls of Shell  

## [9.0.3]

### Added

- Better metrics / statistics

## [9.0.2]

### Added

- Compute metrics / statistics about subjects
- URL checking (if the content is still reachable)
- Move to bash
