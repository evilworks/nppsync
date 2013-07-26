unit NppSyncServer;

interface

uses
    Windows, Messages, Winsock, NppPluginInterface, NppPluginUtils,
    TextUtils;

procedure StartServer(const aPort: word = 40500);
procedure StopServer;

implementation

uses
    NppSyncMain, SysUtils;

var
    wsaData     : TWSAData;
    listenSocket: TSocket = INVALID_SOCKET;
    socketThread: THandle;

function GetErrorText(const aCode: integer): string;
var
    buf: array [0 .. 255] of Char;
    flg: DWORD;
    l: integer;
    i: integer;
begin
    FillChar(buf, 256, 0);
    flg := FORMAT_MESSAGE_FROM_SYSTEM or FORMAT_MESSAGE_IGNORE_INSERTS or FORMAT_MESSAGE_ARGUMENT_ARRAY;
    FormatMessage(flg, nil, aCode, 0, buf, SizeOf(buf), nil);
    Result := buf;
    if (Result = '') then
        Exit;

    l := Length(Result);
    i := l;
    while (Result[i] in [#13, #10]) do dec(i);
    if i < l then Delete(Result, i, l - i);
end;

procedure ReportError(const aText: string; const aCode: integer = SOCKET_ERROR);
var
    msg: string;
begin
    msg := aText;
    if (aCode = SOCKET_ERROR) then
        msg := msg + #13#10 + GetErrorText(WSAGetLastError)
    else
        msg := msg + #13#10 + GetErrorText(aCode);

    MessageBox(0, PChar(msg), NPP_PLUGIN_NAME, MB_ICONERROR or MB_OK);
end;

function ThreadProc(aParam: pointer): DWORD; stdcall;
var
    sck: TSocket;

    function GetBytesOnSocket: integer;
    var
        len: u_long;
        ret: integer;
    begin
        ret := ioctlsocket(sck, FIONREAD, len);
        if (ret = SOCKET_ERROR) then
        begin
            ReportError('Error getting num bytes on socket, ioctlsocket() failed');
            Exit(ret);
        end;
        Result := integer(len);
    end;

    function GetRecvBufferSize: integer;
    var
        val: integer;
        len: integer;
    begin
        len    := SizeOf(val);
        Result := getsockopt(sck, SOL_SOCKET, SO_RCVBUF, @val, len);
        if (Result = SOCKET_ERROR) then
        begin
            ReportError('Error getting receive buffer size, getsockopt() failed');
            Exit;
        end;
        Result := val;
    end;

    function GetFileTS(const aFileName: string): Int64;
    var
        fh  : HFILE;
        info: TByHandleFileInformation;
    begin
        Result := 0;
        fh := CreateFile(PChar(aFileName), GENERIC_READ, FILE_SHARE_READ or FILE_SHARE_WRITE,
          nil, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0);
        if (fh = INVALID_HANDLE_VALUE) then
            Exit;
        try
            if not GetFileInformationByHandle(fh, info) then
                Exit;
            Result := info.ftLastWriteTime.dwHighDateTime;
            Result := Result shl 32;
            Result := Result or info.ftLastWriteTime.dwLowDateTime;
        finally
            CloseHandle(fh);
        end;
    end;

    function GetFileTimestamp(const aFileName: string): string;
    var ts: Int64;
    begin
      ts := GetFileTS(aFileName);
      if ts <> 0 then Str(ts, Result)
                 else Result := '';
    end;

  function mkResponse(body: rawbytestring): rawbytestring; overload ;
  begin
    Result := '200 HTTP/1.1 OK' + #13#10 +
              'content-length: ' + TextFromInt(Length(body)) + #13#10#13#10 +
              body;
  end;

  function mkResponse(body: integer): rawbytestring; overload ;
  begin
     Str(body, Result);
     Result := mkResponse(Result);
  end;

    function GetResponse(const aRequest: rawbytestring): rawbytestring;
    var
        fls: TArray<string>;
        tkn: TTokens;
        i  : integer;
        l  : integer;
        t  : Int64;
        ts : Int64;
    begin
        tkn     := TextTokenize(string(aRequest));
        Result  := TextRight(tkn[1], Length(tkn[1]) - 1);
        Result  := URIDecode(Result);
        Result  := TextReplace(Result, '/', '\', True);
        fls     := NppGetOpenFiles(nppData.nppHandle);
        l       := Length(fls);
        ts      := 0;
        for i := 0 to l - 1 do
        begin
            if (TextSame(Result, fls[i])) then
            begin
                Result := GetFileTimestamp(Result);
                Result := mkResponse(Result);
                Exit;
            end else begin
                if (TextBegins(fls[i], Result)) then begin
                    t := GetFileTS(fls[i]);
                    if ts < t then ts := t; // Get the newest file timestamp
                end;
            end;
        end;
        Str(ts, Result);
        if 0 <> ts then Result := mkResponse(Result);
    end;

    procedure HandleClient;
    label close;
    var
        req: rawbytestring;
        rsp: rawbytestring;
        buf: array of byte;
        len: integer;
        ret: integer;
    begin
        { Read request }
        req := '';
        while (True) do
        begin
            len := GetRecvBufferSize;
            if (len < 0) then
                goto close;
            SetLength(buf, len);
            ret := recv(sck, buf[0], len, 0);
            if (ret < 0) then
            begin
                ReportError('Error receiving data, recv() failed');
                goto close;
            end;

            if (ret > 0) then
                req := req + rawbytestring(pansichar(buf));
            if (ret < len) or (GetBytesOnSocket = 0) then
                Break;
        end;

        { Send response }
        rsp := GetResponse(req);
        ret := send(sck, rsp[1], Length(rsp), 0);
        if (ret < 0) then
            ReportError('Error sending reponse, send() failed');
    close:
        closesocket(sck);
    end;

begin
    Result := 0;
    while (True) do
    begin
        sck := accept(listenSocket, psockaddr(nil), pinteger(nil));
        if (sck = INVALID_SOCKET) then
            Break;
        HandleClient;
    end;
end;

procedure StartServer(const aPort: word = 40500);
label
    error;
var
    threadID: cardinal;
    addr    : sockaddr_in;
    ret     : integer;
begin
    ret := WSAStartup($0202, wsaData);
    if (ret <> 0) then
    begin
        ReportError('Error initializing Winsock, WSAStartup() failed', ret);
        Exit;
    end;

    listenSocket := socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
    if (listenSocket = INVALID_SOCKET) then
    begin
        ReportError('Error creating listen socket, socket() failed');
        Exit;
    end;

    addr.sin_family      := AF_INET;
    addr.sin_addr.S_addr := inet_addr('127.0.0.1');
    addr.sin_port        := htons(aPort);

    if (bind(listenSocket, addr, SizeOf(addr)) <> 0) then
    begin
        ReportError('Error binding listen socket, bind() failed');
        goto error;
    end;

    if (listen(listenSocket, SOMAXCONN) <> 0) then
    begin
        ReportError('Error listening on socket, listen() failed');
        goto error;
    end;

    socketThread := CreateThread(nil, 0, @ThreadProc, nil, 0, threadID);
    if (socketThread = 0) then
    begin
        ReportError('Error creating socket thread');
        goto error;
    end;

    Exit;
error:
    closesocket(listenSocket);
    listenSocket := INVALID_SOCKET;
end;

procedure StopServer;
var
    exitCode: cardinal;
begin
    closesocket(listenSocket);
    listenSocket := INVALID_SOCKET;
    WaitForSingleObject(socketThread, 1000);
    CloseHandle(socketThread);
    WSACleanup;
end;

end.
