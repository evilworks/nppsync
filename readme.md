# NppSync
A notepad++ plugin. Auto-refreshes Google Chrome tabs with file:/// documents open when their source has been modified in notepad++.

Npp plugin acts as a local server and returns file modification date for requested filenames from Chrome extension. Polling is done every second on http://localhost:40500/

## Building and Installing
You need Delphi XE2 to build the npp plugin. Open NppSync.dpr and build. Put NppSync.dll in your plugins dir (either in appdata or in npp plugins subdir if you have a portable install).

To load the plugin in Chrome open extensions page and load \ChromeExtension as an unpacked extension.

## Usage
When you open a file:// url in Chrome an icon appears in OmniBox. Red means disabled, Green, enabled. Click the icon to enable the extension then edit the source of the document in notepad++; Chrome auto-refreshes the changes.

## Licence
Public domain/Free for all

## Changelog
1.0.0 - Initial release

1.1.0 - Now refreshes the page if any of the local scripts or styles linked in the head section have been modified as well.
