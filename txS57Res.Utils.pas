unit txS57Res.Utils;

interface
uses
  System.Classes, System.SysUtils, System.Generics.Collections,
  txS57Res.Res,
  txGis.Utils;

type
  TtxS57ResFeature = class
  private
    Fattries: TDictionary<integer, string>;
    Fcode: integer;
    Fgeo: TArray<TArray<TtxgisCoordinatePoint>>;
    FgeoType: TtxS57ResGeoType;
    Ftag: TObject;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    property code: integer read Fcode write Fcode;
    property attries: TDictionary<integer, string> read Fattries;
    property tag: TObject read Ftag write Ftag;
    property geo: TArray < TArray < TtxgisCoordinatePoint >> read Fgeo write Fgeo;
    property geoType: TtxS57ResGeoType read FgeoType write FgeoType;
  end;


  TtxS57ResFeatures = class(TObjectList<TtxS57ResFeature>)
  public
    constructor Create;
    function Add: TtxS57ResFeature;
  end;

  TtxS57ResFileClass = class of TtxS57ResFile;

  TtxS57ResFile = class
  private
    FfileName: string;
    Ffeatures: TtxS57ResFeatures;
    FmaxRect: TtxgisCoordinateRect;
    Ftag: TObject;
  public
    property fileName: string read FfileName write FfileName;
    property furntures: TtxS57ResFeatures read Ffeatures;
    property maxRect: TtxgisCoordinateRect read FmaxRect write FmaxRect;
    property tag: TObject read Ftag write Ftag;
    constructor Create; virtual;
    destructor Destroy; override;
  end;

  TtxS57ResFiles = class(TObjectList<TtxS57ResFile>)
  public
    constructor Create;
    function Add: TtxS57ResFile;
  end;

implementation

constructor TtxS57ResFile.Create;
begin
  inherited Create;
  Ffeatures := TtxS57ResFeatures.Create;
end;

destructor TtxS57ResFile.Destroy;
begin
  Ffeatures.Free;
  inherited Destroy;
end;

constructor TtxS57ResFeature.Create;
begin
  inherited Create;
  Fattries := TDictionary<integer, string>.Create;
end;

destructor TtxS57ResFeature.Destroy;
begin
  Fattries.Free;
  inherited Destroy;
end;
{ TtxS57ResFeatures }

function TtxS57ResFeatures.Add: TtxS57ResFeature;
begin
  Result := TtxS57ResFeature.Create;
  inherited Add(Result);
end;

constructor TtxS57ResFeatures.Create;
begin
  inherited Create;
end;

{ TtxS57ResFiles }

function TtxS57ResFiles.Add: TtxS57ResFile;
begin
  Result := TtxS57ResFile.Create;
  inherited Add(Result);
end;

constructor TtxS57ResFiles.Create;
begin
  inherited Create;
end;

end.
