unit txS57Res.Import.Mgr;

interface
uses
  System.Classes,
  System.SysUtils,
  txS57Res.Res,
  txS57Res.Import.Utils;

type
  TtxS57ResImportMgr = class(TComponent)
  public
    class procedure buildRes(stream: TStream);
    class procedure buildAttrRes(stream: TStream);
  end;

implementation

{ TtxS57ResImportMgr }


{ TtxS57ResImportMgr }

class procedure TtxS57ResImportMgr.buildAttrRes(stream: TStream);
type
  TData = packed record
    FAcronym: array[0..5] of byte;
    FAttiType: TtxS57ObjectAttiType;
    FCode: Integer;
    FDesc: array[0..47] of byte;
//    FEnums: TObjectList<TtxS57resAttiValueEnum>;
//    FListTyles: TtxS57ListType;


  end;

  TValueEnum = packed record
    FCode: word;
    FDesc: array [0..63] of byte;
  end;


var
  atti: TtxS57resAtti;
  count: integer;
  data: TData;
  bytes: TBytes;
  _byte: integer;
  valueEnum: TtxS57resAttiValueEnum;
  enum: TValueEnum;
begin


  count := S57Res.S57Atties.Count;
  stream.Write(count, sizeOf(count));
  for atti in S57Res.S57Atties do
  begin
    fillChar(data, sizeOf(data), 0);
    bytes := TEncoding.ASCII.GetBytes(atti.Acronym);
    Move(PChar(bytes)^, data.FAcronym, Length(bytes));


    data.FAttiType := atti.AttiType;
    data.FCode := atti.Code;
    bytes := TEncoding.ASCII.GetBytes(atti.Desc);

    Move(PChar(bytes)^, data.FDesc, Length(bytes));

    stream.Write(data, sizeof(data));

    count := atti.Enums.Count;
    stream.Write(count, sizeof(count));

    for valueEnum in atti.Enums do
    begin
      fillchar(enum, sizeof(enum), 0);
      enum.FCode := valueEnum.Code;
      bytes := TEncoding.ASCII.GetBytes(valueEnum.Desc);
      Move(PChar(bytes)^, enum.FDesc, Length(bytes));
      stream.Write(enum, sizeof(enum));
    end;





  //尚未发现如何使用，先放弃
//   // stream.Write(count, integer(count));
//
//    for _byte in atti.ListTyles do
//    begin
//      stream.Write(_byte, integer(_byte));
//    end;
//







  end;


end;

class procedure TtxS57ResImportMgr.buildRes(stream: TStream);
var
  byte: TBytes;
  res: TtxS57resObject;
  head: TtxS57ResImporthead;
  importRes: TtxS57ResImportFeature;
  _stream: TMemoryStream;
begin
   FillChar(head, SizeOf(head), 0);
   head.version := 0;
   head.count := S57Res.S57Objects.Count;
   head.size := 0;

  _stream := TMemoryStream.Create;
  try
    for res in S57Res.S57Objects do
    begin
      fillchar(importRes, SizeOf(TtxS57ResImportFeature), 0);
      importRes.Sort := res.FeatureType;
      importRes.code := res.Code;
      byte := TEncoding.ASCII.GetBytes(res.Acronym);
      Move(PChar(byte)^, importRes.Acronym, SizeOf(importRes.Acronym));
      byte := TEncoding.ASCII.GetBytes(res.Desc);
      Move(PChar(byte)^, importRes.Desc, length(byte));
      _stream.Write(importRes, SizeOf(importRes));
    end;

    head.size := _stream.Position;
    stream.Write(head, SizeOf(head));
    _stream.Position := 0;
    stream.CopyFrom(_stream, _stream.Size);
  finally
    _stream.Free;
  end;
end;

end.
