unit txS57Res.Reg;

interface
uses
  System.SysUtils, System.Classes,
  txS57Res.DB;

procedure Register;
implementation
procedure Register;
begin
  RegisterComponents('VTS', [TtxS57DBManager]);
end;

end.
