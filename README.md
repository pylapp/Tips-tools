[![Opened issues](https://img.shields.io/github/issues-raw/pylapp/Tips-tools?style=for-the-badge)](https://github.com/pylapp/Tips-tools/issues)
[![MIT license](https://img.shields.io/github/license/pylapp/Tips-tools?style=for-the-badge)](https://github.com/pylapp/Tips-tools/blob/master/LICENSE.txt)
[![Versions](https://img.shields.io/github/v/release/pylapp/Tips-tools?label=Last%20version&style=for-the-badge)](https://github.com/pylapp/Tips-tools/releases)
[![Still maintained](https://img.shields.io/maintenance/yes/2023?style=for-the-badge)](https://github.com/pylapp/Tips-tools/issues?q=is%3Aissue+is%3Aclosed)

[![Code size](https://img.shields.io/github/languages/code-size/pylapp/Tips-Tools?style=for-the-badge)](https://github.com/pylapp/Tips-tools/tree/content)

[![Shell](https://img.shields.io/badge/-Shell-89e051?style=for-the-badge)](https://github.com/pylapp/Tips-tools/search?l=shell)
[![Ruby](https://img.shields.io/badge/-Ruby-701516?style=for-the-badge)](https://github.com/pylapp/Tips-tools/search?l=ruby)
[![HTML, CSS, JavaScript](https://img.shields.io/badge/-Web-563d7c?style=for-the-badge)](https://github.com/pylapp/Tips-tools/search?l=html)

<table>
<tr>
<td>
<img 
src="https://github.com/pylapp/Tips-tools/blob/dev/doc/screenshot_pwa_macOS.png" 
alt="Screenshot of the PWA on macOS showing here only some results (here web sites hyperlinks of publications and blogs) for the keyword 'iOS'" 
title="Screenshot of the PWA on macOS showing here only some results (here web sites hyperlinks of publications and blogs) for the keyword 'iOS'" 
width="500"/>
</td>
<td>
<img 
src="https://github.com/pylapp/Tips-tools/blob/dev/doc/video_cli.gif" 
alt="GIF video of CLI tool which make assets updates, metrics computations and provides data" 
title="GIF video of CLI tool which make assets updates, metrics computations and provides data" 
width="500"/>
</td>
</tr>
</table>

# Tips'n'tools

<em>Keep time and be faster with your own cache of references, tools and specifications useful for developers!</em>

_Tips'n'tools_ is a project which has the aim of making searches a bit more fast and improving technical watch.  
Indeed sometimes you need to share usefull web links and cool libraries to your colleagues, but which platform to use?
Your company's inner social network? Lost time if you move from your job.
A public social media? Lost time if this medium is closed.
Fill your web browser's bookmarks? Yeah, got stolen or reinitialized your computer and you are done.  

_Tips'n'tools_ allows you to fill a spreadsheet (_.ods_ file) and then export its sheets to CSV files (ok it's old school).
Then you can:  
- use the main Shell script (_tipsntools.sh_) to make queries so as to find a thing you have listed (hey, just CLI, no GUI) 
- build a little Progressive Web App (a Single Page Application) which allows you to make queries with a more user-friendly UI (but can be improved a lot)
- update a global web page if you cannot use the web app (quite heavy if you have plenty of content to show)
- run the server-side feed script, written in _Ruby_, so as to expose an HTTP API to make the queries from everywhere (Ruby servlet calling Shell scripts, quite dumb)
- place all of this project in your web server, and make the Ruby script or the web app available for your friends or colleagues (but web-voodoo-glue might be required)

**_Tips'n'tools_ may be useful if you want to compile, in one place, plenty of references and data interesting for your projects.
Never rely on social networks or corporate heavy tools, make your own cache and bring it everywhere!**

You can get more detials [in the wiki](https://github.com/pylapp/Tips-tools/wiki).

## The doctor

A _doctor_ script is available to let you check if prerequisites are all filled

```shell
bash doctor.sh
```

## The main script

 Run
```shell
bash tipsntools.sh --help
```
 to get some help about the commands ;-)

 Run
```shell
bash tipsntools.sh {--findAll | --findWeb | --findDevices | --findTools | --findSocs} yourRegex {--json | --csv}
```
 to make some searches in files with a regular expression as a filter. The _--json_ flag after the regex makes the script produce JSON-based data.

 Run
```shell
bash tipsntools.sh --update
```
 to build HTML and JSON files from your CSV files, and build a global web page and the little web app (to see as a Progressive Web App or Single Page Application if you like buzzwords)

## Add new elements in spreadsheets and other files

You can fill the _.ods_ spreadsheet file with new data you want to save.
You should keep the columns order.
Then run
```shell
bash tipsntools.sh --update
```
to update the _.html_ and _.json_ files.

## Who's who

The main script (_tipsntools.sh_) calls core's Shell scripts (stored in _utils/core_ folder) to play with CSV files (in _contents_ folder).  
The server-side script (_datafeed.rb_) calls the main script to process the queries.  
The web app is defined in the _utils/webapp_ folder, and if the web browser is not suitable, the web page (defined in _utils/webpage_ folder) can be used instead.
The web app and the web page to use are in the _build_ folder (their assets are copied from _utils_).
Finally, the CSV files you should export from ODS (preserving UTF8), and the generated _.json_ and _.html_ files are in the _contents_ folder.

## Customize the project

In most of case nothing is hard-coded. Feel free to customize the Shell scripts, the HTML assets, etc.
The thing is, if you want to add a column in one of the spreadsheet's sheets, do not forget to update the dedicated Shell scripts and the HTML elements (CSS style sheets, HTML tables, etc.).

## Run the web app

The web app here is a kind of "Progressive Web App" as a "Single App Application" (one page, offline, installable, with a cache, responsive, etc), BUT it remains web before all and it's a bit crapy.
So because web browsers world is fu****g missy (and also coz' I enjoy native apps <3), it remains web browsers which do not support Service Workers, Web Workers, IndexedDB, Promises, ES6 or common and nowadays tools blablabla. 
Thus you should use an up-to-date web browser. And sometimes it still won't work. "Web is universal and cool" they said (U_U))
Because Service Workers are used, you should reach the web app through HTTPS or a local web server (_localhost_).

_If you saw newbie things I did, feel free to submit a pull request!_

## Requirements

- Operating system which can use **Shell** (Bash / ZSH) and **Ruby** scripts (macOS, GNU/Linux, ...)
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
- export each sheet as CSV file
- run the update command to produce from the CSV files the HTML and JSON files
- and do not forget to store in a server or a shared space the project (to reach the web app or web page, call the web API, etc.), i.e. the content of the "build" folder

## Files tree

Here is the file tree for this version:
- _build_ the web page's and the web app's elements, updated each run, to place in a server (e.g. in _/var/www_)
- _contents_ the place where are stored the CSV files you export form the ODS, and the genereated HTML and JSON files
- _utils_ the place where the Shell core's scripts are, and the assets for the web page and the web app

## Note

It seems some web browsers (Firefox 58 for Android and Ubuntu) have bugs with IndexedDB. So you won't use the web app with them.  
You ask why Shell and Ruby are used instead of full cross-platforms languages? Power, effectiveness, and free and open-source OS ;-)  

## Must-read note

Have a look on the [release note](https://github.com/pylapp/Tips-tools/blob/master/CHANGELOG.md) to get more details.

## Known issues

If you get errors like _sed: RE error: illegal byte sequence_, please refer to the hyperklink bellow.
It seems some files (like CSV files) you produce contain special characters '�' making `sed` fail.
https://stackoverflow.com/questions/19242275/re-error-illegal-byte-sequence-on-mac-os-x

You may also have in the wepp app error like _"An error occured with the JSON data gotten from the feed Web API. The degraded mode is still available"_. By looking in the developer console, you may find there is unexpected error in the JSON data returned by the script.
In this case you should have a look on the CSV files you exported ; maybe there are not well formatted and make the produced JSON bad.

In addition, if you install the web app on your computer, you may have different behaviors if you choose Brave, Chrome or Firefox :-/

More details on the [issues tracker](https://github.com/pylapp/Tips-tools/issues).

Some features may fail, like the _--check_ feature which will check if URL are still available or not.
In fact some commands like _CURL_ may fail if the website does not respond.
Thus in this case we may have to comment the _set -euxo pipefail_ line in the main script to let the script check URL even if CURL fails.

## Funny notice

Several years ago, I noticed the Git history was crappy and fucked up.
There were some data leaks, wrong email address was used, got a lot of spam, commits links to the GitHub account's were not created because of bad pseudo... No DCO, no GPG-signing... It was a big mess. Trials to clean the history failed, that is the reason why the project was deleted and created again and all the Git history lost until 2020. Learned of that!

## Licenses

All the sources (Shell, JavaScript, CSS, HTML, Ruby, etc.) are under **MIT** license.
The ODS template and any HTML, CSS and JSON generated files are under [Creative Commons With Attribution](https://creativecommons.org/licenses/by/4.0/).

## Support

If you want to support this project, feel free to submit [issues](https://github.com/pylapp/Tips-tools/issues) and [pull requests](https://github.com/pylapp/Tips-tools/pulls)!

You can also feed the developer by using some of the tools bellow or <a href="https://pylapersonne.info/donate" title="Go to website with support mediums">other mediums</a> 🫶

<a href="https://www.buymeacoffee.com/pylapp" title="Go to Buy Me a Coffee profile">
    <img src="https://pylapersonne.info/data/donate/resources/logo-bmc.webp" alt="Bye Me A Coffee logo" width="50" style>
</a>
&nbsp;&nbsp;&nbsp;&nbsp;
<a href="https://www.paypal.com/paypalme/pylapp" title="Go to PayPal profile">
    <img src="https://pylapersonne.info/data/donate/resources/logo-ppl.webp" alt="PayPal logo" width="50">
</a>
&nbsp;&nbsp;&nbsp;&nbsp;
<a href="https://pylapersonne.info/donate" title="Use cryptocurrencies or Ğ1">
    <img src="https://pylapersonne.info/data/donate/resources/logo-g1.webp" alt="Ğ1 logo" width="50">
</a>
