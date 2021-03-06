#INCLUDE "PROTHEUS.CH"
#INCLUDE "CFGX053.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �CFGX053   � Autor � Fernando Salvatori � Data � 29/01/2004  ���
�������������������������������������������������������������������������͹��
���Descricao � Consulta de LOG de alteracoes nos cadastros.               ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � GENERICO                                                   ���
�������������������������������������������������������������������������͹��
���           ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.           ���
�������������������������������������������������������������������������͹��
��� PROGRAMADOR  � DATA   � BOPS �  MOTIVO DA ALTERACAO                   ���
�������������������������������������������������������������������������͹��
���              �        �      �                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Function CFGX053
	Local aSays     := {}             //Mensagem do Dialogo Principal
	Local aButtons  := {}             //Botoes do dialogo principal
	Local cCadastro := ""             //Titulo do programa
	Local lOk       := .F.            //Confirmacao da tela do dialogo principal
	Local cPerg     := "CFG053"       //Grupo de perguntas que sera utilizado

	//�������������������������������������������������������������������������Ŀ
	//�Caso nao exista a pergunta. Cria o mesmo no SX1          				�
	//���������������������������������������������������������������������������
	Pergunte( cPerg, .F. )

	//�������������������������������������������������������������������������Ŀ
	//�Dialogo principal para parametrizacao                      				�
	//���������������������������������������������������������������������������
	AAdd(aSays,"                                                                        " )
	AAdd(aSays,STR0001 )//"          Este programa tem por objetivo efetuar a consulta de LOG de altera��es"
	AAdd(aSays,STR0002 )//"de cadastros conforme configurado nos par�metros abaixo.                "
	AAdd(aButtons, { 5,.T.,{|| Pergunte( cPerg,.T. ) } } )
	AAdd(aButtons, { 1,.T.,{|o| lOk := .T.,o:oWnd:End()}} )
	AAdd(aButtons, { 2,.T.,{|o| o:oWnd:End() }} )

	FormBatch( cCadastro, aSays, aButtons )

	//�������������������������������������������������������������������������Ŀ
	//�Caso seja confirmada, realiza a consulta.                  				�
	//���������������������������������������������������������������������������
	If lOk
		CFG053Cons()
	EndIf

	Return Nil

	/*
	�����������������������������������������������������������������������������
	�����������������������������������������������������������������������������
	�������������������������������������������������������������������������ͻ��
	���Funcao    �CFG053Cons�Autor  �Fernando Salvatori  � Data � 29/01/2004  ���
	�������������������������������������������������������������������������͹��
	���Desc.     � Efetua a consulta das informacoes.                         ���
	���          �                                                            ���
	�������������������������������������������������������������������������͹��
	���Uso       � CFGX053                                                    ���
	�������������������������������������������������������������������������ͼ��
	�����������������������������������������������������������������������������
	�����������������������������������������������������������������������������
	*/
Static Function CFG053Cons( cTabela, cUsuDe, cUsuAte, dDataDe, dDataAte, ;
		cHoraDe, cHoraAte, nTipoLog )

	Local oDlg                            //Dialog principal
	Local oListBox                        //Objeto ListBox
	Local aSize       := MsAdvSize()      //Size da tela.
	Local aObjects    := {}               //Objetos da tela
	Local aPosObj     := {}               //Posicoes do objeto
	Local aInfo       := {}               //Posicoes do objeto
	Local oGetDados                       //Objeto da MsGetDados
	Local cTipoLog    := ""               //Tipo de LOG para filtro no SXP
	Local cArqSXP     := ""               //Alias para o IndRegua do SXP
	Local cFiltro     := ""               //Filtro da tabela SXP
	Local aStructSXP  := {}               //Estrutura do SXP
	Local cChaveOld   := ""               //Chave antiga para adicionar registro no Temporario
	Local nX          := 0                //Variavel de contador
	Local nCount      := 0                //Contador de campos
	Local aButtons	  := {}

	Default cUsuDe    := ""
	Default cUsuAte   := Replicate("Z",15)
	Default dDataDe   := CtoD("01/01/2002")
	Default dDataAte  := CtoD("31/12/2049")
	Default cHoraDe   := "00:00:00"
	Default cHoraAte  := "99:99:99"
	Default nTipoLog  := 4

	//��������������������������������������������������������������������������Ŀ
	//�Parametros do programa:                                                   �
	//��������������������������������������������������������������������������Ĵ
	//�MV_PAR01 -> Familia de arquivos para visualizacao dos LOGS.               �
	//�MV_PAR02 -> Usuario de  ( Codigo de usuario inicial )                     �
	//�MV_PAR03 -> Usuario ate ( Codigo de usuario final )                       �
	//�MV_PAR04 -> Data de     ( Data inicial do LOG )                           �
	//�MV_PAR05 -> Data ate    ( Data final do LOG )                             �
	//�MV_PAR06 -> Hora de     ( Hora Inicial )                                  �
	//�MV_PAR07 -> Hora final  ( Hora final )                                    �
	//�MV_PAR08 -> Tipo de LOG / 1-Inclusao / 2-Alteracao / 3-Ambos              �
	//����������������������������������������������������������������������������
	//�������������������������������������������������������������������������Ŀ
	//�Se a tabela nao foi parametrizada, faco a pergunta         				�
	//���������������������������������������������������������������������������
	If ValType( cTabela ) == "U"
		//�������������������������������������������������������������������������Ŀ
		//�Atualizacao dos parametros.                                              �
		//���������������������������������������������������������������������������
		cTabela   := MV_PAR01
		cUsuDe    := MV_PAR02
		cUsuAte   := MV_PAR03
		dDataDe   := MV_PAR04
		dDataAte  := MV_PAR05
		cHoraDe   := MV_PAR06
		cHoraAte  := MV_PAR07
		nTipoLog  := MV_PAR08
	EndIf

	//�����������������������������������������������������������������������������Ŀ
	//�Passo a escolha do parametro de tipo de LOG para string (Filtro no Indregua  �
	//�������������������������������������������������������������������������������
	If nTipoLog == 1
		cTipoLog += "064/"
	ElseIf nTipoLog == 2
		cTipoLog += "128/"
	ElseIf nTipoLog == 3
		cTipoLog += "256/"
	ElseIf nTipoLog == 4
		cTipoLog += "064/128/256/"
	EndIf

	//�������������������������������������������������������������������������Ŀ
	//�Crio o arquivo temporario com a estrutura igual ao SXP   				�
	//���������������������������������������������������������������������������
	dbSelectArea( "SXP" )
	aStructSXP := dbStruct()
	cArqSXP    := CriaTrab( aStructSXP, .T. )
	dbUseArea( .T.,, cArqSXP, "TMPSXP", .F., .F. )

	//�������������������������������������������������������������������������Ŀ
	//�Faco o filtro do arquivo SXP para inserir ao temporario  				�
	//���������������������������������������������������������������������������
	dbSelectArea( "SXP" )

	If !Empty(cTabela)
		cFiltro += "XP_ALIAS = '"+cTabela+"'
	EndIf
	If !Empty(cUsuDe)
		If len(cFiltro) > 0
			cFiltro += " .And. "
		EndIf
		cFiltro += "Upper(XP_USER) >= '"+Upper(cUsuDe)+"'
	EndIf
	If !Empty(cUsuAte)
		If len(cFiltro) > 0
			cFiltro += " .And. "
		EndIf
		cFiltro += "Upper(XP_USER) <= '"+Upper(cUsuAte)+"'
	EndIf

	If !Empty(Dtos(dDataDe))
		If len(cFiltro) > 0
			cFiltro += " .And. "
		EndIf
		cFiltro += "DtoS(XP_DATA) >= '"+DtoS(dDataDe)+"'
	EndIf

	If !Empty(DtoS(dDataAte))
		If len(cFiltro) > 0
			cFiltro += " .And. "
		EndIf
		cFiltro += "DtoS(XP_DATA) <= '"+DtoS(dDataAte)+"'
	EndIf

	If !Empty(cHoraDe)
		If len(cFiltro) > 0
			cFiltro += " .And. "
		EndIf
		cFiltro += "XP_TIME >= '"+cHoraDe+"'
	EndIf

	If !Empty(cHoraAte)
		If len(cFiltro) > 0
			cFiltro += " .And. "
		EndIf
		cFiltro += "XP_TIME <= '"+cHoraAte+"'
	EndIf

	If !Empty(cTipoLog)
		If len(cFiltro) > 0
			cFiltro += " .And. "
		EndIf
		cFiltro += "StrZero(XP_OPER,3,0) $ '"+cTipoLog+"'"
	EndIf

	IndRegua( "SXP", cArqSXP ,"XP_ALIAS+XP_ID",,cFiltro )
	dbSetOrder( 1 )
	dbGotop()

	//�������������������������������������������������������������������������Ŀ
	//�Preencho o Temporario com os dados do SXP para o cabecalho do programa   �
	//���������������������������������������������������������������������������
	cChaveOld   := ""
	Do While !Eof()
		If cChaveOld != XP_ALIAS + XP_ID
			cChaveOld := XP_ALIAS + XP_ID

			dbSelectArea( "TMPSXP" )
			nCount := FCount()

			RecLock( "TMPSXP" , .T. )
			For nX := 1 to nCount
				FieldPut( nX, SXP->(FieldGet(nX)) )
			Next nX
			MsUnlock()

		EndIf

		dbSelectArea( "SXP" )
		dbSkip()
	EndDo

	TMPSXP->( dbGotop() )

	//�������������������������������������������������������������������������Ŀ
	//�Caso a tabela selecionada no parametro exista nos filtros, trago os dados�
	//���������������������������������������������������������������������������
	If dbSeek( cTabela )
		Aadd(aButtons, { "RELATORIO" , { || ImpLog()}, STR0022, STR0022})   //"Impress�o"

		//�������������������������������������������������������������������������Ŀ
		//� Define as posicoes da GetDados e Paineis.                               �
		//���������������������������������������������������������������������������
		AAdd( aObjects, {  100, 100, .T., .T. } )      //Painel Cabecalho
		aInfo 	 := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 2, 2 }
		aPosObj  := MsObjSize( aInfo, aObjects, .T. , .F. )

		//�������������Ŀ
		//�aHeader:     �
		//�������������Ĵ
		//�             �
		//�TITULO  1    �
		//�CAMPO   2    �
		//�PICTURE 3    �
		//�TAMANHO 4    �
		//�DECIMAL 5    �
		//�VALID   6    �
		//�USADO   7    �
		//�TIPO    8    �
		//�F3      9    �
		//�CONTEXT 10   �
		//�CBOX    11   �
		//�RELACAO 12   �
		//�WHEN    13   �
		//�VISUAL  14   �
		//�VLDUSER 15   �
		//�VISUAL  14   �
		//�PICTVAR 16   �
		//�OBRIGAT 17   �
		//���������������

		//�������������������������������������������������������������������������Ŀ
		//� Montagem da tela.                                                       �
		//���������������������������������������������������������������������������
		DEFINE MSDIALOG oDlg TITLE STR0003 FROM aSize[7],00 TO aSize[6],aSize[5] OF oMainWnd PIXEL//"Consulta de LOG de cadastros"

		//������������������������������������������������������������������������Ŀ
		//� Objeto ListBox aberto diretamente a base de dados SXP                  �
		//��������������������������������������������������������������������������
		@ aPosObj[1][1], aPosObj[1][2] LISTBOX oListBox FIELDS TMPSXP->XP_ALIAS,;
			TMPSXP->XP_ID,;
			IIf(TMPSXP->XP_OPER ==64,STR0004,IIf(TMPSXP->XP_OPER == 128,STR0005,STR0006)), ;//"Inclus�o"//"Altera��o"//"Exclus�o"
		TMPSXP->XP_USER, ;
			TMPSXP->XP_DATA, ;
			TMPSXP->XP_TIME ;
			HEADER STR0007,;//"Alias"
		STR0008,;//"Identifica��o"
		STR0009, ;//"Opera��o"
		STR0010, ;//"Usu�rio"
		STR0011, ;//"Data"
		STR0012 ;//"Hora"
		ALIAS  "TMPSXP" ;
			SIZE   aPosObj[1][4]-aPosObj[1][2],aPosObj[1][3]-aPosObj[1][1] ;
			OF     oDlg PIXEL

		//�������������������������������������������������������������������������Ŀ
		//�Duplo clique no ListBox traz a tela de visualizacao dos campos.          �
		//���������������������������������������������������������������������������
		oListBox:bLdblClick := {|| CFG053Visual() }

		//�������������������������������������������������������������������������Ŀ
		//�Ativo o Dialogo Principal.                                               �
		//���������������������������������������������������������������������������
		ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar( oDlg,{|| oDlg:End()},{|| oDlg:End()},,aButtons,,,.F. )
	Else
		MsgStop( STR0013, STR0014 )//"N�o existe tabelas para serem selecionados."//"Aten��o"
	EndIf

	//�������������������������������������������������������������������������Ŀ
	//�Fechamento dos arquivos temporarios e do Indregua do SXP.                �
	//���������������������������������������������������������������������������
	dbSelectArea( "TMPSXP" )
	dbCloseArea()
	FErase( cArqSXP+GetDBExtension() )

	dbSelectArea( "SXP" )
	FErase( cArqSXP + OrdBagExt() )

	Return Nil

	/*
	�����������������������������������������������������������������������������
	�����������������������������������������������������������������������������
	�������������������������������������������������������������������������ͻ��
	���Programa  �CFG053Visu�Autor  �Fernando Salvatori  � Data �  17/06/2003 ���
	�������������������������������������������������������������������������͹��
	���Desc.     � Visualizacao do LOG.                                       ���
	���          �                                                            ���
	�������������������������������������������������������������������������͹��
	���Uso       � CFGX053                                                    ���
	�������������������������������������������������������������������������ͼ��
	�����������������������������������������������������������������������������
	�����������������������������������������������������������������������������
	*/
Static Function CFG053Visual()
	Local oDlgVisual                                //Objeto da tela de visualizacao
	Local oListVisual                               //Objeto da ListBox
	Local aSize       := MsAdvSize()                //Size da tela.
	Local aObjects    := {}                         //Objetos da tela
	Local aPosObj     := {}                         //Posicoes do objeto
	Local aInfo       := {}                         //Posicoes do objeto
	Local aListBox    := {}                         //Array com a ListBox atual
	Local oListBox                                  //Objeto ListBox
	Local cSeekWhile  := ""                         //Cache para Loop
	Local oAlias, oId, oOper, oUser, oData, oTime   //Objeto das mensagens SAY
	Local nRecnoSXP						            //Recno do SXP
	Local nTamAntVal  := 0                          //Tamanho do campo do Listbox para Antigo Valor
	Local nTamNovVal  := 0                          //Tamanho do campo do Listbox para Antigo Valor
	Local oRec  									// Objeto do Recno do registro
	Local oUnico									// Objeto da Chave Unica
	Local cUnico									// Chave Unica
	Local nAdd		:= 0
	Local nPos		:= 0

	//�������������������������������������������������������������������������Ŀ
	//�Realizo a pesquisa na base de dados para retirar os itens (campos) do LOG�
	//���������������������������������������������������������������������������
	dbSelectArea( "SXP" )
	dbSeek( cSeekWhile := TMPSXP->XP_ALIAS + TMPSXP->XP_ID )
	nRecnoSXP   := SXP->( Recno() )           //Recno do SXP
	IF SX2->(DbSeek(TMPSXP->XP_ALIAS))
		cUnico := SX2->X2_UNICO
	else
		cUnico := ''
	EndIf

	Do While !Eof() .And. cSeekWhile == XP_ALIAS + XP_ID
		AAdd( aListBox, { XP_CAMPO, XP_ANTVAL, XP_NOVVAL ,XP_UNICO})

		If Len( AllTrim(XP_ANTVAL) ) > nTamAntVal
			nTamAntVal := Len( AllTrim(XP_ANTVAL) )
		EndIf

		If Len( AllTrim(XP_NOVVAL) ) > nTamNovVal
			nTamNovVal := Len( AllTrim(XP_NOVVAL) )
		EndIf

		dbSkip()
	EndDo

	//�������������������������������������������������������������������������Ŀ
	//�Caso o espaco de cada campo seja menor que 15 caracteres, padronizo.     �
	//���������������������������������������������������������������������������
	If nTamAntVal < 15
		nTamAntVal := 15
	EndIf

	If nTamNovVal < 15
		nTamNovVal := 15
	EndIf

	//�������������������������������������������������������������������������Ŀ
	//�Volto pro registro original por causa dos campos do SAY Abaixo.          �
	//���������������������������������������������������������������������������
	dbGoto( nRecnoSXP )

	//�������������������������������������������������������������������������Ŀ
	//� Define as posicoes da GetDados e Paineis.                               �
	//���������������������������������������������������������������������������
	AAdd( aObjects, {  100, 030, .T., .T. } )        //Enchoice
	AAdd( aObjects, {  100, 070, .T., .T. } )        //ListBox

	aInfo 	 := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 2, 2 }
	aPosObj  := MsObjSize( aInfo, aObjects, .T. , .F. )

	//�������������������������������������������������������������������������Ŀ
	//�Dialogo de visualizacao de campos.                                       �
	//���������������������������������������������������������������������������
	DEFINE MSDIALOG oDlgVisual TITLE STR0003 FROM aSize[7],00 TO aSize[6],aSize[5] OF oMainWnd PIXEL//"Consulta de LOG de cadastros"

	oPanel := TPanel():New(aPosObj[1][1],aPosObj[1][2],"",oDlgVisual,NIL,.T.,.F.,NIL,NIL,aPosObj[1][4]-aPosObj[2][2],aPosObj[1][3]+aPosObj[1][1],.T.,.F.)

	@ 008,010  SAY STR0007 PIXEL OF oPanel//"Alias"
	@ 008,040  MSGET oAlias VAR SXP->XP_ALIAS WHEN .F. OF oPanel PIXEL SIZE 020,009

	@ 008,170  SAY STR0008 PIXEL OF oPanel//"Identifica��o"
	@ 008,220  MSGET oId    VAR SXP->XP_ID    WHEN .F. OF oPanel PIXEL SIZE 090,009

	@ 021,010  SAY STR0009 PIXEL OF oPanel//"Opera��o"
	@ 021,040  MSGET oOper  VAR IIf(SXP->XP_OPER ==64,STR0004,IIf(SXP->XP_OPER == 128,STR0005,STR0006))  WHEN .F. OF oPanel PIXEL SIZE 040,009//"Inclus�o"//"Altera��o"//"Exclus�o"

	@ 021,170  SAY STR0010 PIXEL OF oPanel//"Usu�rio"
	@ 021,220  MSGET oUser  VAR SXP->XP_USER  WHEN .F. OF oPanel PIXEL SIZE 040,009

	@ 034,010  SAY STR0011 PIXEL OF oPanel//"Data"
	@ 034,040  MSGET oData  VAR SXP->XP_DATA  WHEN .F. OF oPanel PIXEL SIZE 030,009

	@ 034,170  SAY STR0012 PIXEL OF oPanel//"Hora"
	@ 034,220  MSGET oTime  VAR SXP->XP_TIME  WHEN .F. OF oPanel PIXEL SIZE 030,009

	If SXP->(FieldPos("XP_REC")) > 0
		If SXP->XP_REC != 0
			@ 047,010  SAY STR0018 PIXEL OF oPanel//"Recno "
			@ 047,040  MSGET oRec VAR SXP->XP_REC WHEN .F. OF oPanel PIXEL SIZE 030,009

			nAdd := 13
		EndIf
	EndIf

	If SXP->(FieldPos("XP_UNICO")) > 0
		nPos := 47+nAdd
		@ nPos,010 SAY STR0019 + ": "+cUnico PIXEL OF oPanel//"Chave �nica"

		@ nPos+13,010 SAY STR0020 PIXEL OF oPanel//"Informa��es da Chave �nica"
		@ nPos+13,100 MSGET oUnico VAR SXP->XP_UNICO WHEN .F. OF oPanel PIXEL SIZE 200,009
	EndIf

	//������������������������������������������������������������������������Ŀ
	//� Objeto ListBox aberto diretamente a base de dados SXP                  �
	//��������������������������������������������������������������������������
	@ aPosObj[2][1]+10,aPosObj[2][2] LISTBOX oListBox FIELDS HEADER STR0015,STR0016,STR0017,STR0021 ;//"Campo"//"Valor Antigo"//"Valor Novo"//"Chave Alias"
	FIELDSIZES 40, (nTamAntVal * 2.8), (nTamNovVal * 2.8) SIZE aPosObj[2][4]-aPosObj[2][2],aPosObj[2][3]-aPosObj[2][1] OF oDlgVisual PIXEL

	//�������������������������������������������������������������������������Ŀ
	//�Configuracao da ListBox.                                                 �
	//���������������������������������������������������������������������������
	oListBox:SetArray( aListBox )
	oListBox:bLine := {|| {aListBox[oListBox:nAt,1],aListBox[oListBox:nAt,2],aListBox[oListBox:nAt,3],aListBox[oListBox:nAt,4]} }
	oListBox:Refresh()

	ACTIVATE MSDIALOG oDlgVisual ON INIT EnchoiceBar( oDlgVisual,{|| oDlgVisual:End()},{|| oDlgVisual:End()} )

	Return .T.

	//----------------------------------------------------------------------------
Static Function ImpLog()
	Local CbCont
	Local wnrel
	Local limite     := 132
	Local titulo     := OemToAnsi(STR0003) //"Consulta de LOG de cadastros"
	Local cDesc1     := OemToAnsi(STR0023) //"Emiss�o dos LOGs de cadastro"
	Local cDesc2     := OemToAnsi(STR0024) //"Ir� imprimir os dados dos registros"
	Local cDesc3     := OemToAnsi(STR0025) //"de acordo com os par�metros do relat�rio"

	Local nRecno := TMPSXP->(Recno())

	Private aReturn  := { OemToAnsi(STR0026), 1,OemToAnsi(STR0027), 2, 2, 1, "",1 } //"Zebrado"###"Administra��o"
	Private aLinha   := { }
	Private nomeprog := "CFGX053"
	Private AParDef  := {}
	Private nLastKey

	Private cabec1
	Private cabec2
	Private cabec3
	Private tamanho    := "M"
	Private local

	cbcont   := 0
	cabec1   := OemToAnsi(STR0003) //"RELACAO DO CADASTRO DE USU�RIOS"
	cabec2   := ""
	cabec3   := ""
	cString  := ""
	wnrel    := "CFGX053"

	Pergunte("CFG053",.F.)
	wnrel := SetPrint(cString,wnrel,,@Titulo,cDesc1,cDesc2,cDesc3,.F.,{},,tamanho,,.F.)
	If nLastKey == 27
		Return
	EndIf
	SetDefault(aReturn,cString)
	If nLastKey == 27
		Return
	EndIf
	RptStatus({|lEnd| RApCfg53(@lEnd,Cabec1,Cabec2,Cabec3,limite,tamanho,cbCont,wnrel)},Titulo)

	If nRecno > 0
		TMPSXP->(DbGoto(nRecno))
	Endif
	Return

	// ---------------------------------------------------------------------
Static Function RApCfg53(lEnd,Cabec1,Cabec2,Cabec3,limite,tamanho,cbCont,wnrel)
	Local nPadr := 47
	Local cSeekWhile := ""
	Local cUnico := ""
	Local cAlias := ""
	Local lDupl  := .F.
	Local cAux	 := ""
	Local nI	 := 0
	Local cHeader:=""
	Local cTexto := ""

	Private li
	Private cCabec1  := Cabec1
	Private cCabec2  := Cabec2
	Private cCabec3  := Cabec3
	Private nTamanho := Tamanho

	m_Pag  := 1
	li     := 80

	cabec(cabec1,cabec2,cabec3,nomeprog,tamanho)
	LinhaPrint(__PrtCenter(STR0028)) //"Par�metros do relat�rio"
	LinhaPrint(Padr(STR0029,nPadr)+":",If(!Empty(MV_PAR01), MV_PAR01,"")) //Fam�lia de arquivos para visualiza��o dos LOGS
	LinhaPrint(Padr(STR0030,nPadr)+":",If(!Empty(MV_PAR02), MV_PAR02,"")) //Usuario de
	LinhaPrint(Padr(STR0031,nPadr)+":",If(!Empty(MV_PAR03), MV_PAR03,"")) //Usuario ate
	LinhaPrint(Padr(STR0032,nPadr)+":",If(!Empty(MV_PAR04), DTOC(MV_PAR04),"")) //Data de
	LinhaPrint(Padr(STR0033,nPadr)+":",If(!Empty(MV_PAR05), DTOC(MV_PAR05),"")) //Data ate
	LinhaPrint(Padr(STR0034,nPadr)+":",If(!Empty(MV_PAR06), MV_PAR06,"")) //Hora de
	LinhaPrint(Padr(STR0035,nPadr)+":",If(!Empty(MV_PAR07), MV_PAR07,"")) //Hora ate
	LinhaPrint(Padr(STR0036,nPadr)+":",If(MV_PAR08==1,STR0004,If(MV_PAR08 == 2, STR0005,If(MV_PAR08 == 3,STR0006,STR0037)))) //Tipo de LOG###"Inclus�o"###"Altera��o"###"Exclus�o"###"Ambos"

	LinhaPrint()
	LinhaPrint(__PrtFatLine())

	li := 80

	TMPSXP->(DbGotop())
	While TMPSXP->(!Eof())
		lDupl := .F.
		//�������������������������������������������������������������������������Ŀ
		//�Realizo a pesquisa na base de dados para retirar os itens (campos) do LOG�
		//���������������������������������������������������������������������������
		SXP->(dbSeek( cSeekWhile := TMPSXP->XP_ALIAS + TMPSXP->XP_ID ))

		//imprime o cabe�alho da tabela
		IF cAlias != TMPSXP->XP_ALIAS
			IF SX2->(DbSeek(TMPSXP->XP_ALIAS))
				cUnico := SX2->X2_UNICO
			else
				cUnico := ''
			EndIf
			LinhaPrint(Padr(STR0038+SXP->XP_ALIAS,20)+Iif(!Empty(cUnico), Padr(STR0019+": "+cUnico,120),""))	//"Tabela: "
			LinhaPrint()
		EndIF

		//imprime o cabe�alho principal do registro
		cHeader := Padr(STR0008, 32)+Padr(STR0009, 11)+Padr(STR0010, 27)+Padr(STR0011, 10)+Padr(STR0012, 10)
		IF SXP->(FieldPos("XP_REC")) > 0
			cHeader += Padr(STR0018, 12)
		EndIf
		If SXP->(FieldPos("XP_UNICO")) > 0
			cHeader += Padr(STR0019, 100)
		endIf
		LinhaPrint(cHeader)
		LinhaPrint(__PrtThinLine())
		cTexto := Padr(SXP->XP_ID, 32)+Padr(If(SXP->XP_OPER==64,STR0004, If(SXP->XP_OPER==128,STR0005,STR0006)), 11)+Padr(SXP->XP_USER, 27)+Padr(SXP->XP_DATA, 10)+Padr(SXP->XP_TIME, 10)
		IF SXP->(FieldPos("XP_REC")) > 0
			cTexto += Padr(SXP->XP_REC, 12)
		EndIf
		If SXP->(FieldPos("XP_UNICO")) > 0
			cTexto += Padr(SXP->XP_UNICO, 100)
		endIf
		LinhaPrint(cTexto)
		LinhaPrint()

		//imprime o header da se��o dependo do tipo de opera��o
		If SXP->XP_OPER==64
			lDupl := .T.
			LinhaPrint(Padr(Padr(STR0015, 12)+STR0017,70)+Padr(STR0015, 12)+STR0017)	//"Campo"###""Valor Novo"
			LinhaPrint(__PrtThinLine())
		Else
			If SXP->XP_OPER==128
				LinhaPrint(Padr(STR0015, 12)+Padr(STR0016,58)+Padr(STR0017, 58)) //"Campo"###"Valor Antigo"###"Valor Novo"
				LinhaPrint(__PrtThinLine())
			Else
				lDupl := .T.
				LinhaPrint(Padr(Padr(STR0015, 12)+STR0039,70)+Padr(STR0015, 12)+STR0039)	//"Campo"###"�ltimo Valor"
				LinhaPrint(__PrtThinLine())
			EndIf
		EndIF

		Do While SXP->(!Eof()) .And. cSeekWhile == SXP->XP_ALIAS + SXP->XP_ID
			If SXP->XP_OPER==64 .Or. SXP->XP_OPER==256
				If !Empty(SXP->XP_NOVVAL) .And. SXP->XP_NOVVAL != "0" .And. SXP->XP_NOVVAL != "  /  /  "
					nI := nI+Iif(lDupl, 1,2)
					cAux := cAux + Padr(Padr(SXP->XP_CAMPO, 12)+Subs(SXP->XP_NOVVAL, 1,55),70)
				EndIf
			Else
				nI := 2
				cAux := Padr(SXP->XP_CAMPO, 12)+Padr(Subs(SXP->XP_ANTVAL,1,55),58)+Padr(Subs(SXP->XP_NOVVAL,1,55), 58)
			EndIF

			If !Empty(cAux)
				If nI == 2
					LinhaPrint(cAux)
					cAux := ""
					nI := 0
				EndIF
			EndIf
			SXP->(dbSkip())
		EndDo

		If !Empty(cAux)
			LinhaPrint(cAux)
			cAux := ""
			nI := 0
		EndIf

		LinhaPrint()
		LinhaPrint()

		cAlias := TMPSXP->XP_ALIAS

		TMPSXP->(DbSkip())
	End

	If aReturn[5] == 1
		SET Print TO
		Commit
		ourspool(wnrel)
	EndIf
	MS_FLUSH()

	Return

	// ---------------------------------------------------------------------
Static Function LinhaPrint(cvar1,cvar2)
	If li > 58
		li := cabec(cCabec1,cCabec2,cCabec3,nomeprog,nTamanho)
		li += 1
	EndIf
	If !Empty(cVar1)
		@ li,0  Psay cVar1
	EndIf
	If !Empty(cVar2)
		@ li,50 Psay cVar2
	EndIf

	Li := li + 1
	Return NIL
