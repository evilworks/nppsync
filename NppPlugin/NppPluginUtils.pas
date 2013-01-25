unit NppPluginUtils;

interface

uses
	Windows, Messages, NppPluginInterface;

function NppGetOpenFiles(const aNppHandle: HWND): TArray<string>;

implementation

function NppGetOpenFiles(const aNppHandle: HWND): TArray<string>;
var
    ret: integer;
    ary: array of pchar;
    i: integer;
begin
    ret := SendMessage(aNppHandle, NPPM_GETNBOPENFILES, 0, ALL_OPEN_FILES);
    if (ret <= 0) then
        Exit;
    SetLength(ary, ret);
    try
        for i := 0 to ret - 1 do
            ary[i] := AllocMem(MAX_PATH + 1);
        ret := SendMessage(aNppHandle, NPPM_GETOPENFILENAMES, WPARAM(@ary[0]), ret);
        if (ret <= 0) then
            Exit;
        SetLength(Result, ret);
        for i := 0 to ret - 1 do
            Result[i] := string(PChar(ary[i]));
    finally
        for i := 0 to Length(ary) - 1 do
            FreeMem(ary[i]);
    end;
end;

end.
