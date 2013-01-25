unit NppPluginInterface;

interface

uses
	Windows, Messages;

const
	NPP_COMMAND_NAME_LENGTH = 64; // Max plugin command menu item text length.

type
	{ Type definitions. }
	uptr_t = ULONG_PTR;
	sptr_t = LONG_PTR;

	{ Method prototypes. }
	TNppPluginCmd = procedure;

    { TNppLangType (enum LangType) }
	TNppLangType = (L_TXT, L_PHP, L_C, L_CPP, L_CS, L_OBJC, L_JAVA, L_RC,
	  L_HTML, L_XML, L_MAKEFILE, L_PASCAL, L_BATCH, L_INI, L_NFO, L_USER,
	  L_ASP, L_SQL, L_VB, L_JS, L_CSS, L_PERL, L_PYTHON, L_LUA,
	  L_TEX, L_FORTRAN, L_BASH, L_FLASH, L_NSIS, L_TCL, L_LISP, L_SCHEME,
	  L_ASM, L_DIFF, L_PROPS, L_PS, L_RUBY, L_SMALLTALK, L_VHDL, L_KIX, L_AU3,
	  L_CAML, L_ADA, L_VERILOG, L_MATLAB, L_HASKELL, L_INNO, L_SEARCHRESULT,
	  L_CMAKE, L_YAML,
	  L_EXTERNAL
	  );

    { TNppWinVer (enum winVer) }
	TNppWinVer = (WV_UNKNOWN, WV_WIN32S, WV_95, WV_98, WV_ME, WV_NT, WV_W2K,
	  WV_XP, WV_S2003, WV_XPX64, WV_VISTA, WV_WIN7
	  );

    { TNppData (struct NppData) }
    { Data passed from notepad++ to plugin via setData(); }
	TNppData = record
		nppHandle: HWND;
		scintillaMainHandle: HWND;
		scintillaSecondHandle: HWND;
	end;

    { TNppPluginCommandShortcut (struct ShortcutKey). }
    { A shortcut definition for TNppPluginCommand. }
	TNppPluginCommandShortcut = record
		ModCTRL: boolean;
		ModALT: boolean;
		ModSHIFT: boolean;
		Key: byte;
	end;

	PNppPluginCommandShortcut = ^TNppPluginCommandShortcut;

    { TNppPluginCommand (struct FuncItem).}
    { A structure defining a command the plugin provides to notepad++. }
	TNppPluginCommand = record
		itemName: array [0 .. NPP_COMMAND_NAME_LENGTH - 1] of char;
		pFunc: TNppPluginCmd;
		cmdID: integer;
		init2Check: bool;
		shortcut: PNppPluginCommandShortcut;
	end;

	PNppPluginCommand = ^TNppPluginCommand;

    { Sci_NotifyHeader }
	Sci_NotifyHeader = record
		hwndFrom: THandle;
		idFrom: uptr_t;
		code: integer;
	end;

    { TSCNotification }
	TSCNotification = record
		nmhdr: Sci_NotifyHeader;
		position: integer;             // SCN_STYLENEEDED, SCN_MODIFIED, SCN_DWELLSTART, SCN_DWELLEND */
		ch: integer;                   // SCN_CHARADDED, SCN_KEY */
		modifiers: integer;            // SCN_KEY */
		modificationType: integer;     // SCN_MODIFIED */
		text: PChar;                   // SCN_MODIFIED, SCN_USERLISTSELECTION, SCN_AUTOCSELECTION */
		length: integer;               // SCN_MODIFIED */
		linesAdded: integer;           // SCN_MODIFIED */
		msg: integer;                  // SCN_MACRORECORD */
		wParam: uptr_t;                // SCN_MACRORECORD */
		lParam: sptr_t;                // SCN_MACRORECORD */
		line: integer;                 // SCN_MODIFIED */
		foldLevelNow: integer;         // SCN_MODIFIED */
		foldLevelPrev: integer;        // SCN_MODIFIED */
		margin: integer;               // SCN_MARGINCLICK */
		listType: integer;             // SCN_USERLISTSELECTION */
		x: integer;                    // SCN_DWELLSTART, SCN_DWELLEND */
		y: integer;                    // SCN_DWELLSTART, SCN_DWELLEND */
		token: integer;                // SCN_MODIFIED with SC_MOD_CONTAINER */
		annotationLinesAdded: integer; // SC_MOD_CHANGEANNOTATION */
	end;

	PSCNotification = ^TSCNotification;

	SearchResultMarking = record
		starts: LONG;
		ends: LONG;
	end;

	PSearchResultMarking = ^SearchResultMarking;

	SearchResultMarkings = record
		length: LONG;
		markings: PSearchResultMarking;
	end;

	TNppSessionInfo = record
		sessionFilePathName: PChar;
		nbFile: integer;
		files: PPChar;
	end;

	TNppToolbarIcons = record
		hToolbarBmp: HBITMAP;
		hToolbarIcon: HICON;
	end;

	TNppCommunicationInfo = record
		internalMsg: LONG;
		scrModuleName: PChar;
		info: pointer; // defined by plugin
	end;

const
	{ NPPM_GETNBOPENFILES parameters }
	ALL_OPEN_FILES = 0;
	PRIMARY_VIEW   = 1;
	SECOND_VIEW    = 2;

	{ NPPM_MODELESSDIALOG parameters }
	MODELESSDIALOGADD    = 0;
	MODELESSDIALOGREMOVE = 1;

	{ NPPM_GETCURRENTDOCINDEX parameters }
	MAIN_VIEW = 0;
	SUB_VIEW  = 1;

	{ NPPM_SETSTATUSBAR parameters }
	STATUSBAR_DOC_TYPE     = 0;
	STATUSBAR_DOC_SIZE     = 1;
	STATUSBAR_CUR_POS      = 2;
	STATUSBAR_EOF_FORMAT   = 3;
	STATUSBAR_UNICODE_TYPE = 4;
	STATUSBAR_TYPING_MODE  = 5;

	{ NPPM_GETMENUHANDLE parameters }
	NPPPLUGINMENU = 0;

	{ RUNCOMMAND_USER parameters }
	VAR_NOT_RECOGNIZED = 0;
	FULL_CURRENT_PATH  = 1;
	CURRENT_DIRECTORY  = 2;
	FILE_NAME          = 3;
	NAME_PART          = 4;
	EXT_PART           = 5;
	CURRENT_WORD       = 6;
	NPP_DIRECTORY      = 7;
	CURRENT_LINE       = 8;
	CURRENT_COLUMN     = 9;

	{ NPPN_READONLYCHANGED parameters }
	DOCSTAUS_READONLY    = 1;
	DOCSTAUS_BUFFERDIRTY = 2;

    { ===================== }
	{ Messages to Notepad++ }
    { ===================== }

	NPPMSG                         = (WM_USER + 1000);
	NPPM_GETCURRENTSCINTILLA       = (NPPMSG + 4);
	NPPM_GETCURRENTLANGTYPE        = (NPPMSG + 5);
	NPPM_SETCURRENTLANGTYPE        = (NPPMSG + 6);
	NPPM_GETNBOPENFILES            = (NPPMSG + 7);
	NPPM_GETOPENFILENAMES          = (NPPMSG + 8);
	NPPM_MODELESSDIALOG            = (NPPMSG + 12);
	NPPM_GETNBSESSIONFILES         = (NPPMSG + 13);
	NPPM_GETSESSIONFILES           = (NPPMSG + 14);
	NPPM_SAVESESSION               = (NPPMSG + 15);
	NPPM_SAVECURRENTSESSION        = (NPPMSG + 16);
	NPPM_GETOPENFILENAMESPRIMARY   = (NPPMSG + 17);
	NPPM_GETOPENFILENAMESSECOND    = (NPPMSG + 18);
	NPPM_CREATESCINTILLAHANDLE     = (NPPMSG + 20);
	NPPM_DESTROYSCINTILLAHANDLE    = (NPPMSG + 21);
	NPPM_GETNBUSERLANG             = (NPPMSG + 22);
	NPPM_GETCURRENTDOCINDEX        = (NPPMSG + 23);
	NPPM_SETSTATUSBAR              = (NPPMSG + 24);
	NPPM_GETMENUHANDLE             = (NPPMSG + 25);
	NPPM_ENCODESCI                 = (NPPMSG + 26);
	NPPM_DECODESCI                 = (NPPMSG + 27);
	NPPM_ACTIVATEDOC               = (NPPMSG + 28);
	NPPM_LAUNCHFINDINFILESDLG      = (NPPMSG + 29);
	NPPM_DMMSHOW                   = (NPPMSG + 30);
	NPPM_DMMHIDE                   = (NPPMSG + 31);
	NPPM_DMMUPDATEDISPINFO         = (NPPMSG + 32);
	NPPM_DMMREGASDCKDLG            = (NPPMSG + 33);
	NPPM_LOADSESSION               = (NPPMSG + 34);
	NPPM_DMMVIEWOTHERTAB           = (NPPMSG + 35);
	NPPM_RELOADFILE                = (NPPMSG + 36);
	NPPM_SWITCHTOFILE              = (NPPMSG + 37);
	NPPM_SAVECURRENTFILE           = (NPPMSG + 38);
	NPPM_SAVEALLFILES              = (NPPMSG + 39);
	NPPM_SETMENUITEMCHECK          = (NPPMSG + 40);
	NPPM_ADDTOOLBARICON            = (NPPMSG + 41);
	NPPM_GETWINDOWSVERSION         = (NPPMSG + 42);
	NPPM_DMMGETPLUGINHWNDBYNAME    = (NPPMSG + 43);
	NPPM_MAKECURRENTBUFFERDIRTY    = (NPPMSG + 44);
	NPPM_GETENABLETHEMETEXTUREFUNC = (NPPMSG + 45);
	NPPM_GETPLUGINSCONFIGDIR       = (NPPMSG + 46);
	NPPM_MSGTOPLUGIN               = (NPPMSG + 47);
	NPPM_MENUCOMMAND               = (NPPMSG + 48);
	NPPM_TRIGGERTABBARCONTEXTMENU  = (NPPMSG + 49);
	NPPM_GETNPPVERSION             = (NPPMSG + 50);
	NPPM_HIDETABBAR                = (NPPMSG + 51);
	NPPM_ISTABBARHIDDEN            = (NPPMSG + 52);
	NPPM_GETPOSFROMBUFFERID        = (NPPMSG + 57);
	NPPM_GETFULLPATHFROMBUFFERID   = (NPPMSG + 58);
	NPPM_GETBUFFERIDFROMPOS        = (NPPMSG + 59);
	NPPM_GETCURRENTBUFFERID        = (NPPMSG + 60);
	NPPM_RELOADBUFFERID            = (NPPMSG + 61);
	NPPM_GETBUFFERLANGTYPE         = (NPPMSG + 64);
	NPPM_SETBUFFERLANGTYPE         = (NPPMSG + 65);
	NPPM_GETBUFFERENCODING         = (NPPMSG + 66);
	NPPM_SETBUFFERENCODING         = (NPPMSG + 67);
	NPPM_GETBUFFERFORMAT           = (NPPMSG + 68);
	NPPM_SETBUFFERFORMAT           = (NPPMSG + 69);
	NPPM_HIDETOOLBAR               = (NPPMSG + 70);
	NPPM_ISTOOLBARHIDDEN           = (NPPMSG + 71);
	NPPM_HIDEMENU                  = (NPPMSG + 72);
	NPPM_ISMENUHIDDEN              = (NPPMSG + 73);
	NPPM_HIDESTATUSBAR             = (NPPMSG + 74);
	NPPM_ISSTATUSBARHIDDEN         = (NPPMSG + 75);
	NPPM_GETSHORTCUTBYCMDID        = (NPPMSG + 76);
	NPPM_DOOPEN                    = (NPPMSG + 77);

	RUNCOMMAND_USER          = (WM_USER + 3000);
	NPPM_GETFULLCURRENTPATH  = (RUNCOMMAND_USER + FULL_CURRENT_PATH);
	NPPM_GETCURRENTDIRECTORY = (RUNCOMMAND_USER + CURRENT_DIRECTORY);
	NPPM_GETFILENAME         = (RUNCOMMAND_USER + FILE_NAME);
	NPPM_GETNAMEPART         = (RUNCOMMAND_USER + NAME_PART);
	NPPM_GETEXTPART          = (RUNCOMMAND_USER + EXT_PART);
	NPPM_GETCURRENTWORD      = (RUNCOMMAND_USER + CURRENT_WORD);
	NPPM_GETNPPDIRECTORY     = (RUNCOMMAND_USER + NPP_DIRECTORY);
	NPPM_GETCURRENTLINE      = (RUNCOMMAND_USER + CURRENT_LINE);
	NPPM_GETCURRENTCOLUMN    = (RUNCOMMAND_USER + CURRENT_COLUMN);

    { ============================ }
    { Notifications from notepad++ }
    { ============================ }

	NPPN_FIRST             = 1000;
	NPPN_READY             = (NPPN_FIRST + 1);
	NPPN_TBMODIFICATION    = (NPPN_FIRST + 2);
	NPPN_FILEBEFORECLOSE   = (NPPN_FIRST + 3);
	NPPN_FILEOPENED        = (NPPN_FIRST + 4);
	NPPN_FILECLOSED        = (NPPN_FIRST + 5);
	NPPN_FILEBEFOREOPEN    = (NPPN_FIRST + 6);
	NPPN_FILEBEFORESAVE    = (NPPN_FIRST + 7);
	NPPN_FILESAVED         = (NPPN_FIRST + 8);
	NPPN_SHUTDOWN          = (NPPN_FIRST + 9);
	NPPN_BUFFERACTIVATED   = (NPPN_FIRST + 10);
	NPPN_LANGCHANGED       = (NPPN_FIRST + 11);
	NPPN_WORDSTYLESUPDATED = (NPPN_FIRST + 12);
	NPPN_SHORTCUTREMAPPED  = (NPPN_FIRST + 13);
	NPPN_FILEBEFORELOAD    = (NPPN_FIRST + 14);
	NPPN_FILELOADFAILED    = (NPPN_FIRST + 15);
	NPPN_READONLYCHANGED   = (NPPN_FIRST + 16);
	NPPN_DOCORDERCHANGED   = (NPPN_FIRST + 16);

    { =================================================== }
    { Notifications from and Messages to Scintilla editor }
    { =================================================== }

	SCI_START                                     = 2000;
	SCI_OPTIONAL_START                            = 3000;
	SCI_LEXER_START                               = 4000;
	SCI_ADDTEXT                                   = 2001;
	SCI_ADDSTYLEDTEXT                             = 2002;
	SCI_INSERTTEXT                                = 2003;
	SCI_CLEARALL                                  = 2004;
	SCI_CLEARDOCUMENTSTYLE                        = 2005;
	SCI_GETLENGTH                                 = 2006;
	SCI_GETCHARAT                                 = 2007;
	SCI_GETCURRENTPOS                             = 2008;
	SCI_GETANCHOR                                 = 2009;
	SCI_GETSTYLEAT                                = 2010;
	SCI_REDO                                      = 2011;
	SCI_SETUNDOCOLLECTION                         = 2012;
	SCI_SELECTALL                                 = 2013;
	SCI_SETSAVEPOINT                              = 2014;
	SCI_GETSTYLEDTEXT                             = 2015;
	SCI_CANREDO                                   = 2016;
	SCI_MARKERLINEFROMHANDLE                      = 2017;
	SCI_MARKERDELETEHANDLE                        = 2018;
	SCI_GETUNDOCOLLECTION                         = 2019;
	SCI_GETVIEWWS                                 = 2020;
	SCI_SETVIEWWS                                 = 2021;
	SCI_POSITIONFROMPOINT                         = 2022;
	SCI_POSITIONFROMPOINTCLOSE                    = 2023;
	SCI_GOTOLINE                                  = 2024;
	SCI_GOTOPOS                                   = 2025;
	SCI_SETANCHOR                                 = 2026;
	SCI_GETCURLINE                                = 2027;
	SCI_GETENDSTYLED                              = 2028;
	SCI_CONVERTEOLS                               = 2029;
	SCI_GETEOLMODE                                = 2030;
	SCI_SETEOLMODE                                = 2031;
	SCI_STARTSTYLING                              = 2032;
	SCI_SETSTYLING                                = 2033;
	SCI_GETBUFFEREDDRAW                           = 2034;
	SCI_SETBUFFEREDDRAW                           = 2035;
	SCI_SETTABWIDTH                               = 2036;
	SCI_GETTABWIDTH                               = 2121;
	SCI_SETCODEPAGE                               = 2037;
	SCI_SETUSEPALETTE                             = 2039;
	SCI_MARKERDEFINE                              = 2040;
	SCI_MARKERSETFORE                             = 2041;
	SCI_MARKERSETBACK                             = 2042;
	SCI_MARKERADD                                 = 2043;
	SCI_MARKERDELETE                              = 2044;
	SCI_MARKERDELETEALL                           = 2045;
	SCI_MARKERGET                                 = 2046;
	SCI_MARKERNEXT                                = 2047;
	SCI_MARKERPREVIOUS                            = 2048;
	SCI_MARKERDEFINEPIXMAP                        = 2049;
	SCI_MARKERADDSET                              = 2466;
	SCI_MARKERSETALPHA                            = 2476;
	SCI_SETMARGINTYPEN                            = 2240;
	SCI_GETMARGINTYPEN                            = 2241;
	SCI_SETMARGINWIDTHN                           = 2242;
	SCI_GETMARGINWIDTHN                           = 2243;
	SCI_SETMARGINMASKN                            = 2244;
	SCI_GETMARGINMASKN                            = 2245;
	SCI_SETMARGINSENSITIVEN                       = 2246;
	SCI_GETMARGINSENSITIVEN                       = 2247;
	SCI_STYLECLEARALL                             = 2050;
	SCI_STYLESETFORE                              = 2051;
	SCI_STYLESETBACK                              = 2052;
	SCI_STYLESETBOLD                              = 2053;
	SCI_STYLESETITALIC                            = 2054;
	SCI_STYLESETSIZE                              = 2055;
	SCI_STYLESETFONT                              = 2056;
	SCI_STYLESETEOLFILLED                         = 2057;
	SCI_STYLERESETDEFAULT                         = 2058;
	SCI_STYLESETUNDERLINE                         = 2059;
	SCI_STYLEGETFORE                              = 2481;
	SCI_STYLEGETBACK                              = 2482;
	SCI_STYLEGETBOLD                              = 2483;
	SCI_STYLEGETITALIC                            = 2484;
	SCI_STYLEGETSIZE                              = 2485;
	SCI_STYLEGETFONT                              = 2486;
	SCI_STYLEGETEOLFILLED                         = 2487;
	SCI_STYLEGETUNDERLINE                         = 2488;
	SCI_STYLEGETCASE                              = 2489;
	SCI_STYLEGETCHARACTERSET                      = 2490;
	SCI_STYLEGETVISIBLE                           = 2491;
	SCI_STYLEGETCHANGEABLE                        = 2492;
	SCI_STYLEGETHOTSPOT                           = 2493;
	SCI_STYLESETCASE                              = 2060;
	SCI_STYLESETCHARACTERSET                      = 2066;
	SCI_STYLESETHOTSPOT                           = 2409;
	SCI_SETSELFORE                                = 2067;
	SCI_SETSELBACK                                = 2068;
	SCI_GETSELALPHA                               = 2477;
	SCI_SETSELALPHA                               = 2478;
	SCI_GETSELEOLFILLED                           = 2479;
	SCI_SETSELEOLFILLED                           = 2480;
	SCI_SETCARETFORE                              = 2069;
	SCI_ASSIGNCMDKEY                              = 2070;
	SCI_CLEARCMDKEY                               = 2071;
	SCI_CLEARALLCMDKEYS                           = 2072;
	SCI_SETSTYLINGEX                              = 2073;
	SCI_STYLESETVISIBLE                           = 2074;
	SCI_GETCARETPERIOD                            = 2075;
	SCI_SETCARETPERIOD                            = 2076;
	SCI_SETWORDCHARS                              = 2077;
	SCI_BEGINUNDOACTION                           = 2078;
	SCI_ENDUNDOACTION                             = 2079;
	SCI_INDICSETSTYLE                             = 2080;
	SCI_INDICGETSTYLE                             = 2081;
	SCI_INDICSETFORE                              = 2082;
	SCI_INDICGETFORE                              = 2083;
	SCI_INDICSETUNDER                             = 2510;
	SCI_INDICGETUNDER                             = 2511;
	SCI_GETCARETLINEVISIBLEALWAYS                 = 3095;
	SCI_SETCARETLINEVISIBLEALWAYS                 = 3096;
	SCI_SETWHITESPACEFORE                         = 2084;
	SCI_SETWHITESPACEBACK                         = 2085;
	SCI_SETSTYLEBITS                              = 2090;
	SCI_GETSTYLEBITS                              = 2091;
	SCI_SETLINESTATE                              = 2092;
	SCI_GETLINESTATE                              = 2093;
	SCI_GETMAXLINESTATE                           = 2094;
	SCI_GETCARETLINEVISIBLE                       = 2095;
	SCI_SETCARETLINEVISIBLE                       = 2096;
	SCI_GETCARETLINEBACK                          = 2097;
	SCI_SETCARETLINEBACK                          = 2098;
	SCI_STYLESETCHANGEABLE                        = 2099;
	SCI_AUTOCSHOW                                 = 2100;
	SCI_AUTOCCANCEL                               = 2101;
	SCI_AUTOCACTIVE                               = 2102;
	SCI_AUTOCPOSSTART                             = 2103;
	SCI_AUTOCCOMPLETE                             = 2104;
	SCI_AUTOCSTOPS                                = 2105;
	SCI_AUTOCSETSEPARATOR                         = 2106;
	SCI_AUTOCGETSEPARATOR                         = 2107;
	SCI_AUTOCSELECT                               = 2108;
	SCI_AUTOCSETCANCELATSTART                     = 2110;
	SCI_AUTOCGETCANCELATSTART                     = 2111;
	SCI_AUTOCSETFILLUPS                           = 2112;
	SCI_AUTOCSETCHOOSESINGLE                      = 2113;
	SCI_AUTOCGETCHOOSESINGLE                      = 2114;
	SCI_AUTOCSETIGNORECASE                        = 2115;
	SCI_AUTOCGETIGNORECASE                        = 2116;
	SCI_USERLISTSHOW                              = 2117;
	SCI_AUTOCSETAUTOHIDE                          = 2118;
	SCI_AUTOCGETAUTOHIDE                          = 2119;
	SCI_AUTOCSETDROPRESTOFWORD                    = 2270;
	SCI_AUTOCGETDROPRESTOFWORD                    = 2271;
	SCI_REGISTERIMAGE                             = 2405;
	SCI_CLEARREGISTEREDIMAGES                     = 2408;
	SCI_AUTOCGETTYPESEPARATOR                     = 2285;
	SCI_AUTOCSETTYPESEPARATOR                     = 2286;
	SCI_AUTOCSETMAXWIDTH                          = 2208;
	SCI_AUTOCGETMAXWIDTH                          = 2209;
	SCI_AUTOCSETMAXHEIGHT                         = 2210;
	SCI_AUTOCGETMAXHEIGHT                         = 2211;
	SCI_SETINDENT                                 = 2122;
	SCI_GETINDENT                                 = 2123;
	SCI_SETUSETABS                                = 2124;
	SCI_GETUSETABS                                = 2125;
	SCI_SETLINEINDENTATION                        = 2126;
	SCI_GETLINEINDENTATION                        = 2127;
	SCI_GETLINEINDENTPOSITION                     = 2128;
	SCI_GETCOLUMN                                 = 2129;
	SCI_SETHSCROLLBAR                             = 2130;
	SCI_GETHSCROLLBAR                             = 2131;
	SCI_SETINDENTATIONGUIDES                      = 2132;
	SCI_GETINDENTATIONGUIDES                      = 2133;
	SCI_SETHIGHLIGHTGUIDE                         = 2134;
	SCI_GETHIGHLIGHTGUIDE                         = 2135;
	SCI_GETLINEENDPOSITION                        = 2136;
	SCI_GETCODEPAGE                               = 2137;
	SCI_GETCARETFORE                              = 2138;
	SCI_GETUSEPALETTE                             = 2139;
	SCI_GETREADONLY                               = 2140;
	SCI_SETCURRENTPOS                             = 2141;
	SCI_SETSELECTIONSTART                         = 2142;
	SCI_GETSELECTIONSTART                         = 2143;
	SCI_SETSELECTIONEND                           = 2144;
	SCI_GETSELECTIONEND                           = 2145;
	SCI_SETPRINTMAGNIFICATION                     = 2146;
	SCI_GETPRINTMAGNIFICATION                     = 2147;
	SCI_SETPRINTCOLOURMODE                        = 2148;
	SCI_GETPRINTCOLOURMODE                        = 2149;
	SCI_FINDTEXT                                  = 2150;
	SCI_FORMATRANGE                               = 2151;
	SCI_GETFIRSTVISIBLELINE                       = 2152;
	SCI_GETLINE                                   = 2153;
	SCI_GETLINECOUNT                              = 2154;
	SCI_SETMARGINLEFT                             = 2155;
	SCI_GETMARGINLEFT                             = 2156;
	SCI_SETMARGINRIGHT                            = 2157;
	SCI_GETMARGINRIGHT                            = 2158;
	SCI_GETMODIFY                                 = 2159;
	SCI_SETSEL                                    = 2160;
	SCI_GETSELTEXT                                = 2161;
	SCI_GETTEXTRANGE                              = 2162;
	SCI_HIDESELECTION                             = 2163;
	SCI_POINTXFROMPOSITION                        = 2164;
	SCI_POINTYFROMPOSITION                        = 2165;
	SCI_LINEFROMPOSITION                          = 2166;
	SCI_POSITIONFROMLINE                          = 2167;
	SCI_LINESCROLL                                = 2168;
	SCI_SCROLLCARET                               = 2169;
	SCI_REPLACESEL                                = 2170;
	SCI_SETREADONLY                               = 2171;
	SCI_NULL                                      = 2172;
	SCI_CANPASTE                                  = 2173;
	SCI_CANUNDO                                   = 2174;
	SCI_EMPTYUNDOBUFFER                           = 2175;
	SCI_UNDO                                      = 2176;
	SCI_CUT                                       = 2177;
	SCI_COPY                                      = 2178;
	SCI_PASTE                                     = 2179;
	SCI_CLEAR                                     = 2180;
	SCI_SETTEXT                                   = 2181;
	SCI_GETTEXT                                   = 2182;
	SCI_GETTEXTLENGTH                             = 2183;
	SCI_GETDIRECTFUNCTION                         = 2184;
	SCI_GETDIRECTPOINTER                          = 2185;
	SCI_SETOVERTYPE                               = 2186;
	SCI_GETOVERTYPE                               = 2187;
	SCI_SETCARETWIDTH                             = 2188;
	SCI_GETCARETWIDTH                             = 2189;
	SCI_SETTARGETSTART                            = 2190;
	SCI_GETTARGETSTART                            = 2191;
	SCI_SETTARGETEND                              = 2192;
	SCI_GETTARGETEND                              = 2193;
	SCI_REPLACETARGET                             = 2194;
	SCI_REPLACETARGETRE                           = 2195;
	SCI_SEARCHINTARGET                            = 2197;
	SCI_SETSEARCHFLAGS                            = 2198;
	SCI_GETSEARCHFLAGS                            = 2199;
	SCI_CALLTIPSHOW                               = 2200;
	SCI_CALLTIPCANCEL                             = 2201;
	SCI_CALLTIPACTIVE                             = 2202;
	SCI_CALLTIPPOSSTART                           = 2203;
	SCI_CALLTIPSETHLT                             = 2204;
	SCI_CALLTIPSETBACK                            = 2205;
	SCI_CALLTIPSETFORE                            = 2206;
	SCI_CALLTIPSETFOREHLT                         = 2207;
	SCI_CALLTIPUSESTYLE                           = 2212;
	SCI_VISIBLEFROMDOCLINE                        = 2220;
	SCI_DOCLINEFROMVISIBLE                        = 2221;
	SCI_WRAPCOUNT                                 = 2235;
	SCI_SETFOLDLEVEL                              = 2222;
	SCI_GETFOLDLEVEL                              = 2223;
	SCI_GETLASTCHILD                              = 2224;
	SCI_GETFOLDPARENT                             = 2225;
	SCI_SHOWLINES                                 = 2226;
	SCI_HIDELINES                                 = 2227;
	SCI_GETLINEVISIBLE                            = 2228;
	SCI_SETFOLDEXPANDED                           = 2229;
	SCI_GETFOLDEXPANDED                           = 2230;
	SCI_TOGGLEFOLD                                = 2231;
	SCI_ENSUREVISIBLE                             = 2232;
	SCI_SETFOLDFLAGS                              = 2233;
	SCI_ENSUREVISIBLEENFORCEPOLICY                = 2234;
	SCI_SETTABINDENTS                             = 2260;
	SCI_GETTABINDENTS                             = 2261;
	SCI_SETBACKSPACEUNINDENTS                     = 2262;
	SCI_GETBACKSPACEUNINDENTS                     = 2263;
	SCI_SETMOUSEDWELLTIME                         = 2264;
	SCI_GETMOUSEDWELLTIME                         = 2265;
	SCI_WORDSTARTPOSITION                         = 2266;
	SCI_WORDENDPOSITION                           = 2267;
	SCI_SETWRAPMODE                               = 2268;
	SCI_GETWRAPMODE                               = 2269;
	SCI_SETWRAPVISUALFLAGS                        = 2460;
	SCI_GETWRAPVISUALFLAGS                        = 2461;
	SCI_SETWRAPVISUALFLAGSLOCATION                = 2462;
	SCI_GETWRAPVISUALFLAGSLOCATION                = 2463;
	SCI_SETWRAPSTARTINDENT                        = 2464;
	SCI_GETWRAPSTARTINDENT                        = 2465;
	SCI_SETWRAPINDENTMODE                         = 2472;
	SCI_GETWRAPINDENTMODE                         = 2473;
	SCI_SETLAYOUTCACHE                            = 2272;
	SCI_GETLAYOUTCACHE                            = 2273;
	SCI_SETSCROLLWIDTH                            = 2274;
	SCI_GETSCROLLWIDTH                            = 2275;
	SCI_SETSCROLLWIDTHTRACKING                    = 2516;
	SCI_GETSCROLLWIDTHTRACKING                    = 2517;
	SCI_TEXTWIDTH                                 = 2276;
	SCI_SETENDATLASTLINE                          = 2277;
	SCI_GETENDATLASTLINE                          = 2278;
	SCI_TEXTHEIGHT                                = 2279;
	SCI_SETVSCROLLBAR                             = 2280;
	SCI_GETVSCROLLBAR                             = 2281;
	SCI_APPENDTEXT                                = 2282;
	SCI_GETTWOPHASEDRAW                           = 2283;
	SCI_SETTWOPHASEDRAW                           = 2284;
	SCI_TARGETFROMSELECTION                       = 2287;
	SCI_LINESJOIN                                 = 2288;
	SCI_LINESSPLIT                                = 2289;
	SCI_SETFOLDMARGINCOLOUR                       = 2290;
	SCI_SETFOLDMARGINHICOLOUR                     = 2291;
	SCI_LINEDOWN                                  = 2300;
	SCI_LINEDOWNEXTEND                            = 2301;
	SCI_LINEUP                                    = 2302;
	SCI_LINEUPEXTEND                              = 2303;
	SCI_CHARLEFT                                  = 2304;
	SCI_CHARLEFTEXTEND                            = 2305;
	SCI_CHARRIGHT                                 = 2306;
	SCI_CHARRIGHTEXTEND                           = 2307;
	SCI_WORDLEFT                                  = 2308;
	SCI_WORDLEFTEXTEND                            = 2309;
	SCI_WORDRIGHT                                 = 2310;
	SCI_WORDRIGHTEXTEND                           = 2311;
	SCI_HOME                                      = 2312;
	SCI_HOMEEXTEND                                = 2313;
	SCI_LINEEND                                   = 2314;
	SCI_LINEENDEXTEND                             = 2315;
	SCI_DOCUMENTSTART                             = 2316;
	SCI_DOCUMENTSTARTEXTEND                       = 2317;
	SCI_DOCUMENTEND                               = 2318;
	SCI_DOCUMENTENDEXTEND                         = 2319;
	SCI_PAGEUP                                    = 2320;
	SCI_PAGEUPEXTEND                              = 2321;
	SCI_PAGEDOWN                                  = 2322;
	SCI_PAGEDOWNEXTEND                            = 2323;
	SCI_EDITTOGGLEOVERTYPE                        = 2324;
	SCI_CANCEL                                    = 2325;
	SCI_DELETEBACK                                = 2326;
	SCI_TAB                                       = 2327;
	SCI_BACKTAB                                   = 2328;
	SCI_NEWLINE                                   = 2329;
	SCI_FORMFEED                                  = 2330;
	SCI_VCHOME                                    = 2331;
	SCI_VCHOMEEXTEND                              = 2332;
	SCI_ZOOMIN                                    = 2333;
	SCI_ZOOMOUT                                   = 2334;
	SCI_DELWORDLEFT                               = 2335;
	SCI_DELWORDRIGHT                              = 2336;
	SCI_DELWORDRIGHTEND                           = 2518;
	SCI_LINECUT                                   = 2337;
	SCI_LINEDELETE                                = 2338;
	SCI_LINETRANSPOSE                             = 2339;
	SCI_LINEDUPLICATE                             = 2404;
	SCI_LOWERCASE                                 = 2340;
	SCI_UPPERCASE                                 = 2341;
	SCI_LINESCROLLDOWN                            = 2342;
	SCI_LINESCROLLUP                              = 2343;
	SCI_DELETEBACKNOTLINE                         = 2344;
	SCI_HOMEDISPLAY                               = 2345;
	SCI_HOMEDISPLAYEXTEND                         = 2346;
	SCI_LINEENDDISPLAY                            = 2347;
	SCI_LINEENDDISPLAYEXTEND                      = 2348;
	SCI_HOMEWRAP                                  = 2349;
	SCI_HOMEWRAPEXTEND                            = 2450;
	SCI_LINEENDWRAP                               = 2451;
	SCI_LINEENDWRAPEXTEND                         = 2452;
	SCI_VCHOMEWRAP                                = 2453;
	SCI_VCHOMEWRAPEXTEND                          = 2454;
	SCI_LINECOPY                                  = 2455;
	SCI_MOVECARETINSIDEVIEW                       = 2401;
	SCI_LINELENGTH                                = 2350;
	SCI_BRACEHIGHLIGHT                            = 2351;
	SCI_BRACEBADLIGHT                             = 2352;
	SCI_BRACEMATCH                                = 2353;
	SCI_GETVIEWEOL                                = 2355;
	SCI_SETVIEWEOL                                = 2356;
	SCI_GETDOCPOINTER                             = 2357;
	SCI_SETDOCPOINTER                             = 2358;
	SCI_SETMODEVENTMASK                           = 2359;
	SCI_GETEDGECOLUMN                             = 2360;
	SCI_SETEDGECOLUMN                             = 2361;
	SCI_GETEDGEMODE                               = 2362;
	SCI_SETEDGEMODE                               = 2363;
	SCI_GETEDGECOLOUR                             = 2364;
	SCI_SETEDGECOLOUR                             = 2365;
	SCI_SEARCHANCHOR                              = 2366;
	SCI_SEARCHNEXT                                = 2367;
	SCI_SEARCHPREV                                = 2368;
	SCI_LINESONSCREEN                             = 2370;
	SCI_USEPOPUP                                  = 2371;
	SCI_SELECTIONISRECTANGLE                      = 2372;
	SCI_SETZOOM                                   = 2373;
	SCI_GETZOOM                                   = 2374;
	SCI_CREATEDOCUMENT                            = 2375;
	SCI_ADDREFDOCUMENT                            = 2376;
	SCI_RELEASEDOCUMENT                           = 2377;
	SCI_GETMODEVENTMASK                           = 2378;
	SCI_SETFOCUS                                  = 2380;
	SCI_GETFOCUS                                  = 2381;
	SCI_SETSTATUS                                 = 2382;
	SCI_GETSTATUS                                 = 2383;
	SCI_SETMOUSEDOWNCAPTURES                      = 2384;
	SCI_GETMOUSEDOWNCAPTURES                      = 2385;
	SCI_SETCURSOR                                 = 2386;
	SCI_GETCURSOR                                 = 2387;
	SCI_SETCONTROLCHARSYMBOL                      = 2388;
	SCI_GETCONTROLCHARSYMBOL                      = 2389;
	SCI_WORDPARTLEFT                              = 2390;
	SCI_WORDPARTLEFTEXTEND                        = 2391;
	SCI_WORDPARTRIGHT                             = 2392;
	SCI_WORDPARTRIGHTEXTEND                       = 2393;
	SCI_SETVISIBLEPOLICY                          = 2394;
	SCI_DELLINELEFT                               = 2395;
	SCI_DELLINERIGHT                              = 2396;
	SCI_SETXOFFSET                                = 2397;
	SCI_GETXOFFSET                                = 2398;
	SCI_CHOOSECARETX                              = 2399;
	SCI_GRABFOCUS                                 = 2400;
	SCI_SETXCARETPOLICY                           = 2402;
	SCI_SETYCARETPOLICY                           = 2403;
	SCI_SETPRINTWRAPMODE                          = 2406;
	SCI_GETPRINTWRAPMODE                          = 2407;
	SCI_SETHOTSPOTACTIVEFORE                      = 2410;
	SCI_GETHOTSPOTACTIVEFORE                      = 2494;
	SCI_SETHOTSPOTACTIVEBACK                      = 2411;
	SCI_GETHOTSPOTACTIVEBACK                      = 2495;
	SCI_SETHOTSPOTACTIVEUNDERLINE                 = 2412;
	SCI_GETHOTSPOTACTIVEUNDERLINE                 = 2496;
	SCI_SETHOTSPOTSINGLELINE                      = 2421;
	SCI_GETHOTSPOTSINGLELINE                      = 2497;
	SCI_PARADOWN                                  = 2413;
	SCI_PARADOWNEXTEND                            = 2414;
	SCI_PARAUP                                    = 2415;
	SCI_PARAUPEXTEND                              = 2416;
	SCI_POSITIONBEFORE                            = 2417;
	SCI_POSITIONAFTER                             = 2418;
	SCI_COPYRANGE                                 = 2419;
	SCI_COPYTEXT                                  = 2420;
	SCI_SETSELECTIONMODE                          = 2422;
	SCI_GETSELECTIONMODE                          = 2423;
	SCI_GETLINESELSTARTPOSITION                   = 2424;
	SCI_GETLINESELENDPOSITION                     = 2425;
	SCI_LINEDOWNRECTEXTEND                        = 2426;
	SCI_LINEUPRECTEXTEND                          = 2427;
	SCI_CHARLEFTRECTEXTEND                        = 2428;
	SCI_CHARRIGHTRECTEXTEND                       = 2429;
	SCI_HOMERECTEXTEND                            = 2430;
	SCI_VCHOMERECTEXTEND                          = 2431;
	SCI_LINEENDRECTEXTEND                         = 2432;
	SCI_PAGEUPRECTEXTEND                          = 2433;
	SCI_PAGEDOWNRECTEXTEND                        = 2434;
	SCI_STUTTEREDPAGEUP                           = 2435;
	SCI_STUTTEREDPAGEUPEXTEND                     = 2436;
	SCI_STUTTEREDPAGEDOWN                         = 2437;
	SCI_STUTTEREDPAGEDOWNEXTEND                   = 2438;
	SCI_WORDLEFTEND                               = 2439;
	SCI_WORDLEFTENDEXTEND                         = 2440;
	SCI_WORDRIGHTEND                              = 2441;
	SCI_WORDRIGHTENDEXTEND                        = 2442;
	SCI_SETWHITESPACECHARS                        = 2443;
	SCI_SETCHARSDEFAULT                           = 2444;
	SCI_AUTOCGETCURRENT                           = 2445;
	SCI_ALLOCATE                                  = 2446;
	SCI_TARGETASUTF8                              = 2447;
	SCI_SETLENGTHFORENCODE                        = 2448;
	SCI_ENCODEDFROMUTF8                           = 2449;
	SCI_FINDCOLUMN                                = 2456;
	SCI_GETCARETSTICKY                            = 2457;
	SCI_SETCARETSTICKY                            = 2458;
	SCI_TOGGLECARETSTICKY                         = 2459;
	SCI_SETPASTECONVERTENDINGS                    = 2467;
	SCI_GETPASTECONVERTENDINGS                    = 2468;
	SCI_SELECTIONDUPLICATE                        = 2469;
	SCI_SETCARETLINEBACKALPHA                     = 2470;
	SCI_GETCARETLINEBACKALPHA                     = 2471;
	SCI_SETCARETSTYLE                             = 2512;
	SCI_GETCARETSTYLE                             = 2513;
	SCI_SETINDICATORCURRENT                       = 2500;
	SCI_GETINDICATORCURRENT                       = 2501;
	SCI_SETINDICATORVALUE                         = 2502;
	SCI_GETINDICATORVALUE                         = 2503;
	SCI_INDICATORFILLRANGE                        = 2504;
	SCI_INDICATORCLEARRANGE                       = 2505;
	SCI_INDICATORALLONFOR                         = 2506;
	SCI_INDICATORVALUEAT                          = 2507;
	SCI_INDICATORSTART                            = 2508;
	SCI_INDICATOREND                              = 2509;
	SCI_SETPOSITIONCACHE                          = 2514;
	SCI_GETPOSITIONCACHE                          = 2515;
	SCI_COPYALLOWLINE                             = 2519;
	SCI_GETCHARACTERPOINTER                       = 2520;
	SCI_SETKEYSUNICODE                            = 2521;
	SCI_GETKEYSUNICODE                            = 2522;
	SCI_INDICSETALPHA                             = 2523;
	SCI_INDICGETALPHA                             = 2524;
	SCI_SETEXTRAASCENT                            = 2525;
	SCI_GETEXTRAASCENT                            = 2526;
	SCI_SETEXTRADESCENT                           = 2527;
	SCI_GETEXTRADESCENT                           = 2528;
	SCI_MARKERSYMBOLDEFINED                       = 2529;
	SCI_MARGINSETTEXT                             = 2530;
	SCI_MARGINGETTEXT                             = 2531;
	SCI_MARGINSETSTYLE                            = 2532;
	SCI_MARGINGETSTYLE                            = 2533;
	SCI_MARGINSETSTYLES                           = 2534;
	SCI_MARGINGETSTYLES                           = 2535;
	SCI_MARGINTEXTCLEARALL                        = 2536;
	SCI_MARGINSETSTYLEOFFSET                      = 2537;
	SCI_MARGINGETSTYLEOFFSET                      = 2538;
	SCI_ANNOTATIONSETTEXT                         = 2540;
	SCI_ANNOTATIONGETTEXT                         = 2541;
	SCI_ANNOTATIONSETSTYLE                        = 2542;
	SCI_ANNOTATIONGETSTYLE                        = 2543;
	SCI_ANNOTATIONSETSTYLES                       = 2544;
	SCI_ANNOTATIONGETSTYLES                       = 2545;
	SCI_ANNOTATIONGETLINES                        = 2546;
	SCI_ANNOTATIONCLEARALL                        = 2547;
	SCI_ANNOTATIONSETVISIBLE                      = 2548;
	SCI_ANNOTATIONGETVISIBLE                      = 2549;
	SCI_ANNOTATIONSETSTYLEOFFSET                  = 2550;
	SCI_ANNOTATIONGETSTYLEOFFSET                  = 2551;
	SCI_ADDUNDOACTION                             = 2560;
	SCI_CHARPOSITIONFROMPOINT                     = 2561;
	SCI_CHARPOSITIONFROMPOINTCLOSE                = 2562;
	SCI_SETMULTIPLESELECTION                      = 2563;
	SCI_GETMULTIPLESELECTION                      = 2564;
	SCI_SETADDITIONALSELECTIONTYPING              = 2565;
	SCI_GETADDITIONALSELECTIONTYPING              = 2566;
	SCI_SETADDITIONALCARETSBLINK                  = 2567;
	SCI_GETADDITIONALCARETSBLINK                  = 2568;
	SCI_GETSELECTIONS                             = 2570;
	SCI_CLEARSELECTIONS                           = 2571;
	SCI_SETSELECTION                              = 2572;
	SCI_ADDSELECTION                              = 2573;
	SCI_SETMAINSELECTION                          = 2574;
	SCI_GETMAINSELECTION                          = 2575;
	SCI_SETSELECTIONNCARET                        = 2576;
	SCI_GETSELECTIONNCARET                        = 2577;
	SCI_SETSELECTIONNANCHOR                       = 2578;
	SCI_GETSELECTIONNANCHOR                       = 2579;
	SCI_SETSELECTIONNCARETVIRTUALSPACE            = 2580;
	SCI_GETSELECTIONNCARETVIRTUALSPACE            = 2581;
	SCI_SETSELECTIONNANCHORVIRTUALSPACE           = 2582;
	SCI_GETSELECTIONNANCHORVIRTUALSPACE           = 2583;
	SCI_SETSELECTIONNSTART                        = 2584;
	SCI_GETSELECTIONNSTART                        = 2585;
	SCI_SETSELECTIONNEND                          = 2586;
	SCI_GETSELECTIONNEND                          = 2587;
	SCI_SETRECTANGULARSELECTIONCARET              = 2588;
	SCI_GETRECTANGULARSELECTIONCARET              = 2589;
	SCI_SETRECTANGULARSELECTIONANCHOR             = 2590;
	SCI_GETRECTANGULARSELECTIONANCHOR             = 2591;
	SCI_SETRECTANGULARSELECTIONCARETVIRTUALSPACE  = 2592;
	SCI_GETRECTANGULARSELECTIONCARETVIRTUALSPACE  = 2593;
	SCI_SETRECTANGULARSELECTIONANCHORVIRTUALSPACE = 2594;
	SCI_GETRECTANGULARSELECTIONANCHORVIRTUALSPACE = 2595;
	SCI_SETVIRTUALSPACEOPTIONS                    = 2596;
	SCI_GETVIRTUALSPACEOPTIONS                    = 2597;
	SCI_SETRECTANGULARSELECTIONMODIFIER           = 2598;
	SCI_GETRECTANGULARSELECTIONMODIFIER           = 2599;
	SCI_SETADDITIONALSELFORE                      = 2600;
	SCI_SETADDITIONALSELBACK                      = 2601;
	SCI_SETADDITIONALSELALPHA                     = 2602;
	SCI_GETADDITIONALSELALPHA                     = 2603;
	SCI_SETADDITIONALCARETFORE                    = 2604;
	SCI_GETADDITIONALCARETFORE                    = 2605;
	SCI_ROTATESELECTION                           = 2606;
	SCI_SWAPMAINANCHORCARET                       = 2607;
	SCI_STARTRECORD                               = 3001;
	SCI_STOPRECORD                                = 3002;
	SCI_SETLEXER                                  = 4001;
	SCI_GETLEXER                                  = 4002;
	SCI_COLOURISE                                 = 4003;
	SCI_SETPROPERTY                               = 4004;
	SCI_SETKEYWORDS                               = 4005;
	SCI_SETLEXERLANGUAGE                          = 4006;
	SCI_LOADLEXERLIBRARY                          = 4007;
	SCI_GETPROPERTY                               = 4008;
	SCI_GETPROPERTYEXPANDED                       = 4009;
	SCI_GETPROPERTYINT                            = 4010;
	SCI_GETSTYLEBITSNEEDED                        = 4011;

    { ============================================================= }
    { Other Scintilla constants and message/notification parameters }
    { ============================================================= }

	INVALID_POSITION = - 1;

	SCWS_INVISIBLE          = 0;
	SCWS_VISIBLEALWAYS      = 1;
	SCWS_VISIBLEAFTERINDENT = 2;

	SC_EOL_CRLF = 0;
	SC_EOL_CR   = 1;
	SC_EOL_LF   = 2;

	SC_CP_UTF8 = 65001;
	SC_CP_DBCS = 1;

	MARKER_MAX = 31;

	SC_MARK_CIRCLE               = 0;
	SC_MARK_ROUNDRECT            = 1;
	SC_MARK_ARROW                = 2;
	SC_MARK_SMALLRECT            = 3;
	SC_MARK_SHORTARROW           = 4;
	SC_MARK_EMPTY                = 5;
	SC_MARK_ARROWDOWN            = 6;
	SC_MARK_MINUS                = 7;
	SC_MARK_PLUS                 = 8;
	SC_MARK_VLINE                = 9;
	SC_MARK_LCORNER              = 10;
	SC_MARK_TCORNER              = 11;
	SC_MARK_BOXPLUS              = 12;
	SC_MARK_BOXPLUSCONNECTED     = 13;
	SC_MARK_BOXMINUS             = 14;
	SC_MARK_BOXMINUSCONNECTED    = 15;
	SC_MARK_LCORNERCURVE         = 16;
	SC_MARK_TCORNERCURVE         = 17;
	SC_MARK_CIRCLEPLUS           = 18;
	SC_MARK_CIRCLEPLUSCONNECTED  = 19;
	SC_MARK_CIRCLEMINUS          = 20;
	SC_MARK_CIRCLEMINUSCONNECTED = 21;
	SC_MARK_BACKGROUND           = 22;
	SC_MARK_DOTDOTDOT            = 23;
	SC_MARK_ARROWS               = 24;
	SC_MARK_PIXMAP               = 25;
	SC_MARK_FULLRECT             = 26;
	SC_MARK_LEFTRECT             = 27;
	SC_MARK_AVAILABLE            = 28;
	SC_MARK_UNDERLINE            = 29;
	SC_MARK_CHARACTER            = 10000;
	SC_MARKNUM_FOLDEREND         = 25;
	SC_MARKNUM_FOLDEROPENMID     = 26;
	SC_MARKNUM_FOLDERMIDTAIL     = 27;
	SC_MARKNUM_FOLDERTAIL        = 28;
	SC_MARKNUM_FOLDERSUB         = 29;
	SC_MARKNUM_FOLDER            = 30;
	SC_MARKNUM_FOLDEROPEN        = 31;

	SC_MASK_FOLDERS = $FE000000;

	SC_MARGIN_SYMBOL = 0;
	SC_MARGIN_NUMBER = 1;
	SC_MARGIN_BACK   = 2;
	SC_MARGIN_FORE   = 3;
	SC_MARGIN_TEXT   = 4;
	SC_MARGIN_RTEXT  = 5;

	STYLE_DEFAULT        = 32;
	STYLE_LINENUMBER     = 33;
	STYLE_BRACELIGHT     = 34;
	STYLE_BRACEBAD       = 35;
	STYLE_CONTROLCHAR    = 36;
	STYLE_INDENTGUIDE    = 37;
	STYLE_CALLTIP        = 38;
	STYLE_LASTPREDEFINED = 39;
	STYLE_MAX            = 255;

	SC_CHARSET_ANSI        = 0;
	SC_CHARSET_DEFAULT     = 1;
	SC_CHARSET_BALTIC      = 186;
	SC_CHARSET_CHINESEBIG5 = 136;
	SC_CHARSET_EASTEUROPE  = 238;
	SC_CHARSET_GB2312      = 134;
	SC_CHARSET_GREEK       = 161;
	SC_CHARSET_HANGUL      = 129;
	SC_CHARSET_MAC         = 77;
	SC_CHARSET_OEM         = 255;
	SC_CHARSET_RUSSIAN     = 204;
	SC_CHARSET_CYRILLIC    = 1251;
	SC_CHARSET_SHIFTJIS    = 128;
	SC_CHARSET_SYMBOL      = 2;
	SC_CHARSET_TURKISH     = 162;
	SC_CHARSET_JOHAB       = 130;
	SC_CHARSET_HEBREW      = 177;
	SC_CHARSET_ARABIC      = 178;
	SC_CHARSET_VIETNAMESE  = 163;
	SC_CHARSET_THAI        = 222;
	SC_CHARSET_8859_15     = 1000;

	SC_CASE_MIXED = 0;
	SC_CASE_UPPER = 1;
	SC_CASE_LOWER = 2;

	INDIC_PLAIN     = 0;
	INDIC_SQUIGGLE  = 1;
	INDIC_TT        = 2;
	INDIC_DIAGONAL  = 3;
	INDIC_STRIKE    = 4;
	INDIC_HIDDEN    = 5;
	INDIC_BOX       = 6;
	INDIC_ROUNDBOX  = 7;
	INDIC_MAX       = 31;
	INDIC_CONTAINER = 8;

	INDIC0_MASK = $20;
	INDIC1_MASK = $40;
	INDIC2_MASK = $80;
	INDICS_MASK = $E0;

	SC_IV_NONE        = 0;
	SC_IV_REAL        = 1;
	SC_IV_LOOKFORWARD = 2;
	SC_IV_LOOKBOTH    = 3;

	SC_PRINT_NORMAL                 = 0;
	SC_PRINT_INVERTLIGHT            = 1;
	SC_PRINT_BLACKONWHITE           = 2;
	SC_PRINT_COLOURONWHITE          = 3;
	SC_PRINT_COLOURONWHITEDEFAULTBG = 4;

	SCFIND_WHOLEWORD = 2;
	SCFIND_MATCHCASE = 4;

	SCFIND_WORDSTART = $00100000;
	SCFIND_REGEXP    = $00200000;
	SCFIND_POSIX     = $00400000;

	SC_FOLDLEVELBASE       = $400;
	SC_FOLDLEVELWHITEFLAG  = $1000;
	SC_FOLDLEVELHEADERFLAG = $2000;
	SC_FOLDLEVELNUMBERMASK = $0FFF;

	SC_FOLDFLAG_LINEBEFORE_EXPANDED   = $0002;
	SC_FOLDFLAG_LINEBEFORE_CONTRACTED = $0004;
	SC_FOLDFLAG_LINEAFTER_EXPANDED    = $0008;
	SC_FOLDFLAG_LINEAFTER_CONTRACTED  = $0010;
	SC_FOLDFLAG_LEVELNUMBERS          = $0040;

	SC_TIME_FOREVER = 10000000;

	SC_WRAP_NONE = 0;
	SC_WRAP_WORD = 1;
	SC_WRAP_CHAR = 2;

	SC_WRAPVISUALFLAG_NONE  = $0000;
	SC_WRAPVISUALFLAG_END   = $0001;
	SC_WRAPVISUALFLAG_START = $0002;

	SC_WRAPVISUALFLAGLOC_DEFAULT       = $0000;
	SC_WRAPVISUALFLAGLOC_END_BY_TEXT   = $0001;
	SC_WRAPVISUALFLAGLOC_START_BY_TEXT = $0002;

	SC_WRAPINDENT_FIXED  = 0;
	SC_WRAPINDENT_SAME   = 1;
	SC_WRAPINDENT_INDENT = 2;

	SC_CACHE_NONE     = 0;
	SC_CACHE_CARET    = 1;
	SC_CACHE_PAGE     = 2;
	SC_CACHE_DOCUMENT = 3;

	EDGE_NONE       = 0;
	EDGE_LINE       = 1;
	EDGE_BACKGROUND = 2;

	SC_STATUS_OK       = 0;
	SC_STATUS_FAILURE  = 1;
	SC_STATUS_BADALLOC = 2;

	SC_CURSORNORMAL = - 1;
	SC_CURSORWAIT   = 4;

	VISIBLE_SLOP   = $01;
	VISIBLE_STRICT = $04;

	CARET_SLOP   = $01;
	CARET_STRICT = $04;
	CARET_JUMPS  = $10;
	CARET_EVEN   = $08;

	SC_SEL_STREAM    = 0;
	SC_SEL_RECTANGLE = 1;
	SC_SEL_LINES     = 2;
	SC_SEL_THIN      = 3;

	SC_ALPHA_TRANSPARENT = 0;
	SC_ALPHA_OPAQUE      = 255;
	SC_ALPHA_NOALPHA     = 256;

	CARETSTYLE_INVISIBLE = 0;
	CARETSTYLE_LINE      = 1;
	CARETSTYLE_BLOCK     = 2;

	ANNOTATION_HIDDEN   = 0;
	ANNOTATION_STANDARD = 1;
	ANNOTATION_BOXED    = 2;

	UNDO_MAY_COALESCE = 1;

	SCVS_NONE                 = 0;
	SCVS_RECTANGULARSELECTION = 1;
	SCVS_USERACCESSIBLE       = 2;

	KEYWORDSET_MAX = 8;

	SC_MOD_INSERTTEXT       = $1;
	SC_MOD_DELETETEXT       = $2;
	SC_MOD_CHANGESTYLE      = $4;
	SC_MOD_CHANGEFOLD       = $8;
	SC_PERFORMED_USER       = $10;
	SC_PERFORMED_UNDO       = $20;
	SC_PERFORMED_REDO       = $40;
	SC_MULTISTEPUNDOREDO    = $80;
	SC_LASTSTEPINUNDOREDO   = $100;
	SC_MOD_CHANGEMARKER     = $200;
	SC_MOD_BEFOREINSERT     = $400;
	SC_MOD_BEFOREDELETE     = $800;
	SC_MULTILINEUNDOREDO    = $1000;
	SC_STARTACTION          = $2000;
	SC_MOD_CHANGEINDICATOR  = $4000;
	SC_MOD_CHANGELINESTATE  = $8000;
	SC_MOD_CHANGEMARGIN     = $10000;
	SC_MOD_CHANGEANNOTATION = $20000;
	SC_MOD_CONTAINER        = $40000;
	SC_MODEVENTMASKALL      = $7FFFF;

	SC_SEARCHRESULT_LINEBUFFERMAXLENGTH = 1024;

	SCEN_CHANGE    = 768;
	SCEN_SETFOCUS  = 512;
	SCEN_KILLFOCUS = 256;

	SCK_DOWN     = 300;
	SCK_UP       = 301;
	SCK_LEFT     = 302;
	SCK_RIGHT    = 303;
	SCK_HOME     = 304;
	SCK_END      = 305;
	SCK_PRIOR    = 306;
	SCK_NEXT     = 307;
	SCK_DELETE   = 308;
	SCK_INSERT   = 309;
	SCK_ESCAPE   = 7;
	SCK_BACK     = 8;
	SCK_TAB      = 9;
	SCK_RETURN   = 13;
	SCK_ADD      = 310;
	SCK_SUBTRACT = 311;
	SCK_DIVIDE   = 312;
	SCK_WIN      = 313;
	SCK_RWIN     = 314;
	SCK_MENU     = 315;

	SCMOD_NORM  = 0;
	SCMOD_SHIFT = 1;
	SCMOD_CTRL  = 2;
	SCMOD_ALT   = 4;
	SCMOD_SUPER = 8;

	SCN_STYLENEEDED        = 2000;
	SCN_CHARADDED          = 2001;
	SCN_SAVEPOINTREACHED   = 2002;
	SCN_SAVEPOINTLEFT      = 2003;
	SCN_MODIFYATTEMPTRO    = 2004;
	SCN_KEY                = 2005;
	SCN_DOUBLECLICK        = 2006;
	SCN_UPDATEUI           = 2007;
	SCN_MODIFIED           = 2008;
	SCN_MACRORECORD        = 2009;
	SCN_MARGINCLICK        = 2010;
	SCN_NEEDSHOWN          = 2011;
	SCN_PAINTED            = 2013;
	SCN_USERLISTSELECTION  = 2014;
	SCN_URIDROPPED         = 2015;
	SCN_DWELLSTART         = 2016;
	SCN_DWELLEND           = 2017;
	SCN_ZOOM               = 2018;
	SCN_HOTSPOTCLICK       = 2019;
	SCN_HOTSPOTDOUBLECLICK = 2020;
	SCN_CALLTIPCLICK       = 2021;
	SCN_AUTOCSELECTION     = 2022;
	SCN_INDICATORCLICK     = 2023;
	SCN_INDICATORRELEASE   = 2024;
	SCN_AUTOCCANCELLED     = 2025;
	SCN_AUTOCCHARDELETED   = 2026;
	SCN_SCROLLED           = 2080;

    { =========================== }
    { Notepad++ Docking interface }
    { =========================== }

	DMM_MSG            = $5000;
	DMM_CLOSE          = (DMM_MSG + 1);
	DMM_DOCK           = (DMM_MSG + 2);
	DMM_FLOAT          = (DMM_MSG + 3);
	DMM_DOCKALL        = (DMM_MSG + 4);
	DMM_FLOATALL       = (DMM_MSG + 5);
	DMM_MOVE           = (DMM_MSG + 6);
	DMM_UPDATEDISPINFO = (DMM_MSG + 7);
	DMM_GETIMAGELIST   = (DMM_MSG + 8);
	DMM_GETICONPOS     = (DMM_MSG + 9);
	DMM_DROPDATA       = (DMM_MSG + 10);
	DMM_MOVE_SPLITTER  = (DMM_MSG + 11);
	DMM_CANCEL_MOVE    = (DMM_MSG + 12);
	DMM_LBUTTONUP      = (DMM_MSG + 13);

	DMN_FIRST = 1050;
	DMN_CLOSE = (DMN_FIRST + 1);
	//nmhdr.code = DWORD(DMN_CLOSE, 0));
	//nmhdr.hwndFrom = hwndNpp;
	//nmhdr.idFrom = ctrlIdNpp;

	DMN_DOCK  = (DMN_FIRST + 2);
	DMN_FLOAT = (DMN_FIRST + 3);
	//nmhdr.code = DWORD(DMN_XXX, int newContainer);
	//nmhdr.hwndFrom = hwndNpp;
	//nmhdr.idFrom = ctrlIdNpp;

    { Styles for containers }
	CAPTION_TOP    = True;
	CAPTION_BOTTOM = False;

    { Defines for docking manager }
	CONT_LEFT    = 0;
	CONT_RIGHT   = 1;
	CONT_TOP     = 2;
	CONT_BOTTOM  = 3;
	DOCKCONT_MAX = 4;

    { Mask params for plugins of internal dialogs }
	DWS_ICONTAB   = $00000001; // Icon for tabs are available
	DWS_ICONBAR   = $00000002; // Icon for icon bar are available (currently not supported)
	DWS_ADDINFO   = $00000004; // Additional information are in use
	DWS_PARAMSALL = DWS_ICONTAB or DWS_ICONBAR or DWS_ADDINFO;

    { Default docking values for first call of plugin }
	DWS_DF_CONT_LEFT   = CONT_LEFT shl 28;   // default docking on left
	DWS_DF_CONT_RIGHT  = CONT_RIGHT shl 28;  // default docking on right
	DWS_DF_CONT_TOP    = CONT_TOP shl 28;    // default docking on top
	DWS_DF_CONT_BOTTOM = CONT_BOTTOM shl 28; // default docking on bottom
	DWS_DF_FLOATING    = $80000000;          // default state is floating

	HIT_TEST_THICKNESS = 20;
	SPLITTER_WIDTH     = 4;

type
	{ TNppTbData (struct tTbData) }
    { Docking info structure for notepad++ }
	TNppTbData = record
		hClient: HWND;  // client Window Handle
		pszName: PChar; // name of plugin (shown in window)
		dlgID: integer; // a funcItem provides the function pointer to start a dialog. Please parse here these ID

        // user modifications
		uMask: UINT;       // mask params: look to above defines
		hIconTab: HICON;   // icon for tabs
		pszAddInfo: PChar; // for plugin to display additional informations

        // internal data, do not use!
		rcFloat: TRect;       // floating position
		iPrevCont: integer;   // stores the privious container (toggling between float and dock)
		pszModuleName: PChar; // it's the plugin file name. It's used to identify the plugin
	end;

    { TNppDockMgr (struct tDockMgr) }
    { Notepad++ Dock manager infos. }
	tDockMgr = record
		Wnd: HWND;                                        // the docking manager wnd
		rcRegion: array [0 .. DOCKCONT_MAX - 1] of TRect; // position of docked dialogs
	end;

implementation

end.
