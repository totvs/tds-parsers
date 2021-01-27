#include "msmgadd.CH"
#Include "Protheus.ch"
#Include "Folder.ch"
#Include "CFGX057.ch"

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ CFGX057  ³ Autor ³ Acacio Egas           ³ Data ³ 03.09.09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Configurador de reconciliacao Bancaria por arquivo CSV     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CFGX057()                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

FUNCTION CFGX057(void)

    // ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    // ³ Define Variaveis                                            ³
    // ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    Local oDlg

    Private nOpcf   :=1
    Private cFile   :=""
    Private cType   :=""
    Private nBcoHdl :=0
    Private aCposCab,aCposMov,aCsvFile	:= {}
    Private aCposSep
    Private nLinCsv	:= 0

    aCposCab	:= {{.F.,STR0001	,'D'	,"E5_DATA"		,0,0,nil},;//'Data Inicial'
    {.F.,STR0002	,'D'	,"E5_DATA"		,0,0,nil},;//'Data Final'
    {.F.,STR0003	,'C'	,"E5_BANCO"		,0,0,nil},;//'Cod. Banco'
    {.F.,STR0004	,'C'	,"E5_AGENCIA"	,0,0,nil},;//'Cod. Agencia'
    {.F.,STR0005	,'C'	,"E5_CONTA"		,0,0,nil},;//'Conta'
    {.F.,STR0006	,'N'	,"E5_VALOR"		,0,0,nil}}//'Saldo Anterior'

    aCposMov	:= {{.F.,STR0007	,'D'	,"E5_DATA"		,0,0,nil},;//'Data Movimento'
    {.F.,STR0008	,'C'	,"E5_NUMERO"	,0,0,nil},;//'Num. Movimento'
    {.F.,STR0009	,'N'	,"E5_VALOR"		,0,0,nil},;//'Vlr Lançamento'
    {.F.,STR0010	,'C'	,"EJ_OCORBCO"	,0,0,nil},;//'Tipo Lançamento'
    {.F.,STR0011	,'C'	,"E5_HISTOR"	,0,0,nil},;//'Desc. Lançamento'
    {.F.,STR0012	,'N'	,"E5_VALOR"		,0,0,nil},;//'Saldo'
    {.F.,STR0013	,'C'	,"E5_MOEDA"		,0,0,nil}}//'Moeda'

    //--- Para os Separadores
    aCposSep	:= {{ .F. , nil	, SPACE(1) },;  // 'Separador Arquivo'
    { .F. , nil	, SPACE(1) },;  // 'Separador Decimais'
    { .F. , "N"	, 0 } }         // 'Digitos Menos Significativos'
	/*/
    ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    ³ Arquivo de Com.Bancaria angola configuravel   ³
    ³  de acordo com arquivo CSV enviado pelo Banco ³
    ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	/*/

    // ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    // ³ Recupera o desenho padrao de atualizacoes                   ³
    // ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    DEFINE MSDIALOG oDlg FROM  94,1 TO 243,295 TITLE OemToAnsi(STR0014) PIXEL // "Configura‡„o Reconciliação Bancario"

    @ 10,17 Say OemToAnsi(STR0015) SIZE 150,7 OF oDlg PIXEL  // "Estrutura‡„o dos arquivos de LayOut utilizados"
    @ 18,30 Say OemToAnsi(STR0016) SIZE 100,7 OF oDlg PIXEL  // "na reconciliação banc ria."

    @ 48, 005 Button OemToAnsi(STR0017)     SIZE 33, 11 OF oDlg PIXEL   Action(nOpcf:=1,TipoFile(),MudaArq()   ,If(!Empty(cFile),EditExtr(oDlg),nOpcf:=0))       Font oDlg:oFont // "Novo"
    @ 48, 040 Button OemToAnsi(STR0018)     SIZE 33, 11 OF oDlg PIXEL   Action(nOpcf:=2,TipoFile(),MudaArq()   ,If(!Empty(cFile),RestFile(oDlg),nOpcf:=0))       Font oDlg:oFont // "Restaura"
    @ 48, 075 Button OemToAnsi(STR0019)     SIZE 33, 11 OF oDlg PIXEL   Action(nOpcf:=3,TipoFile(),MudaArq()   ,If(!Empty(cFile),RestFile(oDlg,.T.),nOpcf:=0))   Font oDlg:oFont // "Excluir"
    @ 48, 110 Button OemToAnsi(STR0020)     SIZE 33, 11 OF oDlg PIXEL   Action(nopcf:=4,oDlg:End())                                                                 Font oDlg:oFont // "Cancelar"

    ACTIVATE MSDIALOG oDlg CENTERED


	/*
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Fun‡…o    ³MudaArq   ³ Autor ³ Acacio Egas           ³ Data ³ 03.09.09 ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡…o ³ Escolhe arquivo ou cria arquivo para padroniza‡Æo CNAB     ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Sintaxe   ³ MudaArq()                                                  ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Parametros³                                                            ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	*/

Static Function MudaArq()

    Local cFileChg
    Local cMask := OemToAnsi( STR0044 )  // "Retorno (*.REC)|*.rec|"
    If  Empty(cType)
        cType   :=Iif(nOpcf==1,OemToAnsi(STR0022)+'*.REC',OemToAnsi(STR0022)+'*.REC')   // "Retorno | "
    Endif

    If cPaisLoc == "ARG"

        cFileChg := cGetFile( cMask, OemToAnsi( STR0045 ) + Subs(cType,1,7) ) // "Selecione arquivo "

    Else

        cFileChg    :=cGetFile(cType, OemToAnsi(OemToAnsi(STR0023)+Subs(cType,1,7) )) // "Selecione arquivo "

    Endif

    If  Empty(cFileChg)
        cFile:=""
        Return
    Endif

    If  "."$cFileChg
        cFileChg := Substr(cFileChg,1,rat(".", cFileChg)-1)
    Endif

    cFileChg    := alltrim(cFileChg)
    cFile       := Alltrim(cFileChg+Right(cType,4))

    If  nOpcf == 1
        If  File(cFile)
            cFile:=""
            Help(" ",1,"AX023EXIST")
            Return
        Endif
    Else
        cType   :="Retorno | "+cFile
    Endif

Return


	/*
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Fun‡…o    ³EditEXTR  ³ Autor ³ Acacio Egas           ³ Data ³ 03.09.09 ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡…o ³Edita LayOut do arquivo de Extratos por CSV                 ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Sintaxe   ³EditExtr(oDlg,cFile)                                        ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Parametros³oDlg     - Objeto pai da janela                             ³±±
	±±³          ³lDele    - Arquivo a ser Criado/Editado                     ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³ Uso      ³ MATCONF                                                    ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	*/

Static Function EditEXTR(oDlg,lDele)

    Local oDlgLayOut
    Local oMsmAuto,oGdMov,oGetFile,cFileCSV
    Local oOk := LoadBitmap( GetResources(), "LBOK" )
    Local oNo := LoadBitmap( GetResources(), "LBNO" )
    Local aCols,aHeader,aSize
    Local nX
    Local lRefresh := .T.

    //--- Caracter Separador de Arquivo
    Local cChrSepFil := SPACE( 1 )
    Local oChrSepFil

    //--- Caracter Separador de Casa Decimal
    Local cChrSepDec := SPACE( 1 )
    Local oChrSepDec

    //--- Qtde de Digitos Menos Significativos
    Local nChrMenSig := 0
    Local oChrMenSig

    Default lDele	:= .F.

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Se eh um Novo Retorno, reinicia os arrays ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    If nOpcf == 1

        aCposCab	:= {{.F.,STR0001	,'D'	,"E5_DATA"		,0,0,nil},;//'Data Inicial'
        {.F.,STR0002	,'D'	,"E5_DATA"		,0,0,nil},;//'Data Final'
        {.F.,STR0003	,'C'	,"E5_BANCO"		,0,0,nil},;//'Cod. Banco'
        {.F.,STR0004	,'C'	,"E5_AGENCIA"	,0,0,nil},;//'Cod. Agencia'
        {.F.,STR0005	,'C'	,"E5_CONTA"		,0,0,nil},;//'Conta'
        {.F.,STR0006	,'N'	,"E5_VALOR"		,0,0,nil}}//'Saldo Anterior'

        aCposMov	:= {{.F.,STR0007	,'D'	,"E5_DATA"		,0,0,nil},;//'Data Movimento'
        {.F.,STR0008	,'C'	,"E5_NUMERO"	,0,0,nil},;//'Num. Movimento'
        {.F.,STR0009	,'N'	,"E5_VALOR"		,0,0,nil},;//'Vlr Lançamento'
        {.F.,STR0010	,'C'	,"EJ_OCORBCO"	,0,0,nil},;//'Tipo Lançamento'
        {.F.,STR0011	,'C'	,"E5_HISTOR"	,0,0,nil},;//'Desc. Lançamento'
        {.F.,STR0012	,'N'	,"E5_VALOR"		,0,0,nil},;//'Saldo'
        {.F.,STR0013	,'C'	,"E5_MOEDA"		,0,0,nil}}//'Moeda'

        //--- Para os Separadores
        aCposSep	:= {{ .F. , nil	, SPACE(1) },;  // 'Separador Arquivo'
        { .F. , nil	, SPACE(1) },;  // 'Separador Decimais'
        { .F. , "N"	, 0 } }         // 'Digitos Menos Significativos'

    Else

        cChrSepFil := aCposSep[ 1 ][ 3 ]
        cChrSepDec := aCposSep[ 2 ][ 3 ]
        nChrMenSig := aCposSep[ 3 ][ 3 ]

    EndIf
    Do While lRefresh
        lRefresh	:= .F.
        oMsmAuto	:= nil
        oGdMov		:= nil
        oGetFile	:= nil
        If cPaisLoc == "ARG"

            DEFINE MSDIALOG oDlgLayOut TITLE OemToAnsi(STR0021)+Space(05)+cFile ; // "Configura‡„o Extrato Bancario"
            FROM 4.0,0 to 44,100 OF oMainWnd

            TGroup():New( 5, 10, 110, 385,STR0022, oDlgLayOut,/*<nClrFore>*/,/*<nClrBack>*/,.T./* <.lPixel.>*/,/*[<.lDesign.>]*/)//"Cabeçalho"

            oLstCpoCab	:= TWBrowse():New( 15, 20, 75, 85,,{"",STR0023,STR0024},{5,10,20},oDlgLayOut,/*<(cField)>*/,/*<uValue1>*/,/*<uValue2>*/,/*[<{uChange}>]*/,{|nRow,nCol,nFlags| CabecInc(oLstCpoCab,nCol,@aCposCab),RunMsmGet(@oMsmAuto,aCposCab) },/*[\{|nRow,nCol,nFlags|<uRClick>\}]*/,/*<oFont>*/,/*<oCursor>*/,/*<nClrFore>*/,/*<nClrBack>*/,/*<cMsg>*/,/*<.update.>*/,/*<cAlias>*/,.T./*<.pixel.>*/,/*<{uWhen}>*/,/*<.design.>*/,/*<{uValid}>*/,/*<{uLClick}>*/,/*[\{<{uAction}>\}]*/ )//"Campos"##"Tipo"
            oLstCpoCab:SetArray(aCposCab)
            oLstCpoCab:bLine := {|| {If(aCposCab[oLstCpoCab:nAT,01],oOk,oNo),aCposCab[oLstCpoCab:nAT,02],aCposCab[oLstCpoCab:nAT,03]} }

            RunMsmGet(@oMsmAuto,aCposCab)

            oPnlBot	:= 	TGroup():New( 120, 10, 240, 385,STR0025, oDlgLayOut,/*<nClrFore>*/,/*<nClrBack>*/,.T./* <.lPixel.>*/,/*[<.lDesign.>]*/)//"Lançamentos"

            oLstCpoMov	:= TWBrowse():New( 130, 20, 75, 105,,{"",STR0023,STR0024},{5,20,10},oDlgLayOut,/*<(cField)>*/,/*<uValue1>*/,/*<uValue2>*/,/*[<{uChange}>]*/,{|nRow,nCol,nFlags| GridInc(oLstCpoMov,nCol,@aCposMov),lRefresh := .T.,oDlgLayOut:End() },/*[\{|nRow,nCol,nFlags|<uRClick>\}]*/,/*<oFont>*/,/*<oCursor>*/,/*<nClrFore>*/,/*<nClrBack>*/,/*<cMsg>*/,/*<.update.>*/,/*<cAlias>*/,.T./*<.pixel.>*/,/*<{uWhen}>*/,/*<.design.>*/,/*<{uValid}>*/,/*<{uLClick}>*/,/*[\{<{uAction}>\}]*/ )//"Campos"##"Tipo"
            oLstCpoMov:SetArray(aCposMov)
            oLstCpoMov:bLine := {|| {If(aCposMov[oLstCpoMov:nAT,01],oOk,oNo),aCposMov[oLstCpoMov:nAT,02],aCposMov[oLstCpoMov:nAT,03]} }

            RunGrid(@oGdMov,aCposMov,@aCols,@aHeader,@aSize)

            //--- Separador de Arquivo ----
            @ C(200),C(010) Say STR0046 Size C(042),C(008) COLOR CLR_BLACK PIXEL OF oDlgLayOut //"Separador de Arquivo"
            @ C(198),C(060) MsGet oChrSepFil  Var cChrSepFil Size C(010),C(010) Valid (ChkSepa( "cChrSepFil", cChrSepFil ) ) COLOR CLR_BLACK Picture "@!" PIXEL OF oDlgLayOut

            //--- Separador de Casa Decimal ----
            @ C(200),C(080) Say STR0047 Size C(055),C(008) COLOR CLR_BLACK PIXEL OF oDlgLayOut //"Separador de Casa Decimal"
            @ C(198),C(142) MsGet oChrSepDec  Var cChrSepDec Size C(010),C(010) Valid (ChkSepa( "cChrSepDec", cChrSepDec ) ) COLOR CLR_BLACK Picture "@!" PIXEL OF oDlgLayOut

            //--- Quantidade de Digitos menos Significativos
            @ C(200),C(170) Say STR0055 Size C(070),C(008) COLOR CLR_BLACK PIXEL OF oDlgLayOut //"Qtde Digitos menos Significativos"
            @ C(198),C(245) MsGet oChrMenSig  Var nChrMenSig Size C(010),C(010) Valid (ChkSepa( "nChrMenSig", nChrMenSig ) ) Picture "9" COLOR CLR_BLACK Picture "@!" PIXEL OF oDlgLayOut

            @ C(220),C(010) Say STR0026 Size C(037),C(008) COLOR CLR_BLACK PIXEL OF oDlgLayOut //"Arquivo Exemplo"
            @ C(220),C(135) BUTTON "..." PIXEL SIZE 10,10 ACTION (cFileCSV := cGetFile(STR0027,STR0028,1),aCsvFile	:= CFG57Csv(cFileCSV),lRefresh := .T.,oDlgLayOut:End())//'Arquivo de importação de Tipo csv.'##'Escolha o arquivo'
            @ C(218),C(060) MsGet oGetFile Var cFileCSV Size C(075),C(010) valid (File(cFileCSV).or.Empty(cFileCSV)) COLOR CLR_BLACK Picture "@!" PIXEL OF oDlgLayOut

            @ C(220),C(220) Button If(lDele,STR0043,STR0029) Size C(025),C(010) ACTION {|| If( lDele, DeleFile(), If( ChkGlobo(.T.), SaveFile(), ) ), If( ChkGlobo(.F.), oDlgLayOut:End(), ) } PIXEL OF oDlgLayOut //"Salvar"
            @ C(220),C(260) Button STR0032 Size C(025),C(010) ACTION {|| oDlgLayOut:End() } PIXEL OF oDlgLayOut //"Sair"

            ACTIVATE DIALOG oDlgLayOut

        Else
            DEFINE MSDIALOG oDlgLayOut TITLE OemToAnsi(STR0021)+Space(05)+cFile ; // "Configura‡„o Extrato Bancario"
            FROM 8.0,0 to 44,100 OF oMainWnd

            TGroup():New( 5, 10, 110, 385,STR0022, oDlgLayOut,/*<nClrFore>*/,/*<nClrBack>*/,.T./* <.lPixel.>*/,/*[<.lDesign.>]*/)//"Cabeçalho"

            oLstCpoCab	:= TWBrowse():New( 15, 20, 75, 85,,{"",STR0023,STR0024},{5,10,20},oDlgLayOut,/*<(cField)>*/,/*<uValue1>*/,/*<uValue2>*/,/*[<{uChange}>]*/,{|nRow,nCol,nFlags| CabecInc(oLstCpoCab,nCol,@aCposCab),RunMsmGet(@oMsmAuto,aCposCab) },/*[\{|nRow,nCol,nFlags|<uRClick>\}]*/,/*<oFont>*/,/*<oCursor>*/,/*<nClrFore>*/,/*<nClrBack>*/,/*<cMsg>*/,/*<.update.>*/,/*<cAlias>*/,.T./*<.pixel.>*/,/*<{uWhen}>*/,/*<.design.>*/,/*<{uValid}>*/,/*<{uLClick}>*/,/*[\{<{uAction}>\}]*/ )//"Campos"##"Tipo"
            oLstCpoCab:SetArray(aCposCab)
            oLstCpoCab:bLine := {|| {If(aCposCab[oLstCpoCab:nAT,01],oOk,oNo),aCposCab[oLstCpoCab:nAT,02],aCposCab[oLstCpoCab:nAT,03]} }

            RunMsmGet(@oMsmAuto,aCposCab)

            oPnlBot	:= 	TGroup():New( 120, 10, 240, 385,STR0025, oDlgLayOut,/*<nClrFore>*/,/*<nClrBack>*/,.T./* <.lPixel.>*/,/*[<.lDesign.>]*/)//"Lançamentos"

            oLstCpoMov	:= TWBrowse():New( 130, 20, 75, 105,,{"",STR0023,STR0024},{5,20,10},oDlgLayOut,/*<(cField)>*/,/*<uValue1>*/,/*<uValue2>*/,/*[<{uChange}>]*/,{|nRow,nCol,nFlags| GridInc(oLstCpoMov,nCol,@aCposMov),lRefresh := .T.,oDlgLayOut:End() },/*[\{|nRow,nCol,nFlags|<uRClick>\}]*/,/*<oFont>*/,/*<oCursor>*/,/*<nClrFore>*/,/*<nClrBack>*/,/*<cMsg>*/,/*<.update.>*/,/*<cAlias>*/,.T./*<.pixel.>*/,/*<{uWhen}>*/,/*<.design.>*/,/*<{uValid}>*/,/*<{uLClick}>*/,/*[\{<{uAction}>\}]*/ )//"Campos"##"Tipo"
            oLstCpoMov:SetArray(aCposMov)
            oLstCpoMov:bLine := {|| {If(aCposMov[oLstCpoMov:nAT,01],oOk,oNo),aCposMov[oLstCpoMov:nAT,02],aCposMov[oLstCpoMov:nAT,03]} }

            RunGrid(@oGdMov,aCposMov,@aCols,@aHeader,@aSize)

            @ C(195),C(010) Say STR0026 Size C(037),C(008) COLOR CLR_BLACK PIXEL OF oDlgLayOut //"Arquivo Exemplo"
            @ C(195),C(135) BUTTON "..." PIXEL SIZE 10,10 ACTION (cFileCSV := cGetFile(STR0027,STR0028,1),aCsvFile	:= CFG57Csv(cFileCSV),lRefresh := .T.,oDlgLayOut:End())//'Arquivo de importação de Tipo csv.'##'Escolha o arquivo'
            @ C(193),C(060) MsGet oGetFile Var cFileCSV Size C(075),C(010) valid (File(cFileCSV).or.Empty(cFileCSV)) COLOR CLR_BLACK Picture "@!" PIXEL OF oDlgLayOut

            @ C(195),C(220) Button If(lDele,STR0043,STR0029) Size C(025),C(010) ACTION {|| Processa({|| If(lDele,DeleFile(),SaveFile())},STR0030,STR0031,.F.),oDlgLayOut:End() } PIXEL OF oDlgLayOut //"Salvar"##"Processando"##"Aguarde , Importando Dados..."##"Deletar"
            @ C(195),C(260) Button STR0032 Size C(025),C(010) ACTION {|| oDlgLayOut:End() } PIXEL OF oDlgLayOut //"Sair"

            ACTIVATE DIALOG oDlgLayOut
        EndIf
    EndDo

Return

	/*/
    ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
    ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
    ±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
    ±±³Fun‡…o    ³ RestFile ³ Autor ³ Acacio Egas           ³ Data ³ 03/09/0  ³±±
    ±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
    ±±³Descri‡…o ³ Restaura arquivos de Comunicacao Bancaria ja Configurados  ³±±
    ±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
    ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
    ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	/*/
Static Function RestFile(oDlg,lDele)

    CFG57Load( cFile, aCposCab, aCposMov, aCposSep )

    lDele:=IIF(lDele==NIL,.F.,lDele)

    EditExtr(oDlg,lDele)

Return

	/*/
    ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
    ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
    ±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
    ±±³Fun‡…o    ³ ChkSepa  ³ Autor ³ Carlos E. Chigres     ³ Data ³ 14/09/12 ³±±
    ±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
    ±±³Descri‡…o ³ Validacao nas variaveis de Caracteres Separadores          ³±±
    ±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
    ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
    ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	/*/
Static Function ChkSepa( cNomSepa, xConteud )

    Local lRet := .T.

    If cNomSepa == "cChrSepFil"    // Separador de Arquivo

        If Empty( xConteud )

            lRet := .F.
            // "Informação Obrigatoria"
            Aviso( STR0051, STR0053, { STR0050 }   )   // "Caracter Separador de Arquivo é Obrigatorio."

        Else

            aCposSep[ 1 ][ 1 ] := .T.
            aCposSep[ 1 ][ 3 ] := xConteud

        EndIf

    ElseIf cNomSepa == "cChrSepDec"    // Separador de Decimais

        If Empty( xConteud )

            lRet := .F.
            // "Informação Obrigatoria"
            Aviso( STR0051, STR0054, { STR0050 }   )   // "Caracter Separador de Decimais é Obrigatorio."

        Else

            aCposSep[ 2 ][ 1 ] := .T.
            aCposSep[ 2 ][ 3 ] := xConteud

        EndIf

    ElseIf cNomSepa == "nChrMenSig"    // Qtde Digitos Menos Significativos

        aCposSep[ 3 ][ 1 ] := .T.
        aCposSep[ 3 ][ 3 ] := xConteud

    EndIf

Return( lRet )

	/*/
    ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
    ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
    ±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
    ±±³Fun‡…o    ³ ChkGlobo ³ Autor ³ Carlos E. Chigres     ³ Data ³ 14/09/12 ³±±
    ±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
    ±±³Descri‡…o ³ Acionada pelo botao SALVAR, somente Localizacao            ³±±
    ±±³          ³ Argentina, valida a presenca dos caracteres delimitadores  ³±±
    ±±³          ³ e validacoes correlatas.                                   ³±±
    ±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
    ±±³Parametros³ True Modo Normal / .F. Modo Silent                         ³±±
    ±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
    ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
    ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	/*/
Static Function ChkGlobo( lSilent )

    Local lRet      := .T.
    Local nX        := 1
    Local lMovimen  := .F.
    Local lSepara   := .F.

    //--- Linha do array aCposSep que armazena a Qtde de Digitos Separadores ---
    Local nLinMenSig := 3

    Default lSilent := .T.

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Realiza verificacao de preenchimento do array de Movimentacoes, ja que Header nao eh obrigatorio ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    nX := aScan( aCposMov, {|x| x[1] == .T. } )

    lMovimen := ( nX > 0 )

    If lMovimen

        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Realiza verificacao de preenchimento do array de Caracteres ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        //
        lSepara := aCposSep[1][1] .And. aCposSep[2][1]
        //
        If lSepara

            If aCposSep[ 1 ][ 3 ] == aCposSep[ 2 ][ 3 ]
                //
                lRet := .F.
                //--- "Inconsistencia"
                If lSilent
                    Aviso( STR0048, STR0056, { STR0050 } ) // "Os Caracteres Separadores nao podem ser iguais." //###"Sair"
                EndIf
                //
            EndIf

        Else

            lRet := .F.
            //--- "Informação Obrigatoria"
            If lSilent
                Aviso( STR0051, STR0052, { STR0050 } ) // "Todos os Caracteres Separadores devem ser preenchidos." //###"Sair"
            EndIf

        EndIf

    Else

        lRet := .F.
        // "Inconsistencia"
        If lSilent
            Aviso( STR0048, STR0049, { STR0050 } ) // "Não existem informações de Lançamento a serem gravadas nessa Configuração."  //###"Sair"
        EndIf

    EndIf

Return( lRet )

	/*
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Fun‡…o    ³ SaveFile ³ Autor ³ Acacio Egas           ³ Data ³ 03/09/0  ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡…o ³ Salva arquivos de Comunicacao Bancaria ja Configurados     ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	*/
Static Function SaveFile()

    Local nX        := 1
    Local cRegA     := " "
    Local cFileback :=cFile
    //--- Linha do array aCposSep que armazena a Qtde de Digitos Separadores ---
    Local nLinMenSig := 3


    IF  nOpcf == 2
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Escolhe o nome do Arquivo a ser salvo                        ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        //MudaArq()
        If  Empty(cFile)
            Return .F.
        Endif

        If  cFile#cFileBack .AND. File(cFile)
            If  !MsgYesNo(OemToAnsi(STR0033),OemToAnsi(STR0034)) // "Arquivo LayOut j  existe grava por cima" ### "LayOut Extrato"
                cFile   :=""
                Return .F.
            Endif
        Endif
    Else
        If  !MsgYesNo(OemToAnsi(STR0035),OemToAnsi(STR0036)) // "Confirma Grava‡„o do arquivo LayOut" ### "LayOut Extrato"
            Return .F.
        Endif
    EndIF

    fClose(nBcoHdl)
    nBcoHdl:=MSFCREATE(cFile,0)

    FSEEK(nBcoHdl,0,0)


    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Gravacao dos Caracteres Separadores ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    If cPaisLoc == "ARG"

        For nX := 1 TO Len( aCposSep )

            If aCposSep[nX][1]

                If nX == nLinMenSig

                    cRegA := "#Sep#" + StrZero(nX,3) + Str( aCposSep[nX][3], 1 ) + Space(245)

                Else

                    cRegA := "#Sep#" + StrZero(nX,3) + aCposSep[nX][3] + Space(245)

                EndIf

                FWRITE(nBcoHdl,cRegA+CHR(13)+CHR(10),256)   //grava nova linha

            EndIf

        Next nX

    EndIf

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Gravacao do Cabecalho ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    For nX := 1 to Len(aCposCab)
        If aCposCab[nX,1]
            cRegA	:= "#Cab#" + StrZero(nX,3) + StrZero(aCposCab[nX,5],3) + StrZero(aCposCab[nX,6],3) + SubStr(aCposCab[nX,7],1,240) + Space(240-Len(aCposCab[nX,7]))
            FWRITE(nBcoHdl,cRegA+CHR(13)+CHR(10),256)   //grava nova linha
        EndIf

    Next

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Gravacao dos Lancamentos ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    For nX := 1 to Len(aCposMov)
        If aCposMov[nX,1]
            cRegA	:= "#Lan#" + StrZero(nX,3) + StrZero(aCposMov[nX,5],3) + Space(3) + SubStr(aCposMov[nX,7],1,240) + Space(240-Len(aCposMov[nX,7]))
            FWRITE(nBcoHdl,cRegA+CHR(13)+CHR(10),256)   //grava nova linha
        EndIf

    Next

    FCLOSE(nBcoHdl)
Return .T.


	/*
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Fun‡…o    ³ DeleFile ³ Autor ³ Acacio Egas           ³ Data ³ 03/09/09 ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡…o ³ Deleta   arquivos de Comunicacao Bancaria ja Configurados  ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	*/
Static Function DeleFile()

    If MsgYesNo(OemToAnsi(STR0037),OemToAnsi(STR0038)) // "Deleta arquivo LayOut"  ### "LayOut Extrato"
        FCLOSE(nBcoHdl)
        FERASE(cFile)
    Endif

Return .T.


	/*
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Fun‡…o    ³ CabecInc ³ Autor ³ Acacio Egas           ³ Data ³ 03.09.09 ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡…o ³ Atualiza cabec da configuração do CSV.                     ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	*/

Static Function CabecInc(oLst,nCol,aCposCab)

    Local aParam := {}
    Local aRet	:= {}
    If nCol==1

        If !aCposCab[oLst:nAt,nCol]
            aAdd(aParam,{1,STR0039,0,"@E",".T.",,".T.",50,.T.}) //"Linha:"
            aAdd(aParam,{1,STR0040,0,"@E",".T.",,".T.",50,.T.})//"Celula:"
            aAdd(aParam,{1,STR0041,Space(240),"@!",".T.",,".T.",50,.F.})//"Bloco de Codigo:"
            If Parambox(aParam,STR0042,aRet) //"Localização no arquivo"
                aCposCab[oLst:nAt,nCol]	:= !aCposCab[oLst:nAt,nCol]
                aCposCab[oLst:nAt,5]	:= aRet[1]
                aCposCab[oLst:nAt,6]	:= aRet[2]
                aCposCab[oLst:nAt,7]	:= aRet[3]
                oLst:Refresh()
            EndIf
        Else
            aCposCab[oLst:nAt,nCol]	:= !aCposCab[oLst:nAt,nCol]
            aCposCab[oLst:nAt,5]	:= 0
            aCposCab[oLst:nAt,6]	:= 0
        EndIf
    EndIf
Return

	/*
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Fun‡…o    ³ RunMsmGet³ Autor ³ Acacio Egas           ³ Data ³ 03.09.09 ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡…o ³ Atualiza MsmGet do cabecalho da configuração do CSV.       ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	*/
Static Function RunMsmGet(oBj,aCposCab)

    Local nX
    Local aCpoGets	:= {}

    If ValType(oBj)=="O"
        oBj:oBox:FreeChildren()
    EndIf

    If aScan(aCposCab,{|x| x[1]==.T.})>0
        For nX := 1 to Len(aCposCab)
            If aCposCab[nX,1]
                If Len(aCsvFile)>=aCposCab[nX,5] .and. Len(aCsvFile[aCposCab[nX,5]])>=aCposCab[nX,6]
                    If !Empty(aCposCab[nX,7])
                        cRet := eVal(MontaBlock("{ |x| " + aCposCab[nX,7] + " }"),aCsvFile[aCposCab[nX,5],aCposCab[nX,6]])
                        //If VALTYPE(cRet)==aCposCab[nX,3]
                        _SetOwnerPrvt("CPO" + StrZero(Nx,3),cRet)
                        //Else
                        //	_SetOwnerPrvt("CPO" + StrZero(Nx,3),,CriaVar(Trim(aCposCab[nX,4]),.F.))
                        //EndIf
                    Else
                        _SetOwnerPrvt("CPO" + StrZero(Nx,3),aCsvFile[aCposCab[nX,5],aCposCab[nX,6]])
                    EndIf
                    nLinCsv := Nx
                Else
                    _SetOwnerPrvt("CPO" + StrZero(Nx,3),CriaVar(Trim(aCposCab[nX,4]),.F.))
                EndIf
                SX3->(DbSetOrder(2))
                SX3->( MsSeek( PadR(aCposCab[nX,4], 10 ) ) )
                // Criando campos para a MsmGet
                ADD FIELD aCpoGets TITULO aCposCab[nX,2] CAMPO "CPO" + StrZero(Nx,3) TIPO SX3->X3_TIPO 	TAMANHO SX3->X3_TAMANHO DECIMAL SX3->X3_DECIMAL PICTURE PesqPict(SX3->X3_ARQUIVO,SX3->X3_CAMPO) VALID (SX3->X3_VALID) OBRIGAT NIVEL SX3->X3_NIVEL F3 SX3->X3_F3 BOX SX3->X3_CBOX FOLDER 1
            EndIf
        Next
        DbSelectArea("SE5")
        oBj := MsMGet():New("SE5",SE5->(RECNO()),4,,,,,{15, 110, 100, 375},,4,,,,,,,,,,.T.,aCpoGets)
        oBj:Disable()
    Endif
Return

	/*
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Fun‡…o    ³ GridInc  ³ Autor ³ Acacio Egas           ³ Data ³ 03.09.09 ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡…o ³ Atualiza configuração de movimentos do CSV.                ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	*/
Static Function GridInc(oLst,nCol,aCposMov)

    Local aParam := {}
    Local aRet	:= {}
    If nCol==1
        If !aCposMov[oLst:nAt,nCol]
            aAdd(aParam,{1,STR0040,0,"@E",".T.",,".T.",50,.T.})//"Celula:"
            aAdd(aParam,{1,STR0041,Space(240),"@!",".T.",,".T.",50,.F.})//"Bloco de Codigo:"
            If Parambox(aParam,STR0040,aRet)//"Celula:"
                aCposMov[oLst:nAt,nCol]	:= !aCposMov[oLst:nAt,nCol]
                aCposMov[oLst:nAt,5]	:= aRet[1]
                aCposMov[oLst:nAt,7]	:= aRet[2]
                oLst:Refresh()
            EndIf
        Else
            aCposMov[oLst:nAt,nCol]	:= !aCposMov[oLst:nAt,nCol]
            aCposMov[oLst:nAt,5]	:= 0
            aCposMov[oLst:nAt,7]	:= ''
        EndIf
    EndIf
Return

	/*
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Fun‡…o    ³ RunGrid  ³ Autor ³ Acacio Egas           ³ Data ³ 03.09.09 ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡…o ³ Atualiza grid com a configuração do CSV.                   ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	*/
Static Function	RunGrid(oGdMov,aCposMov,aCols,aHeader,aSize)

    Local lSavLinha	:= .T.
    Local nX,nY,nZ
    Local aCposOk := {}

    If aScan(aCposMov,{|x| x[1]==.T.})>0

        aCols	:= {}
        aSize	:= {}
        If Len(aCsvFile)>nLinCsv
            //****************************
            // Monta arquivo CSV na grid *
            //****************************
            For nX := nLinCsv + 1 to Len(aCsvFile)
                aLinha	:= {}
                lSavLinha	:= .T.
                For nY := 1 to Len(aCposMov)
                    If aCposMov[nY,1]
                        aAdd(aCposOk,aCposMov[nY,2])
                        aAdd(aSize,20)
                        If Len(aCsvFile[nX])>=aCposMov[nY,5]
                            If !Empty(aCposMov[nY,7])
                                cRet := eVal(MontaBlock("{ |x| " + aCposMov[nY,7] + " }"),aCsvFile[nX,aCposMov[nY,5]])
                                //If VALTYPE(cRet)==aCposMov[nY,3]
                                aAdd(aLinha,cRet)
                                //EndIf
                            Else
                                aAdd(aLinha,aCsvFile[nX,aCposMov[nY,5]])
                            EndIf
                        else
                            Exit
                            lSavLinha	:= .F.
                        EndIf
                    EndIf
                Next
                If lSavLinha
                    aAdd(aCols,aLinha)
                EndIf
            Next
        EndIf
        If Len(aCols)==0
            //***********************
            // Monta grid em branco *
            //***********************
            aAdd(aCols,{})
            For nY := 1 to Len(aCposMov)
                If aCposMov[nY,1]
                    aAdd(aCposOk,aCposMov[nY,2])
                    aAdd(aSize,20)
                    aAdd(aCols[1],CriaVar(aCposMov[nY,4],.F.))
                EndIf
            Next
        EndIf
        oGdMov	:= TWBrowse():New( 130,110, 265, 105,,aCposOk,aSize,,/*<(cField)>*/,/*<uValue1>*/,/*<uValue2>*/,/*[<{uChange}>]*/,/*{|nRow,nCol,nFlags| DblCLick() }*/,/*[\{|nRow,nCol,nFlags|<uRClick>\}]*/,/*<oFont>*/,/*<oCursor>*/,/*<nClrFore>*/,/*<nClrBack>*/,/*<cMsg>*/,/*<.update.>*/,/*<cAlias>*/,.T./*<.pixel.>*/,/*<{uWhen}>*/,/*<.design.>*/,/*<{uValid}>*/,/*<{uLClick}>*/,/*[\{<{uAction}>\}]*/ )
        oGdMov:SetArray(aCols)
        oGdMov:bLine := {|| aCols[oGdMov:nAT] }

    EndIf
Return

	/*
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Fun‡…o    ³ CFG57Csv ³ Autor ³ Acacio Egas           ³ Data ³ 03.09.09 ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡…o ³ Le o arquivo CSV e retorna em Array.                       ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	*/
Function CFG57Csv(cFileCSV)

    Local cMemo,xBuffer,xBufGet	:= ""
    Local aLinha,aRet	:= {}
    Local nTamArq,nBytes	:= 0

    Local cChrSepFil := ""
    Local cTarget    := cChrSepFil+cChrSepFil
    Local cReplace   := cChrSepFil + Space( 3 ) + cChrSepFil


    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Recupera a informacao do Separador ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    If cPaisLoc == "ARG"

        If aCposSep[ 1 ][ 1 ]

            cChrSepFil := aCposSep[ 1 ][ 3 ]

        EndIf

    EndIf

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Valida a informacao do Separador ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    If Empty( cChrSepFil )
        cChrSepFil := ";"  // Separador Default
    EndIf
    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Constroi as variaveis para o StrTran e StrTokArr ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    cTarget  := cChrSepFil+cChrSepFil
    cReplace := cChrSepFil + Space( 3 ) + cChrSepFil


    If File(cFileCSV)

        nBcoHdl :=FOPEN(cFileCSV,2+64)
        If nBcoHdl==-1
            Help(" ",1,"AX023BCO")
        Else

            nTamArq := FSEEK( nBcoHdl, 0, 2 )

            FSEEK( nBcoHdl, 0, 0 )

            aRet	:= {}
            xBuffer := ""

            While nBytes < nTamArq
                FREAD( nBcoHdl, @xBufGet, 256 )
                xBuffer += xBufGet

                //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                //³ Execute ate encontrar os caracteres de final de linha ³
                //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                Do While ( nI := AT( CHR(13)+CHR(10), xBuffer ) ) > 0

                    cMemo := SubStr( xBuffer, 1, nI+1 )

                    If !Empty( SubStr( cMemo, 1, Len( cMemo ) - 2 ) )

                        aLinha := StrTokArr( StrTran( SubStr( cMemo, 1, Len( cMemo ) - 2 ), cTarget, cReplace), cChrSepFil )

                        aAdd( aRet, aLinha )

                    EndIf

                    xBuffer	:= SubStr( xBuffer, nI + 2 )

                EndDo

                nBytes += 256
            EndDo

            fClose( nBcoHdl )
        EndIf
    EndIf

Return aRet

	/*
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Fun‡…o    ³ CFG57Load³ Autor ³ Acacio Egas           ³ Data ³ 03.09.09 ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡…o ³ Carrega arquivo de configração em arrays                   ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	*/
Function CFG57Load(cFile,aCposCab,aCposMov)


    Local nTamArq := 0
    Local nBytes  := 0
    Local xBuffer
    Local nBcoHdl
    Local cSeqSep := " "
    Local lRet	:= .T.

    //--- Linha do array aCposSep que armazena a Qtde de Digitos Separadores ---
    Local nLinMenSig := 3

    Default aCposCab	:= {{.F.,STR0001	,'D'	,"E5_DATA"		,0,0,nil},;//'Data Inicial'
    {.F.,STR0002	,'D'	,"E5_DATA"		,0,0,nil},;//'Data Final'
    {.F.,STR0003	,'C'	,"E5_BANCO"		,0,0,nil},;//'Cod. Banco'
    {.F.,STR0004	,'C'	,"E5_AGENCIA"	,0,0,nil},;//'Cod. Agencia'
    {.F.,STR0005	,'C'	,"E5_CONTA"		,0,0,nil},;//'Conta'
    {.F.,STR0006	,'N'	,"E5_VALOR"		,0,0,nil}}//'Saldo Anterior'

    Default aCposMov	:= {{.F.,STR0007	,'D'	,"E5_DATA"		,0,0,nil},;//'Data Movimento'
    {.F.,STR0008	,'C'	,"E5_NUMERO"	,0,0,nil},;//'Num. Movimento'
    {.F.,STR0009	,'N'	,"E5_VALOR"		,0,0,nil},;//'Vlr Lançamento'
    {.F.,STR0010	,'C'	,"EJ_OCORBCO"	,0,0,nil},;//'Tipo Lançamento'
    {.F.,STR0011	,'C'	,"E5_HISTOR"	,0,0,nil},;//'Desc. Lançamento'
    {.F.,STR0012	,'N'	,"E5_VALOR"		,0,0,nil},;//'Saldo'
    {.F.,STR0013	,'C'	,"E5_MOEDA"		,0,0,nil}}//'Moeda'

    //--- Para os Separadores
    Default aCposSep := {{ .F. , nil	, SPACE(1) },;  // 'Separador Arquivo'
    { .F. , nil	, SPACE(1) },;  // 'Separador Decimais'
    { .F. , "N"	, 0 } }         // 'Digitos Menos Significativos'

    If !File(cFile)
        cFile:=""
        lRet := .F.
        Help(" ",1,"AX023BCO")
        Return(lRet)
    Endif

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Abertura do Arquivo de Retorno ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    nBcoHdl := FOPEN( cFile, 2+64 )

    If nBcoHdl==-1
        Help(" ",1,"AX023BCO")
        lRet := .F.
    Else
        nTamArq :=FSEEK(nBcoHdl,0,2)
        FSEEK(nBcoHdl,0,0)

        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Preenche os arrays de acordo com a Identificador             ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        While nBytes < nTamArq
            xBuffer := Space(256)
            FREAD(nBcoHdl,@xBuffer,256)

            If SubStr(xBuffer,1,5)=="#Cab#"
                aCposCab[val(SubStr(xBuffer,6,3)),1]	:= .T.
                aCposCab[val(SubStr(xBuffer,6,3)),5]	:= val(SubStr(xBuffer,09,3))
                aCposCab[val(SubStr(xBuffer,6,3)),6]	:= Val(SubStr(xBuffer,12,3))
                aCposCab[val(SubStr(xBuffer,6,3)),7]	:= SubStr(xBuffer,15,240)
            ElseIf SubStr(xBuffer,1,5)=="#Lan#"
                aCposMov[val(SubStr(xBuffer,6,3)),1]	:= .T.
                aCposMov[val(SubStr(xBuffer,6,3)),5]	:= val(SubStr(xBuffer,09,3))
                aCposMov[val(SubStr(xBuffer,6,3)),7]	:= SubStr(xBuffer,15,240)
            ElseIf SubStr(xBuffer,1,5) == "#Sep#"

                cSeqSep := SubStr( xBuffer, 6, 3 )

                aCposSep[ Val( cSeqSep ) ][ 1 ] := .T.

                If Val( cSeqSep ) == nLinMenSig

                    aCposSep[ Val( cSeqSep ) ][ 3 ] := Val( SubStr( xBuffer, 9, 1 ) )

                Else

                    aCposSep[ Val( cSeqSep ) ][ 3 ] := SubStr( xBuffer, 9, 1 )

                EndIf

            EndIf

            nBytes += 256
        EndDO

        FCLOSE(nBcoHdl)
    EndIf

Return(lRet)
