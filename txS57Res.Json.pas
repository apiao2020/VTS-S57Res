unit txS57Res.Json;

interface
uses
  System.Classes,
  System.SysUtils,
  System.Generics.Collections,
  txJsonToClass,
  txS57Res.Res,
  txGis.Utils,
  txS57Res.Utils;

type

 TtxS57FeatureType = (ftGeo, ftMeta, ftCollection, ftCartographic);



  TtxS57DataLonlat = class(TObjectJson)
  private
    FLat: double;
    FLon: double;
    FHeight: double;
  public
    property Lon: double read FLon write FLon;
    property Lat: double read FLat write FLat;
    property Height: double read FHeight write FHeight;
  end;

  TtxS57DataLonlats = class(TObjectJson)
  private
    FLonlats: TObjectListJson;
  public
    constructor Create; override;
    destructor Destroy; override;
    property Lonlats: TObjectListJson read FLonlats write FLonlats;
  end;

  TtxS57DataRect = class(TObjectJson)
  private
    FWest: double;
    FEast: double;
    FSouth: double;
    FNorth: double;
  public
    property West: double read FWest write FWest;
    property East: double read FEast write FEast;
    property North: double read FNorth write FNorth;
    property South: double read FSouth write FSouth;
  end;



  TtxS57DataFile = class(TObjectJson)
  private
    FFileName: String;
    FFeatures: TObjectListJson;
    FRect: TtxS57DataRect;
  public
    constructor Create; override;
    destructor Destroy; override;
    property FileName: String read FFileName write FFileName;
    property Rect: TtxS57DataRect read FRect write FRect;
    property Features: TObjectListJson read FFeatures write FFeatures;

  end;


  TtxS57DataGroup = class(TObjectJson)
  private
    FFiles: TObjectListJson;
  public
    constructor Create;
    destructor Destroy; override;
    property Files: TObjectListJson read FFiles write FFiles;
  end;

  TtxS57DataFeature = class(TObjectJson)
  private
    FCode: Integer;
    FAttries: TObjectListJson;
    FGeo: TObjectListJson;
    FGeoType: integer;
  public
    constructor Create; override;
    destructor Destroy; override;
    property Code: Integer read FCode write FCode;
    property Attries: TObjectListJson read FAttries write FAttries;
    property Geo:  TObjectListJson read FGeo write FGeo;
    property GeoType: integer read FGeoType write FGeoType;
  end;

  TtxS57DBJsonManager = class(TComponent)
  public
    procedure Save(ADB: TtxS57ResFiles; AStream: TStream); overload;
    procedure Save(ADB: TtxS57ResFiles; AFileName: String); overload;
    procedure Load(AStream: TStream; ADB: TtxS57ResFiles); overload;
    procedure Load(AFileName: String; ADB: TtxS57ResFiles); overload;
  end;

  TtxS57DataAttr = class(TObjectJson)
  private
    FKey: Integer;
    FValue: string;
  public
    property Key: Integer read FKey write FKey;
    property Value: string read FValue write FValue;
  end;


implementation

{ TtxS57DBJSONManager }

procedure TtxS57DBJsonManager.Load(AStream: TStream; ADB: TtxS57ResFiles);
var
  encGroup: TtxS57DataGroup;
  _stream: TStringStream;
  resFile: TtxS57ResFile;
  resFileJson: TObjectJson;
  _resFile: TtxS57DataFile;

  resFeatureJson: TObjectJson;
  resFeature: TtxS57ResFeature;
  _resFeature: TtxS57DataFeature;

  resAttrJson:  TObjectJson;
  resAttr: TPair<integer, String>;
  _resAttr: TtxS57DataAttr;

  resGeosJson: TObjectJson;
  resGeos: TArray<TtxgisCoordinatePoint>;
  geo: TArray<TArray<TtxgisCoordinatePoint>>;
  _resGeos: TtxS57DataLonlats;

  resGeoJson: TObjectJson;
  resGeo: TtxgisCoordinatePoint;
  _resGeo: TtxS57DataLonlat;
  i, j: integer;

begin

  try
    encGroup :=  TtxS57DataGroup.Create;

    try
      _stream := TStringStream.Create;
      AStream.Position := 0;
      _stream.CopyFrom(AStream, AStream.Size);
      TtxJsonToClass.parse(_stream.DataString, encGroup);

      ADB.Clear;
      for resFileJson in encGroup.Files do
      begin
         _resFile := TtxS57DataFile(resFileJson);
         resFile :=  ADB.Add;
         resFile.FileName := _resFile.fileName;
         resFile.maxRect.Create(_resFile.Rect.East, _resFile.Rect.South,  _resFile.Rect.West, _resFile.Rect.North);


         for resFeatureJson in _resFile.Features do
         begin
           _resFeature := TtxS57DataFeature(resFeatureJson);
           resFeature :=  resFile.furntures.Add(resFile);
           resFeature.Code := _resFeature.code;
           resFeature.GeoType :=  TtxS57ResGeoType(_resFeature.geoType);

           for resAttrJson in _resFeature.attries do
           begin
              _resAttr := TtxS57DataAttr(resAttrJson);
             resFeature.attries.Add(_resAttr.Key, _resAttr.Value);
           end;

           setLength(geo, _resFeature.geo.Count);
           for i := 0 to _resFeature.geo.Count - 1 do
           begin
             _resGeos := TtxS57DataLonlats(_resFeature.geo[i]);

             setLength(resGeos, _resGeos.FLonlats.Count);
             for j := 0 to _resGeos.FLonlats.Count - 1 do
             begin
               _resGeo := TtxS57DataLonlat(_resGeos.FLonlats[j]);
               resGeos[j].Create(_resGeo.Lon, _resGeo.Lat, _resGeo.Height);
             end;
             geo[i] := resGeos;
           end;
             resFeature.geo := geo;

         end;



      end;




    finally
      _stream.Free;
    end;
  finally
    encGroup.Free;
  end;

end;

procedure TtxS57DBJsonManager.Save(ADB: TtxS57ResFiles; AStream: TStream);
var
  encGroup: TtxS57DataGroup;
  _stream: TStringStream;
  resFile: TtxS57ResFile;
  _resFile: TtxS57DataFile;
  resFeature: TtxS57ResFeature;
  _resFeature: TtxS57DataFeature;

  resAttr: TPair<integer, String>;
  _resAttr: TtxS57DataAttr;

  resGeos: TArray<TtxgisCoordinatePoint>;
  _resGeos: TtxS57DataLonlats;

  resGeo: TtxgisCoordinatePoint;
  _resGeo: TtxS57DataLonlat;
begin

  try
    encGroup :=  TtxS57DataGroup.Create;


    for resFile in ADB do
    begin
       _resFile :=  TtxS57DataFile.Create;
       _resFile.FileName := ExtractFileName(resFile.fileName);

       _resFile.Rect.North := resFile.maxRect.north;
       _resFile.Rect.South := resFile.maxRect.south;
       _resFile.Rect.West := resFile.maxRect.west;
       _resFile.Rect.East := resFile.maxRect.east;
       encGroup.Files.Add(_resFile);

       for resFeature in resFile.furntures do
       begin
         _resFeature :=  TtxS57DataFeature.Create;
         _resFeature.Code := resFeature.code;
         _resFeature.GeoType :=  integer(resFeature.geoType);
         _resFile.Features.Add(_resFeature);

         for resAttr in resFeature.attries do
         begin
            _resAttr := TtxS57DataAttr.Create;
            _resAttr.Key := resAttr.Key;
            _resAttr.Value := resAttr.Value;
            _resFeature.Attries.Add(_resAttr);
         end;

         for resGeos in resFeature.geo do
         begin
           _resGeos := TtxS57DataLonlats.Create;
           for resGeo in resGeos do
           begin
             _resGeo := TtxS57DataLonlat.Create;
             _resGeo.Lon := resGeo.longitude;
             _resGeo.Lat := resGeo.latitude;
             _resGeo.Height := resGeo.height;
             _resGeos.Lonlats.Add(_resGeo);
           end;
           _resFeature.Geo.Add(_resGeos);

         end;

       end;



    end;




















    try
      _stream := TStringStream.Create( TtxJsonToClass.build(encGroup));
      _stream.Position := 0;
      AStream.CopyFrom(_stream, _stream.Size);
    finally
      _stream.Free;
    end;
  finally
    encGroup.Free;
  end;

end;

procedure TtxS57DBJsonManager.Load(AFileName: String; ADB: TtxS57ResFiles);
var
  stream: TFileStream;
begin
  stream := TFileStream.Create(AFileName, fmOpenRead);
  try
    load(stream, ADB);
  finally
    stream.Free;
  end;

end;

procedure TtxS57DBJsonManager.Save(ADB: TtxS57ResFiles; AFileName: String);
var
  stream: TFileStream;
begin
  stream := TFileStream.Create(AFileName, fmOpenWrite or fmCreate);
  try
    save(ADB, stream);
  finally
    stream.Free;
  end;

end;

{ TtxS57DataGroup }

constructor TtxS57DataGroup.Create;
begin
  inherited;
  FFiles := TObjectListJson.Create(TtxS57DataFile);
end;

destructor TtxS57DataGroup.Destroy;
begin
  FFiles.Free;
  inherited;
end;

{ TtxS57DataFile }

constructor TtxS57DataFile.Create;
begin
  inherited;
  FFeatures := TObjectListJson.Create(TtxS57DataFeature);
  FRect := TtxS57DataRect.Create;
end;

destructor TtxS57DataFile.Destroy;
begin
  FRect.Free;
  FFeatures.Free;
  inherited;
end;


{ TtxS57DataFeature }

constructor TtxS57DataFeature.Create;
begin
  inherited;
  FAttries := TObjectListJson.Create(TtxS57DataAttr);
  FGeo := TObjectListJson.Create(TtxS57DataLonlats);
end;

destructor TtxS57DataFeature.Destroy;
begin
  FGeo.Free;
  FAttries.Free;
  inherited;
end;

{ TtxS57DataLonlats }

constructor TtxS57DataLonlats.Create;
begin
  inherited;
  FLonlats := TObjectListJson.Create(TtxS57DataLonlat);
end;

destructor TtxS57DataLonlats.Destroy;
begin
  FLonlats.Free;
  inherited;
end;

end.
