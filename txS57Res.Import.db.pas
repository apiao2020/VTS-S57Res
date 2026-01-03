unit txS57Res.Import.db;

interface
uses
  System.Classes,
  System.SysUtils,
  txS57Res.Utils;

type
  S57ResImprotDBMgr = class(TComponent)
  public
    procedure importDB(ADB: TtxS57ResFiles; catpion: String);
  end;

implementation

{ S57ResImprotDBMgr }

procedure S57ResImprotDBMgr.importDB(ADB: TtxS57ResFiles; catpion: String);
begin

end;

end.
