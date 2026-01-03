unit txS57Res.Utils;

interface
uses
  System.Classes, System.SysUtils, System.Generics.Collections,
  System.IOUtils,
  txS57Res.Expend,
  txS57Res.Res,
  txGis.Utils,
  txGis.Lib;

type

   TtxS57ScaleRange = record
    level: integer;
    max: integer;
    min: Integer;
    English: string;
    Chinese: string;
  end;

const
  C_S57ScaleRange: array[0..5] of TtxS57ScaleRange = (
   (level: 1; max: 349999; min: 1499999; English: 'Overview'; Chinese: '概览'),
   (level: 2; max: 1499999; min: 350000; English: 'General';Chinese: '一般'),
   (level: 3; max: 349999; min: 90000; English: 'Coastal';Chinese: '沿海'),
   (level: 4; max: 89999; min: 22000; English: 'Approach';Chinese: '进港'),
   (level: 5; max: 21999; min: 4000; English: 'Harbour';Chinese: '港口'),
   (level: 6; max: 3999; min: 0; English: 'Berthing'; Chinese: '靠泊')

  );


type
  TtxS57ResFile = class;


  TtxS57ResData = class(TPersistent)
  protected
    procedure AssignTo(Dest: TPersistent); override;
  end;

 //这个类是为了保存在S57数据上的缓存
  TtxS57resCache = class(TtxS57ResData)
  private
    FTriangles: TList<TtxgisTriangle>;
  protected
    procedure AssignTo(Dest: TPersistent); override;
  public
    points: TtxgisPointGroup;
    property Triangles: TList<TtxgisTriangle> read FTriangles; // 保存三角形
    constructor Create;
    destructor Destroy; override;
    procedure Save(stream: TStream);
    procedure Load(stream: TStream);

  end;


  TtxS57ResFeature = class(TtxS57ResData)
  private
    Fattries: TDictionary<integer, string>;
    Fcode: integer;
    Fgeo: TArray<TArray<TtxgisCoordinatePoint>>;
    FgeoType: TtxS57ResGeoType;
    Ftag: TObject;
    Fcache: TtxS57resCache;
    FExptend: TS57ExpendFeature;
    FParent: TtxS57ResFile;
    function GetParentExptendFeatureRow: TS57ExpendRow;
  protected
    procedure AssignTo(Dest: TPersistent); override;
  public
    constructor Create(parent: TtxS57ResFile);
    destructor Destroy; override;
    procedure Save(stream: TStream);
    procedure Load(stream: TStream);
    function findAttr(code: string): string;
    function findAttrDouble(code: string; default: double): double;
    function findAttrInteger(code: string; default: integer ): integer;
    function findAttrDoubleValue(code: Integer; default: double): double; overload;
    function findAttrDoubleValue(code: string; default: double): double;  overload;
    function findAttrIntegerValue(code: Integer; default: Integer): Integer; overload;
    function findAttrIntegerValue(code: string; default: Integer): Integer; overload;
    function findAttrListValue(code: integer): TArray<Integer>; overload;
    function findAttrListValue(code: string): TArray<Integer>; overload;
    function findAttrListValueDict(code: string): String; overload;
    function findAttrStringValue(code: Integer): string; overload;
    function findAttrStringValue(code: string): string; overload;
    function findResObj: TtxS57resObject;
    function findGeos:  TArray<TArray<TtxgisPoint>>;

    property code: integer read Fcode write Fcode;
    property attries: TDictionary<integer, string> read Fattries;
    property tag: TObject read Ftag write Ftag;
    property geo: TArray < TArray < TtxgisCoordinatePoint >> read Fgeo write Fgeo;
    property geoType: TtxS57ResGeoType read FgeoType write FgeoType;
    property cache: TtxS57resCache read Fcache write Fcache; //用于S52显示的缓存

    property Exptend: TS57ExpendFeature read FExptend; //非标准扩展的属性

    property Parent: TtxS57ResFile read FParent;
    property ParentExptendFeatureRow: TS57ExpendRow read  GetParentExptendFeatureRow;
  end;


  TtxS57ResFeatures = class(TObjectList<TtxS57ResFeature>)
  public
    constructor Create;
    function Add(parent: TtxS57ResFile): TtxS57ResFeature;
  end;

  TtxS57ResFileClass = class of TtxS57ResFile;

  TtxS57ResFile = class(TtxS57ResData)
  private
    FfileName: string;
    Ffeatures: TtxS57ResFeatures;
    FmaxRect: TtxgisCoordinateRect;
    Ftag: TObject;
    FScale: integer;
    FDesc: string;
    FScaleRange: TtxS57ScaleRange;
    FExptend: TS57ExpendFile;
    FINTU: Integer;
    FRDTN: String;
    FISDT: String;
    FAGEN: String;
    function getMaxScale: integer;
    function getMinScale: integer;
  protected
    procedure AssignTo(Dest: TPersistent); override;
  public
    procedure Save(AFileName: string); overload;
    procedure Save(AStream: TStream); overload;
    procedure Load(AFileName: string); overload;
    procedure Load(AStream: TStream); overload;

    function Selected(APos: TtxgisPoint): boolean;

    property fileName: string read FfileName write FfileName;
    property furntures: TtxS57ResFeatures read Ffeatures;
    property maxRect: TtxgisCoordinateRect read FmaxRect write FmaxRect;
    property tag: TObject read Ftag write Ftag;
    property Scale: integer read FScale write FScale; //制图比例尺
    property ScaleRange: TtxS57ScaleRange read FScaleRange write FScaleRange;
    property Desc: string read FDesc write FDesc; //描述

    property INTU: Integer read FINTU write FINTU; //比例尺等级 1-6
    property ISDT: String read FISDT write FISDT; //发行日期
    property AGEN: String read FAGEN write FAGEN; //发行机构编码，后面有IHO的对照名称表
    property RDTN: String read FRDTN write FRDTN; //发行机构编码，后面有IHO的对照名称表





    property Exptend: TS57ExpendFile read FExptend; //非标准扩展的属性

    property MinScale: integer read getMinScale;
    property MaxScale: integer read getMaxScale;

    constructor Create; virtual;
    destructor Destroy; override;
  end;

  TtxS57ResFiles = class(TObjectList<TtxS57ResFile>)
  public
    constructor Create;
    destructor Destroy; override;
    function Add: TtxS57ResFile; overload;
    function Add(data: TtxS57ResFile): integer; overload;
    function CacheFileName(APath, AFileName: string): string;
    procedure Save(AFileName: string); overload;
    procedure Save(AStream: TStream); overload;
    procedure Load(AFileName: string); overload;
    procedure Load(AStream: TStream); overload;
  end;

implementation

procedure TtxS57ResFile.AssignTo(Dest: TPersistent);
begin
  inherited;
  var _dest := TtxS57ResFile(dest);
  _dest.FfileName := FfileName;
  _dest.Ffeatures.Clear;
  for var fea in Ffeatures do
  begin
    var _fea := _dest.Ffeatures.Add(_dest);
    _fea.Assign(fea);
  end;
    _dest.FmaxRect := FmaxRect;
    _dest.Ftag := Ftag;
    _dest.FScale := FScale;
    _dest.FDesc := FDesc;
    _dest.FScaleRange := FScaleRange;
    _dest.FExptend.Assign(FExptend);
    _dest.FINTU := FINTU;
    _dest.FRDTN := FRDTN;
    _dest.FISDT := FISDT;
    _dest.FAGEN := FAGEN;
end;

constructor TtxS57ResFile.Create;
begin
  inherited Create;
  Ffeatures := TtxS57ResFeatures.Create;
  FExptend := TS57ExpendFile.Create;
end;

destructor TtxS57ResFile.Destroy;
begin
  FExptend.Free;
  Ffeatures.Free;
  inherited Destroy;
end;

function TtxS57ResFile.getMaxScale: integer;
begin
  if FExptend.MaxScale = -1 then
    Result := FScaleRange.max
  else
    Result := FExptend.MaxScale;
end;

function TtxS57ResFile.getMinScale: integer;
begin
  if FExptend.MinScale = -1 then
    Result := FScaleRange.min
  else
    Result := FExptend.MinScale;
end;

procedure TtxS57ResFile.Load(AFileName: string);
var
  stream: TFileStream;
begin
   stream := TFileStream.Create(AFileName, fmOpenRead);
   try
     Load(stream);
   finally
     stream.Free;
   end;
end;

procedure TtxS57ResFile.Load(AStream: TStream);
var
  i, len: integer;
  byte: Tbytes;
begin
  AStream.read(len, sizeOf(len));
  SetLength(byte, len);
  AStream.ReadData(byte, len);
  filename := TEncoding.UTF8.GetString(byte);
  AStream.read(FmaxRect, Sizeof(FmaxRect));



  AStream.read(len, sizeOf(len));
  FScaleRange := C_S57ScaleRange[len - 1];  //缩放级别




  AStream.Read(len, Sizeof(len));
  for i := 0 to len - 1 do
  begin
    Ffeatures.Add(self).Load(AStream);
  end;

  FExptend.Load(AStream);

  AStream.Read(FScale, Sizeof(FScale));
  AStream.Read(FINTU, Sizeof(FINTU));

  AStream.read(len, sizeOf(len));
  SetLength(byte, len);
  AStream.ReadData(byte, len);
  FRDTN := TEncoding.UTF8.GetString(byte);

  AStream.read(len, sizeOf(len));
  SetLength(byte, len);
  AStream.ReadData(byte, len);
  FISDT := TEncoding.UTF8.GetString(byte);

  AStream.read(len, sizeOf(len));
  SetLength(byte, len);
  AStream.ReadData(byte, len);
  FAGEN := TEncoding.UTF8.GetString(byte);


end;

procedure TtxS57ResFile.Save(AFileName: string);
var
  stream: TFileStream;
begin
   stream := TFileStream.Create(AFileName, fmCreate);
   try
     Save(stream);
   finally
     stream.Free;
   end;
end;

procedure TtxS57ResFile.Save(AStream: TStream);
var
  len: integer;
  featrue: TtxS57ResFeature;
  byte: Tbytes;
begin

  byte := TEncoding.UTF8.GetBytes(fileName);
  len := length(byte);
  AStream.Write(len, sizeOf(len));
  AStream.WriteData(byte, len);
  AStream.Write(FmaxRect, Sizeof(FmaxRect));


  len := FScaleRange.level;
  AStream.Write(len, sizeOf(len));


  len := Ffeatures.Count;
  AStream.Write(len, sizeOf(len));

  for featrue in Ffeatures do
    featrue.Save(AStream);

  FExptend.Save(AStream);


  AStream.Write(FScale, Sizeof(FScale));
  AStream.Write(FINTU, Sizeof(FINTU));


  byte := TEncoding.UTF8.GetBytes(FRDTN);
  len := length(byte);
  AStream.Write(len, sizeOf(len));
  AStream.WriteData(byte, len);

  byte := TEncoding.UTF8.GetBytes(FISDT);
  len := length(byte);
  AStream.Write(len, sizeOf(len));
  AStream.WriteData(byte, len);


  byte := TEncoding.UTF8.GetBytes(FAGEN);
  len := length(byte);
  AStream.Write(len, sizeOf(len));
  AStream.WriteData(byte, len);



end;

function TtxS57ResFile.Selected(APos: TtxgisPoint): boolean;
begin
  var rect := GisLib.Proj.toRect(self.FmaxRect);
  Result := rect.inSelf(APos);
end;

procedure TtxS57ResFeature.AssignTo(Dest: TPersistent);
begin
  inherited;
  var _dest := TtxS57ResFeature(Dest);
//  _dest.FParent := FParent; //这里是指针，给指针在创建中指定，不能外部更改
  _dest.Fattries.Clear;
  for var attr in Fattries do
  begin
    _dest.Fattries.Add(attr.Key, attr.Value);
  end;


//  var geo := _dest.geo;
//  setLength(geo, Length(self.geo));
//  for var i := 0 to Length(geo) - 1 do
//  begin
//     for var j := 0 to  Length(geo[i]) - 1 do
//     begin
//
//     end;
//  end;

  _dest.Fcode := Fcode;
  _dest.Fgeo := Fgeo;
  _dest.FgeoType := FgeoType;
//  _dest.Ftag := Ftag;
  if Fcache <> nil then
  begin
    if _dest.Fcache = nil then
      _dest.Fcache := TtxS57resCache.Create;
    _dest.Fcache.Assign(Fcache);
  end;
  _dest.FExptend.Assign(FExptend);
end;

constructor TtxS57ResFeature.Create(parent: TtxS57ResFile);
begin
  inherited Create;
  Fattries := TDictionary<integer, string>.Create;
  FExptend := TS57ExpendFeature.Create;
  FParent := parent;
end;

destructor TtxS57ResFeature.Destroy;
begin
  FExptend.Free;
  Fattries.Free;
  FreeAndNil(Fcache);
  inherited Destroy;
end;
function TtxS57ResFeature.findAttr(code: string): string;
begin
  var attr := S57Res.GetResAtti(code);
  if attr = nil then
    Result := ''
  else
  if attries.ContainsKey(attr.Code) then
    Result := attries[attr.Code]
  else
    Result := '';
end;

function TtxS57ResFeature.findAttrDouble(code: string; default: double): double;
begin
  var attr := S57Res.GetResAtti(code);
  if attr = nil then
    Result := default
  else
  if attries.ContainsKey(attr.Code) then
    Result := StrToFloatDef(attries[attr.Code], default);
end;

function TtxS57ResFeature.findAttrDoubleValue(code: string;
  default: double): double;
begin
  if S57Res.GetResAtti(code) = nil then
    Result := default
  else
    Result := findAttrDoubleValue(S57Res.GetResAtti(code).code, default);
end;

function TtxS57ResFeature.findAttrDoubleValue(code: Integer;
  default: double): double;
begin
  if self.attries.ContainsKey(code) then
    Result := StrToFloatDef(self.attries[code], default)
  else
    Result := default;
end;

function TtxS57ResFeature.findAttrInteger(code: string; default: integer ): integer;
begin
  var attr := S57Res.GetResAtti(code);
  if attr = nil then
    Result := default
  else
  if attries.ContainsKey(attr.Code) then
    Result := StrToIntDef(attries[attr.Code], default);

end;

function TtxS57ResFeature.findAttrIntegerValue(code: string;
  default: Integer): Integer;
begin
  if S57Res.GetResAtti(code) = nil then
    Result := default
  else
  Result := findAttrIntegerValue(S57Res.GetResAtti(code).code, default);
end;

function TtxS57ResFeature.findAttrIntegerValue(code, default: Integer): Integer;
begin
  if self.attries.ContainsKey(code) then
    Result := StrToIntDef(self.attries[code], default)
  else
    Result := default;
end;

function TtxS57ResFeature.findAttrListValue(code: string): TArray<Integer>;
begin
  Result := findAttrListValue(S57Res.GetResAtti(code).code);
end;

function TtxS57ResFeature.findAttrListValue(code: integer): TArray<Integer>;
var
  i: Integer;
  ss: TArray<string>;
begin
  if self.attries.ContainsKey(code) then
  begin
    ss := self.attries[code].Split([',']);
    Setlength(Result, length(ss));
    for i := 0 to length(ss) - 1 do
    begin
      { TODO : 2018-04-04 返回有错误的空格 }
      Result[i] := StrToIntDef(ss[i], 0);
      //-----
    end;
  end
  else
    Result := nil;
end;


function TtxS57ResFeature.findAttrListValueDict(code: string): String;
var
  attris: TArray<integer>;
  attriDict: TtxS57resAtti;
  i, v: integer;
begin
  attriDict := S57Res.GetResAtti(code);
  attris := findAttrListValue(attriDict.code);
  Result := '';
  i := 0;
  for v in attris do
  begin
    if i = 0 then
      Result := attriDict.GetMnum(v).Desc
    else
      Result := Result + ',' + attriDict.GetMnum(v).Desc;
  end;
end;

function TtxS57ResFeature.findAttrStringValue(code: Integer): string;
begin
  if  self.attries.Count = 0 then
    exit;



  if self.attries.ContainsKey(code) then
    Result := self.attries[code]
  else
    Result := '';
end;


function TtxS57ResFeature.findAttrStringValue(code: string): string;
var
  attr: TtxS57resAtti;
begin
  Result := '';
  attr := S57Res.GetResAtti(code);
  if attr <>nil then
    Result := findAttrStringValue(attr.code);
end;


function TtxS57ResFeature.findGeos: TArray<TArray<TtxgisPoint>>;
begin
  Result := GisLib.Proj.toPoint(Fgeo);
end;

function TtxS57ResFeature.findResObj: TtxS57resObject;
begin
  result :=  S57Res.findObj(code);
end;

function TtxS57ResFeature.GetParentExptendFeatureRow: TS57ExpendRow;
begin
  if self.FParent.Exptend.FeatureRows.ContainsKey(code) then
    Result := self.FParent.Exptend.FeatureRows[code]
  else
    Result := nil;
end;


procedure TtxS57ResFeature.Load(stream: TStream);
var
  i, j, len, len1, key: integer;
  value: string;
  byte: Tbytes;
  _geos: TArray<TtxgisCoordinatePoint>;
begin
  stream.Read(len, sizeof(len));
  for i := 0 to len - 1 do
  begin
    stream.Read(key, sizeof(key));
    stream.Read(len1, sizeof(len1));
    SetLength(byte, len1);
    stream.ReadData(byte, len1);
    value := TEncoding.UTF8.GetString(byte);
    Fattries.Add(key, value);
  end;

  stream.Read(Fcode, sizeof(Fcode));
  stream.Read(len, sizeof(len));
  setLength(Fgeo, len);
  for i := 0 to len - 1 do
  begin
    _geos := Fgeo[i];
    stream.Read(len1, sizeof(len1));
    SetLength(_geos, len1);
    for j := 0 to len1 - 1 do
    begin
      stream.Read(_geos[j], sizeof(_geos[j]));
    end;
    Fgeo[i] := _geos;
  end;
  stream.Read(FgeoType, sizeof(FgeoType));


  stream.Read(len, sizeof(len));
  if len > 0 then
  begin
    Fcache := TtxS57resCache.Create;
    Fcache.Load(Stream);
  end;


end;

procedure TtxS57ResFeature.Save(stream: TStream);
var
  len, key: integer;
  attr: TPair<integer, string>;
  byte: TBytes;
  _geos: TArray<TtxgisCoordinatePoint>;
  _geo: TtxgisCoordinatePoint;
begin
   //写属性
   len := Fattries.Count;
   stream.Write(len, sizeof(len));
   for attr in Fattries do
   begin
     key := attr.key;
     stream.Write(Key, sizeof(Key));
     byte := TEncoding.UTF8.GetBytes(attr.Value);
     len := length(byte);
     stream.Write(len, sizeof(len));
     stream.WriteData(byte, len);
   end;
   stream.Write(Fcode, sizeof(Fcode));



   len := Length(Fgeo);
   stream.Write(len, sizeof(len));
   for _geos in Fgeo do
   begin
     len := Length(_geos);
     stream.Write(len, sizeof(len));
     for _geo in _geos do
     begin
       stream.Write(_geo, Sizeof(TtxgisCoordinatePoint));
     end;
   end;
   stream.Write(FgeoType, sizeof(FgeoType));

   //写缓存
   if Fcache = nil then
   begin
     len := 0;
     stream.Write(len, sizeof(len));
   end
   else begin
     len := 1;
     stream.Write(len, sizeof(len));
     Fcache.Save(stream);
   end;




end;

{ TtxS57ResFeatures }

function TtxS57ResFeatures.Add(parent: TtxS57ResFile): TtxS57ResFeature;
begin
  Result := TtxS57ResFeature.Create(parent);
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

function TtxS57ResFiles.Add(data: TtxS57ResFile): integer;
begin
  Result := inherited Add(data);
end;

function TtxS57ResFiles.CacheFileName(APath, AFileName: string): string;
var
  path: string;
begin
  path := TPath.Combine(APath, '_cache');
  Result := TPath.Combine(path, AFileName + '.cache');

  path := TDirectory.GetParent(Result);
  if not TDirectory.Exists(path) then
  begin
    TDirectory.CreateDirectory(path);
  end;


end;

constructor TtxS57ResFiles.Create;
begin
  inherited Create;
end;

destructor TtxS57ResFiles.Destroy;
begin
  inherited;
end;

procedure TtxS57ResFiles.Load(AFileName: string);
var
  stream: TFileStream;
begin
   stream := TFileStream.Create(AFileName, fmOpenRead);
   try
     Load(stream);
   finally
     stream.Free;
   end;
end;

procedure TtxS57ResFiles.Load(AStream: TStream);
var
  i, len: Integer;
begin
  //读数量
  AStream.Read(len, sizeOf(len));
  for i := 0 to len - 1 do
    self.Add;

  for i := 0 to len - 1 do
    self[i].Load(AStream);

end;


procedure TtxS57ResFiles.Save(AFileName: string);
var
  stream: TFileStream;
begin
   stream := TFileStream.Create(AFileName, fmCreate);
   try
     Save(stream);
   finally
     stream.Free;
   end;
end;

procedure TtxS57ResFiles.Save(AStream: TStream);
var
  i, len: Integer;
begin
  //写数量
  len := self.Count;
  AStream.Write(len, sizeOf(len));
  for i := 0 to len - 1 do
  begin
    self[i].Save(AStream);
  end;

end;

{ TtxS57resCache }

procedure TtxS57resCache.AssignTo(Dest: TPersistent);
begin
  inherited;
  var _dest := TtxS57resCache(dest);
  _dest.FTriangles.Clear;
  for var tri in self.FTriangles do
  begin
    _dest.FTriangles.Add(tri);
  end;

  _dest.points := points;
end;

constructor TtxS57resCache.Create;
begin
  FTriangles := TList<TtxgisTriangle>.Create;
end;

destructor TtxS57resCache.Destroy;
begin
  FTriangles.Free;
  inherited;
end;

procedure TtxS57resCache.Load(stream: TStream);
var
  i, j, len, len1: integer;
begin
  stream.read(len, sizeof(len));
  setLength(points, len);
  for i := 0 to len - 1 do
  begin
    stream.read(len1, sizeof(len1));
    setLength(points[i], len1);
    for j := 0 to len1 - 1 do
    begin
     stream.read(points[i][j], Sizeof(TtxgisPoint));
    end;
  end;

  //三角形缓存
  stream.Read(len, sizeof(len));
  for i := 0 to len - 1 do
  begin
    var tri: TtxgisTriangle;
    stream.Read(tri, Sizeof(tri));
    Triangles.Add(tri);
  end;
end;

procedure TtxS57resCache.Save(stream: TStream);
var
  len: integer;
begin
  len := Length(points);
  stream.Write(len, sizeof(len));
  for var ps in points do
  begin
     len := Length(ps);
     stream.Write(len, sizeof(len));
     for var p in ps do
     begin
       stream.Write(p, Sizeof(TtxgisPoint));
     end;
  end;

  //三角形缓存
  len := self.Triangles.Count;
  stream.Write(len, sizeof(len));
  for var tri in Triangles do
  begin
    stream.Write(tri, Sizeof(tri));
  end;

end;

{ TtxS57ResData }

procedure TtxS57ResData.AssignTo(Dest: TPersistent);
begin
//  inherited;

end;

end.
