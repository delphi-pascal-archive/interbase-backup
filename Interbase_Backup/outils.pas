{
bonjour tm ce fichier source contient un enseble de fonction tres utiles
e_mail : abdelali_l@yahoo.com
}

unit outils;

interface

uses  Shellapi , StrUtils,JvDBLookup,DBCtrls,JvValidateEdit,
  Dialogs,Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Messages,Buttons, Db, IBCustomDataSet, IBQuery, ExtCtrls, Grids, DBGrids ,
  QuickRpt, Qrctrls, Variants,  Registry , printers ,IniFiles,WinSvc , DBTables,
  math ,ActiveX,ShlObj ;

type
  TWindowsVersion = (twvUnknow, twvWin31, twvWin951, twvWin952, tWvWin981,
                     tWvWin982, tWvWinme, tWvWin9x, tWvWinnt35, tWvWinnt4,
                     tWvWin2k, tWvWinxp, tWvWinnt);

  TDndExportFormat = (dndexp_TXT, dndexp_DB, dndexp_HTML);
function WindowsVersion:string; //TWindowsVersion;
function GetSysDirectory : string;
function GetIBRootDir: string;
function IsNT : boolean;
function IsAdmin: Boolean;
function ServiceCreate(sMachine, sService, sDisplayName, sBinFile : string; StartType : integer) : boolean;
function ServiceDelete(sMachine, sService : string) : boolean;
function ServiceStart(sMachine, sService : string ) : boolean;
function ServiceStop(sMachine, sService : string ) : boolean;
function GetInterbaseGuardianFile : String;
function InterbaseRunning : boolean;
function ShutDownInterbase : boolean;
function StartInterbase : boolean;
function InterbaseInstalled : boolean;
function Exememo(xnom , classexnom  : pchar ) : boolean;
  procedure Bouge(xcomp:TControl;FinX:Integer;FinY:Integer;FinW:Integer;FinH:Integer;Temps:Integer);
  procedure Enter(Sender: TControl; var Key: Char);
  function  convrsion( a00 : Real) : string  ;
  FUNCTION  Lettres( valeur : integer ) : string ;
  function  myhint( vexp: string ) : string ;
  function  BDEexist (var xpath : string) : boolean ;
  Function Complete_var( Xvaleur_initial ,Xvaleur_remplisage : string ;xlengeur : integer ;xsance :string) : string ;
  procedure Transfer_Table(xdbgrid :TDBGrid ;  xdataset1,  xdataset2 : TTable ;
              xtype : TTableType ; xname : string ; xSauvgarde :TSaveDialog  );
//  procedure Transfer_Html(xdbgrid :TDBGrid ; xname : string ;
//               xSauvgarde : TSaveDialog ; xlmdstar : TLMDStarter);
procedure Transfer_Html(xname : String ;xSauvgarde : TSaveDialog );
 procedure Transfer_csv( xname : string ; xSauvgarde : TSaveDialog );
 procedure Transfer_TEXT( xname : string ; xSauvgarde : TSaveDialog );


 function cherche_reg(  xxRootkey : Cardinal ;xxValue , xxKey : String  ) : String   ;
function ajouter_reg(  xxRootkey : Cardinal ;xxValue , xxKey ,xvaleur : String  ) : Boolean   ;
 procedure cree_lnk( edCible , Fichier_lnk  : String ; ico_index : integer );
  function  LerFichIni(FichIni:String; Section: String; rubrique: String): AnsiString;
  procedure EscreverFichIni(FichIni:String; Section: String; rubrique: String; NovoValor: AnsiString);
  Procedure Liste_imprimantes(var xval : TStringList ) ;
  procedure changer_impremant_defaults(Imprimant: String);
  procedure duplique_fichier( fichier_source , fichier_new : string );
  function  strtofieldtype (xtype : integer ) : TFieldType ;
procedure DataSetPreviewPrint(AOwner : TComponent; MakePreview : boolean;
  ReportTitle : string; ADataSet : TDataset;
  PageOrientation : TPrinterOrientation);
procedure DataSetPreview(AOwner : TComponent; ReportTitle : string;
  ADataSet : TDataset; PageOrientation : TPrinterOrientation);
procedure DataSetPrint(AOwner : TComponent; ReportTitle : string;
  ADataSet : TDataset; PageOrientation : TPrinterOrientation);
procedure StringGridPreviewPrint(AOwner : TComponent; StringGrid : TStringGrid;
  Preview : boolean; ReportTitle : string;
  PageOrientation : TPrinterOrientation);
function StringGridExport(StringGrid : TStringGrid;
  FileFormat : TDndExportFormat; FileName : string) : boolean;
function ExportDBToFile(Tbl : TDataSet; FileFormat : TDndExportFormat;
  FileName : string; const Tous : boolean = false) : boolean;
procedure changer_coleur_zone_edit(xpanel  : TCustomPanel ; xcouleur : TColor ) ;
function get_cpu_speed:dword;
procedure lancer_interbase(Sender: TObject);
procedure afichier_date_taill_fichier(var xfile , xdate,xtaille ,xtypetaille: string  );
function non_aroundi(  xreal_vale : Currency ;xleng : integer ) : Currency ;
function oui_aroundi(  xreal_vale : Currency  ) : Currency ;
function nbr_jours(CONST  xdate_du , xdate_au : TDateTime ; xtype_jours ,xjour_f_1,xjour_f_2: String ) : Integer ;
function extrair_ico(var xfile : string  ) : TIcon ;
procedure edit_cherche_dans_table(xedit : TEdit ;
                      xdataset : TDataSet ; xchamp: string ; xcolor :TColor  );
procedure crer_fields_type(VAR xField : TField ; xtype : TFieldType  ; xtable : TComponent ) ;
procedure crer_fields_type_float(VAR xField : TFloatField ; xtable : TComponent ) ;
procedure crer_fields_type_integer(VAR xField : TintegerField ; xtable : TComponent ) ;
var
  CountReportPreview : integer = 0;
type
  TPrntDataSet = class(TComponent)
  private
    FQuickRep : TQuickRep;
    FDataset: TDataSet;
    FLstFields : TList;
    FString: string;
    FOrientation: TPrinterOrientation;
    procedure CreerReport;
    procedure QuickRepNeedData(Sender: TObject; var MoreData: Boolean);
    procedure CreerChamps;
    procedure AjouterChamp(i : integer; var x : extended; mw, w : extended);
    procedure Prepare(Tbl: TDataSet);
    procedure QRepPreview(Sender: TObject);
  protected
  public
    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;
    procedure Preview(Tbl : TDataSet);
    procedure Print(Tbl : TDataSet);

  published
    property DataSet : TDataSet read FDataset write FDataSet;
    property Title : string read FString write FString;
    property Orientation : TPrinterOrientation read FOrientation write FOrientation;
  end;

var
xcle ,Xversion ,  XChemin , xnomexe , xcheminexport : string ;
implementation
uses dbclient , DateUtils;

const
  //L'identificateur de l'interface IPersistFile
  CLSIDPFile: TGUID = '{0000010B-0000-0000-C000-000000000046}';

const  SECURITY_NT_AUTHORITY: TSIDIdentifierAuthority = (Value: (0, 0, 0, 0, 0, 5));
       SECURITY_BUILTIN_DOMAIN_RID = $00000020;
       DOMAIN_ALIAS_RID_ADMINS     = $00000220;
       ENGINE_ID            = 1;
       INDEX_SERVER_ID      = 2;
       STOP_LISTS_ID        = 21;
       NEUTRAL_STOP_LIST_ID = 211;
       ENGLISH_STOP_LIST_ID = 212;
       MORPHOLOGY_ID        = 3;
       SOUNDEX_ID           = 4;
       THESAURUS_ID         = 5;
       THES_PROJ_ID         = 51;
       THES_DIC_ID          = 52;
       LOGIN_ID             = 6;
       FILTER_ID            = 7;
       THES_DIC_OFFSET      = 10000;

procedure Enter(Sender: TControl; var Key: Char);
var
  FEditTemp : TCustomForm;
begin
  if (Key = #13) then   // Enter
    begin
      FEditTemp := GetParentForm(Sender);
      SendMessage(FEditTemp.Handle, WM_NEXTDLGCTL, 0, 0);
      Key := #0;
    end;
end;

function convrsion( a00 : real ): string ;
var   valcar ,centimescar : string ;
     centimes ,temp : integer  ;
     centimes0 : real  ;
     a0 : currency ;
begin
a0 := a00 ;
//temp := 0 ;
IF a0 < 0 then   valcar := 'C''est un nombre negative' ;
IF a0 = 0  then  valcar :='Zero Dinar' ;
centimes0 := frac(a0) ;
centimescar :=CurrToStr( centimes0) +'0'  ;
if Length(centimescar) >=3 then centimescar := copy(centimescar,3,2) ;
integer(centimes) := StrToInt( centimescar );
a0 := INT(a0) ;
valcar := '' ;
if a0 >=1000000000000 then
        begin
        temp   :=   trunc( a0 / 1000000000000 ) ;
                         valcar := valcar + Lettres(temp)+ ' Mille Milliards ';
        a0:= a0 - (temp * 1000000000000);
        end;

if a0 >=1000000000 then
        begin
        temp   := trunc( a0 / 1000000000 ) ;
        if temp = 1 then valcar := valcar + 'Un Milliards '
                    else valcar := valcar + Lettres(temp)+ ' Milliards ';
        a0:= a0 - (temp * 1000000000);
        end;

if a0 >=1000000 then
        begin
        temp   := trunc( a0 / 1000000 ) ;
        if temp = 1 then valcar := valcar + 'Un Millions '
                    else valcar := valcar + Lettres(temp)+ ' Millions ';
        a0:= a0 - (temp * 1000000);
        end;

if a0 >=1000 then
        begin
        temp   := trunc( a0 / 1000 ) ;
        valcar := valcar + Lettres(temp)+ ' Mille ';
        a0:= a0 - (temp * 1000);
        end;
if a0 >= 100 then
        begin
        temp   := trunc( a0 / 100 ) ;
        valcar := valcar + Lettres(temp)+ ' Cent ';
        a0:= a0 - (temp * 100);
        end;
 temp := trunc(a0) ;
 if a0 = 1 then valcar:= VALCAR +  'Un '
           else
           IF   a0 <= 100  then  valcar:= valcar + Lettres(temp) ;
if centimes <> 0 then   valcar:= valcar + ' DINARS et ' + Lettres(centimes) + ' Centimes'
               else     valcar:= valcar + ' DINARS et Zero Centimes' ;
Result := valcar ;
end ;

FUNCTION Lettres( valeur : integer ) : string ;
var  unite ,dizaine , code : string ;
var  n1 : integer ;
begin
        code :=''  ;
    //    n1 := 0 ;
         unite:=      'Un        Deux      Trois     Quatre    Cinq      ' ;
         unite:=unite+'Six       Sept      Huit      Neuf      Dix       ' ;
         unite:=unite+'Onze      Douze     Treize    Quatorze  Quinze    ' ;
         unite:=unite+'Seize     Dix-sept  Dix-huit  Dix-neuf  '         ;
       dizaine:=      'Vingt           Trente          Quarante        Cinquante       ' ;
     dizaine:=dizaine+'Soixante        Soixante        Quatre-vingt    Quatre-vingt    ' ;

IF valeur > 99 then
          begin
           n1:= trunc(valeur/100) ;
           code := copy( unite,10*(n1 -1),10) ;
           if n1 >1 then  code:= trim(code) +' Cent ' else code :='Cent ' ;
           valeur:= valeur - (n1 * 100);
          end ;

IF valeur > 19  then
          begin
                  n1:= trunc(valeur/10) ;
                  code:= trim(code)+' ' + trim(copy( dizaine,16*(n1 -2),15 )) ;
                  n1:= trunc(valeur/10)    ;
                  valeur:= valeur - n1*10 ;
                   if valeur = 1 then code := code + ' et ' ;

                 if valeur > 0 then
                        begin
                  IF n1 = 7  then  code:= code +' ' + trim(copy( unite,10*(valeur+9),10)) ;
                  IF n1 = 9  then  code:= code +' ' + trim(copy( unite,10*(valeur+9),10)) ;
                  IF n1 = 7  then    valeur :=0 ;
                  IF n1 = 9  then    valeur :=0 ;
                        end
                        else
                        begin
	          IF n1 = 7  then  code:= code  + '-dix ' ;
	          IF n1 = 9  then  code:= code + '-dix ' ;
                        end ;

         end ;
         n1:= trunc(valeur) ;
IF valeur > 0 then  code := trim(code) +' '+ trim(copy( unite,10*(n1 -1)+1,10)) ;
   if trim(code) = 'Un' then code :='' ;
Result := Trim(code)  ;
end ;

function  myhint(vexp: string ) : string ;
var expr : string ;
    xln, xlnmax : integer ;
begin
xln := 60 ;
expr := vexp ;
expr := StringReplace(expr,chr(13),' ',[rfReplaceAll, rfIgnoreCase]) ;
expr := StringReplace(expr,chr(10),' ',[rfReplaceAll, rfIgnoreCase]) ;
xlnmax := StrLen(pchar(vexp))   ;
while xln < xlnmax do
begin
Insert(chr(13) ,expr , xln ) ;
xln := xln + 60 ;
end;
Result := expr ;
end;
//procedure cherche_reg( xxValue :String ; xxRootkey :String ; xxKey :String ) : String ;

 //—————————————————————————————————————————————————————————————————————————————
// Returns the system directory for the current running OS
//—————————————————————————————————————————————————————————————————————————————
function GetSysDirectory : string;
var SysDir : Pchar;
begin
SysDir := StrAlloc(255);
try
  fillchar(SysDir^,255,0);
  GetSystemDirectory(SysDir,255); // Get the "windows\system" directory
  result := SysDir;
finally
  StrDispose(SysDir);
end;
end;

//—————————————————————————————————————————————————————————————————————————————
// Returns the Interbase installation path
//—————————————————————————————————————————————————————————————————————————————
function GetIBRootDir: string;
var Reg : TRegistry;
begin
Reg := TRegistry.Create(KEY_READ);
try
  Reg.RootKey := HKEY_LOCAL_MACHINE;
  if Reg.KeyExists(xcle) then begin
   if Reg.OpenKeyReadOnly(xcle) then begin
    if Reg.ValueExists('RootDirectory') then begin
     result := Reg.ReadString('RootDirectory');
    end;
    Reg.CloseKey;
   end else result := '';
  end else result := '';
  finally
  Reg.free;
end;
end;

//—————————————————————————————————————————————————————————————————————————————
// Returns true if applications runs on NT/2000
//—————————————————————————————————————————————————————————————————————————————
function IsNT : boolean;
var osv : TOSVERSIONINFO;
begin
fillchar(osv,sizeof(TOSVERSIONINFO),0);
osv.dwOSVersionInfoSize := sizeof(TOSVERSIONINFO);
GetVersionEx(osv);
//if (osv.dwPlatformId = VER_PLATFORM_WIN32_NT) then
//      if MessageDlg('Ok Pour Lancer ou Desactive un Service ',mtConfirmation,mbOKCancel,0) = mrOk
//         then result := true else
result := false;

end;

//—————————————————————————————————————————————————————————————————————————————
// Returns true if the current user is an administrator
//—————————————————————————————————————————————————————————————————————————————
function IsAdmin: Boolean;
var hAccessToken: THandle;
    ptgGroups: PTokenGroups;
    dwInfoBufferSize: DWORD;
    psidAdministrators: PSID;
    x: Integer;
    bSuccess: BOOL;
begin
if IsNT then begin
  Result := False;
  bSuccess := OpenThreadToken(GetCurrentThread, TOKEN_QUERY, True, hAccessToken);
  if not bSuccess then begin
   if GetLastError = ERROR_NO_TOKEN then
    bSuccess := OpenProcessToken(GetCurrentProcess, TOKEN_QUERY, hAccessToken);
  end;
  if bSuccess then begin
   GetMem(ptgGroups, 1024);
   bSuccess := GetTokenInformation(hAccessToken, TokenGroups, ptgGroups, 1024, dwInfoBufferSize);
   CloseHandle(hAccessToken);
   if bSuccess then begin
    AllocateAndInitializeSid(SECURITY_NT_AUTHORITY, 2, SECURITY_BUILTIN_DOMAIN_RID,
     DOMAIN_ALIAS_RID_ADMINS, 0, 0, 0, 0, 0, 0, psidAdministrators);
    {$R-}
    for x := 0 to ptgGroups.GroupCount - 1 do begin
     if EqualSid(psidAdministrators, ptgGroups.Groups[x].Sid) then begin
      Result := True;
      Break;
     end;
    end;
    {$R+}
    FreeSid(psidAdministrators);
   end;
   FreeMem(ptgGroups);
  end;
end else result := true; // If not running on Windows NT then admin = ok
end;

//—————————————————————————————————————————————————————————————————————————————
// Creates an NT Service
//—————————————————————————————————————————————————————————————————————————————
function ServiceCreate(sMachine, sService, sDisplayName, sBinFile : string; StartType : integer) : boolean;
var schm, schs   : SC_Handle;
begin
schm := OpenSCManager(PChar(sMachine),Nil,SC_MANAGER_CREATE_SERVICE);
if(schm > 0)then begin
  schs := CreateService(schm, PChar(sService),pchar(sDisplayName),SERVICE_ALL_ACCESS,
  SERVICE_INTERACTIVE_PROCESS or SERVICE_WIN32_OWN_PROCESS, StartType,
  SERVICE_ERROR_NORMAL, pchar(sBinFile), nil, nil, nil, nil, nil);
  if (schs > 0) then begin
   result := true;
   CloseServiceHandle(schs);
  end else result := false;
  CloseServiceHandle(schm);
end else result := false;
end;

//—————————————————————————————————————————————————————————————————————————————
// Removes an NT Service
//—————————————————————————————————————————————————————————————————————————————
function ServiceDelete(sMachine, sService : string) : boolean;
var schm, schs : SC_Handle;
begin
schm := OpenSCManager(PChar(sMachine),Nil,SC_MANAGER_CREATE_SERVICE);
if(schm > 0)then begin
  schs := OpenService(schm,pchar(sService), SERVICE_ALL_ACCESS);
  if (schs > 0) then begin
   result := DeleteService(schs);
   CloseServiceHandle(schs);
  end else result := false;
  CloseServiceHandle(schm);
end else result := false;
end;

//—————————————————————————————————————————————————————————————————————————————
// Starts an NT service
//—————————————————————————————————————————————————————————————————————————————
function ServiceStart(sMachine, sService : string ) : boolean;
var schm, schs   : SC_Handle;
    ss     : TServiceStatus;
    psTemp : PChar;
    dwChkP : DWord;
begin
  ss.dwCurrentState := 0;
  schm := OpenSCManager(PChar(sMachine),Nil,SC_MANAGER_CONNECT);
  if(schm > 0)then begin
   schs := OpenService(schm,PChar(sService),SERVICE_START or SERVICE_QUERY_STATUS);
   if (schs > 0) then begin
    psTemp := Nil;
    if (StartService(schs,0,psTemp)) then begin
     if (QueryServiceStatus(schs,ss)) then begin
      while (SERVICE_RUNNING <> ss.dwCurrentState) do begin
       dwChkP := ss.dwCheckPoint;
       Sleep(ss.dwWaitHint);
       if (not QueryServiceStatus(schs,ss)) then begin
        break;
       end;
       if (ss.dwCheckPoint < dwChkP) then begin
        break;
       end;
      end;
     end;
    end;
    CloseServiceHandle(schs);
   end;
   CloseServiceHandle(schm);
  end;
  Result := SERVICE_RUNNING = ss.dwCurrentState;
end;

//—————————————————————————————————————————————————————————————————————————————
// Stops an NT service
//—————————————————————————————————————————————————————————————————————————————
function ServiceStop(sMachine, sService : string ) : boolean;
var schm, schs   : SC_Handle;
    ss     : TServiceStatus;
    dwChkP : DWord;
begin
  schm := OpenSCManager(PChar(sMachine),Nil,SC_MANAGER_CONNECT);
  if(schm > 0)then begin
   schs := OpenService(schm,PChar(sService),SERVICE_STOP or SERVICE_QUERY_STATUS);
   if(schs > 0)then begin
    if (ControlService(schs,SERVICE_CONTROL_STOP,ss)) then begin
     if (QueryServiceStatus(schs,ss)) then begin
      while (SERVICE_STOPPED <> ss.dwCurrentState) do begin
       dwChkP := ss.dwCheckPoint;
       Sleep(ss.dwWaitHint);
       if (not QueryServiceStatus(schs,ss))then begin
        break;
       end;
       if (ss.dwCheckPoint < dwChkP) then begin
        break;
       end;
      end;
     end;
    end;
    CloseServiceHandle(schs);
   end;
   CloseServiceHandle(schm);
  end;
  Result := (SERVICE_STOPPED = ss.dwCurrentState);
end;

//—————————————————————————————————————————————————————————————————————————————
// Returns the full name to the Interbase guardian EXE file
//—————————————————————————————————————————————————————————————————————————————
function GetInterbaseGuardianFile : string ;
var Reg: TRegistry;
    xval : TStringList ;
    I  :Integer;
    xv , xent : string ;
begin
//Result :=  cherche_reg( HKEY_LOCAL_MACHINE,'RootDirectory' ,xcle);

  Reg:=TRegistry.Create ;
  try
    xval:=TStringList.Create ;
    try
     xv := '' ;
      Reg.RootKey:=HKEY_LOCAL_MACHINE  ;
      if reg.KeyExists(XCle ) then
       begin
        Reg.OpenKey(xcle,false )    ;
        Reg.GetValueNames(xval)   ;
      for I:=0 to xval.Count-1 do
        begin
            xent :=      VarToStr( xval.Strings[I] ) ;
            if (xent ='Version')            then   Xversion := VarToStr(   Reg.ReadString(xval.Strings[I]) )        ;
            if (xent ='ServerDirectory')  then  XChemin :=  VarToStr(   Reg.ReadString(xval.Strings[I]) ) ;
        end;
     end ;
    finally
      xval.Free;
    end;
  finally
    Reg.Free;
  end;
result := XChemin  ; //+ xnomexe  ;
end;

//—————————————————————————————————————————————————————————————————————————————
// returns true if Interbase is running
//—————————————————————————————————————————————————————————————————————————————
function InterbaseRunning : boolean;
begin
result := boolean(FindWindow('IB_Server','InterBase Server')
  or FindWindow('IB_Guard','InterBase Guardian'));
end;

//—————————————————————————————————————————————————————————————————————————————
// Shuts down Interbase
//—————————————————————————————————————————————————————————————————————————————
function ShutDownInterbase : boolean;
var IBSRVHandle,IBGARHandle : THandle;
begin
if IsNT then begin
  result := ServiceStop('','InterBaseGuardian');
end else begin
  IBGARHandle := FindWindow('IB_Guard','InterBase Guardian');
  if IBGARHandle > 0 then begin
   PostMessage(IBGARHandle,31,0,0);
   PostMessage(IBGARHandle,16,0,0);
  end;
  IBSRVHandle := FindWindow('IB_Server','InterBase Server');
  if IBSRVHandle > 0 then begin
   PostMessage(IBSRVHandle,31,0,0);
   PostMessage(IBSRVHandle,16,0,0);
  end;
  result := InterbaseRunning;
end;
end;

//—————————————————————————————————————————————————————————————————————————————
// Starts Interbase
//—————————————————————————————————————————————————————————————————————————————
function StartInterbase : boolean;
var Filename ,xxch : string;
    StartupInfo: TStartupInfo;
    ProcessInformation: TProcessInformation;
begin
filename := GetInterbaseGuardianFile + xnomexe ;
xxch := copy(Xversion,1,5);
if FileExists(Filename) then begin
  if IsNT then begin
   result := ServiceStart('','InterBaseGuardian');
  end else begin
   if xxch ='WI-V6' then filename := filename  + ' -a' ;
   Fillchar(StartupInfo,Sizeof(TStartupInfo),0);
   StartupInfo.cb := sizeof(StartupInfo);
   StartupInfo.lpReserved := nil;
   StartupInfo.lpTitle:= nil;
   StartupInfo.lpDesktop := nil;
   StartupInfo.dwFlags := STARTF_USESTDHANDLES;
   StartupInfo.wShowWindow := SW_SHOWNORMAL;
   StartupInfo.cbReserved2 := 0;
   StartupInfo.lpReserved2 := nil;
   result := CreateProcess(nil,PChar(filename),nil,nil,False,NORMAL_PRIORITY_CLASS,
    nil,PChar(ExtractFilePath(filename)),StartupInfo,ProcessInformation);
  end;
end else result := false;
end;

//—————————————————————————————————————————————————————————————————————————————
// Returns TRUE if Interbase is installed
//—————————————————————————————————————————————————————————————————————————————
function InterbaseInstalled : boolean;
var Filename : string;
begin
result := false;
filename :=  GetInterbaseGuardianFile + xnomexe  ;
     if   FileExists(Filename)
     then  if  FileExists((GetSysDirectory)+'\gds32.dll')
                 then result := true ;
end;


//Bouge(controle ,Top, Left, Width , Height, vitesse );
procedure Bouge(xcomp:TControl;FinX:Integer;FinY:Integer;FinW:Integer;FinH:Integer;Temps:Integer);
var
DecX:integer;    //Décalage X (Left)
DecY:integer;    //Décalage Y (Top)
DecH:integer;    //Décalage H (Height)
DecW:integer;    //Décalage W (Width)
MemTimer:integer;  //ME sert pour garder une vitesse identique sur chaq ordi
a:integer;
xx : TControl ;
begin
xx := xcomp ;
With  xx do begin
  DecX := (FinX - Left) div Temps; //Calcul des décalages
  DecY := (FinY - Top) div Temps;  //Plus temps est grand, plus c lent
  DecH := (FinH - Height) div Temps;
  DecW := (FinW - Width) div Temps;
  For a := 1 To Temps do begin    //Ben la ca déplace
    MemTimer := GetTickCount;
    top  := Top + DecY;
    Left := Left + DecX;
    Width := Width + DecW;
    Height := Height + DecH;
    repeat
    Until GetTickCount - MemTimer > 10;
  end;
End;
End;

procedure Transfer_Table(xdbgrid :TDBGrid ; xdataset1, xdataset2 : TTable ;
        xtype : TTableType ; xname : string ;
        xSauvgarde : TSaveDialog );
var
i : integer ;
xtabi : TStringList ;
xbatmov   : TBatchMove ;
begin
if  not  xdataset1.Active then exit ;
if xdataset1.RecordCount <=0 then exit ;
xSauvgarde.Title := 'Sauvgarder La Table sur disque' ;
if xtype = ttDBase then xSauvgarde.Filter := 'table Dbase (*.dbf)|*.dbf';
if xtype = ttDBase then xSauvgarde.DefaultExt := 'dbf' ;
if xtype = ttParadox then xSauvgarde.Filter := 'table Paradox (*.db)|*.db';
if xtype = ttParadox then xSauvgarde.DefaultExt := 'db' ;
if xtype = ttDefault then xSauvgarde.Filter := 'table Paradox (*.db)|*.db |table Dbase (*.dbf)|*.dbf';
if xtype = ttDefault then xSauvgarde.DefaultExt := 'db' ;
xSauvgarde.FileName := Copy( xname  , 1, pos( '.',xname )-1) ;
if not xSauvgarde.Execute then  exit ;
xtabi := TStringList.Create ;
xbatmov := TBatchMove.Create(Application) ;
xbatmov.Source := xdataset1 ;
xbatmov.Destination := xdataset2 ;
xbatmov.Mode := batAppend ;
      xdataset2.Active := False;
      xdataset2.TableName := xSauvgarde.FileName  ;
      xdataset2.TableType :=   xtype ;
      xdataset2.FieldDefs.Clear;
   for i := 0 to xdbgrid.Columns.Count-1 do
     begin
      if xdbgrid.Columns.Items[i].Visible then
      begin
      xdataset2.FieldDefs.Add(xdbgrid.Columns[i].FieldName,
                         xdbgrid.Columns[i].Field.DataType,
                         xdbgrid.Columns[i].Field.Size , false );
      xtabi.Add(IntToStr(i)) ;
      xbatmov.Mappings.Add(xdbgrid.Columns[i].FieldName +'='+ xdbgrid.Columns[i].FieldName ) ;
      end;
     end;
      xdataset2.CreateTable; // create the table
      xbatmov.Execute ;
//
{      xdataset1.First;
      xdataset2.Active := true ;
        while not xdataset1.Eof do
        begin
        xdataset2.Append ;
        for i := 0 to xdataset2.FieldCount - 1 do
        xdataset2.Fields[i].Value := xdataset1.Fields[StrToInt(xtabi[i])].Value ;
        xdataset1.Next ;
        end;
        xdataset2.Append ;
        for i := 0 to xdataset2.FieldCount - 1 do
        xdataset2.Fields[i].Value := xdataset1.Fields[StrToInt(xtabi[i])].Value ;
        xdataset2.Active := false ;
        xdataset2.TableName := '' ;
    finally
    end; }

end;

//procedure Transfer_Html(xdbgrid :TDBGrid ;xname : String ;
//              xSauvgarde : TSaveDialog ;xlmdstar : TLMDStarter);
procedure Transfer_Html(xname : String ;xSauvgarde : TSaveDialog );
//var
// F: Textfile;
// xf ,xxf : String ;
//  i,xfieldlen : integer ;
// xary : array of integer ;
//  xdataset1 : TDataSet ;
begin
//xdataset1 := xdbgrid.DataSource.DataSet ;
//if  not  xdataset1.Active then exit ;
//if xdataset1.RecordCount <=0 then exit ;
xSauvgarde.Title := 'Sauvgarder Le fichie Html  sur disque' ;
xSauvgarde.Filter := 'Fichier Text (*.HTML)|*.html';
xSauvgarde.DefaultExt := 'html' ;
xSauvgarde.FileName := Copy( xname  , 1, pos( '.',xname )-1) ;
{
if xSauvgarde.Execute then
  begin
      SetLength(xary,xdataset1.FieldCount );
    AssignFile(F, xSauvgarde.FileName  );
    try
      Rewrite(F);
//      Gauge1.MaxValue := Query1.RecordCount ;
  xf := '<html>' + chr(13) +
        '<body bgcolor="#DFDFDF">' + chr(13) +
        '<div align="center"><center>' + chr(13) +  chr(13) +
        '<table border="1" cellpadding="0" cellspacing="0"' + chr(13) +
        'bgcolor="#FFFFE1" bordercolordark="#FFFFFF"'+ chr(13) +
        'bordercolorlight="#000000">' ;
        Writeln(F, xf );
      xf :=  '<tr>' ;
        Writeln(F, xf );
     for i := 0 to xdataset1.FieldCount - 1 do
      if xdbgrid.Columns.Items[i].Visible then
         begin
             xfieldlen :=  xdataset1.FieldDefs[i].Size ;
             xxf :=  xdbgrid.Columns[i].Title.Caption ;
             case  xdataset1.FieldDefs[i].DataType of
              ftDate    : while  Length(xxf) < 12 do Insert(' ',xxf, Length(xxf)+1);
              ftInteger : xfieldlen := 25 ;
              ftFloat : xfieldlen := 25 ;
             end;
             xary[i] := Max(xfieldlen, length(xxf) );
             while Length(xxf) < xary[i] do Insert(' ',xxf, Length(xxf)+1);

      xf := xf +  '<td bgcolor="#000080"><font color="#FFFFFF"><strong> '
        + xxf +    ' </strong></font></td> ' ;

     end ;
     Writeln(F, xf );
     xf := '</tr> ' ;
     Writeln(F, xf );
      xdataset1.First;
      while not xdataset1.Eof do
      begin
      xf :='<tr>' ;
      Writeln(F, xf );
      for  i := 0 to xdataset1.FieldCount - 1 do
      if xdbgrid.Columns.Items[i].Visible then
       begin
        xxf := xdataset1.Fields[i].AsString ;
        if (xxf ='' ) then xxf :='&nbsp' ;
        xf := xf + '<td> ' + xxf + ' </td>' ;
        end;
        Writeln(F, xf );
        xf :='</tr>' ;
        Writeln(F, xf );
//        Gauge1.Progress := Gauge1.Progress  +1 ;
      xdataset1.Next ;
      end;
      CloseFile(F) ;
//        Gauge1.Progress := 0 ;
//        Gauge1.MaxValue := 0 ;
//        Gauge1.Refresh ;
      if MessageDlg('Voulez vous voir le fichier transfére',mtConfirmation,
         mbOKCancel,0) = mrOk then  begin
                         xlmdstar.Command := 'Explorer.exe' ;
                         xlmdstar.Parameters := xSauvgarde.FileName ;
                         xlmdstar.Execute ;
                                   end ;

          except
        on EInOutError do
        MessageDlg('Erreur d''E-S fichier.', mtError, [mbOk], 0);
    end;
  end;
 }

end;
function oui_aroundi(  xreal_vale : Currency  ) : Currency ;
var xsepar,xval_0 ,xval_str :string ;
    xval_int :integer ;
    xval_flot : Real48 ;
begin
xsepar:= DecimalSeparator ;
xval_str := FloatToStr(xreal_vale) ;
if pos(DecimalSeparator ,xval_str ) <> 0
   then begin
        xval_0   := copy(xval_str ,pos(DecimalSeparator ,xval_str ) +3,1);
        xval_str := copy(xval_str ,1,pos(DecimalSeparator ,xval_str ) +2);
   end else xval_0   := '' ;
xval_flot := StrToFloat(xval_str );
if  xval_0 <> ''
   then xval_int := StrToInt(xval_0)
   else xval_int :=  0 ;
if xval_int >= 5 then begin
       if  xval_flot > 0
          then  xval_flot :=  xval_flot + StrToFloat('0' + DecimalSeparator +'01' )
          else  xval_flot :=  xval_flot - StrToFloat('0' + DecimalSeparator +'01' );
       end;
Result := xval_flot ;
end ;

function non_aroundi(  xreal_vale : Currency ;xleng : integer ) : Currency ;
var xstr_val  :string ;
begin
 xstr_val := FloatToStr(xreal_vale)  ;
 if pos(DecimalSeparator ,xstr_val) <> 0
    then  xstr_val := copy(xstr_val ,1,pos(DecimalSeparator ,xstr_val)-1 ) + DecimalSeparator +
                      copy(xstr_val ,pos(DecimalSeparator ,xstr_val)+ 1 ,xleng );
 Result := StrToFloat(xstr_val);
end ;
procedure Transfer_TEXT( xname : string ; xSauvgarde : TSaveDialog );
begin
xSauvgarde.Title := 'Sauvgarder Le fichie text  sur disque' ;
xSauvgarde.Filter := 'Fichier Text (*.TXT)|*.txt';
xSauvgarde.DefaultExt := 'txt' ;
xSauvgarde.FileName := Copy( xname  , 1, pos( '.',xname )-1) ;
end;
procedure Transfer_csv( xname : string ; xSauvgarde : TSaveDialog );
begin
xSauvgarde.Title := 'Sauvgarder Le fichie text  sur disque' ;
xSauvgarde.Filter := 'Fichier Text (*.CSV)|*.csv';
xSauvgarde.DefaultExt := 'csv' ;
xSauvgarde.FileName := Copy( xname  , 1, pos( '.',xname )-1) ;
end;


function Exememo(xnom , classexnom  : pchar ) : boolean;
begin
result :=boolean( FindWindow( xnom , classexnom));
end;
function ajouter_reg(  xxRootkey : Cardinal ;xxValue , xxKey ,xvaleur: String  ) : Boolean   ;
var   Reg: TRegistry;
begin
  Reg:=TRegistry.Create ;
  Reg.RootKey := xxRootkey ;
  try
     Reg.OpenKey(xxKey,true);
     Reg.WriteString(xxValue ,xvaleur);
   Result := true ;
  finally
    Reg.Free;
  end;
end;


function cherche_reg(  xxRootkey : Cardinal ;xxValue , xxKey : String  ) : string   ;
var   Reg: TRegistry;
  xval : TStringList ;
  I  :Integer;
  xv , xent : string ;
begin
  Result := '' ;
  try
  Reg:=TRegistry.Create ;
  Reg.RootKey := xxRootkey ;
  xval:=TStringList.Create ;
    try
     xv := '' ;
     if reg.KeyExists( xxKey ) then
        begin
        Reg.OpenKey(xxKey,false )    ;
        Reg.GetValueNames(xval)   ;
        for I:= 0 to xval.Count-1   do
            begin
            xent :=     VarToStr( xval.Strings[I] ) ;
            if ( UpperCase(xent) = UpperCase(xxValue) )  then
            Result :=  VarToStr(   Reg.ReadString(xval.Strings[I]) )  ;
            end;
        end ;
    finally
      xval.Free;
    end;
  finally
    Reg.Free;
  end;
end;
procedure cree_lnk( edCible , Fichier_lnk  : String ; ico_index : integer );
Var Link: IShellLink;
    PFile: IPersistFile;
begin
  CoInitialize(nil);  //Initialisation de la librairie COM
  If SUCCEEDED(CoCreateInstance(CLSID_ShellLink, nil,
               CLSCTX_INPROC_SERVER, IID_IShellLinkW, Link)) then
  Begin
    Link.SetPath(PChar(edCible));
    Link.SetWorkingDirectory(PChar(ExtractFilePath(edCible)));
    Link.SetIconLocation(PChar(edCible), ico_index );
  end;
  If SUCCEEDED(Link.QueryInterface(CLSIDPFile, PFile)) then
      PFile.Save(StringToOLEStr(Fichier_lnk), True);
end;
function BDEexist (var xpath : string ) : boolean ;
var   xfichie0, xfichie , xsubfichie: string ;
      xval : TStringList ;
      i ,xdebuit,xlen : integer ;
begin
Result := false ;
xdebuit:= 0 ;
xpath :='';
xval :=  TStringList.Create ;        //D:\Program Files\Fichiers communs\Borland Shared\BDE\
xfichie := UpperCase( cherche_reg(HKEY_LOCAL_MACHINE,'DLLPATH' ,'\SOFTWARE\Borland\Database Engine'));
if xfichie ='' then exit;
xfichie0 :=  xfichie ;
xlen :=   Length(xfichie) ;
for i := 1 to xlen  do
     if  xfichie[i] = ';' then
        begin
        xsubfichie :=  copy(xfichie0,(xdebuit + 1) ,(i - xdebuit - 1)  ) ;
        xdebuit := i  ;
        xval.Add(xsubfichie);
        end;
        xsubfichie :=  copy(xfichie0,(xdebuit + 1) ,(xlen - xdebuit )  ) ;
        xval.Add(xsubfichie);

for i := 0 to xval.Count -1 do
        begin
        xfichie := xval[i] ;
        if xfichie[Length(xfichie)] <>'\' then xfichie := xfichie + '\' ;
        xfichie := xfichie + 'BDEADMIN.EXE' ;
        //xfichie := GetSysDirectory  + '\BDEADMIN.CPL' ;
        if FileExists( xfichie ) then Result := true ;
        if FileExists( xfichie ) then xpath := xfichie ;
        end;

end;


Function LerFichIni(FichIni:String; Section: String; rubrique: String): AnsiString;
Var
   IniF : TIniFile;
   Str  : AnsiString;
Begin
   IniF := TIniFile.Create(FichIni);
   Str  := IniF.ReadString(Section, Rubrique, '');
   IniF.free;
   RESULT := Str;
End;

Procedure EscreverFichIni(FichIni:String; Section: String; rubrique: String; NovoValor: AnsiString);
Var IniF : TIniFile;
Begin
  IniF := TIniFile.Create(FichIni);
  IniF.WriteString(Section, Rubrique, NovoValor);
  IniF.free;
End;
Procedure Liste_imprimantes(var xval : TStringList)    ;
var   Reg  : TRegistry;
//     xval  : TStringList ;
     xkey  : string ;
begin
  try
  Reg  := TRegistry.Create ;
  Reg.RootKey := HKEY_USERS  ;
    xkey :='\.DEFAULT\Software\Microsoft\Windows NT\CurrentVersion\Devices' ;
     if reg.KeyExists( xkey) then
        begin
        Reg.OpenKey(xKey,false )    ;
        Reg.GetValueNames(xval)   ;
        end;
  finally
    Reg.Free;
  end;
end;

procedure changer_impremant_defaults(Imprimant: String);
Var WinIniFileName : Array[0..MAX_PATH] Of Char;
    DEFINICAO_DA_IMPRESSORA: String;
    Arr_Tmp: Array[0..64] of Char;
begin
  // Procurar pasta do ficheiro Win.Ini :
  GetWindowsDirectory(WinIniFileName, sizeof(WinIniFileName));
  // Ficheiro Ini :
  StrCat(WinIniFileName, '\win.ini');
  // Mudar de Impressora :
  DEFINICAO_DA_IMPRESSORA := LerFichIni(WinIniFileName, 'DEVICES', Imprimant);
  If DEFINICAO_DA_IMPRESSORA <> ''
  Then Begin
    EscreverFichIni(WinIniFileName, 'WINDOWS', 'DEVICE', Imprimant + ',' + DEFINICAO_DA_IMPRESSORA);
    // Windows Refresh changes :
    StrCopy(Arr_Tmp, 'windows');
 //   SendMessage(HWND_BROADCAST, WM_WININICHANGE, 0, LongInt(@Arr_Tmp));
  End;
end;
procedure duplique_fichier( fichier_source , fichier_new : string );
begin
CopyFile(pchar(fichier_source),pchar(fichier_new),false );
end;

function  strtofieldtype(xtype : integer ) : TFieldType ;
begin
case xtype of
0 : Result := ftUnknown ;
1 : Result := ftString ;
2 : Result := ftSmallint ;
3 : Result := ftInteger ;
4 : Result := ftWord ;
5 : Result := ftBoolean ;
6 : Result := ftFloat ;
7 : Result := ftCurrency ;
8 : Result := ftBCD ;
9 : Result := ftDate ;
10 : Result := ftTime ;
11 : Result := ftDateTime    ;
12 : Result := ftBytes        ;
13 : Result := ftVarBytes     ;
14 : Result := ftAutoInc      ;
15 : Result := ftBlob         ;
16 : Result := ftMemo         ;
17 : Result := ftGraphic      ;
18 : Result := ftFmtMemo      ;
19 : Result := ftParadoxOle   ;
20 : Result := ftDBaseOle     ;
21 : Result := ftTypedBinary  ;
22 : Result := ftCursor       ;
23 : Result := ftFixedChar    ;
24 : Result := ftWideString   ;
25 : Result := ftLargeint     ;
26 : Result := ftADT          ;
27 : Result := ftArray        ;
28 : Result := ftReference    ;
29 : Result := ftDataSet      ;
30 : Result := ftOraBlob      ;
31 : Result := ftOraClob      ;
32 : Result := ftVariant      ;
33 : Result := ftInterface    ;
34 : Result := ftIDispatch    ;
35 : Result := ftGuid         ;
36 : Result := ftTimeStamp    ;
37 : Result := ftFMTBcd       ;
end;

end;
procedure AjouterUnChamp(Titre : string; Tbl : TClientDataSet;
  Largeur : integer);
var
  Numero : integer ;
var
  Fld : TStringField;
  Nom : string;
begin
  Numero := 0;
  Fld := TStringField.Create(Tbl);
  Nom := 'Champ'+inttostr(Numero);
  with Fld do begin
    Size := 255;
    SetFieldType(ftString);
    Name := Nom;
    FieldName := Nom;
    Index := Numero;
    DisplayLabel := Titre;
    DisplayWidth := strtoint(formatfloat('0',Largeur));
    DataSet := Tbl;
  end;
//  Numero := Numero + 1;
end;
procedure StringGridToCDS(StringGrid : TStringGrid; CDS : TClientDataSet);
var
  NumChamp, NumColonne, NumLigne : integer;
begin
  with CDS do begin
    for NumColonne := 0 to StringGrid.colcount-1 do begin
      if StringGrid.ColWidths[NumColonne]>2 then begin
        AjouterUnChamp(StringGrid.Cells[NumColonne,0], CDS,
          StringGrid.ColWidths[NumColonne]);
      end;
    end;
    CreateDataSet;
    open;
    for NumLigne := 1 to StringGrid.RowCount-1 do begin
      append;
      NumChamp := 0;
      for NumColonne := 0 to StringGrid.ColCount-1 do begin
        if StringGrid.ColWidths[NumColonne]>2 then begin
          fields[NumChamp].asstring := StringGrid.Cells[NumColonne,NumLigne];
          inc(numChamp);
        end;
      end;
      CheckBrowseMode;
    end;
  end;
end;
function ExportDBToFileDB(Tbl : TDataSet; FileName : string;
  const Tous : boolean = false) : boolean;
var
  Dst : TTable;
  NumChamp : integer;
begin
  result := false;
  Dst := TTable.Create(application);
  with Dst do begin
    TableName := FileName;
    FieldDefs.Assign((Tbl as TClientDataSet).FieldDefs);
    IndexDefs.Assign((Tbl as TClientDataSet).IndexDefs);
    CreateTable;
    open;
    Tbl.First;
    While not Tbl.Eof do begin
      Append;
      for NumChamp := 0 to fields.count-1 do begin
        fields[NumChamp].Value := Tbl.Fields[NumChamp].value;
      end;
      Post;
      Tbl.Next;
    end;
    Dst.FlushBuffers;
    Dst.Close;
    Dst.Free;
  end;
end;
function ExportDBToFileHTML(Tbl : TDataSet; FileName : string;
  const Tous : boolean = false; const Separateur : string = ';') : boolean;
var
  Sl : TStringList;
  Chaine : string;
  NumChamp : integer;
begin
  result := false;
  sl := TStringList.Create;
  sl.add('<HTML><TITLE>');
  sl.add('</TITLE><BODY><TABLE BORDER="1">');
  try
    with Tbl do begin
      first;
      Chaine := '';
      sl.add('<TR>');
      for NumChamp := 0 to fields.count-1 do begin
        if (fields[NumChamp].Visible or Tous) then begin
          Chaine := Chaine + '<TD>' + Fields[NumChamp].DisplayName + '</TD>';
        end;
      end;
      sl.add('</TR>');
      sl.add(Chaine);
      while not eof do begin
        sl.add('<TR>');
        Chaine := '';
        for NumChamp := 0 to fields.count-1 do begin
          if (fields[NumChamp].Visible or Tous) then begin
            Chaine := Chaine + '<TD>'+Fields[NumChamp].asstring + '</TD>';
          end;
        end;
        sl.add(Chaine);
        next;
        sl.add('</TR>');
      end;
    end;
    sl.add('</TABLE></BODY></HTML>');
    sl.SaveToFile(FileName);
    result := True;
  finally
    sl.free;
  end;
end;
function ExportDBToFileTXT(Tbl : TDataSet; FileName : string;
  const Tous : boolean = false; const Separateur : string = ';') : boolean;
var
  Sl : TStringList;
  Chaine : string;
  NumChamp : integer;
begin
  result := false;
  sl := TStringList.Create;
  try
    with Tbl do begin
      first;
      Chaine := '';
      for NumChamp := 0 to fields.count-1 do begin
        if (fields[NumChamp].Visible or Tous) then begin
          Chaine := Chaine + Fields[NumChamp].DisplayName + ';';
        end;
      end;
      sl.add(Chaine);
      while not eof do begin
        Chaine := '';
        for NumChamp := 0 to fields.count-1 do begin
          if (fields[NumChamp].Visible or Tous) then begin
            Chaine := Chaine + Fields[NumChamp].asstring + ';';
          end;
        end;
        sl.add(Chaine);
        next;
      end;
    end;
    sl.SaveToFile(FileName);
    result := True;
  finally
    sl.free;
  end;
end;
function AskFileNameForExport : string;
begin
  with TOpenDialog.create(application) do begin
    DefaultExt:='txt';
    Filter:='Fichiers texte (*.txt)|*.txt';
    Options:=[ofOverwritePrompt, ofHideReadOnly, ofPathMustExist,
      ofNoReadOnlyReturn, ofEnableIncludeNotify, ofEnableSizing];
    {(ofReadOnly, ofOverwritePrompt, ofHideReadOnly, ofNoChangeDir, ofShowHelp,
    ofNoValidate, ofAllowMultiSelect, ofExtensionDifferent, ofPathMustExist,
    ofFileMustExist, ofCreatePrompt, ofShareAware, ofNoReadOnlyReturn,
    ofNoTestFileCreate, ofNoNetworkButton, ofNoLongNames, ofOldStyleDialog,
    ofNoDereferenceLinks, ofEnableIncludeNotify, ofEnableSizing);}
    if Execute then result := FileName;
    free;
  end;
end;
function ExportDBToFile(Tbl : TDataSet; FileFormat : TDndExportFormat;
  FileName : string; const Tous : boolean = false) : boolean;
begin
  result := false;
  FileName := Trim(FileName);
  if Length(FileName) = 0 then begin
    FileName := AskFileNameForExport;
  end;
  case FileFormat of
    dndexp_TXT : result := ExportDBToFileTXT(Tbl, FileName, Tous);
    dndexp_DB : result := ExportDBToFileDB(Tbl, FileName, Tous);
    dndexp_HTML : result := ExportDBToFileHTML(Tbl, FileName, Tous);
  end;
end;
function StringGridExport(StringGrid : TStringGrid;
  FileFormat : TDndExportFormat; FileName : string) : boolean;
var
  Tbl : TClientDataSet;
begin
  Tbl := TClientDataSet.Create(nil);
  StringGridToCDS(StringGrid, Tbl);
  result := ExportDBToFile(Tbl, FileFormat, FileName);
  Tbl.Close;
  Tbl.free;
end;
procedure StringGridPreviewPrint(AOwner : TComponent; StringGrid : TStringGrid;
  Preview : boolean; ReportTitle : string;
  PageOrientation : TPrinterOrientation);
var
  Tbl : TClientDataSet;
begin
  Tbl := TClientDataSet.Create(nil);
  StringGridToCDS(StringGrid, Tbl);
  DataSetPreviewPrint(AOwner, Preview, ReportTitle, Tbl, PageOrientation);
  Tbl.Close;
  Tbl.free;
end;
procedure DataSetPreviewPrint(AOwner : TComponent; MakePreview : boolean;
  ReportTitle : string; ADataSet : TDataset;
  PageOrientation : TPrinterOrientation);
begin
  with TPrntDataSet.create(AOwner) do begin
    Title:=ReportTitle;
    Orientation:=PageOrientation;
    FQuickRep.Page.Orientation:=PageOrientation;
    if MakePreview then begin
      Preview(ADataSet);
    end else begin
      Print(ADataSet);
    end;
    free;
  end;
end;
procedure DataSetPreview(AOwner : TComponent; ReportTitle : string;
  ADataSet : TDataset; PageOrientation : TPrinterOrientation);
begin
  DataSetPreviewPrint(AOwner, True, ReportTitle, ADataSet, PageOrientation);
end;
procedure DataSetPrint(AOwner : TComponent; ReportTitle : string;
  ADataSet : TDataset; PageOrientation : TPrinterOrientation);
begin
  DataSetPreviewPrint(AOwner, false, ReportTitle, ADataSet, PageOrientation);
end;
{ TPrntDataSet }
constructor TPrntDataSet.Create(AOwner: TComponent);
begin
  inherited;
  FQuickRep:=TQuickRep.Create(Application);
  FQuickRep.PrinterSettings.PrinterIndex := printer.printerindex;
  FQuickRep.visible := false;
  FQuickRep.name:='myquickrep'+inttostr(CountReportPreview);
  CountReportPreview:= CountReportPreview+1;
  FQuickRep.Parent:=(Aowner as TWinControl);
//  FQuickRep.OnPreview := QRepPreview;
end;
procedure TPrntDataSet.QRepPreview(Sender : TObject);
begin
  DataSet.First;
end;
procedure TPrntDataSet.CreerReport;
const
  hauteur = 15;
begin
  FQuickRep.OnNeedData:=QuickRepNeedData;
  FQuickRep.Bands.HasTitle:=true;
  FQuickRep.Bands.HasColumnHeader:=true;
  FQuickRep.Bands.HasDetail:=true;
  FQuickRep.Bands.HasSummary:=true;
  FQuickRep.Bands.ColumnHeaderBand.height:=hauteur;
  FQuickRep.Bands.DetailBand.height:=hauteur;
  FQuickRep.Bands.SummaryBand.height:=5;
  with TQRShape.Create(FQuickRep) do begin
    parent:=FQuickRep.Bands.ColumnHeaderBand;
    left:=0;
    Shape:=qrsHorLine;
    height:=1;
    top:=FQuickRep.Bands.ColumnHeaderBand.Height-1;
    Size.Width:=FQuickRep.Bands.ColumnHeaderBand.Size.Width;
    name:='shp1';
  end;
  with TQRShape.Create(FQuickRep) do begin
    parent:=FQuickRep.Bands.SummaryBand;
    left:=0;
    top:=0;
    Shape:=qrsHorLine;
    height:=1;
    Size.Width:=FQuickRep.Bands.ColumnHeaderBand.Size.Width;
    name:='shp2';
  end;
  with tqrlabel.Create(FquickRep) do begin
    parent:=FquickRep.Bands.TitleBand;
    AlignToBand:=true;
    Alignment:=taCenter;
    AutoSize:=true;
    Font.Name:='Arial';
    Font.Size:=14;
    caption:=Title;
    name:='title1';
  end;
end;
destructor TPrntDataSet.Destroy;
begin
  FQuickRep.destroy;
  inherited;
end;
procedure TPrntDataSet.QuickRepNeedData(Sender: TObject; var MoreData: Boolean);
var
  i : integer;
  n : integer;
begin
  MoreData:=not Dataset.EOF;
  if not moredata then exit;
  // remplir les captions
  n:=0;
  for i:=0 to DataSet.Fields.count-1 do begin
    if DataSet.Fields[i].Visible then begin
      TQRLabel(FLstFields[n]).Caption:=dataset.fields[i].asstring;
      inc(n);
    end;
  end;
  //
  DataSet.next;
end;
procedure TPrntDataSet.Preview(Tbl: TDataSet);
begin
  FQuickRep.Page.Orientation:=Orientation;
  Prepare(Tbl);
  Tbl.first;
  FQuickRep.Preview;
  Tbl.first;
end;
procedure TPrntDataSet.Prepare(Tbl: TDataSet);
begin
  DataSet:=Tbl;
  DataSet.First;
  CreerReport;
  CreerChamps;
end;
procedure TPrntDataSet.CreerChamps;
var
  i : integer;
  x : extended;
  w, mw : extended;
  MaxDispWidth : integer;
begin
  FLstFields:=TList.create;
  x:=0;
  mw:=FQuickRep.Bands.DetailBand.Size.Width;
  MaxDispWidth:=0;
  for i:=0 to DataSet.Fields.count-1 do begin
    if DataSet.Fields[i].Visible then begin
      MaxDispWidth:=MaxDispWidth+DataSet.Fields[i].DisplayWidth;
    end;
  end;
  for i:=0 to DataSet.Fields.count-1 do begin
    if DataSet.Fields[i].Visible then begin
      w:=DataSet.Fields[i].DisplayWidth*(mw/MaxDispWidth);
      AjouterChamp(i,x,mw,w);
    end;
  end;
end;
procedure TPrntDataSet.AjouterChamp(i : integer; var x : extended; mw, w : extended);
var
  fld : TQRLabel;
  ox : extended;
begin
  ox:=x;
  fld:=tqrlabel.Create(FquickRep);
  with fld do begin
    parent:=FquickRep.Bands.DetailBand;
    size.Left:=x;
    top:=0;
    AutoSize:=false;
    size.width:=w;
    x:=x+w;//width+10;
    Transparent:=true;
    name:='myqrlabelspec' + IntToStr(i);
  end;
  FLstFields.Add(fld);
  with TQRLabel.create(FQuickRep) do begin
    parent:=FquickRep.Bands.ColumnHeaderBand;
    size.left:=ox;
    top:=0;
    AutoSize:=true;
    caption:=dataset.fields[i].DisplayName;
    Transparent:=true;
    name:='myqrlabelspec0' + IntToStr(i);
  end;
end;
procedure TPrntDataSet.Print(Tbl: TDataSet);
begin
  FQuickRep.Page.Orientation:=Orientation;
  Prepare(Tbl);
  Tbl.first;
  FQuickRep.print;
  Tbl.first;
end;
Function Complete_var( Xvaleur_initial ,Xvaleur_remplisage : string ;xlengeur : integer ;xsance : string ) : string ;
begin
if xsance ='D' then while length(Xvaleur_initial) < xlengeur do Xvaleur_initial := Xvaleur_initial + Xvaleur_remplisage
               else while length(Xvaleur_initial) < xlengeur do Xvaleur_initial := Xvaleur_remplisage + Xvaleur_initial;
Result := Xvaleur_initial ;
end;
procedure changer_coleur_zone_edit(xpanel  : TCustomPanel ; xcouleur : TColor ) ;
var I:Integer;
xEdit :TEdit ;
xJvValidateEdit :TJvValidateEdit ;
xDBEdit :TDBEdit  ;
xComboBox :TComboBox ;
xDBComboBox :TDBComboBox ;
xJvDBLookupEdit :TJvDBLookupEdit ;
xJvDBLookupCombo :TJvDBLookupCombo ;
begin
for I:=0 to   xpanel.ControlCount -1 do
  begin
    if xpanel.Controls[I] is TEdit then
            begin
            xEdit := (xpanel.Controls[I] as TEdit ) ;
            if xEdit.Focused
                         then xEdit.Color := xcouleur
                         else xEdit.Color := clWhite ;
            end;
    if xpanel.Controls[I] is TJvValidateEdit then
            begin
            xJvValidateEdit := (xpanel.Controls[I] as TJvValidateEdit ) ;
            if xJvValidateEdit.Focused
                         then xJvValidateEdit.Color := xcouleur
                         else xJvValidateEdit.Color := clWhite ;
            end;
    if xpanel.Controls[I] is TDBEdit then
            begin
            xDBEdit := (xpanel.Controls[I] as TDBEdit ) ;
            if xDBEdit.Focused
                         then xDBEdit.Color := xcouleur
                         else xDBEdit.Color := clWhite ;
       end;
    if xpanel.Controls[I] is TComboBox then
            begin
            xComboBox := (xpanel.Controls[I] as TComboBox ) ;
            if xComboBox.Focused
                        then xComboBox.Color := xcouleur
                        else xComboBox.Color := clWhite ;
            end;
    if xpanel.Controls[I] is TDBComboBox then
            begin
            xDBComboBox := (xpanel.Controls[I] as TDBComboBox ) ;
            if xDBComboBox.Focused
                        then xDBComboBox.Color := xcouleur
                        else
                        xDBComboBox.Color := clWhite ;
            end;
    if xpanel.Controls[I] is TJvDBLookupEdit then
            begin
            xJvDBLookupEdit := (xpanel.Controls[I] as TJvDBLookupEdit ) ;
            if xJvDBLookupEdit.Focused
                        then xJvDBLookupEdit.Color := xcouleur
                        else xJvDBLookupEdit.Color := clWhite ;
            end;
    if xpanel.Controls[I] is TJvDBLookupCombo then
            begin
            xJvDBLookupCombo := (xpanel.Controls[I] as TJvDBLookupCombo ) ;
            if xJvDBLookupCombo.Focused
                        then xJvDBLookupCombo.Color := xcouleur
                        else xJvDBLookupCombo.Color := clWhite ;
            end;

end ;
end;
function get_cpu_speed:dword;
{
voila un chtite functon pour prendre la vitesse
du cpu qui marche avec un pentium au minimum

bon coding a vous ...

ManChesTer (c)2002 freeware
}
var Speed : dword;
    perform: int64;
begin
 perform:=0;
 SetpriorityClass(getcurrentprocess,REALTIME_PRIORITY_CLASS);
 SetThreadPriority(getcurrentThread,THREAD_PRIORITY_TIME_CRITICAL);
 asm
   push eax
   push edx
   push ecx
   push 1000
   call sleep // appel de sleep(1000)
   dw $310F // rdtsc (red internal cpu timer in cycle)
   add eax,edx
   mov speed,eax // stokez les cycles machine
   push edx
   xor eax,eax
   push 1000
   call sleep // appel de sleep(1000)
   pop edx
   dw $310F // relire le timer cpu rdsc
   add eax,edx
   sub eax,speed // garder 1000 millisecondes (1 seconde)
   mov speed,eax // le stocké dans speed;
   pop ecx
   pop edx
   pop eax
 end;
 result:=round((speed / 1000000) / 3)*3; // div 3 * 3 a cose de busfeq
end;
procedure lancer_interbase(Sender: TObject);
var    xouiv5 ,xouiv6,xlance : Boolean ;
repsys : PChar ;
xfilsource , xfildestin  ,xverinter : string;
begin
if  InterbaseRunning then exit ;
xouiv5 := false ;
xouiv6 := false ;
repsys := pchar( GetSysDirectory ) ;
Xnomexe :='ibguard.exe' ;

xcle :='\SOFTWARE\Borland\InterBase\CurrentVersion' ;
if  InterbaseInstalled = true then xouiv6 := true ;
XCle :='\SOFTWARE\InterBase Corp\InterBase\CurrentVersion' ;
if  InterbaseInstalled = true then xouiv5 := true ;
xcle :='' ;
if ((xouiv6 = true ) and (xouiv5 = false )) then  XCle :='\SOFTWARE\Borland\InterBase\CurrentVersion' ;
if ((xouiv6 = false ) and (xouiv5 = true )) then   XCle :='\SOFTWARE\InterBase Corp\InterBase\CurrentVersion' ;
if ((xouiv6 = false ) and (xouiv5 = false )) then  xcle :='' ;
if ((xouiv6 = false ) and (xouiv5 = false )) then   MessageDlg('Inerbase server n''est pas Installer ',mtInformation,[mbOk],0) ;

    if ((xouiv6 = true  ) and (xouiv5 = true ) and ( InterbaseRunning = false) ) then
             begin
             xfildestin := repsys + '\gds32.dll' ;
             RenameFile( repsys +'\gds32.dll',repsys +'\gds0032.dll' ) ;
             DeleteFile( pchar(repsys +  '\gds0032.dll' ) ) ;
             if  MessageDlg('Tapez OUI Pour Lancer La Version   V6  ' + chr(13)  +
                            'et    Non pour Lancer La Version   V5  ',mtInformation,[mbOK,mbNo],0) = mrOk
                 then  XCle :='\SOFTWARE\Borland\InterBase\CurrentVersion'
                 else  XCle :='\SOFTWARE\InterBase Corp\InterBase\CurrentVersion' ;
              xverinter := UpperCase( cherche_reg(HKEY_LOCAL_MACHINE,'Version' ,Xcle ));
              xverinter := xverinter[5]+ '_' + xverinter[7] ;
              xfilsource  := 'gds32_' + xverinter + '.dll' ;
              CopyFile(pchar( xfilsource),pchar(xfildestin),true) ;
             end;
 if  xcle <> ''  then   StartInterbase ;
end;

function nbr_jours(CONST  xdate_du , xdate_au : TDateTime ; xtype_jours ,xjour_f_1,xjour_f_2: String ) : Integer ;
var xdate0  : tdate ;
jour : string ;
i,j : integer;
BEGIN
i := 0 ;
j := 0 ;
jour := '' ;
xdate0 := xdate_du ;
     while xdate0 <= xdate_au  do
     begin
              jour := FormatDateTime('dddd',xdate0);
              if (UpperCase(jour) = xjour_f_1 ) OR (UpperCase(jour) = xjour_f_2 )
                  Then j := j+1
                  else i := i+1;
              xdate0 := IncDay(xdate0 , 1);
    end;


if xtype_jours = 'TOUS'     then Result := I + J ;
if xtype_jours = 'OUVRABLE' then Result := I  ;
if xtype_jours = 'WEKEND'   then Result := J ;

END;

procedure afichier_date_taill_fichier(var xfile , xdate,xtaille,xtypetaille : string  );
var xsource ,xsize  : string ;
F: file of Byte;
size : Longint;
begin
xtaille   := '' ;
xdate   := '' ;
if not FileExists( xfile )  then
   begin
   exit ;
   end else
   begin
     AssignFile(F,xfile);
     FileMode :=0 ;{Accès en lecture seule au fichier }
     try
     Reset(F);
     if xtypetaille = 'Ko'  then       xtaille   :=  VarToStr(int(FileSize(f)/1024)) ;
     if xtypetaille = 'Mo'  then       xtaille   :=  VarToStr(int(FileSize(f)/1048576)) ;
     if xtypetaille = 'oK'  then       xtaille   :=  VarToStr(FileSize(f));
     xdate     :=  DateTimeToStr(FileDateToDateTime(FileAge(xfile)));
     Except
     CloseFile(F);
     end;
     CloseFile(F);
   end;
end;

function extrair_ico(var xfile : string  ) : TIcon ;
Var Uicon: Hicon;
Var xNbr: integer;
xico : TIcon;
xstnbr ,xprograme0 ,xprograme1 ,xtension :string ;
begin
xico := TIcon.Create ;
xtension :=copy(xfile ,length(xfile)-3,4);
xprograme0 :=   cherche_reg(HKEY_CLASSES_ROOT,'',xtension );
xprograme1 :=   cherche_reg(HKEY_CLASSES_ROOT,'',xprograme0 + '\DefaultIcon'  );
if xprograme1 ='' then xprograme1 :=   cherche_reg(HKEY_CLASSES_ROOT,'',xprograme0 + '\shell\open\command'  );
xNbr := 0 ;
if  pos(',',xprograme1) <> 0 then
         begin
         xstnbr :=copy( xprograme1,length(xprograme1),1);
         if xstnbr <> '' then xNbr := StrToInt(xstnbr) ;
         xprograme1 := copy(xprograme1,1,pos(',',xprograme1)-1) ;
         end else xprograme1 := copy(xprograme1,2,length(xprograme1)-7 );

if UpperCase(xtension)='.EXE'
   then  xico.Handle := ExtractIcon(Application.Handle, Pchar(xfile), 0)
   else  xico.Handle := ExtractIcon(Application.Handle, Pchar(xprograme1), xNbr);
Result := xico ;
end;
//*************************************************************
//       Fonction Trouvant la Version de Windows
//*************************************************************
function WindowsVersion:string; //TWindowsVersion;
var
  VI         : TOSVersionInfo;
  WinVersion : TWindowsVersion;
begin
  VI.dwOSVersionInfoSize:= SizeOf(VI);
  GetVersionEx(VI);
Result :='Windows ';
  WinVersion := twvunknow ;
  case VI.dwPlatformID of
    VER_PLATFORM_WIN32s: WinVersion := tWvWin31;

    VER_PLATFORM_WIN32_WINDOWS:
        case VI.dwMinorVersion of
              0 : if Trim(VI.szCSDVersion[1]) = 'B' then
                      WinVersion:= tWvWin952
                    else
                      WinVersion:= tWvWin951;
             10 : if Trim(VI.szCSDVersion[1]) = 'A' then
                    WinVersion:= tWvWin982
                  else
                    WinVersion:= tWvWin981;
             90 : if (VI.dwBuildNumber = 73010104) then
                    WinVersion:= tWvWinme;

             else WinVersion:= tWvWin9x;
        end;

    VER_PLATFORM_WIN32_NT:
        case VI.dwMajorVersion of
            3 : WinVersion:= tWvWinnt35;
            4 : WinVersion:= tWvWinnt4;
            5 : case VI.dwMinorVersion of
                  0 : WinVersion:= tWvWin2k;
                  1 : WinVersion:= tWvWinxp;
                  else WinVersion:= tWvWinnt
                end;
            6,7 : Result :='Windows Vista ';


        end;
  end;
//  result := WinVersion;


  case WinVersion of
//    twvunknow   : Result :='Windows Inconnu';

    twvwin31    : Result :='Windows 3.1';
    twvwin951   : Result :='Windows 95 OSR 1';
    twvwin952   : Result :='Windows 95 OSR 2';
    twvwin981   : Result :='Windows 98 OSR 1';
    twvwin982   : Result :='Windows 98 OSR 2';
    twvwinme    : Result :='Windows Me';
    twvwin9x    : Result :='Windows 9x'; // Si Windows Inconnu parmi les Win9x
    twvwinnt35  : Result :='Windows NT 3.5';
    twvwinnt4   : Result :='Windows NT 4';
    twvwin2k    : Result :='Windows 2000';
    twvwinxp    : Result :='Windows XP';
    twvwinnt    : Result :='Windows NT'; // Si Windows Inconnu parmi les WinNT
  end;

 Result := Result + '  ' + VarToStr(Vi.dwBuildNumber) +
                    '  ' + VarToStr(Vi.dwMajorVersion) +
                    '  ' + VarToStr(Vi.dwMinorVersion);
end;


procedure edit_cherche_dans_table(xedit : TEdit ;
                          xdataset : TDataSet ;  xchamp: string  ; xcolor :TColor );
var xtext : string ;
    xoui : boolean ;
begin
xtext := trim(xedit.Text) ;
xedit.Color := clWhite ;
if xtext= '' then exit;
if  xdataset.FieldByName(xchamp).DataType = ftString
   then if length(xtext) > xdataset.FieldByName(xchamp).Size then begin
       xedit.text := copy( xtext ,1 ,length(xtext)-1 );
       if length(xtext) > 0 then xedit.SelStart :=  length(xtext) ;
       end;
xtext := trim(xedit.Text) ;
if xtext= '' then exit;
xoui := true ;
   if           xdataset.FieldByName(xchamp).DataType = ftString then begin
         if not xdataset.Locate(xchamp,xtext,[loPartialKey])
             then if not  xdataset.Locate(xchamp,xtext,[loCaseInsensitive]) then xoui := false ;
   end else if  xdataset.FieldByName(xchamp).DataType = ftInteger then begin
        if not xdataset.Locate(xchamp,strtoint( xtext),[loPartialKey])
            then if not  xdataset.Locate(xchamp,strtoint(xtext),[loCaseInsensitive]) then xoui := false ;
   end else if  xdataset.FieldByName(xchamp).DataType = ftFloat then begin
        if ((xtext[length(xtext)] = '.' ) or (xtext[length(xtext)] = ',' ) )
              then  xtext := copy(xtext ,1, length(xtext)-1) ;
            xtext := StringReplace(xtext,',',DecimalSeparator ,[rfReplaceAll]) ;
            xtext := StringReplace(xtext,'.',DecimalSeparator ,[rfReplaceAll]) ;
        if not xdataset.Locate(xchamp,StrToFloat( xtext),[loPartialKey])
            then if not  xdataset.Locate(xchamp,StrToFloat(xtext),[loCaseInsensitive]) then xoui := false ;
   end ;

 if  xoui = true
      then xedit.Color := xColor
      else xedit.Color := clRed ;
end;


procedure crer_fields_type(VAR xField : TField ;  xtype : TFieldType  ; xtable : TComponent ) ;
begin
case xtype of
//  pour les type Float ou Integer lancer  crer_fields_type_float ou crer_fields_type_integer
  ftInteger      : begin
                   xField  :=  tIntegerField.Create(xtable) ;
                  // xfield.DisplayFormat := '### ### ### ### ###' ;
                   end;
  ftFloat        : begin
                   xField  :=  tFloatField.Create(xtable) ;
                  // xfield.DisplayFormat := '### ### ### ### ##0.00' ;
                 //  xfield.Precision := 2 ;
                   end;

  ftUnknown      : xField  := nil ; //tUnknownField.Create(xtable) ;
  ftString       : xField  := tStringField.Create(xtable) ;
  ftSmallint     : xField  := tSmallintField.Create(xtable) ;
  ftWord         : xField  :=  tWordField.Create(xtable) ;
  ftBoolean      : xField  :=  tBooleanField.Create(xtable) ;
  ftCurrency     : xField  :=  tCurrencyField.Create(xtable) ;
  ftBCD          : xField  :=  tBCDField.Create(xtable) ;
  ftDate         : xField  :=  tDateField.Create(xtable) ;
  ftTime         : xField  :=  tTimeField.Create(xtable) ;
  ftDateTime     : xField  :=  tDateTimeField.Create(xtable) ;
  ftBytes        : xField  :=  tBytesField.Create(xtable) ;
  ftVarBytes     : xField  :=  tVarBytesField.Create(xtable) ;
  ftAutoInc      : xField  :=  tAutoIncField.Create(xtable) ;
  ftBlob         : xField  :=  tBlobField.Create(xtable) ;
  ftMemo         : xField  :=  tMemoField.Create(xtable) ;
  ftGraphic      : xField  :=   tGraphicField.Create(xtable) ;
  ftFmtMemo      : xField  :=  nil ; // tFmtMemoField.Create(xtable) ;
  ftParadoxOle   : xField  :=  nil ; // tParadoxOleField.Create(xtable) ;
  ftDBaseOle     : xField  :=  nil ; //tDBaseOleField.Create(xtable) ;
  ftTypedBinary  : xField  :=  nil ; //tTypedBinaryField.Create(xtable) ;
  ftCursor       : xField  :=  nil ; //tCursorField.Create(xtable) ;
  ftFixedChar    : xField  :=  nil ; //tFixedCharField.Create(xtable) ;
  ftWideString   : xField  :=  tWideStringField.Create(xtable) ;
  ftLargeint     : xField  :=  tLargeintField.Create(xtable) ;
  ftADT          : xField  :=  tADTField.Create(xtable) ;
  ftArray        : xField  :=  tArrayField.Create(xtable) ;
  ftReference    : xField  :=  tReferenceField.Create(xtable) ;
  ftDataSet      : xField  :=  tDataSetField.Create(xtable) ;
  ftOraBlob      : xField  :=  nil ; //tOraBlobField.Create(xtable) ;
  ftOraClob      : xField  :=  nil ; //tOraClobField.Create(xtable) ;
  ftVariant      : xField  :=  tVariantField.Create(xtable) ;
  ftInterface    : xField  :=  tInterfaceField.Create(xtable) ;
  ftIDispatch    : xField  :=  tIDispatchField.Create(xtable) ;
  ftGuid         : xField  :=  tGuidField.Create(xtable) ;
  ftTimeStamp    : xField  :=  nil ; //tTimeStampField.Create(xtable) ;
  ftFMTBcd       : xField  :=  tFMTBcdField.Create(xtable) ;
end;

end;

procedure crer_fields_type_Float(VAR xField : TFloatField ;  xtable : TComponent ) ;
begin
                   xField  :=  tFloatField.Create(xtable) ;
                   xfield.DisplayFormat := '### ### ### ### ##0.00' ;
                   xfield.Precision := 2 ;
end;
procedure crer_fields_type_Integer(VAR xField :  TintegerField ;  xtable : TComponent ) ;
begin
                   xField  :=  tIntegerField.Create(xtable) ;
                   xfield.DisplayFormat := '### ### ### ### ###' ;
end;




end.


