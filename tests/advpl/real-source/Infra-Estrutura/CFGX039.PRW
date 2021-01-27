#include "Fivewin.ch"
#include "cfgx039.ch"

Function CFGX039()
	Local cMsg
	cMsg := OemToAnsi(STR0001)+chr(13) // "Este programa ir  gerar os arquivos de configura‡„o do Forprint"
	cMsg += OemToAnsi(STR0002)+chr(13) //"com todos os campos definidos no dicion rio de dados Microsiga"
	cMsg += OemToAnsi(STR0003)+chr(13)+chr(13) // "e suas respectivas liga‡”es."
	cMsg += OemToAnsi(STR0004) // "Efetiva o procedimento de gera‡„o dos arquivos Forprint (.FPW)?"
	IF MsgYesNO(OemToAnsi(cMsg),OemToAnsi(STR0005) )  // "Quanto ao Procedimento ? "
		If Forprint()
			Processa ({|| CriaFpw()},OemToAnsi(STR0006),OemToAnsi(STR0007))  // "Criando Arquivos Fpw" ### "Aguarde"
			Processa ({|| IncLigFpw()},OemToAnsi(STR0008),OemToAnsi(STR0007))  // "Criando Liga‡”es entre arquivos"  ### "Aguarde"
		Else
			Help(" ",1,"NOFORPRINT")
		Endif
	Endif
	Return
	/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Fun‡…o    ³ CriaFpw  ³ Autor ³ Cristiane Maeda       ³ Data ³          ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡…o ³ Cria Fpws com a Estrutura definida no Sx3                  ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Parametros³ Alias do Arquivo a Ser Criado                              ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³ Uso      ³ Forprint       ³                    ³                      ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	/*/

Function CriaFpw(cFpw)
	Local nArq,cOldFil,cCampo := "",lpExpr := "",hdll,lAllArq := .F.
	Local cAlias := "",hwconect := 0,aTipo := {"C","N","D","J","H","T","L","R","I"}
	Local cArqFpw,cArqDbf
	Local cEmptyFil := "  "

	ProcRegua(SX2->(RecCount()),17,4)

	lAllArq := IIf(cFpw==Nil .or. Empty(cFpw),.T.,.F.)

	*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	*³ Carrega a Dll para utilizar fun‡oes do Forprint              ³
	*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	hDLL := LoadLibrary(GetMv("MV_FORPRINT")+"FWEXTFPW.DLL")
	dbSelectarea("SX2")
	cOldFil := dbFilter()
	dbClearFil()
	dbgotop()
	If !lAllArq // Somente um aArquivo
		DbSeek(cFpw)
	Endif

	//-- Atualiza o conteúdo da filial
	If FindFunction("FWSizeFilial")
		cEmptyFil := Space(FWSizeFilial())
	EndIf

	While !Sx2->(eof())
		HwConect := FPW_CREATE(hDll,oMainWnd:hWnd)//,GetWndDefault():hWnd)
		cArqFpw := GETMV("MV_FORPRIN")
		cArqFpw  += AllTrim(SX2->X2_ARQUIVO)+".FPW"
		IncProc(AllTrim(Sx2->x2_arquivo))
		*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		*³ Cria um  FPW Vazio  ³
		*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		lOk := FPW_NEWFPW(hDll,HwConect,cArqFpw)
		MsgErrFpw(lOk,"CREATENEW")
		cArqDbf := Alltrim(SX2->X2_PATH)+Alltrim(SX2->X2_ARQUIVO)+GetDBExtension()
		cAlias := SX2->X2_CHAVE
		*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		*³ Informa Atributos da Tabela (Nome e Path do arquivo ³
		*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		lOk := FPW_SETTABLE(hDll,HwConect,cArqDbf,18) // 18 Indica funcoes Clipper
		MsgErrFpw(lOk,"SETTABLE")
		dbSelectArea("SX3")
		dbSetOrder(1)
		dbgotop()
		dbSeek(cAlias)
		*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		*³ Inclui campos no Fpw de acordo com estrutura do Sx3³
		*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cCampo := ""
		If Found()
			While (cAlias == x3_arquivo)
				If "_FILIAL" $ x3_campo
					cCampo := FpwTitulo(X3Titulo())
				Endif
				If (x3_context != "V") .and. (x3_tipo != "M")
					nTipo := ASCAN(aTipo,x3_tipo)-1
					cTitulo := FpwTitulo(X3Titulo())
					cCpo := AllTrim(x3_campo)
					lOk :=  FPW_FIELD_SETINFO(hDll,hwConect,cCpo,cTitulo,AllTrim(X3Descric()),nTipo,0,cTitulo,X3_TAMANHO)
				Endif
				SX3->(dbSkip())
			End
		Endif
		*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		*³ Monta filtro para Listar somente filial corrente   ³
		*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		IF !Empty(cCampo)
			lpExpr := '('+cCampo+'<> @TFILIAL E '+cCampo+'<> "'+cEmptyFil+'") E (@TFILIAL <> "'+cEmptyFil+'")'
			lOk :=  FPW_SETFILTER(Hdll,HwConect,cCampo,lpExpr)
			MsgErrFpw(lOk,"SETFILTER")
		Endif
		*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		*³ Salva arquivo Fpw                                  ³
		*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		lOk :=  FPW_SAVE(Hdll,hwConect)
		MsgErrFpw(lOk,"FPWSAVE")
		lOk :=  FPW_CLOSE(Hdll,hwConect)
		MsgErrFpw(lOk,"FPWCLOSE")
		lOk :=  FPW_DESTROY(Hdll,hwConect)
		MsgErrFpw(lOk,"FPWDESTROY")
		IF lAllArq
			SX2->(DBSKIP())
		Else
			Exit
		Endif
	Enddo

	dbselectarea("SX2")
	Set FIlter to &(cOldFil)
	FreeLibrary( hDLL )
	Return Nil

Static Function MsgErrFpw(lOK,cFuncao)
	If ValType(lOk) == "U"
		Final(STR0009)  // "Nao Foi Possivel Carregar FWEXTFPW.DLL"
	Endif
	If !lOk
		Help("",1,cfuncao)
		//Final("Erro na Funcao + cFuncao")
	Endif

	Return


Function RetSX2Arq(cArq,lPath)
	Local cAlias := Alias()
	Local nSx2Ord,nSx2Rec,cSx2Filter

	DbSelectarea("SX2")
	nSx2Ord := IndexOrd()
	nSx2Rec := Recno()
	cSx2Filter := DbFilter()
	dbSetOrder(1)
	Set Filter to
	dbGotop()

	DbSeek(cArq)
	If lPath
		cArq := Alltrim(x2_Path)+Alltrim(x2_arquivo)
	Else
		cArq := Alltrim(x2_arquivo)
	Endif

	dbSetOrder(nSx2Ord)
	Set Filter to &cSx2Filter
	DbGoto(nSx2Rec)

	DbSelectarea(cAlias)
	return cArq


Static Function IncLigFpw(cArq)
	Local lAllSx2,Hdll,HwConect,lOk
	Local cOldAlias := Alias(),nOrder := IndexOrd(),cFilter := DbFilter()
	Local lAllArq,cExpDom,cExpCDom,cDirForpw := GetMv("MV_FORPRIN")

	lAllArq:= If(cArq == Nil .or. Empty(carq),.T.,.F.)

	hDLL := LoadLibrary(GetMv("MV_FORPRINT")+"FWEXTFPW.DLL")

	*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	*³ Abre Arquivo de Liga‡”es                                     ³
	*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	OpenSx9()
	DbGoTop()
	dbsetOrder(2)

	DbSelectArea("SX2")
	DbClearFilter()
	DbGoTop()

	ProcRegua(SX9->(RecCount()),17,4)
	While !(Sx2->(Eof()))
		cAlias := Sx2->x2_chave
		dbSelectarea("SX9")
		dbSeek(cAlias)
		If Found()
			HwConect := FPW_CREATE(hDll,oMainWnd:hWnd)//,GetWndDefault():hWnd)
			*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			*³ Inclui liga‡”es cadastradas no SX9                 ³
			*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			While cAlias == SX9->X9_DOM .and. !Eof()
				IncProc(OemToAnsi(STR0010)+SX9->X9_DOM + OemToAnsi(STR0011) +SX9->x9_CDOM)  // "  Dominio: " ### "   Contra Dominio : "
				If X9_USO != "N"
					cExpDom := ValidaExpr(X9_DOM,X9_EXPDOM)
					cExpCDom := ValidaExpr(X9_CDOM,X9_EXPCDOM)
					*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					*³ Inclui liga‡”es do   Dominio                       ³
					*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					cArqFpw  := cDirForpw+AllTrim(SX2->X2_ARQUIVO)+".FPW"
					lOk :=  FPW_OPEN(hDll,hwConect,cArqFpw)
					MsgErrFpw(lOk,"FPWOPEN")
					cArqlig := cDirForpw+RetSx2Arq(X9_CDOM,.F.)+".FPW"
					nTipo := IIF(X9_LIGDOM == "1",0,1)
					lOk :=  FPW_SETLINK(Hdll,HwConect,cArqLig,Val(X9_SEQUENC),nTipo,cExpDom,cExpCDom)
					MsgErrFpw(lOk,"SETLINK")
					*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					*³ Salva arquivo Fpw                                  ³
					*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					lOk :=  FPW_SAVE(Hdll,hwConect)
					MsgErrFpw(lOk,"FPWSAVE")
					lOk :=  FPW_CLOSE(Hdll,hwConect)
					MsgErrFpw(lOk,"FPWCLOSE")
					*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					*³ Inclui liga‡”es do Cnt. Dominio                    ³
					*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					cArqFpw  := cDirForpw+RetSx2Arq(X9_CDOM,.F.)+".FPW"
					lOk :=  FPW_OPEN(hDll,hwConect,cArqFpw)
					MsgErrFpw(lOk,"FPWOPEN")
					cArqlig := cDirForpw+RetSx2Arq(X9_DOM,.F.)+".FPW"
					nTipo := IIF(X9_LIGCDOM == "1",0,1)
					lOk :=  FPW_SETLINK(Hdll,HwConect,cArqLig,Val(X9_SEQUENC)+12000,nTipo,cExpCDom,cExpDom)
					MsgErrFpw(lOk,"SETLINK")
					*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					*³ Salva arquivo Fpw                                  ³
					*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					lOk :=  FPW_SAVE(Hdll,hwConect)
					MsgErrFpw(lOk,"FPWSAVE")
					lOk :=  FPW_CLOSE(Hdll,hwConect)
					MsgErrFpw(lOk,"FPWCLOSE")
				Endif
				dbSkip()
			Enddo
			lOk :=  FPW_DESTROY(Hdll,hwConect)
			MsgErrFpw(lOk,"FPWDESTROY")
		Endif
		If lAllArq
			Sx2->(dbSkip())
		Else
			Exit
		Endif
	Enddo

	dbSelectarea("SX9")
	DbCloseArea()
	dbselectarea(cOldAlias)
	Set FIlter to &cFilter
	FreeLibrary( hDLL )

	Return Nil



	/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Fun‡…o    ³FpwTitulo ³ Autor ³ Cristiane Maeda       ³ Data ³07.08.96  ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡…o ³Remove caracteres invalidos para o FORPRINT                 ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Parametros³Titulo do Sx3                                               ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³ Uso      ³ Forprint       ³                    ³                      ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	/*/

Static Function FpwTitulo(cTitulo)
	Local aInvldChar := {"<",">","%",",","(","/","$","¦","§"}
	Local i

	cTitulo := AllTrim(cTitulo)
	cTitulo := Strtran(cTitulo," ","_")
	cTitulo := Strtran(cTitulo,".","_")

	If !Isalpha(cTitulo)
		cTitulo := "_" + cTitulo
	Endif

	For i := 1 To Len(aInvldChar)
		If ainvldChar[i] $ cTitulo
			cTitulo := Strtran(cTitulo,aInvldChar[i],"")
		Endif
	Next i

	cTitulo := Strtran(cTitulo,"__","_")

	Return (OemToAnsi(cTitulo))

Static Function ValidaExpr(cAlias,cExpr)
	Local cOldAlias:= Alias(),nOldRec := Recno(),nOldOrder := IndexOrd()
	Local aCampos := {},cTitulo,nPos,cProxChar
	Local cOperadores := "+-><=(){[]}$%*/!"
	Local i

	cExpr := mtrim(cExpr)
	DbSelectArea("SX3")
	DbSetOrder(1)
	DbSeek(cAlias)
	While cAlias == x3_arquivo
		AADD(aCampos,{AllTrim(x3_campo),AllTrim(X3Titulo())})
		dbSKip()
	Enddo
	*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	*³Retira Alias da expressao (se houver) ³
	*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cExpr:=StrTran(cExpr,cAlias+"->","")
	*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	*³Troca nome do campo por titulo      ³
	*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	For i := 1 to Len(aCampos)
		nPos := At(Upper(Alltrim(aCampos[i,1])),Upper(cExpr))
		cProxChar := Substr(cExpr,nPos+Len(acampos[i,1]),1)
		IF nPos > 0 .and. (Empty(cProxChar) .or. cProxChar $ cOperadores)
			cTitulo := FpwTitulo(aCampos[i,2])
			cExpr:=StrTran(cExpr,AllTrim(aCampos[i,1]),cTitulo)
		Endif
	Next i

	DbSelectArea(cOldAlias)
	DbSetOrder(nOldOrder)
	DbGoto(nOldRec)

	Return cExpr








