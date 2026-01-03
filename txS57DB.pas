unit txS57DB;

interface
uses
  System.Classes, System.SysUtils, System.Generics.Collections,
  txgis.Utils;

type
  TtxS57dbGeoType = (
      dgtNone = 0,
      dgtPoint = 1,
      dgtLine = 2,
      dgtArea = 3
  );

 

  TtxS57dbFunture = class
  private
    Fattries: TDictionary<integer, string>;
    Fcode: integer;
    Fgeo: TArray<TArray<TtxgisCoordinatePoint>>;
    FgeoType: TtxS57dbGeoType;
    FMinScale: Integer;
  public
    property code: integer read Fcode write Fcode;
    property attries: TDictionary<integer, string> read Fattries;
    property geo: TArray < TArray < TtxgisCoordinatePoint >> read Fgeo write Fgeo;
    property geoType: TtxS57dbGeoType read FgeoType write FgeoType;
    property MinScale: Integer read FMinScale write FMinScale;

    constructor Create;
    destructor Destroy; override;
  end;

  TtxS57dbFile = class
  private
    FfileName: string;
    Ffurntures: TObjectList<TtxS57dbFunture>;
    FmaxRect: TtxgisCoordinateRect;
    FMinScale: Integer;
    FMaxScale: Integer;
  public
    constructor Create;
    destructor Destroy; override;
    property fileName: string read FfileName write FfileName;
    property furntures: TObjectList<TtxS57dbFunture> read Ffurntures;
    property maxRect: TtxgisCoordinateRect read FmaxRect write FmaxRect;
    property MinScale: Integer read FMinScale write FMinScale;
    property MaxScale: Integer read FMaxScale write FMaxScale;
  end;

implementation

constructor TtxS57dbFile.Create;
begin
  inherited Create;
  Ffurntures := TObjectList<TtxS57dbFunture>.Create;
end;

destructor TtxS57dbFile.Destroy;
begin
  Ffurntures.Free;
  inherited Destroy;
end;

constructor TtxS57dbFunture.Create;
begin
  inherited Create;
  Fattries := TDictionary<integer, string>.Create;
end;

destructor TtxS57dbFunture.Destroy;
begin
  Fattries.Free;
  inherited Destroy;
end;

end.
