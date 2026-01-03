unit txS57Res.Import.db.mgr;

interface
uses
  System.Classes,
  System.SysUtils,
  System.Generics.Collections,
  txGis.Utils,
  txS57Res.Utils,
  txS57Res.Import.db.utils;


type
  S57ResImprotDBMgr = class(TComponent)
  private
    procedure buildFile(resFile: TtxS57ResFile; fileStream, featureStream, keyvalueStream, LonlatStream: TStream);
    procedure buildFeature(resFeature: TtxS57ResFeature; featureStream, keyvalueStream, LonlatStream: TStream);
    procedure buildAttrie(resFeature: TtxS57ResFeature; keyvalueStream: TStream);
    function buildLonlat(resFeature: TtxS57ResFeature; lonlatStream: TStream): TtxgisCoordinateRect;
  public
    procedure importDB(AStream: TStream; ADB: TtxS57ResFiles; caption: String); overload;
    procedure importDB(ADB: TtxS57ResFiles; caption: String); overload;
  end;

implementation

procedure S57ResImprotDBMgr.buildAttrie(resFeature: TtxS57ResFeature;
  keyvalueStream: TStream);
var
  pair: TPair<integer, String>;
  byte: TBytes;
  key: integer;
  count: integer;
begin
  //写个数
  count := resFeature.attries.Count;
  keyvalueStream.write(count, SizeOf(integer));
  for pair in resFeature.attries do
  begin
    key := pair.Key;

    if key = 131 then
       key := 131;


    keyvalueStream.Write(key, Sizeof(key));

    byte := TEncoding.UTF8.GetBytes(pair.Value);
    count := Length(byte);
    keyvalueStream.Write(count, Sizeof(count));
    keyvalueStream.Write(PChar(byte)^, count);
  end;

end;


procedure S57ResImprotDBMgr.buildFeature(resFeature: TtxS57ResFeature;
  featureStream, keyvalueStream, LonlatStream: TStream);
var
  feature: TImportFeature;
begin
  feature.geoType := Byte(resFeature.geoType);
  feature.code := resFeature.code;
  feature.attri := keyvalueStream.Position;
  feature.lonlat := LonlatStream.Position;

  if (resFeature.code = 71) then
  begin
    resFeature.code := 71;
  end;


  buildAttrie(resFeature, keyvalueStream);




  feature.rect.Create(buildLonlat(resFeature, lonlatStream));
  feature.attri_size := keyvalueStream.Position - feature.attri;
  feature.lonlat_size := LonlatStream.Position - feature.lonlat;
  featureStream.Write(feature, SizeOf(feature));




end;

procedure S57ResImprotDBMgr.buildFile(resFile: TtxS57ResFile; fileStream,
  featureStream, keyvalueStream, LonlatStream: TStream);
var
  _resFeature: TtxS57ResFeature;
  byte: TBytes;
  importFile: TImportFile;
  count: integer;
begin
  fillChar(importFile, Sizeof(importFile), 0);
  byte := TEncoding.ASCII.GetBytes(resFile.fileName);
  Move(PChar(byte)^, importFile.caption, 16);
  importFile.rect.Create(resFile.maxRect);
  importFile.feature := featureStream.Position;
  fileStream.Write(importFile, SizeOf(importFile));
  //写数量
  count := resFile.furntures.Count;
  featureStream.Write(count, SizeOf(count));
  for _resFeature in resFile.furntures do
  begin

     if _resFeature.code = 41 then
        count := 0;



     buildFeature(_resFeature, featureStream, keyvalueStream, LonlatStream);
  end;

end;

function S57ResImprotDBMgr.buildLonlat(resFeature: TtxS57ResFeature;
  lonlatStream: TStream): TtxgisCoordinateRect;
var
  i,count, key: integer;
  point: TtxgisCoordinatePoint;
  lonlat: TLonlat;
begin
  Result.setNull;
  //写经纬度组的数量
  key := Length(resFeature.geo);
  lonlatStream.Write(key, SizeOf(key));
  for i := 0 to key - 1 do
  begin
    count := Length(resFeature.geo[i]);
    lonlatStream.Write(count, SizeOf(count));
    for point in resFeature.geo[i] do
    begin
      Result.Max(point);
      lonlat.lon := point.longitude;
      lonlat.lat := point.latitude;
      if point.height > 0 then
         lonlat.height := lonlat.height + 1 - 1;

      lonlat.height := round(point.height * 100);
      lonlatStream.Write(lonlat, SizeOf(lonlat));
    end;
  end;


end;

procedure S57ResImprotDBMgr.importDB(ADB: TtxS57ResFiles; caption: String);
begin

end;

procedure S57ResImprotDBMgr.importDB(AStream: TStream; ADB: TtxS57ResFiles;
  caption: String);
var
  fileStream, featureStream, keyvalueStream, lonlatStream: TMemoryStream;
  _resFile: TtxS57ResFile;
  importFileGroup: TImportFileGroup;
  byte:TBytes;
  rect: TtxgisCoordinateRect;
begin
  fillChar(importFileGroup, Sizeof(importFileGroup), 0);
  byte := TEncoding.UTF8.GetBytes(caption);
  Move(PChar(byte)^, importFileGroup.caption, Length(byte));

  fileStream := TMemoryStream.Create;
  featureStream := TMemoryStream.Create;
  keyvalueStream := TMemoryStream.Create;
  lonlatStream := TMemoryStream.Create;

  fileStream := TMemoryStream.Create;
  rect.setNull;
  fileStream.write(ADB.Count, Sizeof(integer)); //文件数
  for _resFile in ADB do
  begin
    buildFile(_resFile, fileStream, featureStream, keyvalueStream, lonlatStream);
    rect.max(_resFile.maxRect.westnorth);
    rect.max(_resFile.maxRect.eastsouth);
  end;

  byte := TEncoding.UTF8.GetBytes(caption);

  Move(PChar(byte)^, importFileGroup.caption, 64);


  importFileGroup.rect.Create(rect);

  importFileGroup.feature := SizeOf(importFileGroup) + fileStream.Size;
  importFileGroup.attries :=  importFileGroup.feature + featureStream.Size;
  importFileGroup.geo := importFileGroup.attries + keyvalueStream.Size;

  AStream.write(importFileGroup, SizeOf(importFileGroup));

  fileStream.Position := 0;
  AStream.CopyFrom(fileStream, fileStream.Size);
  featureStream.Position := 0;
  AStream.CopyFrom(featureStream, featureStream.Size);
  keyvalueStream.Position := 0;
  AStream.CopyFrom(keyvalueStream, keyvalueStream.Size);
  lonlatStream.Position := 0;
  AStream.CopyFrom(lonlatStream, lonlatStream.Size);
end;

end.
