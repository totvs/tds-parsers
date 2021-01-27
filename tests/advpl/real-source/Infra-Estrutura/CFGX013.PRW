#include "protheus.ch"
#include "cfgx013.ch"

Static aRetMod, aTables, aDirMnu
Static nTitle
Static __lR7 := GetRpoRelease("R7")
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ CFGx013  ³ Autor ³ Tecnologia            ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Configurador de Menus                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ CFGx013()                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Sem Argumentos                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Configurador   ³ Funcao Relacionada ³ Entrada Dados (Todos)³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Function Cfgx013()
	Local i
	Local oDlg13
	Local oAll
	Local cMenu
	Local oListMnu
	Local lAll := .T.
	Local aListMnu := {}
	Local oOk := LoadBitmap(GetResources(), "LBOK")
	Local oNo := LoadBitmap(GetResources(), "LBNO")
	Local aModDefault := {}
	Local bLine := {|| {If(aListMnu[oListMnu:nAt,1],oOk,oNo), aListMnu[oListMnu:nAt,2], aListMnu[oListMnu:nAt,5]}}
	Local cCurDir
	Local lFlatMode := If(FindFunction("FLATMODE"),FlatMode(),SetMDIChild())
	Local oPanel
	Local nWndTop
	Local nWndLeft
	Local nAdjust

	If nTitle == Nil
		If __Language == "ENGLISH"
			nTitle := 3
		ElseIf __Language == "SPANISH"
			nTitle := 2
		Else
			nTitle := 1
		EndIf
	EndIf

	aRetMod := RetModName()
	cCurDir := CurDir()
	If Subs(cCurDir,Len(cCurDir)) == "\"
		aDirMnu := {"\"+CurDir()}
	Else
		aDirMnu := {"\"+CurDir()+"\"}
	EndIf

	Aadd(aRetMod,{99,"SIGACFG",STR0001}) //"Configurador"

	For i := 1 To Len(aRetMod)
		cMenu := Upper(AllTrim(aRetMod[i][2])+RetExtMnu())
		If ( ! __lPyme ) .And. ( File(cMenu) )
			Aadd(aModDefault,{(aRetMod[i][1] <> 99),aRetMod[i][3],cMenu,aRetMod[i][1],aDirMnu[1]})
		ElseIf ( __lPyme ) .And. ( ModIsPyme(Subs( cMenu, 5, 3 ) ) ) .And. ( File(cMenu) )
			Aadd(aModDefault,{(aRetMod[i][1] <> 99),aRetMod[i][3],cMenu,aRetMod[i][1],aDirMnu[1]})
		EndIf
	Next

	aModDefault := Asort(aModDefault,,,{|x,y| x[2]<y[2]})

	aListMnu := ReadDirMnu(aModDefault)

	If ( aTables == NIL )
		Processa({|lEnd| aTables := ReadSx2()}, AnsiToOem(STR0007), "", .F.) //"Lendo cadastro de tabelas ..."
	EndIf

	oMainWnd:ReadClientCoors()

	If lFlatMode
		nWndTop := 0
		nWndLeft := 0
		nAdjust := 30
	Else
		nWndTop := oMainWnd:nTop+125
		nWndLeft := oMainWnd:nLeft+5
		nAdjust := 60
	EndIf

	DEFINE MSDIALOG oDlg13 TITLE STR0004 FROM nWndTop,nWndLeft TO oMainWnd:nBottom-nAdjust,oMainWnd:nRight-10 OF oMainWnd PIXEL //"Selecione os menus"
	oDlg13:lMaximized := .T.

	@00,00 MSPANEL oPanel SIZE 05,05
	oPanel:Align := CONTROL_ALIGN_TOP

	@00,00 MSPANEL oPanel SIZE 05,05
	oPanel:Align := CONTROL_ALIGN_LEFT

	@05,05 LISTBOX oListMnu FIELDS HEADER "",STR0005,STR0002 FIELDSIZES 14, 100,50 SIZE 200, 300 PIXEL OF oDlg13 //"Módulos" # "Diretório"

	oListMnu:Align := CONTROL_ALIGN_ALLCLIENT
	oListMnu:SetArray(aListMnu)
	oListMnu:bLine := bLine
	oListMnu:bLDblClick := {|nRowPix, nColPix, nKeyFlags| ValSelection(@aListMnu,oListMnu),oListMnu:Refresh(),;
		If(lAll,(lAll := .F., oAll:Refresh()),)}

		@00,00 MSPANEL oPanel SIZE 15,10
		oPanel:Align := CONTROL_ALIGN_BOTTOM

		@01,05 CHECKBOX oAll VAR lAll PROMPT STR0006 FONT oDlg13:oFont PIXEL SIZE 80, 09 OF oPanel ; //"&Todos os menus"
		ON CLICK (Aeval(aListMnu,{|x,y| aListMnu[y][1] := If(aListMnu[y][4] == 99,.F.,lAll)}), oListMnu:Refresh())

		@00,00 MSPANEL oPanel SIZE 40,40
		oPanel:Align := CONTROL_ALIGN_RIGHT

		DEFINE SBUTTON oBtn1 FROM 00,05 TYPE 1 ENABLE OF oPanel;
			ACTION (oDlg13:Hide(), aListMnu := ResetList(aListMnu,ManageMenu(aListMnu)),;
			oListMnu:SetArray(aListMnu),oListMnu:bLine := bLine,oDlg13:Show())

		DEFINE SBUTTON oBtn2 FROM 15,05 TYPE 2 ENABLE OF oPanel ACTION oDlg13:End()

		DEFINE SBUTTON oBtn3 FROM 30,05 TYPE 4 ENABLE OF oPanel ONSTOP STR0060; //"Configurar diretórios de menu"
		ACTION If(GetDirMnu(),(aListMnu := ReadDirMnu(aModDefault),oListMnu:nAt := 1,oListMnu:SetArray(aListMnu),oListMnu:bLine := bLine,oListMnu:Refresh(),lAll := .T.,oAll:Refresh()),)

		DEFINE SBUTTON oBtn4 FROM 45,05 TYPE 15 ENABLE OF oPanel ACTION FindMenu(@oListMnu,aListMnu) ONSTOP STR0072	//"Pesquisar"

		If lFlatMode
			oBtn3:cCaption := STR0091	//"Configurar"
			oBtn4:cCaption := STR0072	//"Pesquisar"
		EndIf

		ACTIVATE DIALOG oDlg13 ON INIT (oListMnu:Refresh())

		Return NIL

		Static ;
		Function ValSelection(aListMnu,oListMnu)
		Local i
		Local nAt := oListMnu:nAt

		aListMnu[nAt,1] := !aListMnu[nAt,1]

		If (aListMnu[nAt,4] == 99)
			If aListMnu[nAt,1]
				For i := 1 To Len(aListMnu)
					If i <> nAt
						aListMnu[i,1] := .F.
					EndIf
				Next
			EndIf
		Else
			If (i := Ascan(aListMnu,{|x| x[4] == 99})) <> 0
				aListMnu[i,1] := .F.
			EndIf
		EndIf
		Return

		Static ;
		Function ManageMenu(aListMnu)
		Local i
		Local oDlg
		Local oPrg1
		Local oMod1
		Local oPrg2
		Local oMod2
		Local oTree1
		Local oTree2
		Local nTree := 1
		Local cCargo1 := ""
		Local cCargo2 := ""
		Local aBtn := Array(10)
		Local lFlatMode := If(FindFunction("FLATMODE"),FlatMode(),SetMDIChild())
		Local nWndTop
		Local nWndLeft
		Local nAdjust
		Local nWidth
		Local nHeight
		Local oLPanel
		Local oRPanel
		Local oRPanel1
		Local oRPanel2
		Local oRPanel3
		Local oCPanel
		Local oLPanel1
		Local oLPanel2
		Local oLPanel3

		// Bruno
		Local aGroup := {}
		Local aInfo  := {}
		Local cDir	 := ""
		Local cMenu	 := ""
		Local nBtnCol:= 0
		Local nPnlWdt:= 0
		Local oFWMenuManager := FWMenuManager():New()

		Private lCfg := aListMnu[Ascan(aListMnu,{|x| x[4] == 99})][1]
		Private aMenus := {} //contem itens dos menus escolhidos
		Private aNewMnu := {} //contem itens do menu a gerar
		Private lAbortPrint := .F.
		Private aMainTitles := Array(4)
		Private aCreated := {}

		aMainTitle[1] := Padr(If(lCfg,STR0011,STR0012),18) //"Ambiente" # "Atualizações"
		aMainTitle[2] := Padr(If(lCfg,STR0013,STR0014),18) //"Usuário" # "Consultas"
		aMainTitle[3] := Padr(If(lCfg,STR0015,STR0016),18) //"Base de Dados" # "Relatórios"
		aMainTitle[4] := Padr(If(lCfg,STR0017,STR0018),18) //"Empresas" #"Miscelanea"

		oMainWnd:ReadClientCoors()

		If lFlatMode
			nWndTop := 0
			nWndLeft := 0
			nAdjust := 30
		Else
			nWndTop := oMainWnd:nTop+125
			nWndLeft := oMainWnd:nLeft+5
			nAdjust := 60
		EndIf

		DEFINE MSDIALOG oDlg FROM nWndTop,nWndLeft TO oMainWnd:nBottom-nAdjust,oMainWnd:nRight-10 TITLE STR0009 PIXEL //"Configuração de Menus"
		oDlg:lMaximized := .T.
		//oDlg:ReadClientCoors()
		nWidth := oDlg:nWidth/2
		nHeight := oDlg:nHeight/2

		nPnlWdt	:= nWidth/2-30

		//------------------------------------
		// ## Painel dos Menus Selecionados ##
		//------------------------------------
		@00,00 MSPANEL oLPanel SIZE nPnlWdt,00 OF oDlg
		oLPanel:Align := CONTROL_ALIGN_LEFT

		@03,05 SAY STR0010 OF oLPanel PIXEL //"Opções:"

		oTree1 := XTree():New(012,005,nHeight-35,nPnlWdt-5,oLPanel,;
			{||(cCargo1 := oTree1:GetCargo(),oPrg1:SetText(GetPrgName(oFWMenuManager, 1)),oMod1:SetText(GetModulo(oFWMenuManager, 1)))},)
		oTree1:bLClicked := {|| nTree := 1 } //alteração temporária

		@oTree1:nHeight/2+13,05 SAY STR0019 OF oLPanel PIXEL //"Programa:"
		@oTree1:nHeight/2+13,33 SAY oPrg1 VAR Space(10) OF oLPanel PIXEL

		@oTree1:nHeight/2+23,05 SAY STR0020 OF oLPanel PIXEL //"Módulo:"
		@oTree1:nHeight/2+23,33 SAY oMod1 VAR Space(10) OF oLPanel PIXEL

		//------------------------
		// ## Painel dos Botões ##
		//------------------------
		@00,00 MSPANEL oCPanel SIZE 60,00 OF oDlg
		oCPanel:Align := CONTROL_ALIGN_LEFT

		nBtnCol := (oCPanel:nWidth/2-42)/2

		@11,nBtnCol BUTTON aBtn[1] PROMPT STR0021 SIZE 42,12 Of oCPanel PIXEL; //"&Adicionar >>"
		ACTION (oFWMenuManager:CopyItem()) WHEN nTree == 1

		@24,nBtnCol BUTTON aBtn[2] PROMPT STR0022 SIZE 42,12 Of oCPanel PIXEL; //"<< &Remover"
		ACTION (oFWMenuManager:RemoveItem()) WHEN nTree == 2

		@37,nBtnCol BUTTON aBtn[3] PROMPT STR0023 SIZE 42,12 Of oCPanel PIXEL; //"Novo &Grupo"
		ACTION ( If ( oFWMenuManager:ReceptorCanReceive(), ( If( NewGroup( @aInfo ), oFWMenuManager:NewFolder( aInfo ), ) ), ) );
			WHEN nTree == 2

		@50,nBtnCol BUTTON aBtn[4] PROMPT STR0024 SIZE 42,12 Of oCPanel PIXEL; //"Novo &Item"
		ACTION ( If ( oFWMenuManager:ReceptorCanReceive(), If( NewItem( @aInfo ), oFWMenuManager:NewContent( aInfo ), ), ) ) ;
			WHEN nTree == 2

		@63,nBtnCol BUTTON aBtn[5] PROMPT STR0025 SIZE 42,12 Of oCPanel PIXEL; //"&Detalhes"
		ACTION ( aInfo := {}, If ( oFWMenuManager:Details( nTree, @aInfo ), If ( Detail( nTree, @aInfo ), If( nTree == 2, oFWMenuManager:UpdateReceptor( aInfo ), ), ), ) )

		@076,nBtnCol BUTTON aBtn[6] PROMPT STR0092 SIZE 42,12 Of oCPanel PIXEL; //"Mover p/ cima"
		ACTION (oFWMenuManager:MoveUpReceptor()) WHEN nTree == 2

		@089,nBtnCol BUTTON aBtn[7] PROMPT STR0093 SIZE 42,12 Of oCPanel PIXEL; //"Mover p/ baixo"
		ACTION (oFWMenuManager:MoveDownReceptor()) WHEN nTree == 2

		@102,nBtnCol BUTTON aBtn[8] PROMPT "&"+OemToAnsi(STR0072) SIZE 42,12 Of oCPanel PIXEL ;   //   "Localizar"
		ACTION oFWMenuManager:Search(nTree) WHEN .F.

		@115,nBtnCol BUTTON aBtn[9] PROMPT STR0026 SIZE 42,12 Of oCPanel PIXEL ;// WHEN (!Empty(aNewMnu)); //"G&erar"
		ACTION If( CreateMenu( @cDir, @cMenu, oFWMenuManager ), oFWMenuManager:Publish( cDir, cMenu ), )

		@128,nBtnCol BUTTON aBtn[10] PROMPT STR0027 SIZE 42,12 Of oCPanel PIXEL ;
			ACTION (If ( MsgYesNo( STR0097, STR0003 ), oDlg:End(), )) //"Finalizar Manutenção?" # "Atenção"

		//--------------------------
		// ## Painel do Novo Menu ##
		//--------------------------
		@00,00 MSPANEL oRPanel SIZE nPnlWdt,00 OF oDlg
		oRPanel:Align := CONTROL_ALIGN_LEFT

		@03, 05 SAY STR0028 OF oRPanel PIXEL //"Novo menu:"

		oTree2 := XTree():New(011,005,nHeight-35,nPnlWdt-5,oRPanel,;
			{||(cCargo2 := oTree2:GetCargo(),oPrg2:SetText(GetPrgName(oFWMenuManager, 2)),oMod2:SetText(GetModulo(oFWMenuManager, 2))) },)
		oTree2:bLClicked := {|| nTree := 2} //alteração temporaria

		@oTree2:nHeight/2+13,05 SAY STR0019 OF oRPanel PIXEL //"Programa:"
		@oTree2:nHeight/2+13,33 SAY oPrg2 VAR Space(10) OF oRPanel PIXEL

		@oTree2:nHeight/2+23,05 SAY STR0020 OF oRPanel PIXEL //"Módulo:"
		@oTree2:nHeight/2+23,33 SAY oMod2 VAR Space(10) OF oRPanel PIXEL

		MsgRun( STR0098, , {|| oFWMenuManager:Init( aListMnu, oTree1, oTree2, nTitle, lCfg ) } ) // "Aguarde... Carregando Menus..."

		ACTIVATE MSDIALOG oDlg

		Return aCreated

		Static ;
		Function NewGroup( aInfo )

		Local cGrupo := Space(25)

		Local lReturn := .F.

		Local oDlg
		Local oGrupo := Array(3)

		aInfo := { Space(25),Space(25),Space(25) }

		DEFINE MSDIALOG oDlg TITLE STR0076 FROM 0,0 TO 200,300 PIXEL

		@ 003,003 TO 085,149 PIXEL

		@ 008,007 SAY STR0077 OF oDlg PIXEL

		@ 018,007 GET oGrupo[1] VAR aInfo[1] PIXEL PICTURE "@!" SIZE 139,011

		@ 033,007 SAY STR0078 OF oDlg PIXEL

		@ 043,007 GET oGrupo[2] VAR aInfo[2] PIXEL PICTURE "@!" SIZE 139,011

		@ 058,007 SAY STR0079 OF oDlg PIXEL

		@ 068,007 GET oGrupo[3] VAR aInfo[3] PIXEL PICTURE "@!" SIZE 139,011

		DEFINE SBUTTON FROM 87,090 TYPE 1 ENABLE OF oDlg ACTION ( If( !Empty(aInfo[1]) .AND. !Empty(aInfo[2]) .AND. !Empty(aInfo[3]) , (lReturn := .T., oDlg:End()), MsgAlert(STR0054,STR0003) ))

		DEFINE SBUTTON FROM 87,120 TYPE 2 ENABLE OF oDlg ACTION oDlg:End()

		ACTIVATE DIALOG oDlg CENTERED

		Return lReturn


		Static;
		Function NewItem( aInfo )
		If __lR7
			aInfo := {{Space(25),Space(25),Space(25)},Space(10),"T",Replicate(".",90),Replicate("x",10),"",0,1,"0",{Space(25),Space(25),Space(25)}}

			If Properties(@aInfo,{{.T.,.T.,.T.},.T.,.T.,.T.,.T.,.T.,.T.,{.T.,.T.,.T.}})
				Return .T.
			EndIf
		Else
			aInfo := {{Space(25),Space(25),Space(25)},Space(10),"T",Replicate(".",90),Replicate("x",10),"",0,1,"0"}

			If Properties(@aInfo,{{.T.,.T.,.T.},.T.,.T.,.T.,.T.,.T.,.T.})
				Return .T.
			EndIf

		Endif

		Return .F.

		Static ;
		Function Detail( nTree, aInfo)

		Local aEnable

		// Verifica qual arvore esta selecionada e inicializa aEnable
		If __lR7
			If nTree == 1
				aEnable := {{.F.,.F.,.F.},.F.,.F.,.F.,.F.,.F.,.F.,{.F.,.F.,.F.}}
			ElseIf nTree == 2
				aEnable := {{.T.,.T.,.T.},.T.,.T.,.T.,.T.,.T.,.T.,{.T.,.T.,.T.}}
			EndIf
		Else
			If nTree == 1
				aEnable := {{.F.,.F.,.F.},.F.,.F.,.F.,.F.,.F.,.F.}
			ElseIf nTree == 2
				aEnable := {{.T.,.T.,.T.},.T.,.T.,.T.,.T.,.T.,.T.}
			EndIf
		Endif

		If Len( aInfo ) == 2
			If GrpProperties(@aInfo,aEnable)
				Return .T.
			EndIf
		Else
			If Properties(@aInfo,aEnable)
				Return .T.
			EndIf
		EndIf

		Return .F.

		Static ;
		Function CreateMenu( cDir, cMenu, oFWMenuManager )

		Local oDlg
		Local aListDir := Aclone(aDirMnu)
		Local nListDir := 1
		Local lContinua := .T.
		Local lReturn	:= .F.
		Local nModError := Ascan(aNewMnu,{|x| Empty(x[6]) .and. !x[7]})

		cMenu := Space(50)

		DEFINE MSDIALOG oDlg FROM 00,00 TO 175,273 TITLE STR0039 PIXEL //"Gerar Menu"

		@01,05 SAY STR0040 PIXEL //"Arquivo (sem extensão):"
		@10,05 GET cMenu PIXEL SIZE 88,10 PICTURE "@!"

		@25,05 SAY STR0067 PIXEL //"Diretório:"
		@34,05 LISTBOX nListDir ITEMS aListDir PIXEL SIZE 88,50

		@10,95 BUTTON STR0026 SIZE 40,11 PIXEL; //"G&erar"
		ACTION If(ValCreate(aListDir[nListDir],cMenu,oFWMenuManager), ( cDir := aListDir[nListDir], lReturn := .T., oDlg:End() ), ) //"Gerando arquivo de menu"

		@23,95 BUTTON STR0027 SIZE 40,11 PIXEL ACTION oDlg:End() //"&Fechar"

		ACTIVATE MSDIALOG oDlg CENTERED

		Return lReturn

		Static ;
		Function ValCreate(cDir,cMenu,oFWMenuManager)
		Local cArquivo := ""
		Local lReturn := .F.
		Local lContinua := .T.

		If ExistBlock("CFG013CM")
			lContinua := ExecBlock("CFG013CM", .F., .F.,{cDir+cMenu,oFWMenuManager:getNewMnu()})
		EndIf

		If lContinua

			If !MsgYesNo( STR0099, STR0003 ) // "Confirma geração do Menu?" # "Atenção"
				Return .F.
			EndIf

			If ( "."$cMenu )
				MsgStop(STR0065,STR0003) //"Digite o nome do arquivo sem extensão." # "Atenção"
			ElseIf ( "\"$cMenu )
				MsgStop(STR0066,STR0003) //"Digite o nome do arquivo sem diretório." # "Atenção"
			Else
				cArquivo := AllTrim(cDir)+AllTrim(cMenu)+RetExtMnu()
				If File(cArquivo)
					lReturn := MsgYesNo(STR0042+cArquivo+STR0043,STR0003) //"O arquivo " # " já existe. Deseja substituí-lo?" # "Atenção"
				Else
					lReturn := .T.
				EndIf
			EndIf

		EndIf

		Return lReturn

		Static ;
		Function Properties(aInfo,aEnable)
		Local i
		Local j
		Local oDlg
		Local oGetFile
		Local aObj
		Local aProperties
		Local nPos
		Local cTemp
		Local cAlias
		Local nTable := 0
		Local aCbxMod := {}
		Local lReturn := .F.
		Local oOk := LoadBitmap( GetResources(), "LBOK" )
		Local oNo := LoadBitmap( GetResources(), "LBNO" )
		Local aTypes := {{},{}}
		Local cTag
		If __lR7
			aObj := {{,,},,,,,,,{,,}}
			aProperties := Array(10)
			DEFAULT aEnable := {{.T.,.T.,.T.},.T.,.T.,.T.,.T.,.T.,.T.,{.T.,.T.,.T.}}
		Else
			aObj := {{,,},,,,,,}
			aProperties := Array(9)
			DEFAULT aEnable := {{.T.,.T.,.T.},.T.,.T.,.T.,.T.,.T.,.T.}
		Endif

		//Relacao de titulos e respectivos codigos a serem salvos no XNU
		AAdd(aTypes[1],STR0080);AAdd(aTypes[2],1)	//"Função Protheus"
		AAdd(aTypes[1],STR0081);AAdd(aTypes[2],2)	//"Relatório SIGRPM"
		AAdd(aTypes[1],STR0082);AAdd(aTypes[2],3)	//"Função de Usuário"
		AAdd(aTypes[1],STR0083);AAdd(aTypes[2],4)	//"Função Template"
		AAdd(aTypes[1],STR0084);AAdd(aTypes[2],5)	//"Relatório Crystal"
		AAdd(aTypes[1],STR0089);AAdd(aTypes[2],6)	//"Cons. Generica Relacional"
		AAdd(aTypes[1],STR0094);AAdd(aTypes[2],8)	//"Protheus Report"
		AAdd(aTypes[1],STR0096);AAdd(aTypes[2],9)	//"Relatório iReport"
		AAdd(aTypes[1],STR0100);AAdd(aTypes[2],11)	//"RM Report"

		//inicializa vetor de modulos usado pelo combobox
		Aeval(aRetMod,{|x,y| Aadd(aCbxMod,x[3])})
		aCbxMod := Asort(aCbxMod,,,{|x,y| x < y})
		Aadd(aCbxMod,STR0064) //"(Nenhum)"

		//inicializa vetor de propriedades que sera alterado
		aProperties[1] := {Space(25),Space(25),Space(25)}        //descricao
		aProperties[2] := Space(10)        //programa
		aProperties[3] := 1                //tipo
		aProperties[4] := Aclone(aTables)  //tabelas
		aProperties[5] := {{.T.,"01"},{.T.,"02"},{.T.,"03"},{.T.,"04"},{.T.,"05"},;
			{.T.,"06"},{.T.,"07"},{.T.,"08"},{.T.,"09"},{.T.,"10"}}  //rotinas
		aProperties[6] := STR0064          //modulo
		aProperties[7] := 0                //posicao no vetor aNewMnu
		aProperties[8] := aTypes[1][1]		// Type
		aProperties[9] := "0"			// Owner
		If __lR7
			aProperties[10] := {Space(25),Space(25),Space(25)}
		Endif

		//verifica se foi passado vetor com propriedades do item
		If !Empty(aInfo)

			aProperties[1][1] := Padr( aInfo[1][1], 25 )
			aProperties[1][2] := Padr( aInfo[1][2], 25 )
			aProperties[1][3] := Padr( aInfo[1][3], 25 )

			aProperties[2] := aInfo[2]
			aProperties[3] := If(aInfo[3] == "E",1,If(aInfo[3] == "D",2,If(aInfo[3] == "H",3,)))

			cTemp := aInfo[4]
			While !Empty(cTemp)
				cAlias := Subs(cTemp,1,3)
				If cAlias <> "..."
					nPos := Ascan(aProperties[4],{|x| x[2] == cAlias})
					If nPos <>0
						aProperties[4][nPos][1] := .T.
						nTable := nTable + 1
					EndIf
				EndIf
				cTemp := Subs(cTemp,4)
			End

			For i := 1 To Len(aInfo[5])
				If Subs(aInfo[5],i,1) <> "x"
					aProperties[5][i][1] := .F.
				EndIf
			Next

			nPos := Ascan(aRetMod,{|x| x[1] == Val(aInfo[6])})
			If ( nPos <> 0 )
				aProperties[6] := aRetMod[nPos][3]
			EndIf

			aProperties[7] := aInfo[7]
			aProperties[8] := aTypes[1][aScan(aTypes[2],aInfo[8])]
			aProperties[9] := "0"
			If __lR7
				aProperties[10][1] := Padr( aInfo[10][1], 25 )
				aProperties[10][2] := Padr( aInfo[10][2], 25 )
				aProperties[10][3] := Padr( aInfo[10][3], 25 )
			Endif

		EndIf

		DEFINE MSDIALOG oDlg FROM 00,00 TO 330,If(__lR7, 951, 720) TITLE STR0044 PIXEL //"Configuração do Item"

		@ 005,005 TO 073,110 PROMPT STR0053 PIXEL

		@ 011,008 SAY STR0077 PIXEL
		@ 019,008 GET aObj[1,1] VAR aProperties[1,1] SIZE 100,009 PIXEL

		@ 031,008 SAY STR0078 PIXEL
		@ 039,008 GET aObj[1,2] VAR aProperties[1,2] SIZE 100,009 PIXEL

		@ 051,008 SAY STR0079 PIXEL
		@ 059,008 GET aObj[1,3] VAR aProperties[1,3] SIZE 100,009 PIXEL

		@ 077,005 TO 099,110 PROMPT STR0019 PIXEL //"Programa:"
		@ 084,008 GET aObj[2] VAR aProperties[2] SIZE 85,09 WHEN (aObj[7]:nAt <> 9) PIXEL PICTURE "@!"
		@ 084,095 BUTTON oGetFile PROMPT "..." PIXEL SIZE 10,10 WHEN (aObj[7]:nAt == 2 .Or. aObj[7]:nAt == 6 .Or. aObj[7]:nAt == 7 .Or. aObj[7]:nAt == 9);
			ACTION (aProperties[2] := GetPath(aObj[7]:nAt) ,aObj[2]:Refresh())	//"Advaced Protheus Report Utility"###"Arquivo de Relatório|*.rpm"

		@ 103,005 TO 148,110 PROMPT STR0085 PIXEL
		@ 111,008 RADIO aObj[3] VAR aProperties[3] SIZE 50,12 PIXEL PROMPT STR0047,STR0048,STR0049 //"Habilitado" # "Desabilitado" # "Inibido"

		@ 005,117 TO 025,222 PROMPT STR0020 PIXEL //"Módulo:"
		@ 011,120 COMBOBOX aObj[6] VAR aProperties[6] ITEMS aCbxMod PIXEL SIZE 100,50

		@ 030,117 TO 050,222 PROMPT STR0046 PIXEL	//"Tipo"
		@ 036, 120 COMBOBOX aObj[7] VAR aProperties[8] ITEMS aTypes[1] SIZE 100,50 PIXEL ;
			ON CHANGE (aProperties[2] := If(aObj[7]:nAt == 2 .Or. aObj[7]:nAt == 6 .Or. aObj[7]:nAt == 7,Space(255),Space(10)),aObj[2]:Refresh())
		aProperties[2] := If(aObj[7]:nAt == 2 .Or. aObj[7]:nAt == 6 .Or. aObj[7]:nAt == 7,Padr(aProperties[2],255),Padr(aProperties[2],10))

		@ 055,117 TO 148,222 PROMPT STR0050 PIXEL //"Rotinas do browse:"
		@ 063,120 LISTBOX aObj[5] FIELDS HEADER "","" SIZE 098,080 PIXEL

		aObj[5]:SetArray(aProperties[5])
		aObj[5]:bLine := {|| {If(aProperties[5][aObj[5]:nAt,1],oOk,oNo),aProperties[5][aObj[5]:nAt,2]}}
		aObj[5]:bLDblClick := {|| aProperties[5][aObj[5]:nAt,1] := !aProperties[5][aObj[5]:nAt,1],aObj[5]:DrawSelect()}

		@ 005,228 TO 148,357 PROMPT STR0051 PIXEL //"Tabelas:"
		@ 015,232 LISTBOX aObj[4] FIELDS HEADER "",STR0052,STR0053 SIZE 120,128 PIXEL //"Alias" # "Descrição"

		aObj[4]:SetArray(aProperties[4])
		aObj[4]:bLine := {|| {If(aProperties[4][aObj[4]:nAt,1],oOk,oNo),aProperties[4][aObj[4]:nAt,2],aProperties[4][aObj[4]:nAt,3]}}
		aObj[4]:bLDblClick := {|| If(ValTables(@nTable,aObj[4]:nAt,@aProperties[4]),aObj[4]:DrawSelect(),)}

		If __lR7
			@ 005,363 TO 148,472 PROMPT STR0114 PIXEL //"Palavras-Chave"

			@ 011,368 SAY STR0077 PIXEL
			@ 019,368 GET aObj[8,1] VAR aProperties[10,1] SIZE 100,009 PIXEL
			aObj[8,1]:lReadOnly := .T.
			aObj[8,1]:bGotFocus := {|| cTag := FWEditKeyWord(aProperties[1,1], aProperties[10,1], STR0077), aProperties[10,1] := cTag }

			@ 031,368 SAY STR0078 PIXEL
			@ 039,368 GET aObj[8,2] VAR aProperties[10,2] SIZE 100,009 PIXEL
			aObj[8,2]:lReadOnly := .T.
			aObj[8,2]:bGotFocus := {|| cTag := FWEditKeyWord(aProperties[1,1], aProperties[10,2], STR0078), aProperties[10,2] := cTag }

			@ 051,368 SAY STR0079 PIXEL
			@ 059,368 GET aObj[8,3] VAR aProperties[10,3] SIZE 100,009 PIXEL
			aObj[8,3]:lReadOnly := .T.
			aObj[8,3]:bGotFocus := {|| cTag := FWEditKeyWord(aProperties[1,1], aProperties[10,3], STR0079), aProperties[10,3] := cTag }

		EndIf

		For i := 1 To Len(aObj)
			If i == 1 .Or. i == 8
				For j:=1 To Len(aEnable[i])
					If !aEnable[i,j]
						aObj[i,j]:Disable()
					EndIf
				Next J
			ElseIf !aEnable[i]
				If (i == 4) .or. (i == 5)
					aObj[i]:bLDblClick := {|| }
				Else
					aObj[i]:Disable()
				EndIf
			EndIf
		Next

		DEFINE SBUTTON FROM 151,If(__lR7,385,285) TYPE 1 ENABLE OF oDlg ACTION If(ValProperties(aProperties,aEnable),(lReturn := .T.,oDlg:End()),)

		DEFINE SBUTTON FROM 151,If(__lR7,417,317) TYPE 2 ENABLE OF oDlg ACTION oDlg:End()

		ACTIVATE MSDIALOG oDlg CENTERED

		i := 0
		j := 0

		If lReturn
			For i := 1 To Len(aEnable)
				If (i == 1)
					For j := 1 To Len(aEnable[i])
						If aEnable[i,j]
							aInfo[i,j] := aProperties[i,j]
						EndIf
					Next J
				ElseIf (i == 8)
					For j := 1 To Len(aEnable[i])
						If aEnable[i,j]
							aInfo[10,j] := aProperties[10,j]
						EndIf
					Next J
				ElseIf aEnable[i]
					If (i == 3)
						aInfo[i] := If(aProperties[i] == 1,"E",If(aProperties[i] == 2,"D",If(aProperties[i] == 3,"H",)))
					ElseIf (i == 4)
						aInfo[i] := {}
						For j := 1 To Len(aProperties[i])
							If aProperties[i][j][1]
								aAdd( aInfo[i], aProperties[i][j][2] )
							EndIf
						Next
					ElseIf (i == 5)
						aInfo[i] := ""
						For j := 1 To Len(aProperties[i])
							aInfo[i] := aInfo[i] + If(aProperties[i][j][1],"x"," ")
						Next
					ElseIf (i == 7)
						aInfo[8] := aTypes[2][Ascan(aTypes[1],aProperties[8])]
					Else
						aInfo[i] := aProperties[i]
					EndIf
				EndIf
			Next
			aInfo[9] := "0"
		EndIf
		Return lReturn

		Static ;
		Function ValTables(nTable,nAt,aNewTable)

		If aNewTable[nAt,1]
			nTable := nTable - 1
			aNewTable[nAt,1] := .F.
			Return .T.
		ElseIf nTable < 200
			nTable := nTable + 1
			aNewTable[nAt,1] := .T.
			Return .T.
		EndIf
		Return .F.

		Static ;
		Function ValProperties(aProperties,aEnable)
		Local nPos

		//valida descricao
		If aEnable[1,1] .and. ( Empty(aProperties[1][1]) .OR. Empty(aProperties[1][2]) .OR. Empty(aProperties[1][3]) )
			MsgAlert(STR0054,STR0003) //"Descrição em branco." # "Atenção"
			Return .F.
		EndIf

		//valida programa
		If aEnable[2]
			If Empty(aProperties[2])
				MsgAlert(STR0055,STR0003) //"Programa em branco." # "Atenção"
				Return .F.
			EndIf
		EndIf

		If ( aEnable[6] )
			aProperties[6] := Trim(aProperties[6])
			nPos := Ascan(aRetMod,{|x| Trim(x[3]) == aProperties[6]})
			If ( nPos == 0 )
				MsgAlert(STR0057,STR0003) //"Nenhum módulo foi escolhido." # "Atenção"
				Return .F.
			Else
				aProperties[6] := StrZero(aRetMod[nPos][1],2,0)
			EndIf
		EndIf
		Return .T.

		Static ;
		Function ReadSx2()
		Local cFilter
		Local aArqs := {}
		Local cOldAlias := Alias()

		DbSelectArea("SX2")
		cFilter := DbFilter()
		Set Filter To
		ProcRegua(RecCount())
		DbGotop()
		DbEval({|| IncProc(Capital(X2Nome())),Aadd(aArqs,{.F.,X2_CHAVE,Capital(OemToAnsi(X2Nome()))})})
		If ( ! Empty(cFilter) )
			Set Filter To &cFilter
		EndIf
		DbSelectArea(cOldAlias)
		Return aArqs

		Static ;
		Function GetModulo(oFWMenuManage, nTree)

		Local cReturn := ""

		Local nModule := oFWMenuManage:GetModulo( nTree )

		DEFAULT nTree := 1

		If !( nModule == 0 )
			nModule := Ascan(aRetMod,{|x| x[1] == nModule})
			If !( nModule == 0 )
				cReturn := aRetMod[nModule][2]
			EndIf
		EndIf

		Return cReturn

		Static ;
		Function GetPrgName(oFWMenuManage,nTree)
		DEFAULT nTree := 1
		Return oFWMenuManage:GetPrgName( nTree )

		Static ;
		Function GetDirMnu( )
		Local oDlg
		Local aListDir := Aclone(aDirMnu)
		Local nListDir := 1
		Local oListDir
		Local cNewDir := Space(255)
		Local oNewDir
		Local lNewDir := .F.

		DEFINE MSDIALOG oDlg FROM 00,00 TO 175,273 TITLE STR0060 PIXEL //"Configurar diretórios de menu"

		@01,05 SAY STR0061 PIXEL //"Digite o nome do diretório a adicionar:"
		@10,05 GET oNewDir VAR cNewDir PIXEL SIZE 88,10 PICTURE "@!"

		@10,95 BUTTON oAdd PROMPT OemToAnsi(STR0072) SIZE 40,11 PIXEL; //"&Adicionar >>" ## "&Procurar"
		ACTION (cNewDir := Padr(cGetFile(,,,,.T.,128),255),oNewDir:Refresh())

		@25,05 SAY STR0062 PIXEL //"Diretórios selecionados:"
		@34,05 LISTBOX oListDir VAR nListDir ITEMS aListDir PIXEL SIZE 88,50;
			ON CHANGE If(oListDir:nAt == 1,oDel:Disable(),oDel:Enable())

		@34,95 BUTTON oAdd PROMPT STR0021 SIZE 40,11 PIXEL; //"&Adicionar >>"
		ACTION (If(ValdAddDir(cNewDir,@aListDir),oListDir:SetItems(aListDir),),oNewDir:SetFocus())

		@47,95 BUTTON oDel PROMPT STR0022 SIZE 40,11 PIXEL; // "<< &Remover"
		ACTION (Adel(aListDir,oListDir:nAt),aSize(aListDir,Len(aListDir)-1),oListDir:SetItems(aListDir));
			WHEN oListDir:nAt > 1
		oDel:Disable()

		@60,95 BUTTON oOK PROMPT "&OK" SIZE 40,11 PIXEL ACTION (lNewDir := .T.,oDlg:End())

		@73,95 BUTTON oCancel PROMPT STR0063 SIZE 40,11 PIXEL ACTION oDlg:End() //"&Cancelar"

		ACTIVATE MSDIALOG oDlg CENTERED

		If ( lNewDir )
			aDirMnu := Aclone(aListDir)
		EndIf
		Return lNewDir

		Static ;
		Function ValdAddDir(cNewDir,aListDir)
		Local cDir
		Local lRet
		Local cFile

		cDir := AllTrim(cNewDir)

		If ( Subs(cDir,1,1) <> "\" )
			MsgStop(STR0071,STR0003) //"Diretório inválido." # "Atenção"
			lRet := .F.
		ElseIf ( Subs(cDir,Len(cDir),1) <> "\" )
			MsgStop(STR0071,STR0003) //"Diretório inválido." # "Atenção"
			lRet := .F.
		Else
			cFile := cDir+"EXISTE.DIR"
			nHdl := Fcreate(cFile)
			If ( nHdl < 0 )
				MsgStop(STR0071,STR0003) //"Diretório inválido." # "Atenção"
				lRet := .F.
			Else
				Fclose(nHdl)
				Ferase(cFile)
				If Ascan(aListDir,cDir) == 0
					Aadd(aListDir,cDir)
				EndIf
				lRet := .T.
			EndIf
		EndIf
		Return lRet

		Static ;
		Function ReadDirMnu(aModDefault)
		Local i,j
		Local aDir
		Local cMenu
		Local aTemp := {}
		Local aConvMnu2Xnu := {}

		DEFAULT aModDefault  := {}

		aTemp := Aclone(aModDefault)

		For i := 1 To Len(aDirMnu)
			aDir := Directory(aDirMnu[i]+"*"+RetExtMnu())
			For j := 1 To Len(aDir)
				cMenu := Upper(AllTrim(aDir[j][1]))

				If ( __lPyme ) .And. ( Subs( cMenu, 1, 4) == 'SIGA' ) .And. ( ! ModIsPyme(Subs( cMenu, 5, 3 ) ) )
					Loop
				EndIf

				If Ascan(aTemp,{|x| x[3] == cMenu .and. x[5] == aDirMnu[i]}) == 0
					Aadd(aTemp,{.T.,Capital(cMenu),cMenu,00,aDirMnu[i]})
				EndIf
			Next
		Next
		Return aTemp

		Static ;
		Function ResetList(aList,aNewList)
		Local i
		Local aRet := Aclone(aList)

		If !Empty(aNewList)
			For i := 1 To Len(aNewList)
				If Ascan(aRet,{|x| AllTrim(x[5]) == AllTrim(aNewList[i][1]) .and. AllTrim(x[3]) == AllTrim(aNewList[i][2])}) == 0
					Aadd(aRet,{.F.,Capital(aNewList[i][2]),aNewList[i][2],00,aNewList[i][1]})
				EndIf
			Next
		EndIf
		Return aRet

		Static ;
		Function FindMenu(oListMnu,aListMnu)
		Local oDlgSeek
		Local cSeek := Space(20)
		Local lCase := .F.
		Local lWord := .F.
		Local nLastSeek := 0
		Local cLastSeek := ""
		Local nPos := oListMnu:nAt
		Local aSeek := {}

		Aeval(aListMnu,{|x,y| Aadd(aSeek,x[2])})

		DEFINE MSDIALOG oDlgSeek FROM 00,00 TO 105,370 TITLE OemtoAnsi(STR0072) PIXEL   //  "Pesquisar"

		@07,02 SAY OemToAnsi(STR0072)+":" OF oDlgSeek PIXEL //"Pesquisar"
		@05,30 GET cSeek OF oDlgSeek PIXEL SIZE 100,9

		@20,02 TO 51,130 LABEL OemtoAnsi(STR0010) PIXEL OF oDlgSeek //"Opções"
		@27,05 CHECKBOX lCase PROMPT OemtoAnsi(STR0073) FONT oDlgSeek:oFont PIXEL SIZE 80,09 //"&Coincidir maiúsc./minúsc."
		@38,05 CHECKBOX lWord PROMPT OemtoAnsi(STR0074) FONT oDlgSeek:oFont PIXEL SIZE 80,09 //"Localizar palavra &inteira"

		@05,135 BUTTON OemtoAnsi(STR0075) PIXEL OF oDlgSeek SIZE 44,11; //"&Próximo"
		ACTION (nPos := FastSeek(cSeek,nPos,aSeek,lCase,lWord),oListMnu:nAt := nPos,oListMnu:Refresh())

		@18,135 BUTTON OemtoAnsi(STR0063) PIXEL ACTION oDlgSeek:End() OF oDlgSeek SIZE 44,11 //"&Cancelar"

		ACTIVATE MSDIALOG oDlgSeek CENTERED
		Return

		//-------------------------------------------

	Static Function GrpProperties(aInfo,aEnable)

		Local aGrupo := { Padr( aInfo[1][1], 25 ),Padr( aInfo[1][2], 25 ),Padr( aInfo[1][3], 25 )}

		Local lReturn := .F.

		Local nStatus := If(aInfo[2] == "E",1,If(aInfo[2] == "D",2,If(aInfo[2] == "H",3,)))

		Local oDlg
		Local oGrupo := Array(3)
		Local oStatus := Nil

		DEFINE MSDIALOG oDlg TITLE STR0076 FROM 0,0 TO 265,300 PIXEL

		@ 003,003 TO 085,149 PIXEL

		@ 008,007 SAY STR0077 OF oDlg PIXEL

		@ 018,007 GET oGrupo[1] VAR aGrupo[1] PIXEL PICTURE "@!" SIZE 139,011 WHEN aEnable[1][1]

		@ 033,007 SAY STR0078 OF oDlg PIXEL

		@ 043,007 GET oGrupo[2] VAR aGrupo[2] PIXEL PICTURE "@!" SIZE 139,011 WHEN aEnable[1][2]

		@ 058,007 SAY STR0079 OF oDlg PIXEL

		@ 068,007 GET oGrupo[3] VAR aGrupo[3] PIXEL PICTURE "@!" SIZE 139,011 WHEN aEnable[1][3]

		@ 087,003 TO 128,075 PROMPT STR0085 PIXEL

		@ 092,007 RADIO oStatus VAR nStatus SIZE 50,12 PIXEL PROMPT STR0047,STR0048,STR0049 WHEN aEnable[4] //"Habilitado" # "Desabilitado" # "Inibido"

		DEFINE SBUTTON FROM 100,080 TYPE 1 ENABLE OF oDlg ACTION ( If( !Empty(aGrupo[nTitle]), (lReturn := .T., oDlg:End()), ApMsgAlert(STR0086,STR0003) ))

		DEFINE SBUTTON FROM 100,115 TYPE 2 ENABLE OF oDlg ACTION oDlg:End()

		ACTIVATE DIALOG oDlg CENTERED

		If lReturn
			aInfo[1][1] := Capital(aGrupo[1])
			aInfo[1][2] := Capital(aGrupo[2])
			aInfo[1][3] := Capital(aGrupo[3])
			aInfo[2]	:= If(nStatus == 1, "E",If(nStatus == 2, "D",If(nStatus == 3, "H",)))
		EndIf

		Return lReturn

		//---------------------------------------

		Static ;
		Function FastSeek(cGet,nLastSeek,aArray,lCase,lWord)
		Local nSearch := 0
		Local bSearch

		cGet := Trim(cGet)

		If ( lCase .And. lWord )
			bSearch := {|x| Trim(x) == cGet}
		ElseIf ( !lCase .And. !lWord )
			bSearch := {|x| Trim(Upper(SubStr(x,1,Len(cGet)))) == Upper(cGet)}
		ElseIf ( lCase .And. !lWord )
			bSearch := {|x| Trim(SubStr(x,1,Len(cGet))) == cGet}
		ElseIf ( !lCase .And. lWord )
			bSearch := {|x| Trim(Upper(x)) == Upper(cGet)}
		EndIf

		nSearch := Ascan(aArray,bSearch,nLastSeek+1)
		If ( nSearch == 0 )
			nSearch := Ascan(aArray,bSearch)
			If ( nSearch == 0 )
				nSearch := nLastSeek
			EndIf
		EndIf
		Return nSearch

		//---------------------------------------

	Static Function GetPath(nType)

		Local cMask		:= ""
		Local cRet		:= ""

		If nType == 9
			cRet := GetRMRepInfo()
		Else
			If nType == 2
				cMask := STR0088 // "Arquivo de Relatório|*.rpm"
			ElseIf nType == 6
				cMask := STR0090 // "Arquivo de Configuracöes (Consulta Generica)|*.NGC | Arquivo de Configuracöes (Consulta Generica - Versöes Anteriores)|*.C4W"
			Else
				cMask := STR0095 // "Protheus Report|*.xrp"
			EndIf
			cRet := Padr(cGetFile(cMask,STR0087,,,.F.,GETF_ONLYSERVER),255) //"Advaced Protheus Report Utility"
		EndIf

		Return cRet

		//---------------------------------------

	Static Function GetRMRepInfo()

		Local cRet		:= ""
		Local cRels		:= ""
		Local cPesq		:= Space(100)
		Local aRelList	:= {}
		Local aRels		:= {}
		Local aTmp		:= {}
		Local nPosSel	:= 0
		Local nX		:= 0
		Local lOk		:= .T.
		Local oDlg
		Local oPanel
		Local oOk
		Local oNo
		Local oPesq
		Local oWS
		Local oFWFormBar

		//ToDo:Checar parametro do WSDL do RM
		//ToDo:Carregar client do WebService

		//	CODCOLIGADA, CODAPLICACAO, ID, CODIGO, DESCRICAO, DATACRIACAO, GUID
		//	Empresa, sistema, identificador, código (digitado pelo usuário), descrição, data de criação e identificador único
		oWS := WSRptWebServicesServer():New()

		If oWS:GetReportList()
			cRels := oWS:cGetReportListResult
			aRels := StrToKArr(cRels,";")
			For nX := 1 to Len(aRels)
				aTmp := StrToKArr(aRels[nX],",")
				aAdd(aRelList,{	.F.		,;	//Marca de selecao
				aTmp[3]	,;	//ID
				aTmp[5]	,;	//Descricao
				aTmp[1]	,;	//Cod.Coligada (Empresa)
				aTmp[2]	,;	//Sistema
				aTmp[4]	,;	//Codigo
				aTmp[6]	,;	//Data Criacao
				aTmp[7]	})	//GUID
			Next nX
			aSort(aRelList,,,{|x,y| x[1] < y[1]})
		Else
			lOk := .F.
			MsgInfo(STR0101) //"WebService do RM Reports não disponível"
		EndIf

		If lOk .AND. Len(aRelList) == 0
			MsgStop(STR0102) //"Nenhum relatório foi encontrado no RM Reports"
			lOk := .F.
		EndIf

		If lOk

			oOk := LoadBitMap(GetResources(), "LBOK")
			oNo := LoadBitMap(GetResources(), "LBNO")

			DEFINE MSDIALOG oDlg TITLE STR0103 FROM 0,0 TO 500,880 PIXEL STYLE nOr(WS_VISIBLE,WS_POPUP) //"Relatórios disponíveis"

			oFWLayer := FWLayer():New()
			oFWLayer:init( oDlg, .F. )
			oFWLayer:addCollumn( "Col01", 100, .T. )
			oFWLayer:addWindow( "Col01", "Win01", STR0103, 100, .F., .T. )

			oPanel := oFWLayer:getWinPanel( "Col01", "Win01" )

			@ 007,005 SAY STR0104 OF oPanel PIXEL //"Busca:"
			@ 005,025 MSGET oPesq VAR cPesq OF oPanel SIZE 150,10 PIXEL
			@ 005,180 BUTTON STR0105 SIZE 30,12 OF oPanel PIXEL Action(LBoxSeek(@oLBx,cPesq,@oPesq)) //"Pesquisar"
			@ 005,215 BUTTON STR0106 SIZE 30,12 OF oPanel PIXEL Action(LBoxSeek(@oLBx,cPesq,@oPesq,.F.)) //"Próximo"

			@ 021,005 LISTBOX oLbx FIELDS;
				HEADER  ""			,;
				STR0107		,;	//"Id."
			STR0053		,;	//"Descrição"
			STR0108		,;	//"Empresa"
			STR0109		,;	//"Sistema"
			STR0110		,;	//"Código"
			STR0111		,;	//"Data"
			STR0112		,;	//"Id. Único"
			COLSIZES 05,20,45,10,30,40,30,110;
				SIZE 420,200 OF oPanel PIXEL;
				ON DblClick( aEval(oLbx:aArray,{|x| x[1] := .F.}), oLbx:aArray[oLbx:nAt,1] := .T., oLbx:Refresh() )

			oLbx:SetArray(aRelList)
			oLbx:bLine := { || {If(aRelList[oLbx:nAt,1],oOk,oNo),;
				aRelList[oLbx:nAt,2],;
				aRelList[oLbx:nAt,3],;
				aRelList[oLbx:nAt,4],;
				aRelList[oLbx:nAt,5],;
				aRelList[oLbx:nAt,6],;
				aRelList[oLbx:nAt,7],;
				aRelList[oLbx:nAt,8]}}

			oFWFormBar := FWFormBar():New( oPanel )
			oFWFormBar:AddOk( {|| nPosSel := aScan(oLbx:aArray,{|x|x[1]}) ,oDlg:End() } )
			oFWFormBar:AddClose( {|| oDlg:End() } )
			oFWFormBar:Activate()

			ACTIVATE MSDIALOG oDlg CENTERED

			If nPosSel > 0
				cRet := aRelList[nPosSel][4]+";"+aRelList[nPosSel][2]
			EndIf

		Else
			MsgInfo(STR0113) //"Não foi possível obter a lista de relatórios no servidor do RM"
		EndIf

		Return cRet

		/*
		ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
		±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
		±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
		±±ºPrograma  ³Tk040BuscaºAutor  ³Vendas CRM          º Data ³  23/11/10   º±±
		±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
		±±ºDesc.     ³Pesquisa um valor no array do listbox, posicionando o mesmo º±±
		±±º          ³em caso de sucesso. O objeto do MsGet sera colorido na cor  º±±
		±±º          ³vermelha quando a ocorrencia nao for encontrada.            º±±
		±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
		±±ºParametros³ExpO1 - Listbox das habilidades                             º±±
		±±º          ³ExpC2 - Texto pesquisado                                    º±±
		±±º          ³ExpO3 - Get da pesquisa                                     º±±
		±±º          ³ExpL4 - Indica se deve pesquisar do inicio(.T.) ou nao(.F.) º±±
		±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
		±±ºUso       ³TMKA090                                                     º±±
		±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
		±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
		ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
		*/
	Function LBoxSeek(oLbx,cBusca,oGtBusca,lInicio)

		Local nStart	:= 1
		Local lAchou	:= .F.
		Local nCols		:= 0
		Local nCount,nCount2

		Default oGtBusca:= Nil
		Default lInicio	:= .T.

		If !lInicio
			nStart := oLbx:nAt+1
		EndIf

		nCols := Len(oLbx:aArray[1])

		//Procura em todas as linhas e colunas pelo conteudo solicitado.
		For nCount := nStart To Len(oLbx:aArray)
			For nCount2 := 2 To nCols
				If Upper(AllTrim(cBusca)) $ Upper(AllTrim(oLbx:aArray[nCount][nCount2]))
					oLbx:nAt := nCount
					oLbx:Refresh()
					lAchou := .T.
					Exit
				EndIf
			Next

			//Se encontrou um resultado abandona.
			If lAchou
				Exit
			EndIf
		Next

		If oGtBusca <> Nil
			If lAchou
				oGtBusca:SetColor(CLR_BLACK,CLR_WHITE)
			Else
				oGtBusca:SetColor(CLR_WHITE,CLR_HRED)
			Endif
		EndIf

		Return Nil

		//-------------------------------------------------------------------
		/*/{Protheus.doc} ASxEditKeyWord
		Função para edição de palavras-chave

		@param cItem Nome do item de menu
		@param cKeys Palavras-chave já cadastradas

		@result cRet String com as palavras-chavev concatenadas atraves de virgula

		@author  Juliane Venteu
		@since   06/02/2012
		@version P11
		/*/
		//-------------------------------------------------------------------
	Static Function FWEditKeyWord(cItem, cKeys, cIdioma)
		Local oDlg
		Local oGetDados
		Local aHeader   := {{"KEYWORD", "KEYWORD", "@!",30,0,,,"C"}}
		Local aResult	:= {}
		Local aFieldAlter 	:=	{"KEYWORD"}
		Local aKeys
		Local nI
		Local cRet := cKeys

		If !Empty(cKeys)
			aKeys := StrTokArr(cKeys,",")

			aEval(aKeys, {|x| aAdd(aResult, {x+Space(30-Len(x)),.F.} )})
		EndIf

		DEFINE MSDIALOG oDlg TITLE STR0115  FROM 0,0 TO 460,450 OF oMainWnd PIXEL  //"Edição de Palavras-Chave"

		@ 000,000 MSPANEL oPanel SIZE 000,010 RAISED
		oPanel:Align := CONTROL_ALIGN_ALLCLIENT

		DEFINE FONT oBold NAME "Arial" SIZE 0, -13 BOLD

		@  03, 4 SAY STR0114 FONT oBold PIXEL of oPanel //"Palavras-Chave"

		@  14, 1 TO 16,400 LABEL ''  OF oPanel PIXEL

		@  18, 12 SAY STR0116 FONT oBold PIXEL of oPanel //"Item:"

		@  19, 32 SAY ALLTRIM(cItem) FONT PIXEL of oPanel

		@  25, 12 SAY STR0117 FONT oBold PIXEL of oPanel //"Idioma:"

		@  26, 38 SAY ALLTRIM(cIdioma) FONT PIXEL of oPanel

		oGetDados := MsNewGetDados():New(36,12,201,224,GD_INSERT + GD_UPDATE + GD_DELETE, "VldKeyWord","TOKKeyWord", ,aFieldAlter,,,,;
			,, oPanel, aHeader, aResult,, )

		ACTIVATE MSDIALOG oDlg CENTERED ON INIT( EnchoiceBar(oDlg,{|| if ( TOKKeyWord(oGetDados), ( cRet := GetKeyWord(oGetDados) , oDlg:End() ),) ,}, ;
			{|| oDlg:End()},/*lMessageDel*/,/*aButtons*/,/*nReg*/,/*cAlias*/,.F.,.F. ))

		Return cRet


		//-------------------------------------------------------------------
		/*/{Protheus.doc} VldKeyWord
		Função para validação de palavras-chave
		Não são permitidos espaços, hifen e virgula

		@param cKeyTrad Palavra traduzida
		@param lTrad    Indica que precisa validar a tradução

		@author  Juliane Venteu
		@since   06/02/2012
		@version P11
		/*/
		//-------------------------------------------------------------------
	Function VldKeyWord(oGetDados)
		Local lRet := .F.

		If Empty(ALLTRIM(aCols[n][1]))
			Aviso( STR0003, STR0118, { "Ok"}, 2  ) 	 //Atenção # "Informe uma palavra."
		ElseIf "," $ ALLTRIM(aCols[n][1])
			Aviso( STR0003, STR0120, { "Ok"}, 2  ) //Atenção # "Não é permitido o caracter ',' nas palavras-chave. Retire esse caracter da palavra."
		Else
			lRet :=	.T.
		EndIf

		Return lRet

		//-------------------------------------------------------------------
		/*/{Protheus.doc} TOKKeyWord
		Essa função tem por finalidade criar a String com as palavras-chave

		@author  Juliane Venteu
		@since   06/02/2012
		@version P11
		/*/
		//-------------------------------------------------------------------
	Static Function TOKKeyWord(oGetDados)
		Local nI
		Local lRet := .T.

		For nI := 1 to len(oGetDados:aCols)
			oGetDados:GoTo(nI)
			If !oGetDados:LinhaOK()
				lRet := .F.
				Exit
			EndIf
		Next nI

		Return lRet

		//-------------------------------------------------------------------
		/*/{Protheus.doc} TOKKeyWord
		Essa função tem por finalidade criar a String com as palavras-chave

		@author  Juliane Venteu
		@since   06/02/2012
		@version P11
		/*/
		//-------------------------------------------------------------------
	Static Function GetKeyWord(oGetDados)
		Local nI
		Local cRet := ""

		For nI := 1 to len(oGetDados:aCols)
			If !oGetDados:aCols[nI][2]
				If ALLTRIM(oGetDados:aCols[nI][1]) <> ""
					cRet += ALLTRIM(oGetDados:aCols[nI][1])
					If nI <> Len(oGetDados:aCols)
						cRet += ","
					EndIf
				EndIf
			EndIf
		Next nI

		//TESTE RPO PDV.
		Return cRet