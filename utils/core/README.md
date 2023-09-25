# Folder 'core'

Here are Shell scripts which can process CSV files in order to produce HTML and JSON files.

There are some issues with 'sed' and 'truncat' commands between GNU/Linux (e.g. Linux Mint and Ubuntu) and macOS systems.

## truncate on macOS

If you meet errors about 'truncate', try to run:
```shell
brew install truncate
brew link truncate
```

## sed on macOS

If you get errors like _sed: RE error: illegal byte sequence_, please refer to [this post on Stack Overflow](https://stackoverflow.com/questions/19242275/re-error-illegal-byte-sequence-on-mac-os-x).