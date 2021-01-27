#INCLUDE "Protheus.ch"
#INCLUDE "CFGX012.ch"
#INCLUDE "SCROLLBX.CH"
#include "JPEG.CH"
#include "FileIO.ch"

#DEFINE AJUSTADO 1
#DEFINE NAMESIZE 20
#define MAX_BMP_SIZE 900000 // 900K

Static __aRecnoReposit := {}

//--------------------------------------------------------------------------------------
Function CFGX012()
	Local oDlg
	Local oList
	Local oBmp
	Local oDel
	Local oExt
	Local oScrollBox
	Local oStretch
	Local nBmpHeigth := 80
	Local nBmpWidth  := 100
	Local nStretch	  := 1
	Local cBitMap 	  := Space(255)
	Local cDirAtu 	  := "" // Diretório incial da cGetfile de inclusão
	local nWidth	  := oMainWnd:nClientWidth  // Largura
	Local nHeight	  := oMainWnd:nClientHeight // Altura
	Local oBold
	Local nMaskDef   := 1 // Masca JPEG como Default
	Local lFlatMode := If(FindFunction("FLATMODE"),FlatMode(),SetMDIChild())
	Local oPanel
	Local nWndTop
	Local nWndLeft
	Local nAdjust
	Local nSavHdl,cSavAlias
	Local nType := 0
	Local lImport := .F.

	nType := Val(GetSrvProfString('REPOSITINDATABASE',StrZero(nType,1,0)))

	If ( nType == 1 .and. __cRdd <> "TOPCONN" )
		Alert(STR0054 + CRLF + STR0055) //"Não é possível utilizar a rotina de Repositória de imagens." # "Configure a chave REPOSITINDATABASE para o tipo de banco que está sendo utilizado."
		Return
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

	DEFINE MSDIALOG oDlg FROM nWndTop,nWndLeft TO oMainWnd:nBottom-nAdjust,oMainWnd:nRight-10 TITLE STR0014 PIXEL //"Repositório de Imagens"
	oDlg:lMaximized := .T.

	DEFINE FONT oBold NAME "Arial" SIZE 0, -13 BOLD

	@00,00 MSPANEL oPanel SIZE 25,25
	oPanel:Align := CONTROL_ALIGN_TOP

	@03,03 SAY STR0026 FONT oBold PIXEL OF oPanel //"Repositório de Imagens"
	@14,03 TO 16,oDlg:nWidth LABEL '' OF oPanel  PIXEL

	@00,00 MSPANEL oPanel SIZE 03,03
	oPanel:Align := CONTROL_ALIGN_LEFT

	If RepositInBD()
		@25,03 LISTBOX oList FIELDS "BPMNAME","ALIAS" ALIAS "PROTHEUS_REPOSIT" HEADER OemToAnsi(STR0001),"Alias" OF oDlg PIXEL SIZE 110,80; //"Imagens"//
		ON CHANGE (ChangeStr(oBmp,nStretch), ChgList( oBmp, oList, @cBitmap, oDel, oExt ))
	Else
		@25,03 LISTBOX oList FIELDS oBmp:EntryName(oList:nAt) HEADER OemToAnsi(STR0001) OF oDlg PIXEL SIZE 110,80; //"Imagens"//
		ON CHANGE (ChangeStr(oBmp,nStretch), ChgList( oBmp, oList, @cBitmap, oDel, oExt ))
	EndIf
	oList:cToolTip := STR0028 //"Duplo click ou <Enter> para visualizar a imagen"
	oList:Align := CONTROL_ALIGN_LEFT

	@00,00 MSPANEL oPanel SIZE 03,03
	oPanel:Align := CONTROL_ALIGN_LEFT

	@25,114 SCROLLBOX oScrollBox SIZE ((oDlg:nHeight /2) - 80), ((oDlg:nWidth/2) - 190) OF oDlg VERTICAL HORIZONTAL BORDER
	oScrollBox:Align := CONTROL_ALIGN_ALLCLIENT

	@ 000, 000 REPOSITORY oBmp SIZE nBmpWidth, nBmpHeigth OF oScrollBox PIXEL NOBORDER
	oBmp:lAutoSize := .T.

	@00,00 MSPANEL oPanel SIZE 03,03
	oPanel:Align := CONTROL_ALIGN_RIGHT

	@00,00 MSPANEL oPanel SIZE 36,36
	oPanel:Align := CONTROL_ALIGN_BOTTOM

	@ 05,03 TO 32,113 LABEL OemToAnsi(STR0016) PIXEL OF oPanel //"Visualização"
	@ 11,08 RADIO oStretch VAR nStretch ITEMS OemtoAnsi(STR0017),OemtoAnsi(STR0018) SIZE 70,10 PIXEL OF oPanel;   //"Ajustado"##"Normal"
	ON CHANGE ChangeStr(oBmp,nStretch)

	@ 13,(oDlg:nWidth/2)-195 BUTTON STR0043 SIZE 30 ,11 FONT oDlg:oFont ACTION MsgRun(STR0044,"",{|| ImportInBD(@oBMP), lImport := .T., ChangeStr(oBmp,2), If(RepositInBD(), LoadRepBD(), ChgList(oBmp,oList,@cBitmap,oDel,oExt)),oList:Refresh() }) OF oPanel PIXEL // "Importar" ### "Atualizando o repositório de objetos. aguarde..."

	@ 13,(oDlg:nWidth/2)-160 BUTTON STR0037 SIZE 30 ,11   FONT oDlg:oFont ACTION PesqImg(oList,oBmp) OF oPanel PIXEL
	DEFINE SBUTTON      FROM 13,(oDlg:nWidth/2)-125 TYPE 04 ENABLE OF oPanel ACTION (InsertREP(oList,oBmp,@cDirAtu,@nMaskDef),ChangeStr(oBmp,2),ChgList(oBmp,oList,@cBitmap,oDel,oExt))
	DEFINE SBUTTON oDel FROM 13,(oDlg:nWidth/2)-95 TYPE 03 ENABLE OF oPanel ACTION DeleteBmp(oBmp,oDel,@cBitmap,oList,oExt, lImport)
	DEFINE SBUTTON oExt FROM 13,(oDlg:nWidth/2)-65 TYPE 13 ENABLE OF oPanel ACTION ExtractREP(oList,obmp)
	DEFINE SBUTTON      FROM 13,(oDlg:nWidth/2)-35 TYPE 01 ENABLE OF oPanel ACTION oDlg:End()

	oExt:cToolTip := OemtoAnsi(STR0020)   //   "Extrair Bitmap..."

	// Inicializa o List com os nomes dos bitmaps
	InitList( oList, oBmp )

	ACTIVATE DIALOG oDlg ON INIT ( nSavHdl := oBmp:nHdl, cSavAlias := oBmp:cAlias, ChangeStr(oBmp,2), ChgList( oBmp, oList, @cBitmap, oDel, oExt ) )

	CloseReposit(nSavHdl,cSavAlias,.T.)

	PackRepository()

	Return Nil

	//--------------------------------------------------------------------------------------
Static Function DeleteBmp(oBmp,oDel,cBitmap,oList,oExt, lImport)

	If MsgYesNo(OemToAnsi(STR0021) + Alltrim(oBmp:EntryName(oList:nAt)) + OemToAnsi(STR0022),OemToAnsi(STR0023))   //   'Deseja realmente apagar o Bitmap'##'do repositório de imagens?'##"Atenção"
		oBmp:DeleteBmp(oBmp:EntryName(oList:nAt))
		If !RepositInBD()
			oDel:Disable()
		Else
			LoadRepBD()
		EndIf
		cBitMap := oemtoansi(STR0015)
		If !lImport
			MsgRun(OemtoAnsi(STR0024),"",{|| CursorWait(), oBmp:Pack(),CursorArrow()})   //   "Atualizando o repositório de objetos. aguarde..."
		EndIf
		oList:Refresh()
		ChgList( oBmp, oList, cBitmap, oDel, oExt )
	Endif

	Return Nil

	//--------------------------------------------------------------------------------------
Static Function ChgList( oBmp, oList, cBitmap, oDel, oExt )
	Local cEntry := ""

	cEntry := oBmp:EntryName(oList:nAt)
	If Empty(cEntry) .Or. cEntry == oemtoansi(STR0015)
		oDel:Disable()
		oExt:Disable()
	Else
		oDel:Enable()
		oExt:Enable()
	Endif
	If cEntry <> cBitmap
		oBmp:LoadBmp(cEntry)
		cBitMap := cEntry
	Endif

	Return Nil

Static Function InsertREP(oList,oBmp,cTargetDir)
	Local cMask
	Local aBmps
	Local aJpgs
	Local aSourceImg
	Local oOk
	Local oNo
	Local oDlg
	Local oListImg
	Local oPreview
	Local oAlias
	Local aDelete := {}
	Local nI
	Local cSearch := Space(50)
	Local oSearch
	Local oBSearch
	Local oStretch
	Local nStretch
	Local oPanelLeft
	Local oPanelRight
	Local oScroll
	Local aType
	Local oType
	Local cType
	Local lAll
	Local oAll
	Local lOk := .F.
	Local aButtons := {}
	Local cAlias := Space(3)
	Local lRet := .T.

	Aadd(aButtons, { "OPEN_MDI" , { || AltDir(@oListImg, @cTargetDir, @oType, @aSourceImg, @aBmps, @aJpgs, lAll)}, STR0040, STR0040})   //"troca diretório"

	cMask 	:= ""
	cTargetDir := cGetFile(,STR0029,,cTargetDir,.T.,GETF_LOCALFLOPPY+GETF_LOCALHARD+128) //"Selecione o diretório contendo os arquivos de imagem"

	If Empty(cTargetDir)
		Return
	EndIf

	aBmps := Directory(cTargetDir+"*.bmp")
	aJpgs := Directory(cTargetDir+"*.jpg")

	aSourceImg := {}
	Aeval(aBmps,{|x| If( x[2] <= MAX_BMP_SIZE,Aadd(aSourceImg,{.F.,x[1]}), ) })
	Aeval(aJpgs,{|x| If( x[2] <= MAX_BMP_SIZE,Aadd(aSourceImg,{.F.,x[1]}), ) })
	Asort(aSourceImg,,,{|x,y| x[2]<y[2]})

	If Empty(aSourceImg)
		MsgStop(STR0030 + cTargetDir, STR0031) //"Não há imagens no caminho " ### "Atenção"
		Return
	EndIf

	MakeDir("\imgreposittmp")
	__CopyFile(cTargetDir+aSourceImg[1][2], "\imgreposittmp\"+aSourceImg[1][2])
	Aadd( aDelete, "\imgreposittmp\"+aSourceImg[1][2])

	oOk := LoadBitmap( GetResources(), "LBTIK" )
	oNo := LoadBitmap( GetResources(), "LBNO" )

	DEFINE MSDIALOG oDlg TITLE STR0032 FROM 000,000 TO 530,796 PIXEL //"Seleção de imagens"

	@ 000,000 MSPANEL oPanelLeft OF oDlg SIZE 150,200
	@ 000,000 MSPANEL oPanelRight OF oDlg SIZE 010,010

	oPanelLeft:Align := CONTROL_ALIGN_LEFT
	oPanelRight:Align := CONTROL_ALIGN_ALLCLIENT

	aType := {STR0033+" (*.bmp,*.jpg)", "Bitmap (*.bmp)", "JPEG (*.jpg)"} //"Todas as imagens"

	@ 003,005 COMBOBOX oType VAR cType ITEMS aType SIZE 142,011 OF oPanelLeft PIXEL
	oType:bChange := {|| lRet := ResetList(oListImg,@aSourceImg,@aBmps,@aJpgs,cTargetDir,oType:nAt,oListImg:bLine,lAll), Eval(oListImg:bChange), Iif(!lRet,(oType:nAt:= 1, oType:Refresh()),) }

	@ 018, 005 LISTBOX oListImg FIELDS HEADER "",STR0034 SIZE 140,170 OF oPanelLeft PIXEL //"Imagem"
	oListImg:SetArray(aSourceImg)
	oListImg:bLine := {|| {If(aSourceImg[oListImg:nAt][1],oOk,oNo),cTargetDir+aSourceImg[oListImg:nAt][2]}}
	oListImg:bLDblClick := {|| aSourceImg[oListImg:nAt][1] := !aSourceImg[oListImg:nAt][1],oListImg:DrawSelect()}
	oListImg:bChange := {|| __CopyFile(cTargetDir+aSourceImg[oListImg:nAt][2], "\imgreposittmp\"+aSourceImg[oListImg:nAt][2]),;
		Aadd( aDelete, "\imgreposittmp\"+aSourceImg[oListImg:nAt][2]),;
		oPreview:Load(,"\imgreposittmp\"+aSourceImg[oListImg:nAt][2])}

	lAll := .F.
	@ 190, 005 CHECKBOX oAll VAR lAll PROMPT STR0035 OF oPanelLeft SIZE 080, 010 PIXEL //"Marcar todos"
	oAll:bChange := {|| Aeval(aSourceImg,{|x| x[1]:=lAll}), oListImg:Refresh()}

	If RepositInBD()
		@192,072 SAY "Tabela Vinculada" PIXEL OF oPanelLeft
		@190,115 MSGET oAlias VAR cAlias OF oPanelLeft SIZE 030, 010 PICTURE "@!" VALID ValidSx2(cAlias) PIXEL F3 "SX2PAD"
	EndIf

	@ 000,000 SCROLLBOX oScroll SIZE 010,010 PIXEL OF oPanelRight
	oScroll:Align := CONTROL_ALIGN_ALLCLIENT

	@ 018, 150 BITMAP oPreview DISK cTargetDir+aSourceImg[1][2] SIZE 800,500 OF oScroll PIXEL
	oPreview:Align := CONTROL_ALIGN_ALLCLIENT
	oPreview:lAutoSize := .T.

	@ 202, 005 TO 223,143 PROMPT STR0036 OF oPanelLeft PIXEL //"Buscar"

	@ 208, 008 GET oSearch VAR cSearch OF oPanelLeft SIZE 115, 010 PIXEL

	@ 208, 124 BUTTON oBSearch PROMPT "Ok" SIZE 016, 011 PIXEL OF oPanelLeft
	oBSearch:bAction := {|nPos| nPos:=Ascan(aSourceImg,{|x| Upper(Trim(cSearch)) $ Upper(x[2])}),;
		If(nPos>0,(oListImg:nAt:=nPos,Eval(oListImg:bChange),oListImg:Refresh(),cSearch:=Space(50),oSearch:Refresh()),)}

		nStretch := 2
		@ 226, 005 TO 251,143 PROMPT STR0016 OF oPanelLeft PIXEL //"Visualizção"

		@ 232, 008 RADIO oStretch VAR nStretch ITEMS STR0017,STR0018 SIZE 70,10 PIXEL OF oPanelLeft;   //"Ajustado"##"Normal"
		ON CHANGE ChangeStr(oPreview,nStretch,.F.)

		ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg,{|| lOk:=.T., oDlg:End()},{|| oDlg:End()}, , aButtons)


		aDelete := Directory("\imgreposittmp\*.bmp")
		For nI:=1 To Len(aDelete)
			Ferase("\imgreposittmp\"+aDelete[nI][1])
		Next nI

		aDelete := Directory("\imgreposittmp\*.jpg")
		For nI:=1 To Len(aDelete)
			Ferase("\imgreposittmp\"+aDelete[nI][1])
		Next nI

		If ( lOk )
			For nI:=1 To Len(aSourceImg)
				If ( aSourceImg[nI][1] )
					If ( ValidRPO(aSourceImg[nI][2]) )
						xInsertREP(oList,oBmp,cTargetDir,cTargetDir+aSourceImg[nI][2],cAlias)
					EndIf
				EndIf
			Next nI
			If RepositInBD()
				LoadRepBD()
				oList:Refresh()
			EndIf
		EndIf
		Return

		//--------------------------------------------------------------------------------------
	Static Function xInsertREP(oList,oBmp,cDirAtu,cFile,cAliasBMP)
		Local lIncluiu := .T.
		Local lRet 		:= .T.
		Local cDrive   := Space(255)
		Local cDir     := Space(255)
		Default cAliasBMP    := ""

		SplitPath( cFile, @cDrive, @cDir ) // Quebrada o path em partes (Diretório, drive, etc)
		cDirAtu := Alltrim(cDrive)+Alltrim(cDir)
		if IsFileServer( cDirAtu ) // Se for no servidor soma a string servidor
			cDirAtu := OemtoAnsi(STR0025)+cDirAtu   //   "SERVIDOR"
		endif

		cFile := oBmp:InsertBmp(cFile,,@lIncluiu,cAliasBMP)

		If !Empty(cFile)
			oBmp:LoadBmp(cFile)
			oBmp:Refresh()
			If !RepositInBD()
				IF lIncluiu
					oList:Cargo++
				Endif
				oList:nAt := oBmp:PosByName(cFile)
				oList:Refresh()
				oList:SetFocus()
			EndIf
		EndIf

		Return lRet

		//--------------------------------------------------------------------------------------
	Static Function ExtractREP(oList,oBmp)
		Local cMask 	:= OemToAnsi(STR0009)+"(*.*) |*.*|"  //"Todos os arquivos"
		Local cFile		:= ""
		Local cEntry 	:= ""
		Local lRet 		:= .T.

		cFile := cGetFile(cMask,OemToAnsi(STR0011),0,"",.F.,)  // "Salvar Como..."

		if Empty(cFile)
			lRet := .F.
		else
			cEntry := oBmp:EntryName(oList:nAt)
			if cEntry <> oemtoansi(STR0015)
				cFile := oBmp:Extract(cEntry,cFile)
			endif
		endif

		Return lRet

		//--------------------------------------------------------------------------------------
	Static Function ChangeStr(oBmp,nStretch,lAlign)
		Default lAlign := .T.
		oBmp:lStretch := nStretch == AJUSTADO

		if oBmp:lStretch
			If lAlign
				oBmp:Align := 5
			EndIf
			oBmp:lAutoSize := .F.
		Else
			If lAlign
				oBmp:Align := 0
			EndIf
			oBmp:lAutoSize := .T.
		Endif

		Return Nil

		//--------------------------------------------------------------------------------------
	Static Function InitList( oList, oBmp )

		oList:Cargo     := oBmp
		If RepositInBD()
			LoadRepBD()
			oList:bLine     := { || { PROTHEUS_REPOSIT->BMPNAME, PROTHEUS_REPOSIT->ALIAS   } }
			oList:bLogicLen := { || oBmp:RecordCount() }
			oList:bGoTop    := { || oList:nAt := 1 }
			oList:bGoBottom := { || oList:nAt := oBmp:RecordCount() }
			oList:bSkip     := { | nSkip | RepBDSkipper(nSkip) }
		Else
			oList:cAlias    := "ARRAY"
			oList:bLine     := { || { oBmp:EntryName(oList:nAt) } }
			oList:bLogicLen := { || oBmp:RecordCount() }
			oList:bGoTop    := { || oList:nAt := 1 }
			oList:bGoBottom := { || oList:nAt := oBmp:RecordCount()  }
			oList:bSkip     := { | nSkip, nOld | nOld := oList:nAt, oList:nAt += nSkip,;
				oList:nAt := Min( Max( oList:nAt, 1 ), oList:Cargo:RecordCount() ),;
				oList:nAt - nOld }
		EndIf

		Return Nil

		//--------------------------------------------------------------------------------------

	Static Function ResetList(oListImg,aSourceImg,aBmps,aJpgs,cTargetDir,nType,bLine,lAll)
		If ( nType == 2 .And. Empty(aBmps) )
			MsgInfo(STR0053,STR0023) // "Não existem imagens no diretóprio para o tipo selecionado"
			Return .F.
		ElseIf ( nType == 3 .And. Empty(aJpgs) )
			MsgInfo(STR0053,STR0023) // "Não existem imagens no diretóprio para o tipo selecionado"
			Return .F.
		EndIf

		aSourceImg := {}
		If ( nType == 1 )
			Aeval(aBmps,{|x| If( x[2] <= MAX_BMP_SIZE,Aadd(aSourceImg,{.F.,x[1]}), ) })
			Aeval(aJpgs,{|x| If( x[2] <= MAX_BMP_SIZE,Aadd(aSourceImg,{.F.,x[1]}), ) })
		ElseIf ( nType == 2 )
			Aeval(aBmps,{|x| If( x[2] <= MAX_BMP_SIZE,Aadd(aSourceImg,{.F.,x[1]}), ) })
		ElseIf ( nType == 3 )
			Aeval(aJpgs,{|x| If( x[2] <= MAX_BMP_SIZE,Aadd(aSourceImg,{.F.,x[1]}), ) })
		EndIf
		Asort(aSourceImg,,,{|x,y| x[2]<y[2]})

		oListImg:SetArray(aSourceImg)
		oListImg:bLine := bLine
		oListImg:nAt := 1
		oListImg:Refresh()
		Return .T.

	Function PesqImg(oList,oBmp)
		Local aParam	:= {}
		Local cTexto := ""

		If ParamBox( { { 1,STR0037 ,SPACE(200),"@" 	 ,""  ,""    ,"" ,120 ,.F. },;
				{5,STR0038,.F.,90,,.F.},;
				{5,STR0039,.F.,90,,.F.} }, STR0037, aParam )

			If RepositInBD()
				dbSelectArea("PROTHEUS_REPOSIT")
			Else
				dbSelectArea("REPOSIT")
			EndIf
			If aParam[2]
				If aParam[3]
					dbSkip()
					LOCATE REST FOR ( AllTrim(aParam[1])== AllTrim(BMPNAME))
				Else
					LOCATE FOR ( AllTrim(aParam[1])== AllTrim(BMPNAME))
				EndIf
			Else
				If aParam[3]
					dbSkip()
					LOCATE REST FOR ( UPPER(AllTrim(aParam[1]))$UPPER(AllTrim(BMPNAME)))
				Else
					LOCATE FOR ( UPPER(AllTrim(aParam[1]))$UPPER(AllTrim(BMPNAME)))
				EndIf
			EndIf
			If RepositInBD()
				oList:nAt := RetPosBrw(PROTHEUS_REPOSIT->(Recno()))
			Else
				oList:nAt := oBmp:PosByName(REPOSIT->(BMPNAME))
			EndIf
			oList:Refresh()
			Eval(oList:bChange)
		EndIf

		Return

	Static Function AltDir(oListImg, cTargetDir, oType, aSourceImg, aBmps, aJpgs, lAll)
		Local oOk
		Local oNo

		oOk := LoadBitmap( GetResources(), "LBTIK" )
		oNo := LoadBitmap( GetResources(), "LBNO" )

		cTargetDir := cGetFile(,STR0029,,cTargetDir,.T.,GETF_LOCALFLOPPY+GETF_LOCALHARD+128) //"Selecione o diretório contendo os arquivos de imagem"

		If Empty(cTargetDir)
			Return
		EndIf

		aBmps := Directory(cTargetDir+"*.bmp")
		aJpgs := Directory(cTargetDir+"*.jpg")

		aSourceImg := {}
		Aeval(aBmps,{|x| If( x[2] <= MAX_BMP_SIZE,Aadd(aSourceImg,{.F.,x[1]}), ) })
		Aeval(aJpgs,{|x| If( x[2] <= MAX_BMP_SIZE,Aadd(aSourceImg,{.F.,x[1]}), ) })
		Asort(aSourceImg,,,{|x,y| x[2]<y[2]})

		If Empty(aSourceImg)
			oListImg:SetArray(aSourceImg)
			MsgStop(STR0030 + cTargetDir, STR0031) //"Não há imagens no caminho " ### "Atenção"
			Return
		EndIf

		oListImg:SetArray(aSourceImg)
		oListImg:bLine := {|| {If(aSourceImg[oListImg:nAt][1],oOk,oNo),cTargetDir+aSourceImg[oListImg:nAt][2]}}
		oListImg:Refresh()


		ResetList(oListImg,aSourceImg,aBmps,aJpgs,cTargetDir,oType:nAt,oListImg:bLine,lAll)
		Eval(oListImg:bChange)

		//oType:nAt := 1
		Return

		//--------------------------------------------------------------------------------------
	Function LoadRepBD(cAlias,cResName)
		Local nPos      := 0
		Local cBmpName  := ""
		Local cFilter   := ".T."
		Local cQuery    := ""
		Local cSQL		:= ""
		Local cTRB		:= GetNextAlias()
		Local aFiltra := {}

		Static lRepFil := ExistBlock("REPFIL")

		Default cAlias  := ""

		// Verifica se a tabela está aberta, se não estiver, força a abertura
		If SELECT("PROTHEUS_REPOSIT") == 0
			OpenRepositDB()
		EndIf

		__aRecnoReposit := {}

		If !Empty(cAlias)
			cFilter := "( PROTHEUS_REPOSIT->ALIAS == '   ' .Or. PROTHEUS_REPOSIT->ALIAS == '"+cAlias+"' )"
			cSQL    := " AND ( ALIAS = '   ' OR ALIAS = '"+cAlias+"' )"
		EndIf

		If !Empty(cResName)
			cFilter += " .And. PROTHEUS_REPOSIT->BMPNAME == '"+cResName+"'"
			cSQL    += " AND BMPNAME = '"+cResName+"'"
		EndIf

		// Por Modulo ou Especifico parao GPE
		If ( SuperGetMV("MV_REPOSIT", .F., "1") == "2" ) .Or. ( SuperGetMV("MV_REPOSIT", .F., "1") == "3" .And. cModulo == "GPE" )
			cFilter += " .And. Trim(PROTHEUS_REPOSIT->MODULO) == '"+cModulo+"'"
			cSQL    += " AND RTrim(MODULO) = '"+cModulo+"'"
		EndIf

		If lRepFil
			aFiltra := ExecBlock("REPFIL",.f.,.f.,{cModulo,cAlias})
			If ValType(aFiltra) == "A"
				cFilter += " .And. " + aFiltra[1]
				cSQL    += " AND " + aFiltra[2]
			End
		End

		If __cRdd == "TOPCONN"
			//para melhora de performance
			cQuery := "SELECT BMPNAME,ALIAS, MIN(R_E_C_N_O_) R_E_C_N_O_ FROM PROTHEUS_REPOSIT "
			cQuery += " WHERE D_E_L_E_T_ = ' ' "
			If !Empty(cSQL)
				cQuery += cSQL
			EndIf
			cQuery += " GROUP BY BMPNAME, ALIAS "
			cQuery := ChangeQuery(cQuery)
			dbUseArea( .t., "TopConn", TCGenQry(,,cQuery),cTRB, .F., .F. )
			(cTRB)->(DbGoTop())
			While (cTRB)->(!Eof())
				aAdd(__aRecnoReposit,{(cTRB)->(R_E_C_N_O_),AllTrim((cTRB)->BMPNAME),AllTrim((cTRB)->ALIAS)})
				(cTRB)->(DbSkip())
			EndDo
			(cTRB)->(DBCloseArea())

		Else

			PROTHEUS_REPOSIT->(DbGoTop())
			While PROTHEUS_REPOSIT->(!Eof())
				If PROTHEUS_REPOSIT->BMPNAME+PROTHEUS_REPOSIT->ALIAS <> cBmpName+cAlias .And. PROTHEUS_REPOSIT->( &(cFilter) )
					If Ascan(__aRecnoReposit,{|x| x[2] == AllTrim(PROTHEUS_REPOSIT->BMPNAME) .And. x[3] == AllTrim(PROTHEUS_REPOSIT->ALIAS) }) == 0
						aAdd(__aRecnoReposit,{PROTHEUS_REPOSIT->(Recno()),AllTrim(PROTHEUS_REPOSIT->BMPNAME),AllTrim(PROTHEUS_REPOSIT->ALIAS)})
					EndIf
					cBmpName := PROTHEUS_REPOSIT->BMPNAME
					cAlias   := PROTHEUS_REPOSIT->ALIAS
				EndIf
				PROTHEUS_REPOSIT->(DbSkip())
			EndDo

		endif
		If !Empty(__aRecnoReposit)
			PROTHEUS_REPOSIT->(dbGoTo(__aRecnoReposit[1][1]))
		EndIf

		Return

		// --------------------------------------------------------------------------------------------

	Function RepBDSkipper(nSkip)
		Local nPos     := 0
		Local nOldSkip := nSkip

		DbSelectArea("PROTHEUS_REPOSIT")
		DbSetOrder(1)

		If Empty(__aRecnoReposit)
			DbGoBottom()
			DbSkip()
		Else
			nPos := Ascan(__aRecnoReposit,{|x| x[2] == AllTrim(PROTHEUS_REPOSIT->BMPNAME) .And. x[3] == AllTrim(PROTHEUS_REPOSIT->ALIAS) })

			If nPos + nSkip < 1
				nSkip := (nPos - 1) * (-1)
			ElseIf nPos + nSkip > Len(__aRecnoReposit)
				nSkip := Len(__aRecnoReposit) - nPos
			EndIf

			If nSkip <> 0
				DbGoTo(__aRecnoReposit[nPos + nSkip][1])
			EndIf
		EndIf

		Return nSkip

		// --------------------------------------------------------------------------------------------
	Function RetPosBrw(nRecno,cEntry,nEntry)
		Local nRet     := 0
		Default nRecno := 0
		Default cEntry := ""
		Default nEntry := 0

		If nRecno > 0
			nRet := Ascan( __aRecnoReposit, { |x| x[1] == nRecno } )
		ElseIf !Empty(cEntry)
			//-- Carrega os recno existente para a imagem
			If Empty(__aRecnoReposit)
				LoadRepBD(,cEntry)
			EndIf
			nRet   := Ascan( __aRecnoReposit, { |x| Trim(x[2]) == Trim(cEntry) } )
			If nRet > 0
				PROTHEUS_REPOSIT->(DbGoto(__aRecnoReposit[nRet,1]))
			EndIf
		ElseIf nEntry > 0
			If nEntry <= Len( __aRecnoReposit)
				PROTHEUS_REPOSIT->(DbGoto(__aRecnoReposit[nEntry,1]))
				nRet := nEntry
			EndIf
		EndIf

		If nRet == 0
			nRet := 1
		EndIf

		Return nRet

		// --------------------------------------------------------------------------------------------
	Function RecCountDB()
		Return Len(__aRecnoReposit)

		//--------------------------------------------------------------------------------------------

	Static Function ValidRPO( cResource )

		Local cEntry
		Local aImgInfo := {}
		Local aImgExt  := {".PNG",".JPG",".BMP",".GIF"}
		Local lRet      := .T.
		Local nX

		If ( "\" $ cResource )
			cEntry := Substr(cResource,RAT("\",cResource)+1)
			cEntry := Substr(cResource,1,AT(".",cResource)-1)
		else
			cEntry := Substr(cResource,1,AT(".",cResource)-1)
		endif

		For nX := 1 to len(aImgExt)
			aImgInfo := getApoInfo( cEntry + aImgExt[nX] )
			If ( !Empty(aImgInfo) )
				lRet := .F.
				MsgInfo(STR0051 + cEntry + STR0052,STR0023)
				Exit
			EndIf
		Next nX

		Return lRet

		//----------------------------------------------------------------------------------
	Function ImportInBD(oBMP)
		Local bLine
		Local oList
		Local oAll
		Local oOk        := LoadBitmap( GetResources(), "LBTIK" )
		Local oNo        := LoadBitmap( GetResources(), "LBNO" )
		Local nI         := 0
		Local nSeq       := 0
		Local nHdl       := 0
		Local nBytes     := 0
		Local nRead      := 0
		Local cName      := ""
		Local cFile      := ""
		Local cIndex     := ""
		Local cBuffer    := ""
		Local cAuxBuffer := ""
		Local cMod       := ""
		Local cResource  := ""
		Local cAliasBMP  := ""
		Local aFiles     := {}
		Local aTemp      := Directory("*.BMD")
		Local lAppend    := .T.
		Local lAll       := .F.
		Local lOk        := .F.
		Local lRepByModulo := .F.
		Local nHdlImp	:= 0
		Local nHdlTmp	:= 0
		Local nSize		:= 0
		Local cDrive	:= ""
		Local cDir		:= ""
		Local cFName 	:= ""
		Local cNewFile  := ""
		Local nImgType  := 0

		// Por Modulo ou Especifico parao GPE
		If ( SuperGetMV("MV_REPOSIT", .F., "1") == "2" ) .Or. ( SuperGetMV("MV_REPOSIT", .F., "1") == "3" .And. cModulo == "GPE" )
			lRepByModulo := .T.
		EndIf

		For nI := 1 To Len(aTemp)
			If lRepByModulo .And. !RepositInBD()
				If Subs(aTemp[nI,1], 1, len(cModulo)) <> cModulo
					Aadd( aFiles, { .F., aTemp[nI,1] } )
				EndIf
			Else
				Aadd( aFiles, { .F., aTemp[nI,1] } )
			Endif
		Next nI

		DEFINE MSDIALOG oDlg TITLE STR0047 FROM 0,0 TO 299,496 PIXEL // "Importar - Repositório de Imagens"

		@16,02 TO 138,248 PROMPT STR0048 PIXEL OF oDlg // "Selecione o Repositório"

		@23,10 LISTBOX oList FIELDS HEADER "",STR0049 FIELDSIZES 14,100 SIZE 226,112 PIXEL OF oDlg // "Arquivo"

		If !Empty(aFiles)
			bLine := {|| {if(aFiles[oList:nAt,1],oOk,oNo),aFiles[oList:nAt,2]} }
			oList:SetArray(aFiles)
			oList:bLine := bLine
			oList:bLDblClick := { || aFiles[oList:nAt,1]:= !aFiles[oList:nAt,1] }

			@138,05 CHECKBOX oAll VAR lAll PROMPT STR0050 PIXEL SIZE 90,09; // "Marca Todos"
			ON CLICK ( aEval(aFiles, { |x| x[1] := lAll }), oList:Refresh() ) OF oDlg
		EndIf

		ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg,{|| lOk := .T. , oDlg:End() },{|| oDlg:End()})

		If lOk
			For nI := 1 To Len(aFiles)
				If aFiles[nI,1]
					cName  := SubStr(aFiles[nI,2],1,RAt(".",aFiles[nI,2])-1)
					cFile  := cName+".BMD"
					cIndex := cName+".BMI"

					cMod := SubStr(cName,1,3)
					If cMod == "SIG"
						cMod := " "
					EndIf

					If Empty(cMod)
						cMod := cModulo
					EndIf

					If File(cName+".BMR")
						If (nHdlImp:= FOpen(cName+".BMR",FO_READWRITE + FO_SHARED)) > 0

							USE &cFile ALIAS REPOSIT1 SHARED NEW VIA __LocalDriver
							If !File(cName+".BMI")
								INDEX ON REPOSIT1->BMPNAME TAG "IDX1" TO &cIndex
							Else
								SET INDEX TO &cIndex
							EndIf
							//-- Realiza a importacao
							REPOSIT1->( DbGoTop() )
							While REPOSIT1->(!Eof())
								If REPOSIT1->BMPDEL <> "û"
									lAppend := .T.
									If RepositInBD()
										//-- Verifica se o registro já eciste no banco
										If PROTHEUS_REPOSIT->(dbSeek(REPOSIT1->BMPNAME))
											cResource := PROTHEUS_REPOSIT->BMPNAME
											cAliasBMP := PROTHEUS_REPOSIT->ALIAS
											While PROTHEUS_REPOSIT->(!Eof()) .And. PROTHEUS_REPOSIT->BMPNAME+PROTHEUS_REPOSIT->ALIAS == cResource+cAliasBMP
												If Trim(PROTHEUS_REPOSIT->MODULO) == Trim(cMod)
													If !MsgYesNo(OemToAnsi(STR0045+PROTHEUS_REPOSIT->BMPNAME+STR0046),OemToAnsi(STR0031)) // "Entrada " ### " j  existe, Regrava?" ### "Aten‡Æo"
														lAppend := .F.
													EndIf
													Exit
												EndIf
												PROTHEUS_REPOSIT->(DbSkip())
											EndDo
											If lAppend
												While PROTHEUS_REPOSIT->(!Eof()) .And. PROTHEUS_REPOSIT->BMPNAME+PROTHEUS_REPOSIT->ALIAS == cResource+cAliasBMP
													If Trim(PROTHEUS_REPOSIT->MODULO) <> Trim(cMod)
														PROTHEUS_REPOSIT->(DbSkip())
														Loop
													EndIf
													RecLock("PROTHEUS_REPOSIT",.F.)
													PROTHEUS_REPOSIT->(DbDelete())
													MsUnlock()
													PROTHEUS_REPOSIT->(DbSkip())
												EndDo
											Else
												REPOSIT1->(DbSkip())
												Loop
											EndIf
										EndIf
									Else
										REPOSIT->(dbSeek(REPOSIT1->BMPNAME))
										While REPOSIT1->BMPNAME == REPOSIT->BMPNAME .and. REPOSIT->BMPDEL == "û"
											dbSkip()
										Enddo
										If REPOSIT->BMPNAME == REPOSIT1->BMPNAME .and. !(REPOSIT->(Eof()))
											If MsgYesNo(OemToAnsi("Entrada "+REPOSIT1->BMPNAME+" já existe, Regrava?"),OemToAnsi("Atenção")) // "Entrada " ### " j  existe, Regrava?" ### "Aten‡Æo"
												FSeek(oBMP:nHdl,REPOSIT->BMPPOS+RepNewPos(oBMP:nHdl),FS_SET)
												fWrite(oBMP:nHdl,Space(NAMESIZE),NAMESIZE)
												RecLock("REPOSIT",.F.)
												REPOSIT->(DbDelete())
												MsUnlock()
												oBMP:nDeleted++
											Else
												REPOSIT1->(DbSkip())
												Loop
											Endif
										Endif
									EndIf

									nBytes := 0
									If RepositInBD()
										//-- Efetua a inclusao no banco
										nSeq := 0
										cAuxBuffer := ""
										nSize := FSeek(nHdlImp,0,FS_END)
										FSeek(nHdlImp,REPOSIT1->BMPPOS+NAMESIZE+4+RepNewPos(nHdlImp),FS_SET)
										While nBytes < REPOSIT1->BMPSIZE
											nSeq++
											nRead := if(REPOSIT1->BMPSIZE-nBytes>65000,65000,REPOSIT1->BMPSIZE-nBytes)
											cBuffer := Space(nRead)
											FRead(nHdlImp,@cBuffer,nRead)
											nBytes += nRead
											cAuxBuffer += cBuffer
											//-- Atualiza Banco de Dados
											DbSelectArea("PROTHEUS_REPOSIT")
											RecLock("PROTHEUS_REPOSIT",.T.)
											PROTHEUS_REPOSIT->BMPNAME := REPOSIT1->BMPNAME
											PROTHEUS_REPOSIT->ALIAS   := " "
											PROTHEUS_REPOSIT->SEQ     := StrZero(nSeq,2)
											PROTHEUS_REPOSIT->MEMO    := cBuffer
											PROTHEUS_REPOSIT->MODULO  := cMod
											MsUnlock()
										EndDo
									Else
										//extrai a imagem para o diretório temporário.
										cFile := "\imgreposittmp\"+Trim(REPOSIT1->BMPNAME)

										if (nHdlTmp := FCreate(cFile,FC_NORMAL)) < 0
											MsgStop("Erro criando arquivo: "+cFile,OemToAnsi("Atenção")) // "Erro criando arquivo: " ### "Aten‡Æo"
											lRet := .f.
										else
											FSeek(nHdlImp,REPOSIT1->BMPPOS+NAMESIZE+4+RepNewPos(nHdlImp),FS_SET)
											While nBytes < REPOSIT1->BMPSIZE
												nRead := if(REPOSIT1->BMPSIZE-nBytes > 4096,4096,REPOSIT1->BMPSIZE-nBytes)
												cBuffer := Space(nRead)
												FRead(nHdlImp,@cBuffer,nRead)
												FWrite(nHdlTmp,cBuffer,nRead)
												nBytes += nRead
											end
											FClose(nHdlTmp)
										endif

										SplitPath( cFile, @cDrive, @cDir, @cFName )
										cNewFile := AllTrim(cDrive+cDir+cFName)

										nImgType := RetImgType( cFile )  // Verifica em C++ qual é o tipo do arquivo
										if nImgType == 1
											cNewFile += ".bmp"
											FRename( cFile, cNewFile )
										elseif nImgType == 2
											cNewFile += ".jpg"
											FRename( cFile, cNewFile )
										endIf

										nHdlTmp := FOpen(cNewFile,FO_READ)
										//inclui a imagem no novo repositorio
										nSize := FSeek(nHdlTmp,0,FS_END)
										If ( nSize > MAX_BMP_SIZE ) // Tamanho máximo atingido
											MsgInfo(STR0011,STR0002) // "Não é possível incluir um bitmap maior que 900 Kilobytes. Por favor escolha um de menor tamanho." ### "Atenci¢n"
										Else
											FSeek(nHdlTmp, 0, FS_SET)
											cBuffer := Space(65000)
											nPos  := FSeek(oBMP:nHdl,0,FS_END)
											lIncluiu := .t.
											dbSelectArea("REPOSIT")
											Append Blank
											Replace BMPNAME with REPOSIT1->BMPNAME
											Replace BMPPOS  with nPos
											Replace BMPSIZE with nSize

											fWrite(oBMP:nHdl,REPOSIT1->BMPNAME,NAMESIZE)
											fWrite(oBMP:nHdl,L2Bin(nSize),4);

											While nRead != 0
												nRead = FRead(nHdlTmp, @cBuffer, 4096)
												fWrite(oBMP:nHdl,cBuffer, nRead)
											Enddo
										Endif
										FClose(nHdlTmp)

										FErase(cNewFile)
									EndIf
								EndIf
								REPOSIT1->(DbSkip())
							EndDo
							FClose(nHdlImp)
							REPOSIT1->(DbCloseArea())
						EndIf
					EndIf
				EndIf
			Next nI
		EndIf

		Return

	Static Function RepNewPos(nHdl)
		Local nRet := 0
		Local cBuffer := Space(4)
		Local cAlias	:= ""

		If RepositInBD()
			cAlias := "REPOSIT1"
		Else
			cAlias := "REPOSIT"
		EndIf

		If nHdl > 0 .And. (cAlias)->BMPPOS == 0
			FSeek(nHdl,0,FS_SET)
			FRead(nHdl,@cBuffer,4)
			If cBuffer == "#20#"
				nRet := 4
			EndIf
		EndIf
		//TESTE RPO PDV.

		Return nRet
