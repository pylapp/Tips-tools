# Folder 'core'

Here are Shell scripts which can process CSV files in order to produce HTML and JSON files.

There are some issues with 'sed' and 'truncat' commands between GNU/Linux (e.g. Linux Mint and Ubuntu) and macOS systems.

## truncate on macOS

If you meet errors about 'truncate', try to run:
```shell
brew install truncate
brew link truncate
```

## sed on macOS and GNU/Linux

The 'sed' command is ued to as to processs the CSV lines and prepare them for HTML.
In fact each line will be given to 'sed' with will replace ';' par '\n'. Thus read loops will process the outputs to generate HTML code.
However the syntax is slightly different between sytems.
For macOS, 'sed' command should be `sed 's/;/\'$'\n/g'` and for GNU/Linux `sed 's/;/\n/g'`.

## sed on macOS

If you get errors like _sed: RE error: illegal byte sequence_, please refer to 
https://stackoverflow.com/questions/19242275/re-error-illegal-byte-sequence-on-mac-os-x