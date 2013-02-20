unit NppSyncMain;

interface

uses
	Windows, NppPluginInterface;

const
	NPP_PLUGIN_NAME: PChar        = 'NppSync';
	NPP_PLUGIN_MODULE_NAME: PChar = 'NppSync.dll';
	NPP_PLUGIN_VERSION: PChar     = '1.2.0';
	NPP_PLUGIN_FUNCTION_COUNT     = 1;

var
	nppData       : TNppData;
	pluginCommands: array [0 .. NPP_PLUGIN_FUNCTION_COUNT - 1] of TNppPluginCommand;

procedure PluginInitialization;
procedure PluginFinalization;

implementation

uses
	NppSyncServer;

procedure CommandAbout;
begin
	MessageBox(0,
	  PChar('NppSync version: ' + NPP_PLUGIN_VERSION + #13#10 +
	  'by your friend, evilworks - 2013' + #13#10 +
	  'pollux@lavabit.com'),
	  'NppSync',
	  MB_ICONINFORMATION or MB_OK
	  );
end;

procedure SetNppPluginCommandData(
  const aIndex: integer;      // Index of command in pluginCommands array.
  const aName: string;        // Command display name as show in npp plugins menu.
  const aFunc: TNppPluginCmd; // Function called when the command is executed.
  const aCmdID: integer;      // CommandID.
  const aInit2Check: boolean;
  const aShortcutCtrl: boolean = False;
  const aShortcutShift: boolean = False;
  const aShortcutAlt: boolean = False;
  const aShortcutKey: byte = 0
  );
begin
	Move(aName[1], pluginCommands[aIndex].itemName[0], Length(aName) * SizeOf(char));
	pluginCommands[aIndex].pFunc      := aFunc;
	pluginCommands[aIndex].cmdID      := aCmdID;
	pluginCommands[aIndex].init2Check := aInit2Check;
	if (aShortcutKey <> 0) then
	begin
		pluginCommands[aIndex].shortcut           := AllocMem(SizeOf(pluginCommands[aIndex].shortcut^));
		pluginCommands[aIndex].shortcut^.ModCTRL  := aShortcutCtrl;
		pluginCommands[aIndex].shortcut^.ModSHIFT := aShortcutShift;
		pluginCommands[aIndex].shortcut^.ModALT   := aShortcutAlt;
		pluginCommands[aIndex].shortcut^.Key      := aShortcutKey;
	end;
end;

procedure FreeNppPluginCommandShortcuts;
var
	i: integer;
begin
	for i := 0 to high(pluginCommands) do
	begin
		if (pluginCommands[i].shortcut = nil) then
			Continue;
		FreeMem(pluginCommands[i].shortcut);
		pluginCommands[i].shortcut := nil;
	end;
end;

procedure PluginInitialization;
begin
	ZeroMemory(@pluginCommands, SizeOf(pluginCommands[0]) * Length(pluginCommands));

	SetNppPluginCommandData(0, 'About...', CommandAbout, 0, False);
end;

procedure PluginFinalization;
begin
	FreeNppPluginCommandShortcuts;
end;

end.
