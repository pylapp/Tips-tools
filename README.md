![Image of Tips and Tools](https://github.com/pylapp/Tips-n-tools/blob/master/picture.png)

# Tips'n'tools (v14.3.2)

  <em>Keep time and be faster with your own cache of references, tools and specifications useful for developers.</em>

  _Tips'n'tools_ is a project whch has the aim of making searches faster and improving technical watch.  
  Indeed, sometimes you need to share usefull web links and cool libraries to your colleagues, but which platform to use?
  Your company's inner social network? Lost time if you move from your job.
  A public social media? Lost time if this medium is closed.
  Fill your web browser's bookmarks? Yeah, got stolen or reinitialized your computer and you are done.  

  _Tips'n'tools_ allows you to fill a spreadsheet (_.ods_ file) and then export its sheets to CSV files.
  Then you can:  
- use the main Shell script (_tipsntools.sh_) to make queries so as to find a thing you have listed  
- build a little Progressive Web App (a Single Page Application) which allows you to make queries with a more user-friendly UI  
- update a global web page if you cannot use the web app  
- run the server-side feed script, written in _Ruby_, so as to expose an HTTP API to make the queries from everywhere  
- place all of this project in your web server, and make the Ruby script or the web app available for your friends or colleagues  


  _Tips'n'tools_ may be useful if you want to compile, in one place, plenty of references and data interesting for your projects.
  Never rely on social networks or corporate heavy tools, make your own cache and bring it everywhere!

  **If you read this document through the GitHub repository, click <a href="https://rawgit.com/pylapp/Tips-n-tools/content/build/webapp.html">here</a> instead.**

## The main script

 Run
```shell
	bash tipsntools.sh --help
```
 to get some help about the commands ;-)

 Run
```shell
	bash tipsntools.sh {--findAll | --findWeb | --findDevices | --findTools | --findSocs} yourRegex
```
 to make some searches in files with a regular expression as a filter. The _--json_ flag after the regex makes the script produce JSON-based data.

 Run
```shell
	bash tipsntools.sh --update
```
 to build HTML and JSON files from your CSV files, and build a global web page and the little web app (to see as a Progressive Web App or Single Page Application if you like buzzwords)

## Add new elements in spreadsheets and other files

You can fill the .ods spreadsheet file with new data you want to save. Then run
```shell
	bash tipsntools.sh --update
```
to update the .html and .json files.

## Who's who

The main script (_tipsntools.sh_) calls core's Shell scripts (stored in _utils/core_ folder) to play with CSV files (in _contents_ folder).  
The server-side script (_datafeed.rb_) calls the main script to process the queries.  
The web app is defined in the _utils/webapp_ folder, and if the web browser is not suitable, the web page (defined in _utils/webpage_ folder) can be used instead.
The web app and the web page to use are in the _builld_ folder (their assets are copied from _utils_).
Finally, the CSV files you should create, and the generated .json and .html files are in the _contents_ folder.

## Customize the project

In most of case nothing is hard-coded. Feel free to customize the Shell scripts, the HTML assets, etc.
The thing is, if you want to add a column in one of the spreadsheet's sheets, do not forget to update the dedicated Sheel scripts and the HTML elements (CSS styl sheets, HTML tables, etc.).

## Run the web app

The web app here is a kind of "Progressive Web App" as a "Single App Application" (one page, offline, installable, with a cache, responsive, etc), BUT it remains web before all.
So because web browsers world is fu****g missy, it remains web browsers which do not support Service Workers, Web Workers, IndexedDB, Promises, ES6 or common and nowadays tools.  
Thus you should use an up-to-date web browser. And sometimes it still won't work. "Web is universal and cool" they said x-)  
Because Service Workers are used, you should reach the web app through HTTPS or a local web server (_localhost_).

## Requirements

- Operating system which can use **Shell** (BASH) and **Ruby** scripts (macOS, Linux, ...)
- **Up-to-date web browser** compatible with IndexedDB, Web Workers, Service Workers, ES6, JS' Promises... (Firefox 58.0.2+, Chromium 64.0.+, ...)
- Something which can deal with .ods file (Libre Office, Open Office, ...)

For macOS users, you should install the _truncate_ command:
```shell
  brew install coreutils
  brew install truncate
```

## Deploy it

To deploy this project for you, your colleagues, your team or whoever, here are the steps:
- get this project (download, fork, clone, summon, ...)
- customize elements if you want (columns, styles, ...)
- fill the ODS file
- run the update command to produce the CSV, HTML and JSON files
- and do not forget to store in a server or a shared space the project (to reach the web app or web page, call the web API, etc.), i.e. the content of the "build" folder

## Files tree

Here is the file tree for this version:
- _build_ the web page's and the web app 'selements, updated each run, to place in a server (e.g. in _/var/www_)
- _contents_ the place where are stored the CSV files you export form the ODS, and the genereated HTML and JSON files
- _utils_ the place where the Shell core's scripts are, and the assets for the web page and the web app

## Note

It seems some web browsers (Firefox 58 for Android and Ubuntu) have bugs with IndexedDB. So you won't use the web app with them.  
You ask why Shell and Ruby are used instead of full cross-platforms languages? Power, effectiveness, and free and open-source OS ;-)  

## Must-read note

Because there are differences and gaps between commands on macOS and GNU/Linux, the project in its v14.3.0 release will not work on macOS! v14.3.1 may be broken on macOS for HTML content production.
In fact numerous commands like _truncate_ , _sed_, and MD5 or SHA1 checksums are not implemented or have a different behavior.

Thus for macOS users **you must use** the v14.3.2 release, and for GNU/Linux users **you have to use** the v14.3.0 release.

If you get errors like _sed: RE error: illegal byte sequence_, please refer to 
https://stackoverflow.com/questions/19242275/re-error-illegal-byte-sequence-on-mac-os-x