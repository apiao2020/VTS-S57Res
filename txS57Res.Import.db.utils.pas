unit txS57Res.Import.db.utils;

interface
uses
  txGis.utils;
type
  TLonlat = packed record
    lon: double;
    lat: double;
    height: integer; //高度，放大100倍数
  end;


  TGeoRect = packed record
    east: double;
    south: double;
    north: double;
    west: double;
  public constructor Create(rect: TtxgisCoordinateRect);
  end;



  TCaption256 = array[0..255] of Byte;
  TCaption64 = array[0..63] of Byte;
  TCaption16 = array[0..15] of Byte;
  TCaption10 = array[0..9] of Byte;
  TCaption8 = array[0..7] of Byte;


  TImportFeature = packed record
    code: word;
    geoType: byte;
    rect: TGeoRect;
    attri: int64;
    attri_size: integer;
    lonlat: int64;
    lonlat_size: integer;
  end;




  TImportFile = packed record
    caption: TCaption16;
    rect: TGeoRect;
    feature: int64;
  end;



  TImportFileGroup = packed record
    caption: TCaption64;
    desc: TCaption256;
    version: integer;
    buildTime: TCaption16; //构建日期
    key: TCaption64; //构建的用户密钥
    rect: TGeoRect;
    feature: int64; //featue开始的位置
    attries: int64; //字典的位置
    geo: int64; //坐标点的位置
  end;

implementation

{ TGeoRect }

constructor TGeoRect.Create(rect: TtxgisCoordinateRect);
begin
  self.east := rect.east;
  self.west := rect.west;
  self.north := rect.north;
  self.south := rect.south;
end;

end.
