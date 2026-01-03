unit txS57Res.Import.Utils;

interface
uses
  txS57Res.Res;

type
  TtxS57ResImportCaption = array[0..5] of byte;
  TtxS57ResImportDesc = array[0..63] of byte;



  TtxS57ResImportFeature = packed record
    sort: TtxS57FeatureType;
    code: word;
    Acronym: TtxS57ResImportCaption;
    Desc: TtxS57ResImportDesc;
  end;


  TtxS57ResImportHead = packed record
    version: integer;
    Desc: TtxS57ResImportDesc;
    count: integer;
    size: integer; //整个数据体的大小
  end;




  TtxS57ResImportFeatureType = (ftGeo, ftMeta, ftCollection, ftCartographic);
  TtxS57ResImportGeoType = (
      vtNone = 0,
      vtArea = 1,
      vtLine = 2,
      vtPoint = 3
      );




implementation

end.
