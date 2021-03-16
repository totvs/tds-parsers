#include "FiveWin.Ch"
#include "Folder.ch"
#include "cfgx032.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ CFGx032  ³ Autor ³ Wagner Xavier         ³ Data ³ 14.07.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Criacao de Empresas                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ CFGX032(void)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Sem Argumentos                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Configurador   ³ Fun‡†o Relacionada ³ Entrada Dados (Todos)³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function CFGx032()
	Local lRet := CfgLibEmp()

	//
	// integração com o TOTVS Obras e Projetos
	//
	If FindFunction("PMS_SM0All")
		PMS_SM0All()
	EndIf

	Return lRet

Static Function __CFGx032()
	*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	*³ Salva a Integridade dos dados de Entrada                     ³
	*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	#ifndef PROTHEUS
		Local lSavCancel:= SetCancel(.F.)
	#else
		Local lSavCancel:= .T.
	#endif
	*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	*³ Definicao de variaveis locais                                ³
	*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Local cArqSx2,cIndSx2,lCdxAxs := .F.
	Local nOpc:=0,aEmpresa := {},nEmp,nOpt:=0,oDlg
	Local nTpRur := 1
	Local cPaisCGC  := Rtrim(RetTitle("A1_CGC"))
	Local cPaisTipo := STR0055+" - "+cPaisCGC
	Local cPaisPict := X3Picture("A1_CGC")

	Local GetList := {}
	Local cCodEmp:="  ",cFilEmp:="  ",cEstCob:="  ",cEstEnt:="  "
	Local cNomeReduz:=cNomeFil:=Space(15)
	Local cNomeCom:=Space(40)
	Local cEndCob:=cEndEnt:=Space(30)
	Local cBairCob := cBairEnt := Space(20)
	Local cCompCob := cCompEnt := Space(12)
	Local cCidCob:=cCidEnt:=Space(20)
	Local cCepCob:=cCepEnt:=Space( 8)
	Local cCGC:=cInscr:=cFone:=cFax:=Space(14)
	Local cEquip:=" ",cCorAnt,cLiber:="",cAutoriz:="   ",cTelAnt,cTelAnt1,cValid:=""
	Local cTpRur:= " "
	Local cFPAS   :=  Space(4)
	Local cAcTrab :=  Space(8)
	Local cCNAE   :=  Space(5)
	Local nInsc := 1,oSay, lMudou
	Local cCodMun := Space(7),cNatJur := Space(4),cDtBase := Space(2),nNumProp := 0,lModEnd := .F.,lModInsc :=.F.,cCausa:=" ",cInscAnt := Space(14)
	Local cTelImp :=Space(22),cFaxImp:=Space(22),cTelContat:=Space(22),cFaxContat:=Space(22)
	Local nImpCon:=1,cCodZose:=Space(12),cDesZoSe:=Space(30),cCodAtv:=space(5),cInscSuf:=Space(12), i

	lCdxAxs := Iif(RetIndExt() == ".CDX",.t.,.f.)

	*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	*³ Aguarda Liberacao de Arquivos por outras estacoes para abrir SX2 Exclusivo	 ³
	*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	cArqSx2 := "SX2" + SM0->M0_CODIGO + "0"
	cIndSx2 := cArqSx2
	If !OpenSX2Excl(cArqSx2,cIndSx2)
		Finaliza(lSavCancel)
		Return
	EndIf
	aEmpresa := {}
	Select SM0
	Go Top
	DBEVAL({|| AADD(aEmpresa,{M0_CODIGO,M0_CODFIL,M0_NOME,M0_FILIAL})})

	DEFINE MSDIALOG oDlg FROM 0,0 TO 177,400 TITLE STR0001 PIXEL  // "Cadastro de Empresas"

	@5,5 LISTBOX oLbx FIELDS HEADER STR0002,STR0003,STR0004,STR0005 SIZE 163,78 OF oDlg PIXEL;  // "Emp"  ### "Fil" ### "Empresa" ### "Filial"
	ON DBLCLICK (nEmp:=oLbx:nAt,nOpc:=2,oDlg:End())
	oLbx:SetArray(aEmpresa)
	oLbx:bLine := { || {aEmpresa[oLbx:nAt,1],aEmpresa[oLbx:nAt,2],aEmpresa[oLbx:nAt,3],aEmpresa[oLbx:nAt,4] }}

	DEFINE SBUTTON FROM 8 ,170 TYPE 4  ENABLE OF oDlg PIXEL ACTION (nEmp:=0,nOpc:=1,oDlg:End())
	DEFINE SBUTTON FROM 21,170 TYPE 11 ENABLE OF oDlg PIXEL ACTION (nEmp:=oLbx:nAt,nOpc:=2,oDlg:End())
	DEFINE SBUTTON FROM 33,170 TYPE 3  ENABLE OF oDlg PIXEL ACTION (nEmp:=oLbx:nAt,nOpc:=3,Iif(!(aEmpresa[nEmp,1]==cEmpAnt .and. aEmpresa[nEmp,2]==cFilAnt),oDlg:End(),(nOpc:=0,Help("",1,"NOPERMIT"))))
	DEFINE SBUTTON FROM 45,170 TYPE 2  ENABLE OF oDlg PIXEL ACTION (nEmp:= 0,nOpc:=0,oDlg:End())

	ACTIVATE MSDIALOG oDlg CENTERED

	If nOpc == 0
		Finaliza(lSavCancel)
		Return
	EndIf

	If nOpc != 1
		DbSeek(aEmpresa[nEmp,1]+aEmpresa[nEmp,2])
		cCodEmp   :=M0_CODIGO
		cFilEmp   :=M0_CODFIL
		cEstCob   :=M0_ESTCOB
		cEstEnt   :=M0_ESTENT
		cNomeReduz:=M0_NOME
		cNomeFil  :=M0_FILIAL
		cNomeCom  :=M0_NOMECOM
		cEndCob   :=M0_EndCOB
		cEndEnt   :=M0_EndENT
		cCidCob   :=M0_CIDCOB
		cCidEnt   :=M0_CIDENT
		cBairCob  :=M0_BAIRCOB
		cBairEnt  :=M0_BAIRENT
		cCepCob   :=M0_CEPCOB
		cCepEnt   :=M0_CEPENT
		cCGC      :=M0_CGC
		cInscr    :=M0_INSC
		cFone     :=M0_TEL
		cFax      :=M0_FAX
		cEquip    :=M0_EQUIP
		cTpRur    :=M0_PRODRUR
		cNatJur   :=M0_NATJUR
		cDtBase   :=M0_DTBASE
		nNumProp  :=M0_NUMPROP
		lModEnd   :=Iif(M0_MODEnd== "S",.T.,.F.)
		lModInsc  :=Iif(M0_MODINSC=="S",.T.,.F.)
		cCausa    :=M0_CAUSA
		cInscAnt  :=M0_INSCANT
		cCodMun   :=M0_CODMUN
		nInsc     :=M0_TPINSC
		cFPAS     :=M0_FPAS
		cCNAE     :=M0_CNAE
		cAcTrab   :=M0_ACTRAB
		cCompCob  :=M0_COMPCOB
		cCompEnt  :=M0_COMPENT
		nTpRur    :=Iif (cTpRur == "F",1,Iif(cTpRur=="J",2,3))
		cLiber    :=M0_SEQUENCE
		cTelImp   :=M0_TEL_IMP
		cFaxImp   :=M0_FAX_IMP
		cTelContat:=M0_TEL_PO
		cFaxContat:=M0_FAX_PO
		nImpCon   :=Val(M0_IMP_CON)
		cCodZose  :=M0_CODZOSE
		cDesZoSe  :=M0_DESZOSE
		cCodAtv   :=M0_COD_ATV
		cInscSuf  :=M0_INS_SUF
	Else
		If FindFunction("FWSizeFilial")
			cFilEmp := Space(FWSizeFilial())
		EndIf
	EndIf

	lConfirma := .F.
	aTitulo  := {STR0006,STR0007,STR0008,STR0009}  // "Dados Gerais" ### "Endere‡os"  ### "Complementos" ### "Adicionais"
	aPages := {"CFGX032A","CFGX032B","CFGX032C","CFGX032D"}

	DEFINE MSDIALOG oDlg TITLE STR0001 FROM 00,00 TO 320,550 OF oMainWnd PIXEL // RESOURCE "CFGX032F"

	oFolder := TFolder():New(3,3,aTitulo, aPages,oDlg,,,, .T.,.F.,270,140,)

	For i:= 1 to Len(oFolder:aDialogs)
		oFolder:aDialogs[i]:oFont := oDlg:oFont
	Next


	*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	*³ DEFINICAO DO PRIMEIRO FOLDER 1 	 ³
	*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	@ 05,05 SAY STR0020 PIXEL OF oFolder:aDialogs[1]
	@ 15,05 MSGET oCodEmp VAR cCodEmp  SIZE 20,10 PIXEL OF oFolder:aDialogs[1] PICTURE "@!";
		VALID !Empty(cCodEmp) .and. Len(AllTrim(cCodEmp))==2  WHEN (nOpc == 1)

	@ 05,30 SAY STR0021 PIXEL OF oFolder:aDialogs[1]
	@ 15,30 MSGET oFilEmp VAR cFilEmp  SIZE 25,10 PIXEL OF oFolder:aDialogs[1] PICTURE "@!";
		VALID !Empty(cFilEmp) .And. ChkEmp(cCodEmp,cFilEmp,nOpc) .and. Len(AllTrim(cFilEmp))==2 WHEN (nOpc == 1)

	@ 05,60 SAY STR0022 PIXEL OF oFolder:aDialogs[1]
	@ 15,60 MSGET oNomeReduz VAR cNomeReduz  SIZE 70,10 PIXEL OF oFolder:aDialogs[1]  PICTURE "@!";
		VALID !Empty(cNomeReduz) WHEN (nOpc != 3)

	@ 05,135 SAY STR0023 PIXEL OF oFolder:aDialogs[1]
	@ 15,135 MSGET oNomeFil VAR cNomeFil  SIZE 70,10 PIXEL OF  oFolder:aDialogs[1]  PICTURE "@X";
		VALID !Empty(cNomeFil)	WHEN (nOpc != 3)

	@ 30,05 SAY STR0024 PIXEL OF oFolder:aDialogs[1]
	@ 40,05 MSGET oNomeCom VAR cNomeCom  SIZE 145,10 PIXEL OF  oFolder:aDialogs[1];
		WHEN (nOpc != 3)

	@ 55,05 SAY STR0025 PIXEL OF oFolder:aDialogs[1]
	@ 65,05 MSGET oFone VAR cFone  SIZE 70,10 PIXEL OF oFolder:aDialogs[1]  PICTURE "@X";
		WHEN (nOpc != 3)

	@ 55,80 SAY STR0026 PIXEL OF oFolder:aDialogs[1]
	@ 65,80 MSGET oFax VAR cFax  SIZE 70,10 PIXEL OF oFolder:aDialogs[1]  PICTURE "@X";
		WHEN (nOpc != 3)

	@ 55,155 SAY STR0027 PIXEL OF oFolder:aDialogs[1]
	@ 65,155 MSGET oEquip VAR cEquip  SIZE 10,10 PIXEL OF oFolder:aDialogs[1]  PICTURE "@X";
		WHEN (nOpc != 3)

	@ 80,05 SAY cPaisCGC PIXEL OF oFolder:aDialogs[1]
	@ 90,05 MSGET oCGC VAR cCGC  SIZE 70,10 PIXEL OF oFolder:aDialogs[1]   PicTure cPaisPict;
		WHEN (nOpc != 3)

	@ 80,80 SAY STR0029 PIXEL OF oFolder:aDialogs[1]
	@ 90,80 MSGET oInscr VAR cInscr  SIZE 70,10 PIXEL OF oFolder:aDialogs[1] Picture "@X";
		WHEN (nOpc != 3)

	*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	*³ DEFINICAO DO SEGUNDO  FOLDER 2 	 ³
	*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	@ 3, 2 TO 60, 265 LABEL STR0053 OF oFolder:aDialogs[2] PIXEL

	@ 10, 6 SAY oNome PROMPT STR0030 PIXEL OF oFolder:aDialogs[2] //"Rua/Avenida"
	@ 20, 6 MSGET oEndEnt VAR cEndEnt SIZE 65,10 PIXEL OF oFolder:aDialogs[2]  PICTURE "@X";
		WHEN (nOpc != 3)

	@ 10,75 SAY STR0031 PIXEL OF oFolder:aDialogs[2]
	@ 20,75 MSGET oCompEnt VAR cCompEnt SIZE 40,10 PIXEL OF oFolder:aDialogs[2] PICTURE "@X";
		WHEN  (nOpc != 3)

	@ 10,120 SAY STR0032 PIXEL OF oFolder:aDialogs[2]
	@ 20,120 MSGET oBairEnt VAR cBairEnt SIZE 56,10 PIXEL OF oFolder:aDialogs[2] PICTURE "@X";
		WHEN (nOpc != 3)

	@ 35,6 SAY STR0033 PIXEL OF oFolder:aDialogs[2]
	@ 45,6 MSGET oCidEnt VAR cCidEnt SIZE 65,10 PIXEL OF oFolder:aDialogs[2]  PICTURE "@X";
		WHEN (nOpc != 3)

	@ 35,75 SAY STR0034 PIXEL OF oFolder:aDialogs[2]
	@ 45,75 MSGET oEstEnt VAR cEstEnt SIZE 10,10 PIXEL OF oFolder:aDialogs[2]  PICTURE "@X";
		WHEN (nOpc != 3)

	@ 35,120 SAY STR0035 PIXEL OF oFolder:aDialogs[2]
	@ 45,120 MSGET oCepEnt VAR cCepEnt SIZE 30,10 PIXEL OF oFolder:aDialogs[2]  PICTURE "@X";
		WHEN (nOpc != 3)

	@ 63,2 TO 125,265 LABEL STR0054 OF oFolder:aDialogs[2] PIXEL

	@ 70,6 SAY STR0030 PIXEL OF oFolder:aDialogs[2]
	@ 80,6 MSGET oEndCob VAR cEndCob SIZE 65,10 PIXEL OF oFolder:aDialogs[2]  PICTURE "@X";
		WHEN (nOpc != 3)

	@ 70,75 SAY STR0031 PIXEL OF oFolder:aDialogs[2]
	@ 80,75 MSGET oCompCob VAR cCompCob SIZE 40,10 PIXEL OF oFolder:aDialogs[2] PICTURE "@X";
		WHEN (nOpc != 3)

	@ 70,120 SAY STR0032 PIXEL OF oFolder:aDialogs[2]
	@ 80,120 MSGET oBairCob VAR cBairCob SIZE 56,10 PIXEL OF oFolder:aDialogs[2] PICTURE "@X";
		WHEN (nOpc != 3)

	@ 095,6 SAY STR0033 PIXEL OF oFolder:aDialogs[2]
	@ 105,6 MSGET oCidCob VAR cCidCob SIZE 65,10 PIXEL OF oFolder:aDialogs[2]  PICTURE "@X";
		WHEN (nOpc != 3)

	@ 095,75 SAY STR0034 PIXEL OF oFolder:aDialogs[2]
	@ 105,75 MSGET oEstCob VAR cEstCob SIZE 10,10 PIXEL OF oFolder:aDialogs[2]  PICTURE "@X";
		WHEN (nOpc != 3)

	@ 095,120 SAY STR0035 PIXEL OF oFolder:aDialogs[2]
	@ 105,120 MSGET oCepCob VAR cCepCob SIZE 30,10 PIXEL OF oFolder:aDialogs[2]  PICTURE "@X";
		WHEN (nOpc != 3)

	*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	*³ DEFINICAO DO TERCEIRO FOLDER 3 	 ³
	*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	@ 15,5 RADIO oInsc VAR nInsc  ITEMS STR0062,cPaisCGC,STR0064,STR0065;
		SIZE 56,9 OF oFolder:aDialogs[3] PIXEL WHEN (nOpc != 3)

	@ 3,2 TO 60, 65 LABEL STR0055 OF oFolder:aDialogs[3] PIXEL

	@ 80,5 RADIO oTpRur VAR ntpRur ITEMS STR0066,STR0067,STR0068 ;
		SIZE 58,9 PIXEL OF oFolder:aDialogs[3];
		ON CHANGE (cTpRur := Iif(nTpRur == 1,"F",Iif(nTpRur==2,"J","L")));
		WHEN (nOpc != 3)

	@ 65,2 TO 125, 65  LABEL STR0056 OF oFolder:aDialogs[3]  PIXEL

	@ 10,75 SAY STR0036 PIXEL OF oFolder:aDialogs[3]
	@ 20,75 MSGET oFPAS VAR cFPAS SIZE 50,9 PIXEL OF oFolder:aDialogs[3];
		PICTURE "@!" WHEN  (nOpc != 3)

	@ 10,130 SAY STR0040 PIXEL OF oFolder:aDialogs[3]
	@ 20,130 MSGET oNatJur VAR cNatJur SIZE 50,9 PIXEL OF oFolder:aDialogs[3];
		PICTURE "@!" WHEN (nOpc != 3)

	@ 10,190 SAY STR0038 PIXEL OF oFolder:aDialogs[3]
	@ 20,190 MSGET oDtbase VAR cDtBase SIZE 15,10 PIXEL OF oFolder:aDialogs[3];
		PICTURE "99" WHEN (nOpc != 3)

	@ 35,75 SAY STR0037 PIXEL OF oFolder:aDialogs[3]
	@ 45,75 MSGET oCNAE VAR cCNAE SIZE 50,9 PIXEL OF oFolder:aDialogs[3];
		PICTURE "@!" WHEN (nOpc != 3)

	@ 35,130 SAY STR0041 PIXEL OF oFolder:aDialogs[3]
	@ 45,130 MSGET oAcTrab VAR cAcTrab SIZE 50,9 PIXEL OF oFolder:aDialogs[3];
		PICTURE "@!" WHEN (nOpc != 3)

	@ 35,190 SAY STR0039 PIXEL OF oFolder:aDialogs[3]
	@ 45,190 MSGET oNumProp VAR nNumProp SIZE 15,10 PIXEL OF oFolder:aDialogs[3];
		PICTURE "99" WHEN (nOpc != 3)

	@ 65,75 CHECKBOX oModEnd VAR lModEnd PROMPT STR0069 SIZE 50, 10 PIXEL OF oFolder:aDialogs[3]
	oModEnd:oFont:=oDlg:oFont

	@ 82,75 CHECKBOX oModInsc VAR lModInsc PROMPT cPaisTipo SIZE 76, 10 PIXEL OF oFolder:aDialogs[3];
		ON CLICK (cCausa := Iif(!lModInsc," ",cCausa),cInscAnt := Iif(!lModInsc,Space(14),cInscAnt),oCausa:Refresh(.F.),oInscAnt:Refresh(.F.))
	oModInsc:oFont:=oDlg:oFont

	@ 100,75 SAY STR0043 PIXEL OF oFolder:aDialogs[3]
	@ 110,75 MSGET oCausa  VAR cCausa  SIZE 50,9 PIXEL OF oFolder:aDialogs[3];
		PICTURE "@!" WHEN (nOpc != 3)

	@ 100,130 SAY STR0044 PIXEL OF oFolder:aDialogs[3]
	@ 110,130 MSGET oInscAnt VAR cInscAnt SIZE 55,10 PIXEL OF oFolder:aDialogs[3];
		PICTURE "@!" WHEN (nOpc != 3)

	@ 100,190 SAY STR0042 PIXEL OF oFolder:aDialogs[3]
	@ 110,190 MSGET oCodMun VAR cCodMun SIZE 70,10 PIXEL OF oFolder:aDialogs[3];
		PICTURE "@!" WHEN (nOpc != 3)

	@ 3, 70 TO 125, 265 LABEL STR0008 OF oFolder:aDialogs[3] PIXEL

	*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	*³ DEFINICAO DO QUARTO  FOLDER 4 	 ³
	*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	@ 3,2 TO 40, 130 LABEL STR0058 OF oFolder:aDialogs[4] PIXEL

	@ 10,5  SAY STR0025 PIXEL OF oFolder:aDialogs[4]
	@ 20,5  MSGET cTelimp SIZE 50,10 PIXEL OF oFolder:aDialogs[4];
		PICTURE "@!" WHEN (nOpc != 3)

	@ 10,60 SAY STR0046 PIXEL OF oFolder:aDialogs[4]
	@ 20,60 MSGET cFaxImp SIZE 50,10 PIXEL OF oFolder:aDialogs[4];
		PICTURE "@!" WHEN (nOpc != 3)

	@ 43,2 TO 75, 130 LABEL STR0059 OF oFolder:aDialogs[4] PIXEL

	@ 50,5 SAY STR0047 PIXEL OF oFolder:aDialogs[4]
	@ 60,5 MSGET cTelContat SIZE 50,10 PIXEL OF oFolder:aDialogs[4];
		PICTURE "@!" WHEN (nOpc != 3)

	@ 50,60 SAY STR0048 PIXEL OF oFolder:aDialogs[4]
	@ 60,60 MSGET cFaxContat SIZE 50,10 PIXEL OF oFolder:aDialogs[4];
		PICTURE "@!" WHEN (nOpc != 3)

	@ 86,5 SAY  STR0049	PIXEL OF oFolder:aDialogs[4]
	@ 96,5 MSGET cCodZoSe SIZE 50,10 PIXEL OF oFolder:aDialogs[4];
		PICTURE "@!" WHEN (nOpc != 3)

	@ 86,60 SAY STR0050 PIXEL OF oFolder:aDialogs[4]
	@ 96,60 MSGET cDesZoSe SIZE 65,10 PIXEL OF oFolder:aDialogs[4];
		PICTURE "@!" WHEN (nOpc != 3)
	@ 78,2 TO 115, 130 LABEL STR0060 OF oFolder:aDialogs[4]  PIXEL

	@ 3,135 TO 40, 200 LABEL STR0061 OF oFolder:aDialogs[4] PIXEL

	@ 12,140 RADIO nImpCon ITEMS STR0071,STR0072 SIZE 50,9 PIXEL OF oFolder:aDialogs[4];
		WHEN (nOpc != 3)

	@ 50,139 SAY STR0051 PIXEL OF oFolder:aDialogs[4]
	@ 60,139 MSGET cCodAtv SIZE 50,10 PIXEL OF oFolder:aDialogs[4];
		PICTURE "@!" WHEN (nOpc != 3)

	@ 86,139 SAY STR0052 PIXEL OF oFolder:aDialogs[4]
	@ 96,139 MSGET cInscSuf SIZE 50,10 PIXEL OF oFolder:aDialogs[4];
		PICTURE "@!" WHEN (nOpc != 3)

	@ 43,135 TO 116, 200 LABEL "" OF oFolder:aDialogs[4]  PIXEL

	//----------------- botoes de confirma e cancela  ----------------//
	DEFINE SBUTTON FROM 145,210 TYPE 1  ENABLE OF oDlg PIXEL ACTION (lConfirma := .T.,oDlg:End())
	DEFINE SBUTTON FROM 145,245 TYPE 2  ENABLE OF oDlg PIXEL ACTION (lConfirma := .F.,oDlg:End())

	ACTIVATE MSDIALOG oDlg	CENTERED

	If lConfirma
		If nOpc != 3
			cLiber := ""
			cValid := ""
			cLiber := CriaAut(cCodEmp,cFilEmp,cNomeReduz,cNomeFil)
			cLiber+=cValid
		EndIf
		If nOpc == 3
			Select SM0
			//
			// Integracao TOTVS Obras e Projeto com Erp Protheus, exclusão da filial no RM
			//
			If FindFunction("PMS_SM0")
				PMS_SM0(256)
			EndIf
			RecLock("SM0",.F.)
			DbDelete()
			MsUnlock()
			Finaliza(lSavCancel)
			Return
		ElseIf nOpc == 1
			If Empty(cNomeReduz) .or.Empty(cNomeFil)
				Help(1,"","SEMNOME")
				Finaliza(lSavCancel)
				Return
			EndIf
		EndIf

		lMudou := .f.
		If nOpc == 2
			lImprime := .T.
			If (cNomeReduz != SM0->M0_NOME) .or. (cNomeFil != SM0->M0_FILIAL)
				lImprime:=ImprFax(cCodEmp,cFilEmp,cNomeCom,cNomeReduz,cNomeFil,cCGC,cFone,cLiber,cEndCob,cCidCob,cEstCob,cCepCob,.T.)  //Impressao do relatorio
				lMudou := .t.
			EndIf
		Else
			lImprime:=ImprFax(cCodEmp,cFilEmp,cNomeCom,cNomeReduz,cNomeFil,cCGC,cFone,cLiber,cEndCob,cCidCob,cEstCob,cCepCob,.T.)  //Impressao do relatorio
			lMudou :=.t.
		EndIf

		If lImprime
			If nOpc == 1
				*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				*³ VerIfica se sera criada uma nova empresa                     ³
				*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				Select SM0
				If lImprime
					Seek cCodEmp
					If EOF()
						CriaArqs(cCodEmp,nOpc)
					EndIf
					RecLock("SM0",.T.)
				EndIf
			Else
				RecLock("SM0",.F.)
			EndIf
			Select SM0
			REPLACE M0_CODIGO   With cCodEmp
			REPLACE M0_CODFIL   With cFilEmp
			REPLACE M0_ESTCOB   With cEstCob
			REPLACE M0_ESTENT   With cEstEnt
			REPLACE M0_NOME     With cNomeReduz
			REPLACE M0_FILIAL   With cNomeFil
			REPLACE M0_NOMECOM  With cNomeCom
			REPLACE M0_EndCOB   With cEndCob
			REPLACE M0_EndENT   With cEndEnt
			REPLACE M0_COMPCOB  With cCompCob
			REPLACE M0_COMPENT  With cCompEnt
			REPLACE M0_CIDCOB   With cCidCob
			REPLACE M0_CIDENT   With cCidEnt
			REPLACE M0_BAIRCOB  With cBairCob
			REPLACE M0_BAIRENT  With cBairEnt
			REPLACE M0_CEPCOB   With cCepCob
			REPLACE M0_CEPENT   With cCepEnt
			REPLACE M0_CGC      With cCGC
			REPLACE M0_INSC     With cInscr
			REPLACE M0_TEL      With cFone
			REPLACE M0_FAX      with cFax
			REPLACE M0_EQUIP    With cEquip
			If lMudou
				REPLACE M0_SEQUENC  With cLiber
			EndIf
			REPLACE M0_PRODRUR  With cTpRur
			REPLACE M0_NATJUR   With cNatJur
			REPLACE M0_DTBASE   With cDtBase
			REPLACE M0_NUMPROP  With nNumProp
			REPLACE M0_MODEnd   With Iif(lModEnd,"S","N")
			REPLACE M0_MODINSC  With Iif(lModInsc,"S","N")
			REPLACE M0_CAUSA    With Iif(!lModInsc," ",cCausa)
			REPLACE M0_INSCANT  With Iif(!lModInsc,Space(14),cInscAnt)
			REPLACE M0_CODMUN   With cCodMun
			REPLACE M0_TPINSC   With nInsc
			REPLACE M0_FPAS     With cFPAS
			REPLACE M0_CNAE     With cCNAE
			REPLACE M0_ACTRAB   With cAcTrab
			REPLACE M0_TEL_IMP  With cTelImp
			REPLACE M0_FAX_IMP  With cFaxImp
			REPLACE M0_TEL_PO   With cTelcontat
			REPLACE M0_FAX_PO   With cFaxContat
			REPLACE M0_IMP_CON  With Str(nImpCon,1,0)
			REPLACE M0_CODZOSE  With cCodZose
			REPLACE M0_DESZOSE  With cDesZose
			REPLACE M0_COD_ATV  With cCodAtv
			REPLACE M0_INS_SUF With cInscSuf
			MsUnlock()
		EndIf

		//
		// Integracao TOTVS Obras e Projeto com Erp Protheus, atualização de todas as filiais no RM
		//
		If FindFunction("PMS_SM0All")
			PMS_SM0All(128)
		EndIf
	EndIf
	Finaliza(lSavCancel)
	Return

Static Function Finaliza(lSavCancel)
	Local lCdxAxs := .F.
	lCdxAxs := Iif(RetIndExt() == ".CDX",.t.,.f.)

	#ifndef PROTHEUS
		*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		*³ Restaura a Integridade dos Dados                             ³
		*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		SetCanCel(lSavCancel)
	#endif

	DbSelectArea("SX2")	// Fecha Arquivo Em Modo Exclusivo
	dbCloseArea()
	// Abre Arquivo em Modo Compartilhado
	DbSelectArea("SM0")
	DbSeek(cEmpAnt+cFilAnt)
	cIndSx2 := Iif(lCdxAxs,"SX2"+cEmpAnt+"0","SX2"+cEmpAnt+"01")
	dbUseArea( .T.,,("SX2"+cEmpAnt+"0"), "SX2", If(.F. .OR. .T., !.F., NIL), .F. )
	dbSetIndex( cIndSx2 )

	Return .T.

	/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Fun‡…o    ³ ChkEmp   ³ Autor ³ Wagner Xavier         ³ Data ³ 06/07/92 ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡…o ³ VerIfica se a empresa ja esta cadastrada                   ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Sintaxe   ³ Cx032Emp(Codigo da Empresa,Filial)                         ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³ Uso      ³ Generico                                                   ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	/*/
FuncTion ChkEmp(cEmpresa,jFilial,nOpc)
	Seek cEmpresa+jFilial
	If nOpc == 1
		If Found()
			Help(" ",1,"JA EXISTE")
			Return (.F.)
		EndIf
	Else
		If !Found()
			Help(" ",1,"NAO EXISTE")
			Return (.F.)
		EndIf
	EndIf
	Return (.T.)

	/*/
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Fun‡…o    ³ CriaArqs ³ Autor ³ Wagner Xavier         ³ Data ³          ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡…o ³ Cria os arquivos necessarios para utilizacao da empresa    ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Sintaxe e ³ CriaArqs()                                                 ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Parametros³ Codigo da empresa a ser criada                             ³±±
	±±³          ³                                                            ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³ Uso      ³ Generico                                                   ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	/*/
Function CriaArqs(cCodEmp,nOpc)

	Local cPath,cSx2Nome,nOpt
	Local oLbx,bAction,nRec,odlg

	Private aSX2:={}

	DbSelectArea("SX2")
	Set Filter To
	Set Order TO 1
	Go Top

	While !Eof()
		If SX2->X2_CHAVE $ "SR5/SYN/SYO"
			If X2_CHAVE == "SR5"
				cSx2Nome := "SIGAGPE  "
				cPath    :=  "\"+AllTrim(Curdir()) +"\"
			ElseIf X2_CHAVE == "SYN"
				cSx2Nome :=  "SIGAEYN "
				cPath    :=  "\"+AllTrim(Curdir()) +"\"
			ElseIf X2_CHAVE == "SYO"
				cSx2Nome :=  "SIGAEYO "
				cPath    :=  "\"+AllTrim(Curdir()) +"\"
			EndIf
		Else
			cSx2Nome := SubStr(x2_arquivo,1,3)+cCodEmp+"0   "
			cPath    := AllTrim(x2_path)
		EndIf
		cPath +=    Space(31 - Len(cPath))
		AADD(aSX2, { x2_chave, cPath, cSX2Nome, x2_nome, x2_modo, x2_tts, x2_rotina, X2_NOMESPA, X2_NOMEENG})
		DbSkip()
	End

	nOpt:=1
	DEFINE MSDIALOG oDlg FROM  150,93 TO 366,542 TITLE STR0010 PIXEL  //"Cadastro de Empresas"

	@15,14 LISTBOX oLbx FIELDS HEADER "Alias",STR0011,STR0012,STR0013,STR0014,STR0015 SIZE 163,76  OF oDlg PIXEL; // "Diret¢rio" ### "Arquivo" ### "Descri‡„o" ### "Modo" ### "TTS"
	ON DBLCLICK (nOpt:=oLbx:nAt,GetPath(@aSx2,nOpt),oLbx:Refresh())
	oLbx:SetArray(aSX2)
	oLbx:bLine := { || {aSx2[oLbx:nAt,1],aSx2[oLbx:nAt,2],aSx2[oLbx:nAt,3],aSx2[oLbx:nAt,4],aSx2[oLbx:nAt,5], aSx2 [oLbx:nAt,6]}}

	DEFINE SBUTTON FROM 15,186 TYPE 1  ENABLE OF oDlg ACTION (MsgMeter( {| oMeter, oText, oDlg, lEnd | CopiaArqs( oMeter, oText, oDlg, @lEnd,cCodEmp ) } ,STR0016, STR0073 ),oDlg:End())  // "Criando Arquivo ... "
	DEFINE SBUTTON FROM 28,186 TYPE 2  ENABLE OF oDlg ACTION (oDlg:End())

	ACTIVATE MSDIALOG oDlg

	REturn



Function CopiaArqs(oMeter, oText, oDlg, lEnd,cCodEmp)
	Local aFiles		:= {}
	Local cSource		:= ''
	Local cTarget		:= ''
	Local cDriver		:= ''
	Local nI			:= 0
	Local lOk			:= .T.
	Local nTam			:= 0
	Local aCampos:={{"X2_CHAVE"   ,"C" ,  3,0 } ,;
		{"X2_PATH"	  ,"C" , 40,0 } ,;
		{"X2_ARQUIVO" ,"C" ,  8,0 } ,;
		{"X2_NOME"    ,"C" , 30,0 } ,;
		{"X2_NOMESPA" ,"C" , 30,0 } ,;
		{"X2_NOMEENG" ,"C" , 30,0 } ,;
		{"X2_DELET"   ,"N" ,  6,0 },;
		{"X2_MODO"    ,"C" ,  1,0 },;
		{"X2_TTS"     ,"C" ,  1,0 },;
		{"X2_ROTINA"  ,"C" , 40,0 } }

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Cria lista dos arquivos                                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	AAdd( aFiles, 'SX1' )
	AAdd( aFiles, 'SX3' )
	AAdd( aFiles, 'SX5' )
	AAdd( aFiles, 'SX6' )
	AAdd( aFiles, 'SX7' )
	AAdd( aFiles, 'SX9' )
	AAdd( aFiles, 'SXB' )
	AAdd( aFiles, 'SXA' )
	AAdd( aFiles, 'SXG' )
	AAdd( aFiles, 'SXD' )
	AAdd( aFiles, 'QMF' )
	AAdd( aFiles, 'QA6' )
	AAdd( aFiles, 'QA7' )
	AAdd( aFiles, 'QED' )
	AAdd( aFiles, 'QEE' )
	AAdd( aFiles, 'QEF' )
	AAdd( aFiles, 'QEG' )
	AAdd( aFiles, 'QEJ' )
	AAdd( aFiles, 'QEX' )
	AAdd( aFiles, 'QF1' )
	AAdd( aFiles, 'QPD' )
	AAdd( aFiles, 'QPE' )
	AAdd( aFiles, 'QPF' )
	AAdd( aFiles, 'QPG' )
	AAdd( aFiles, 'QPX' )
	AAdd( aFiles, 'QQB' )

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Configura regua                                              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	oMeter:nTotal := Len( aFiles ) + 1

	For nI := 1 To Len( aFiles )

		cSource	:= aFiles [nI] + cEmpAnt + '0'
		cTarget	:= aFiles [nI] + cCodEmp + '0'
		cDriver := RetDrvFile( aFiles [nI] )

		oText:SetText( STR0016 + ' ' + cTarget )  // "Criando Arquivo ... "
		bAction:={|| oMeter:Set(nI), SysRefresh(), !lEnd}
		Eval(bAction)

		If ( cDriver == 'TOPCONN' ) .Or. ( cDriver == 'BTVCDX' )

			If ( aFiles [nI] == 'SX5' ) .Or. ( MsFile( cSource, , cDriver ) )
				lOk := MsCopyFile( cSource, cTarget )
			EndIf

		Else
			cSource	+= GetDBExtension()
			cTarget	+= GetDBExtension()
			lOk	:= _CopyFile( cSource, cTarget )
		EndIf

		If ( ! lOk )
			Final ( 'Nao foi possivel criar o arquivo ' + cTarget )
		EndIf

	Next

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ SX2                                                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	cTarget	:= 'SX2' + cCodEmp + '0'
	cDriver := RetDrvFile( 'SX2' )

	oText:SetText( STR0016 + ' ' + cTarget )  // "Criando Arquivo ... "
	bAction:={|| oMeter:Set(Len(aFiles)+1), SysRefresh(), !lEnd}
	Eval(bAction)

	DbCreate(cTarget, aCampos)
	DbUseArea( .T., cDriver, cTarget, 'X2D', .T., .F. )

	For nI:=1 To Len( aSX2 )

		RecLock('X2D', .T.)
		Replace X2_CHAVE   With aSX2[nI,1]
		nTam:=Len(AllTrim(aSX2[nI,2]))
		If Substr(aSx2[nI,2],nTam,1) != "\"
			cPath:=aSX2[nI,2]+"\"
		Else
			cPath:=aSX2[nI,2]
		EndIf
		Replace X2_PATH    With cPath
		Replace X2_ARQUIVO With aSX2[nI,3]
		Replace X2_NOME    With aSX2[nI,4]
		Replace X2_DELET   With 0
		Replace X2_MODO    With aSX2[nI,5]
		Replace X2_TTS     WITH aSX2[nI,6]
		Replace X2_ROTINA  WITH aSX2[nI,7]
		Replace X2_NOMESPA With aSX2[nI,8]
		Replace X2_NOMEENG With aSX2[nI,9]
		MsUnlock()
	Next

	DbSelectArea('X2D')
	DbCloseArea()

	Return

Static Function GetPath(aSx2,Pos)
	Local cDiret,cArquivo,oDlg

	If aSx2[Pos,1] $ "SR5/SYN/SYO"
		Help(" ",1,"NOALTSR5")
		Return Nil
	EndIf


	cDiret  :=ASX2[pos,2]
	cArquivo:=aSX2[pos,3]

	DEFINE MSDIALOG oDlg FROM  5,5 TO 18,50 TITLE STR0017 // "Arquivos de Dados"

	@ 6, 17 TO 81, 127 OF oDlg  PIXEL
	@ 16, 26 SAY STR0019 SIZE 62, 7 OF oDlg PIXEL  // "&Diret¢rio :"
	@ 26, 26 MSGET cDiret SIZE 79, 10 OF oDlg PIXEL  Valid SubStr(cDiret,1,1)=="\" .And. !Empty(cDiret)
	@ 48, 26 SAY STR0018 SIZE 37, 7 OF oDlg PIXEL  // "&Arquivo :"
	@ 60, 26 MSGET cArquivo SIZE 79, 10 OF oDlg PIXEL  Valid !Empty(cArquivo)

	DEFINE SBUTTON FROM 11, 140 TYPE 1 ACTION (aSX2[pos,2]:=cDiret,aSx2[pos,3]:=cArquivo,oDlg:End()) ENABLE OF oDlg
	DEFINE SBUTTON FROM 26, 140 TYPE 2 ACTION oDlg:End() ENABLE OF oDlg

	ACTIVATE MSDIALOG oDlg

	Return Nil


	// ------------------------------------------------------

	Static ;
	Function RetDrvFile ( cAlias )

	Local cDriver, cDriveSX := __cRdd

	If ( Empty( cAlias ) )
		Return( __cRdd )
	EndIf

	#ifdef TOP
		cDriveSX := "DBFCDX"
	#else
		#ifdef BTV
			cDriveSX := "DBFCDX"
		#endif
	#endif

	If cAlias $ 'SM0/SX1/SX6'
		cDriver := 'DBFCDX'
	ElseIf cAlias == 'SX5'
		cDriver := __cRdd
	ElseIf 'SX' $ cAlias .Or. cAlias == 'SIX'
		cDriver := cDriveSX
	ElseIf cAlias $ 'SH7/SH9'
		#ifdef TOP
			cDriver := 'DBFCDX'
		#else
			cDriver := __cRdd
		#endif
	Else
		cDriver := __cRdd
	EndIf

	Return( cDriver )

