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
    procedure save(Stream: TStream);
    procedure load(Stream: TStream);

    procedure clear;
    property DB: TtxS57ResFiles read FDB write FDB;
  end;

implementation

{ TtxS57DBManager }

procedure TtxS57DBManager.clear;
begin
  FDB.Clear;
end;

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

procedure TtxS57DBManager.load(Stream: TStream);
var
  i, len: integer;
begin
  FDB.Clear;
  //读数量
  Stream.Read(len, SizeOf(Integer));

  for i := 0 to len - 1 do
  begin
    FDB.Add.Load(Stream);
  end;
end;

procedure TtxS57DBManager.save(Stream: TStream);
var
  len: integer;
begin
  //写数量
  len := FDB.Count;
  Stream.Write(len, SizeOf(Integer));
  for var db in FDB do
  begin
    db.Save(Stream);
  end;
end;

end.
