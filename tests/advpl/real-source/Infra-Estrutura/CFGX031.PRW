#include "FIVEWIN.CH"
#include "CFGX031.CH"

#ifdef SPANISH
	#define COLDESC1 2
	#define COLDESC2 1
	#define COLDESC3 3
#else
	#ifdef ENGLISH
		#define COLDESC1 3
		#define COLDESC2 1
		#define COLDESC3 2
	#else
		#define COLDESC1 1
		#define COLDESC2 2
		#define COLDESC3 3
	#endif
#endif

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ CFGx031  ³ Autor ³ Jorge Queiroz         ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Atualiza o Dicionario de campos disponiveis pelo usuario.  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ void CFGx031(void)                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Sem Argumentos                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Configurador   ³ Fun‡†o Relacionada ³ Entrada Dados (Todos)³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Cheyenne    ³16/12/99³25544A³ VerIficacao de cDBMS antes do GET para   ³±±
±±³            ³16/12/99³25544A³alteracao do tamanho do campo. Compatibi- ³±±
±±³            ³16/12/99³25544A³zacao com ORACLE.                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function CFGX031
	Return APCFG10()

Static Function __CFGX031

	Local cArqIni,cArqFin,cArqSX2,cIndSx2,nPos:=1
	Local lClose := .t.,cArqSx3,nArq := 1,oCpo,oUso,oOrdem,oBrow,oCbx,lUsado,lbrowse
	Local oDlg,nNew:=1,cBkp:="01",lUso:=.T.,lBrow:=.T.,lOrd:=.F.,nOpc1:=0,cTitulo
	Local oOk := LoadBitmap( GetResources(), "ENABLE" )
	Local oNo := LoadBitmap( GetResources(), "LBNO" )
	Local oOk1 :=LoadBitmap( GetResources(), "DISABLE" )
	Local lRet := .F.,lModStr := .F.,oBtn1,oBtn2,oBtn3
	Local lX3Uso := .F.,cCposdef,cOrdem:="",cDriver:= __cRDD
	Local aRetMod	:= RetModName()
	Local nI		:= 1,noCponAt
	Local xDriver   := "DBFCDX"
	Local oPesq, cPesq := Space(20)
	Local aDescr := Array(3)
	Local lLastOpen := .F.
	Local cLastAlias := ""

	Private  aModulos := {}
	Private lReal := .F.  // Indica que pelo menos um campo real foi incluido
	// p/ Atualizar estrutura fisica do arquivo
	Private cArq := ""
	Private cOrd := ""
	Private aStrAnt[0]
	Private aStrAtu[0]
	Private aFieldAlt := {}
	Private aBancos[0]
	Private aCampos[0]
	Private tcampos := ""
	Private AltOpc := .T.
	Private AltOrd := .F.
	Private AltStr := .F.
	Private AltUso := .F.
	Private AltBrw := .f.
	Private aCpoDesc := {"X3_DESCRIC","X3_DESCSPA","X3_DESCENG"}

	If !PgsExclusive()
		Help(" ",1,"PGSEXC")
	EndIf

	Aadd(aModulos, {.F.,	OemToAnsi(STR0001),OemToAnsi(STR0002), 0})       // "TODOS   "  ### "Utilizado em todos os m¢dulos       "

	For nI:=1 To Len(aRetMod)
		Aadd( aModulos, { .F., aRetMod [nI][2], aRetMod [nI][3], aRetMod [nI][1] } )
	Next

	cCposDef :=  "_USERLGA/_USERGA/_USERLGI/_USERGI/_MSEXP/_MSIMP/_MSIDENT/_MSIDEN" // Campos c/ Caracteristicas Default

	cArqSx2 := "SX2" + SM0->M0_CODIGO + "0"
	cIndSx2:=cArqSx2
	If !OpenSX2Excl(cArqSx2,cIndSx2)
		DeleteObject(oOk)
		DeleteObject(oNo)
		DeleteObject(oOk1)
		Return
	EndIf

	DbSelectArea("Sx2")
	Set Filter To
	dbSetOrder(1)
	dbGoTop()
	DbSelectArea("SX3")
	dbSetOrder(1)
	dbGoTop()
	*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	*³ Monta array de bancos e tabela de campos                     ³
	*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DbSelectArea("SX2")
	dbGoTop()
	While .NOT. EOF()
		If !(Upper(AllTrim(X2_CHAVE)) == "SX5") .and. !(Upper(AllTrim(X2_CHAVE)) == "SR5") .and. ;
				!(Upper(AllTrim(X2_CHAVE)) == "SYN") .and. !(Upper(AllTrim(X2_CHAVE)) == "SYO")
			AADD(aBancos,x2_chave+"   "+Capital( X2Nome() ))
		EndIf
		DbSkip()
	End
	*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	*³ Monta a tela de Bancos de Dados                              ³
	*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DEFINE MSDIALOG oDlg FROM  10,15 TO 23,53 TITLE OemToAnsi(STR0024) OF oMainWnd // "Selecione Arquivo"

	@ 11,12 LISTBOX oLbx FIELDS HEADER OemtoAnsi(STR0106) + OemtoAnsi(STR0036);
		SIZE 131, 69 OF oDlg PIXEL ;  // "Descri‡„o"
	ON CHANGE (nArq:=oLbx:nAt) ON DBLCLICK (lRet := .T.,oDlg:End())
	oLbx:SetArray(aBancos)
	oLbx:bLine := {|| {aBancos[oLbx:nAt]} }

	@ 83,2  SAY OemToAnsi(STR0107) SIZE 25, 7 OF oDlg PIXEL
	@ 83,30 MSGET oPesq  VAR cPesq  SIZE 60,10 OF oDlg PIXEL PICTURE "@!" ;
		VALID (nPosArq:=If(!Empty(cPesq),ASCAN(aBancos,{|z|AllTrim(cPesq)$z}),oLbx:nAt),If(nPosArq#0,oLbx:nAt:=nPosArq,MsgStop(OemtoAnsi(STR0108))),oLbx:Refresh(),If(nPosArq#0,nArq:=nPosArq,),(nPosArq#0))

	DEFINE SBUTTON FROM 83, 92  TYPE 1  ENABLE OF oDlg ACTION (lRet := .T.,oDlg:End())
	DEFINE SBUTTON FROM 83, 120 TYPE 2  ENABLE OF oDlg ACTION (lRet := .F.,oDlg:End())

	ACTIVATE MSDIALOG oDlg

	If !lRet
		Finaliza()
		DeleteObject(oOk)
		DeleteObject(oNo)
		DeleteObject(oOk1)
		//#ifdef CDX
		//SET AUTOPEN ON
		//#endif
		Return
	EndIf
	*-------------------------------------------------------*
	*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	*³ Monta o Array de Estrutura de Campos                         ³
	*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cArq := Substr(aBancos[nArq],1,3)

	SET SOFTSEEK ON
	dbSelectArea("SX3")
	dbSetOrder(1)
	dbSeek(cArq)

	SET SOFTSEEK OFF
	If x3_arquivo != cArq
		MsgAlert(OemToAnsi(STR0025))  // "Arquivo Inv lido  "
		Finaliza()
		DeleteObject(oOk)
		DeleteObject(oNo)
		DeleteObject(oOk1)
		//#ifdef CDX
		//SET AUTOPEN ON
		//#endif
		Return
	EndIf

	aDescr[1] := OemToAnsi(STR0036)
	aDescr[2] := STR0119
	aDescr[3] := STR0120

	While (x3_arquivo = cArq)

		If SubStr(X3Reserv(x3_reserv),8,1) == "x" .And. ! (AllTrim(Subs(x3_campo,3)) $ cCposDef) .And. ! x031Str(Subs(x3_campo,4),cCposDef)
			lx3Uso := 	.T.
		EndIf

		AADD(aCampos,{lX3Uso,If(X3_BROWSE=="S",.T.,.F.),x3_ordem,x3_campo,oemtoansi(&(aCpoDesc[COLDESC1])),x3_usado,x3_reserv,x3_obrigat,oemtoansi(&(aCpoDesc[COLDESC2])),oemtoansi(&(aCpoDesc[COLDESC3]))})
		DbSkip()
	End
	*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	*³ Monta a Tela de Escolha de Campos                            ³
	*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SX2")
	dbSeek(Substr(aBancos[nArq],1,3))

	If __cRdd == "TOPCONN"
		#ifdef WNTX
			xDriver := "DBFNTX"
		#endif
		cDriver := Iif(Substr(aBancos[nArq],1,3)  $ "SH7/SH9",xDriver,cDriver)
	EndIf
	cArqIni := Trim(x2_path)+AllTrim(SX2->X2_ARQUIVO)
	cArqIni := RetArq(cDriver,cArqIni,.t.)
	If !MSFile(cArqIni,,cDriver)
		//CriaDbf(AllTrim(X2_PATH)+AllTrim(X2_ARQUIVO),X2_CHAVE)
		CriaDbf(cArqIni,X2_CHAVE,cDriver)
	EndIf
	If Select(X2_CHAVE) <> 0
		DbSelectarea(X2_CHAVE)
		DbCloseArea()
		lLastOpen := .T.
		cLastAlias := SX2->X2_CHAVE
	EndIf

	lOk := MSOpEndBF( .T.,cDriver, cArqIni, "CurArq", .F., .F. )

	While !lOk
		If !NaoExcl()
			Finaliza(cIndSx2)
			DeleteOBJECT(oOK)
			DeleteObject(oNo)
			DeleteObject(oOk1)
			//#ifdef CDX
			//SET AUTOPEN ON
			//#endif
			Return Nil
		EndIf
		lOk := MSOpEndBF( .T.,cDriver, cArqIni, "CurArq", .F., .F. )
	End

	*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	*³ Monta array contEndo SX3's que dever„o ser alterados no ³
	*³	caso do arquivo ser compartilhado entre outras empresas ³
	*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aSx3 := CheckCompart(cArq,cArqIni)

	// verIficar o retorno do aSx3
	// usar retarq()

	DbSelectArea("CurArq")

	*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	*³ Monta a Tela de Escolha de Campos                            ³
	*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	DbSelectArea("SX3")
	DbCloseArea()
	MsgMeter( { | oMeter, oText, oDlg, lEnd | ;
		SavArq( oMeter, oText, oDlg, @lEnd ) },;
		OemToAnsi(STR0026+Space(11)),;  // "Arquivo :"
	OemToAnsi(STR0027))  // "C¢pias de Seguran‡a"

	DbSelectArea("SX3")

	cTitulo := OemToAnsi(STR0026)+" " + AllTrim(Capital(Substr(aBancos[nArq],7)))  // "Arquivo :"
	While .T.
		nPos := 1
		VerReserv(nPos,@lOrd,@lUso,@lBrow,@lUsado)
		VerUso(aCampos[nPos,6])
		cOrdem := aCampos[nPos,3]
		lUsado  := Iif(Empty(FirstBitOff(Bin2Str(aCampos[nPos,6]))),.F.,.T.)
		lBrowse := aCampos[nPos,2]
		lRet := .F.

		oDlg:=Nil
		DEFINE MSDIALOG oDlg FROM  118,30 TO 358,590 TITLE cTitulo PIXEL  OF oMainWnd
		@ 2, 172 TO 34, 233 OF oDlg  PIXEL
		@ 36, 172 TO 113, 277 OF oDlg  PIXEL

		DEFINE SBUTTON FROM 7,249  TYPE 1 ENABLE OF oDlg ACTION (nOpc1 := 0,lRet := .T.,oDlg:End())
		DEFINE SBUTTON FROM 20,249 TYPE 2 ENABLE OF oDlg ACTION (nOpc1 := 0,lRet := .F.,oDlg:End())

		DEFINE SBUTTON oBtn1 FROM 102,82  TYPE 4 ENABLE OF oDlg Action (nOpc1:=1,lRet :=.T.,oDlg:End())
		DEFINE SBUTTON oBtn2 FROM 102,111 TYPE 11 ENABLE OF oDlg Action (nOpc1:=2,lRet :=.T.,oDlg:End())
		DEFINE SBUTTON oBtn3 FROM 102,139 TYPE 3 ENABLE OF oDlg Action (nOpc1:=3,lRet :=.T.,oDlg:End())

		@5,4  LISTBOX oCpo FIELDS HEADER OemToAnsi(STR0067),OemToAnsi(STR0028),OemToAnsi(STR0029),OemToAnsi(STR0030), aDescr[COLDESC1], aDescr[COLDESC2], aDescr[COLDESC3] size 163,90 of oDlg PIXEL; // "Uso"  ### "Brw"  ### "Ord" ### "Campo" ### "Descri‡„o" ### "Desc Spanish" ### "Desc English"
		ON CHANGE (nPos:=oCpo:nAt,VerUso(aCampos[nPos,6]),;
			VerReserv(nPos,@lOrd,@lUso,@lBrow,@lUsado),oOrdem:SetText(aCampos[nPos,3]),;
			cOrdem:=aCampos[nPos,3],lUsado:=Iif(Empty(FirstBitOff(Bin2Str(aCampos[nPos,6]))),.F.,.T.),;
			lBrowse:=aCampos[nPos,2],Iif(lOrd .and. aCampos[nPos,4] != STR0035,oOrdem:Enable(),;
			oOrdem:Disable()),oOrdem:Refresh(),Iif(lUso .and. aCampos[nPos,4] != STR0035,(oUso:Enable(),oUsado:Enable()),;
			(oUso:Disable(),oUsado:Disable())),Iif(lBrow .and. aCampos[nPos,4] != STR0035 ,oBrow:Enable(),oBrow:Disable()),;
			oUso:Refresh(.F.),oUsado:Refresh(),oBrow:Refresh(.F.),Iif(aCampos[nPos,4] == STR0035,(oBtn2:SetDisable(),oBtn3:SetDisable()),;
			(oBtn2:SetEnable(),oBtn3:SetEnable())),oBtn2:RefResh(),oBtn3:RefResh(),noCponAt:=nPos);
			ON DBLCLICK (Eval(oBtn2:bAction))

		oCpo:SetArray(aCampos)
		oCpo:bLine := { || {Iif(aCampos[oCpo:nAt,1],oOk1,oNo),Iif(aCampos[oCpo:nAt,2],oOk,oNo),aCampos[oCpo:nAt,3],aCampos[oCpo:nAt,4],aCampos[oCpo:nAt,5],aCampos[oCpo:nAt,9],aCampos[oCpo:nAt,10]}}

		@10, 180 SAY OemToAnsi(STR0072) SIZE 21, 7 OF oDlg PIXEL  // "&Ordem:"

		@20,180 MSGET oOrdem VAR cOrdem SIZE 37,10 OF oDlg PIXEL;
			VALID ValOrdem(oCpo,@cOrdem,@nPos) PICTURE "@!"; //(lOk :=( VAL(aCampos[oCpo:nAt,3]) > 0 .and. VAL(aCampos[oCpo:nAt,3]) <= 99 ),nNew := Val(aCampos[oCpo:nAt,3]),If(lOk,aCampos := Sort(cBkp,aCampos[oCpo:nAt,3]),.f.),If(lOk,oCpo:Refresh(),.f.),If(lOk,oCpo:Skip(nNew-Val(cBkp)),lOk),If(lOk,SetFocus(oCpo:hWnd),.f.),lOk) PICTURE "99";
			ON CHANGE (AltOrd:=.T.)

		Iif(lOrd,oOrdem:Enable(),oOrdem:Disable())
		oOrdem:bGotFocus := { || cBkp := aCampos[oCpo:nAt,3] }


		@50,180  LISTBOX oUsado FIELDS HEADER " ",OemToAnsi(STR0031),OemToAnsi(STR0036) size 87,42 of oDlg PIXEL;  // "M¢dulos" ### "Descri‡„o"
		ON DBLCLICK (aModulos[oUsado:nAt,1]:=!aModulos[oUsado:nAt,1],;
			Iif(oUsado:nAt != 1,aModulos[1,1]:=.F.,VerUso(Str2Bin(FirstBitOn(Space(99)+"x  ")))),;
			aCampos[oCpo:nAt,6]:=MontaUso(aModulos),;
			oUsado:Refresh(),;
			AltUso:=.T.)

		oUsado:SetArray(aModulos)
		oUsado:bLine := { || {Iif(aModulos[oUsado:nAt,1],oOk,oNo),aModulos[oUsado:nAt,2],aModulos[oUsado:nAt,3] }}

		@98,180 CHECKBOX oBrow VAR lBrowse PROMPT OemToAnsi(STR0032) SIZE 39,10 OF oDlg PIXEL; // "&Browse"
		ON CLICK (aCampos[oCpo:nAt,2]:=lBrowse,oCpo:Refresh(.F.),AltBrw:=.T.)
		Iif(lBrow,oBrow:Enable(),oBrow:Disable())
		oBrow:oFont:=oDlg:oFont

		@98,220 CHECKBOX oUso VAR lUsado PROMPT OemToAnsi(STR0033) SIZE 39,10 OF oDlg PIXEL ;  // "&Usado"
		ON CLICK (Iif(!lUsado,(Veruso(Str2Bin(FirstBitOn(Space(102)))),aCampos[oCpo:nAt,2]:=.F.,lBrowse:=.F.),),aCampos[oCpo:nAt,6]:=Montauso(aModulos),oCpo:Refresh(.F.),oUsado:Refresh(),Iif(lUsado,oBrow:Enable(),oBrow:Disable()),oBrow:Refresh(),Altuso:=.T.)
		Iif(lUso,oUso:Enable(),oUso:Disable())
		oUso:oFont:=oDlg:oFont

		ACTIVATE MSDIALOG oDlg

		If lRet .and. nOpc1 != 0
			GetStruN(nArq,nPos,nOpc1,@lModStr,lUsado)
		ElseIf !lRet
			MsgMeter( { | oMeter, oText, oDlg, lEnd |  RestArq( oMeter, oText, oDlg, @lEnd,cDriver ) },OemToAnsi(STR0026) ,OemToAnsi(STR0068)) // "Arquivo :"  ### "Restaurando Arquivos"
			Exit
		ElseIf (lRet .and. nOpc1 == 0)
			Exit
		EndIf
	End

	*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	*³ VerIfica a certeza da escolha e Endereca esta                ³
	*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	If (!AltUso .AND. !AltOrd .AND. !AltStr .AND. !AltBrw ) .or. !lRet
		FechaSX3(aSx3)
		DbSelectArea("CurArq")
		dbCloseArea()
		//close CurArq
		Finaliza()
		DeleteObject(oOk)
		DeleteObject(oNo)
		DeleteObject(oOk1)
		//#ifdef CDX
		//SET AUTOPEN ON
		//#endif
		If lLastOpen
			ChkFile(cLastAlias)
		EndIf
		Return 0
	EndIf

	If AltUso .or. AltOrd .or. AltStr .or. AltBrw
		lRet := .F.
		cTitulo := OemToAnsi(STR0069)  // "ModIfica‡”es na Estrutura do Arquivo"
		oDlg:=nil
		DEFINE MSDIALOG oDlg TITLE cTitulo From 9,13 To 23,63  OF oMainWnd

		@10,10   SAY OemToAnsi(STR0070) PIXEL  // "Foram feitas modIfica‡”es que alteram a estrutura do sistema."

		@25,18  CHECKBOX oCbx1 VAR AltUso SIZE 120,11 OF oDlg PROMPT OemToAnsi(STR0073) ;  // " Uso dos Campos pelo Sistema"
		WHEN .F. PIXEL ;oCbx1:oFont:=oDlg:oFont
		@40,18  CHECKBOX oCbx2 VAR AltOrd SIZE 120,11 OF oDlg PROMPT OemToAnsi(STR0094);  // " Ordem de Apresenta‡„o dos Campos "
		WHEN .F. PIXEL ;oCbx2:oFont:=oDlg:oFont
		@55,18  CHECKBOX oCbx3 VAR AltStr SIZE 120,11 OF oDlg PROMPT OemToAnsi(STR0077);  // " Estrutura dos Arquivos do Sistema "
		WHEN .F. PIXEL ;oCbx3:oFont:=oDlg:oFont
		@70,18  CHECKBOX oCbx4 VAR AltBrw SIZE 120,11 OF oDlg PROMPT OemToAnsi(STR0079);  // " Utiliza‡„o dos campos nos Browses "
		WHEN .F. PIXEL ;oCbx4:oFont:=oDlg:oFont
		DEFINE SBUTTON FROM 090,132   TYPE 1 ACTION (lClose:=Iif(AltStr,.F.,lClose),AltStruct(noCponAt,lModStr),lRet := .T.,oDlg:End()) ENABLE OF oDlg
		DEFINE SBUTTON FROM 090,159.1 TYPE 2 ACTION (lRet := .F.,oDlg:End()) ENABLE OF oDlg

		ACTIVATE MSDIALOG oDlg
	Else
		AltStruct(noCponAt,lModStr)
	EndIf
	If !lRet
		MsgMeter( { | oMeter, oText, oDlg, lEnd |  RestArq( oMeter, oText, oDlg, @lEnd,cDriver ) },OemToAnsi(STR0026) ,OemToAnsi(STR0081)) // "Arquivo :" ### "Restaurando Arquivos"
	EndIf
	If lClose
		FechaSx3(aSx3)
		DbSelectArea("CurArq")
		dbCloseArea()
	EndIf

	*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	*³ Fecha arquivos abertos em modo exclusivo p/ abrir compartilhado³
	*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Finaliza()

	DbSelectArea("SX2")
	DeleteObject(oOk)
	DeleteObject(oNo)
	DeleteObject(oOk1)
	//#ifdef CDX
	//SET AUTOPEN ON
	//#endif

	PgsShared()
	//MsgAlert( 'Fim PGS' )
	If lLastOpen
		ChkFile(cLastAlias)
	EndIf

	Return

	/*
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Fun‡…o    ³ RestArq  ³ Autor ³                       ³ Data ³          ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡…o ³ Restaura condicoes originais do Arquivo                    ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	*/
	Static ;
	Function RestArq(oMeter, oText, oDlg, lEnd ,cDriver)
	Local bBlock1,cMsg,i,j,cArqIni,cArqFin,cSx3Alias,lCdxAXs := .F.

	#ifdef CDX
		lCdxAxs := .T.
	#endif

	oMeter:nTotal := 3*Len(aSx3)
	For j := 1 to Len(aSx3)
		cSx3Alias := SeleSx3(aSx3[j,1],aSx3[j,2])
		DbCloseArea()
		cArqIni := aSx3[j,1]+".#DB"
		cArqFin := aSx3[j,1]+GetDBExtension()
		cMsg := OemToAnsi(cArqFin)

		//@ 0.4, 6.5  SAY oText VAR cMsg OF oDlg

		oText:SetText( cMsg )

		bblock1:={|| oMeter:Set(j), SysRefresh(), !lEnd}
		EVAL(bblock1)

		__CopyFile(cArqIni, cArqFin)

		If cDriver != "TOPCONN"
			If File(aSx3[j,1]+".#"+Substr(MemoExt(),2,2))
				__CopyFile( aSx3[j,1]+".#"+Substr(MemoExt(),2,2), aSx3[j,1]+MemoExt())
			EndIf
		EndIf

	Next j

	*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	*³ Restaura indices                                             ³
	*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	For i := 1 to Len(aSx3)
		cArqIni := aSx3[i,1]+Iif(lCdxAxs,"","1")+".#"+Substr(RetIndExt(),2,2)
		cArqFin := aSx3[i,1]+Iif(lCdxAxs,"","1")+ RetIndExt()
		cMsg := OemToAnsi(cArqFin)
		//@ 0.4, 6.5  SAY oText VAR cMsg  OF oDlg
		oText:SetText( cMsg )
		bblock1:={|| oMeter:Set(i+j), SysRefresh(), !lEnd}
		EVAL(bblock1)

		__CopyFile( cArqIni, cArqFin )

		If !(".CDX"  $ RetIndExt())
			cArqIni := aSX3[i,1]+ "2.#NT"
			cArqFin := aSX3[i,1]+"2"+RetIndExt()
			cMsg := OemToAnsi(cArqFin)
			//@ 0.4, 6.5 SAY oText VAR cMsg  OF oDlg
			oText:SetText( cMsg )
			bblock1:={|| oMeter:Set(i+j+1), SysRefresh(), !lEnd}
			EVAL(bblock1)

			__CopyFile( cArqIni, cArqFin )
		EndIf

		If (aSx3[i,2] == "SX3")
			cAliasSx3 := SeleSx3(aSx3[i,1],aSx3[i,2])
			DbSetOrder(1)     && mantem como defaut o primeiro indice
		EndIf

	Next i

	Return

	/*
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Fun‡…o    ³ ModStr   ³ Autor ³ Jorge Queiroz         ³ Data ³          ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡…o ³ ModIfica a estrutura do arquivo em pauta                   ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Sintaxe e ³ Void ModStr(ExpC1)                                         ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Parametros³ ExpC1 = Alias do arquivo                                   ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³ Uso      ³ CFGx031.PRG    ³ Fun‡†o Relacionada ³                      ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	*/
	Static ;
	Function ModStr( oMeter, oText, oDlg, lEnd ,cArqIni)
	Local NewStr,i,j,cArqSx3,cIndSx2
	Local cSixAlias, mOwner,cSx3Alias,nOldOrdSx3
	Local cMsg,bBlock1,nCnt,cArqTemp
	Local cMsIdent := "",lOk,cDriver := __cRDD, xDriver := "DBFCDX"

	If __cRdd == "TOPCONN"
		#ifdef WNTX
			xDriver := "DBFNTX"
		#endif
		cDriver := Iif(SX2->X2_CHAVE $ "SH7/SH9",xDriver,cDriver)
	EndIf

	Private lTxt := .F.
	NewStr := AClone(aStrAtu)

	j:=1
	FOR i=1 TO LEN(aStrAtu)
		If aStrAtu[i][1] == OemToAnsi(STR0035) // "Deletado"
			NewStr := ADEL(NewStr,j)
			NewStr := aSize(NewStr,Len(NewStr)-1)
		Else
			If ( "_MSIDENT" $ aStrAtu[i,1] ) .Or. ( "_MSIDEN" $ aStrAtu[i,1] )
				cMsIdent := aStrAtu[i,1]
			EndIf
			j++
		EndIf
	Next

	DbSelectArea("CurArq")
	DbCloseArea()

	*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	*³ Deleta o backup anterior e renomeia o arquivo novo           ³
	*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	MSErase(RetArq( cDriver,Trim(SX2->x2_path)+cArqIni+".#DB",.f.))
	If cDriver != "TOPCONN"
		FErase(Trim(SX2->x2_path)+cArqIni+".#"+Substr(MemoExt(),2,2))
		If File(Trim(SX2->x2_path)+cArqIni+MemoExt()) // Arquivos DBT
			FRename(Trim(SX2->x2_path)+cArqIni+MemoExt(),Trim(SX2->x2_path)+cArqIni+".#"+Substr(MemoExt(),2,2))
		EndIf
	EndIf

	If cDriver == "TOPCONN" .or. cDriver == "BTVCDX"
		MSRename(Trim(SX2->x2_path)+cArqIni+GetDBExtension(),Trim(SX2->x2_path)+cArqIni+".#DB")
	Else
		__CopyFile(RetArq(cDriver,Trim(SX2->x2_path)+cArqIni,.t.),RetArq(cDriver,Trim(SX2->x2_path)+cArqIni+".#DB",.F.))
		FERASE(RetArq(cDriver,Trim(SX2->x2_path)+cArqIni,.t.))
	EndIf

	*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	*³ Deleta os registros marcados do SX3                          ³
	*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For i := 1 to Len(aSx3)
		cMsg :=OemToAnsi(STR0095+AllTrim(aSx3[i,1]))  // "RemovEndo Registros Deletados do "

		//@ 0.4, 0.5  SAY oText VAR cMsg  OF oDlg
		oText:SetText( cMsg )

		cSx3Alias:= SeleSx3(aSx3[i,1],aSx3[i,2])
		SET SOFTSEEK On
		dbSeek(cArq+"99")
		dbSkip(-1)
		oMeter:nTotal := Val(RetAsc((cSx3Alias)->x3_ordem,2,.F.))
		SET SOFTSEEK OFF
		dbSeek(cArq)
		nCnt:=0
		While cArq == (cSx3Alias)->x3_arquivo
			RecLock(cSx3Alias,.F.)
			If (cSx3Alias)->x3_campo = OemToAnsi(STR0035) // "Deletado"
				dbDelete()
			Else
				nCnt++
				REPLACE (cSx3Alias)->x3_ordem WITH RetAsc(Str(nCnt),2,.T.)
			EndIf
			dbSkip()
			bblock1:={|| oMeter:Set(nCnt), SysRefresh(), !lEnd}
			EVAL(bblock1)
		End
		PACK
	Next i

	DbSelectArea("SX3")
	DbSetOrder(nOldOrdSx3)

	cMsg := OemToAnsi(STR0083)  // "Aguarde...Compactando Arquivo"
	//@ 0.4, 0.5  SAY oText VAR cMsg  OF oDlg
	oText:SetText( cMsg )

	*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	*³ Seleciona o arquivo anterior                                 ³
	*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	// Select 0	-- Tirei pq d  erro no protheus...

	cArqIni := RetArq(cDriver,Trim(SX2->x2_path)+AllTrim(cArqIni),.T.)
	cArqIni := FilenoExt(cArqIni)

	*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	*³ Cria a Estrutura do novo arquivo a de NewStr                 ³
	*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	// Deleta os arq. de indices

	If ( RetIndExt() == ".CDX" )
		Ferase(cArqIni+RetIndExt())
	Else
		DbSelectArea("SIX")
		DbSeek(cArq)

		While ( ! Eof() ) .And. ( cArq == SIX->INDICE )
			Ferase(Trim(SX2->x2_path)+cArqIni+SIX->ORDEM+RetIndExt())
			DbSkip()
		End
	EndIf

	MSCreate(cArqIni,NewStr,cDriver)

	If cDriver != "TOPCONN"
		If File(FileNoExt(cArqIni)+".#"+Substr(MemoExt(),2,2))
			cArqTemp := Criatrab(,.f.)
			__CopyFile(cArqIni+".#DB",cArqTemp+GetDBExtension())
			__Copyfile(cArqIni+".#"+Substr(MemoExt(),2,2),cArqTemp+MemoExt())
		Else
			cArqTemp := cArqIni+".#DB"
		EndIf
	Else
		cArqTemp := cArqIni+".#DB"
	EndIf

	lOk := .F.
	While !lOk
		lOk :=MsOpEndbf( .T.,cDriver, cArqIni, "CurArqAtu",.F., .F.,.T. )
	End

	*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	*³ Le o BDados do inicio ao fim                                 ³
	*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DbSelectArea("CurArqAtu")
	MSAppEnd(cArqIni,cArqTemp)
	If !Empty(cMsIdent)
		For i := 1 To LastRec()
			DbGoTo(i)
			REPLACE  &cMsIdent. WITH  GETNEXTIDX6()
		Next i
	EndIf

	If cDriver != "TOPCONN"
		If File(cArqTemp+MemoExt())
			FErase(cArqTemp+GetDBExtension())
			FErase(cArqTemp+MemoExt())
		EndIf
	EndIf


	cSixAlias := SX2->X2_CHAVE
	FechaSx3(aSx3)

	/*
	If cDriver != "TOPCONN"

		MsgMeter( { | oMeter, oText, oDlg, lEnd | ;
			AtualizaIdx( oMeter, oText, oDlg, @lEnd,cSixAlias,"CurArqAtu" ) },;
			OemToAnsi(STR0037),;  // "Aguarde, criando ¡ndices de acordo com a nova estrutura ..."
		OemToAnsi(STR0038))  // " Atualiza‡„o de ¡ndices "
	EndIf
	*/
	DbSelectArea("CurArqAtu")
	dbCloseArea()
	Finaliza()

	If lTxt
		Ourspool("X031LOG")
	EndIf
	Return

	/*
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Fun‡…o    ³ a1Choice ³ Autor ³ Jorge Queiroz         ³ Data ³          ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡…o ³ Processa a o aChoice da escolha de campos                  ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³ Uso      ³ CFGx031.PRG    ³ Fun‡†o Relacionada ³ -                    ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	*/
FUNCTION a1Choice(n_op)
	Local cPode,nSavRec,cObgt
	Local cSx3Alias, nOldOrdSx3 := 0,i:=0,j:=0
	/*--------------------------------------------------------------------
	If AltOrd
		cOrd := RetAsc(Str(n_op),2,.T.)
		Select SX3
		nSavRec := RecNo()
		DbSetOrder(2)
		Seek (aCampos[n_op,4])
		cPode := "xxxxxx x"
		If Found()
			cPode := X3Reserv(aCampos[n_op,7])
		EndIf
		DbSetOrder(1)
		Go nSavRec

		Select Sx3
		nOldOrdSx3 := IndexOrd()

		For i := 1 to Len(aSx3)
			cSx3Alias := SeleSx3(aSx3[i,1],aSx3[i,2])
			DbSetOrder(2)
			For j := 1 to Len(aCampos)
				DbSeek (aCampos[j,4])
				RecLock(cSx3Alias,.F.)
				REPLACE x3_ordem WITH RetAsc(aCampos[j,3],2,.T.)
				MsUnlock()
			Next j
		Next i

		DbSelectArea("SX3")
		DbSetOrder(nOldOrdSx3)
	EndIf
	--------------------------------------------------------------------*/
	If AltUso
		For j := 1 To Len(aCampos)
			Select SX3
			nSavRec := RecNo()
			DbSetOrder(2)
			Seek aCampos[j,4]
			cPode := "xxxxxx x"
			cObgt := Space(8)
			If Found()
				cPode := X3Reserv(aCampos[j,7])
				cObgt := Bin2Str(aCampos[j,8])
			EndIf
			dbSetOrder(1)
			dbGoTo(nSavRec)
			cOrd := RetAsc(aCampos[j,3],2,.T.)
			dbSelectArea("SX3")
			nOldOrdSx3 := IndexOrd()
			For i := 1 to Len(aSx3)
				cSx3Alias := SeleSx3(aSx3[i,1],aSx3[i,2])
				dbSeek(cArq+cOrd)
				If Found()
					RecLock(cSx3Alias,.F.)
					REPLACE x3_usado WITH aCampos[j,6]
					If Empty(FirstBitOff(Bin2Str(aCampos[j,6])))
						Replace X3_BROWSE with "N"
					EndIf
					MsUnlock()
				EndIf
			Next i
			DbSelectArea("SX3")
			DbSetOrder(nOldOrdSX3)
		Next j
	EndIf
	If AltBrw
		nOldOrdSx3 := IndexOrd()
		FOR i := 1 to Len(aSx3)
			cSx3Alias := SeleSx3(aSx3[i,1],aSx3[i,2])
			For j := 1 To Len(aCampos)
				dbSetOrder(2)
				dbSeek(aCampos[j,4])
				dbSetOrder(1)
				If Found()
					RecLock(cSx3Alias,.F.)
					REPLACE x3_browse WITH Iif(aCampos[j,2],"S","N")
					MsUnlock()
				EndIf
			Next j

		Next i
		DbSelectArea("SX3")
		DbSetOrder(nOldOrdSx3)
	EndIf

	Return .T.
	/*
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Fun‡…o    ³x3_Campo  ³ Autor ³ Jorge Queiroz         ³ Data ³          ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡…o ³ Critica do Campo                                           ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³ Uso      ³ CFGx031.PRG    ³ Fun‡†o Relacionada ³ -                    ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	*/
	Static ;
	Function X3_Campo(cOldCampo)
	Local nSavRec := 0
	Local cPrefix := SubStr(cArq,2,2)+"_"
	If Subs(cArq,1,1) != "S"
		cPrefix := SubStr(cArq,1,3)+"_"
	EndIf
	If " " $ Trim(M->x3_campo)
		Return .F.
	EndIf
	dbSelectArea("SX3")
	nSavRec := RecNo()
	dbSeek(cArq)
	If cOldCampo != M->x3_campo
		While x3_arquivo = cArq
			If (M->x3_campo == x3_campo)
				dbGoTo(nSavRec)
				Return .F.
			EndIf
			dbSkip()
		End
	EndIf
	dbGoTo(nSavRec)
	If Subs(cArq,1,1) == "S"
		If (SUBSTR(M->x3_campo,1,3) != cPrefix) .OR. (Trim(M->x3_campo) == cPrefix)
			Return .F.
		EndIf
	Else
		If (SUBSTR(M->x3_campo,1,4) != cPrefix) .OR. (Trim(M->x3_campo) == cPrefix)
			Return .F.
		EndIf
	EndIf
	RETURN .T.

	/*
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Fun‡…o    ³x3_Tamanho³ Autor ³ Jorge Queiroz         ³ Data ³          ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡…o ³ Critica de Tamanho                                         ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³ Uso      ³ CFGx031.PRG    ³ Fun‡†o Relacionada ³ -                    ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	*/
	Static ;
	Function X3_Tamanho
	If    (M->x3_tipo == "N" .AND. M->x3_tamanho > 18 ) .OR.;
			(M->x3_tipo == "C" .AND. M->x3_tamanho > 512) .OR.;
			(M->x3_tipo == "D" .AND. M->x3_tamanho != 8 ) .OR.;
			(M->x3_tipo == "L" .AND. M->x3_tamanho != 1 ) .OR.;
			(M->x3_tipo == "M" .AND. M->x3_tamanho != 10 ) .OR.;
			(M->x3_tamanho < 1)
		RETURN .F.
	EndIf
	RETURN .T.

	/*
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Fun‡…o    ³x3_Tipo   ³ Autor ³ Eveli Morasco         ³ Data ³          ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡…o ³ Sugere o tamanho dos campos a partir do TIPO               ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³ Uso      ³ CFGx031.PRG    ³ Fun‡†o Relacionada ³ -                    ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	*/
	Static ;
	Function X3_Tipo

	If M->x3_tipo == "D"
		M->x3_tamanho := 8
		M->x3_decimal := 0
	ElseIf M->x3_tipo == "L"
		M->x3_tamanho := 1
		M->x3_decimal := 0
	ElseIf M->x3_tipo == "C"
		M->x3_decimal := 0
	EndIf
	RETURN .T.

	/*
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Fun‡…o    ³x3_Decimal³ Autor ³ Jorge Queiroz         ³ Data ³          ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡…o ³ Critica de Decimal                                         ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³ Uso      ³ CFGx031.PRG    ³ Fun‡†o Relacionada ³ -                    ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	*/
	Static ;
	Function X3_Decimal
	If (M->x3_decimal >= M->x3_tamanho) .OR.;
			(M->x3_tipo $ "DCL" .AND. M->x3_decimal > 0 )
		RETURN .F.
	EndIf
	RETURN .T.

	/*
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Fun‡…o    ³ GetStruN ³ Autor ³ Ary Medeiros          ³ Data ³          ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡…o ³ Altera a Estrutura dos Arquivos.                           ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Sintaxe e ³ Void GetStru(void)                                         ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Parametros³ Sem Argumentos                                             ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³ Uso      ³ CFGx031.PRG                                                ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	*/
Function GetStruN(nArq,nPos,nOpc,lModStr,lUsado)
	Local bCampo,nInd:=0,oFont,i, j
	Local cHelp, nEl,cOldHelp
	Local cTipo,nVisual:=1,nContext:=1,lAltHlp:=.F.
	Local lObrigat,cSx3Alias,nOldOrdSx3,cOldContex,cNewContex
	Local af3,nOpca:=0,lHelp := .F.,cOldCampo:= ""
	Local oCampo,oTipo,oTam,oDec,oFormat,oCabec,oDescric,oValSis,oValUsu,oNivel,oF3,oX3Box
	Local oVisual,oContext,oObrig,oHelp,oInitPad,cTitulo,lWhen:=.t.
	Local lX3Uso := .F.,lBitMap := .F.,cCposdef,oDlg
	Local nWhenTam := 0
	Local nWhEndec := 0
	Local cDBMS    := " "
	Local oFolder,cFolder,aFolder
	Local lNoSXG

	#ifdef TOP
		cDBMS := Upper(TCGetDB())
	#endif


	cCposDef :=  "_USERLGA/_USERGA/_USERLGI/_USERGI/_MSEXP/_MSIMP/_MSIDENT/_MSIDEN" // Campos c/ Caracteristicas Default
	*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	*³ Blocos de Codigo                                             ³
	*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	bCampo := {|nCPO| Field(nCPO) }

	*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	*³ Acessa a posicao especIfica do arquivo                       ³
	*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cOrd := aCampos[nPos,3]
	For i := 1 to Len(aSx3)
		cSx3Alias := SeleSx3(aSx3[i,1],aSx3[i,2])
		DbSeek(cArq+cOrd)
	Next i
	DbSelectArea("SX3")

	If nOpc == 3

		cPode := X3Reserv(x3_reserv)
		cObgt := Bin2Str(x3_Obrigat)
		If !Empty(FirstBitOff(Bin2Str(aCampos[nPos,6])))
			Help(" ",1,"USADONAOEX")
			Return
		ElseIf SubStr(cPode,8,1) == " "
			Help(" ",1,"NAOACESSA")
			Return
		EndIf
	EndIf

	*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	*³ Salva a integridade dos Campos de DBF                        ³
	*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	FOR i := 1 TO FCount()
		M->&(EVAL(bCampo,i)) := FieldGet(i)
		If nOpc == 1
			If ValType(M->&(EVAL(bCampo,i))) = "C"
				M->&(EVAL(bCampo,i)) := SPACE(LEN(M->&(EVAL(bCampo,i))))
			ElseIf ValType(M->&(EVAL(bCampo,i))) = "N"
				M->&(EVAL(bCampo,i)) := 0
			ElseIf ValType(M->&(EVAL(bCampo,i))) = "D"
				M->&(EVAL(bCampo,i)) := CTOD("  /  /  ")
			ElseIf ValType(M->&(EVAL(bCampo,i))) = "L"
				M->&(EVAL(bCampo,i)) := .F.
			EndIf
		EndIf
	NEXT i

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Carrega string de 8 bits para verIficar o que pode ser alterado ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If nOpc == 1
		cPode := "xxxxxx x"
		cObgt := Space(8)

		M->x3_reserv := X3Reserv(cPode)
		M->x3_Obrigat:= STr2Bin(cObgt)
	Else

		cPode := X3Reserv(M->x3_reserv)
		cObgt := Bin2Str(M->x3_obrigat)
		cOldContex := M->x3_Context
		cNewContex := cOldContex
		cHelp := GetHelp(X3_CAMPO)
		cHelp := OemToAnsi(cHelp)
		cOldHelp := cHelp
	EndIf

	aF3 := SeleF3()
	aFolder := SeleFolder(cArq)

	aTipo := {OemToAnsi(STR0039),OemToAnsi(STR0088),OemToAnsi(STR0041),OemToAnsi(STR0042),OemToAnsi(STR0043)}  // "Caracter"  ### "Numerico" ### "L¢gico  " ### "Data    " ### "Memo    "

	lAltered := .F.
	If nOpc == 1
		lModStr := .T.
		lUsado := .T.
		lNoSXG := .T.
		M->X3_PROPRI := "U"
		cF3 := Space(30)
		cFolder := Space(34)
		M->X3_OBRIGAT := Space(8)
		M->VISUAL :=" "
		M->CONTEXT := " "
		M->BROWSE := "N"
		M->X3_TIPO := "C"
		M->X3_USADO := Str2Bin(FirstBitOn(Space(99)+"x  ")) //Ultima posicao : Usado por Todos os Modulos
	ElseIf nOpc == 2
		lNoSXG := !VerSXG(M->X3_GRPSXG)
		cF3 := SayConpad(M->X3_F3)
		i := Ascan(aFolder,{|x| Subs(x,1,1) == M->X3_FOLDER})
		cFolder := If(i == 0,Space(34),aFolder[i])
		lObrigat := Iif(Substr(cPode,7,1)=="x" .or. Substr(Bin2Str(x3_obrigat),1,1)== "x",.T.,.F.)
		nVisual  := Iif (M->X3_VISUAL=="V",2,1)
		nContext := Iif (M->X3_CONTEXT=="V",2,1)
		cTipo := M->X3_TIPO
		cTipo := Iif(cTipo == "C",aTipo[1],Iif(cTipo == "N",aTipo[2],Iif(cTipo=="L",aTipo[3],Iif(cTipo=="D",aTipo[4],aTipo[5]))))
		cOldCampo := M->X3_CAMPO
		M->X3_USADO := aCampos[nPos,6]
		M->X3_BROWSE := Iif(aCampos[nPos,2],"S"," ")
	ElseIf nOpc == 3
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Processa Exclusao do Registro                                ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		M->x3_campo := OemToAnsi(STR0035) // "Deletado"
		lAltered := .T.
		AltStr :=  .T.
		nOpca := 1
	EndIf
	*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	*³ Monta a tela de alteracao das estruturas                     ³
	*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If nOpc != 3

		cTitulo := OemToAnsi(STR0026)+" " + AllTrim(Capital(Substr(aBancos[nArq],7)))  // "Arquivo :"
		oFont := TFont():New( "Courier New", 6, 0 )

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Compatibilizacao com ORACLE pois o tamanho n„o pode ser alte-³
		//³ rado para um tamanho MENOR que o atual.                      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nWhenTam := 0
		nWhEndec := 0
		If ( RddName() == "TOPCONN" ) .and. (nOpc == 2)
			nWhenTam := SX3->X3_TAMANHO
			nWhEndec := SX3->X3_DECIMAL
		EndIf

		DEFINE MSDIALOG oDlg FROM  100,35 TO 401,580 TITLE cTitulo PIXEL  OF oMainWnd

		@ 93, 138 TO 130, 180 OF oDlg  PIXEL
		@ 93, 181 TO 130, 223 OF oDlg  PIXEL
		@ 93, 224 TO 130, 266 OF oDlg  PIXEL

		@ 2, 4 SAY OemToAnsi(STR0074) SIZE 22, 7 OF oDlg PIXEL  // "Campo:"
		@ 2, 52 SAY OemToAnsi(STR0076) SIZE 53, 7 OF oDlg PIXEL  // "Tipo:"
		@ 2, 101 SAY OemToAnsi(STR0078) SIZE 30, 7 OF oDlg PIXEL  // "Tamanho:"
		@ 2, 138 SAY OemToAnsi(STR0080) SIZE 27, 7 OF oDlg PIXEL // "Decimal:"
		@ 2, 170 SAY OemToAnsi(STR0034) SIZE 53, 7 OF oDlg PIXEL // "Formato:"
		@ 2, 224 SAY OemToAnsi(STR0082) SIZE 32, 7 OF oDlg PIXEL  // "Cabeçalho:"
		@ 25, 4 SAY OemToAnsi(STR0036) SIZE 53, 7 OF oDlg PIXEL  // "Descrição:"
		@ 25, 40 SAY OemToAnsi(STR0118) SIZE 53, 7 OF oDlg PIXEL  // "Pasta de cadastro:"
		@ 25, 138 SAY OemToAnsi(STR0084) SIZE 69, 7 OF oDlg PIXEL  // "Definição do Campo:"
		@ 47, 4 SAY OemToAnsi(STR0086) SIZE 77, 7 OF oDlg PIXEL  // "Validacão do Usuário:"
		@ 68, 4 SAY OemToAnsi(STR0087) SIZE 75, 7 OF oDlg PIXEL  // "Validação do Sistema:"
		@ 68, 138 SAY OemToAnsi(STR0040) SIZE 75, 7 OF oDlg PIXEL  // "Lista de Opçoes:"
		@ 89, 40 SAY OemToAnsi(STR0089) SIZE 53, 7 OF oDlg PIXEL  // "Consulta Padrão:"
		@ 89, 4 SAY OemToAnsi(STR0090) SIZE 22, 7 OF oDlg PIXEL  // "Nível:"
		@ 99, 141 SAY OemToAnsi(STR0091) SIZE 35, 7 OF oDlg PIXEL  // "Propriedade:"
		@ 99, 184 SAY OemToAnsi(STR0044) SIZE 33, 7 OF oDlg PIXEL  // "Contexto:"
		@ 99, 227 SAY OemToAnsi(STR0045)+":" SIZE 33, 7 OF oDlg PIXEL  // "Campo"
		@ 111, 4 SAY OemToAnsi(STR0046) SIZE 100, 7 OF oDlg PIXEL  // "Inicializador Padrão:"


		@11,4 MSGET oCampo VAR M->X3_CAMPO  SIZE 41,10 Of oDlg PIXEL PICTURE "@!" ;
			VALID (x3_Campo(cOldCampo) .and. (	lBitMap := Iif("BITMAP" $ M->X3_CAMPO,.T.,.F.),DbSelectArea("SX5"),lRet:=POEDEFAULT(X3_CAMPO,@cTipo,@X3_TITULO,@X3_DESCRIC,@X3_NIVEL,@nVisual,@nCOntext,@lObrigat,@X3_TAMANHO,@X3_PROPRI,@lWhen,oTipo,oVisual,oContext),DbSelectArea("SX3"),lRet))  WHEN SubStr(cPode,1,1)=="x" ;
			ON CHANGE (lAltered := .t.)

		@11,52 COMBOBOX oTipo VAR cTipo ITEMS  aTipo SIZE 43,42  OF oDlg PIXEL;
			ON CHANGE (M->X3_TIPO := Substr(cTipo,1,1),x3_tipo(),lAltered := .T.);
			WHEN (M->X3_PROPRI == "U" .and. nOpc == 1 .and. lWhen)  //Substr(cPode,2,1)=="x"

		@11,101 MSGET oTam  VAR M->X3_TAMANHO  SIZE 31,10 OF oDlg PIXEL PICTURE "999";
			VALID ( x3_Tamanho() .and. (M->X3_TAMANHO>=nWhenTam) ) WHEN (SubStr(cPode,3,1)=="x".and.M->X3_TIPO!="L".and.M->X3_TIPO!="D".and. lWhen .and. lNoSXG);
			ON CHANGE (lAltered:=.T.)

		@11,138 MSGET oDec   VAR M->X3_DECIMAL  SIZE 28,10 OF oDlg PIXEL PICTURE "9";
			VALID ( x3_Decimal() .and. (M->X3_DECIMAL>=nWhEndec) ) WHEN (SubStr(cPode,4,1)=="x".and. M->X3_TIPO=="N".and. lWhen .and. lNoSXG);
			ON CHANGE (lAltered:=.T.)

		@11,170 MSGET oFormat  VAR M->X3_PICTURE SIZE 50,10 OF oDlg PIXEL;
			PICTURE	 "@!S10" WHEN (M->X3_TIPO != "M" .and. lWhen .and. lNoSXG);
			ON CHANGE (lAltered:=.T.)

		@11,223 BUTTON oCabec PROMPT STR0109 SIZE 43,12 OF oDlg PIXEL ; //"Editar..."
		ACTION (lAltered:=.T.,EditTitulo(Iif(lBitMap,.T.,lWhen)),oDescr:SetFocus())

		@33,3  BUTTON oDescr PROMPT STR0109 SIZE 31,12 OF oDlg PIXEL; //"Editar..."
		ACTION (lAltered:=.T.,EditDescr(Iif(lBitMap,.T.,lWhen)),oFolder:SetFocus())

		@33,40 COMBOBOX oFolder VAR cFolder ITEMS aFolder SIZE 92,50 OF oDlg PIXEL;
			ON CHANGE (M->X3_FOLDER:=Substr(cFolder,1,1),lAltered:=.T.) When lWhen

		@55,4	 MSGET oValUsu  VAR M->X3_VLDUSER SIZE 128,10 OF oDlg PIXEL ON CHANGE (lAltered:=.T.);
			WHEN M->X3_TIPO != "M" .and. lWhen

		@76,4	 MSGET oValSis  VAR M->X3_VALID  SIZE 128,10 OF oDlg PIXEL  READONLY When lWhen

		@33,138 GET oHelp  VAR cHelp SIZE 129,32 OF oDlg PIXEL MEMO When (lWhen .and. M->X3_PROPRI == "U")
		oHelp:oFont := oFont
		oHelp:bRClicked := {||AllwaysTrue()}

		@76,137	 BUTTON ox3Box PROMPT STR0109 SIZE 43,12 OF oDlg PIXEL; //Editar...
		ACTION (EditX3Box(lWhen .and. M->x3_tipo == "C" .and. Empty(M->X3_F3) .and. M->X3_PROPRI == "U"),oNivel:SetFocus())

		@97,5	MSGET oNivel   VAR M->X3_NIVEL SIZE 31,10 OF oDlg PIXEL PICTURE "9";
			ON CHANGE (lAltered:=.T.) When lWhen

		@97,40 COMBOBOX oF3 VAR cF3 ITEMS aF3 SIZE 92,50 OF oDlg PIXEL;
			ON CHANGE (M->X3_F3:=Substr(cF3,1,3),lAltered:=.T.) When lWhen

		@106,140 RADIO oVisual VAR nVisual PROMPT OemToAnsi(STR0047),OemToAnsi(STR0048) SIZE  30,9 OF oDlg PIXEL;  // "&Alterar" ### "&Visualizar"
		ON CHANGE (M->X3_VISUAL:=Iif(nVisual==1,"A","V"),lAltered:=.T.) WHEN M->X3_TIPO != "M".and. lWhen

		@106,183	RADIO oContext   VAR nContext PROMPT OemToAnsi(STR0049),OemToAnsi(STR0050) SIZE 25,9 OF oDlg PIXEL;  // "&Real" ### "&Virtual"
		ON CHANGE (M->X3_CONTEXT:=Iif(nContext ==1," ","V"),cNewContext :=M->X3_CONTEXT,lAltered:=.T.) WHEN M->X3_PROPRI=="U".and.lWhen

		@109,228 CHECKBOX oObrig  VAR lObrigat PROMPT OemToAnsi(STR0051) SIZE	35,10 OF oDlg PIXEL;  // "&Obrigatório"
		ON CLICK  (M->X3_OBRIGAT:=Iif(lObrigat,Str2bin("x       "),Str2Bin(Space(8))),lAltered:=.T.,;
			M->X3_RESERV:= Iif(M->X3_PROPRI== "U",Iif(lObrigat,X3Reserv(Substr(X3Reserv(M->X3_RESERV),1,6)+"x "+right(X3Reserv(M->X3_RESERV),6) ),X3Reserv(Substr(X3Reserv(M->X3_RESERV),1,6)+" x"+"x "+right(X3Reserv(M->X3_RESERV),6))),M->X3_RESERV));
			WHEN lWhen .and. (Substr(X3Reserv(M->X3_RESERV),7,1)==" " .or. M->X3_PROPRI == "U") .and. lUsado

		oObrig:oFont := oDlg:oFont
		@119,5 MSGET oInitPad  VAR M->X3_RELACAO SIZE 126,10 OF oDlg PIXEL PICTURE "@!";
			ON CHANGE (lAltered:=.T.)	When lWhen

		DEFINE SBUTTON FROM 136,211 TYPE 1 ENABLE OF oDlg ACTION (nOpca:= 1, oDlg:End())
		DEFINE SBUTTON FROM 136,239 TYPE 2 ENABLE OF oDlg ACTION (nOpca:= 0, oDlg:End())

		ACTIVATE MSDIALOG oDlg ON INIT SetFocus(oCampo:hwnd)
		oFont:End()
	EndIf


	If nOpca == 0
		Return 0
	ElseIf nOpc == 2
		If M->X3_PROPRI == "U"
			aCampos[nPos,7] := M->X3_RESERV
			aCampos[nPos,8] := M->X3_OBRIGAT
		EndIf
	EndIf

	If cHelp != cOldHelp
		For i := 1 To 5
			nPosHlp := At(Chr(13)+chr(10),cHelp)
			If nPosHlp > 0
				cHelp := Padr(substr(cHelp,1,nPosHlp-1),40*i)+Substr(cHelp,nPosHlp+2)
			EndIf
		Next i
		EditHlp(M->X3_CAMPO,cHelp)
	EndIf

	lModStr := Iif(cNewContex != cOldContex,.T.,.F.)
	If  nOpca== 1 .AND. ;
			(  M->x3_campo   != x3_campo    .OR.;
			M->x3_tipo    != x3_tipo    .OR.;
			M->x3_tamanho != x3_tamanho .OR.;
			M->x3_decimal != x3_decimal .OR. lModStr)
		AltStr := .T.
		If LEN(aStrAnt) == 0
			aStrAnt := CurArq->(DBStruct())
			aStrAtu := CurArq->(DBStruct())
		EndIf
		*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		*³ Move os campos aceitos para o array contEndo a estrutura     ³
		*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		lReal := Iif(M->x3_context != "V",.T.,lReal)
		nInd:=0
		nInd := Ascan(aStratu, { |x| x[1] == AllTrim(M->x3_campo) } )
		If nInd  == 0 .and. M->X3_CONTEXT != "V" .and. M->X3_CAMPO != STR0035
			AADD(aStrAtu,{ AllTrim(M->x3_campo),M->x3_tipo,M->x3_tamanho,M->x3_decimal})
		ElseIf M->X3_CONTEXT != "R" .and. lModStr .and. nInd != 0
			aStrAtu[nInd][1] := OemToAnsi(STR0035) // "Deletado"
		ElseIf M->X3_Campo==OemToAnsi(STR0035) .and. M->x3_context != "V"  // "Deletado"
			nInd := Ascan(aStratu, { |x| x[1] == AllTrim(x3_campo) } )
			If nInd # 0
				aStrAtu[nInd][1] := OemToAnsi(STR0035)  // "Deletado"
			EndIf
		EndIf
		If nOpc==1
			nInd := 0
			For i := 1 To Len(aSx3)
				cSx3Alias := SeleSx3(aSx3[i,1],aSx3[i,2])
				SEEK cArq
				/*----------------------
				M->x3_ordem := 1
				While cArq = x3_arquivo
					M->x3_ordem++
					Skip
				End
				-----------------------*/
				M->x3_ordem := Len(aCampos)+1
				RecLock(cSx3Alias,.T.)
				M->x3_ordem   := RetAsc(Str(M->x3_ordem),2,.T.)
				M->x3_arquivo := cArq

				If ( AllTrim(Subs(M->X3_CAMPO, 4)) $ cCposdef ) .Or. ( AllTrim(Subs(M->X3_CAMPO, 4)) $ cCposdef )
					M->x3_usado := Str2Bin(FirstBitOn(Space(102)) )
				Else
					M->x3_usado := Str2Bin(FirstBitOn(Space(99)+"x  "))
				EndIf
				If cSx3Alias == "SX3"
					If SubStr( X3Reserv(M->X3_RESERV),8,1 ) == "x" .And. ! ( AllTrim(Subs(M->X3_CAMPO,3)) $ cCposDef ) .And. ! x031Str(Subs(M->X3_CAMPO,4),cCposDef)
						lx3Uso := 	.T.
					EndIf

					AADD(aCampos,{lX3Uso,If(M->X3_BROWSE=="S",.T.,.F.),M->x3_ordem,M->x3_campo,&("M->"+aCpoDesc[COLDESC1]),M->X3_USADO,m->x3_reserv,M->x3_obrigat,&("M->"+aCpoDesc[COLDESC2]),&("M->"+aCpoDesc[COLDESC3])})
				EndIf

			Next i
		EndIf

		If nInd != 0 .and. M->X3_CONTEXT != "V"
			aStrAtu[nInd][1] := AllTrim(M->x3_campo)
			aStrAtu[nInd][2] := M->x3_tipo
			aStrAtu[nInd][3] := M->x3_tamanho
			aStrAtu[nInd][4] := M->x3_decimal
		EndIf
	EndIf

	nOldOrdSx3 := IndexOrd()
	If (lAltered .AND. nOpca!=0) .OR. (nOpc == 3 .AND. nOpcA == 1)
		For j := 1 to Len(aSx3)
			cSx3Alias := SeleSx3(aSx3[j,1],aSx3[j,2])
			If !AltStr
				DbSeek(M->X3_ARQUIVO+M->X3_ORDEM)
			EndIf
			RecLock(cSx3Alias,.F.)

			#ifdef SPANISH

				//gravacao do titulo
				If Empty(M->X3_TITSPA)
					If ( Empty(M->X3_TITENG) )
						M->X3_TITSPA := M->X3_TITULO
					Else
						M->X3_TITSPA := M->X3_TITENG
					EndIf
				EndIf
				If Empty(M->X3_TITULO)
					M->X3_TITULO := M->X3_TITSPA
				EndIf
				If Empty(M->X3_TITENG)
					M->X3_TITENG := M->X3_TITSPA
				EndIf

				//gravacao da descricao
				If Empty(X3_DESCSPA)
					If ( Empty(M->X3_DESCENG) )
						X3_DESCSPA := M->X3_DESCRIC
					Else
						X3_DESCSPA := M->X3_DESCENG
					EndIf
				EndIf
				If Empty(M->X3_DESCRIC)
					M->X3_DESCRIC := M->X3_DESCSPA
				EndIf
				If Empty(M->X3_DESCENG)
					M->X3_DESCENG := M->X3_DESCSPA
				EndIf

				//gravacao do combo
				If Empty(M->X3_CBOXSPA)
					If ( Empty(M->X3_CBOXENG) )
						M->X3_CBOXSPA := M->X3_CBOX
					Else
						M->X3_CBOXSPA := M->X3_CBOXENG
					EndIf
				EndIf
				If Empty(M->X3_CBOX)
					M->X3_CBOX := M->X3_CBOXSPA
				EndIf
				If Empty(M->X3_CBOXENG)
					M->X3_CBOXENG := M->X3_CBOXSPA
				EndIf
			#else
				#ifdef ENGLISH

					//gravacao do titulo
					If Empty(M->X3_TITENG)
						If ( Empty(M->X3_TITSPA) )
							M->X3_TITENG := M->X3_TITULO
						Else
							M->X3_TITENG := M->X3_TITSPA
						EndIf
					EndIf
					If Empty(M->X3_TITULO)
						M->X3_TITULO := M->X3_TITENG
					EndIf
					If Empty(M->X3_TITSPA)
						M->X3_TITSPA := M->X3_TITENG
					EndIf

					//gravacao da descricao
					If Empty(X3_DESCENG)
						If ( Empty(M->X3_DESCSPA) )
							X3_DESCENG := M->X3_DESCRIC
						Else
							X3_DESCENG := M->X3_TITSPA
						EndIf
					EndIf
					If Empty(M->X3_DESCRIC)
						M->X3_DESCRIC := M->X3_DESCENG
					EndIf
					If Empty(M->X3_DESCSPA)
						M->X3_DESCSPA := M->X3_DESCENG
					EndIf

					//gravacao do combo
					If Empty(M->X3_CBOXENG)
						If ( Empty(M->X3_CBOXSPA) )
							M->X3_CBOXENG := M->X3_CBOX
						Else
							M->X3_CBOXENG := M->X3_CBOXSPA
						EndIf
					EndIf
					If Empty(M->X3_CBOX)
						M->X3_CBOX := M->X3_CBOXENG
					EndIf
					If Empty(M->X3_CBOXSPA)
						M->X3_CBOXSPA := M->X3_CBOXENG
					EndIf
				#else

					//gravacao do titulo
					If Empty(M->X3_TITULO)
						If ( Empty(M->X3_TITENG) )
							M->X3_TITULO := M->X3_TITSPA
						Else
							M->X3_TITULO := M->X3_TITENG
						EndIf
					EndIf
					If Empty(M->X3_TITENG)
						M->X3_TITENG := M->X3_TITULO
					EndIf
					If Empty(M->X3_TITSPA)
						M->X3_TITSPA := M->X3_TITULO
					EndIf

					//gravacao da descricao
					If Empty(M->X3_DESCRIC)
						If ( Empty(M->X3_DESCENG) )
							M->X3_DESCRIC := M->X3_DESCSPA
						Else
							M->X3_DESCRIC := M->X3_DESCENG
						EndIf
					EndIf
					If Empty(M->X3_DESCENG)
						M->X3_DESCENG := M->X3_DESCRIC
					EndIf
					If Empty(M->X3_DESCSPA)
						M->X3_DESCSPA := M->X3_DESCRIC
					EndIf

					//gravacao do combo
					If Empty(M->X3_CBOX)
						If ( Empty(M->X3_CBOXENG) )
							M->X3_CBOX := M->X3_CBOXSPA
						Else
							M->X3_CBOX := M->X3_CBOXENG
						EndIf
					EndIf
					If Empty(M->X3_CBOXENG)
						M->X3_CBOXENG := M->X3_CBOX
					EndIf
					If Empty(M->X3_CBOXSPA)
						M->X3_CBOXSPA := M->X3_CBOX
					EndIf
				#endif
			#endif

			FOR i := 1 TO FCount()
				cCpo := AllTrim(FieldName(i))
				FIELDPUT(i,M->&(EVAL(bCampo,i)))
			NEXT i
			MsUnlock()
			dbCommit()
		Next j
		DbSelectArea("SX3")
		DbSetOrder(nOldOrdSx3)
		If nOpc == 2
			If SubStr(X3Reserv(M->X3_RESERV),8,1) == "x" .And. !(AllTrim(Subs(M->X3_CAMPO,3)) $ cCposDef) .And. ! x031Str(Subs(M->X3_CAMPO,4),cCposDef)
				lx3Uso := 	.T.
			EndIf

			aCampos[nPos] :={lX3Uso,If(M->X3_BROWSE=="S",.T.,.F.),M->x3_ordem,M->x3_campo,&("M->"+aCpoDesc[COLDESC1]),M->x3_usado,m->x3_reserv,m->x3_obrigat,&("M->"+aCpoDesc[COLDESC2]),&("M->"+aCpoDesc[COLDESC3])}
		ElseIf nOpc == 3
			ACampos[nPos,4]:=OemToAnsi(STR0035)  // "Deletado"
			aCampos[nPos,1]:=.F.
			aCampos[nPos,2]:=.F.
		EndIf
	EndIf

	If ((cNewContex == cOldContex .and. cNewContex == "V" )  .or. ;
			(cNewContex == "V" .and. nOpc == 1)) .and. !lReal .and. nOpc !=3
		AltStr := .F.
	EndIf

	Return Nil

Function EditTitulo(lWhenEdit)
	Local oDlgTitulo
	Local lConfirm := .F.
	Local aVar := Array(3)
	Local aCaption := Array(3)

	DEFAULT lWhenEdit := .T.

	aVar[1] := M->X3_TITULO
	aVar[2] := M->X3_TITSPA
	aVar[3] := M->X3_TITENG

	aCaption[1] := STR0110 //"Cabecalho em Portugues:"
	aCaption[2] := STR0112 //"Cabecalho em Espanhol:"
	aCaption[3] := STR0111 //"Cabecalho em Ingles:"

	DEFINE MSDIALOG oDlgTitulo FROM 00,00 TO 140,220 TITLE STR0113 PIXEL //"Editar Cabeçalho"

	@02,04 SAY aCaption[COLDESC1] OF oDlgTitulo PIXEL
	@11,04 MSGET aVar[COLDESC1] OF oDlgTitulo SIZE 72,10 PIXEL WHEN lWhenEdit

	@25,04 SAY aCaption[COLDESC2] OF oDlgTitulo PIXEL
	@33,04 MSGET aVar[COLDESC2] OF oDlgTitulo SIZE 72,10 PIXEL WHEN lWhenEdit

	@47,04 SAY aCaption[COLDESC3] OF oDlgTitulo PIXEL
	@55,04 MSGET aVar[COLDESC3] OF oDlgTitulo SIZE 72,10 PIXEL WHEN lWhenEdit

	DEFINE SBUTTON FROM 11,80 TYPE 1 ENABLE OF oDlgTitulo ACTION (lConfirm := .T., oDlgTitulo:End())
	DEFINE SBUTTON FROM 25,80 TYPE 2 ENABLE OF oDlgTitulo ACTION oDlgTitulo:End()

	ACTIVATE MSDIALOG oDlgTitulo CENTERED

	If ( lConfirm .And. lWhenEdit )
		M->X3_TITULO := aVar[1]
		M->X3_TITSPA := aVar[2]
		M->X3_TITENG := aVar[3]
	EndIf
	Return

Function EditDescr(lWhenEdit)
	Local oDlgDesc
	Local lConfirm := .F.
	Local aVar := Array(3)
	Local aCaption := Array(3)

	DEFAULT lWhenEdit := .T.

	aVar[1] := M->X3_DESCRIC
	aVar[2] := M->X3_DESCSPA
	aVar[3] := M->X3_DESCENG

	aCaption[1] := STR0115 //"Descrição em Portugues:"
	aCaption[2] := STR0117 //"Descrição em Espanhol:"
	aCaption[3] := STR0116 //"Descrição em Ingles:"

	DEFINE MSDIALOG oDlgDesc FROM 00,00 TO 140,333 TITLE STR0114 PIXEL //"Editar Descrição"

	@02,04 SAY aCaption[COLDESC1] OF oDlgDesc PIXEL
	@11,04 MSGET aVar[COLDESC1] OF oDlgDesc SIZE 128,10 PIXEL WHEN lWhenEdit

	@25,04 SAY aCaption[COLDESC2] OF oDlgDesc PIXEL
	@33,04 MSGET aVar[COLDESC2] OF oDlgDesc SIZE 128,10 PIXEL WHEN lWhenEdit

	@47,04 SAY aCaption[COLDESC3] OF oDlgDesc PIXEL
	@55,04 MSGET aVar[COLDESC3] OF oDlgDesc SIZE 128,10 PIXEL WHEN lWhenEdit

	DEFINE SBUTTON FROM 11,136 TYPE 1 ENABLE OF oDlgDesc ACTION (lConfirm := .T., oDlgDesc:End())
	DEFINE SBUTTON FROM 25,136 TYPE 2 ENABLE OF oDlgDesc ACTION oDlgDesc:End()

	ACTIVATE MSDIALOG oDlgDesc CENTERED

	If ( lConfirm .And. lWhenEdit )
		M->X3_DESCRIC := aVar[1]
		M->X3_DESCSPA := aVar[2]
		M->X3_DESCENG := aVar[3]
	EndIf
	Return

Function EditX3Box(lWhenEdit)
	Local oDlgX3Box
	Local lConfirm := .F.
	Local aVar := Array(3)
	Local aCaption := Array(3)

	DEFAULT lWhenEdit := .T.

	aVar[1] := M->X3_CBOX
	aVar[2] := M->X3_CBOXSPA
	aVar[3] := M->X3_CBOXENG

	aCaption[1] := STR0122 //"Lista em Portugues"
	aCaption[2] := STR0124 //"Lista em Espanhol"
	aCaption[3] := STR0123 //"Lista em Ingles"

	DEFINE MSDIALOG oDlgX3Box FROM 00,00 TO 140,333 TITLE STR0121 PIXEL //"Editar Lista de Opções"

	@02,04 SAY aCaption[COLDESC1] OF oDlgX3Box PIXEL
	@11,04 MSGET aVar[COLDESC1] OF oDlgX3Box SIZE 128,10 PIXEL WHEN lWhenEdit

	@25,04 SAY aCaption[COLDESC2] OF oDlgX3Box PIXEL
	@33,04 MSGET aVar[COLDESC2] OF oDlgX3Box SIZE 128,10 PIXEL WHEN lWhenEdit

	@47,04 SAY aCaption[COLDESC3] OF oDlgX3Box PIXEL
	@55,04 MSGET aVar[COLDESC3] OF oDlgX3Box SIZE 128,10 PIXEL WHEN lWhenEdit

	DEFINE SBUTTON FROM 11,136 TYPE 1 ENABLE OF oDlgX3Box ACTION (lConfirm := .T., oDlgX3Box:End())
	DEFINE SBUTTON FROM 25,136 TYPE 2 ENABLE OF oDlgX3Box ACTION oDlgX3Box:End()

	ACTIVATE MSDIALOG oDlgX3Box CENTERED

	If ( lConfirm .And. lWhenEdit )
		M->X3_CBOX    := aVar[1]
		M->X3_CBOXSPA := aVar[2]
		M->X3_CBOXENG := aVar[3]
	EndIf
	Return

	/*
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Fun‡…o    ³ SayConPad³ Autor ³ Ary Medeiros          ³ Data ³          ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡…o ³ Retorna consulta padrao do campo                           ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Sintaxe e ³ ExpC1 := SayConPad(ExpC2)                                  ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Parametros³ ExpC1 := Retorna consulta do campo                         ³±±
	±±³          ³ ExpC2 := Nome do Campo                                     ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³ Uso      ³ CFGx031.PRG                                                ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	*/
Function SayConPad(cCampo)
	Local cSavAlias := Alias(), cRet := ""

	If Empty(cCampo)
		Return Space(29)
	EndIf
	DbSelectArea("SXB")
	nSavRec := Recno()
	DbSeek(cCampo+"1")
	If Found()
		cRet := cCampo + " - "+OemToAnsi(Substr(XBDESCRI(),1,25))
		DbGoTo(nSavRec)
	Else
		DbGoTo(nSavRec)
		DbSelectArea("SX5")
		DbGoTop()
		While X5_TABELA == "00"
			If AllTrim(cCampo) == AllTrim(X5_CHAVE)
				cRet := cCampo +" - "+Substr(X5DESCRI(),1,25)
				Exit
			EndIf
			DbSkip()
		End
	EndIf
	If !Empty(cSavAlias)
		DbSelectArea(cSavAlias)
	EndIf
	Return If(Empty(cRet),Space(29),cRet)

	/*
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Fun‡…o    ³ GetHelp  ³ Autor ³ Ary Medeiros          ³ Data ³          ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡…o ³ Retorna Help do campo                                      ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Sintaxe e ³ ExpA1 := GetHelp(ExpC2)                                    ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Parametros³ ExpC1 := Array com Help do Campo                           ³±±
	±±³          ³ ExpC2 := Nome do Campo                                     ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³ Uso      ³ CFGx031.PRG                                                ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	*/
Function GetHelp(cCampo)
	Local nHlpHdl, xNumEnt,nRegLid,nLerInd,cIndice,nPosHlp:=0, cHelp,cRet
	Local cArqHlp := RetHlpFile()

	If Empty(cCampo)
		Return Space(200)
	EndIf
	If File(cArqHlp)
		nHlpHdl := fOpen(cArqHlp,2 + 64) //FO_READWRITE+FO_SHARED
	Else
		Return Space(200)
	EndIf

	xNumEnt := "  "
	FSEEK(nHlpHdl,-2,2)
	FREAD(nHlpHdl,@xNumEnt,2)
	xNumEnt := Bin2I(xNumEnt)
	FSEEK(nHlpHdl,(-10*xNumEnt)-2,2)
	*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	*³ Procura a Entrada no Indice                              ³
	*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nRegLid := 0
	While nRegLid < xNumEnt
		nLerInd := Iif((xNumEnt-nRegLid)>100,100,xNumEnt-nRegLid)
		cIndice := Space(nLerInd*10)
		FREAD(nHlpHdl,@cIndice,nLerInd*10)
		nPosHlp := AT(cCampo,cIndice)
		If nPosHlp > 0
			nPosHlp+=(nRegLid*10)
			Exit
		EndIf
		nRegLid+=nLerInd
	End
	If nPosHlp == 0
		cRet := Space(200)
	Else
		FSEEK(nHlpHdl,((nPosHlp-1)/10)*200,0)
		cHelp := Space(200)
		FREAD(nHlpHdl,@cHelp,200)
		cRet := cHelp
	EndIf
	FClose(nHlpHdl)
	Return cRet

	/*
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Fun‡…o    ³  SeleF3  ³ Autor ³ Ary Medeiros          ³ Data ³          ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡…o ³ Combo Box para selecao da consulta padrao                  ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Sintaxe e ³ Void SeleF3(Void)                                          ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Parametros³ Sem Parametros                                             ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³ Uso      ³ CFGx031.PRG                                                ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	*/
Function SeleF3()
	Local nOpc
	Local aOpc := {}
	Local cSavAlias := Alias()
	Local nSavRec

	DbSelectArea("SXB")
	nSavRec := Recno()
	DbGoTop()
	AADD(aOpc,Space(31))
	While !Eof()
		If XB_TIPO == "1" .and. XB_ALIAS != "SX5"
			AADD(aOpc,XB_ALIAS+" - "+OemToAnsi(Substr(XBDESCRI(),1,25)))
		EndIf
		DbSkip()
	End
	DbGoTo(nSavRec)
	DbSelectArea("SX5")
	DbGoTop()
	While X5_TABELA == "00"
		AADD(aOpc,SubStr(X5_CHAVE,1,3)+" - "+Capital(OemToAnsi(Substr(X5DESCRI(),1,25))))
		DbSkip()
	End


	DbSelectArea(cSavAlias)

	Return aOpc

Function SeleFolder(cAlias)
	Local nOpc
	Local aOpc := {}
	Local cSavAlias := Alias()

	DEFAULT cAlias := ""

	DbSelectArea("SXA")
	DbSetOrder(1)
	DbSeek(cAlias)
	Aadd(aOpc,Space(34))
	While !Eof() .And. XA_ALIAS == cAlias
		Aadd(aOpc,XA_ORDEM+" - "+OemToAnsi(XADESCRIC()))
		DbSkip()
	End
	DbSelectArea(cSavAlias)
	Return aOpc

	/*
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Fun‡…o    ³ EditHlp  ³ Autor ³ Ary Medeiros          ³ Data ³          ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡…o ³ Faz a edicao do texto do help do campo                     ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Sintaxe e ³ Void EditHlp(ExpC1)                                        ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Parametros³ ExpC1 := Nome do campo                                     ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³ Uso      ³ CFGx031.PRG                                                ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	*/
Function EditHlp(cCampoH,cHelp)
	Local GetList := {},nArea,lCriaHelp:=.F.,nTamInd
	Local nSeek,nPosAnt,nPosUlt,nRegLid,nRegs:=0,xBuffer,aBut,nPosHlp := 0
	Local lGrava:=.F.
	Local cArqHlp := RetHlpFile()

	If FILE(cArqHlp)
		nHlpHdl := FOPEN(cArqHlp,2+64) //FO_READWRITE + FO_SHARED
	Else
		nHlpHdl := MSFCREATE(cArqHlp)
		FWRITE(nHlpHdl,(CHR(0)+CHR(0)),2)
		Commit
	EndIf
	If nHlpHdl <= 0
		Tone(3500,1)
		help := .F.
		Return .T.
	EndIf
	*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	*³ Recupera o indice                                        ³
	*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	xNumEnt := "  "
	FSEEK(nHlpHdl,-2,2)
	FREAD(nHlpHdl,@xNumEnt,2)
	xNumEnt := Bin2I(xNumEnt)
	FSEEK(nHlpHdl,(-10*xNumEnt)-2,2)
	*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	*³ Procura a Entrada no Indice                              ³
	*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nRegLid := 0
	While nRegLid < xNumEnt
		nLerInd := Iif((xNumEnt-nRegLid)>100,100,xNumEnt-nRegLid)
		cIndice := Space(nLerInd*10)
		FREAD(nHlpHdl,@cIndice,nLerInd*10)
		nPosHlp := AT(cCampoH,cIndice)
		If nPosHlp > 0
			nPosHlp+=(nRegLid*10)
			Exit
		EndIf
		nRegLid+=nLerInd
	End
	If nPosHlp = 0
		cHelp := Padr(cHelp,200)
		lCriaHelp:=.T.
	Else
		lGrava := .T.
	EndIf

	If lCriaHelp
		/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		³ Adiciona 200 brancos ao arquivo atual           ³
		ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
		nPosAnt:=FSEEK(nHlpHdl,0,2)-2
		FWRITE(nHlpHdl,Space(200),200)
		FSEEK(nHlpHdl,-2,2) /// Mudei de 0 para -2
		xNumEnt++
		cIndice := cCampoH + I2BIN(xNumEnt)
		FWRITE(nHlpHdl,cIndice,12)
		nPosUlt:=FSEEK(nHlpHdl,0,2)-12
		/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		³ Regrava o indice deslocando 210 posicoes adiante³
		ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
		xNumEnt--
		nRegLid:=0
		While nRegLid < (xNumEnt)
			nRegs := Iif((xNumEnt-nRegLid)>100,100,xNumEnt-nRegLid)
			nRegLid+=nRegs
			/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			³ Le a Posicao original do Indice     ³
			ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
			xBuffer:=Space(nRegs*10)
			nPosAnt-=nRegs*10
			FSEEK(nHlpHdl,nPosAnt,0)
			FREAD(nHlpHdl,@xBuffer,(nRegs*10))
			/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			³ Grava na nova posicao do indice     ³
			ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
			nPosUlt-=nRegs*10
			FSEEK(nHlpHdl,nPosUlt,0)
			FWRITE(nHlpHdl,@xBuffer,(nRegs*10))
		End
		/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		³ Posiciona o ponteiro no fim do arquivo.         ³
		ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
		nSeek := FSEEK(nHlpHdl,(xNumEnt)*200,0)
		If nSeek < 0;FSEEK(nHlpHdl,-2,2);EndIf
			FWRITE(nHlpHdl,cHelp,200)
			Commit
		Else
			FSEEK(nHlpHdl,0,0)
			FSEEK(nHlpHdl,(((nPosHlp-1)/10)*200),0)
			FWRITE(nHlpHdl,cHelp,200)
			Commit
		EndIf
		// Acertar Variaveis Globais do Protheus

		*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		*³ Recupera o indice                                        ³
		*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		xNumEnt := "  "
		FSEEK(nHlpHdl,-2,2)
		FREAD(nHlpHdl,@xNumEnt,2)
		xNumEnt := Bin2I(xNumEnt)
		FSEEK(nHlpHdl,(-10*xNumEnt)-2,2)
		cIndice := Space(xNumEnt*10)
		FREAD(nHlpHdl,@cIndice,xNumEnt*10)
		PutGlbValue("HLPIDXSTR"+cArqHlp+GetEnvServer(),cIndice)
		PutGlbValue(cCampoH+cArqHlp+GetEnvServer(),cHelp)
		FClose(nHlpHdl)
		Return nil

		/*
		ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
		±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
		±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
		±±³Fun‡…o    ³ X031BrOk ³ Autor ³ Ary Medeiros          ³ Data ³          ³±±
		±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
		±±³Descri‡…o ³ Funcao de validacao para a alteracao do Browse             ³±±
		±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
		±±³ Uso      ³ CFGx031.PRG                                                ³±±
		±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
		±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
		ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
		*/
	Function X031BrOk(aArray,nEl)
		Local i

		For i:= 1 to Len(aArray)
			If aArray[i,1] .and. i <> nEl
				Return .t.
			EndIf
		Next
		Return .F.

		/*
		ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
		±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
		±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
		±±³Fun‡…o    ³ AtualizaIdx³Autor ³ Cristiane Maeda      ³ Data ³ 27/07/95 ³±±
		±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
		±±³Descri‡…o ³ Deleta Indices Antigos e Cria Novo Indice                  ³±±
		±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
		±±³ Uso      ³ CFGx031.PRG                                                ³±±
		±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
		±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
		ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
		*/
		Static ;
		Function AtualizaIdx( oMeter, oText, oDlg, lEnd, cSixAlias,cAtuAlias)
		Local cArq,cArq1,nOrdem
		Local cDriver := __cRDd, xDriver := "DBFCDX"
		If __cRDD == "TOPCONN"
			#ifdef WNTX
				xDriver := "DBFNTX"
			#endif
			cDriver := Iif(cSixAlias $ "SH7/SH9",xDriver,cDriver)
		EndIf


		DbSelectArea("SX2")
		DbSeek(cSixAlias)
		If !Found()
			HELP(" ","1","OpenIndx")
			Return
		EndIf

		cArq := RetArq(cDriver,AllTrim(X2_PATH) + AllTrim(X2_ARQUIVO),.T.)

		DbSelectArea("SIX")
		DbSeek(cSixAlias)

		While (cSixAlias == INDICE) .and. !Eof()
			cSixChave := AllTrim(CHAVE)
			cArq1 := cArq
			DbSelectArea(cAtuAlias)

			cArq1 := FileNoExt(cArq1)+SIX->ORDEM
			cArq1 := RetArq(cDriver,cArq1,.F.)
			If FILE (cArq1 )
				FERASE(cArq1)
			EndIf
			oText:cMsg:= Substr(cArq1,Rat("\",cArq1)+1)
			ordCondSet( , "",,, {|| (SysRefresh(),.t.)}, 10, RECNO(),,,,"")
			ordCreate(cArq1,, cSixChave, {|| Iif("DESCEnd"$Upper(cSixChave),MontChav(cSixChave),&cSixChave)}, )
			DbCommit()

			DbSelectArea("SIX")
			DbSkip()
		End

		Return


		/*
		ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
		±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
		±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
		±±³Fun‡…o    ³ CheckCompart³Autor ³ Cristiane Maeda      ³ Data ³ 15/08/95 ³±±
		±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
		±±³Descri‡…o ³ VerIfica se o arquivo a ser alterado   ‚ compartilho entre  ³±±
		±±³          ³ outras empresas e monta um array com os arquivos SX3's p/   ³±±
		±±³          ³ serem atualizados.                                          ³±±
		±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
		±±³Retorna   ³ Array c/ SX3 p/serem atualizados                            ³±±
		±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
		±±³ Uso      ³ CFGx031.PRG                                                 ³±±
		±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
		±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
		ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
		*/
		Static ;
		Function CheckCompart(cArq,cArqIni)
		Local cAuxAlias,cArqInd,aAltSX3 := {},cOldEmp:= "",lCdxAxs := .F.
		Local cArqSx2

		#ifdef CDX
			lCdxAxs := .T.
		#endif


		DbSelectArea("SM0")
		DbGoTop()

		While !SM0->(Eof())
			If SM0->M0_CODIGO == cOldEmp
				SM0->(DbSkip())
				loop
			EndIf

			If SM0->M0_CODIGO != cEmpAnt
				cAuxAlias := "X2" + SM0->M0_CODIGO
				cArqSx2 := "SX2" + SM0->M0_CODIGO+"0"
				cArqInd := cArqSx2

				If !MSFILE(cArqSx2+GetDBExtension(),,__LocalDriver)
					dbCloseall()
					Final(cArqSx2 + OemToAnsi(STR0052))  // " n„o existe"
				EndIf

				DbUseArea(.T.,,cArqSx2,cAuxAlias, .F., .T. )
				While !Used()
					Help(" ",1,"SX2 NEXCLUS")
					DbUseArea(.T.,,"SX2"+SM0->M0_CODIGO+"0",cAuxAlias, .T., .T. )
				End

				MsOpenIdx( cArqInd + '1' , 'X2_CHAVE', .T., .T., , cArqInd )

				//		If MSFile(cArqSx2,cArqInd,__LocalDriver)
				//			DbSetIndex(cArqSx2+Iif(lCdxAxs,"","1"))
				//		ElseIf !lCdxAxs
				//			dbCreateIndex( cArqInd,"X2_CHAVE",{|| X2_CHAVE}, If( .F., .T., NIL ) )
				//		Else
				//			Index On X2_CHAVE	TAG &cArqInd To &cArqSx2
				//		EndIf

				dbSetOrder(1)

				DbSeek(cArq)

				If Found()
					If AllTrim(Upper(cArqIni)) ==  RetArq(,Upper(AllTrim(X2_PATH)+AllTrim(X2_ARQUIVO)),.t.)
						AADD(aAltSX3,{"SX3"+SM0->M0_CODIGO+"0","X3"+SM0->M0_CODIGO})
					EndIf
				EndIf
				DbCloseArea()
			Else
				AADD(aAltSX3,{"SX3"+SM0->M0_CODIGO+"0","SX3"})
			EndIf
			cOldEmp := SM0->M0_CODIGO
			SM0->(DbSkip())
		End

		SM0->(DbSeek(cEmpAnt+cFilAnt))
		Return aAltSx3

		/*
		ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
		±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
		±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
		±±³Fun‡…o    ³SeleSx3     ³Autor ³ Cristiane Maeda      ³ Data ³ 15/08/95 ³±±
		±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
		±±³Descri‡…o ³ Deleta Indices Antigos e Cria Novo Indice                  ³±±
		±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
		±±³ Uso      ³ CFGx031.PRG                                                ³±±
		±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
		±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
		ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
		*/
		Static ;
		Function SeleSx3(cArq,cAuxAlias)
		Local cIndSx3,lCdxAxs:= .f.
		Local nI	:= 0
		If Subs(__LocalDriver,4,3) == "CDX"
			lCdxAxs := .T.
		EndIf
		If Select(cAuxAlias) != 0
			DbSelectArea(cAuxAlias)
			Return cAuxAlias
		EndIf

		DbUseArea(.T.,__LocalDriver,cArq,cAuxAlias,.F., .F. )

		While !Used()
			Help("",1,"ARQEXCL",,cArq,1,1)
			DbUseArea(.T.,__LocalDriver,cArq,cAuxAlias,.F., .F. )
		End

		cIndSx3 := RetFileName(cArq)

		MsOpenIdx( cIndSx3+'1' , 'X3_ARQUIVO+X3_ORDEM', .T., .T., , cIndSx3 )
		MsOpenIdx( cIndSx3+'2' , 'X3_CAMPO', .T., .T., , cIndSx3 )
		MsOpenIdx( cIndSx3+'3' , 'X3_GRPSXG+X3_ARQUIVO+X3_ORDEM', .T., .T., , cIndSx3 )
		MsOpenIdx( cIndSx3+'4' , 'X3_FOLDER+X3_ORDEM', .T., .T., , cIndSx3 )

		DbCommit()

		DbSetOrder(1) // Mantem como Default (1)
		Return cAuxAlias

		/*
		ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
		±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
		±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
		±±³Fun‡…o    ³FechaSx3    ³Autor ³ Cristiane Maeda      ³ Data ³ 15/08/95 ³±±
		±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
		±±³Descri‡…o ³Fecha SX3 utilizados para altera‡„o                         ³±±
		±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
		±±³ Uso      ³ CFGx031.PRG                                                ³±±
		±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
		±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
		ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
		*/
		Static ;
		Function FechaSx3(aSx3)
		Local i

		For i := 1 to Len(aSx3)
			If aSx3[i,2] != "SX3"
				If Select(aSx3[i,2]) > 0
					DbSelectArea(aSx3[i,2])
					DbCloseArea()
				EndIf
			EndIf
		Next i

		Return

		/*
		ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
		±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
		±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
		±±³Fun‡…o    ³X031LOG     ³Autor ³ Cristiane Maeda      ³ Data ³ 24/10/95 ³±±
		±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
		±±³Descri‡…o ³Grava Log de Altera‡oes p/ campos Numericos                 ³±±
		±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
		±±³ Uso      ³ CFGx031.PRG                                                ³±±
		±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
		±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
		ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
		*/

	Function X031LOG(cCpo,nRecno,cValAnt)
		Local nHdl,cNome,nTam,xBuffer:= Space(30)
		Local CR := Chr(13)+Chr(10)

		cNome:=__RELDIR+"X031LOG.##R"
		If !File(cNome)
			nHdl:= MSFCREATE(cNome,0)
			xBuffer := OemToAnsi(STR0053) +DTOC(dDataBase)+ CR+CR   // "       Atualiza‡†o da Base de Dados  "
			FWrite(nHdl,xBuffer,Len(xBuffer))
			xBuffer := OemToAnsi(STR0054) + CR  // "Os campos apresentados abaixo tiveram seus valores  truncados ou"
			FWrite(nHdl,xBuffer,Len(xBuffer))
			xBuffer := OemToAnsi(STR0055)+CR  // "zerados, pois os digitos contidos no campo original  excederam o"
			FWrite(nHdl,xBuffer,Len(xBuffer))
			xBuffer := OemToAnsi(STR0056)+CR+CR  // "tamanho do novo campo."
			FWrite(nHdl,xBuffer,Len(xBuffer))
			FClose(nHdl)
		EndIf

		nHdl:= FOpen(cNome,2+64)
		nTam := FSeek(nHdl,0,2)
		Fseek(nHdl,nTam,0)
		xBuffer := OemToAnsi(STR0057)+ Str(nRecno,4)+CR  // "Registro : "
		FWrite(nHdl,xBuffer,Len(xBuffer))
		xBuffer :=	OemToAnsi(STR0045)+" : " + cCpo + CR  // "Campo"
		FWrite(nHdl,xBuffer,Len(xBuffer))
		xBuffer :=	OemToAnsi(STR0092) + cValAnt + CR +CR  // "Valor Anterior : "
		FWrite(nHdl,xBuffer,Len(xBuffer))

		FClose(nHdl)

		Return

		/*
		ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
		±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
		±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
		±±³Fun‡…o    ³ SavArq   ³ Autor ³                       ³ Data ³          ³±±
		±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
		±±³Descri‡…o ³ Copias de Seguranca dos arquivos utilizados                ³±±
		±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
		±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
		ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
		*/

		Static ;
		Function SavArq( oMeter, oText, oDlg, lEnd )
		Local i,j,bBlock1,cMsg,cTitulo,lCdxAxs := .F.

		#ifdef CDX
			lCdxAxs := .T.
		#endif

		oMeter:nTotal := 2*Len(aSx3)

		For j := 1 to Len(aSx3)
			cArqIni := aSx3[j,1]+GetDBExtension()
			cArqFin := aSx3[j,1]+".#DB"
			cMsg := OemtoAnsi(cArqIni)
			//@ 0.4, 6.5  SAY oText VAR cMsg  OF oDlg //oText:cCaption
			oText:SetText( cMsg )
			bblock1:={|| oMeter:Set(j), SysRefresh(), !lEnd}
			EVAL(bblock1)

			__CopyFile( cArqIni, cArqFin )

			If File(aSx3[j,1]+MemoExt())
				__CopyFile( aSx3[j,1]+MemoExt(), aSx3[j,1]+".#"+Substr(MemoExt(),2,2))
			EndIf

		Next j


		*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		*³ Salva Indices                                                ³
		*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		For i := 1 to Len(aSx3)
			cAliasSx3 := SeleSx3(aSx3[i,1],aSx3[i,2])
			dbCloseArea()
			cArqIni := aSX3[i,1]+Iif(lCdxAxs,"","1")+RetIndExt()
			cArqFin := aSX3[i,1]+Iif(lCdxAxs,"","1")+".#"+Substr(RetIndExt(),2,2)
			cMsg := OemtoAnsi(cArqIni)
			//@ 0.4, 6.5  SAY oText VAR cMsg  OF oDlg
			oText:SetText( cMsg )
			bblock1:={|| oMeter:Set(i+j), SysRefresh(), !lEnd}
			EVAL(bblock1)

			__CopyFile( cArqIni, cArqFin )

			cAliasSx3 := SeleSx3(aSx3[i,1],aSx3[i,2])
			dbCloseArea()
			If !lCdxAxs
				cArqIni := aSX3[i,1]+"2"+RetIndExt()
				cArqFin := aSX3[i,1]+"2"+".#NT"

				__CopyFile( cArqIni, cArqFin )
				cMsg := OemtoAnsi(cArqIni)
				//@ 0.4, 6.5  SAY oText VAR cMsg  OF oDlg
				oText:SetText( cMsg )
				bblock1:={|| oMeter:Set(i+j), SysRefresh(), !lEnd}
				EVAL(bblock1)
			EndIf
			cAliasSx3 := SeleSx3(aSx3[i,1],aSx3[i,2])
			dbSetOrder(1)     && mantem como defaut o primeiro indice
		Next i

		Return nil

		/*
		ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
		±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
		±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
		±±³Fun‡…o    ³VerReserv ³ Autor ³ Cristiane Maeda       ³ Data ³28.11.95  ³±±
		±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
		±±³Descri‡…o ³VerIfica permiss„o para alterado de ordem, uso e browse     ³±±
		±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
		±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
		ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
		*/
		Static ;
		Function VerReserv(n_op,lOrd,lUso,lBrow,lUsado)
		Local nSavrec,cPode,lUserObg := .F.,cCposdef

		cCposDef :=  "_USERLGA/_USERGA/_USERLGI/_USERGI/_MSEXP/_MSIMP/_MSIDENT/_MSIDEN" // Campos c/ Caracteristicas Default
		lUserObg := Iif(Substr(Bin2Str(aCampos[n_op,8]),1,1) == "x",.T.,.F.)
		cPode:= X3Reserv(aCampos[n_op,7])
		lOrd := Iif(Substr(cPode,6,1)=="x" ,.T.,.F.)
		lUso := Iif(Substr(cPode,8,1)=="x" .and. !lUserObg,.T.,.F.)
		lUso := lUso .And. !(AllTrim(Subs(aCampos[n_op,4], 3)) $ cCposdef) .and. Subs(aCampos[n_op,4],4,6) != "BITMAT" .And. !(AllTrim(Subs(aCampos[n_op,4], 4)) $ cCposdef)
		lUsado := Iif(!Empty(FirstBitOff(Bin2Str(aCampos[n_op,6]))),.T.,.F.)
		lBrow:= lUsado

		Return Nil

		/*
		ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
		±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
		±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
		±±³Fun‡…o    ³Sort      ³ Autor ³ Cristiane Maeda       ³ Data ³28.11.95  ³±±
		±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
		±±³Descri‡…o ³Altera a ordem de apresenta‡„o dos campos no Browse         ³±±
		±±³          ³(Adapta‡„o da fun‡„o a1choice para altera‡„o da ordem)      ³±±
		±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
		±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
		ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
		*/
		Static ;
		Function Sort(cOld,cNew)
		Local n_op,nOrd,nPasso,aCpo:={},nX

		n_op := Val(RetAsc(cOld,2,.F.))
		nOrd := Val(RetAsc(cNew,2,.F.))
		nPasso := Iif(nOrd > n_op, 1, -1)
		aCpo := aClone(aCampos[n_op])

		FOR nX := n_op TO nOrd STEP nPasso
			cNewOrder := RetAsc(Str(nX),2,.T.)
			If nX == nOrd
				aCampos[nX]   := aClone(aCpo)
				aCampos[nX,3] := cNewOrder
			Else
				aCampos[nX] := aClone(aCampos[nX+nPasso])
				aCampos[nX,3] := cNewOrder
			EndIf
		Next nX
		aCampos := aSort(aCampos,,,{|x,y| x[3] < y[3] })
		Return aCampos


		/*
		ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
		±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
		±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
		±±³Fun‡…o    ³Finaliza³ Descr ³ Abandonar Rotina      ³ Data ³28.11.95  ³±±
		±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÙ±±
		±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
		ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
		*/
		Static ;
		Function Finaliza()
		Local cArqSx3,cArqSx2,lCdxAxs := .F.

		#ifdef CDX
			lCdxAxs := .T.
		#endif

		DbSelectArea("SX2")	// Fecha Arquivo Em Modo Exclusivo
		dbCloseArea()
		// Abre Arquivo em Modo Compartilhado

		cArqSx2:="SX2"+SM0->M0_CODIGO+"0"

		dbUseArea( .T.,__LocalDriver,cArqSx2, "SX2", .T., .F. )
		MsOpenIdx( cArqSx2 + '1', 'X2_CHAVE', .T., .T., , cArqSx2 )

		DbSetOrder(1)

		DbSelectArea("SX3")
		DbClosearea()

		cArqSx3:="SX3"+SM0->M0_CODIGO+"0"

		DbUseArea( .T. , __LocalDriver, cArqSx3, "SX3", .T. , .F. )

		MsOpenIdx( cArqSx3+'1' , 'X3_ARQUIVO+X3_ORDEM', .T., .T., , cArqSx3 )
		MsOpenIdx( cArqSx3+'2' , 'X3_CAMPO', .T., .T., , cArqSx3 )
		MsOpenIdx( cArqSx3+'3' , 'X3_GRPSXG+X3_ARQUIVO+X3_ORDEM', .T., .T., , cArqSx3 )
		MsOpenIdx( cArqSx3+'4' , 'X3_FOLDER+X3_ORDEM', .T., .T., , cArqSx3 )

		DbSetOrder(1)
		Return

		// ------------------------------------------------------

		Static ;
		Function AltStruct(nPos,lModStr)

		If AltOrd .or. AltBrw .or. AltUso
			A1Choice(nPos)
		EndIf

		If AltStr //.or. lModStr
			SX2->(DbSeek(cArq))
			MsgMeter( { | oMeter, oText, oDlg, lEnd | ;
				ModStr( oMeter, oText, oDlg, @lEnd ,AllTrim(SX2->X2_ARQUIVO)) },;
				OemToAnsi(STR0093),"")   // "Alterando a Estrutura do Sistema"
		EndIf

		// ------------------------------------------------------

		Static ;
		Function PoeDefault(X3CAMPO,cTipo,X3TITULO,X3DESCRIC,X3NIVEL,nVisual,nCOntext,lObrigat,X3TAMANHO,X3PROPRI,lWhen,oObj1,oObj2,oObj3)
		Local cCpos := "_USERLGI/_USERGI/_USERGA/_USERLGA/_BITMAP/_MSEXP/_MSIMP/_MSIDENT/_MSIDEN"
		lWhen :=.t.

		If ( ! AllTrim(Subs(X3CAMPO,3)) $  cCpos ) .And. ( ! AllTrim(Subs(X3CAMPO, 4)) $  cCpos ) .And. ( ! "_BITMAP" $ Subs(X3CAMPO,3) )
			Return .t.
		EndIf

		cTipo := "C"
		X3NIVEL := 9
		nVisual := 2
		nContext := 1
		lObrigat := .f.
		lWhen := .f.

		// Last Change by Fernando Ramalho - 8/27/1998
		If ( Subs(X3CAMPO, 3) == "_USERLGI" ) .Or. ( Subs(X3CAMPO, 4) == "_USERGI" )
			X3TITULO  := OemToAnsi(STR0059) // "Log de Inclusao"
			X3DESCRIC := OemToAnsi(STR0059) // "Log de Inclusao"
			X3PROPRI := "L"
			X3TAMANHO := 17
			X3NIVEL := 9
		ElseIf ( Subs(X3CAMPO, 3) == "_USERLGA" ) .Or. ( Subs(X3CAMPO, 4) == "_USERGA" )
			X3TITULO  := OemToAnsi(STR0060) // "Log de Alteracao"
			X3DESCRIC := OemToAnsi(STR0060) // "Log de Alteracao"
			X3PROPRI := "L"
			X3TAMANHO := 17
			X3NIVEL := 9
		ElseIf  "_BITMAP" $ Substr(X3CAMPO,3)
			X3NIVEL := 1
			X3TAMANHO := 8
			X3PROPRI := "B"
			nVisual := 1
			Context := 1
			Obrigat := .f.
		ElseIf "_MSEXP"   $ Substr(X3CAMPO,3)
			X3TITULO  := OemToAnsi(STR0061) // "Ident.Exp."
			X3DESCRIC := OemToAnsi(STR0062) // "Ident.Exp.Dados"
			X3DESCRIC := X3DESCRIC + Space(25 -Len(X3DESCRIC))
			X3PROPRI  := "L"
			X3VISUAL  := "V"
			X3TAMANHO := 8
			X3NIVEL   := 9
			X3CONTEXT := " "
		ElseIf "_MSIMP"   $ Substr(X3CAMPO,3)
			X3TITULO  := OemToAnsi(STR0063) // "Ident.Import"
			X3DESCRIC := OemToAnsi(STR0064) // "Ident.Imp.Dados"
			X3DESCRIC := X3DESCRIC + Space(25 -Len(X3DESCRIC))
			X3PROPRI  := "L"
			X3VISUAL:= "V"
			X3TAMANHO := 8
			X3NIVEL := 9
			X3CONTEXT := " "
		ElseIf ( "_MSIDENT" $ Subs(X3CAMPO, 3) ) .Or. ( "_MSIDEN" $ Subs(X3CAMPO, 4) )
			X3TITULO  := OemToAnsi(STR0065) // "Ident.Reg.   "
			X3DESCRIC := OemToAnsi(STR0066) // "Ident. Registros"
			X3DESCRIC := X3DESCRIC + Space(25 -Len(X3DESCRIC))
			X3PROPRI  := "L"
			X3VISUAL:= "V"
			X3TAMANHO := 8
			X3NIVEL := 9
			X3CONTEXT := " "
		EndIf

		oObj1:Refresh()
		oObj2:Refresh()
		oObj3:Refresh()
		Return .t.

		// ------------------------------------------------------

		Static ;
		Function VerUso(cUsado)
		Local i
		cUsado := FirstBitOff(Bin2Str(cUSado))

		For i := 1 To Len(aModulos)

			If ( aModulos [i][4] == 0 )		// Usado por todos
				aModulos[i,1] := Iif( Subs(cUsado, 100, 1)== "x",.T.,.F.)
			Else
				aModulos[i,1] := Iif( Subs(cUsado, aModulos [i][4], 1 )== "x",.T.,.F.)
			EndIf
		Next

		Return Nil

		Static ;
		Function VerSXG(cGRPSXG)
		Local cSvAlias := Alias()
		Local lRet := .F.

		DEFAULT cGRPSXG := ""

		If ( !Empty(cGRPSXG) )
			DbSelectArea("SXG")
			DbSetOrder(1)
			lRet := DbSeek(cGRPSXG)
		EndIf

		DbSelectArea(cSvAlias)
		Return lRet

		// ------------------------------------------------------

		Static ;
		Function MontaUso(aModulos)
		Local i,cUsado := Space(102)

		For i := 1 To Len(aModulos)

			If ( aModulos [i][4] == 0 )		// Usado por todos
				cUsado := Stuff( cUsado, 100, 1, Iif(aModulos[i,1],"x"," "))
			Else
				cUsado := Stuff( cUsado, aModulos [i][4], 1, Iif(aModulos[i,1],"x"," "))
			EndIf
		Next

		cUsado := Str2Bin(FirstBitOn(cUsado))

		Return cUsado

		// ------------------------------------------------------

		Static ;
		Function ValOrdem(oCpo,cOrdem,nPos)
		Local lOk:= .F.,nNew, i, j
		If cOrdem == aCampos[oCpo:nAt,3]
			lOk := .T.
		EndIf
		If VAL(RetAsc(cOrdem,2,.f.)) > 0 .and. VAL(RetAsc(cOrdem,2,.f.)) <= Len(aCampos)
			lOk := .t.
			nNew := Val(RetAsc(cOrdem,2,.f.))
			aCampos := aClone(Sort(aCampos[oCpo:nAt,3],cOrdem))
			oCpo:Skip(nNew-Val(retasc(aCampos[oCpo:nAt,3],2,.f.)))
			oCpo:Refresh()
			SetFocus(oCpo:hWnd)
			nPos := oCpo:nAt
			M->X3_ORDEM := aCampos[oCpo:nAt,3]
			cOrdem := aCampos[oCpo:nAt,3]
			cOrd := RetAsc(Str(oCpo:nAt),2,.T.)
			dbSelectArea("SX3")
			nSavRec := RecNo()
			dbSetOrder(2)
			dbSeek(aCampos[oCpo:nAt,4])
			cPode := "xxxxxx x"
			If Found()
				cPode := X3Reserv(aCampos[oCpo:nAt,7])
			EndIf
			dbSetOrder(1)
			dbGoTo(nSavRec)

			dbSelectArea("SX3")
			nOldOrdSx3 := IndexOrd()

			For i := 1 to Len(aSx3)
				cSx3Alias := SeleSx3(aSx3[i,1],aSx3[i,2])
				DbSetOrder(2)
				For j := 1 to Len(aCampos)
					If (DbSeek (aCampos[j,4]))
						RecLock(cSx3Alias,.F.)
						REPLACE x3_ordem WITH RetAsc(aCampos[j,3],2,.T.)
						MsUnlock()
					EndIf
				Next j
			Next i

			DbSelectArea("SX3")
			DbSetOrder(nOldOrdSx3)
		EndIf

		Return lOk

		// ------------------------------------------------------

		Static ;
		Function MemoExt()
		Local cExt
		#ifdef CDX
			cExt := ".FPT"
		#else
			cExt := ".CDX"
		#endif
		Return cExt

		/*/
		ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
		±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
		±±ÚÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
		±±³Fun‡…o  ³OpenSx2Exc³ Descr ³ Abre Sx2 Exclusivo 	³ Data ³28.11.95	³±±
		±±ÀÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÙ±±
		±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
		ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
		/*/
	Function OpenSx2Excl(cArqSx2,cIndSx2,cSX2Alias)

		DEFAULT cSX2Alias := "SX2"

		*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		*³ Aguarda Liberacao de Arquivos por outras estacoes para abrir SX2 Exclusivo  ³
		*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		DbSelectArea("SX2")
		dBCloseArea()
		cIndSx2 += "1"
		MsOpEndbf(.t. ,__LocalDriver,cArqSX2,cSX2Alias,.f.,.f.)
		While !Used()
			If !NaoExcl()
				MsOpEndbf(.t. ,__LocalDriver,cArqSX2,cSX2Alias,.t.,.f.)
				MsOpenIdx( cIndSx2,"X2_CHAVE",.f.,,,cArqSX2 )
				Return .F.
			EndIf
			MsOpEndbf(.t. ,__LocalDriver,cArqSX2,cSX2Alias,.f.,.f.)
		End
		MsOpenIdx( cIndSx2,"X2_CHAVE",.f.,,,cArqSX2 )
		Return .T.

		// ------------------------------------------------------

	Function NaoExcl()
		Local lRet := .F.,oDlg,oBtn

		DEFINE MSDIALOG oDlg FROM	96,72 TO 341,540 TITLE OemToAnsi(STR0105) PIXEL  OF oMainWnd  // "Atualiza‡„o de Vers„o"

		@ 8, 20 TO 102, 212 OF oDlg  PIXEL
		@ 24, 34 SAY OemToAnsi(STR0100) SIZE 166, 7 OF oDlg PIXEL  // "Para  Atualizar a  Base de Dados , o Sistema n„o poder  estar em "
		@ 38, 34 SAY OemToAnsi(STR0101) SIZE 166, 7 OF oDlg PIXEL  // "uso por outras esta‡”es. Neste momento est  sEndo aguardada a "
		@ 52, 34 SAY OemToAnsi(STR0102) SIZE 166, 7 OF oDlg PIXEL  // "libera‡„o dos arquivos.  Tecle o bot„o  <Confirma>  quando todas "
		@ 66, 34 SAY OemToAnsi(STR0103) SIZE 166, 7 OF oDlg PIXEL  // "as  esta‡„es  j   estiverem  fora  do sistema para prosseguir com a"
		@ 78, 34 SAY OemToAnsi(STR0104)	SIZE 165, 7 OF oDlg PIXEL // "atualiza‡„o.                                                  "

		DEFINE SBUTTON oBtn FROM 107,158 TYPE 1 ACTION (lRet := .T.,oDlg:End()) ENABLE OF oDlg
		DEFINE SBUTTON oBtn FROM 107,186 TYPE 2 ACTION (lRet := .F.,oDlg:End()) ENABLE OF oDlg

		ACTIVATE MSDIALOG oDlg
		Return lRet

		***************************************
	FUNCTION x031Str(cCampo,cCposDef)

		Local nPos := 1

		While nPos != 0
			If cCampo == SubStr(cCposDef,2,Len(cCampo))
				Return(.t.)
			EndIf
			nPos     := At( "/",cCposDef )
			cCposDef := SubStr(cCposDef,nPos+1,Len(cCposDef))
		End

		Return(.f.)
