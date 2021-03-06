![Image of Tips and Tools](https://github.com/pylapp/Tips-n-tools/blob/master/picture.png)

# Tips'n'tools (v14.3.3)

  <em>Keep time and be faster with your own cache of references, tools and specifications useful for developers.</em>

  _Tips'n'tools_ is a project which has the aim of making searches faster and improving technical watch.  
  Indeed, sometimes you need to share usefull web links and cool libraries to your colleagues, but which platform to use?
  Your company's inner social network? Lost time if you move from your job.
  A public social media? Lost time if this medium is closed.
  Fill your web browser's bookmarks? Yeah, got stolen or reinitialized your computer and you are done.  

  _Tips'n'tools_ allows you to fill a spreadsheet (_.ods_ file) and then export its sheets to CSV files (ok it's old school).
  Then you can:  
- use the main Shell script (_tipsntools.sh_) to make queries so as to find a thing you have listed (hey, just CLI, no GUI) 
- build a little Progressive Web App (a Single Page Application) which allows you to make queries with a more user-friendly UI (but can be improved a lot)
- update a global web page if you cannot use the web app (quit heavy if you have plenty of content to show)
- run the server-side feed script, written in _Ruby_, so as to expose an HTTP API to make the queries from everywhere (Ruby servlet calling Shell scripts, quite dumb)
- place all of this project in your web server, and make the Ruby script or the web app available for your friends or colleagues (but web-voodoo-glue might be required)

 _Tips'n'tools_ may be useful if you want to compile, in one place, plenty of references and data interesting for your projects.
  Never rely on social networks or corporate heavy tools, make your own cache and bring it everywhere!


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

You can fill the _.ods_ spreadsheet file with new data you want to save. Then run
```shell
	bash tipsntools.sh --update
```
to update the _.html_ and _.json_ files.

## Who's who

The main script (_tipsntools.sh_) calls core's Shell scripts (stored in _utils/core_ folder) to play with CSV files (in _contents_ folder).  
The server-side script (_datafeed.rb_) calls the main script to process the queries.  
The web app is defined in the _utils/webapp_ folder, and if the web browser is not suitable, the web page (defined in _utils/webpage_ folder) can be used instead.
The web app and the web page to use are in the _builld_ folder (their assets are copied from _utils_).
Finally, the CSV files you should create, and the generated _.json_ and _.html_ files are in the _contents_ folder.

## Customize the project

In most of case nothing is hard-coded. Feel free to customize the Shell scripts, the HTML assets, etc.
The thing is, if you want to add a column in one of the spreadsheet's sheets, do not forget to update the dedicated Shell scripts and the HTML elements (CSS style sheets, HTML tables, etc.).

## Run the web app

The web app here is a kind of "Progressive Web App" as a "Single App Application" (one page, offline, installable, with a cache, responsive, etc), BUT it remains web before all.
So because web browsers world is fu****g missy (and also coz' I enjou native apps <3), it remains web browsers which do not support Service Workers, Web Workers, IndexedDB, Promises, ES6 or common and nowadays tools.  
Thus you should use an up-to-date web browser. And sometimes it still won't work. "Web is universal and cool" they said x-)  
Because Service Workers are used, you should reach the web app through HTTPS or a local web server (_localhost_).

_If you saw newbie things I did, feel free to submit a pull request!_

## Requirements

- Operating system which can use **Shell** (BASH) and **Ruby** scripts (macOS, Linux, ...)
- **Up-to-date web browser** compatible with IndexedDB, Web Workers, Service Workers, ES6, JS' Promises... (Firefox 58.0.2+, Chromium 64.0.+, ...)
- Something which can deal with _.ods_ file (_Libre Office_, _Open Office_, ...)

For macOS users, you should install the _truncate_ command:
```shell
  brew install coreutils
  brew install truncate
  # Maybe you should after run `brew link truncate`
```

## Deploy it

To deploy this project for you, your colleagues, your team or whoever, here are the steps:
- get this project (download, fork, clone, summon, teleport ...)
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
In fact numerous commands like _truncate_, _sed_, and MD5 or SHA1 checksums are not implemented, have different names or have a different behavior.

Thus for macOS users **you must use** the v14.3.3 release, and for GNU/Linux users **you have to use** the v14.3.0 release.

Have a look on the [release note](https://github.com/pylapp/Tips-n-tools/blob/master/CHANGELOG.md) to get more details.

## Know issues

If you get errors like _sed: RE error: illegal byte sequence_, please refer to the hyperklink bellow.
It seems some files (like CSV files) you produce contain special characters '�' making `sed` fail.
https://stackoverflow.com/questions/19242275/re-error-illegal-byte-sequence-on-mac-os-x

You may also have in the wepp app error like _"An error occured with the JSON data gotten from the feed Web API. The degraded mode is still available"_. By looking in the developer console, you may find there is unexpected error in the JSON data returned by the script.
In this case you should have a look on the CSV files you exported ; maybe there are not well formatted and make the produced JSON bad.

In addition, if you isntall the web app on your computer, you may have different behaviors if you choose Brave, Chrome or Firefox :-/


Some features may fail, like the _--check_ feature which will check if URL are still available or not.
In fact some commands like _CURL_ may fail if the website does not respond.
Thus in this case we may have to comment the _set -euxo pipefail_ mine in the main script to let the script check URL even if CURL fails.