#include "cfgx034.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ Cfgx034  ³ Autor ³ Wagner Xavier         ³ Data ³ 05/08/93 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Programa de configuracao de arquivos                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Cfgx034()                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function cfgx034()
	Return APCFG10("#SX2")

Static Function __cfgx034()
	Local cArqSx2,cIndSx2

	*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	*³ Salva a Integridade dos dados de Entrada                     ³
	*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Define Array contEndo as Rotinas a executar do programa      ³
	//³ ----------- Elementos contidos por dimensao ------------     ³
	//³ 1. Nome a aparecer no cabecalho                              ³
	//³ 2. Nome da Rotina associada                                  ³
	//³ 3. Usado pela rotina                                         ³
	//³ 4. Tipo de Transa‡„o a ser efetuada                          ³
	//³    1 - Pesquisa e Posiciona em um Banco de Dados             ³
	//³    2 - Simplesmente Mostra os Campos                         ³
	//³    3 - Inclui registros no Bancos de Dados                   ³
	//³    4 - Altera o registro corrente                            ³
	//³    5 - Remove o registro corrente do Banco de Dados          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Private aRotina := { { STR0001,"AxVisual", 0 , 2},;  // "Visualizar"
	{ STR0007,"ax034inc",0 , 3},;   // "Incluir"
	{ STR0002,"ax034alt", 0 , 4} }  // "Configurar"
	// { "Pesquisar" ,"AxPesqui", 0 , 1},;
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Define o cabecalho da tela de atualizacoes                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Private cCadastro := OemToAnsi(STR0003) // "Parametriza‡„o de Arquivos"



	*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	*³ Aguarda Liberacao de Arquivos por outras estacoes para abrir SX2 Exclusivo  ³
	*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cArqSx2 := "SX2" + SM0->M0_CODIGO + "0"
	cIndSx2 = cArqSx2
	If !OpenSX2Excl(cArqSx2,cIndSx2)
		Return
	EndIf

	DbSelectArea("SX2")
	Set Filter To
	Set Filter To X2_CHAVE != "SM2" .and. X2_CHAVE != "SH7"
	DbGoTop()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Endereca a funcao de BROWSE                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	mBrowse( 6, 1,22,75,"SX2",,,32)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Recupera a Integridade dos dados                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	cIndSx2 += "1"
	DbSelectArea("SX2")  // Fecha Arquivo Em Modo Exclusivo
	dbCloseArea()
	// Abre Arquivo em Modo Compartilhado
	dbUseArea( .T.,,("SX2"+SM0->M0_CODIGO+"0"), "SX2", If(.F. .OR. .T., !.F., NIL), .F. )

	If RetIndExt()!=".CDX"
		dbSetIndex( cIndSx2 )
	Else
		DbSetOrder(1)
	EndIf
	Set Filter To


	/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Fun‡…o    ³ ax034alt ³ Autor ³ Wagner Xavier         ³ Data ³ 05/08/93 ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡…o ³ Programa de alteracao no modo de acesso de arquivos        ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Sintaxe   ³ Ax034Alt()                                                 ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³ Uso      ³ Generico                                                   ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	/*/
FuncTion Ax034Alt(cAlias,nReg,nOpc)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Define Variaveis                                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Local cArquivo,nPosFilial:=0,nOpcA,nIndices:=0,cModoAnt
	Local xAlias,cIndex,SixChave,cPathAnt,cPath

	DbSelectArea( cAlias )
	cModoAnt:=SX2->X2_MODO
	cPathAnt   :=AllTrim(SX2->X2_PATH)
	If SX2->X2_CHAVE $ "SR5/SYN/SYO"
		Help(" ",1,"NOALTSR5")
		Return
	EndIf

	nOpca := AxAltera( cAlias,nReg,nOpc )

	If nOpca == 1

		cArquivo:=SX2->X2_CHAVE
		cArqSx2 := AllTrim(SX2->X2_PATH) + AllTrim(Sx2->X2_ARQUIVO)
		CheckCompSx2(cArquivo,cArqSx2)

		If SX2->X2_MODO != cModoAnt
			MsgRun(OemToAnsi(STR0004+SubStr(cArquivo,2,2)+"_FILIAL"),,{|| AltFil(cPathAnt)})  // "Aguarde, atualizando Campo "
		EndIf

	End
	MsUnlockAll()

	Return

	/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Fun‡…o    ³ A034Diret³ Autor ³ Wagner Xavier         ³ Data ³ 05/08/93 ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡…o ³ VerIfica validade do nome do diretorio.                    ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Sintaxe   ³ A034Diret()                                                ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³ Uso      ³ Generico                                                   ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	/*/
Function a034diret()
	If SubStr(m->x2_path,1,1) = " " .Or. " " $ Trim(m->x2_path) //Brancos
		Help(" ",1,"DIRBRANCOS")
		Return .F.
	End

	If RAT("\",m->x2_path) != Len(AllTrim(m->x2_path)) //Sem Barra
		Help(" ",1,"NOBARRA")
		Return .F.
	End

	If Len(AllTrim(m->x2_path)) <= 3       //Raiz
		Help(" ",1,"RAIZ")
		Return .F.
	End
	Return .T.

	/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Fun‡…o    ³UpdtFilial³ Autor ³ Wagner Xavier         ³ Data ³ 31/08/93 ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡…o ³Preenche o campo filial.                                    ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Sintaxe   ³UpdtFilial                                                  ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³ Uso      ³ Generico                                                   ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	/*/
Static Function UpdtFilial(cAlias,cConteudo)
	Local cCampo
	Reclock(cAlias)
	cCampo:=SubStr(cAlias,2,2)+"_FILIAL"
	Replace &cCampo. With cConteudo
	Return


	/*
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Fun‡…o    ³ CheckCompSX2³Autor ³ Cristiane Maeda      ³ Data ³ 20/09/95 ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡…o ³ VerIfica se o arquivo a ser alterado   ‚ compartilho entre  ³±±
	±±³          ³ outras empresas e monta um array com os arquivos SX2's p/   ³±±
	±±³          ³ serem atualizados.                                          ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Retorna   ³ Array c/ SX2 p/serem atualizados                            ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³ Uso      ³ CFGx031.PRG                                                 ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	*/
Static Function CheckCompSX2(cArq,cArqIni)
	Local cAuxAlias,cArqInd,cOldEmp:= "",lCdxAxs := .F., i

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
			cArqInd := "SX2" + SM0->M0_CODIGO+"0"
			If !FILE(cArqInd + GetDBExtension())
				dbCloseall()
				Final(cArqInd + STR0005) // " n„o existe"
			EndIf
			DbUseArea(.T.,,cArqInd,cAuxAlias, .T., .T. )
			While !Used()
				Help(" ",1,"SX2 NEXCLUS")
				DbUseArea(.T.,,"SX2"+SM0->M0_CODIGO+"0",cAuxAlias, .T., .T. )
			End
			If File(cArqInd+Iif(lCdxAxs,"","1")+RetIndExt())
				DbSetIndex(cArqInd+Iif(lCdxAxs,"","1"))
			ElseIf lCdxAxs
				Index On x2_chave Tag &(cArqInd+"1") to &cArqInd
			Else
				cArqInd += "1"
				dbCreateIndex( cArqInd,"X2_CHAVE",{|| X2_CHAVE}, .T. )
			EndIf
			DbGoTop()
			DbSeek(cArq)
			If Found()
				If AllTrim(Upper(cArqIni)) == Upper(AllTrim(X2_PATH)+AllTrim(X2_ARQUIVO))
					dbCloseArea()
					DbUseArea(.T.,,"SX2"+SM0->M0_CODIGO+"0",cAuxAlias, .F., .F. )
					While !Used()
						Help(" ",1,"ARQEXCL")
						DbUseArea(.T.,,"SX2"+SM0->M0_CODIGO+"0",cAuxAlias, .F., .F. )
					End
					If !lCdxAxs
						DbSetIndex (cArqInd)
					Else
						DbSetOrder(1)
					EndIf
					DbSeek(cArq)
					For i := 1 to fCount()
						FieldPut(i,SX2->(FieldGet(i)))
					Next i
					dbCloseArea()
				Else
					dbCloseArea()
				EndIf
			Else
				DbCloseArea()
			EndIf
		EndIf
		cOldEmp := SM0->M0_CODIGO
		SM0->(DbSkip())
	End

	SM0->(DbSeek(cEmpAnt+cFilAnt))
	Return


Static Function AltFil(cPathAnt)
	Local cArquivo
	Local theDriver := __cRDD
	Local i
	Local cEmptyFil := "  "
	#ifdef TOP
		Local cDataBase,cCommand,cInIfile  := GetADV97()
	#endif

	cArquivo:= RetArq(__cRdd,cPathAnt+Trim(SX2->X2_ARQUIVO),.T.)
	xAlias  := SX2->X2_CHAVE
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Se o arquivo for o SX5, o mesmo ja' se encontra aberto. ³
	//³ Se o arquivo n„o for encontrado, o mesmo n„o dever  ser ³
	//³ atualizado.                                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If xAlias != "SX5" .and. MSFile(cArquivo)
		If ("SX" $ xAlias)
			theDriver := __LocalDriver
		Else
			#ifdef TOP
				If (xAlias $ "SH7SH8SH9")
					theDriver := __LocalDriver
				EndIf
			#endif
		EndIf
		While !MsOpEndbf(.T.,theDriver,cArquivo,xAlias,.F.,.F.,.T. )
		End
	Else
		DbSelectArea("SX5")
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atualiza‡„o do arquivo. Se modo for compartilhado sera' ³
	//³ gravado a filial com "  ", caso contrario com a filial  ³
	//³ corrente.                                               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If MSFile(cArquivo)

		If FindFunction("FWSizeFilial")
			cEmptyFil := Space(FWSizeFilial())
		EndIf
		cConteudo:=Iif(SX2->X2_MODO=="E",cFilAnt,cEmptyFil)
		nSavOrd := IndexOrd()
		DbSetOrder(0)
		DbGoTop()
		#ifdef TOP
			If (TCSrvType() == "AS/400")
				cDataBase := GetPvProfString("TopConnect","DataBase","ERROR",cInIfile )
				cCommand  := "UPDATE "+cDataBase+"/"+cArquivo
			Else
				cCommand  := "UPDATE "+cArquivo
			EndIf
			cCommand += " SET "+SubStr(cArquivo,2,2)+"_FILIAL = '"+cConteudo+"'"
			TCSqlExec(cCommand)
		#else
			dbEval( { || UpdtFilial(SX2->X2_CHAVE,cConteudo) } )
		#endif
		DbSetOrder(nSavOrd)
		dbCloseArea()
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Caso tenha sido alterado o modo de acesso do arqui-³
		//³ vo, seus indices dever„o ser deletados.            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cArqDel:=AllTrim(cPathAnt)+SX2->X2_CHAVE+cEmpAnt+"0*"+RetIndExt()
		aArqDel:=DIRECTORY(cArqDel)
		For i:=1 To Len(aArqDel)
			Ferase(AllTrim(cPathAnt)+aArqDel[i][1])
		Next i
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Envia chamada para cria‡„o de diretorio. Caso o mes-³
	//³ mo ja' exista, nada sera' feito.                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cPath:=AllTrim(SubStr(SX2->X2_PATH,1,Len(AllTrim(SX2->X2_PATH))-1))
	//MakeDir(cPath)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Se houve alteracao no arquivo de Tabelas, o mesmo   ³
	//³ devera' ser aberto novamente                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If xAlias = "SX5"
		cArquivo := RetArq(__cRdd,AllTrim(SX2->X2_PATH)+AllTrim(SX2->X2_ARQUIVO),.T.)
		If !MSFILE(cArquivo)
			Final(cArquivo+STR0006)  // " n†o encontrado"
		EndIf
		While !ChkFile("SX5",.t. )
			Help("",1,"ARQEXCL")
		End
	End


	Return Nil


Function ax034Inc(cAlias,nReg,nOpc)
	Local nOpca := 0,nRegSx3 := SX3->(Recno()),nOrdSx3 := SX3->(IndexOrd())
	Local cOldAlias := Alias(),nOldRec := Recno(), nOldOrder:=IndexOrd()
	Local cUsado := ""
	Local cPode  := ""

	cUsado := Space(102)
	cUsado := FirstBitOn(cUsado)
	cUsado := Str2Bin(cUsado)
	cPode := replicate("X",6) + " X"
	cPode := x3reserv(cPode)

	nOpca := AxInclui( cAlias,0,nOpc )
	cPrefixo := SX2->X2_CHAVE
	If nOpca == 1
		DbSelectArea("SX3")
		DbSetOrder(1)
		DbSeek(cPrefixo)
		If !Found()   // Cria Registro com Filial
			Reclock("SX3",.t.)
			Replace X3_ARQUIVO	With cPrefixo
			Replace X3_ORDEM  	With "01"
			Replace X3_CAMPO 	With PrefixoCpo(cPrefixo)+"_FILIAL"
			Replace X3_TIPO 	With "C"
			Replace X3_TAMANHO 	With 2
			Replace X3_DECIMAL 	With 0
			Replace X3_TITULO 	With "Filial"
			Replace X3_TITSPA 	With "Sucursal"
			Replace X3_TITENG 	With "Branch"
			Replace X3_DESCRIC 	With "Filial do Sistema"
			Replace X3_DESCSPA 	With "Sucursal"
			Replace X3_DESCENG 	With "Branch of the System"
			Replace X3_PICTURE 	With "@!"
			Replace X3_RESERV   With cPode
			Replace X3_USADO   	With cUsado
			Replace X3_NIVEL   	With 1
			Replace X3_BROWSE  	With "N"
			Replace X3_PROPRI	With "U"
			MsUnlock()
		EndIf
		DbSetOrder(nOrdSx3)
		DbGoTo(nRegSx3)
		DbSelectArea(cOldAlias)
		If nOldOrder # 0
			DbSetOrder(nOldOrder)
			DbSeek(cPrefixo)
		Else
			DbGoTo(nOldRec)
		Endif
	Else
		DbSelectArea(cOldAlias)
		DbGoTo(nOldRec)
	EndIf
	Return

