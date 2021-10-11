unit main;

interface

uses  outils,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, JvPatchFile, JvComponent, JvCreateProcess, StdCtrls,
  JvExStdCtrls, JvButton, JvCtrls, JvDialogs, Buttons, JvExControls,
  JvFormWallpaper, JvCombobox, ExtCtrls, JvSpecialProgress, JvLabel,
  ComCtrls, JvExComCtrls, JvStatusBar, JvEdit, JvValidateEdit,
  JvComponentBase, JvExButtons, JvBitBtn;

type
  TForm_main = class(TForm)
    Memo1: TMemo;
    JvOpenDialog1: TJvOpenDialog;
    Cmdos: TJvCreateProcess;
    CheckBox1: TCheckBox;
    JvStatusBar1: TJvStatusBar;
    DateActuelle: TJvLabel;
    MemProgressbar: TJvSpecialProgress;
    Timermemo: TTimer;
    duree: TJvLabel;
    Panel1: TPanel;
    JvFormWallpaper4: TJvFormWallpaper;
    ComboBox: TJvComboBox;
    Edit1: TEdit;
    Ajouter_Produit: TSpeedButton;
    Backup: TSpeedButton;
    Restore: TSpeedButton;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    Label1: TLabel;
    date_gdb: TLabel;
    JvLabel1: TJvLabel;
    date_bak: TLabel;
    JvLabel2: TJvLabel;
    But_fix_erreur: TSpeedButton;
    taille_gdb: TLabel;
    taille_bak: TLabel;
    JvComboBox1: TJvComboBox;
    procedure Ajouter_ProduitClick(Sender: TObject);
    procedure ComboBoxChange(Sender: TObject);
    procedure BackupClick(Sender: TObject);
    procedure Lire_historique(Sender: TObject);
    procedure Ecrire_historique(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure RestoreClick(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure CmdosTerminate(Sender: TObject; ExitCode: Cardinal);
    procedure TimermemoTimer(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure afichier_taill(Sender: TObject);
    procedure CmdosRead(Sender: TObject; const S: String;
      const StartsOnNewLine: Boolean);
    procedure But_fix_erreurClick(Sender: TObject);
    procedure JvComboBox1Change(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }

  end;

var
  Form_main: TForm_main;
  xxtime : TTime ;
  xoperation ,xnum_lign  : string ;

implementation

{$R *.dfm}

procedure TForm_main.Ajouter_ProduitClick(Sender: TObject);
var xnomfile : string ;
begin
if JvOpenDialog1.Execute then begin
//xnomfile := JvOpenDialog1.FileName ;
  // ComboBox.Items.Add(xnomfile) ;
//   ComboBox.ItemIndex :=  ComboBox.Items.IndexOf(xnomfile) ;
//   Edit1.Text := copy(xnomfile ,1,length(xnomfile)-4 );
 //  Backup.Enabled := true
 ComboBox.Text := JvOpenDialog1.FileName ;
  ComboBoxChange(Self);
   end;
end;

procedure TForm_main.ComboBoxChange(Sender: TObject);
var xnomfile ,xext : string ;
begin
xnomfile := ComboBox.Text ;
Edit1.Text := copy(xnomfile ,1,length(xnomfile)-4 )+ '.BAK';
ComboBox.Text := xnomfile ;
if FileExists(xnomfile) then begin
   if ComboBox.Items.IndexOf(xnomfile) <0
          then ComboBox.Items.Add(xnomfile) ;
   ComboBox.ItemIndex :=  ComboBox.Items.IndexOf(xnomfile) ;
   Edit1.Text := copy(xnomfile ,1,length(xnomfile)-4 )+ '.BAK';
   Backup.Enabled := true ;
   end
   else if UpperCase(xext) <> '.BAK' then Edit1.Text := '';

if FileExists(xnomfile)
         then Backup.Enabled := true
         else Backup.Enabled := false ;
if FileExists(copy(xnomfile ,1,length(xnomfile)-4 )+ '.BAK')
         then Restore.Enabled := true
         else Restore.Enabled := false ;
afichier_taill(Self) ;
But_fix_erreur.Enabled := Backup.Enabled ;
end;

procedure TForm_main.BackupClick(Sender: TObject);
var xsource , xdistin : string ;
begin
xnum_lign :='0' ;
xoperation := ' Backup ' ;
duree.Caption := '' ;
xxtime := now ;
xsource := ComboBox.Text ;
xdistin := Edit1.Text ;
xcle :='\SOFTWARE\InterBase Corp\InterBase\CurrentVersion' ;
Cmdos.CommandLine     := cherche_reg( HKEY_LOCAL_MACHINE,'ServerDirectory' ,xcle) +
 'gbak.exe -B -V -USER sysdba -PAS masterkey "' + xsource + '"  "' + xdistin +'"'  ;
Memo1.Lines.Clear ;
if Panel1.Enabled then Panel1.Enabled := false ;
Cmdos.Run ;
end;

procedure TForm_main.But_fix_erreurClick(Sender: TObject);
var xsource  : string ;
begin
xnum_lign :='0' ;
xoperation := ' Fix Erreur ' ;
duree.Caption := '' ;
xxtime := now ;
xsource := ComboBox.Text ;
xcle :='\SOFTWARE\InterBase Corp\InterBase\CurrentVersion' ;
Cmdos.CommandLine     := cherche_reg( HKEY_LOCAL_MACHINE,'ServerDirectory' ,xcle) +
 'gfix.exe -M -I -USER sysdba -PAS masterkey "' + xsource   ;
Memo1.Lines.Clear ;
if Panel1.Enabled then Panel1.Enabled := false ;
Cmdos.Run ;
end;

procedure TForm_main.Lire_historique(Sender: TObject);
var F: Textfile;
Ch:String ;
i : integer ;
begin
if Not FileExists('C:\back_resotre_interbase_5.INI') then exit ;
   AssignFile(F, 'C:\back_resotre_interbase_5.INI'  );
   try
      Reset(F);
      while not Eof(F)do
      begin
      Readln(F,Ch);
       if  UpperCase( ExtractFileExt(Ch )) <> '.BAK' then ComboBox.Items.Add(Ch);
      end;
      ComboBox.ItemIndex := 0 ;
      ComboBoxChange(Self);
   finally
      CloseFile(F);
   end;
end;

procedure TForm_main.Ecrire_historique(Sender: TObject);
var F: Textfile;
Ch:Char;
i : integer ;
begin
   AssignFile(F, 'C:\back_resotre_interbase_5.INI'  );
   try
      Rewrite(F);
     for i:=0 to ComboBox.Items.Count-1 do
      begin
      Writeln(F,ComboBox.Items[i] );
      end;
   finally
      CloseFile(F);
   end;
end;



procedure TForm_main.FormCreate(Sender: TObject);
var xitem ,xext: string ;
begin
xitem := UpperCase(ParamStr(1)) ;
Xnomexe :='ibguard.exe' ;
XCle :='\SOFTWARE\InterBase Corp\InterBase\CurrentVersion' ;
Form_main.Caption :='Back et Restor (Base type interbase) Ver 1.4.4.0 du 2004/2010  Copyright © Lounici Abdelali' ;
Form_main.Hint :=Form_main.Caption ;
Application.Title := Form_main.Caption ;
if  InterbaseInstalled = true
              then begin
              if  not InterbaseRunning  then   StartInterbase ;
              JvOpenDialog1.Title  := 'Ouvrire fichier Interbase ' ;
              JvOpenDialog1.Filter := 'Fichier Interbase (*.GDB)|*.GDB|(*.ALI)|*.ALI';
              Lire_historique(Self);
              xext := ExtractFileExt(xitem ) ;
              if UpperCase(xext) ='.BAK'   then begin
                  Backup.Enabled := false ;
                  Restore.Enabled := true ;
                  ComboBox.Text  :=  copy(xitem ,1,length(xitem)-4 )+ '.GDB';
                  Edit1.Text     :=  xitem ;
                  end else begin
                       ComboBox.Text := xitem  ;
                       ComboBoxChange(Self);
                       end;
              CheckBox1Click(Self);
              end
              else  begin
                    MessageDlg('Inerbase server n''est pas Installer ',mtInformation,[mbOk],0) ;
                    Application.Terminate ;
                    end;
afichier_taill(Self) ;
But_fix_erreur.Enabled := Backup.Enabled ;

end;

procedure TForm_main.JvComboBox1Change(Sender: TObject);
begin
 ComboBox.TEXT := copy(ComboBox.TEXT ,1,length(ComboBox.TEXT)-4 )+ '.' + JvComboBox1.text ;
end;

procedure TForm_main.FormClose(Sender: TObject; var Action: TCloseAction);
begin
Ecrire_historique(Self);
end;
procedure TForm_main.RestoreClick(Sender: TObject);
var xsource , xdistin : string ;
begin
xnum_lign :='0' ;
xoperation := ' Restore ' ;
duree.Caption := '' ;
xxtime := now ;
xsource := ComboBox.Text ;
xdistin := Edit1.Text ;
xcle :='\SOFTWARE\InterBase Corp\InterBase\CurrentVersion' ;
Cmdos.CommandLine     := cherche_reg( HKEY_LOCAL_MACHINE,'ServerDirectory' ,xcle) +
 'gbak.exe -R -V -USER sysdba -PAS masterkey "' + xdistin + '"  "' + xsource +'"'  ;
Memo1.Lines.Clear ;
if Panel1.Enabled then Panel1.Enabled := false ;
Cmdos.Run ;
end;

procedure TForm_main.CheckBox1Click(Sender: TObject);
begin
if CheckBox1.Checked
    then begin
         CheckBox1.Caption := 'Afficher detaille' ;
         Form_main.Height := 348 ;
         Form_main.top := Form_main.top - 80 ;
         end
    else begin
         CheckBox1.Caption := 'Ne Pas Afficher le detaille';
         Form_main.Height := 198 ;
         Form_main.top := Form_main.top + 80 ;
         end;
end;

procedure TForm_main.SpeedButton1Click(Sender: TObject);
begin
close ;
end;

procedure TForm_main.CmdosTerminate(Sender: TObject; ExitCode: Cardinal);
begin
duree.Caption := FormatDateTime('hh:mm:ss',(Now - xxtime));
         if xoperation = ' Backup '
    then begin
             if MessageDlg( 'Opération du Backup et terminer '  + #13+
                            'elle a durée ' + duree.Caption + #13+
                            'voulez vous lancer Restore'
                        ,mtConfirmation,[mbNo,mbOk],0)= mrOk
               then RestoreClick(Self)
               else Panel1.Enabled := true ;
          end
    else if xoperation = ' Restore '
    then begin
              MessageDlg( 'Opération du Restore  et terminer '   + #13+
                          'elle a durée ' + duree.Caption ,mtInformation,[mbOk],0) ;
              Panel1.Enabled := true ;
         end
    else begin
              MessageDlg( 'Opération de Fixation des erreurs et terminer '   + #13+
                          'elle a durée ' + duree.Caption ,mtInformation,[mbOk],0) ;
              Panel1.Enabled := true ;
         end;
Restore.Enabled:=true ;
afichier_taill(Self) ;
end;

procedure TForm_main.TimermemoTimer(Sender: TObject);
var  xfree ,xtotal : Integer ;
xmemo :  _MEMORYSTATUS ;
begin
DateActuelle.Caption := DateTimeToStr(Now) ;
GlobalMemoryStatus(xmemo) ;
xtotal := Trunc(xmemo.dwTotalVirtual/1000000)  ;
xfree  := Trunc(xmemo.dwAvailVirtual/1000000)  ;
MemProgressbar.Maximum :=   xtotal ;
MemProgressbar.Position :=  xfree ;
MemProgressbar.Hint := FormatFloat('### ###', xfree ) + ' Mo Libre Sur '
                     + FormatFloat('### ###',xtotal ) + ' Mo'  ;
MemProgressbar.Refresh ;

end;

procedure TForm_main.SpeedButton2Click(Sender: TObject);
var xitem : integer ;
begin
if ComboBox.Items.Count <=0 then exit ;
xitem := ComboBox.ItemIndex ;
ComboBox.Items.Delete(ComboBox.ItemIndex);
ComboBox.ItemIndex := xitem ;
end;
procedure TForm_main.afichier_taill(Sender: TObject);
var xsource  ,xdist   : string ;
var xdat  ,xsiz ,xtypsiz  : string ;
begin
xtypsiz := 'Ko' ;
xsource := Form_main.ComboBox.Text ;
xdist   := Form_main.Edit1.Text ;
afichier_date_taill_fichier(xsource,xdat,xsiz ,xtypsiz );
Form_main.taille_gdb.caption  := xsiz ;
Form_main.date_gdb.Caption := xdat ;
afichier_date_taill_fichier(xdist,xdat,xsiz ,xtypsiz);
Form_main.taille_bak.Caption  := xsiz ;
Form_main.date_bak.Caption := xdat ;
end;

procedure TForm_main.CmdosRead(Sender: TObject; const S: String;
  const StartsOnNewLine: Boolean);
begin
if length(S) = 0 then exit;
xnum_lign := IntToStr(StrToInt(xnum_lign) +1) ;
Memo1.Lines.add( Complete_var(xnum_lign,'  ',4,'C') +'  '+ copy(S,6,length(S)) ) ;
Label1.Caption :=  Complete_var(xnum_lign,'  ',4,'C') +'  '+ copy(S,6,length(S)) ;
Label1.Refresh ;
end;

end.

{
echo Réparation de la base ...
gfix -m -i -user SYSDBA -password masterkey C:\Program~1\IBData.gdb
echo Extraction des données ...
gbak -g -b -z -v -l -user SYSDBA -password masterkey C:\Program~1\IBData.gdb C:\Program~1\IBData.gbk
echo Régénération automatique des données ...
gbak -c -v -z -r -user SYSDBA -password masterkey C:\Program~1\IBData.gbk C:\Program~1\IBData.gdb
}
