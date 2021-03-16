/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ CFGx047  ³ Autor ³ Gilson Nascimento     ³ Data ³ 26.02.97 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Consulta Arquivos de LOG                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ CFGx047(void)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Sem Argumentos                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Configurador   ³ Fun‡„o Relacionada ³ Pesquisa/Consulta    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#include "FiveWin.ch"
//#include "Directry.ch"
#include "TCBrowse.ch"
#include "Cfgx047.ch"


Function Cfgx047()
	If ( FindFunction('APCFG100') )
		ApCfg100()
	Else
		_Cfgx047()
	EndIf
	Return


Function _Cfgx047()
	LOCAL oDlg,oCbx,oOrdem,oChk,oLbx,oBrowse
	Local oOk := LoadBitmap( GetResources(), "LBTIK" )
	Local oNo := LoadBitmap( GetResources(), "LBNO" )
	LOCAL nOpc,nRadio:=1, oBt1
	LOCAL cCombo1,cCombo2,cCombo3,cCombo4,cSX2,lChk1:=.T.,lChk2:=.T.,lChk3:=.T.,lChk4:=.T.,lChk5:=.T., lChk6 := .t.,lChk7 := .t.
	LOCAL cNomArq:="",cNomInd1:="",cNomInd2:="",cNomInd3:="",cAliasOld:=Alias(), cResumo
	LOCAL oResumo, oFont

	PRIVATE aArq:={},aUsu:={oemtoansi(STR0001)},aEmp:={oemtoansi(STR0002)},aMod:={oemtoansi(STR0001)}  //  "Todos" ### "Todas"  ### "Todos"
	PRIVATE aEmpresas:={},aModulos:={},aSX2Alias:={}
	PRIVATE nTotal:=0
	PRIVATE xFiltro1:="",xFiltro2:=""

	If x047Diretorio()
		Help(" ",1,"047NOLOG")
		DeleteObject(oOk)
		DeleteObject(oNo)
		Return
	Endif
	x047Usuario()
	x047Empresa()
	x047Modulo()
	x047Arquivo()
	x047TRB(cNomArq)

	ASORT(aArq,,,{|a1,a2|Subs(a1,7,2)+Subs(a1,4,2)+Subs(a1,1,2) < Subs(a2,7,2)+Subs(a2,4,2)+Subs(a2,1,2)})

	DEFINE FONT oFont NAME "Courier New" SIZE 5,0

	While .T.
		nOpc := 0

		DEFINE MSDIALOG oDlg FROM 36,1 TO 440,600 TITLE OemToAnsi(STR0003) PIXEL  // "Consulta LOG"

		@ 7, 3   SAY oemtoansi(STR0004)     SIZE 50, 7 OF oDlg PIXEL // "Data Arquivo Log:"
		@ 7, 52  SAY oemtoansi(STR0005)     SIZE 27, 7 OF oDlg PIXEL  // "Usuário:"
		@ 7, 105 SAY oemtoansi(STR0006)     SIZE 49, 7 OF oDlg PIXEL  // "Empresa/Filial:"
		@ 7, 190 SAY oemtoansi(STR0007)+":" SIZE 30, 7 OF oDlg PIXEL  // "Módulo"

		@ 16, 3   COMBOBOX oCbx VAR cCombo1 ITEMS aArq SIZE 45, 58 OF oDlg PIXEL
		cCombo1 := DTOC(dDatabase)
		oCbx:Refresh(.F.)

		@ 16, 52  COMBOBOX oCbx VAR cCombo2 ITEMS aUsu SIZE 50, 58 OF oDlg PIXEL
		@ 16, 105 COMBOBOX oCbx VAR cCombo3 ITEMS aEmp SIZE 80, 58 OF oDlg PIXEL
		@ 16, 190 COMBOBOX oCbx VAR cCombo4 ITEMS aMod SIZE 60, 58 OF oDlg PIXEL

		@ 32.5,75 LISTBOX oLbx FIELDS HEADER "","",oemtoansi(STR0008) SIZE 130, 61 ON DBLCLICK (aSX2Alias[oLbx:nAt,1] := !aSX2Alias[oLbx:nAt,1],oLbx:Refresh(.f.)) OF oDlg PIXEL  // "Arquivos"
		oLbx:Disable()
		oLbx:SetArray(aSX2Alias)
		oLbx:bLine := { || {if(aSX2Alias[oLbx:nAt,1],oOk,oNo),aSX2Alias[oLbx:nAt,2],aSX2Alias[oLbx:nAt,3] }}
		oLbx:bRClicked := { || AEVAL(aSX2Alias,{|x|x[1]:=!x[1]}),oLbx:Refresh(.F.) }

		@ 30, 3 TO 90, 70 LABEL oemtoansi(STR0010) OF oDlg  PIXEL  // "Tipo de Transação"
		@ 36, 7 CHECKBOX oChk VAR lChk1 PROMPT oemtoansi(STR0011) SIZE 62, 10 OF oDlg PIXEL;oChk:oFont := oDlg:oFont  // "Acesso a Funções"
		@ 43, 7 CHECKBOX oChk VAR lChk2 PROMPT oemtoansi(STR0012) SIZE 53, 10       ON CHANGE (If(lChk2,oLbx:Enable(),oLbx:Disable())) OF oDlg PIXEL;oChk:oFont := oDlg:oFont  // "Inclusões"
		@ 50, 7 CHECKBOX oChk VAR lChk3 PROMPT oemtoansi(STR0013) SIZE 53, 10       ON CHANGE (If(lChk3,oLbx:Enable(),oLbx:Disable())) OF oDlg PIXEL;oChk:oFont := oDlg:oFont  // "Alterações"
		@ 57, 7 CHECKBOX oChk VAR lChk4 PROMPT oemtoansi(STR0014) SIZE 53, 10       OF oDlg PIXEL;oChk:oFont := oDlg:oFont  // "Relatórios"
		@ 64, 7 CHECKBOX oChk VAR lChk5 PROMPT oemtoansi(STR0015) SIZE 53, 10       OF oDlg PIXEL;oChk:oFont := oDlg:oFont  // "Transações"
		@ 71, 7 CHECKBOX oChk VAR lChk6 PROMPT oemtoansi(STR0032) SIZE 53, 10       OF oDlg PIXEL;oChk:oFont := oDlg:oFont
		@ 78, 7 CHECKBOX oChk VAR lChk7 PROMPT oemtoansi(STR0033) SIZE 53, 10       OF oDlg PIXEL;oChk:oFont := oDlg:oFont


		@ 30,210 TO 90,255 LABEL oemtoansi(STR0016) OF oDlg  PIXEL // "Ordem"
		@ 39,211 RADIO oOrdem VAR nRadio ITEMS oemtoansi(STR0017),oemtoansi(STR0018),"&"+oemtoansi(STR0007) 3D SIZE 35,14  OF oDlg PIXEL   // "&Empresa"  ### "&Usuário" ### "Módulo"

		@ 93, 3 TO 200, 295 LABEL "" OF oDlg PIXEL
		oBrowse:=x047ShowBrowse(oDlg)
		oBrowse:bLostFocus:={||x047AtivaBtn(@oBt1),oBt1:SetEnable()}
		oBrowse:bChange := {|| cResumo := TRB->RESUMO, oResumo:Refresh() }
		oOrdem:bChange := {|| dbSetOrder(nRadio),oBrowse:Refresh(), oBrowse:bLostFocus:={||x047AtivaBtn(@oBt1),oBt1:SetEnable()} }

		@ 160,005 SAY oemtoansi(STR0020) PIXEL
		@ 168,005 GET oResumo VAR cResumo OF oDlg SIZE 288,027 FONT oFont PIXEL READONLY MEMO

		DEFINE SBUTTON oBt1 FROM 09, 260 TYPE 15 ENABLE OF oDlg Action (nOpc:=1,Processa({||x047Browse(x047GeraFiltro(cCombo1,cCombo2,cCombo3,cCombo4,lChk1,lChk2,lChk3,lChk4,lChk5,nRadio,lChk6,lChk7),@oBrowse,@cResumo,@oResumo)}),oBt1:lAutDisable:=.F.,SetFocus(oBrowse:hWnd))
		DEFINE SBUTTON FROM 27, 260 TYPE 2  ENABLE OF oDlg Action (nOpc:=0,oDlg:End())
		DEFINE SBUTTON FROM 45, 260 TYPE 6  ENABLE OF oDlg Action (x047Relatorio(oDlg,cCombo1))

		ACTIVATE MSDIALOG oDlg Centered

		IF nOpc # 1
			Exit
		Endif

	EndDO
	dbSelectArea("TRB")
	dbCloseArea()
	FERASE(cNomArq+GetDBExtension())
	FERASE(cNomInd1+".NTX")
	FERASE(cNomInd2+".NTX")
	FERASE(cNomInd3+".NTX")
	dbSelectArea(cAliasOld)
	DeleteObject(oOk)
	DeleteObject(oNo)
	Return


	/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Fun‡…o    ³x047AtivaB³ Autor ³ Gilson Nascimento     ³ Data ³ 26.02.97 ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡…o ³Ativa o Botao de Pesquisa                                   ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Sintaxe   ³                                                            ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Parametros³ Sem Argumentos                                             ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³ Uso      ³ CFGX047                                                    ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	*/
Static Function x047AtivaBtn(oBtn)
	oBtn:lAutDisable:=.T.
	oBtn:Refresh()
	Return

	/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Fun‡…o    ³x047ShowBr³ Autor ³ Gilson Nascimento     ³ Data ³ 26.02.97 ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡…o ³Mostra o Browse da Consulta                                 ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Sintaxe   ³                                                            ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Parametros³ Sem Argumentos                                             ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³ Uso      ³ CFGX047                                                    ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	*/
Static Function x047ShowBrowse(oDlg)
	LOCAL oCol,ni
	LOCAL oBrw,aBrowse:={{oemtoansi(STR0020),"RESUMO"},;  // "Resumo" ### "RESUMO"
	{oemtoansi(STR0021),"TIPO"},;  // "Tipo" ### "TIPO"
	{oemtoansi(STR0022),"EMPRESA"},;  // "Empresa" ### "EMPRESA"
	{oemtoansi(STR0023),"FILIAL"},; // "Filial" ### "FILIAL"
	{OemToAnsi(STR0007),"MODULO" },; //  "MÓdulo" ###  "MODULO"
	{OemToAnsi(STR0005),"USUARIO"},; // "UsuÁrio" ### "USUARIO"
	{oemtoansi(STR0024),"PROGRAMA"},; // "Programa" ### "PROGRAMA"
	{oemtoansi(STR0025),"HORA"},;  // "Hora" ### "HORA"
	{oemtoansi(STR0026),"ARQUIVO"},; // "Tabela" ### "ARQUIVO"
	{oemtoansi(STR0027),"REGISTRO"},;  // "Registro"  ### "REGISTRO"
	{oemtoansi(STR0028),"IDENT"},;  // "Identificador"  ### "IDENT"
	{oemtoansi(STR0030),"PORTA"} }  // "Porta"### "PORTA"
	@ 098,005 COLUMN BROWSE oBrw SIZE 289,060 PIXEL OF oDlg
	For ni := 2 to Len(aBrowse)
		IF TYPE("TRB->"+aBrowse[ni][2]) == "C"
			DEFINE COLUMN oCol DATA FieldWBlock(aBrowse[ni][2],Select("TRB")) HEADER OemToAnsi(aBrowse[ni][1])
		ElseIF TYPE("TRB->"+aBrowse[ni][2]) == "N"
			DEFINE COLUMN oCol DATA FieldWBlock(aBrowse[ni][2],Select("TRB")) HEADER OemToAnsi(aBrowse[ni][1])  RIGHT
		Endif
		oBrw:ADDCOLUMN(oCol)
	Next ni
	SetFocus(oBrw:hWnd)
	oBrw:Refresh()
	Return(oBrw)

