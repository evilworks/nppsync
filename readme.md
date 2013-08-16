# NppSync

**Note:** If you want something similar, but simple, there is a one script solution - [watchem.js](https://github.com/duzun/watchem.js).

A notepad++ plugin. Auto-refreshes Google Chrome tabs when their source has been modified in notepad++.

Npp plugin acts as a local server and returns file modification date for requested filenames or directories from Chrome extension. 
By default polling is done every second on `http://localhost:40500/`, but this can be changed in options page.

## Building and Installing
You need Delphi XE2 on x86 Windows platform to build the npp plugin. 
Open NppSync.dpr and build. 
Put NppSync.dll in your plugins dir (either in appdata or in npp plugins subdir if you have a portable install).

To load the plugin in Chrome open extensions page and load `\ChromeExtension` as an unpacked extension.

## Usage
In Chrome open options page of the extension and under "Address Map" add new address. 
In the left input add an `http://` address (ex. `http://localhost/project/`).
In the right input add (local) filesystem path of the corresponding http address (ex. `D:\www\project\`).
Open any page under "`http://localhost/project/`" in Chrome and you will see an icon appears in OmniBox.
Red means disabled, Green - enabled. 
Click the icon to enable the extension then edit any source file from "`D:\www\project\`" folder in notepad++; Chrome auto-refreshes on changes.

`file:///` addresses are translated to filesystem path automatically!


## Licence
Public domain / Free for all

## Changelog
1.0.0 - Initial release
1.1.0 - Now refreshes the page if any of the local scripts or styles linked in the head section have been modified as well. Remember to allow access to file URLs for NppSync on extensions page.

1.2.0 - Fixed most bugs.

1.3.0 - Added support for `http://` addresses. 
Options page works now! 
You can add address map from `http://localhost/*` to file(system) path.
Track changing of any file in the path (open in npp) and refreshes browser page on save.

1.3.1 - `<link href="*.css" />` are updated dynamically, without page refresh. 
The href attribute get `&v=<hash>` appended at each .css file change.
