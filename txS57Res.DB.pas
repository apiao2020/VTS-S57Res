unit txS57Res.DB;

interface
uses
  System.SysUtils, System.Classes,
  txS57Res.Utils;

type
  TtxS57DBManager = class(TComponent)
  private
    FDB: TtxS57ResFiles;
  public
    constructor Create(AOWner: TComponent); override;
    destructor Destroy; override;
    property DB: TtxS57ResFiles read FDB write FDB;
  end;

implementation

{ TtxS57DBManager }

constructor TtxS57DBManager.Create(AOWner: TComponent);
begin
  inherited;
  FDB := TtxS57ResFiles.Create;
end;

destructor TtxS57DBManager.Destroy;
begin
  FDB.Free;
  inherited;
end;

end.
