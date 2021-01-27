#Include "FiveWin.ch"
#Include "Folder.ch"
#Include "CFGX055.ch"

#include "abc.ch"

#include "abc.ch"

#include "abc.ch"

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ CFGX055  ³ Autor ³ Mauricio Pequim Jr    ³ Data ³ 24.08.98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Configurador de Arquivos de Extrato - Padrao Febraban		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CFGX055()                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
FUNCTION CFGX055(void)

    // ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    // ³ Define Variaveis                                            ³
    // ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    Local bExec
    Local oDlg
    Local oRadio

    Private nOpcf   :=1
    Private aHeader :={{Space(15),Space(03),Space(03),Space(01),Space(60)}}
    Private aLancto :={{Space(15),Space(03),Space(03),Space(01),Space(60)}}
    Private aTrail  :={{Space(15),Space(03),Space(03),Space(01),Space(60)}}
    Private cFile   :=""
    Private cType   :=""
    Private nBcoHdl :=0

	/*/
    ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    ³ Arquivo de Com.Bancaria ³
    ³    Remessa/Retorno      ³
    ³                         ³
    ³ Memoria de Calculo      ³     ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    ³ Registro 1 - USUARIOS   ³     ³Identificadores          ³
    ³ - Identif    CHR(n)   1 ³     ³ CHR(1)   - Header       ³
    ³ - Descricao do Campo 15 ³     ³ CHR(2)   - Saldo Inicial³
    ³ - Posicao Inical      3 ³     ³ CHR(3)   - Lancamento   ³
    ³ - Posicao Final       3 ³     ³ CHR(4)   - Saldo Final  ³
    ³ - Decimais            1 ³     ³ CHR(5)   - Trailler     ³
    ³ - Campo/Conteudo     60 ³     ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	/*/

    aH := {	{OemToAnsi(STR0001),Space(03),Space(03),Space(01),Space(60)},; // "Codigo do Banco"
    {OemToAnsi(STR0004),Space(03),Space(03),Space(01),Space(60)},; // "Tipo Registro  "
    {OemToAnsi(STR0053),Space(03),Space(03),Space(01),Space(60)},; // "Vlr Sld Inicial"
    {OemToAnsi(STR0054),Space(03),Space(03),Space(01),Space(60)},; // "Dt. Sld Inicial"
    {OemToAnsi(STR0045),Space(03),Space(03),Space(01),Space(60)} } // "Saldo D/C      "

    aL := {	{OemToAnsi(STR0003),Space(03),Space(03),Space(01),Space(60)},; // "Codigo Agencia "
    {OemToAnsi(STR0050),Space(03),Space(03),Space(01),Space(60)},; // "Codigo C/C     "
    {OemToAnsi(STR0005),Space(03),Space(03),Space(01),Space(60)},; // "Numero Lancam. "
    {OemToAnsi(STR0006),Space(03),Space(03),Space(01),Space(60)},; // "Data Processam."
    {OemToAnsi(STR0007),Space(03),Space(03),Space(01),Space(60)},; // "Vlr Lancamento "
    {OemToAnsi(STR0052),Space(03),Space(03),Space(01),Space(60)},; // "Categoria Lcto."
    {OemToAnsi(STR0009),Space(03),Space(03),Space(01),Space(60)},; // "Desc.Lancamento"
    {OemToAnsi(STR0004),Space(03),Space(03),Space(01),Space(60)} } // "Tipo Registro  "

    aT := {	{OemToAnsi(STR0010),Space(03),Space(03),Space(01),Space(60)},; // "Dt. Saldo Final"
    {OemToAnsi(STR0011),Space(03),Space(03),Space(01),Space(60)},; // "Vlr Saldo Final"
    {OemToAnsi(STR0045),Space(03),Space(03),Space(01),Space(60)},; // "Saldo D/C      "
    {OemToAnsi(STR0004),Space(03),Space(03),Space(01),Space(60)},; // "Tipo Registro  "
    {OemToAnsi(STR0012),Space(03),Space(03),Space(01),Space(60)},; // "Total Debitos  "
    {OemToAnsi(STR0013),Space(03),Space(03),Space(01),Space(60)} } // "Total Creditos "

    // ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    // ³ Recupera o desenho padrao de atualizacoes                   ³
    // ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    //DEFINE MSDIALOG oDlg FROM  94,1 TO 243,295 TITLE OemToAnsi(STR0029) PIXEL // "Configura‡„o Extrato Bancario"
    //
    //@ 10,17 Say OemToAnsi(STR0015) SIZE 150,7 OF oDlg PIXEL  // "Estrutura‡„o dos arquivos de LayOut utilizados"
    //@ 18,30 Say OemToAnsi(STR0017) SIZE 100,7 OF oDlg PIXEL  // "na comunica‡„o banc ria (Extratos)."
    //
    //@ 48, 005 Button OemToAnsi(STR0018)     SIZE 33, 11 OF oDlg PIXEL   Action(nOpcf:=1,TipoFile(),MudaArq()   ,If(!Empty(cFile),EditExtr(oDlg),nOpcf:=0))       Font oDlg:oFont // "Novo"
    //@ 48, 040 Button OemToAnsi(STR0019)     SIZE 33, 11 OF oDlg PIXEL   Action(nOpcf:=2,TipoFile(),MudaArq()   ,If(!Empty(cFile),RestFile(oDlg),nOpcf:=0))       Font oDlg:oFont // "Restaura"
    //@ 48, 075 Button OemToAnsi(STR0020)     SIZE 33, 11 OF oDlg PIXEL   Action(nOpcf:=3,TipoFile(),MudaArq()   ,If(!Empty(cFile),RestFile(oDlg,.T.),nOpcf:=0))   Font oDlg:oFont // "Excluir"
    //@ 48, 110 Button OemToAnsi(STR0021)     SIZE 33, 11 OF oDlg PIXEL   Action(nopcf:=4,oDlg:End())                                                                 Font oDlg:oFont // "Cancelar"
    //
    //ACTIVATE MSDIALOG oDlg CENTERED


	/*
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Fun‡…o    ³MudaArq   ³ Autor ³ Mauricio Pequim Jr    ³ Data ³ 24.08.98 ³±±
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
    Local cCheck
    Local cBack     := cFile

    If  Empty(cType)
        cType   :=Iif(nOpcf==1,OemToAnsi(STR0022)+'SIGA.REC',OemToAnsi(STR0022)+'*.REC')   // "Retorno | "
    Endif

    cFileChg    :=cGetFile(cType, OemToAnsi(OemToAnsi(STR0023)+Subs(cType,1,7) ) ) // "Selecione arquivo "

    If  Empty(cFileChg)
        cFile:=""
        Return
    Endif

    If  "."$cFileChg
        //	cFileChg := Substr(cFileChg,1,rat(".", cFileChg)-1)
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
	±±³Fun‡…o    ³EditEXTR  ³ Autor ³ Marcos Patricio       ³ Data ³ 05.02.96 ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡…o ³Edita LayOut do arquivo de Extratos                         ³±±
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
    local oGetH
    Local oGetL
    Local oGetT
    Local oLbHeader
    Local oLbLancto
    Local oLbTrail
    Local oBarHeader
    Local oBarLancto
    Local oBarTrail
    Local nControl  := 0
    Local aTitles   := {}
    Local aPages    := {}
    Local nHeader   := 0
    Local nLancto   := 0
    Local nTrail    := 0
    Local lConfirma := .T.
    Local i

    lDele   :=IIF(lDele==NIL,.F.,lDele)

    If  nOpcf==1
        aHeader :=  Aclone(aH)
        aLancto :=  Aclone(aL)
        aTrail  :=  Aclone(aT)
    Endif

    AADD(aTitles,OemToAnsi(STR0024))  // "Header"
    AADD(aPages,"HEADER")
    nControl++
    nHeader := nControl

    AADD(aTitles,OemToAnsi(STR0026)) // "Lan‡amentos"
    AADD(aPages,"DETAIL")
    nControl++
    nLancto := nControl

    AADD(aTitles,OemToAnsi(STR0028))  // "Trailler"
    AADD(aPages,"TRAIL")
    nControl++
    nTrail  := nControl
    SETAPILHA()
    //DEFINE MSDIALOG oDlgLayOut TITLE OemToAnsi(STR0029)+Space(05)+cFile ; // "Configura‡„o Extrato Bancario"
    //FROM 8.0,0 to 34.5,81 OF oMainWnd

    oFolder := TFolder():New(.5,.2,aTitles, aPages,oDlgLayOut,x,x,x, .F., .F.,315,170,)

    For i:= 1 to Len(oFolder:aDialogs)
        oFolder:aDialogs[i]:oFont := oDlgLayOut:oFont
    Next

    oFolder:aPrompts[1] := OemToAnsi(STR0030) // "&Header"
    oFolder:aPrompts[2] := OemToAnsi(STR0032) // "&Lanctos."
    oFolder:aPrompts[3] := OemToAnsi(STR0034) // "&Trailler"

    PUBLIC nLastKey := 0

    DEFINE SBUTTON FROM 180,255.5 TYPE 1 ENABLE OF oDlgLayOut ACTION (If(lConfirma:=If(lDele,DeleFile(),SaveFile()),oDlgLayout:End(),NIL))
    DEFINE SBUTTON FROM 180,285.5 TYPE 2 ENABLE OF oDlgLayOut ACTION (oDlgLayOut:End())

    // ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    // ³ Header				                                            ³
    // ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    @ 1,.2 LISTBOX oLbHeader FIELDS HEADER	OemToAnsi(STR0035),; // "Campo"
    OemToAnsi(STR0036),; // "Pos. Inicial"
    OemToAnsi(STR0037),; // "Pos. Final"
    OemToAnsi(STR0038),; // "Decimais"
    OemToAnsi(STR0039);  // "Conte£do"
    COLSIZES 50,30,30,30,30 ;
        SIZE 307,140 OF oFolder:aDialogs[nHeader] ;
        ON DBLCLICK (LineOut(oLbHeader:nAt,"H",.F.),oLbHeader:Refresh()) // Edi‡Æo

    oLbHeader:SetArray(aHeader)
    oLbheader:bLine  := { || { aHeader[oLbHeader:nAt,1] ,;
        aHeader[oLbHeader:nAt,2] ,;
        aHeader[oLbHeader:nAt,3] ,;
        aHeader[oLbHeader:nAt,4] ,;
        aHeader[oLbHeader:nAt,5] } }


    // ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    // ³ Lancamentos                                                 ³
    // ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    @ 1,.2 LISTBOX oLbLancto FIELDS HEADER    OemToAnsi(STR0035),; // "Campo"
    OemToAnsi(STR0036),; // "Pos. Inicial"
    OemToAnsi(STR0037),; // "Pos. Final"
    OemToAnsi(STR0038),; // "Decimais"
    OemToAnsi(STR0039);  // "Conte£do"
    COLSIZES 50,30,30,30,30 ;
        SIZE 307,140 OF oFolder:aDialogs[nLancto] ;
        ON DBLCLICK (LineOut(oLbLancto:nAt,"L",.F.),oLbLancto:Refresh()) // Edi‡Æo

    oLbLancto:SetArray(aLancto)
    oLbLancto:bLine   := { || { aLancto[oLbLancto:nAt,1]  ,;
        aLancto[oLbLancto:nAt,2]  ,;
        aLancto[oLbLancto:nAt,3]  ,;
        aLancto[oLbLancto:nAt,4]  ,;
        aLancto[oLbLancto:nAt,5]  } }


    // ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    // ³ Trailler                                                    ³
    // ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

    @ 1,.2 LISTBOX oLbTrail FIELDS HEADER  OemToAnsi(STR0035),; // "Campo"
    OemToAnsi(STR0036),; // "Pos. Inicial"
    OemToAnsi(STR0037),; // "Pos. Final"
    OemToAnsi(STR0038),; // "Decimais"
    OemToAnsi(STR0039);  // "Conte£do"
    COLSIZES 50,30,30,30,30 ;
        SIZE 370,140 OF oFolder:aDialogs[nTrail] ;
        ON DBLCLICK (LineOut(oLbTrail:nAt,"T",.F.),oLbTrail:Refresh()) // Edi‡Æo

    oLbTrail:SetArray(aTrail)
    oLbTrail:bLine   := { || { aTrail[oLbTrail:nAt,1] ,;
        aTrail[oLbTrail:nAt,2] ,;
        aTrail[oLbTrail:nAt,3] ,;
        aTrail[oLbTrail:nAt,4] ,;
        aTrail[oLbTrail:nAt,5] } }


    ACTIVATE DIALOG oDlgLayOut ON INIT(FldTool(oFolder,oLbHeader,oLbLancto,oLbTrail,nHeader,nLancto,nTrail))
    SETAPILHA()
    aHeader :={}
    aDetail :={}
    aTrail  :={}

    aHeader :={{Space(15),Space(03),Space(03),Space(01),Space(60)}}
    aLancto :={{Space(15),Space(03),Space(03),Space(01),Space(60)}}
    aTrail  :={{Space(15),Space(03),Space(03),Space(01),Space(60)}}

	/*/
    ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
    ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
    ±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
    ±±³Fun‡…o    ³ RestFile ³ Autor ³ Wagner Xavier         ³ Data ³          ³±±
    ±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
    ±±³Descri‡…o ³ Restaura arquivos de Comunicacao Bancaria ja Configurados  ³±±
    ±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
    ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
    ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	/*/
Static Function RestFile(oDlg,lDele)
    LOCAL nTamArq,nBytes:=0,xBuffer,lSave,i

    lDele:=IIF(lDele==NIL,.F.,lDele)

    If !File(cFile)
        cFile:=""
        Help(" ",1,"AX023BCO")
        Return
    Endif

    nBcoHdl :=FOPEN(cFile,2+64)
    nTamArq :=FSEEK(nBcoHdl,0,2)
    FSEEK(nBcoHdl,0,0)

    aHeader :={}
    aLancto :={}
    aTrail  :={}

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Preenche os arrays de acordo com a Identificador             ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    While nBytes < nTamArq
        xBuffer := Space(85)
        FREAD(nBcoHdl,@xBuffer,85)
        IF SubStr(xBuffer,1,1) == CHR(1)
            AADD(aHeader,{	SubStr(xBuffer,02,15) ,SubStr(xBuffer,17,03),;
                SubStr(xBuffer,20,03) ,SubStr(xBuffer,23,01),;
                SubStr(xBuffer,24,60 ) } )
        Elseif SubStr(xBuffer,1,1) == CHR(3)
            AADD(aLancto,{	SubStr(xBuffer,02,15) ,SubStr(xBuffer,17,03),;
                SubStr(xBuffer,20,03) ,SubStr(xBuffer,23,01),;
                SubStr(xBuffer,24,60) } )
        Elseif SubStr(xBuffer,1,1) == CHR(5)
            AADD(aTrail,{	SubStr(xBuffer,02,15) ,SubStr(xBuffer,17,03),;
                SubStr(xBuffer,20,03) ,SubStr(xBuffer,23,01),;
                SubStr(xBuffer,24,60) } )
        Endif
        nBytes += 85
    EndDO
    IF Len(aHeader)==0 .And. Len(aLancto)==0 .And. Len(aTrail)==0
        HELP(" ",1,"AX023BCO")
        Return
    ENDIF
    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Iguala Array Original com existente.                         ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    If Len( aHeader) < Len( aH  )
        For i:=Len(aHeader)+1 To Len(aH)
            Aadd( aHeader, { aH[i,1], Spac(3), Spac(3), Spac(3), Space(60) } )
        Next i
    End

    If Len( aLancto ) < Len( aL  )
        For i:=Len(aLancto)+1 To Len(aL)
            Aadd( aLancto, { aL[i,1], Spac(3), Spac(3), Spac(3), Space(60) } )
        Next i
    End

    If Len( aTrail ) < Len( aT  )
        For i:=Len(aTrail)+1 To Len(aT)
            Aadd( aTrail , { aT[i,1], Space(3), Space(3), Space(3), Space(60) } )
        Next i
    End

    If  Empty(aHeader)
        aHeader :=Aclone(aH)
    Endif

    If  Empty(aLancto)
        aLancto  :=Aclone(aL)
    Endif

    If  Empty(aTrail)
        aTrail  :=Aclone(aT)
    Endif

    EditExtr(oDlg,lDele)

    FCLOSE(nBcoHdl)
Return


	/*
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Fun‡…o    ³ SaveFile ³ Autor ³ Wagner Xavier         ³ Data ³          ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡…o ³ Salva arquivos de Comunicacao Bancaria ja Configurados     ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Sintaxe   ³SaveFle(cFile)                                              ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Parametros³cFile    - Arquivo a ser Criado/Editado                     ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³ Uso      ³ MATCONF                                                    ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	*/
Static Function SaveFile()

    LOCAL cReg1
    Local i
    Local lCreat    :=.F.
    Local cRegA
    Local cFileback :=cFile

    IF  nOpcf == 2
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Escolhe o nome do Arquivo a ser salvo                        ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        MudaArq()
        If  Empty(cFile)
            Return .F.
        Endif

        If  cFile#cFileBack .AND. File(cFile)
            If  !MsgYesNo(OemToAnsi(STR0040),OemToAnsi(STR0043)) // "Arquivo LayOut j  existe grava por cima" ### "LayOut Extrato"
                cFile   :=""
                Return .F.
            Endif
        Endif
    Else
        If  !MsgYesNo(OemToAnsi(STR0041),OemToAnsi(STR0043)) // "Confirma Grava‡„o do arquivo LayOut" ### "LayOut Extrato"
            Return .F.
        Endif
    EndIF

    fClose(nBcoHdl)
    nBcoHdl:=MSFCREATE(cFile,0)

    FSEEK(nBcoHdl,0,0)

    x055Form(aHeader,1)
    x055Form(aLancto,3)
    x055Form(aTrail ,5)

    FCLOSE(nBcoHdl)
Return .T.

	/*
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Fun‡…o    ³ DeleFile ³ Autor ³ Wagner Xavier         ³ Data ³          ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡…o ³ Deleta   arquivos de Comunicacao Bancaria ja Configurados  ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Sintaxe   ³ DeleFile()                                                 ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Parametros³                                                            ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	*/
Static Function DeleFile()

    If  Len(aHeader) > 0
        If MsgYesNo(OemToAnsi(STR0042),OemToAnsi(STR0043)) // "Deleta arquivo LayOut"  ### "LayOut Extrato"
            FCLOSE(nBcoHdl)
            FERASE(cFile)
        Endif
    Endif
Return .T.


	/*
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Fun‡…o    ³LineOut   ³ Autor ³ Mauricio Pequim Jr    ³ Data ³ 24.08.98 ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡…o ³ Acepta linha do LayOut                                     ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Sintaxe   ³ LiOut(nItem,Folder,lProcess)                               ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Parametros³ nItem    - Item do array                                   ³±±
	±±³          ³ Folder   - Folder Focado                                   ³±±
	±±³          ³ lProcess - Processo InclusÆo ou Altera‡Æo                  ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³ Uso      ³ MATCONF                                                    ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±

	*/
Static Function  LineOut(nItem,Folder)

    Local nOpca     :=0
    Local cPosBco   :=Space(15)
    Local cPosIni   :=Space(03)
    Local cPosFin   :=Space(03)
    Local cLenDec   :=Space(01)
    Local cConteudo :=Space(60)
    Local oDlg

    If nOpcf==3
        Return
    Endif

    If  Folder=="H"
        IF  Len(aHeader)==1 .AND. (Empty(aHeader[1,1]) .AND. Empty(aHeader[1,2]) .AND. Empty(aHeader[1,3]))
            MsgStop(OemToAnsi(STR0044),OemToAnsi(STR0043))  // "N„o h  dados para altera‡„o" ### "LayOut Extrato"
            Return
        Else
            cPosBco    :=OemToAnsi(aHeader[nItem,1])
            cPosIni    :=aHeader[nItem,2]
            cPosFin    :=aHeader[nItem,3]
            cLenDec    :=aHeader[nItem,4]
            cConteudo  :=OemToAnsi(aHeader[nItem,5])
        Endif
    Elseif Folder =="L"
        IF  Len(aLancto)==1 .AND. (Empty(aLancto[1,1]) .AND. Empty(aLancto[1,2]) .AND. Empty(aLancto[1,3]) )
            MsgStop(OemToAnsi(STR0044),OemToAnsi(STR0043)) // "N„o h  dados para altera‡„o" ### "LayOut Extrato"
            Return
        Else
            cPosBco    :=OemToAnsi(aLancto[nItem,1])
            cPosIni    :=aLancto[nItem,2]
            cPosFin    :=aLancto[nItem,3]
            cLenDec    :=aLancto[nItem,4]
            cConteudo  :=OemToAnsi(aLancto[nItem,5])
        Endif
    Else
        IF  Len(aTrail)==1 .AND. ( Empty(aTrail[1,1]) .AND. Empty(aTrail[1,2]) .AND. Empty(aTrail[1,3]) )
            MsgStop(OemToAnsi(STR0044),OemToAnsi(STR0043)) // "N„o h  dados para altera‡„o" ###  "LayOut Extrato"
            Return
        Else
            cPosBco    :=OemToAnsi(aTrail[nItem,1])
            cPosIni    :=aTrail[nItem,2]
            cPosFin    :=aTrail[nItem,3]
            cLenDec    :=aTrail[nItem,4]
            cConteudo  :=OemToAnsi(aTrail[nItem,5])
        Endif
    Endif

    DEFINE MSDIALOG oDlg FROM  15,6 TO 196,366 TITLE OemToAnsi(STR0043) PIXEL // "LayOut Extrato"

    @ -2, 2 TO 74, 179 OF oDlg  PIXEL

    @ 08,05 SAY     OemToAnsi(STR0035)      SIZE 22, 07 OF oDlg PIXEL // "Campo"
    @ 07,53 MSGET   cPosBco Picture "@X"  When .F.  SIZE 70, 10 OF oDlg PIXEL

    @ 21,05 SAY     OemToAnsi(STR0036) SIZE 46, 07 OF oDlg PIXEL // "Pos. Inicial"
    @ 20,53 MSGET   cPosIni  Picture "999"  SIZE 21, 10 OF oDlg PIXEL

    @ 34,05 SAY     OemToAnsi(STR0037)   SIZE 41, 07 OF oDlg PIXEL // "Pos. Final"
    @ 33,53 MSGET   cPosFin  Picture "999"  SIZE 21, 10 OF oDlg PIXEL

    @ 47,05 SAY     OemToAnsi(STR0038)   SIZE 028,07 OF oDlg PIXEL // "Decimais"
    @ 46,53 MSGET   cLenDec  Picture "9"    SIZE 011,10 OF oDlg PIXEL

    @ 60,05 SAY     OemToAnsi(STR0039)   SIZE 031,07 OF oDlg PIXEL // "Conte£do"
    @ 59,53 MSGET   cConteudo              When .F. SIZE 123,10 OF oDlg PIXEL

    DEFINE SBUTTON FROM 77,124 TYPE 1 ENABLE OF oDlg ACTION ( TipoFile(),nOpca:=1,oDlg:End())
    DEFINE SBUTTON FROM 77,152 TYPE 2 ENABLE OF oDlg ACTION oDlg:End()

    ACTIVATE MSDIALOG oDlg CENTERED
    If  nOpca == 1
        If Folder=="H"
            aHeader[nItem]   :={cPosBco,cPosIni,cPosFin,cLenDec,cConteudo}
        Elseif Folder =="L"
            aLancto[nItem]   :={cPosBco,cPosIni,cPosFin,cLenDec,cConteudo}
        Else
            aTrail[nItem]    :={cPosBco,cPosIni,cPosFin,cLenDec,cConteudo}
        Endif
    Endif

Return



	/*
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Fun‡…o    ³ TipoFile ³ Autor ³ Mauricio Pequim Jr    ³ Data ³ 24.08.98 ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡…o ³ Seta o tipo de arqruivo em uso                             ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Sintaxe   ³ TipoFile()                                                 ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Parametros³                                                            ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³ Uso      ³ MATCONF                                                    ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±

	*/
Static Function TipoFile()

    cType   :=Iif(nOpcf==1,OemToAnsi(STR0022)+'SIGA.REC',OemToAnsi(STR0022)+'*.REC') // "Retorno | "

Return Nil


	/*
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Fun‡…o    ³ FldTool  ³ Autor ³ Mauricio Pequim Jr     ³ Data ³ 05.02.96 ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡…o ³ Barra de botäes das pastas                                  ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Parametros³ oFld         - Objeto do Folder                             ³±±
	±±³          ³ oLbHeader    - Objeto ListBox do Header                     ³±±
	±±³          ³ oLbDetail    - Objeto ListBox do Detail                     ³±±
	±±³          ³ oLbTrail     - Objeto ListBox do Trail                      ³±±
	±±³          ³ nHeader      - Referencia da pasta do Objeto Folder         ³±±
	±±³          ³ nDetail      - Referencia da pasta do Objeto Folder         ³±±
	±±³          ³ nTrail       - Referencia da pasta do Objeto Folder         ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³ Uso      ³ MATCONF                                                     ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±

	*/
Static Function FldTool(oFld,oLbHeader,oLbLancto,oLbTrail,nHeader,nLancto,nTrail)

    @ .1,02 BUTTON OemToAnsi(STR0051) SIZE 25,10 OF oFld:aDialogs[nHeader] ACTION (LineOut(oLbHeader:nAt,"H"),oLbHeader:Refresh()) //"Editar"

    @ .1,02 BUTTON OemToAnsi(STR0051) SIZE 25,10 OF oFld:aDialogs[nLancto] ACTION (LineOut(oLbLancto:nAt,"L"),oLbLancto:Refresh()) //"Editar"

    @ .1,02 BUTTON OemToAnsi(STR0051) SIZE 25,10 OF oFld:aDialogs[nTrail] ACTION (LineOut(oLbTrail:nAt,"T"),oLbTrail:Refresh()) //"Editar"


RETURN NIL

	/*
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Fun‡…o    ³ X055Form ³ Autor ³ Wagner Xavier         ³ Data ³          ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡…o ³ Grava um Array no Novo Arquivo de Comunicao Bancaria       ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	*/
Static Function x055Form(aComun,nIdent)

    Local i
    Local cReg1
    Local cRegA
    For i:=1 To Len(aComun)
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Verifica se a linha esta em branco                           ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

        cReg1:= aComun[i][1]+aComun[i][2]+;
            aComun[i][3]+aComun[i][4]+aComun[i][5]
        IF !Empty(cReg1)
            cRegA:= CHR(nIdent)+cReg1
            FWRITE(nBcoHdl,cRegA+CHR(13)+CHR(10),85)   //grava nova linha
        EndIF
    Next i


