//
// EvilLibrary by EvilWorks 2010-2013
//
// Name: 					TextUtils
// Description: 			A collection of various pure pascal string parsing functions.
// File last change date:   January 25th. 2013
// File version: 			Dev 0.0.0
// Licence:                 Public Domain.
//

unit TextUtils;

interface

const
	CEmpty          = '';
	CTab            = #9;
	CLf             = #10;
	CCr             = #13;
	CCrLf           = CCr + CLf;
	CSpace          = ' ';
	C0              = '0';
	C1              = '1';
	C2              = '2';
	C3              = '3';
	C4              = '4';
	C5              = '5';
	C6              = '6';
	C7              = '7';
	C8              = '8';
	C9              = '9';
	CDot            = '.';
	CComma          = ',';
	CDoubleQuote    = '"';
	CSingleQuote    = '''';
	CColon          = ':';
	CSemiColon      = ';';
	CEquals         = '=';
	CMonkey         = '@';
	CPercent        = '%';
	CPlus           = '+';
	CMinus          = '-';
	CLBracket       = '(';
	CRBracket       = ')';
	CLSquareBracket = '[';
	CRSquareBracket = ']';
	CLCurlyBracket  = '{';
	CRCurlyBracket  = '}';
	CAsterisk       = '*';
	CExclam         = '!';
	CLessThan       = '<';
	CGreaterThan    = '>';
	CLadder         = '#';
	CFrontSlash     = '/';
	CBackSlash      = '\';
	CQuestionMark   = '?';
	CAmpersand      = '&';
	CDollar         = '$';

	CTrue               = 'True';
	CFalse              = 'False';
	CURIPrefixDelimiter = '://';
	CURISchemeDelimiter = '://';
	CComment            = '//';

	CNums            = '0123456789';
	CAlphaUpper      = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
	CAlphaLower      = 'abcdefghijklmnopqrstuvwxyz';
	CAlpha           = CAlphaUpper + CAlphaLower;
	CAlphaNums       = CNums + CAlpha;
	CVowelsLower     = 'aeiou';
	CVowelsUpper     = 'AEIOU';
	CVowels          = CVowelsLower + CVowelsUpper;
	CConsonantsLower = 'bcdfghjklmnpqrstvxyz';
	CConsonantsUpper = 'BCDFGHJKLMNPQRSTVXYZ';
	CConsonants      = CConsonantsLower + CConsonantsUpper;

	CPercentEncodedSpace = '%20';
	CURIGenReservedChars = [':', '/', '?', '#', '[', ']', '@'];
	CURISubReservedChars = ['!', '$', '&', '''', '(', ')', '*', '+', ',', ';', '='];
	CURLUnreservedChars  = ['A' .. 'Z', 'a' .. 'z', '0' .. '9', '-', '_', '.', '~'];
	CURIReservedChars    = cURIGenReservedChars + cURISubReservedChars + [cPercent];

type
	{ Forward declarations }
	TTokensEnumerator = class;

	{ TSplitOption }
	{ Options for TextSplit(), TextTokenize() }
	TSplitOption = (
	  soNoDelSep,  // Tokens will be added to list along with their trailing separators.
	  soCSSep,     // Token separators are treated as Case Sensitive. SPEEDS UP! parsing.
	  soCSQot,     // Quote character/string is treated as Case Sensitive. SPEEDS UP! parsing if [soQuoted].
	  soSingleSep, // Splitting will stop after the first separator; Two tokens total.
	  soQuoted,    // Treat strings quoted/enclosed in Quote as single token.
	  soRemQuotes  // Remove Quote from parsed out tokens.
	  );
	TSplitOptions = set of TSplitOption;

    { TPair }
    { Your standard Key=Value pair record. }
	TPair = record
		Key: string;
		Val: string;
	end;

    { TTokens }
    { A helpful text array container for all sorts of formatting and parsing. }
    { Can be declared as standalone (initialize with Clear), or returned by TextTokenize(). }
	TTokens = record
	private
		FTokens: TArray<string>;
		FCount : Integer;
		function GetToken(const aIndex: Integer): string;
		procedure QuickSort(aStart, aEnd: Integer);
		function GetPair(const aIndex: integer): TPair;
	public
		function GetEnumerator: TTokensEnumerator;

		function FromToken(const aIndex: Integer; const aDelimiter: string = CSpace): string;
		function ToToken(const aIndex: Integer; const aDelimiter: string = CSpace): string;
		function AllTokens(const aDelimiter: string = CSpace): string;

		procedure Add(const aText: string); overload;

		procedure Add(const aKey, aVal: string); overload;
		procedure Add(const aKey: string; const aVal: integer); overload;
		procedure Add(const aKey: string; const aVal: boolean); overload;

		procedure AddQ(const aKey, aVal: string); overload;
		procedure AddQ(const aKey: string; const aVal: integer); overload;
		procedure AddQ(const aKey: string; const aVal: boolean); overload;

		procedure Exchange(aIndexA, aIndexB: Integer);
		procedure Sort;
		procedure Clear;

		function ToArray(const aFromToken: integer = 0; const aToToken: integer = maxint): TArray<string>; overload;

		property Token[const aIndex: Integer]: string read GetToken; default;
		property Pair[const aIndex: integer]: TPair read GetPair;
		property Count: Integer read FCount;
		function Empty: boolean;
	end;

    { TTokensEnumerator }
    { Enumerator for TTokens. }
	TTokensEnumerator = class
	private
		FIndex : integer;
		FTokens: TTokens;
	public
		constructor Create(aTokens: TTokens);
		function GetCurrent: string; inline;
		function MoveNext: Boolean; inline;
		property Current: string read GetCurrent;
	end;

{ Basic string handling }
function TextPos(const aText, aSubText: string; const aCaseSens: boolean = False; const aOfs: Integer = 1): Integer;
{ function TextCompare(const aTextA, aTextB: string): integer; }
function TextCopy(const aText: string; const aStartIdx, aCount: Integer): string;
function TextUpCase(const aText: string): string;
function TextLoCase(const aText: string): string;
function TextTrim(const aText: string): string;
function TextReplace(const aText, aSubText, aNewText: string; const aCaseSens: boolean = False): string;
procedure TextAppend(var aText: string; const aAppendWith: string);

{ More exotic functions of basic variety }
procedure TextAppendWithFeed(var aText: string; const aAppendWith: string);
procedure TextKeyValueAppend(var aOutStr: string; const aKey, aValue: string; const aAnd: boolean = True);
function TextEscStr(const aText, aEscape: string): string;

{ Comparison, extraction, splitting, tokenizing... }
function TextLeft(const aText: string; const aCount: Integer): string;
function TextRight(const aText: string; const aCount: Integer): string;
function TextBegins(const aText, aBeginsWith: string; aCaseSens: boolean = False): boolean;
function TextEnds(const aText, aEndsWith: string; aCaseSens: boolean = False): boolean;
function TextSame(const aTextA, aTextB: string; const aCaseSens: boolean = False): boolean;
function TextInText(const aText, aContainsText: string; const aCaseSens: boolean = False): boolean;
function TextInArray(const aText: string; const aArray: array of string; const aAnywhere: boolean = True; const aCaseSens: boolean = False): boolean;
function TextWildcard(const aText, aWildCard: string): boolean;
function TextEnclosed(const aText, aLeftSide, aRightSide: string; const aCaseSens: boolean = False): boolean; overload;
function TextEnclosed(const aText, aEnclosedWith: string; const aCaseSens: boolean = False): boolean; overload;
function TextEnclose(const aText, aEncloseWith: string): string;
function TextUnEnclose(const aText, aEnclosedWith: string; const aCaseSens: boolean = False): string; overload;
function TextUnEnclose(const aText, aLeftSide, aRightSide: string; const aCaseSens: boolean = False): string; overload;
function TextFindEnclosed(const aText, aEnclLeft, aEnclRight: string; const aIdx: Integer; const aRemEncl: boolean = True; const aCaseSens: boolean = False): string; overload;
function TextFindEnclosed(const aText, aEncl: string; const aIdx: Integer; const aRemEncl: boolean = True; const aCaseSens: boolean = False): string; overload;
function TextQuote(const aText: string): string;
function TextUnquote(const aText: string): string;
function TextRemoveLineFeeds(const aText: string): string;
function TextExtractLeft(var aText: string; const aSep: string; const aCaseSens: boolean = False; const aDelSep: boolean = True): string;
function TextExtractRight(var aText: string; const aSep: string; const aCaseSens: boolean = False; const aDelSep: boolean = True): string;
function TextFetchLeft(const aText, aSep: string; const aCaseSens: boolean = False; const aEmptyIfNoSep: boolean = True): string;
function TextFetchRight(const aText, aSep: string; const aCaseSens: boolean = False; const aEmptyIfNoSep: boolean = True; const aSepFromRight: boolean = True): string;
function TextFetchLine(const aText: string): string;
function TextRemoveLeft(const aText, aRemove: string; const aCaseSens: boolean = False): string;
function TextRemoveRight(const aText, aRemove: string; const aCaseSens: boolean = False): string;
function TextSplit(const aText: string; const aSep: string = CSpace; const aQotStr: string = CDoubleQuote; const aOptions: TSplitOptions = [soCSSep, soCSQot]): TArray<string>;
function TextSplitMarkup(const aText: string; const aTrim: boolean = True): TArray<string>;
function TextTokenize(const aText: string; const aSep: string = CSpace; const aQotStr: string = CDoubleQuote; const aOptions: TSplitOptions = [soCSSep, soCSQot]): TTokens;
function TextToken(const aText: string; const aIndex: integer; const aSeparator: string = CSpace): string;

{ Conversion and formating rotines }
function TextToInt(const aText: string; const aDefault: Integer): Integer;
function TextFromBool(const aBoolean: boolean; const aUseBoolStrings: boolean = True): string;
function TextFromInt(const aByte: byte): string; overload;
function TextFromInt(const aInteger: integer): string; overload;
function TextFromInt(const aCardinal: cardinal): string; overload;
function TextFromInt(const aInt64: int64): string; overload;
function TextFromFloat(const aFloat: double; const aDecimals: byte = 6): string; overload;
function TextFromFloat(const aExtended: extended; const aDecimals: byte = 6): string; overload;
function TextHexToDec(const aHexStr: string): cardinal;
function TextIntToHex(aValue: cardinal; const aDigits: integer): string;
function TextMake(const aArgs: array of const; const aSeparator: string = ' '): string;

{ URI text related functions }
function TextURISplit(const aURI: string; var aPrefix, aHost, aPath: string): boolean; overload;
function TextURISplit(const aURI: string; var aPrefix, aHost, aPath, aParams: string): boolean; overload;
function TextURIGetPath(const aURI: string): string;
function TextURIExtractParams(const aURI: string): string;
function TextURIWithoutParams(const aURI: string): string;

{ Various utility functions }
function TextDump(const aData: pByte; const aSize: integer; const aBytesPerLine: byte = 16): string;
procedure TextSave(const aText, aFileName: string);
function TextOfChar(const aChar: char; const aLength: integer): string;

{ IRC related functions }
function SplitHostMask(const aHostMask: string; var aNickname, aIdent, aHost: string): boolean;

{ Random string generation functions }
function RandomNum: char;
function RandomNums(const aLength: byte): string;
function RandomAlphaLower: char;
function RandomAlphaLowers(const aLength: byte): string;
function RandomAlphaUpper: char;
function RandomAlphaUppers(const aLength: byte): string;
function RandomVowelLower: char;
function RandomVowelUpper: char;
function RandomVowel: char;
function RandomConsonantLower: char;
function RandomConsonantUpper: char;
function RandomConsonant: char;
function RandomString(const aLength: Integer; const aLowerCase, aUpperCase, aNumeric: boolean): string; overload;

{ URI functions }
function URIEncode(const aStr: ansistring): string; overload;
function URIEncode(const aStr: UTF8String): string; overload;
function URIEncode(const aStr: unicodestring): string; overload;
function URIDecode(const aStr: string): string;

function URIEncodeQueryString(const aStr: UTF8String): string; overload;
function URIEncodeQueryString(const aStr: unicodestring): string; overload;
function URIEncodeQueryString(const aStr: ansistring): string; overload;
function URIDecodeQueryString(const aStr: string): string;

implementation
uses StrUtils, SysUtils;

{ Lifted from StrUtils.
function PosEx(const SubStr, S: string; Offset: integer = 1): integer;
asm
	TEST  EAX, EAX
	JZ    @Nil
	TEST  EDX, EDX
	JZ    @Nil
	DEC   ECX
	JL    @Nil

	PUSH  ESI
	PUSH  EBX
	PUSH  0
	push  0
	MOV   ESI,ECX
	CMP   word ptr [EAX-10],2
	JE    @substrisunicode

	PUSH  EDX
	MOV   EDX, EAX
	LEA   EAX, [ESP+4]
	CALL  System.@UStrFromLStr
	POP   EDX
	MOV   EAX, [ESP]

@substrisunicode:
	CMP   word ptr [EDX-10],2
	JE    @strisunicode

	PUSH  EAX
	LEA   EAX,[ESP+8]
	CALL  System.@UStrFromLStr
	POP   EAX
	MOV   EDX, [ESP+4]

@strisunicode:
	MOV   ECX,ESI
	MOV   ESI, [EDX-4]  //Length(Str)
	MOV   EBX, [EAX-4]  //Length(Substr)
	SUB   ESI, ECX      //effective length of Str
	SHL   ECX, 1        //double count of offset due to being wide char
	ADD   EDX, ECX      //addr of the first char at starting position
	CMP   ESI, EBX
	JL    @Past         //jump if EffectiveLength(Str)<Length(Substr)
	test  EBX, EBX
	JLE   @Past         //jump if Length(Substr)<=0

	add   ESP, -12
	ADD   EBX, -1             //Length(Substr)-1
	SHL   ESI,1               //double it due to being wide char
	ADD   ESI, EDX            //addr of the terminator
	SHL   EBX,1               //double it due to being wide char
	ADD   EDX, EBX            //addr of the last char at starting position
	MOV   [ESP+8], ESI        //save addr of the terminator
	ADD   EAX, EBX            //addr of the last char of Substr
	SUB   ECX, EDX            //-@Str[Length(Substr)]
	NEG   EBX                 //-(Length(Substr)-1)
	MOV   [ESP+4], ECX        //save -@Str[Length(Substr)]
	MOV   [ESP], EBX          //save -(Length(Substr)-1)
	MOVZX ECX, word ptr [EAX] //the last char of Substr

@Loop:
	CMP   CX, [EDX]
	JZ    @Test0
@AfterTest0:
	CMP   CX, [EDX+2]
	JZ    @TestT
@AfterTestT:
	ADD   EDX, 8
	CMP   EDX, [ESP+8]
	JB   @Continue
@EndLoop:
	ADD   EDX, -4
	CMP   EDX, [ESP+8]
	JB    @Loop
@Exit:
	ADD   ESP, 12
@Past:
	MOV   EAX, [ESP]
	OR    EAX, [ESP+4]
	JZ    @PastNoClear
	MOV   EAX, ESP
	MOV   EDX, 2
	CALL  System.@UStrArrayClr
@PastNoClear:
	ADD   ESP, 8
	POP   EBX
	POP   ESI
@Nil:
	XOR   EAX, EAX
	RET
@Continue:
	CMP   CX, [EDX-4]
	JZ    @Test2
	CMP   CX, [EDX-2]
	JNZ   @Loop
@Test1:
	ADD   EDX,  2
@Test2:
	ADD   EDX, -4
@Test0:
	ADD   EDX, -2
@TestT:
	MOV   ESI, [ESP]
	TEST  ESI, ESI
	JZ    @Found
@String:
	MOV   EBX, [ESI+EAX]
	CMP   EBX, [ESI+EDX+2]
	JNZ   @AfterTestT
	CMP   ESI, -4
	JGE   @Found
	MOV   EBX, [ESI+EAX+4]
	CMP   EBX, [ESI+EDX+6]
	JNZ   @AfterTestT
	ADD   ESI, 8
	JL    @String
@Found:
	MOV   EAX, [ESP+4]
	ADD   EDX, 4

	CMP   EDX, [ESP+8]
	JA    @Exit

	ADD   ESP, 12
	MOV   ECX, [ESP]
	OR    ECX, [ESP+4]
	JZ    @NoClear

	MOV   EBX, EAX
	MOV   ESI, EDX
	MOV   EAX, ESP
	MOV   EDX, 2
	CALL  System.@UStrArrayClr
	MOV   EAX, EBX
	MOV   EDX, ESI

@NoClear:
	ADD   EAX, EDX
	SHR   EAX, 1  //divide by 2 to make an index
	ADD   ESP, 8
	POP   EBX
	POP   ESI
end;

{ Lifted from SysUtils.
function SameText(const aTextA, aTextB: string): Boolean; assembler;
asm
    CMP     EAX,EDX
    JZ      @1
    OR      EAX,EAX
    JZ      @2
    OR      EDX,EDX
    JZ      @3
    MOV     ECX,[EAX-4]
    CMP     ECX,[EDX-4]
    JNE     @3
    CALL    TextCompare
    TEST    EAX,EAX
    JNZ     @3
@1:     MOV     AL,1
@2:     RET
@3:     XOR     EAX,EAX
end;

{ Combines Pos and PosEx. }
function TextPos(const aText, aSubText: string; const aCaseSens: boolean = False; const aOfs: Integer = 1): Integer;
begin
	if (aCaseSens = False) then
		Result := PosEx(TextLoCase(aSubText), TextLoCase(aText), aOfs)
	else
		Result := PosEx(aSubText, aText, aOfs);
end;

{ Lifted from SysUtils (CompareText).
function TextCompare(const aTextA, aTextB: string): integer;
// The function CompareText is licensed under the CodeGear license terms.
// The initial developer of the original code is Fastcode
// Portions created by the initial developer are Copyright (C) 2002-2004
// the initial developer. All Rights Reserved.
// Contributor(s): John O'Harrow
// This is the unicode string version.
asm
	TEST   EAX, EAX
	JNZ    @@CheckS2
	TEST   EDX, EDX
	JZ     @@Ret
	MOV    EAX, [EDX-4]
	NEG    EAX
@@Ret:
	RET
@@CheckS2:
	TEST   EDX, EDX
	JNZ    @@Compare
	MOV    EAX, [EAX-4]
	RET
@@Compare:
	PUSH   EBX
	PUSH   EBP
	PUSH   ESI
	PUSH   0
	PUSH   0
	CMP    WORD PTR [EAX-10],2
	JE     @@S1IsUnicode

	PUSH   EDX
	MOV    EDX,EAX
	LEA    EAX,[ESP+4]
	CALL   System.@UStrFromLStr
	POP    EDX
	MOV    EAX,[ESP]

@@S1IsUnicode:
	CMP    WORD PTR [EDX-10],2
	JE     @@S2IsUnicode

	PUSH   EAX
	LEA    EAX,[ESP+8]
	CALL   System.@UStrFromLStr
	POP    EAX
	MOV    EDX,[ESP+4]

@@S2IsUnicode:
	MOV    EBP, [EAX-4]     //length(S1)
	MOV    EBX, [EDX-4]     //length(S2)
	SUB    EBP, EBX         //Result if All Compared Characters Match
	SBB    ECX, ECX
	AND    ECX, EBP
	ADD    ECX, EBX         //min(length(S1),length(S2)) = Compare Length
	LEA    ESI, [EAX+ECX*2] //Last Compare Position in S1
	ADD    EDX, ECX         //Last Compare Position in S2
	ADD    EDX, ECX         //Last Compare Position in S2
	NEG    ECX
	JZ     @@SetResult                //Exit if Smallest Length = 0
@@Loop:                               //Load Next 2 Chars from S1 and S2
	//May Include Null Terminator
	MOV    EAX, [ESI+ECX*2]
	MOV    EBX, [EDX+ECX*2]
	CMP    EAX,EBX
	JE     @@Next           //Next 2 Chars Match
	CMP    AX,BX
	JE     @@SecondPair     //First Char Matches
	AND    EAX,$0000FFFF
	AND    EBX,$0000FFFF
	CMP    EAX, 'a'
	JL     @@UC1
	CMP    EAX, 'z'
	JG     @@UC1
	SUB    EAX, 'a'-'A'
@@UC1:
	CMP    EBX, 'a'
	JL     @@UC2
	CMP    EBX, 'z'
	JG     @@UC2
	SUB    EBX, 'a'-'A'
@@UC2:
	SUB    EAX,EBX          //Compare Both Uppercase Chars
	JNE    @@Done           //Exit with Result in EAX if Not Equal
	MOV    EAX, [ESI+ECX*2] //Reload Same 2 Chars from S1
	MOV    EBX, [EDX+ECX*2] //Reload Same 2 Chars from S2
	AND    EAX,$FFFF0000
	AND    EBX,$FFFF0000
	CMP    EAX,EBX
	JE     @@Next           //Second Char Matches
@@SecondPair:
	SHR    EAX, 16
	SHR    EBX, 16
	CMP    EAX, 'a'
	JL     @@UC3
	CMP    EAX, 'z'
	JG     @@UC3
	SUB    EAX, 'a'-'A'
@@UC3:
	CMP    EBX, 'a'
	JL     @@UC4
	CMP    EBX, 'z'
	JG     @@UC4
	SUB    EBX, 'a'-'A'
@@UC4:
	SUB    EAX,EBX           //Compare Both Uppercase Chars
	JNE    @@Done            //Exit with Result in EAX if Not Equal
@@Next:
	ADD    ECX, 2
	JL     @@Loop           //Loop until All required Chars Compared
@@SetResult:
	MOV    EAX,EBP          //All Matched, Set Result from Lengths
@@Done:
	MOV    ECX,ESP
	MOV    EDX,[ECX]
	OR     EDX,[ECX + 4]
	JZ     @@NoClear
	PUSH   EAX
	MOV    EAX,ECX
	MOV    EDX,2
	CALL   System.@LStrArrayClr
	POP    EAX
@@NoClear:
	ADD    ESP,8
	POP    ESI
	POP    EBP
	POP    EBX
end;

{ Safe Copy. Won't go apeshit if aStartIdx is > Length(aText), instead it just returns empty string. }
function TextCopy(const aText: string; const aStartIdx, aCount: Integer): string;
begin
	{ Safe Copy. Won't go apeshit if aStartIdx is > Length(aText). }
	if (aStartIdx > Length(aText)) then
		Exit(CEmpty);
	Result := Copy(aText, aStartIdx, aCount);
end;

{ Uppercase }
function TextUpCase(const aText: string): string;
var
	i: integer;
begin
	SetLength(Result, Length(aText));
	for i := 0 to Length(aText) - 1 do
	begin
		if CharInSet(aText[i], ['a' .. 'z']) then
			Result[i] := char(Ord(aText[i]) and not $20)
		else
			Result[i] := aText[i];
	end;
end;

{ Lowercase }
function TextLoCase(const aText: string): string;
var
	i: integer;
begin
	SetLength(Result, Length(aText));
	for i := 0 to Length(aText) - 1 do
	begin
		if CharInSet(aText[i], ['A' .. 'Z']) then
			Result[i] := char(Ord(aText[i]) or $20)
		else
			Result[i] := aText[i];
	end;
end;

{ TextTrim }
function TextTrim(const aText: string): string;
var
	i, l: Integer;
begin
	l := Length(aText);
	i := 1;
	if (l > 0) and (aText[i] > ' ') and (aText[l] > ' ') then
		Exit(aText);
	while (i <= l) and (aText[i] <= ' ') do
		Inc(i);
	if i > l then
		Exit('');
	while aText[l] <= ' ' do
		Dec(l);
	Result := Copy(aText, i, l - i + 1);
end;

{ Replaces all occurances of aSubText with aNewText in aText. }
function TextReplace(const aText, aSubText, aNewText: string; const aCaseSens: boolean = False): string;
var
	i: Integer;
	j: Integer;
begin
	Result := CEmpty;

	if (aText = CEmpty) then
		Exit;

	j := 1;
	while (True) do
	begin
		i := TextPos(aText, aSubText, aCaseSens, j);
		if (i > 0) then
		begin
			Result := Result + TextCopy(aText, j, i - j) + aNewText;
			i      := i + Length(aSubText);
			j      := i;
		end
		else
		begin
			Result := Result + TextRight(aText, Length(aText) - j + 1);
			Exit;
		end;
	end;
end;

{ Append aText with aAppendWith }
procedure TextAppend(var aText: string; const aAppendWith: string);
begin
	aText := aText + aAppendWith;
end;

{ Append aText with aAppendWith and CRLF. }
procedure TextAppendWithFeed(var aText: string; const aAppendWith: string);
begin
	aText := aText + aAppendWith + CCrLf;
end;

{ Append aKey="aValue" pair to aOutStr and add ', ' if aAnd: aKey="aValue",  }
procedure TextKeyValueAppend(var aOutStr: string; const aKey, aValue: string; const aAnd: boolean = True);
begin
	if (aAnd) then
		aOutStr := aOutStr + aKey + '="' + aValue + '", '
	else
		aOutStr := aOutStr + aKey + '="' + aValue + '"';
end;

{ Escape/replace all %s tokens in aText with aEscape}
function TextEscStr(const aText, aEscape: string): string;
begin
	Result := TextReplace(aText, '%s', aEscape, False);
end;

{ Copies aCount chars from Left of aText. }
function TextLeft(const aText: string; const aCount: Integer): string;
begin
	Result := TextCopy(aText, 1, aCount);
end;

{ Copies aCount chars from Right of aText. }
function TextRight(const aText: string; const aCount: Integer): string;
begin
	Result := TextCopy(aText, Length(aText) - aCount + 1, aCount);
end;

{ Checks if aText begins with aBeginsWith. }
function TextBegins(const aText, aBeginsWith: string; aCaseSens: boolean = False): boolean;
begin
	if (aCaseSens) then
		Result := (TextLeft(aText, Length(aBeginsWith)) = aBeginsWith)
	else
		Result := (TextSame(TextLeft(aText, Length(aBeginsWith)), aBeginsWith));
end;

{ Checks if aText ends with aEndsWith. }
function TextEnds(const aText, aEndsWith: string; aCaseSens: boolean = False): boolean;
begin
	if (aCaseSens) then
		Result := (TextRight(aText, Length(aEndsWith)) = aEndsWith)
	else
		Result := (TextSame(TextRight(aText, Length(aEndsWith)), aEndsWith));
end;

{ Checks if aTextA is same as aTextB. Alias for TextEquals. }
function TextSame(const aTextA, aTextB: string; const aCaseSens: boolean): boolean;
begin
    if (aCaseSens) then
        Result := (aTextA = aTextB)
    else
        Result := SameText(aTextA, aTextB);
end;

{ Checks if aText contains aContainsText. }
function TextInText(const aText, aContainsText: string; const aCaseSens: boolean): boolean;
begin
	Result := (TextPos(aText, aContainsText, aCaseSens) <> 0);
end;

{ Checks if aText matches any entries in aArray. If aAnywhere, aText matches anywhere in an aArray item. }
function TextInArray(const aText: string; const aArray: array of string; const aAnywhere: boolean; const aCaseSens: boolean): boolean;
var
	i: integer;
begin
	Result := False;
	for i  := 0 to high(aArray) do
	begin
		if (aAnywhere) then
		begin
			if (TextInText(aArray[i], aText, aCaseSens)) then
				Exit(True);
		end
		else
		begin
			if (TextSame(aArray[i], aText, aCaseSens)) then
				Exit(True);
		end;
	end;
end;

{ Matches aText agains aWildCard. Case insensitive. * and ? supported. For IRC. }
function TextWildcard(const aText, aWildCard: string): boolean;
var
	ps: pchar;
	pw: pchar;
	mp: pchar;
	cp: pchar;
begin
	if (aText = '') or (aWildCard = '') then
		Exit(False);

	ps := @aText[1];
	pw := @aWildCard[1];
	mp := nil;
	cp := nil;

	while ((ps^ <> #0) and (pw^ <> CAsterisk)) do
	begin
		if ((pw^ <> CQuestionMark) and (TextSame(ps^, pw^) = False)) then
			Exit(False);
		Inc(ps);
		Inc(pw);
	end;

	while (ps^ <> #0) do
	begin
		if (pw^ = CAsterisk) then
		begin
			Inc(pw);
			if (pw^ = #0) then
				Exit(True);
			mp := pw;
			cp := @ps[1];
		end
		else
		begin
			if (TextSame(ps^, pw^)) or (pw^ = CQuestionMark) then
			begin
				Inc(ps);
				Inc(pw);
			end
			else
			begin
				ps := cp;
				Inc(cp);
				pw := mp;
			end;
		end;
	end;

	while (pw^ = CAsterisk) do
		Inc(pw);

	Result := (pw^ = #0);
end;

{ Checks if left of aText is prefixed with aLeftSide and right of aText is suffixed with aRightSide. }
function TextEnclosed(const aText, aLeftSide, aRightSide: string; const aCaseSens: boolean = False): boolean;
begin
	if (aCaseSens) then
		Result := ((TextLeft(aText, Length(aLeftSide)) = aLeftSide) and (TextRight(aText, Length(aRightSide)) = aRightSide))
	else
		Result := (TextSame(TextLeft(aText, Length(aLeftSide)), aLeftSide) and TextSame(TextRight(aText, Length(aRightSide)), aRightSide));
end;

{ Checks if aText is prefixed and suffixed with aEnclosedWith. e.g. xXxTeenageDawgxXx }
function TextEnclosed(const aText, aEnclosedWith: string; const aCaseSens: boolean = False): boolean;
begin
	Result := TextEnclosed(aText, aEnclosedWith, aEnclosedWith, aCaseSens);
end;

{ Encloses a aText within aEncloseWith. }
function TextEnclose(const aText, aEncloseWith: string): string;
begin
	Result := aEncloseWith + aText + aEncloseWith;
end;

{ Removes aEnclosedWith prefix AND/OR suffix from aText. }
function TextUnEnclose(const aText, aEnclosedWith: string; const aCaseSens: boolean = False): string;
begin
	Result := TextUnEnclose(aText, aEnclosedWith, aEnclosedWith, aCaseSens);
end;

{ Removes aLeftSide prefix from Left AND/OR aRightSide suffix from Right side of aText. }
function TextUnEnclose(const aText, aLeftSide, aRightSide: string; const aCaseSens: boolean = False): string; overload;
begin
	if (aCaseSens) then
	begin
		if (TextLeft(aText, Length(aLeftSide)) = aLeftSide) then
			Result := TextCopy(aText, Length(aLeftSide) + 1, MaxInt)
		else
			Result := aText;

		if (TextRight(Result, Length(aRightSide)) = aRightSide) then
			Delete(Result, Length(Result), Length(aRightSide));
	end
	else
	begin
		if (TextSame(TextLeft(aText, Length(aLeftSide)), aLeftSide)) then
			Result := TextCopy(aText, Length(aLeftSide) + 1, MaxInt)
		else
			Result := aText;

		if (TextSame(TextRight(Result, Length(aRightSide)), aRightSide)) then
			Delete(Result, Length(Result), Length(aRightSide));
	end;
end;

{ Find and return aIdx(th) (0-based) occurance of text in aText that is enlosed with aEnclLeft on left and }
{ aEnclRight on the right of text. If aRemEncl, aEnclLeft and aEnclRight are removed from result, aCaseSens }
{ makes the search Case-sensitive. If no enclosed text is found, result is an empty string. }
function TextFindEnclosed(const aText, aEnclLeft, aEnclRight: string; const aIdx: Integer; const aRemEncl: boolean = True; const aCaseSens: boolean = False): string;
var
	a : Integer;
	b : Integer;
	ea: integer;
	eb: integer;
	l : Integer;
	i : Integer;
begin
	Result := CEmpty;

	if (aText = CEmpty) then
		Exit;

	a  := 1;
	b  := 1;
	l  := Length(aText);
	ea := Length(aEnclLeft);
	eb := Length(aEnclRight);
	i  := 0;
	while (i <= aIdx) and (a < l) and (b < l) do
	begin
		a := TextPos(aText, aEnclLeft, aCaseSens, b);
		if (a = 0) then
			Exit;

		b := TextPos(aText, aEnclRight, aCaseSens, a + ea);
		if (b <= a) then
			Exit;

		if (i = aIdx) then
		begin
			if (aRemEncl) then
				Result := TextCopy(aText, a + ea, b - a - ea)
			else
				Result := TextCopy(aText, a, b - a + eb);
		end;
		a := b + eb;
		b := a;
		Inc(i);
	end; { while }
end;

{ Find and return aIdx occurance of text in aText that is enlosed with aEncl. If aRemEncl, aEncl is removed }
{ from result. aCase sens makes the search Case-sensitive. If no enclosed text is found, result is empty. }
function TextFindEnclosed(const aText, aEncl: string; const aIdx: Integer; const aRemEncl: boolean; const aCaseSens: boolean): string;
begin
	Result := TextFindEnclosed(aText, aEncl, aEncl, aIdx, aRemEncl, aCaseSens);
end;

{ Encloses aText with Double quotes. "Got it?" }
function TextQuote(const aText: string): string;
begin
	Result := TextEnclose(aText, CDoubleQuote);
end;

{ Removes Double quote prefix AND/OR suffix from aText. }
function TextUnquote(const aText: string): string;
begin
	Result := TextUnEnclose(aText, CDoubleQuote);
end;

{ Strips $0D and $0A from end of text until it finds no more. }
function TextRemoveLineFeeds(const aText: string): string;
var
	i: Integer;
begin
	i := Length(aText);
	while (i > 0) and ((aText[i] = CCr) or (aText[i] = CLf)) do
		Dec(i);
	Result := TextCopy(aText, 1, i);
end;

{ Removes string from Left of aText to aSep. If aSep is not found, nothing is returned or removed. }
{ aSep search begins from Left of aText. If aDelSep is false returns aSep as well. }
function TextExtractLeft(var aText: string; const aSep: string; const aCaseSens: boolean = False; const aDelSep: boolean = True): string;
var
	i: Integer;
begin
	i := TextPos(aText, aSep, aCaseSens);
	if (i > 0) then
	begin
		Result := TextCopy(aText, 1, i - 1);
		Delete(aText, 1, i - 1);
		if (aDelSep) then
			Delete(aText, 1, Length(aSep));
	end;
end;

{ Removes string from Right of aText to aSep. If aSep is not found, nothing is returned or removed. }
{ aSep search begins from Right of aText. If aDelSep is false returns aSep as well. }
function TextExtractRight(var aText: string; const aSep: string; const aCaseSens: boolean = False; const aDelSep: boolean = True): string;
var
	i, ofs: Integer;
begin
	i   := 0;
	ofs := 1;
	while (ofs <> 0) do
	begin
		ofs := TextPos(aText, aSep, aCaseSens, ofs);
		if (ofs <> 0) then
		begin
			i := ofs;
			Inc(ofs);
		end
		else
			Break;
	end;

	if (i <> 0) then
	begin
		Result := TextRight(aText, Length(aText) - i);
		Delete(aText, i, MaxInt);
	end;
end;

{ Copies string from Left of aText to aSep. If aSep is not found, returns nothing. }
{ aSep search begins from Left of aText. }
function TextFetchLeft(const aText, aSep: string; const aCaseSens: boolean = False; const aEmptyIfNoSep: boolean = True): string;
var
	i: Integer;
begin
	i := TextPos(aText, aSep, aCaseSens);
	if (i > 0) then
		Result := TextLeft(aText, i - 1)
	else if (aEmptyIfNoSep) then
		Result := CEmpty
	else
		Result := aText;
end;

{ Copies string from Right of aText to aSep. If aSep is not found returns nothing. }
{ If aSepFromRight aSep search begins from Right of aText, else from left. }
function TextFetchRight(const aText, aSep: string; const aCaseSens: boolean; const aEmptyIfNoSep: boolean; const aSepFromRight: boolean): string;
var
	i, ofs: Integer;
begin
	if (aSepFromRight) then
	begin
		i   := 0;
		ofs := 1;
		while (ofs <> 0) do
		begin
			ofs := TextPos(aText, aSep, aCaseSens, ofs);
			if (ofs <> 0) then
			begin
				i := ofs;
				Inc(ofs);
			end
			else
				Break;
		end;

		if (i = 0) then
			if (aEmptyIfNoSep) then
				Exit(CEmpty)
			else
				Exit(aText);
		Result := TextRight(aText, Length(aText) - i - Length(aSep) + 1);
	end
	else
	begin
		i := TextPos(aText, aSep, aCaseSens);
		if (i > 0) then
			Result := TextRight(aText, Length(aText) - i - Length(aSep) + 1)
		else if (aEmptyIfNoSep) then
			Result := CEmpty
		else
			Result := aText;
	end;
end;

{ Copies string from Left of aText to first CRLF separator. If aSep is not found, returns nothing. }
function TextFetchLine(const aText: string): string;
begin
	Result := TextFetchLeft(atext, #13#10, True);
end;

{ Removes aRemove from the Left of aText, returns the rest. }
function TextRemoveLeft(const aText, aRemove: string; const aCaseSens: boolean = False): string;
begin
	if (TextBegins(aText, aRemove, aCaseSens)) then
		Result := TextCopy(aText, Length(aRemove) + 1, MaxInt)
	else
		Result := aText;
end;

{ Removes aRemove from the Right of aText, returns the rest. }
function TextRemoveRight(const aText, aRemove: string; const aCaseSens: boolean = False): string;
begin
	if (TextEnds(aText, aRemove, aCaseSens)) then
		Result := TextCopy(aText, 1, Length(aText) - Length(aRemove))
	else
		Result := aText;
end;

{ Splits aText on aSep(s), returns an array of strings. }
function TextSplit(const aText: string; const aSep: string; const aQotStr: string; const aOptions: TSplitOptions): TArray<string>;
var
	Count: Integer;

	procedure Add(const aString: string);
	begin
		if (aString = CEmpty) then
			Exit;
		Inc(Count);
		SetLength(Result, Count);
		Result[Count - 1] := aString;
	end;

var
	strLen: Integer;
	sepLen: Integer;
	qotLen: Integer;
	cpyPos: Integer;
	ofsPos: Integer;
	tokPos: Integer;
	qotPos: Integer;

begin
	if ((aText = CEmpty) or (aSep = CEmpty)) then
		Exit;

	if (soQuoted in aOptions) then
		if (aQotStr = CEmpty) then
			Exit;

	Count := 0;

	strLen := Length(aText);
	sepLen := Length(aSep);

	cpyPos := 1;
	ofsPos := 1;

	if (soQuoted in aOptions) then
	begin
		qotLen := Length(aQotStr);
		qotPos := 1;
		while (True) do
		begin
			tokPos := TextPos(aText, aSep, (soCSSep in aOptions), ofsPos);
			qotPos := TextPos(aText, aQotStr, (soCSQot in aOptions), qotPos);
			if (qotPos < tokPos) and (qotPos <> 0) then
			begin
				qotPos := TextPos(aText, aQotStr, (soCSQot in aOptions), qotPos + qotLen);
				if (qotPos <> 0) then
				begin
					ofsPos := qotPos;
					qotPos := qotPos + qotLen;
				end
				else
					qotPos := MaxInt;
			end
			else
			begin
				if (tokPos = 0) then
				begin
					Add(TextCopy(aText, cpyPos, MaxInt));
					Exit;
				end
				else
				begin
					if (soNoDelSep in aOptions) then
					begin
						if (soRemQuotes in aOptions) then
							Add(TextUnEnclose(TextCopy(aText, cpyPos, tokPos - cpyPos + sepLen), aQotStr, (soCSQot in aOptions)))
						else
							Add(TextCopy(aText, cpyPos, tokPos - cpyPos + sepLen))
					end
					else
					begin
						if (soRemQuotes in aOptions) then
							Add(TextUnEnclose(TextCopy(aText, cpyPos, tokPos - cpyPos), aQotStr, (soCSQot in aOptions)))
						else
							Add(TextCopy(aText, cpyPos, tokPos - cpyPos));
					end;
					ofsPos := tokPos + sepLen;
					qotPos := ofsPos;
					cpyPos := ofsPos;
				end;
			end;
		end;
	end
	else
	begin
		while (True) do
		begin
			tokPos := TextPos(aText, aSep, (soCSSep in aOptions), ofsPos);
			if (tokPos > 0) then
			begin
				if (soNoDelSep in aOptions) then
					Add(TextCopy(aText, ofsPos, tokPos - ofsPos + sepLen))
				else
					Add(TextCopy(aText, ofsPos, tokPos - ofsPos));
				ofsPos := tokPos + sepLen;
				if (soSingleSep in aOptions) then
				begin
					Add(TextCopy(aText, ofsPos, MaxInt));
					Exit;
				end;
			end
			else
			begin
				Add(TextRight(aText, strLen - ofsPos + 1));
				Exit;
			end;
		end;
	end;
end;

{ Splits the line with HTML/XML markup into a list of tokens. No pair matching performed. Example: }
{ <tag1>text1</tag1><tag2>text2</tag2> to <tag1>, text1, </tag1>, <tag2>, text2 and </tag2>. }
function TextSplitMarkup(const aText: string; const aTrim: boolean): TArray<string>;
var
	Count: Integer;

	procedure Add(const aString: string);
	begin
		if (aString = CEmpty) then
			Exit;
		Inc(Count);
		SetLength(Result, Count);
		if (aTrim) then
			Result[Count - 1] := TextTrim(aString)
		else
			Result[Count - 1] := aString;
	end;

var
	strLen: Integer;
	cpyPos: Integer;
	ofsPos: Integer;
begin
	strLen := Length(aText);
	if (strLen = 0) then
		Exit;

	Count  := 0;
	ofsPos := 1;
	cpyPos := 1;

	while (cpyPos <= strLen) do
	begin
		if (aText[cpyPos] = CLessThan) then
		begin
			if (ofsPos <> cpyPos) then
			begin
				Add(TextCopy(aText, ofsPos, cpyPos - ofsPos));
				ofsPos := cpyPos;
			end
			else
				Inc(cpyPos);
		end
		else if (aText[cpyPos] = CGreaterThan) then
		begin
			if (ofsPos <> cpyPos) then
			begin
				Add(TextCopy(aText, ofsPos, cpyPos - ofsPos + 1));
				Inc(cpyPos);
				ofsPos := cpyPos;
			end
			else
				Inc(cpyPos);
		end
		else
			Inc(cpyPos);
	end;

	if (ofsPos < cpyPos) then
		Add(TextCopy(aText, ofsPos, MaxInt));
end;

{ Splits aText on aSep(s), returns TTokens record. }
function TextTokenize(const aText: string; const aSep: string; const aQotStr: string; const aOptions: TSplitOptions): TTokens;
begin
	Result.FTokens := TextSplit(aText, aSep, aQotStr, aOptions);
	Result.FCount  := Length(Result.FTokens);
end;

{ Returns token at aIndex from aText split by aSeparator. }
function TextToken(const aText: string; const aIndex: integer; const aSeparator: string = CSpace): string;
var
	tokens: TTokens;
begin
	tokens := TextTokenize(aText);
	Result := tokens[aIndex];
end;

{ Converts a string to an integer. }
function TextToInt(const aText: string; const aDefault: Integer): Integer;
var
	code: Integer;
begin
	Val(aText, Result, code);
	if (code <> 0) then
		Result := aDefault;
end;

{ Converts a byte to a string. }
function TextFromInt(const aByte: byte): string;
begin
{$WARNINGS OFF}
	Str(aByte, Result);
{$WARNINGS ON}
end;

{ Converts an integer to a string. }
function TextFromInt(const aInteger: integer): string;
begin
{$WARNINGS OFF}
	Str(aInteger, Result);
{$WARNINGS ON}
end;

{ Converts a cardinal to a string. }
function TextFromInt(const aCardinal: cardinal): string;
begin
{$WARNINGS OFF}
	Str(aCardinal, Result);
{$WARNINGS ON}
end;

{ Converts an int64 to a string. }
function TextFromInt(const aInt64: int64): string;
begin
{$WARNINGS OFF}
	Str(aInt64, Result);
{$WARNINGS ON}
end;

{ Converts a boolean to string. }
function TextFromBool(const aBoolean: boolean; const aUseBoolStrings: boolean): string;
begin
	if (aBoolean) then
		if (aUseBoolStrings) then
			Exit('True')
		else
			Exit('1');

	if (aBoolean = False) then
		if (aUseBoolStrings) then
			Exit('False')
		else
			Exit('0');
end;

{ Converts a float to string. }
function TextFromFloat(const aFloat: double; const aDecimals: byte): string;
begin
{$WARNINGS OFF}
	Str(aFloat: 1: aDecimals, Result);
{$WARNINGS ON}
end;

{ Converts an extended to string. }
function TextFromFloat(const aExtended: extended; const aDecimals: byte = 6): string;
begin
{$WARNINGS OFF}
	Str(aExtended: 1: aDecimals, Result);
{$WARNINGS ON}
end;

{ Converts a hex string to an integer. Input example: "DEADBEEF". }
function TextHexToDec(const aHexStr: string): cardinal;
var
	c: cardinal;
	b: byte;
begin
	Result := 0;
	if (Length(aHexStr) <> 0) then
	begin
		c := 1;
		b := Length(aHexStr) + 1;
		repeat
			Dec(b);
			if (aHexStr[b] <= '9') then
				Result := (Result + (cardinal(aHexStr[b]) - 48) * c)
			else
				Result := (Result + (cardinal(aHexStr[b]) - 55) * c);

			c := c * 16;
		until (b = 1);
	end;
end;

{ Converts aValue to Hex string with aDigits minimum width. }
function TextIntToHex(aValue: cardinal; const aDigits: integer): string;
const
	HexNumbers: array [0 .. 15] of Char = ('0', '1', '2', '3', '4', '5', '6', '7', '8', '9',
	  'A', 'B', 'C', 'D', 'E', 'F');
begin
	Result := '';
	while aValue <> 0 do
	begin
		Result := HexNumbers[Abs(aValue mod 16)] + Result;
		aValue := aValue div 16;
	end;
	if Result = '' then
	begin
		while Length(Result) < aDigits do
			Result := '0' + Result;
		Exit;
	end;
	if Result[Length(Result)] = '-' then
	begin
		Delete(Result, Length(Result), 1);
		Insert('-', Result, 1);
	end;
	while Length(Result) < aDigits do
		Result := '0' + Result;
end;

{ Converts and appends all parameters together. Parameters can be of mixed types, but not constants. }
function TextMake(const aArgs: array of const; const aSeparator: string): string;
var
	i: integer;
begin
	Result := '';
	for i  := 0 to high(aArgs) do
	begin
		case aArgs[i].VType of
			vtInteger:
			Result := Result + TextFromInt(aArgs[i].VInteger);
			vtBoolean:
			Result := Result + TextFromBool(aArgs[i].VBoolean);
			vtChar:
			Result := Result + string(aArgs[i].VChar);
			vtExtended:
			Result := Result + TextFromFloat(aArgs[i].VExtended^);
			vtString:
			Result := Result + string(aArgs[i].VString^);
			vtPChar:
			Result := Result + string(aArgs[i].VPChar);
			vtObject:
			Result := Result + aArgs[i].VObject.ClassName;
			vtClass:
			Result := Result + aArgs[i].VClass.ClassName;
			vtAnsiString:
			Result := Result + string(aArgs[i].VAnsiString);
			vtUnicodeString:
			Result := Result + string(aArgs[i].VUnicodeString);
			vtCurrency:
			Result := Result + TextFromFloat(aArgs[i].VCurrency^);
			vtVariant:
			Result := Result + string(aArgs[i].VVariant^);
			vtInt64:
			Result := Result + TextFromInt(aArgs[i].VInt64^);
		end;

		if (i <> high(aArgs)) then
			Result := Result + aSeparator;
	end;
end;

{ Splits an URI into parts: http://goatse.cx/images/goatse.jpg = http, goatse.cx, images/goatse.jpg }
function TextURISplit(const aURI: string; var aPrefix, aHost, aPath: string): boolean;
var
	rPrefix, rHost, rPath, rParams: string;
begin
	Result := TextURISplit(aURI, rPrefix, rHost, rPath, rParams);
end;

{ Splits an URI into parts: http://goatse.cx/images/goatse.jpg = http, goatse.cx, images/goatse.jpg, par=val&par2=val2 }
function TextURISplit(const aURI: string; var aPrefix, aHost, aPath, aParams: string): boolean; overload;
var
	offs: Integer;
	i   : Integer;
begin
	Result := False;

	if (aURI = CEmpty) then
		Exit;

	offs := 0;

	// Extract prefix.
	i := TextPos(aURI, CURIPrefixDelimiter);
	if (i > 0) then
	begin
		aPrefix := TextLeft(aURI, i - 1);
		offs    := i + Length(CURIPrefixDelimiter);
	end;

	// Extract host.
	if (offs = 0) then
	begin
		i := TextPos(aURI, CFrontSlash);
		if (i > 0) then
		begin
			aHost := TextCopy(aURI, offs, i - 1);
			offs  := i;
		end;
	end
	else
	begin
		i := TextPos(aURI, CFrontSlash, True, offs);
		if (i > 0) then
		begin
			aHost := TextCopy(aURI, offs, i - offs);
			offs  := i;
		end;
	end;

	// Extract path.
	if (offs = 0) then
	begin
		i := TextPos(aURI, CQuestionMark);
		if (i > 0) then
		begin
			aPath := TextCopy(aURI, offs, i - 1);
            // The rest are params
			aParams := TextCopy(aURI, i + 1, MaxInt);
		end
		else
		begin
			aPath := TextCopy(aURI, offs, MaxInt);
			Exit(True);
		end;
	end
	else
	begin
		i := TextPos(aURI, CQuestionMark, True, offs);
		if (i > 0) then
		begin
			aPath := TextCopy(aURI, offs, i - offs);
            // The rest are params
			aParams := TextCopy(aURI, i + 1, MaxInt);
		end
		else
		begin
			aPath := TextCopy(aURI, offs, MaxInt);
			Exit(True);
		end;
	end;

	Result := True;
end;

{ Extracts Path from an URL }
function TextURIGetPath(const aURI: string): string;
var
	prefix, domain, path: string;
begin
	if (TextURISplit(aURI, prefix, domain, path)) then
		Result := path
	else
		Result := CEmpty;
end;

{ Url encodes(percent encodes) a string. }
function TextURIEncode(const aText: string): string;
var
	i : Integer;
	Ch: char;
begin
	Result := '';
	for i  := 1 to Length(aText) do
	begin
		Ch := aText[i];
		if ((Ch >= '0') and (Ch <= '9')) or ((Ch >= 'a') and (Ch <= 'z')) or
		  ((Ch >= 'A') and (Ch <= 'Z')) or (Ch = '.') or (Ch = '-') or (Ch = '_')
		  or (Ch = '~') then
			Result := Result + Ch
		else
		begin
			Result := Result + '%' + TextIntToHex(Ord(Ch), 2);
		end;
	end;
end;

{ Url decodes(percent decodes) a string. }
function TextURIDecode(const aText: string): string;
var
	i: Integer;
	l: Integer;
begin
	Result := CEmpty;

	i := 1;
	l := Length(aText);
	while (i <= l) do
	begin
		if (aText[i] = CPercent) then
		begin
			Result := Result + Chr(TextHexToDec(aText[i + 1] + aText[i + 2]));
			i      := Succ(Succ(i));
		end
		else
		begin
			if aText[i] = CPlus then
				Result := (Result + CSpace)
			else
				Result := (Result + aText[i]);
		end;
		i := Succ(i);
	end;
end;

{ Returns "file.ext" from "http://www.site.com/path/here/file.ext". }
function TextURIExtractParams(const aURI: string): string;
begin
	Result := TextFetchRight(aURI, '?', True);
end;

{ Returns "http://www.site.com/path/here/" from "http://www.site.com/path/here/file.ext" }
function TextURIWithoutParams(const aURI: string): string;
var
	rPrefix, rHost, rPath, rParams: string;
begin
	// Have to do everything here. If we go too deep on the stack
    // Delphi forgets string refcount and returns nothing :S.
	if (TextPos(aURI, CQuestionMark, True) > 0) then
		Exit(TextFetchLeft(aURI, CQuestionMark, True))
	else
		Result := CEmpty;

	if (TextURISplit(aURI, rPrefix, rHost, rPath, rParams)) then
		Result := rPrefix + CURISchemeDelimiter + rHost + rPath;
end;

{ Returns a hex display style string from aData of aSize. }
function TextDump(const aData: pByte; const aSize: integer; const aBytesPerLine: byte): string;
var
	p: pbyte;
	i: integer;
	h: string;
	t: string;
begin
	if (aData = nil) or (aSize <= 0) or (aBytesPerLine = 0) then
		Exit;

	i := 0;
	p := aData;
	while (i < aSize) do
	begin
		if ((i mod aBytesPerLine = 0) and (i <> 0)) or (i = aSize) then
		begin
			Result := Result + h + CSpace + CMinus + CSpace + t + CCrLf;
			h      := CEmpty;
			t      := CEmpty;
		end;

		if (h <> CEmpty) then
		begin
			if (i mod 8 = 0) then
				h := h + CSpace + CSpace
			else
				h := h + CSpace;
		end;

		h := h + TextIntToHex(p^, 2);
		if (p^ >= 20) and (p^ <= 127) then
			t := t + Chr(p^)
		else
			t := t + CDot;

		Inc(p);
		Inc(i);
	end;

	if (h <> CEmpty) then
	begin
		Result := Result + h;
		while (i mod aBytesPerLine <> 0) do
		begin
			if (i mod 8 = 0) then
				Result := Result + CSpace + CSpace + CSpace + CSpace
			else
				Result := Result + CSpace + CSpace + CSpace;
			Inc(i);
		end;
		Result := Result + CSpace + CMinus + CSpace + t;
	end;
end;

{ Save aText to aFileName. }
procedure TextSave(const aText, aFileName: string);
var
	f: TextFile;
begin
	AssignFile(f, aFileName, 65001);
	Rewrite(f);
	write(f, aText);
	CloseFile(f);
end;

{ Returns a string of length aLength composed entirely of aChar. }
function TextOfChar(const aChar: char; const aLength: integer): string;
var
	i: integer;
begin
	if (aLength <= 0) then
		Exit('');
	SetLength(Result, alength);
	for i         := 1 to aLength do
		Result[i] := aChar;
end;

{ Splits IRC hostmask nickname!ident@host.name into parts. }
function SplitHostMask(const aHostMask: string; var aNickname, aIdent, aHost: string): boolean;
begin
	if (Length(aHostMask) = 0) then
		Exit(False);

	aHost     := aHostMask;
	aIdent    := TextExtractLeft(aHost, CMonkey);
	aNickname := TextExtractLeft(aIdent, CExclam);
	Result    := (aHost <> CEmpty) and (aIdent <> CEmpty) and (aNickname <> CEmpty);
end;

{ Returns a random number character. }
function RandomNum: char;
begin
	Result := pchar(CNums)[Random(Length(CNums))];
end;

{ Returns a random string of number characters of aLength. }
function RandomNums(const aLength: byte): string;
var
	i: Integer;
begin
	Result := CEmpty;

	for i      := 0 to aLength - 1 do
		Result := Result + RandomNum;
end;

{ Returns a random lowercase letter. }
function RandomAlphaLower: char;
begin
	Result := pchar(CAlphaLower)[Random(Length(CAlphaLower))];
end;

{ Returns a random string of lowercase letters of aLength. }
function RandomAlphaLowers(const aLength: byte): string;
var
	i: Integer;
begin
	Result := CEmpty;

	for i      := 0 to aLength - 1 do
		Result := Result + RandomAlphaLower;
end;

{ Returns a random uppercase letter. }
function RandomAlphaUpper: char;
begin
	Result := pchar(CAlphaUpper)[Random(Length(CAlphaUpper))];
end;

{ Returns a random string of uppercase letters of aLength. }
function RandomAlphaUppers(const aLength: byte): string;
var
	i: Integer;
begin
	Result := CEmpty;

	for i      := 0 to aLength - 1 do
		Result := Result + RandomAlphaUpper;
end;

{ Returns a random lowercase vowel. }
function RandomVowelLower: char;
begin
	Result := pchar(CVowelsLower)[Random(Length(CVowelsLower))];
end;

{ Returns a random uppercase vowel. }
function RandomVowelUpper: char;
begin
	Result := pchar(CVowelsUpper)[Random(Length(CVowelsUpper))];
end;

{ Returns a random vowel. }
function RandomVowel: char;
begin
	Result := pchar(CVowels)[Random(Length(CVowels))];
end;

{ Returns a random lowercase consonant. }
function RandomConsonantLower: char;
begin
	Result := pchar(CConsonantsLower)[Random(Length(CConsonantsLower))];
end;

{ Returns a random uppercase consonant. }
function RandomConsonantUpper: char;
begin
	Result := pchar(CConsonantsUpper)[Random(Length(CConsonantsUpper))];
end;

{ Returns a random consonant. }
function RandomConsonant: char;
begin
	Result := pchar(CConsonants)[Random(Length(CConsonants))];
end;

{ Generates a random string of aLength. }
function RandomString(const aLength: Integer; const aLowerCase, aUpperCase, aNumeric: boolean): string;
type
	TRandomFunc  = function: char;
	TRandomFuncs = array of TRandomFunc;
var
	i: Integer;
	f: TRandomFuncs;
begin
	Result := CEmpty;

	if (aLowerCase) then
	begin
		SetLength(f, Length(f) + 1);
		f[Length(f) - 1] := RandomAlphaLower;
	end;

	if (aUpperCase) then
	begin
		SetLength(f, Length(f) + 1);
		f[Length(f) - 1] := RandomAlphaUpper;
	end;

	if (aNumeric) then
	begin
		SetLength(f, Length(f) + 1);
		f[Length(f) - 1] := RandomNum;
	end;

	for i      := 0 to aLength - 1 do
		Result := Result + f[Random(Length(f))];
end;

{ Returns an integer in range >= aMin and <= aMax. }
function RandomRange(const aMin, aMax: Integer): Integer;
begin
	Result := Random(aMax - aMin) + aMin;
end;

{ Returns a random boolean. Fiddy fiddy bitch money dawg yo sup sup u down. }
function RandomBool: boolean;
begin
	Result := (Random > 0.5);
end;

{ URI encodes aStr. }
function URIEncode(const aStr: ansistring): string; overload;
begin
	Result := URIEncode(UTF8Encode(aStr));
end;

{ URI encodes aStr. }
function URIEncode(const aStr: UTF8String): string; overload;
var
	ch: AnsiChar;
begin
	Result := CEmpty;

	for ch in aStr do
	begin
		if (ch in cURLUnreservedChars) then
			Result := Result + WideChar(ch)
		else
			Result := Result + cPercent + TextIntToHex(Ord(ch), 2);
	end;
end;

{ URI encodes aStr. }
function URIEncode(const aStr: unicodestring): string; overload;
begin
	Result := URIEncode(UTF8Encode(aStr));
end;

{ Decodes a URI encoded string. }
function URIDecode(const aStr: string): string;

	{ Counts number of '%' characters in a UTF8 string. }
	function CountPercent(const S: UTF8String): Integer;
	var
		i: Integer;
	begin
		Result := 0;
		for i  := 1 to Length(S) do
			if S[i] = cPercent then
				Inc(Result);
	end;

var
	srcUTF8: UTF8String; // input string as UTF-8
	srcIdx : Integer;    // index into source UTF-8 string
	resUTF8: UTF8String; // output string as UTF-8
	resIdx : Integer;    // index into result UTF-8 string
	hex    : string;     // hex component of % encoding
	chVal  : Integer;    // character ordinal value from a % encoding
begin
    // Convert input string to UTF-8
	srcUTF8 := UTF8Encode(aStr);
    // Size the decoded UTF-8 string: each 3 byte sequence starting with '%' is
    // replaced by a single byte. All other bytes are copied unchanged.
	SetLength(resUTF8, Length(srcUTF8) - 2 * CountPercent(srcUTF8));
	srcIdx := 1;
	resIdx := 1;
	while srcIdx <= Length(srcUTF8) do
	begin
		if srcUTF8[srcIdx] = cPercent then
		begin
      		// % encoding: decode following two hex chars into required code point
			if Length(srcUTF8) < srcIdx + 2 then
				Exit('');
			hex   := '$' + string(srcUTF8[srcIdx + 1] + srcUTF8[srcIdx + 2]);
			chVal := TextToInt(hex, - 1);
			if (chVal = - 1) then
				Exit('');
			resUTF8[resIdx] := AnsiChar(chVal);
			Inc(resIdx);
			Inc(srcIdx, 3);
		end
		else
		begin
      		// plain char or UTF-8 continuation character: copy unchanged
			resUTF8[resIdx] := srcUTF8[srcIdx];
			Inc(resIdx);
			Inc(srcIdx);
		end;
	end;

  	// Convert back to native string type for result
	Result := UTF8ToString(resUTF8);
end;

{ URI encodes query aStr component. Spaces in original string are encoded as "+".}
function URIEncodeQueryString(const aStr: ansistring): string; overload;
begin
	Result := URIEncodeQueryString(UTF8Encode(aStr));
end;

{ URI encodes query aStr component. Spaces in original string are encoded as "+".}
function URIEncodeQueryString(const aStr: UTF8String): string; overload;
begin
    // First we URI encode the string. This so any existing '+' symbols get
    // encoded because we use them to replace spaces and we can't confuse '+'
    // already in URI with those that we add. After this step spaces get encoded
    // as %20. So next we replace all occurences of %20 with '+'.
	Result := TextReplace(URIEncode(aStr), cPercentEncodedSpace, cPlus);
end;

{ URI encodes query aStr component. Spaces in original string are encoded as "+".}
function URIEncodeQueryString(const aStr: unicodestring): string; overload;
begin
	Result := URIEncodeQueryString(UTF8Encode(aStr));
end;

{ Decodes a URI encoded query aStr where spaces have been encoded as '+'. }
function URIDecodeQueryString(const aStr: string): string;
begin
    // First replace plus signs with spaces. We use percent-encoded spaces here
    // because string is still URI encoded and space is not one of unreserved
    // chars and therefor should be percent-encoded. Finally we decode the
    // percent-encoded string.
	Result := URIDecode(TextReplace(aStr, cPlus, cPercentEncodedSpace, True));
end;

{ ======= }
{ TTokens }
{ ======= }

{ GetEnumerator implement. }
function TTokens.GetEnumerator: TTokensEnumerator;
begin
	Result := TTokensEnumerator.Create(Self);
end;

{ Returns tokens from and including token at aIndex as a string delimited by aDelimiter. }
function TTokens.FromToken(const aIndex: Integer; const aDelimiter: string): string;
var
	i: Integer;
begin
	Result := CEmpty;

	for i := aIndex to FCount - 1 do
	begin
		if (i = aIndex) then
			Result := Result + GetToken(i)
		else
			Result := Result + aDelimiter + GetToken(i);
	end;
end;

{ Returns tokens from start to and including token at aIndex as a string delimited by aDelimiter. }
function TTokens.ToToken(const aIndex: Integer; const aDelimiter: string): string;
var
	i: Integer;
begin
	Result := CEmpty;

	for i := 0 to aIndex do
	begin
		if (i = 0) then
			Result := Result + GetToken(i)
		else
			Result := Result + aDelimiter + GetToken(i);
	end;
end;

{ Adds a string to the array. }
procedure TTokens.Add(const aText: string);
begin
	if (aText = CEmpty) then
		Exit;
	Inc(FCount);
	SetLength(FTokens, FCount);
	FTokens[FCount - 1] := aText;
end;

{ Adds aKey=aVal as one string to the array. String aVal overload. }
procedure TTokens.Add(const aKey, aVal: string);
begin
	Add(aKey + '=' + aVal);
end;

{ Adds aKey=aVal as one string to the array. Integer aVal overload. }
procedure TTokens.Add(const aKey: string; const aVal: integer);
begin
	Add(aKey, TextFromInt(aVal));
end;

{ Adds aKey=aVal as one string to the array. Boolean aVal overload. }
procedure TTokens.Add(const aKey: string; const aVal: boolean);
begin
	Add(aKey, TextFromBool(aVal));
end;

{ Adds aKey="aVal" as one string to the array. String aVal overload. }
procedure TTokens.AddQ(const aKey, aVal: string);
begin
	Add(aKey + '="' + aVal + '"');
end;

{ Adds aKey="aVal" as one string to the array. Integer aVal overload. }
procedure TTokens.AddQ(const aKey: string; const aVal: integer);
begin
	Add(aKey + '="' + TextFromInt(aVal) + '"');
end;

{ Adds aKey="aVal" as one string to the array. Boolean aVal overload. }
procedure TTokens.AddQ(const aKey: string; const aVal: boolean);
begin
	Add(aKey + '="' + TextFromBool(aVal) + '"');
end;

{ Returns all tokens in one string separated by aDelimiter. }
function TTokens.AllTokens(const aDelimiter: string): string;
var
	i: Integer;
begin
	Result := CEmpty;

	for i := 0 to FCount - 1 do
	begin
		if (i = 0) then
			Result := Result + GetToken(i)
		else
			Result := Result + aDelimiter + GetToken(i);
	end;
end;

{ Clears all tokens. }
procedure TTokens.Clear;
begin
	SetLength(FTokens, 0);
	Finalize(FTokens);
	FCount := 0;
end;

{ Checks if empty. }
function TTokens.Empty: boolean;
begin
	Result := (FCount = 0);
end;

{ Returns an array of string from and including token at aFromToken to and including token at aToToken. }
function TTokens.ToArray(const aFromToken, aToToken: Integer): TArray<string>;
var
	i: Integer;
begin
	if (aFromToken < 0) or (aFromToken >= FCount) or (aToToken < aFromToken) then
		Exit;

	SetLength(Result, FCount - (aToToken - aFromToken));

	for i         := aFromToken to aToToken do
		Result[i] := Token[i];
end;

{ Token getter. Get as string. }
function TTokens.GetToken(const aIndex: Integer): string;
begin
	if ((aIndex < 0) or (aIndex >= FCount)) then
		Result := CEmpty
	else
		Result := FTokens[aIndex];
end;

{ Pair getter. Get as TPair. }
function TTokens.GetPair(const aIndex: integer): TPair;
begin
	if ((aIndex < 0) or (aIndex >= FCount)) then
	begin
		Result.Key := '';
		Result.Val := '';
	end
	else
	begin
		Result.Key := TextFetchLeft(FTokens[aIndex], '=', True);
		Result.Val := TextFetchRight(FTokens[aIndex], '=', True, False);
	end;
end;

{ Exchanges two items in tokens. }

procedure TTokens.Exchange(aIndexA, aIndexB: Integer);
var
	temp: string;
begin
	temp             := FTokens[aIndexB];
	FTokens[aIndexB] := FTokens[aIndexA];
	FTokens[aIndexA] := temp;
end;

{ QuickSorts tokens. }
procedure TTokens.QuickSort(aStart, aEnd: Integer);
var
	a: Integer;
	i: Integer;
	j: Integer;
	p: Integer;
begin
	if (FCount <= 1) then
		Exit;
	a := aStart;
	repeat
		i := a;
		j := aEnd;
		p := (a + aEnd) shr 1;
		repeat
			while (CompareText(FTokens[i], FTokens[p]) < 0) do
				Inc(i);
			while (CompareText(FTokens[j], FTokens[p]) > 0) do
				Dec(j);
			if (i <= j) then
			begin
				if (i <> j) then
					Exchange(i, j);
				if (p = i) then
					p := j
				else
				  if (p = j) then
					p := i;
				Inc(i);
				Dec(j);
			end;
		until (i > j);
		if (a < j) then
			QuickSort(a, j);
		a := i;
	until (i >= aEnd);
end;

{ Sorts the items. }
procedure TTokens.Sort;
begin
	QuickSort(0, FCount - 1);
end;

{ ================= }
{ TTokensEnumerator }
{ ================= }

{ Constructor. }
constructor TTokensEnumerator.Create(aTokens: TTokens);
begin
	inherited Create;
	FIndex  := - 1;
	FTokens := aTokens;
end;

{ GetCurrent implementaiton. }
function TTokensEnumerator.GetCurrent: string;
begin
	Result := FTokens[FIndex];
end;

{ MoveNext Implementation. }
function TTokensEnumerator.MoveNext: Boolean;
begin
	Result := (FIndex < FTokens.Count - 1);
	if Result then
		Inc(FIndex);
end;

end.
