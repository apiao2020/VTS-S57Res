unit txS57Res.Reg;

interface
uses
  System.SysUtils, System.Classes,
  txS57Res.Import.Mgr,
  txS57Res.Import.db.mgr,
  txS57Res.DB,
  txS57Res.Json;

procedure Register;
implementation
procedure Register;
begin
  RegisterComponents('VTS', [TtxS57DBManager, TtxS57ResImportMgr, S57ResImprotDBMgr,TtxS57DBJSONManager]);
end;

end.
