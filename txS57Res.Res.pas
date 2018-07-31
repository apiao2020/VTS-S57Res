unit txS57Res.Res;

interface

uses
  System.Classes, System.SysUtils, System.Types, System.Generics.Collections,
  IniFiles;

type
  TtxS57FeatureType = (ftGeo, ftMeta, ftCollection, ftCartographic);
  TtxS57ResGeoType = (
      vtNone = 0,
      vtArea = 1,
      vtLine = 2,
      vtPoint = 3

      );



  TtxS57ObjectAttiTypeOld = (otFeatureObject, otNationalLanguage,
                             otSpatialAndMetaObject);


  TtxS57ObjectAttiName = record
    Sort: TtxS57ObjectAttiTypeOld;
    Code: Integer;
    Acronym: string;
    Desc: string;
  end;



  TtxS57ObjectFeatureValue = record
    Sort: TtxS57FeatureType;
    Code: Integer;
    Acronym: string;
    Desc: string;
  end;


  //属性的list类型
  TtxS57ListType = set of Byte;

  //属性的数据类型
  TtxS57ObjectAttiType = (
           atNone,    //未知的
           atInteger, //整数
           atFolat,   //浮点
           atString,  //字符串
           atEmnu,    //枚举
           atList     //集合类型
  );







  TtxS57resAttiValueEnum = class(TObject)
  private
    FCode: Integer;
    FDesc: string;
  public
    property Code: Integer read FCode write FCode;
    property Desc: string read FDesc write FDesc;
  end;


  TtxS57resAtti = class(TObject)
  private
    FAcronym: string;
    FAttiType: TtxS57ObjectAttiType;
    FCode: Integer;
    FDesc: string;
    FEnums: TObjectList<TtxS57resAttiValueEnum>;
    FListTyles: TtxS57ListType;
  public
    constructor Create;
    destructor Destroy; override;
    function GetMnum(AIndex: Integer): TtxS57resAttiValueEnum;
    function GetMnumsValue(AIndexes: string): string;
    property Acronym: string read FAcronym write FAcronym;
    property AttiType: TtxS57ObjectAttiType read FAttiType write FAttiType;
    property Code: Integer read FCode write FCode;
    property Desc: string read FDesc write FDesc;
    property Enums: TObjectList<TtxS57resAttiValueEnum> read FEnums write FEnums;
    property ListTyles: TtxS57ListType read FListTyles write FListTyles;
  end;

  TtxS57resObjectAtti = class(TObject)
  private
    FAcronym: string;
    FS57Atti: TtxS57resAtti;
  public
    property Acronym: string read FAcronym write FAcronym;
    property S57Atti: TtxS57resAtti read FS57Atti write FS57Atti;
  end;

  TtxS57resObject = class(TObject)
  private
    FAcronym: string;
    FAttribute_A: TObjectList<TtxS57resObjectAtti>;
    FAttribute_B: TObjectList<TtxS57resObjectAtti>;
    FAttribute_C: TObjectList<TtxS57resObjectAtti>;
    FCode: Integer;
    FDesc: string;
    FFeatureType: TtxS57FeatureType;
  public
    constructor Create;
    destructor Destroy; override;
    property Acronym: string read FAcronym write FAcronym;
    property Attribute_A:  TObjectList<TtxS57resObjectAtti> read FAttribute_A;
    property Attribute_B:  TObjectList<TtxS57resObjectAtti> read FAttribute_B;
    property Attribute_C:  TObjectList<TtxS57resObjectAtti> read FAttribute_C;
    property Code: Integer read FCode write FCode;
    property Desc: string read FDesc write FDesc;
    property FeatureType: TtxS57FeatureType read FFeatureType;
  end;

  TtxS57Resource = class(TObject)
  private
    FlstS57Res: TArray<string>;
    FS57Atties: TObjectList<TtxS57resAtti>;
    FS57Objects: TObjectList<TtxS57resObject>;
  protected
    procedure LinkAtti;
    procedure LoadAttiRes;
    procedure LoadObejctRes;
  public
    constructor Create;
    destructor Destroy; override;
    function getAtti(ACode: Integer): TtxS57resAtti;
    function GetResAtti(AAcronym: string): TtxS57resAtti;
    function findObj(AOBJL: Integer): TtxS57resObject;
    procedure ParseAtti;
    procedure ParseObejct;
    function StrToListType(str: string): TArray<integer>;
    function IsIntersection(a,b: TArray<integer>): boolean;
    property S57Atties: TObjectList<TtxS57resAtti> read FS57Atties;
    property S57Objects: TObjectList<TtxS57resObject> read FS57Objects;
  end;


const
  c_S57ObjectFeatureValue: array[0..182] of TtxS57ObjectFeatureValue = (
(Sort: ftGeo; Code: 1; Acronym: 'ADMARE'; Desc: 'Administration Area (Named)'),
(Sort: ftGeo; Code: 2; Acronym: 'AIRARE'; Desc: 'Airport/airfield'),
(Sort: ftGeo; Code: 3; Acronym: 'ACHBRT'; Desc: 'Anchor berth'),
(Sort: ftGeo; Code: 4; Acronym: 'ACHARE'; Desc: 'Anchorage area'),
(Sort: ftGeo; Code: 5; Acronym: 'BCNCAR'; Desc: 'Beacon, cardinal'),
(Sort: ftGeo; Code: 6; Acronym: 'BCNISD'; Desc: 'Beacon, isolated danger'),
(Sort: ftGeo; Code: 7; Acronym: 'BCNLAT'; Desc: 'Beacon, lateral'),
(Sort: ftGeo; Code: 8; Acronym: 'BCNSAW'; Desc: 'Beacon, safe water'),
(Sort: ftGeo; Code: 9; Acronym: 'BCNSPP'; Desc: 'Beacon, special purpose/general'),
(Sort: ftGeo; Code: 10; Acronym: 'BERTHS'; Desc: 'Berth'),
(Sort: ftGeo; Code: 11; Acronym: 'BRIDGE'; Desc: 'Bridge'),
(Sort: ftGeo; Code: 12; Acronym: 'BUISGL'; Desc: 'Building, single'),
(Sort: ftGeo; Code: 13; Acronym: 'BUAARE'; Desc: 'Built-up area'),
(Sort: ftGeo; Code: 14; Acronym: 'BOYCAR'; Desc: 'Buoy, cardinal'),
(Sort: ftGeo; Code: 15; Acronym: 'BOYINB'; Desc: 'Buoy, installation'),
(Sort: ftGeo; Code: 16; Acronym: 'BOYISD'; Desc: 'Buoy, isolated danger'),
(Sort: ftGeo; Code: 17; Acronym: 'BOYLAT'; Desc: 'Buoy, lateral'),
(Sort: ftGeo; Code: 18; Acronym: 'BOYSAW'; Desc: 'Buoy, safe water'),
(Sort: ftGeo; Code: 19; Acronym: 'BOYSPP'; Desc: 'Buoy, special purpose/general'),
(Sort: ftGeo; Code: 20; Acronym: 'CBLARE'; Desc: 'Cable area'),
(Sort: ftGeo; Code: 21; Acronym: 'CBLOHD'; Desc: 'Cable, overhead'),
(Sort: ftGeo; Code: 22; Acronym: 'CBLSUB'; Desc: 'Cable, submarine'),
(Sort: ftGeo; Code: 23; Acronym: 'CANALS'; Desc: 'Canal'),
(Sort: ftGeo; Code: 24; Acronym: 'CANBNK'; Desc: 'Canal bank'),
(Sort: ftGeo; Code: 25; Acronym: 'CTSARE'; Desc: 'Cargo transhipment area'),
(Sort: ftGeo; Code: 26; Acronym: 'CAUSWY'; Desc: 'Causeway'),
(Sort: ftGeo; Code: 27; Acronym: 'CTNARE'; Desc: 'Caution area'),
(Sort: ftGeo; Code: 28; Acronym: 'CHKPNT'; Desc: 'Checkpoint'),
(Sort: ftGeo; Code: 29; Acronym: 'CGUSTA'; Desc: 'Coastguard station'),
(Sort: ftGeo; Code: 30; Acronym: 'COALNE'; Desc: 'Coastline'),
(Sort: ftGeo; Code: 31; Acronym: 'CONZNE'; Desc: 'Contiguous zone'),
(Sort: ftGeo; Code: 32; Acronym: 'COSARE'; Desc: 'Continental shelf area'),
(Sort: ftGeo; Code: 33; Acronym: 'CTRPNT'; Desc: 'Control point'),
(Sort: ftGeo; Code: 34; Acronym: 'CONVYR'; Desc: 'Conveyor'),
(Sort: ftGeo; Code: 35; Acronym: 'CRANES'; Desc: 'Crane'),
(Sort: ftGeo; Code: 36; Acronym: 'CURENT'; Desc: 'Current - non-gravitational'),
(Sort: ftGeo; Code: 37; Acronym: 'CUSZNE'; Desc: 'Custom zone'),
(Sort: ftGeo; Code: 38; Acronym: 'DAMCON'; Desc: 'Dam'),
(Sort: ftGeo; Code: 39; Acronym: 'DAYMAR'; Desc: 'Daymark'),
(Sort: ftGeo; Code: 40; Acronym: 'DWRTCL'; Desc: 'Deep water route centerline'),
(Sort: ftGeo; Code: 41; Acronym: 'DWRTPT'; Desc: 'Deep water route part'),
(Sort: ftGeo; Code: 42; Acronym: 'DEPARE'; Desc: 'Depth area'),
(Sort: ftGeo; Code: 43; Acronym: 'DEPCNT'; Desc: 'Depth contour'),
(Sort: ftGeo; Code: 44; Acronym: 'DISMAR'; Desc: 'Distance mark'),
(Sort: ftGeo; Code: 45; Acronym: 'DOCARE'; Desc: 'Dock area'),
(Sort: ftGeo; Code: 46; Acronym: 'DRGARE'; Desc: 'Dredged area'),
(Sort: ftGeo; Code: 47; Acronym: 'DRYDOC'; Desc: 'Dry dock'),
(Sort: ftGeo; Code: 48; Acronym: 'DMPGRD'; Desc: 'Dumping ground'),
(Sort: ftGeo; Code: 49; Acronym: 'DYKCON'; Desc: 'Dyke'),
(Sort: ftGeo; Code: 50; Acronym: 'EXEZNE'; Desc: 'Exclusive economic zone'),
(Sort: ftGeo; Code: 51; Acronym: 'FAIRWY'; Desc: 'Fairway'),
(Sort: ftGeo; Code: 52; Acronym: 'FNCLNE'; Desc: 'Fence/wall'),
(Sort: ftGeo; Code: 53; Acronym: 'FERYRT'; Desc: 'Ferry route'),
(Sort: ftGeo; Code: 54; Acronym: 'FSHZNE'; Desc: 'Fishery zone'),
(Sort: ftGeo; Code: 55; Acronym: 'FSHFAC'; Desc: 'Fishing facility'),
(Sort: ftGeo; Code: 56; Acronym: 'FSHGRD'; Desc: 'Fishing ground'),
(Sort: ftGeo; Code: 57; Acronym: 'FLODOC'; Desc: 'Floating dock'),
(Sort: ftGeo; Code: 58; Acronym: 'FOGSIG'; Desc: 'Fog signal'),
(Sort: ftGeo; Code: 59; Acronym: 'FORSTC'; Desc: 'Fortified structure'),
(Sort: ftGeo; Code: 60; Acronym: 'FRPARE'; Desc: 'Free port area'),
(Sort: ftGeo; Code: 61; Acronym: 'GATCON'; Desc: 'Gate'),
(Sort: ftGeo; Code: 62; Acronym: 'GRIDRN'; Desc: 'Gridiron'),
(Sort: ftGeo; Code: 63; Acronym: 'HRBARE'; Desc: 'Harbour area (administrative)'),
(Sort: ftGeo; Code: 64; Acronym: 'HRBFAC'; Desc: 'Harbour facility'),
(Sort: ftGeo; Code: 65; Acronym: 'HULKES'; Desc: 'Hulk'),
(Sort: ftGeo; Code: 66; Acronym: 'ICEARE'; Desc: 'Ice area'),
(Sort: ftGeo; Code: 67; Acronym: 'ICNARE'; Desc: 'Incineration area'),
(Sort: ftGeo; Code: 68; Acronym: 'ISTZNE'; Desc: 'Inshore traffic zone'),
(Sort: ftGeo; Code: 69; Acronym: 'LAKARE'; Desc: 'Lake'),
(Sort: ftGeo; Code: 70; Acronym: 'LAKSHR'; Desc: 'Lake shore'),
(Sort: ftGeo; Code: 71; Acronym: 'LNDARE'; Desc: 'Land area'),
(Sort: ftGeo; Code: 72; Acronym: 'LNDELV'; Desc: 'Land elevation'),
(Sort: ftGeo; Code: 73; Acronym: 'LNDRGN'; Desc: 'Land region'),
(Sort: ftGeo; Code: 74; Acronym: 'LNDMRK'; Desc: 'Landmark'),
(Sort: ftGeo; Code: 75; Acronym: 'LIGHTS'; Desc: 'Light'),
(Sort: ftGeo; Code: 76; Acronym: 'LITFLT'; Desc: 'Light float'),
(Sort: ftGeo; Code: 77; Acronym: 'LITVES'; Desc: 'Light vessel'),
(Sort: ftGeo; Code: 78; Acronym: 'LOCMAG'; Desc: 'Local magnetic anomaly'),
(Sort: ftGeo; Code: 79; Acronym: 'LOKBSN'; Desc: 'Lock basin'),
(Sort: ftGeo; Code: 80; Acronym: 'LOGPON'; Desc: 'Log pond'),
(Sort: ftGeo; Code: 81; Acronym: 'MAGVAR'; Desc: 'Magnetic variation'),
(Sort: ftGeo; Code: 82; Acronym: 'MARCUL'; Desc: 'Marine farm/culture'),
(Sort: ftGeo; Code: 83; Acronym: 'MIPARE'; Desc: 'Military practice area'),
(Sort: ftGeo; Code: 84; Acronym: 'MORFAC'; Desc: 'Mooring/Warping facility'),
(Sort: ftGeo; Code: 85; Acronym: 'NAVLNE'; Desc: 'Navigation line'),
(Sort: ftGeo; Code: 86; Acronym: 'OBSTRN'; Desc: 'Obstruction'),
(Sort: ftGeo; Code: 87; Acronym: 'OFSPLF'; Desc: 'Offshore platform'),
(Sort: ftGeo; Code: 88; Acronym: 'OSPARE'; Desc: 'Offshore production area'),
(Sort: ftGeo; Code: 89; Acronym: 'OILBAR'; Desc: 'Oil barrier'),
(Sort: ftGeo; Code: 90; Acronym: 'PILPNT'; Desc: 'Pile'),
(Sort: ftGeo; Code: 91; Acronym: 'PILBOP'; Desc: 'Pilot boarding place'),
(Sort: ftGeo; Code: 92; Acronym: 'PIPARE'; Desc: 'Pipeline area'),
(Sort: ftGeo; Code: 93; Acronym: 'PIPOHD'; Desc: 'Pipeline, overhead'),
(Sort: ftGeo; Code: 94; Acronym: 'PIPSOL'; Desc: 'Pipeline, submarine/on land'),
(Sort: ftGeo; Code: 95; Acronym: 'PONTON'; Desc: 'Pontoon'),
(Sort: ftGeo; Code: 96; Acronym: 'PRCARE'; Desc: 'Precautionary area'),
(Sort: ftGeo; Code: 97; Acronym: 'PRDARE'; Desc: 'Production/storage area'),
(Sort: ftGeo; Code: 98; Acronym: 'PYLONS'; Desc: 'Pylon/bridge support'),
(Sort: ftGeo; Code: 99; Acronym: 'RADLNE'; Desc: 'Radar line '),
(Sort: ftGeo; Code: 100; Acronym: 'RADRNG'; Desc: 'Radar range'),
(Sort: ftGeo; Code: 101; Acronym: 'RADRFL'; Desc: 'Radar reflector'),
(Sort: ftGeo; Code: 102; Acronym: 'RADSTA'; Desc: 'Radar station'),
(Sort: ftGeo; Code: 103; Acronym: 'RTPBCN'; Desc: 'Radar transponder beacon'),
(Sort: ftGeo; Code: 104; Acronym: 'RDOCAL'; Desc: 'Radio calling-in point'),
(Sort: ftGeo; Code: 105; Acronym: 'RDOSTA'; Desc: 'Radio station'),
(Sort: ftGeo; Code: 106; Acronym: 'RAILWY'; Desc: 'Railway'),
(Sort: ftGeo; Code: 107; Acronym: 'RAPIDS'; Desc: 'Rapids'),
(Sort: ftGeo; Code: 108; Acronym: 'RCRTCL'; Desc: 'Recommended route centerline'),
(Sort: ftGeo; Code: 109; Acronym: 'RECTRC'; Desc: 'Recommended track'),
(Sort: ftGeo; Code: 110; Acronym: 'RCTLPT'; Desc: 'Recommended traffic lane part'),
(Sort: ftGeo; Code: 111; Acronym: 'RSCSTA'; Desc: 'Rescue station'),
(Sort: ftGeo; Code: 112; Acronym: 'RESARE'; Desc: 'Restricted area'),
(Sort: ftGeo; Code: 113; Acronym: 'RETRFL'; Desc: 'Retro-reflector'),
(Sort: ftGeo; Code: 114; Acronym: 'RIVERS'; Desc: 'River'),
(Sort: ftGeo; Code: 115; Acronym: 'RIVBNK'; Desc: 'River bank'),
(Sort: ftGeo; Code: 116; Acronym: 'ROADWY'; Desc: 'Road'),
(Sort: ftGeo; Code: 117; Acronym: 'RUNWAY'; Desc: 'Runway'),
(Sort: ftGeo; Code: 118; Acronym: 'SNDWAV'; Desc: 'Sand waves'),
(Sort: ftGeo; Code: 119; Acronym: 'SEAARE'; Desc: 'Sea area/named water area'),
(Sort: ftGeo; Code: 120; Acronym: 'SPLARE'; Desc: 'Sea-plane landing area'),
(Sort: ftGeo; Code: 121; Acronym: 'SBDARE'; Desc: 'Seabed area'),
(Sort: ftGeo; Code: 122; Acronym: 'SLCONS'; Desc: 'Shoreline construction'),
(Sort: ftGeo; Code: 123; Acronym: 'SISTAT'; Desc: 'Signal station, traffic'),
(Sort: ftGeo; Code: 124; Acronym: 'SISTAW'; Desc: 'Signal station, warning'),
(Sort: ftGeo; Code: 125; Acronym: 'SILTNK'; Desc: 'Silo/tank'),
(Sort: ftGeo; Code: 126; Acronym: 'SLOTOP'; Desc: 'Slope topline'),
(Sort: ftGeo; Code: 127; Acronym: 'SLOGRD'; Desc: 'Sloping ground'),
(Sort: ftGeo; Code: 128; Acronym: 'SMCFAC'; Desc: 'Small craft facility'),
(Sort: ftGeo; Code: 129; Acronym: 'SOUNDG'; Desc: 'Sounding'),
(Sort: ftGeo; Code: 130; Acronym: 'SPRING'; Desc: 'Spring'),
(Sort: ftGeo; Code: 131; Acronym: 'SQUARE'; Desc: 'Square'),
(Sort: ftGeo; Code: 132; Acronym: 'STSLNE'; Desc: 'Straight territorial sea baseline'),
(Sort: ftGeo; Code: 133; Acronym: 'SUBTLN'; Desc: 'Submarine transit lane'),
(Sort: ftGeo; Code: 134; Acronym: 'SWPARE'; Desc: 'Swept Area'),
(Sort: ftGeo; Code: 135; Acronym: 'TESARE'; Desc: 'Territorial sea area'),
(Sort: ftGeo; Code: 136; Acronym: 'TS_PRH'; Desc: 'Tidal stream - harmonic prediction'),
(Sort: ftGeo; Code: 137; Acronym: 'TS_PNH'; Desc: 'Tidal stream - non-harmonic prediction'),
(Sort: ftGeo; Code: 138; Acronym: 'TS_PAD'; Desc: 'Tidal stream panel data'),
(Sort: ftGeo; Code: 139; Acronym: 'TS_TIS'; Desc: 'Tidal stream - time series'),
(Sort: ftGeo; Code: 140; Acronym: 'T_HMON'; Desc: 'Tide - harmonic prediction'),
(Sort: ftGeo; Code: 141; Acronym: 'T_NHMN'; Desc: 'Tide - non-harmonic prediction'),
(Sort: ftGeo; Code: 142; Acronym: 'T_TIMS'; Desc: 'Tide - time series'),
(Sort: ftGeo; Code: 143; Acronym: 'TIDEWY'; Desc: 'Tideway'),
(Sort: ftGeo; Code: 144; Acronym: 'TOPMAR'; Desc: 'Topmark'),
(Sort: ftGeo; Code: 145; Acronym: 'TSELNE'; Desc: 'Traffic separation line'),
(Sort: ftGeo; Code: 146; Acronym: 'TSSBND'; Desc: 'Traffic separation scheme boundary'),
(Sort: ftGeo; Code: 147; Acronym: 'TSSCRS'; Desc: 'Traffic separation scheme crossing'),
(Sort: ftGeo; Code: 148; Acronym: 'TSSLPT'; Desc: 'Traffic separation scheme lane part'),
(Sort: ftGeo; Code: 149; Acronym: 'TSSRON'; Desc: 'Traffic separation scheme roundabout'),
(Sort: ftGeo; Code: 150; Acronym: 'TSEZNE'; Desc: 'Traffic separation zone'),
(Sort: ftGeo; Code: 151; Acronym: 'TUNNEL'; Desc: 'Tunnel'),
(Sort: ftGeo; Code: 152; Acronym: 'TWRTPT'; Desc: 'Two-way route part'),
(Sort: ftGeo; Code: 153; Acronym: 'UWTROC'; Desc: 'Underwater/awash rock'),
(Sort: ftGeo; Code: 154; Acronym: 'UNSARE'; Desc: 'Unsurveyed area'),
(Sort: ftGeo; Code: 155; Acronym: 'VEGATN'; Desc: 'Vegetation'),
(Sort: ftGeo; Code: 156; Acronym: 'WATTUR'; Desc: 'Water turbulence'),
(Sort: ftGeo; Code: 157; Acronym: 'WATFAL'; Desc: 'Waterfall'),
(Sort: ftGeo; Code: 158; Acronym: 'WEDKLP'; Desc: 'Weed/Kelp'),
(Sort: ftGeo; Code: 159; Acronym: 'WRECKS'; Desc: 'Wreck'),
//增补
(Sort: ftGeo; Code: 161; Acronym: 'ARCSLN'; Desc: 'Archipelagic Sea Lane'),
(Sort: ftGeo; Code: 162; Acronym: 'ASLXIS'; Desc: 'Archipelagic Sea Lane axis'),
(Sort: ftGeo; Code: 163; Acronym: 'NEWOBJ'; Desc: 'New object'),
//---




(Sort: ftMeta; Code: 300; Acronym: 'M_ACCY'; Desc: 'Accuracy of data'),
(Sort: ftMeta; Code: 301; Acronym: 'M_CSCL'; Desc: 'Compilation scale of data'),
(Sort: ftMeta; Code: 302; Acronym: 'M_COVR'; Desc: 'Coverage'),
(Sort: ftMeta; Code: 303; Acronym: 'M_HDAT'; Desc: 'Horizontal datum of data'),
(Sort: ftMeta; Code: 304; Acronym: 'M_HOPA'; Desc: 'Horizontal datum shift parameters'),
(Sort: ftMeta; Code: 305; Acronym: 'M_NPUB'; Desc: 'Nautical publication information'),
(Sort: ftMeta; Code: 306; Acronym: 'M_NSYS'; Desc: 'Navigational system of marks'),
(Sort: ftMeta; Code: 307; Acronym: 'M_PROD'; Desc: 'Production information'),
(Sort: ftMeta; Code: 308; Acronym: 'M_QUAL'; Desc: 'Quality of data'),
(Sort: ftMeta; Code: 309; Acronym: 'M_SDAT'; Desc: 'Sounding datum '),
(Sort: ftMeta; Code: 310; Acronym: 'M_SREL'; Desc: 'Survey reliability '),
(Sort: ftMeta; Code: 311; Acronym: 'M_UNIT'; Desc: 'Units of measurement of data '),
(Sort: ftMeta; Code: 312; Acronym: 'M_VDAT'; Desc: 'Vertical datum of data '),

(Sort: ftCollection; Code: 400; Acronym: 'C_AGGR'; Desc: 'Aggregation '),
(Sort: ftCollection; Code: 401; Acronym: 'C_ASSO'; Desc: 'Association '),
(Sort: ftCollection; Code: 402; Acronym: 'C_STAC'; Desc: 'Stacked on/stacked under '),
(Sort: ftCollection; Code: 500; Acronym: '$AREAS'; Desc: 'Cartographic area '),

(Sort: ftCartographic; Code: 501; Acronym: '$LINES'; Desc: 'Cartographic line '),
(Sort: ftCartographic; Code: 502; Acronym: '$CSYMB'; Desc: 'Cartographic symbol'),
(Sort: ftCartographic; Code: 503; Acronym: '$COMPS'; Desc: 'Compass '),
(Sort: ftCartographic; Code: 504; Acronym: '$TEXTS'; Desc: 'Text ')


  );



  c_S57ObjectAttiValue: array[0..192] of TtxS57ObjectAttiName = (
(Sort: otFeatureObject; Code: 1; Acronym: 'AGENCY'; Desc: 'Agency responsible for production'),
(Sort: otFeatureObject; Code: 2; Acronym: 'BCNSHP'; Desc: 'Beacon shape'),
(Sort: otFeatureObject; Code: 3; Acronym: 'BUISHP'; Desc: 'Building shape'),
(Sort: otFeatureObject; Code: 4; Acronym: 'BOYSHP'; Desc: 'Buoy shape'),
(Sort: otFeatureObject; Code: 5; Acronym: 'BURDEP'; Desc: 'Buried depth'),
(Sort: otFeatureObject; Code: 6; Acronym: 'CALSGN'; Desc: 'Call sign'),
(Sort: otFeatureObject; Code: 7; Acronym: 'CATAIR'; Desc: 'Category of airport/airfield'),
(Sort: otFeatureObject; Code: 8; Acronym: 'CATACH'; Desc: 'Category of anchorage'),
(Sort: otFeatureObject; Code: 9; Acronym: 'CATBRG'; Desc: 'Category of bridge'),
(Sort: otFeatureObject; Code: 10; Acronym: 'CATBUA'; Desc: 'Category of built-up area'),
(Sort: otFeatureObject; Code: 11; Acronym: 'CATCBL'; Desc: 'Category of cable'),
(Sort: otFeatureObject; Code: 12; Acronym: 'CATCAN'; Desc: 'Category of canal'),
(Sort: otFeatureObject; Code: 13; Acronym: 'CATCAM'; Desc: 'Category of cardinal mark'),
(Sort: otFeatureObject; Code: 14; Acronym: 'CATCHP'; Desc: 'Category of checkpoint'),
(Sort: otFeatureObject; Code: 15; Acronym: 'CATCOA'; Desc: 'Category of coastline'),
(Sort: otFeatureObject; Code: 16; Acronym: 'CATCTR'; Desc: 'Category of control point'),
(Sort: otFeatureObject; Code: 17; Acronym: 'CATCON'; Desc: 'Category of conveyor'),
(Sort: otFeatureObject; Code: 18; Acronym: 'CATCOV'; Desc: 'Category of coverage'),
(Sort: otFeatureObject; Code: 19; Acronym: 'CATCRN'; Desc: 'Category of crane'),
(Sort: otFeatureObject; Code: 20; Acronym: 'CATDAM'; Desc: 'Category of dam'),
(Sort: otFeatureObject; Code: 21; Acronym: 'CATDIS'; Desc: 'Category of distance mark'),
(Sort: otFeatureObject; Code: 22; Acronym: 'CATDOC'; Desc: 'Category of dock'),
(Sort: otFeatureObject; Code: 23; Acronym: 'CATDPG'; Desc: 'Category of dumping ground'),
(Sort: otFeatureObject; Code: 24; Acronym: 'CATFNC'; Desc: 'Category of fenceline'),
(Sort: otFeatureObject; Code: 25; Acronym: 'CATFRY'; Desc: 'Category of ferry'),
(Sort: otFeatureObject; Code: 26; Acronym: 'CATFIF'; Desc: 'Category of fishing facility'),
(Sort: otFeatureObject; Code: 27; Acronym: 'CATFOG'; Desc: 'Category of fog signal'),
(Sort: otFeatureObject; Code: 28; Acronym: 'CATFOR'; Desc: 'Category of fortified structure'),
(Sort: otFeatureObject; Code: 29; Acronym: 'CATGAT'; Desc: 'Category of gate'),
(Sort: otFeatureObject; Code: 32; Acronym: 'CATICE'; Desc: 'Category of ice'),
(Sort: otFeatureObject; Code: 33; Acronym: 'CATINB'; Desc: 'Category of installation buoy'),
(Sort: otFeatureObject; Code: 34; Acronym: 'CATLND'; Desc: 'Category of land region'),
(Sort: otFeatureObject; Code: 35; Acronym: 'CATLMK'; Desc: 'Category of landmark'),
(Sort: otFeatureObject; Code: 36; Acronym: 'CATLAM'; Desc: 'Category of lateral mark'),
(Sort: otFeatureObject; Code: 37; Acronym: 'CATLIT'; Desc: 'Category of light'),
(Sort: otFeatureObject; Code: 38; Acronym: 'CATMFA'; Desc: 'Category of marine farm/culture'),
(Sort: otFeatureObject; Code: 39; Acronym: 'CATMPA'; Desc: 'Category of military practice area'),
(Sort: otFeatureObject; Code: 40; Acronym: 'CATMOR'; Desc: 'Category of mooring/warping facility'),
(Sort: otFeatureObject; Code: 42; Acronym: 'CATOBS'; Desc: 'Category of obstruction'),
(Sort: otFeatureObject; Code: 43; Acronym: 'CATOFP'; Desc: 'Category of offshore platform'),
(Sort: otFeatureObject; Code: 44; Acronym: 'CATOLB'; Desc: 'Category of oil barrier'),
(Sort: otFeatureObject; Code: 45; Acronym: 'CATPLE'; Desc: 'Category of pile'),
(Sort: otFeatureObject; Code: 46; Acronym: 'CATPIL'; Desc: 'Category of pilot boarding place'),
(Sort: otFeatureObject; Code: 47; Acronym: 'CATPIP'; Desc: 'Category of pipeline/pipe'),
(Sort: otFeatureObject; Code: 48; Acronym: 'CATPRA'; Desc: 'Category of production area'),
(Sort: otFeatureObject; Code: 49; Acronym: 'CATPYL'; Desc: 'Category of pylon'),
(Sort: otFeatureObject; Code: 51; Acronym: 'CATRAS'; Desc: 'Category of radar station'),
(Sort: otFeatureObject; Code: 52; Acronym: 'CATRTB'; Desc: 'Category of radar transponder beacon'),
(Sort: otFeatureObject; Code: 53; Acronym: 'CATROS'; Desc: 'Category of radio station'),
(Sort: otFeatureObject; Code: 54; Acronym: 'CATTRK'; Desc: 'Category of recommended track'),
(Sort: otFeatureObject; Code: 55; Acronym: 'CATRSC'; Desc: 'Category of rescue station'),
(Sort: otFeatureObject; Code: 56; Acronym: 'CATREA'; Desc: 'Category of restricted area'),
(Sort: otFeatureObject; Code: 57; Acronym: 'CATROD'; Desc: 'Category of road'),
(Sort: otFeatureObject; Code: 58; Acronym: 'CATRUN'; Desc: 'Category of runway'),
(Sort: otFeatureObject; Code: 59; Acronym: 'CATSEA'; Desc: 'Category of sea area'),
(Sort: otFeatureObject; Code: 60; Acronym: 'CATSLC'; Desc: 'Category of shoreline construction'),
(Sort: otFeatureObject; Code: 61; Acronym: 'CATSIT'; Desc: 'Category of signal station, traffic'),
(Sort: otFeatureObject; Code: 62; Acronym: 'CATSIW'; Desc: 'Category of signal station, warning'),
(Sort: otFeatureObject; Code: 63; Acronym: 'CATSIL'; Desc: 'Category of silo/tank'),
(Sort: otFeatureObject; Code: 64; Acronym: 'CATSLO'; Desc: 'Category of slope'),
(Sort: otFeatureObject; Code: 65; Acronym: 'CATSCF'; Desc: 'Category of small craft facility'),
(Sort: otFeatureObject; Code: 66; Acronym: 'CATSPM'; Desc: 'Category of special purpose mark'),
(Sort: otFeatureObject; Code: 188; Acronym: 'CAT_TS'; Desc: 'Category of Tidal Stream'),
(Sort: otFeatureObject; Code: 67; Acronym: 'CATTSS'; Desc: 'Category of Traffic Separation Scheme'),
(Sort: otFeatureObject; Code: 68; Acronym: 'CATVEG'; Desc: 'Category of vegetation'),
(Sort: otFeatureObject; Code: 69; Acronym: 'CATWAT'; Desc: 'Category of water turbulence'),
(Sort: otFeatureObject; Code: 70; Acronym: 'CATWED'; Desc: 'Category of weed/kelp'),
(Sort: otFeatureObject; Code: 71; Acronym: 'CATWRK'; Desc: 'Category of wreck'),
(Sort: otFeatureObject; Code: 73; Acronym: '$SPACE'; Desc: 'Character spacing'),
(Sort: otFeatureObject; Code: 74; Acronym: '$CHARS'; Desc: 'Character specification'),
(Sort: otFeatureObject; Code: 75; Acronym: 'COLOUR'; Desc: 'Colour'),
(Sort: otFeatureObject; Code: 76; Acronym: 'COLPAT'; Desc: 'Colour pattern'),
(Sort: otFeatureObject; Code: 77; Acronym: 'COMCHA'; Desc: 'Communication channel'),
(Sort: otFeatureObject; Code: 78; Acronym: '$CSIZE'; Desc: 'Compass size'),
(Sort: otFeatureObject; Code: 79; Acronym: 'CPDATE'; Desc: 'Compilation date'),
(Sort: otFeatureObject; Code: 80; Acronym: 'CSCALE'; Desc: 'Compilation scale'),
(Sort: otFeatureObject; Code: 81; Acronym: 'CONDTN'; Desc: 'Condition'),
(Sort: otFeatureObject; Code: 82; Acronym: 'CONRAD'; Desc: 'Conspicuous, radar'),
(Sort: otFeatureObject; Code: 83; Acronym: 'CONVIS'; Desc: 'Conspicuous, visually'),
(Sort: otFeatureObject; Code: 84; Acronym: 'CURVEL'; Desc: 'Current velocity'),
(Sort: otFeatureObject; Code: 85; Acronym: 'DATEND'; Desc: 'Date end'),
(Sort: otFeatureObject; Code: 86; Acronym: 'DATSTA'; Desc: 'Date start'),
(Sort: otFeatureObject; Code: 87; Acronym: 'DRVAL1'; Desc: 'Depth range value 1'),
(Sort: otFeatureObject; Code: 88; Acronym: 'DRVAL2'; Desc: 'Depth range value 2'),
(Sort: otFeatureObject; Code: 89; Acronym: 'DUNITS'; Desc: 'Depth units'),
(Sort: otFeatureObject; Code: 90; Acronym: 'ELEVAT'; Desc: 'Elevation'),
(Sort: otFeatureObject; Code: 91; Acronym: 'ESTRNG'; Desc: 'Estimated range of transmission'),
(Sort: otFeatureObject; Code: 93; Acronym: 'EXPSOU'; Desc: 'Exposition of sounding'),
(Sort: otFeatureObject; Code: 94; Acronym: 'FUNCTN'; Desc: 'Function'),
(Sort: otFeatureObject; Code: 95; Acronym: 'HEIGHT'; Desc: 'Height'),
(Sort: otFeatureObject; Code: 96; Acronym: 'HUNITS'; Desc: 'Height/length units'),
(Sort: otFeatureObject; Code: 97; Acronym: 'HORACC'; Desc: 'Horizontal accuracy'),
(Sort: otFeatureObject; Code: 98; Acronym: 'HORCLR'; Desc: 'Horizontal clearance'),
(Sort: otFeatureObject; Code: 99; Acronym: 'HORLEN'; Desc: 'Horizontal length'),
(Sort: otFeatureObject; Code: 100; Acronym: 'HORWID'; Desc: 'Horizontal width'),
(Sort: otFeatureObject; Code: 101; Acronym: 'ICEFAC'; Desc: 'Ice factor'),
(Sort: otFeatureObject; Code: 102; Acronym: 'INFORM'; Desc: 'Information'),
(Sort: otFeatureObject; Code: 103; Acronym: 'JRSDTN'; Desc: 'Jurisdiction'),
(Sort: otFeatureObject; Code: 104; Acronym: '$JUSTH'; Desc: 'Justification - horizontal'),
(Sort: otFeatureObject; Code: 105; Acronym: '$JUSTV'; Desc: 'Justification - vertical'),
(Sort: otFeatureObject; Code: 106; Acronym: 'LIFCAP'; Desc: 'Lifting capacity'),
(Sort: otFeatureObject; Code: 107; Acronym: 'LITCHR'; Desc: 'Light characteristic'),
(Sort: otFeatureObject; Code: 108; Acronym: 'LITVIS'; Desc: 'Light visibility'),
(Sort: otFeatureObject; Code: 109; Acronym: 'MARSYS'; Desc: 'Marks navigational - System of'),
(Sort: otFeatureObject; Code: 110; Acronym: 'MLTYLT'; Desc: 'Multiplicity of lights'),
(Sort: otFeatureObject; Code: 111; Acronym: 'NATION'; Desc: 'Nationality'),
(Sort: otFeatureObject; Code: 112; Acronym: 'NATCON'; Desc: 'Nature of construction'),
(Sort: otFeatureObject; Code: 113; Acronym: 'NATSUR'; Desc: 'Nature of surface'),
(Sort: otFeatureObject; Code: 114; Acronym: 'NATQUA'; Desc: 'Nature of surface - qualifying terms'),
(Sort: otFeatureObject; Code: 115; Acronym: 'NMDATE'; Desc: 'Notice to Mariners date'),
(Sort: otFeatureObject; Code: 116; Acronym: 'OBJNAM'; Desc: 'Object name'),
(Sort: otFeatureObject; Code: 117; Acronym: 'ORIENT'; Desc: 'Orientation'),
(Sort: otFeatureObject; Code: 118; Acronym: 'PEREND'; Desc: 'Periodic date end'),
(Sort: otFeatureObject; Code: 119; Acronym: 'PERSTA'; Desc: 'Periodic date start'),
(Sort: otFeatureObject; Code: 120; Acronym: 'PICREP'; Desc: 'Pictorial representation'),
(Sort: otFeatureObject; Code: 121; Acronym: 'PILDST'; Desc: 'Pilot district'),
(Sort: otFeatureObject; Code: 189; Acronym: 'PUNITS'; Desc: 'Positional accuracy units'),
(Sort: otFeatureObject; Code: 122; Acronym: 'PRCTRY'; Desc: 'Producing country'),
(Sort: otFeatureObject; Code: 123; Acronym: 'PRODCT'; Desc: 'Product'),
(Sort: otFeatureObject; Code: 124; Acronym: 'PUBREF'; Desc: 'Publication reference'),
(Sort: otFeatureObject; Code: 125; Acronym: 'QUASOU'; Desc: 'Quality of sounding measurement'),
(Sort: otFeatureObject; Code: 126; Acronym: 'RADWAL'; Desc: 'Radar wave length'),
(Sort: otFeatureObject; Code: 127; Acronym: 'RADIUS'; Desc: 'Radius'),
(Sort: otFeatureObject; Code: 128; Acronym: 'RECDAT'; Desc: 'Recording date'),
(Sort: otFeatureObject; Code: 129; Acronym: 'RECIND'; Desc: 'Recording indication'),
(Sort: otFeatureObject; Code: 130; Acronym: 'RYRMGV'; Desc: 'Reference year for magnetic variation'),
(Sort: otFeatureObject; Code: 131; Acronym: 'RESTRN'; Desc: 'Restriction'),
(Sort: otFeatureObject; Code: 132; Acronym: 'SCAMAX'; Desc: 'Scale maximum'),
(Sort: otFeatureObject; Code: 133; Acronym: 'SCAMIN'; Desc: 'Scale minimum'),
(Sort: otFeatureObject; Code: 134; Acronym: 'SCVAL1'; Desc: 'Scale value one'),
(Sort: otFeatureObject; Code: 135; Acronym: 'SCVAL2'; Desc: 'Scale value two'),
(Sort: otFeatureObject; Code: 136; Acronym: 'SECTR1'; Desc: 'Sector limit one'),
(Sort: otFeatureObject; Code: 137; Acronym: 'SECTR2'; Desc: 'Sector limit two'),
(Sort: otFeatureObject; Code: 138; Acronym: 'SHIPAM'; Desc: 'Shift parameters'),
(Sort: otFeatureObject; Code: 139; Acronym: 'SIGFRQ'; Desc: 'Signal frequency'),
(Sort: otFeatureObject; Code: 140; Acronym: 'SIGGEN'; Desc: 'Signal generation'),
(Sort: otFeatureObject; Code: 141; Acronym: 'SIGGRP'; Desc: 'Signal group'),
(Sort: otFeatureObject; Code: 142; Acronym: 'SIGPER'; Desc: 'Signal period'),
(Sort: otFeatureObject; Code: 143; Acronym: 'SIGSEQ'; Desc: 'Signal sequence'),
(Sort: otFeatureObject; Code: 144; Acronym: 'SOUACC'; Desc: 'Sounding accuracy'),
(Sort: otFeatureObject; Code: 145; Acronym: 'SDISMX'; Desc: 'Sounding distance - maximum'),
(Sort: otFeatureObject; Code: 146; Acronym: 'SDISMN'; Desc: 'Sounding distance - minimum'),
(Sort: otFeatureObject; Code: 147; Acronym: 'SORDAT'; Desc: 'Source date'),
(Sort: otFeatureObject; Code: 148; Acronym: 'SORIND'; Desc: 'Source indication'),
(Sort: otFeatureObject; Code: 149; Acronym: 'STATUS'; Desc: 'Status'),
(Sort: otFeatureObject; Code: 151; Acronym: 'SUREND'; Desc: 'Survey date - end'),
(Sort: otFeatureObject; Code: 152; Acronym: 'SURSTA'; Desc: 'Survey date - start'),
(Sort: otFeatureObject; Code: 153; Acronym: 'SURTYP'; Desc: 'Survey type'),
(Sort: otFeatureObject; Code: 154; Acronym: '$SCALE'; Desc: 'Symbol scaling factor'),
(Sort: otFeatureObject; Code: 155; Acronym: '$SCODE'; Desc: 'Symbolization code'),
(Sort: otFeatureObject; Code: 156; Acronym: 'TECSOU'; Desc: 'Technique of sounding measurement'),
(Sort: otFeatureObject; Code: 157; Acronym: '$TXSTR'; Desc: 'Text string'),
(Sort: otFeatureObject; Code: 158; Acronym: 'TXTDSC'; Desc: 'Textual description'),
(Sort: otFeatureObject; Code: 159; Acronym: 'TS_TSP'; Desc: 'Tidal stream - panel values'),
(Sort: otFeatureObject; Code: 160; Acronym: 'TS_TSV'; Desc: 'Tidal stream - time series values'),
(Sort: otFeatureObject; Code: 161; Acronym: 'T_ACWL'; Desc: 'Tide - accuracy of water level'),
(Sort: otFeatureObject; Code: 162; Acronym: 'T_HWLW'; Desc: 'Tide - high and low water values'),
(Sort: otFeatureObject; Code: 163; Acronym: 'T_MTOD'; Desc: 'Tide - method of tidal prediction'),
(Sort: otFeatureObject; Code: 164; Acronym: 'T_THDF'; Desc: 'Tide - time and height differences'),
(Sort: otFeatureObject; Code: 166; Acronym: 'T_TSVL'; Desc: 'Tide - time series values'),
(Sort: otFeatureObject; Code: 167; Acronym: 'T_VAHC'; Desc: 'Tide - value of harmonic constituents'),
(Sort: otFeatureObject; Code: 165; Acronym: 'T_TINT'; Desc: 'Tide - time interval of values'),
(Sort: otFeatureObject; Code: 168; Acronym: 'TIMEND'; Desc: 'Time end'),
(Sort: otFeatureObject; Code: 169; Acronym: 'TIMSTA'; Desc: 'Time start'),
(Sort: otFeatureObject; Code: 170; Acronym: '$TINTS'; Desc: 'Tint'),
(Sort: otFeatureObject; Code: 171; Acronym: 'TOPSHP'; Desc: 'Topmark/daymark shape'),
(Sort: otFeatureObject; Code: 172; Acronym: 'TRAFIC'; Desc: 'Traffic flow'),
(Sort: otFeatureObject; Code: 173; Acronym: 'VALACM'; Desc: 'Value of annual change in magnetic variation'),
(Sort: otFeatureObject; Code: 174; Acronym: 'VALDCO'; Desc: 'Value of depth contour'),
(Sort: otFeatureObject; Code: 175; Acronym: 'VALLMA'; Desc: 'Value of local magnetic anomaly'),
(Sort: otFeatureObject; Code: 176; Acronym: 'VALMAG'; Desc: 'Value of magnetic variation'),
(Sort: otFeatureObject; Code: 177; Acronym: 'VALMXR'; Desc: 'Value of maximum range'),
(Sort: otFeatureObject; Code: 178; Acronym: 'VALNMR'; Desc: 'Value of nominal range'),
(Sort: otFeatureObject; Code: 179; Acronym: 'VALSOU'; Desc: 'Value of sounding'),
(Sort: otFeatureObject; Code: 180; Acronym: 'VERACC'; Desc: 'Vertical accuracy'),
(Sort: otFeatureObject; Code: 181; Acronym: 'VERCLR'; Desc: 'Vertical clearance'),
(Sort: otFeatureObject; Code: 182; Acronym: 'VERCCL'; Desc: 'Vertical clearance, closed'),
(Sort: otFeatureObject; Code: 183; Acronym: 'VERCOP'; Desc: 'Vertical clearance, open'),
(Sort: otFeatureObject; Code: 184; Acronym: 'VERCSA'; Desc: 'Vertical clearance, safe'),
(Sort: otFeatureObject; Code: 185; Acronym: 'VERDAT'; Desc: 'Vertical datum'),
(Sort: otFeatureObject; Code: 186; Acronym: 'VERLEN'; Desc: 'Vertical length'),
(Sort: otFeatureObject; Code: 187; Acronym: 'WATLEV'; Desc: 'Water level effect'),


 { TODO : 后补充，之前没有定义 }
(Sort: otFeatureObject; Code: 190; Acronym: 'CLSDEF'; Desc: 'Object class definition'),
(Sort: otFeatureObject; Code: 191; Acronym: 'CLSNAM'; Desc: 'Object class name'),
(Sort: otFeatureObject; Code: 912; Acronym: 'SYMINS'; Desc: 'Symbol instruction'),
//----------------------

(Sort: otNationalLanguage; Code: 300; Acronym: 'NINFOM'; Desc: 'Information in national language'),
(Sort: otNationalLanguage; Code: 301; Acronym: 'NOBJNM'; Desc: 'Object name in national language'),
(Sort: otNationalLanguage; Code: 302; Acronym: 'NPLDST'; Desc: 'Pilot district in national language'),
(Sort: otNationalLanguage; Code: 303; Acronym: '$NTXST'; Desc: 'Text string in national language'),
(Sort: otNationalLanguage; Code: 304; Acronym: 'NTXTDS'; Desc: 'Textual description in national language'),

(Sort: otSpatialAndMetaObject; Code: 400; Acronym: 'HORDAT'; Desc: 'Horizontal datum'),
(Sort: otSpatialAndMetaObject; Code: 401; Acronym: 'POSACC'; Desc: 'Positional Accuracy'),
(Sort: otSpatialAndMetaObject; Code: 402; Acronym: 'QUAPOS'; Desc: 'Quality of position')




  );

var
  S57Res: TtxS57Resource;

function GetS57ResObjectFeatureValue(ACode: Integer): TtxS57ObjectFeatureValue;
function GetS57ObjectAtti(ACode: Integer): TtxS57ObjectAttiName;

implementation
//{$R txS57ResAtti.res}
// {$R txS57Res.dres}

function GetS57ResObjectFeatureValue(ACode: Integer): TtxS57ObjectFeatureValue;
var
  i: Integer;
begin
  for i := 0 to Length(c_S57ObjectFeatureValue) - 1 do
  begin
    if ACode = c_S57ObjectFeatureValue[i].Code then
    begin
      Result := c_S57ObjectFeatureValue[i];
      Exit;
    end;
  end;

  Result.Code := 0;
end;

function GetS57ObjectAtti(ACode: Integer): TtxS57ObjectAttiName;
var
  i: Integer;
begin
  for i := 0 to Length(c_S57ObjectAttiValue) - 1 do
  begin
    if ACode = c_S57ObjectAttiValue[i].Code then
    begin
      Result := c_S57ObjectAttiValue[i];
      Exit;
    end;
  end;

  Result.Code := 0;
end;


{
******************************* TtxS57resAtti *******************************
}
constructor TtxS57resAtti.Create;
begin
  inherited Create;
  FEnums := TObjectList<TtxS57resAttiValueEnum>.Create;
end;

destructor TtxS57resAtti.Destroy;
begin
  FEnums.Free;
  inherited Destroy;
end;

function TtxS57resAtti.GetMnum(AIndex: Integer): TtxS57resAttiValueEnum;
var
  i: Integer;
begin
  Result := nil;
  for i := 0 to FEnums.Count - 1 do
  begin
    if AIndex = FEnums[i].Code then
    begin
      Result := FEnums[i];
      Exit;
    end;
  end;

end;

function TtxS57resAtti.GetMnumsValue(AIndexes: string): string;
var
  _lst: TStrings;
  i: Integer;
  _Enum: TtxS57resAttiValueEnum;
begin
  Result := '';
  _lst := TStringList.Create;
  try
    ExtractStrings([','], [], PChar(AIndexes), _lst);

    for i := 0 to _lst.Count - 1 do
    begin
      _Enum := GetMnum(StrToInt(_lst[i]));
      if _Enum <> nil then
      begin
        if i = 0 then
          Result := _Enum.Desc
        else
          Result := Result + ',' + _Enum.Desc;
      end;
    end;
  finally
    _lst.Free;
  end;
end;

{
****************************** TtxS57resAtties ******************************
}
{
*************************** TtxS57resObjectAtties ***************************
}
{
****************************** TtxS57resObject ******************************
}
constructor TtxS57resObject.Create;
begin
  inherited Create;
  FAttribute_A :=  TObjectList<TtxS57resObjectAtti>.Create;
  FAttribute_B :=  TObjectList<TtxS57resObjectAtti>.Create;
  FAttribute_C :=  TObjectList<TtxS57resObjectAtti>.Create;
end;

destructor TtxS57resObject.Destroy;
begin
  FAttribute_C.Free;
  FAttribute_B.Free;
  FAttribute_A.Free;
  inherited Destroy;
end;

{
***************************** TtxS57resObjects ******************************
}
{
****************************** TtxS57Resource *******************************
}
constructor TtxS57Resource.Create;
begin
  inherited Create;
  FS57Atties := TObjectList<TtxS57resAtti>.Create;
  FS57Objects := TObjectList<TtxS57resObject>.Create;
  LoadAttiRes;
  LoadObejctRes;
  LinkAtti;
end;

destructor TtxS57Resource.Destroy;
begin
  FS57Objects.Free;
  FS57Atties.Free;
  inherited Destroy;
end;

function TtxS57Resource.getAtti(ACode: Integer): TtxS57resAtti;
var
  i: Integer;
begin
  Result := nil;
  for i := 0 to FS57Atties.Count - 1 do
  begin
    if FS57Atties[i].Code = ACode then
    begin
      Result := FS57Atties[i];
      Exit;
    end;
  end;
end;

function TtxS57Resource.GetResAtti(AAcronym: string): TtxS57resAtti;
var
  i: Integer;
begin
  Result := nil;
  for i := 0 to FS57Atties.Count - 1 do
  begin
    if FS57Atties[i].Acronym = AAcronym then
    begin
      Result := FS57Atties[i];
      Exit;
    end;
  end;
end;

function TtxS57Resource.IsIntersection(a, b: TArray<integer>): boolean;
var
  _a, _b: integer;
begin
  //是否是交集
  for _a in a do
  begin
    for _b in b do
    begin
      if _a = _b then
      begin
         Result := true;
         Exit;
      end;
    end;
  end;
  Result := false;
end;

function TtxS57Resource.findObj(AOBJL: Integer): TtxS57resObject;
var
  i: Integer;
begin
  Result := nil;
  for i := 0 to FS57Objects.Count - 1 do
  begin
    if FS57Objects[i].Code = AOBJL then
    begin
      Result := FS57Objects[i];
      Exit;
    end;
  end;
end;

procedure TtxS57Resource.LinkAtti;
var
  i: Integer;
  j: Integer;
begin
  for i := 0 to FS57Objects.Count - 1 do
  begin
    for j := 0 to FS57Objects[i].Attribute_A.Count - 1 do
    begin
      FS57Objects[i].Attribute_A[j].S57Atti := GetResAtti((FS57Objects[i].Attribute_A[j].Acronym));
      if FS57Objects[i].Attribute_A[j].S57Atti = nil then
        Raise Exception.Create('Attribute_A Not Find Attribute!' + FS57Objects[i].Attribute_A[j].Acronym);

    end;

    for j := 0 to FS57Objects[i].Attribute_B.Count - 1 do
    begin
      FS57Objects[i].Attribute_B[j].S57Atti := GetResAtti((FS57Objects[i].Attribute_B[j].Acronym));
      if FS57Objects[i].Attribute_B[j].S57Atti = nil then
        Raise Exception.Create('Attribute_B Not Find Attribute!' + FS57Objects[i].Attribute_B[j].Acronym);
    end;

    for j := 0 to FS57Objects[i].Attribute_C.Count - 1 do
    begin
      FS57Objects[i].Attribute_C[j].S57Atti := GetResAtti((FS57Objects[i].Attribute_C[j].Acronym));
      if FS57Objects[i].Attribute_C[j].S57Atti = nil then
        Raise Exception.Create('Attribute_C Not Find Attribute!' + FS57Objects[i].Attribute_C[j].Acronym);
    end;

  end;

end;

procedure TtxS57Resource.LoadAttiRes;
var
  _ResStream: TResourceStream;
  buf: TBytes;
  sbuf: string;
begin
//  _ResStream := TResourceStream.Create(HInstance, 'S057Atti', PChar('TXT'));  只是window平台采用
  _ResStream := TResourceStream.Create(HInstance, 'S57Atti', RT_RCDATA);
  try
    SetLength(buf, _ResStream.Size);
    _ResStream.Read(buf, _ResStream.Size);
    sbuf := TEncoding.ASCII.GetString(buf);
    FlstS57Res := sbuf.Split([#13#10]);
  finally
    _ResStream.Free;
  end;

  ParseAtti;
end;

procedure TtxS57Resource.LoadObejctRes;
var
  _ResStream: TResourceStream;
  buf: TBytes;
  sbuf: string;
begin
//  _ResStream := TResourceStream.Create(HInstance, 'S57OBJECT', PChar('TXT'));
  _ResStream := TResourceStream.Create(HInstance, 'S57OBJ', RT_RCDATA);
  try
    SetLength(buf, _ResStream.Size);
    _ResStream.Read(buf, _ResStream.Size);
    sbuf := TEncoding.ASCII.GetString(buf);
    FlstS57Res := sbuf.Split([#13#10]);
  finally
    _ResStream.Free;
  end;

  ParseObejct;
end;

procedure TtxS57Resource.ParseAtti;
var
  iIndex, iNum: Integer;
  _resAtti: TtxS57resAtti;

  function GetEndIndex(start: integer): integer;
  var
    i: integer;
  begin
    for i := start + 1 to Length(FlstS57Res) - 1 do
    begin
      if Pos('>', FlstS57Res[i]) = 1 then
      begin
        Result := i;
        Exit;
      end;
    end;
    Raise Exception.Create('Error S57Attribute Foramt!');
  end;

  function GetDesc(start: integer): string;
  var
    i: integer;
  begin
    for i := start to Length(FlstS57Res) - 1 do
    begin
      if Pos('Attribute:', FlstS57Res[i]) = 1 then
      begin
        Result := Trim(StringReplace(FlstS57Res[i], 'Attribute:', '', []));
        Exit;
      end;
    end;
    Raise Exception.Create('Error S57Attribute Foramt!');

  end;

  function GetAttiType(start: integer): TtxS57ObjectAttiType;
  var
    i: integer;
    sAtti: char;
  begin
    Result := atNone;
    for i := start to Length(FlstS57Res) - 1 do
    begin
      if Pos('Attribute type: ', FlstS57Res[i]) = 1 then
      begin
        sAtti := Trim(StringReplace(FlstS57Res[i], 'Attribute type: ', '', []))[1];
        case sAtti of
          'A', 'S': Result := atString;
          'F'     : Result := atFolat;
          'E'     : Result := atEmnu;
          'L'     : Result := atList;
          'I'     : Result := atInteger;
          'B'     : Result := atFolat;
          else
            Raise Exception.CreateFmt('not find attitype %s', [FlstS57Res[i]]);
        end;
        Exit;
      end;
    end;
    Raise Exception.Create('Error S57Attribute Foramt!');

  end;


  function GetAcronym(start: integer): string;
  var
    i: integer;
  begin
    for i := start to Length(FlstS57Res) - 1 do
    begin
      if Pos('Acronym:', FlstS57Res[i]) = 1 then
      begin
        Result := Trim(StringReplace(FlstS57Res[i], 'Acronym:', '', []));
        Exit;
      end;
    end;
    Raise Exception.Create('Error S57Attribute Foramt!');

  end;

  function GetCode(start: integer): integer;
  var
    i: integer;
  begin
    for i := start to Length(FlstS57Res) - 1 do
    begin
      if Pos('Code:', FlstS57Res[i]) = 1 then
      begin
        Result := StrToInt(Trim(StringReplace(FlstS57Res[i], 'Code:', '', [])));
        Exit;
      end;
    end;
    Raise Exception.Create('Error S57Attribute Foramt!');

  end;


  procedure GetenumValue(start: integer);
  var
    i, ioffce: integer;
    _enum: TtxS57resAttiValueEnum;
  begin
    _resAtti.ListTyles := [];
    for i := start to Length(FlstS57Res) - 1 do
    begin
      if Pos('enum end', FlstS57Res[i]) = 1 then
      begin
        Exit;
      end;
      if Pos('>', FlstS57Res[i]) = 1 then
      begin
        Exit;
      end;
      ioffce := Pos(' : ', FlstS57Res[i]);
      if ioffce > 1 then
      begin
        _enum := TtxS57resAttiValueEnum.Create;
        _resAtti.Enums.Add(_enum);
        _enum.Code := StrToInt(Copy(FlstS57Res[i], 1, ioffce - 1));
        _enum.Desc := trim(Copy(FlstS57Res[i], ioffce + Length(' : '), MaxInt));

        if _resAtti.AttiType = atList then
          _resAtti.ListTyles := _resAtti.ListTyles + [_enum.Code];

      end;
    end;
    Raise Exception.Create('Error S57Attribute Foramt!');

  end;

begin
  FS57Atties.Clear;
  iNum := 2;
  while Length(FlstS57Res) > iNum do
  begin
    _resAtti := TtxS57resAtti.Create;
    _resAtti.Acronym := GetAcronym(iNum);

    _resAtti.Code := GetCode(iNum);
    _resAtti.AttiType := GetAttiType(iNum);
    _resAtti.Desc := GetDesc(iNum);
    FS57Atties.Add(_resAtti);
    GetenumValue(iNum);
    iNum := GetEndIndex(iNum);
    if Length(FlstS57Res) - iNum <= 4 then break; //剩下的几行

  end;

end;

procedure TtxS57Resource.ParseObejct;
var
  iCount, iIndex, iNum: Integer;
  _lst: TStrings;
  _resObejct: TtxS57resObject;

  function GetEndIndex(start: integer): integer;
  var
    i: integer;
  begin
    for i := start + 1 to Length(FlstS57Res) - 1 do
    begin
      if Pos('>', FlstS57Res[i]) = 1 then
      begin
        Result := i;
        Exit;
      end;
    end;
    Raise Exception.Create('Error S57Attribute Foramt!');
  end;

  function GetDesc(start: integer): string;
  var
    i: integer;
  begin
    for i := start to Length(FlstS57Res) - 1 do
    begin
      if Pos('Object Class:', FlstS57Res[i]) = 1 then
      begin
        Result := Trim(StringReplace(FlstS57Res[i], 'Object Class:', '', []));
        Exit;
      end;
    end;
    Raise Exception.Create('Error S57Attribute Foramt!');

  end;



  function GetAcronym(start: integer): string;
  var
    i: integer;
  begin
    for i := start to Length(FlstS57Res) - 1 do
    begin
      if Pos('Acronym:', FlstS57Res[i]) = 1 then
      begin
        Result := Trim(StringReplace(FlstS57Res[i], 'Acronym:', '', []));
        Exit;
      end;
    end;
    Raise Exception.Create('Error S57Attribute Foramt!');

  end;

  function GetCode(start: integer): integer;
  var
    i: integer;
  begin
    for i := start to Length(FlstS57Res) - 1 do
    begin
      if Pos('Code:', FlstS57Res[i]) = 1 then
      begin
        Result := StrToInt(Trim(StringReplace(FlstS57Res[i], 'Code:', '', [])));
        Exit;
      end;
    end;
    Raise Exception.Create('Error S57Attribute Foramt!');

  end;



  procedure GetAttis(start: integer; AHead: string);
  var
    i, j: integer;
    sData: string;
    _ObjectAtti: TtxS57resObjectAtti;
  begin


      for i := start to Length(FlstS57Res) - 1 do
      begin
        if Pos('>', FlstS57Res[i]) = 1 then Exit;
        if Pos(AHead,  FlstS57Res[i]) = 1 then
        begin
          sData := Trim(StringReplace(FlstS57Res[i], AHead, '', []));
          _lst.Clear;
          ExtractStrings([';'], [], PChar(sData), _lst);
          for j := 0 to _lst.Count - 1 do
          begin
            if AHead = 'Set Attribute_A:' then
            begin
              _ObjectAtti := TtxS57resObjectAtti.Create;
              _resObejct.Attribute_A.Add(_ObjectAtti);
            end;
            if AHead = 'Set Attribute_B:' then
            begin
               _ObjectAtti := TtxS57resObjectAtti.Create;
              _resObejct.Attribute_B.Add(_ObjectAtti);
            end;
            if AHead = 'Set Attribute_C:' then
            begin
              _ObjectAtti := TtxS57resObjectAtti.Create;
              _resObejct.Attribute_C.Add(_ObjectAtti);
            end;
            _ObjectAtti.Acronym := Trim(_lst[j]);
          end;
          Exit;

        end;
      end;
      Raise Exception.Create('Error S57Attribute Foramt!');

  end;

begin
  _lst := TStringList.Create;
  try
    FS57Objects.Clear;
    iNum := 2;
    while Length(FlstS57Res) > iNum do
    begin
      _resObejct := TtxS57resObject.Create;
      _resObejct.Acronym := GetAcronym(iNum);
      _resObejct.Code := GetCode(iNum);
      _resObejct.Desc := GetDesc(iNum);
      _resObejct.FFeatureType := GetS57ResObjectFeatureValue(_resObejct.Code).Sort;
      FS57Objects.Add(_resObejct);
      GetAttis(iNum, 'Set Attribute_A:');
      GetAttis(iNum, 'Set Attribute_B:');
      GetAttis(iNum, 'Set Attribute_C:');
      iNum := GetEndIndex(iNum);

      if Length(FlstS57Res) - iNum <= 4 then  break;

    end;
  finally
    _lst.Free;
  end;

end;

function TtxS57Resource.StrToListType(str: string): TArray<integer>;
var
  i: integer;
  strs: TArray<string>;
begin
  if str = '' then
  begin
    Result := nil;
    Exit;
  end;
  strs := str.Split([',']);
  SetLength(Result, Length(strs));
  for i := 0 to Length(strs) - 1 do
    Result[i] := StrToInt(strs[i]);
end;

initialization
  S57Res := TtxS57Resource.Create;
finalization
  S57Res.Free;

end.

