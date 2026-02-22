unit txS57Res.Expend;

interface
uses
  System.Classes,
  System.Generics.Collections,
  txgisCanvas.Draw;

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
   (level: 1; max: 3000000; min: 200; English: 'Overview'; Chinese: '概览'),
   (level: 2; max: 1499999; min: 200; English: 'General';Chinese: '一般'),
//   (level: 3; max: 15000; min: 200; English: 'Coastal';Chinese: '沿海'),
   (level: 3; max: 3000000; min: 200; English: 'Coastal';Chinese: '沿海'),
   (level: 4; max: 2500; min: 200; English: 'Approach';Chinese: '进港'),
   (level: 5; max: 600; min: 200; English: 'Harbour';Chinese: '港口'),
   (level: 6; max: 400; min: 100; English: 'Berthing'; Chinese: '靠泊')

  );



type
  TShowStyle = (
        ssShow,      //没变化
        ssHide,
        ssSlowFlash,
        ssFastFlash

        )

        ;

  IS57ExpendInfo = interface
    function GetScaleRange: TtxS57ScaleRange; //当前图的显示级别
  end;

  TS57Expend = class(TPersistent)
  private
    FMinScale: Integer;
    FMaxScale: Integer;
    FTextMaxScale: Integer;
    FShowOnSelected: TShowStyle;
    FhadBuilded: boolean;
    FHide: boolean;
    FtextUpdateTime: int64;
  protected
    function GetMaxScaleAll: integer; virtual;
    procedure AssignTo(Dest: TPersistent); override;
  public
    property MaxScaleAll: integer read GetMaxScaleAll; //当前实际的MMaxScale的，区别于自身的设置
    property MinSCale: Integer read FMinScale write FMinScale;
    property MaxScale: Integer read FMaxScale write FMaxScale;
    property TextMaxScale: Integer read FTextMaxScale write FTextMaxScale;
    constructor Create; virtual;
    destructor Destroy; override;
    procedure Save(stream: TStream); virtual;
    procedure Load(stream: TStream); virtual;
    property ShowOnSelected: TShowStyle read FShowOnSelected write FShowOnSelected; //当前是否显示,如果 被选择
    property Hide: boolean read FHide write FHide;
    property hadBuilded: boolean read FhadBuilded write FhadBuilded; //当前是否正在创建绘制
    property textUpdateTime: int64 read FtextUpdateTime write FtextUpdateTime; //当前文本处理结束时间，用于判断是否有新的更新文本
  end;

  TS57ExpendRow = class(TS57Expend)   //保存的是当前file中包含物标的种类和数量
  private
    FCode: Integer;
    FCount: Integer;
  protected
    procedure AssignTo(Dest: TPersistent); override;
  public
    procedure Save(stream: TStream); override;
    procedure Load(stream: TStream); override;
    property Code: Integer read FCode write FCode;
    property Count: Integer read FCount write FCount;

  end;



  TS57ExpendFile = class(TS57Expend)
  private
    FExpendInfo: IS57ExpendInfo;
    FShowRect: boolean;
    FFeatureRows: TObjectDictionary<integer, TS57ExpendRow>;
    FShowForever: boolean;
    FDrawTag: IMetaLoadData;
  protected
    function GetMaxScaleAll: integer; override;
    procedure AssignTo(Dest: TPersistent); override;
  public
    constructor Create(expendInfo: IS57ExpendInfo);
    destructor Destroy; override;
    procedure Save(stream: TStream); override;
    procedure Load(stream: TStream); override;
    property ShowRect: boolean read FShowRect write FShowRect;
    property ShowForever: boolean read FShowForever write FShowForever;
    property FeatureRows: TObjectDictionary<integer, TS57ExpendRow> read FFeatureRows;
    property DrawTag: IMetaLoadData read  FDrawTag write FDrawTag;
  end;

  TS57ExpendFeature = class(TS57Expend)
  private

  public
  //  property ExptendFile: TS57ExpendFile read GetExptendFile;
  //  property ExptendFile: TS57ExpendFile read GetExptendFile;
  end;

implementation

procedure TS57Expend.AssignTo(Dest: TPersistent);
begin
  var _dest := TS57Expend(dest);
  _dest.FMinScale := FMinScale;
  _dest.FMaxScale := FMaxScale;
  _dest.FTextMaxScale := FTextMaxScale;
  _dest.FShowOnSelected := FShowOnSelected;
  _dest.FhadBuilded := FhadBuilded;
  _dest.FHide := FHide;
end;

constructor TS57Expend.Create;
begin
  inherited Create;
  //默认值是空置
  FMinScale := -1;
  FMaxScale := -1;
  FTextMaxScale := -1;
  FHide := False; //不显示
  FShowOnSelected := ssShow;
end;

destructor TS57Expend.Destroy;
begin
  inherited Destroy;
end;

function TS57Expend.GetMaxScaleAll: integer;
begin
  Result := -1;
end;

procedure TS57Expend.Load(stream: TStream);
begin
  stream.Read(FMinScale, SizeOf(FMinScale));
  stream.Read(FMaxScale, SizeOf(FMaxScale));
  stream.Read(FTextMaxScale, SizeOf(FTextMaxScale));
end;

procedure TS57Expend.Save(stream: TStream);
begin
  stream.write(FMinScale, SizeOf(FMinScale));
  stream.write(FMaxScale, SizeOf(FMaxScale));
  stream.write(FTextMaxScale, SizeOf(FTextMaxScale));
end;

{ TS57ExpendFile }

procedure TS57ExpendFile.AssignTo(Dest: TPersistent);
begin
  inherited;
  var _dest := TS57ExpendFile(dest);
  _dest.FShowRect := FShowRect;
  _dest.FShowForever := FShowForever;
  _dest.FExpendInfo := FExpendInfo;
  _dest.FDrawTag := FDrawTag;

  _dest.FFeatureRows.Clear;
  for var row in FFeatureRows do
  begin
    var _row := TS57ExpendRow.Create;
    _row.Assign(row.Value);
    _dest.FFeatureRows.Add(row.Key, _row);
  end;

end;

constructor TS57ExpendFile.Create(expendInfo: IS57ExpendInfo);
begin
  inherited Create;
  FFeatureRows := TObjectDictionary<integer, TS57ExpendRow>.Create([doOwnsValues]);
  FExpendInfo := expendInfo;
  FShowForever := True;
end;

destructor TS57ExpendFile.Destroy;
begin
  FFeatureRows.Free;
  inherited;
end;

function TS57ExpendFile.GetMaxScaleAll: integer;
begin
  var maxScale := FExpendInfo.GetScaleRange.max;
  //写入cache
  if self.MaxScale <> -1 then
    maxScale := self.MaxScale;
  Result := maxScale;
end;

procedure TS57ExpendFile.Load(stream: TStream);
begin
  inherited;

  stream.read(FShowRect, SizeOf(FShowRect));
  stream.read(FShowForever, SizeOf(FShowForever));


  var len: integer;
  stream.read(len, SizeOf(len));
  FFeatureRows.Clear;
  for var i := 0 to len - 1 do
  begin
    var key: integer;
    stream.Read(key, SizeOf(key));
    var row:= TS57ExpendRow.Create;
    row.Load(stream);
    FFeatureRows.Add(key, row);
  end;

end;

procedure TS57ExpendFile.Save(stream: TStream);
begin
  inherited;

  stream.Write(FShowRect, SizeOf(FShowRect));
  stream.Write(FShowForever, SizeOf(FShowForever));

  var len: integer := FFeatureRows.Count;
  stream.Write(len, SizeOf(len));
  for var pair in FFeatureRows do
  begin
    var key: integer := pair.Key;
    stream.Write(key, SizeOf(key));
    pair.Value.Save(stream);
  end;

end;

{ TS57ExpendRow }

procedure TS57ExpendRow.AssignTo(Dest: TPersistent);
begin
  inherited;
  var _dest := TS57ExpendRow(Dest);
  _dest.FCode := FCode;
  _dest.FCount := FCount;
end;

procedure TS57ExpendRow.Load(stream: TStream);
begin
  inherited;
  stream.Read(FCode, SizeOf(FCode));
  stream.Read(FCount, SizeOf(FCount));
end;

procedure TS57ExpendRow.Save(stream: TStream);
begin
  inherited;
  stream.Write(FCode, SizeOf(FCode));
  stream.Write(FCount, SizeOf(FCount));

end;

end.