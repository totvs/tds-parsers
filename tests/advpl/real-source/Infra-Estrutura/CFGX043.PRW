/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ DATA   ³ BOPS ³Prograd.³ALTERACAO                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³04.03.98³14785A³Eduardo ³Inclusao do campo de Codigo de Rejeicao no Cnab³±±
±±³08.06.98³16145A³Mauricio³Incluido Campo Fornecedor na Config.de Retorno ³±±
±±³26.05.98³		³Mauricio³Conversao Protheus                             ³±±
±±³18.02.00³      ³Andre   ³Incluido Campo cgc na config.de retorno        ³±±
±±ÀÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
#Include "FiveWin.ch"
#Include "Folder.ch"
#Include "cfgx043.ch"

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ CFGX043  ³ Autor ³ Marcos Patricio       ³ Data ³ 05.02.96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Configurador de Arquivos de Comunicacao Bancaria           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CFGX043()                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATCONF                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
Last change:  CIA  22 Feb 96    8:45 am
*/

FUNCTION CFGX043(void)

	// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	// ³ Define Variaveis                                            ³
	// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Local bExec
	Local oDlg
	Local oRadio

	Private nOpcf   :=1
	Private nRadio  :=1
	Private aHeader :={{Space(15),Space(03),Space(03),Space(01),Space(60)}}
	Private aDetail :={{Space(15),Space(03),Space(03),Space(01),Space(60)}}
	Private aTrail  :={{Space(15),Space(03),Space(03),Space(01),Space(60)}}
	Private cFile   :=""
	Private cType   :=""
	Private nBcoHdl := 0

	/*
	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³ Arquivo de Com.Bancaria ³
	³    Remessa/Retorno      ³
	³                         ³
	³ Memoria de Calculo      ³     ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³ Registro 1 - USUARIOS   ³     ³Identificadores          ³
	³ - Identif    CHR(n)   1 ³     ³ CHR(1)   - Header       ³
	³ - Descricao do Campo 15 ³     ³ CHR(2)   - Detalhe      ³
	³ - Posicao Inical      3 ³     ³ CHR(3)   - Trailler     ³
	³ - Posicao Final       3 ³     ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	³ - Decimais            1 ³
	³ - Campo/Conteudo     60 ³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	*/

	aH := { {OemToAnsi(STR0001),Space(03),Space(03),Space(01),Space(60)} }  // "Codigo do Banco"

	aD := { {OemToAnsi(STR0002),Space(03),Space(03),Space(01),Space(60)},;  // "Numero Titulo  "
	{OemToAnsi(STR0003),Space(03),Space(03),Space(01),Space(60)},;  // "Data Ocorrencia"
	{OemToAnsi(STR0004),Space(03),Space(03),Space(01),Space(60)},;  // "Vlr Desp Cobr. "
	{OemToAnsi(STR0005),Space(03),Space(03),Space(01),Space(60)},;  // "Vlr Desconto   "
	{OemToAnsi(STR0006),Space(03),Space(03),Space(01),Space(60)},;  // "Vlr Abatimento "
	{OemToAnsi(STR0007),Space(03),Space(03),Space(01),Space(60)},;  // "Vlr Pago       "
	{OemToAnsi(STR0008),Space(03),Space(03),Space(01),Space(60)},;  // "Valor Juros    "
	{OemToAnsi(STR0009),Space(03),Space(03),Space(01),Space(60)},;  // "Valor Multa    "
	{OemToAnsi(STR0010),Space(03),Space(03),Space(01),Space(60)},;  // "Cod Ocorrencia "
	{OemToAnsi(STR0011),Space(03),Space(03),Space(01),Space(60)},;  // "Especie        "
	{OemToAnsi(STR0012),Space(03),Space(03),Space(01),Space(60)},;  // "Nosso Numero   "
	{OemToAnsi(STR0048),Space(03),Space(03),Space(01),Space(60)},;  // "Cod Rejeicao   "
	{OemToAnsi(STR0056),Space(03),Space(03),Space(01),Space(60)},;  // "Reservado(Forn)"
	{OemToAnsi(STR0057),Space(03),Space(03),Space(01),Space(60)},;  // "Cgc Fornecedor "
	{OemToAnsi(STR0058),Space(03),Space(03),Space(01),Space(60)} }  // "Data Debito    "

	aT := { {OemToAnsi(STR0001),Space(03),Space(03),Space(01),Space(60)} }  // "Codigo do Banco"

	// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	// ³ Recupera o desenho padrao de atualizacoes                   ³
	// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DEFINE MSDIALOG oDlg FROM  94,1 TO 273,293 TITLE OemToAnsi(STR0013) PIXEL  // "Movimenta‡„o Banc ria"

	@ 10,17 Say OemToAnsi(STR0014) SIZE 150,7 OF oDlg PIXEL  // "Estrutura‡„o dos arquivos de LayOut utilizados"
	@ 18,40 Say OemToAnsi(STR0015)                       SIZE 100,7 OF oDlg PIXEL   // "na comunica‡„o banc ria."

	@ 27,07 TO 58, 139 OF oDlg  PIXEL

	@ 35,10 Radio oRadio VAR nRadio ITEMS STR0016,STR0017 3D SIZE 100,10 OF oDlg PIXEL ON Change TypeFile()  // "&Remessa"  ### "R&etorno"

	@ 68, 007 Button STR0018         SIZE 33, 11 OF oDlg PIXEL   Action(nOpcf:=1,TypeFile(),ChangeFile(.F.)   ,If(!Empty(cFile),EditCNAB(oDlg),nOpcf:=0))       Font oDlg:oFont  // "Novo"
	@ 68, 040 Button STR0019     SIZE 33, 11 OF oDlg PIXEL   Action(nOpcf:=2,TypeFile(),ChangeFile(.T.)   ,If(!Empty(cFile),RestFile(oDlg),nOpcf:=0))       Font oDlg:oFont // "Restaura"
	@ 68, 073 Button STR0020      SIZE 33, 11 OF oDlg PIXEL   Action(nOpcf:=3,TypeFile(),ChangeFile(.T.)   ,If(!Empty(cFile),RestFile(oDlg,.T.),nOpcf:=0))   Font oDlg:oFont // "Excluir"
	@ 68, 106 Button STR0021     SIZE 33, 11 OF oDlg PIXEL   Action(nopcf:=4,oDlg:End())                                                                 Font oDlg:oFont  // "Cancelar"

	ACTIVATE MSDIALOG oDlg CENTERED


	/*
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Fun‡…o    ³ChangeFile³ Autor ³ Marcos Patricio       ³ Data ³ 05.02.96 ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡…o ³ Escolhe arquivo ou cria arquivo para padroniza‡Æo CNAB     ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Sintaxe   ³ ChangeFile()                                               ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Parametros³                                                            ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³ Uso      ³ MATCONF                                                    ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	*/

Static Function ChangeFile(lOpen)

	Local cFileChg
	Local cCheck
	Local cBack     := cFile

	DEFAULT lOpen := .T.

	If  nRadio==1
		cType    := STR0023  // "Remessa | SIGA.CPE" ### "Remessa | *.CPE"
	Else
		cType   := STR0025     // "Retorno | SIGA.CPR"  ### "Retorno | *.CPR"
	Endif

	cFileChg	:= cGetFile( cType, OemToAnsi(STR0026+Subs(cType,1,7)) , 1,, lOpen, 1+16+32, .T. ) //GETF_OVERWRITEPROMPT+GETF_LOCALHARD+GETF_NETWORKDRIVE

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
			Help(" ",1,"AX043EXIST")
			Return
		Endif
	Else
		If nRadio==1
			cType := OemToAnsi(STR0023)+cFile	// "Remessa | "
		Else
			cType := OemToAnsi(STR0025)+cFile	// "Retorno | "
		Endif

	Endif

	Return


	/*
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Fun‡…o    ³EditCNAB  ³ Autor ³ Marcos Patricio       ³ Data ³ 05.02.96 ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡…o ³Edita LayOut do arquivo CNAB                                ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Sintaxe   ³EditCnab(oDlg,cFile)                                        ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Parametros³oDlg     - Objeto pai da janela                             ³±±
	±±³          ³cFile    - Arquivo a ser Criado/Editado                     ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³ Uso      ³ MATCONF                                                    ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	Last change:  CIA   5 Feb 96    9:44 am
	*/

Static Function EditCNAB(oDlg,lDele)

	Local oDlgLayOut
	local oGetH
	Local oGetD
	Local oGetT
	Local oLbHeader
	Local oLbDetail
	Local oLbTrail
	Local oBarHeader
	Local oBarDetail
	Local oBarTrail
	Local nControl  := 0
	Local aTitles   := {}
	Local aPages    := {}
	Local nHeader   := 0
	Local nDetail   := 0
	Local nTrail    := 0
	Local lConfigma := .T.
	Local i

	lDele   :=IIF(lDele==NIL,.F.,lDele)

	If  (nRadio == 2  .And. nOpcf==1)
		aHeader :=  Aclone(aH)
		aDetail :=  Aclone(aD)
		aTrail  :=  Aclone(aT)
	Endif

	AADD(aTitles,OemToAnsi(STR0050)) //"Header"
	AADD(aPages,"HEADER")
	nControl++
	nHeader := nControl

	AADD(aTitles,OemToAnsi(STR0052)) //"Detalhes"
	AADD(aPages,"DETAIL")
	nControl++
	nDetail := nControl

	AADD(aTitles,OemToAnsi(STR0054)) //"Trailler"
	AADD(aPages,"TRAIL")
	nControl++
	nTrail  := nControl
	SETAPILHA()
	DEFINE MSDIALOG oDlgLayOut TITLE OemToAnsi(STR0028+if(nRadio==1,STR0029,STR0030) )+Space(05)+cFile;  // "LayOut do arquivo CNAB a Pagar "  ### "Remessa"  ### "Retorno"
	FROM 8.0,0 to 34.5,81 OF oMainWnd

	oFolder := TFolder():New(.5,.2,aTitles, aPages,oDlgLayOut,,,, .F., .F.,315,170,)

	For i:= 1 to Len(oFolder:aDialogs)
		oFolder:aDialogs[i]:oFont := oDlgLayOut:oFont
	Next

	oFolder:aPrompts[1] := oemtoansi(STR0051) // "&Header"
	oFolder:aPrompts[2] := oemtoansi(STR0053) // "&Detalhe"
	oFolder:aPrompts[3] := oemtoansi(STR0055) // "&Trailler"

	PUBLIC nLastKey := 0

	DEFINE SBUTTON FROM 180,255.5 TYPE 1 ENABLE OF oDlgLayOut ACTION (If(lConfirma:=If(lDele,DeleFile(),SaveFile()),oDlgLayout:End(),NIL))
	DEFINE SBUTTON FROM 180,285.5 TYPE 2 ENABLE OF oDlgLayOut ACTION (oDlgLayOut:End())

	#IFNDEF PROTHEUS
		@ 1,.2 LISTBOX oLbHeader FIELDS HEADER	OemToAnsi(STR0031),; // "Campo"
		OemToAnsi(STR0032),; // "Pos. Inicial"
		OemToAnsi(STR0033),; // "Pos. Final"
		OemToAnsi(STR0034),; // "Decimais"
		OemToAnsi(STR0035);  // "Conteudo"
		COLSIZES 90,60,60,60,60 ;
			SIZE 307,140 OF oFolder:aDialogs[nHeader]  ;
			ON DBLCLICK (LinOut(oLbHeader:nAt,"H",.F.),oLbHeader:Refresh()) // Edi‡Æo

	#ELSE
		@ 1,.2 LISTBOX oLbHeader FIELDS HEADER	OemToAnsi(STR0031),; // "Campo"
		OemToAnsi(STR0032),; // "Pos. Inicial"
		OemToAnsi(STR0033),; // "Pos. Final"
		OemToAnsi(STR0034),; // "Decimais"
		OemToAnsi(STR0035);  // "Conteudo"
		COLSIZES 50,30,30,30,30 ;
			SIZE 307,140 OF oFolder:aDialogs[nHeader]  ;
			ON DBLCLICK (LinOut(oLbHeader:nAt,"H",.F.),oLbHeader:Refresh()) // Edi‡Æo
	#ENDIF

	oLbHeader:SetArray(aHeader)
	oLbheader:bLine   := { || { aHeader[oLbHeader:nAt,1] ,;
		aHeader[oLbHeader:nAt,2] ,;
		aHeader[oLbHeader:nAt,3] ,;
		aHeader[oLbHeader:nAt,4] ,;
		aHeader[oLbHeader:nAt,5] } }
	#IFNDEF PROTHEUS
		@ 1,.2 LISTBOX oLbDetail FIELDS HEADER OemToAnsi(STR0031),; // "Campo"
		OemToAnsi(STR0032),; // "Pos. Inicial"
		OemToAnsi(STR0033),; // "Pos. Final"
		OemToAnsi(STR0034),; // "Decimais"
		OemToAnsi(STR0035);  // "Conteudo"
		COLSIZES 90,60,60,60,60;
			SIZE 307,140 OF oFolder:aDialogs[nDetail] ;
			ON DBLCLICK (LinOut(oLbDetail:nAt,"D",.F.),oLbDetail:Refresh()) // Edi‡Æo
	#ELSE
		@ 1,.2 LISTBOX oLbDetail FIELDS HEADER 	OemToAnsi(STR0031),; // "Campo"
		OemToAnsi(STR0032),; // "Pos. Inicial"
		OemToAnsi(STR0033),; // "Pos. Final"
		OemToAnsi(STR0034),; // "Decimais"
		OemToAnsi(STR0035);  // "Conteudo"
		COLSIZES 50,30,30,30,30;
			SIZE 307,140 OF oFolder:aDialogs[nDetail] ;
			ON DBLCLICK (LinOut(oLbDetail:nAt,"D",.F.),oLbDetail:Refresh()) // Edi‡Æo
	#ENDIF

	oLbDetail:SetArray(aDetail)
	oLbDetail:bLine   := { || { aDetail[oLbDetail:nAt,1]  ,;
		aDetail[oLbDetail:nAt,2]  ,;
		aDetail[oLbDetail:nAt,3]  ,;
		aDetail[oLbDetail:nAt,4]  ,;
		aDetail[oLbDetail:nAt,5]  } }

	#IFNDEF PROTHEUS
		@ 1,.2 LISTBOX oLbTrail FIELDS HEADER	OemToAnsi(STR0031),; // "Campo"
		OemToAnsi(STR0032),; // "Pos. Inicial"
		OemToAnsi(STR0033),; // "Pos. Final"
		OemToAnsi(STR0034),; // "Decimais"
		OemToAnsi(STR0035);  // "Conte£do"
		COLSIZES 90,60,60,60,60;
			SIZE 307,140 OF oFolder:aDialogs[nTrail] ;
			ON DBLCLICK (LinOut(oLbTrail:nAt,"T",.F.),oLbTrail:Refresh()) // Edi‡Æo
	#ELSE
		@ 1,.2 LISTBOX oLbTrail FIELDS HEADER	OemToAnsi(STR0031),; // "Campo"
		OemToAnsi(STR0032),; // "Pos. Inicial"
		OemToAnsi(STR0033),; // "Pos. Final"
		OemToAnsi(STR0034),; // "Decimais"
		OemToAnsi(STR0035);  // "Conte£do"
		COLSIZES 50,30,30,30,30;
			SIZE 307,140 OF oFolder:aDialogs[nTrail] ;
			ON DBLCLICK (LinOut(oLbTrail:nAt,"T",.F.),oLbTrail:Refresh()) // Edi‡Æo
	#ENDIF

	oLbTrail:SetArray(aTrail)
	oLbTrail:bLine   := { || { aTrail[oLbTrail:nAt,1] ,;
		aTrail[oLbTrail:nAt,2] ,;
		aTrail[oLbTrail:nAt,3] ,;
		aTrail[oLbTrail:nAt,4] ,;
		aTrail[oLbTrail:nAt,5] } }


	ACTIVATE DIALOG oDlgLayOut ON INIT(FldTools(oFolder,oLbHeader,oLbDetail,oLbTrail,nHeader,nDetail,nTrail))
	SETAPILHA()
	aHeader :={}
	aDetail :={}
	aTrail  :={}

	aHeader :={{Space(15),Space(03),Space(03),Space(01),Space(60)}}
	aDetail :={{Space(15),Space(03),Space(03),Space(01),Space(60)}}
	aTrail  :={{Space(15),Space(03),Space(03),Space(01),Space(60)}}


	/*
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Fun‡…o    ³ RestFile ³ Autor ³ Wagner Xavier         ³ Data ³          ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡…o ³ Restaura arquivos de Comunicacao Bancaria ja Configurados  ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Sintaxe   ³RestFile(cFile,lDele)                                       ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Parametros³cFile    - Arquivo a ser deletado                           ³±±
	±±³          ³lDele    -                                                  ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	*/
Static Function RestFile(oDlg,lDele)
	Local nTamArq
	Local nBytes    :=0
	Local xBuffer
	Local lSave
	Local i

	lDele   :=IIF(lDele==NIL,.F.,lDele)

	If  !File(cFile)
		cFile:=""
		Help(" ",1,"AX043BCO")
		Return
	Endif

	nBcoHdl :=FOPEN(cFile,2+64)
	nTamArq :=FSEEK(nBcoHdl,0,2)
	FSEEK(nBcoHdl,0,0)

	aHeader :={}
	aDetail :={}
	aTrail  :={}

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Preenche os arrays de acordo com a Identificador             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	While   nBytes < nTamArq
		xBuffer := Space(85)
		FREAD(nBcoHdl,@xBuffer,85)
		If  SubStr(xBuffer,1,1) == CHR(1)
			AADD(aHeader,{	SubStr(xBuffer,02,15) ,SubStr(xBuffer,17,03),;
				SubStr(xBuffer,20,03) ,SubStr(xBuffer,23,01),;
				SubStr(xBuffer,24,60 ) } )
		Elseif SubStr(xBuffer,1,1) == CHR(2)
			AADD(aDetail,{	SubStr(xBuffer,02,15) ,SubStr(xBuffer,17,03),;
				SubStr(xBuffer,20,03) ,SubStr(xBuffer,23,01),;
				SubStr(xBuffer,24,60) } )
		Elseif SubStr(xBuffer,1,1) == CHR(3)
			AADD(aTrail,{	SubStr(xBuffer,02,15) ,SubStr(xBuffer,17,03),;
				SubStr(xBuffer,20,03) ,SubStr(xBuffer,23,01),;
				SubStr(xBuffer,24,60) } )
		Endif
		nBytes += 85
	Enddo
	IF  Len(aHeader)==0 .And. Len(aDetail)==0 .And. Len(aTrail)==0
		Help(" ",1,"AX043BCO")
		Return
	ENDIF

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Iguala Array Original com existente.                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ( Len( aDetail ) < Len( aD ) ) .and. nRadio == 2  //Somente para arquivos de retorno.
		For i:=Len(aDetail)+1 To Len(aD)
			Aadd( aDetail, { aD[i,1], Spac(3), Spac(3), Spac(1), Space(60) } )
		Next i
	EndIf

	If  Empty(aHeader)
		If  nRadio == 2
			aHeader :=Aclone(aH)
		Else
			aHeader :={{Space(15),Space(03),Space(03),Space(01),Space(60)}}
		Endif
	Endif
	If  Empty(aDetail)
		If  nRadio == 2
			aDetal  :=Aclone(aD)
		Else
			aDetail :={{Space(15),Space(03),Space(03),Space(01),Space(60)}}
		Endif
	Endif
	If  Empty(aTrail)
		If  nRadio == 2
			aTrail  :=Aclone(aT)
		Else
			aTrail  :={{Space(15),Space(03),Space(03),Space(01),Space(60)}}
		Endif
	Endif

	EditCNAB(oDlg,lDele)

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
		ChangeFile(.F.)
		If  Empty(cFile)
			Return .F.
		Endif

		If  cFile#cFileBack .AND. File(cFile)
			If  !MsgYesNo(OemToAnsi(STR0036),OemToAnsi(STR0049))  // "Arquivo LayOut j  existe grava por cima"
				cFile   :=""
				Return .F.
			Endif
		Endif
	Else
		If  !MsgYesNo(OemToAnsi(STR0037),OemToAnsi(STR0049))  // "Confirma Grava‡Æo do arquivo LayOut"
			Return .F.
		Endif
	EndIF

	If nBcoHdl > 0
		fClose(nBcoHdl)
	End

	nBcoHdl:=MSFCREATE(cFile,0)

	FSEEK(nBcoHdl,0,0)

	x043Form(aHeader,1)
	x043Form(aDetail,2)
	x043Form(aTrail ,3)

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
	Local lFechou := .F.
	If  Len(aHeader) > 0
		If  MsgYesNo(OemToAnsi(STR0038),OemToAnsi(STR0049))  // "Deleta arquivo LayOut"
			If nBcoHdl > 0
				lFechou := FCLOSE(nBcoHdl)
			Endif
			If lFechou
				FERASE(cFile)
			Else
				msgstop("NÇO FECHOU A BAGA€A !!!")
			Endif
		Endif
	Endif
	Return .T.


	/*
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Fun‡…o    ³LinOut    ³ Autor ³ Marcos Patricio       ³ Data ³ 05.02.96 ³±±
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
	Last change:  CIA   5 Feb 96    9:44 am
	*/
Static Function  LinOut(nItem,Folder,lProcess)

	Local nOpca     :=0
	Local cPosBco   :=Space(15)
	Local cPosIni   :=Space(03)
	Local cPosFin   :=Space(03)
	Local cLenDec   :=Space(01)
	Local cConteudo :=Space(60)

	If  (lProcess .AND. nRadio == 2) .OR. nOpcf==3
		Return
	Endif

	If  !lProcess
		If  Folder=="H"
			IF  Len(aHeader)==1 .AND. (Empty(aHeader[1,1]) .AND. Empty(aHeader[1,2]) .AND. Empty(aHeader[1,3]))
				MsgStop(OemToAnsi(STR0039),OemToAnsi(STR0049))  // "NÆo h  dados para altera‡Æo"
				Return
			Else
				cPosBco    :=OemToAnsi(aHeader[nItem,1])
				cPosIni    :=aHeader[nItem,2]
				cPosFin    :=aHeader[nItem,3]
				cLenDec    :=aHeader[nItem,4]
				cConteudo  :=OemToAnsi(aHeader[nItem,5])
			Endif
		Elseif Folder =="D"
			IF  Len(aDetail)==1 .AND. (Empty(aDetail[1,1]) .AND. Empty(aDetail[1,2]) .AND. Empty(aDetail[1,3]) )
				MsgStop(OemToAnsi(STR0039),OemToAnsi(STR0049))  // "NÆo h  dados para altera‡Æo"
				Return
			Else
				cPosBco    :=OemToAnsi(aDetail[nItem,1])
				cPosIni    :=aDetail[nItem,2]
				cPosFin    :=aDetail[nItem,3]
				cLenDec    :=aDetail[nItem,4]
				cConteudo  :=OemToAnsi(aDetail[nItem,5])
			Endif
		Else
			IF  Len(aTrail)==1 .AND. ( Empty(aTrail[1,1]) .AND. Empty(aTrail[1,2]) .AND. Empty(aTrail[1,3]) )
				MsgStop(OemToAnsi(STR0039),OemToAnsi(STR0049))  // "NÆo h  dados para altera‡Æo"
				Return
			Else
				cPosBco    :=OemToAnsi(aTrail[nItem,1])
				cPosIni    :=aTrail[nItem,2]
				cPosFin    :=aTrail[nItem,3]
				cLenDec    :=aTrail[nItem,4]
				cConteudo  :=OemToAnsi(aTrail[nItem,5])
			Endif
		Endif
	Endif

	DEFINE MSDIALOG oDlg FROM  15,6 TO 196,366 TITLE OemToAnsi(STR0049) PIXEL

	@ -2, 2 TO 74, 179 OF oDlg  PIXEL

	@ 08,05 SAY     STR0031                 SIZE 22, 07 OF oDlg PIXEL  // "Campo"
	@ 07,53 MSGET  cPosBco Picture "@X"    SIZE 70, 10 OF oDlg PIXEL

	@ 21,05 SAY     OemToAnsi(STR0040) SIZE 46, 07 OF oDlg PIXEL  // "Posi‡Æo Inicial"
	@ 20,53 MSGET  cPosIni  Picture "999" Valid ChkLi043(cPosIni,nItem,Folder,lProcess)     SIZE 21, 10 OF oDlg PIXEL

	@ 34,05 SAY     OemToAnsi(STR0041)   SIZE 41, 07 OF oDlg PIXEL  // "Posi‡Æo Final"
	@ 33,53 MSGET  cPosFin  Picture "999" Valid ChkLf043(cPosIni,cPosFin,nItem,Folder)      SIZE 21, 10 OF oDlg PIXEL

	@ 47,05 SAY     OemToAnsi(STR0034)   SIZE 028,07 OF oDlg PIXEL // "Decimais"
	@ 46,53 MSGET  cLenDec  Picture "9"    SIZE 011,10 OF oDlg PIXEL

	@ 60,05 SAY     OemToAnsi(STR0035)   SIZE 031,07 OF oDlg PIXEL  // "Conteudo"
	@ 59,53 MSGET   cConteudo               When Iif(nRadio==2,.F.,.T.) SIZE 123,10 OF oDlg PIXEL

	DEFINE SBUTTON FROM 77,124 TYPE 1 ENABLE OF oDlg ACTION (nOpca:=1, If( (ChkLi043(cPosIni,nItem,Folder,lProcess).AND.ChkLf043(cPosIni,cPosFin,nItem,Folder) ) ,oDlg:End(),nOpca:=0))
	DEFINE SBUTTON FROM 77,152 TYPE 2 ENABLE OF oDlg ACTION oDlg:End()

	ACTIVATE MSDIALOG oDlg CENTERED

	If  nOpca == 1
		If  nRadio=1 .AND. lProcess
			If Folder=="H"
				IF Len(aHeader)==1 .AND. ( Empty(aHeader[1,1]) .AND. Empty(aHeader[1,2]) .AND. Empty(aHeader[1,3]) )
					aHeader[1]   :={cPosBco,cPosIni,cPosFin,cLenDec,cConteudo}
				Else
					Aadd(aHeader,{cPosBco,cPosIni,cPosFin,cLenDec,cConteudo} )
				Endif
			Elseif Folder =="D"
				IF Len(aDetail)==1 .AND. ( Empty(aDetail[1,1]) .AND. Empty(aDetail[1,2]) .AND. Empty(aDetail[1,3]) )
					aDetail[1]   :={cPosBco,cPosIni,cPosFin,cLenDec,cConteudo}
				Else
					Aadd(aDetail,{cPosBco,cPosIni,cPosFin,cLenDec,cConteudo} )
				Endif
			Else
				IF Len(aTrail)==1 .AND. ( Empty(aTrail[1,1]) .AND. Empty(aTrail[1,2]) .AND. Empty(aDetail[1,3]) )
					aTrail[1]   :={cPosBco,cPosIni,cPosFin,cLenDec,cConteudo}
				Else
					Aadd(aTrail,{cPosBco,cPosIni,cPosFin,cLenDec,cConteudo} )
				Endif
			Endif
		Else
			If Folder=="H"
				aHeader[nItem]   :={cPosBco,cPosIni,cPosFin,cLenDec,cConteudo}
			Elseif Folder =="D"
				aDetail[nItem]   :={cPosBco,cPosIni,cPosFin,cLenDec,cConteudo}
			Else
				aTrail[nItem]    :={cPosBco,cPosIni,cPosFin,cLenDec,cConteudo}
			Endif
		Endif
	Endif

	Return


	/*
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Fun‡…o    ³ LinDel   ³ Autor ³ Marcos Patricio       ³ Data ³ 05.02.96 ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡…o ³ Deleta linha do LayOut                                     ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Sintaxe   ³ LiDel(nItem,Folder,oLbHeader,oLbDetail,oLbTrail)           ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Parametros³ nItem        - Item do array                               ³±±
	±±³          ³ Folder       - Pasta Focada                                ³±±
	±±³          ³ oLbHeader    - Objeto ListBox do Header                    ³±±
	±±³          ³ oLbDetail    - Objeto ListBox do Detail                    ³±±
	±±³          ³ oLbTrail     - Objeto ListBox do Trail                     ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³ Uso      ³ MATCONF                                                    ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	Last change:  CIA   5 Feb 96    9:44 am
	*/

Static Function LinDel(nItem,Folder,oLbHeader,oLbDetail,oLbTrail)

	If  nOpcf==3
		Return
	Endif

	If  nRadio=1
		If  Folder=="H"
			IF  Len(aHeader)==1 .AND. (Empty(aHeader[1,1]) .AND. Empty(aHeader[1,2]) .AND. Empty(aHeader[1,3]))
				MsgStop(OemToAnsi(STR0042),OemToAnsi(STR0049))  // "NÆo h  dados para dele‡Æo"
				Return
			Else
				If  MsgYesNo(OemToAnsi(STR0043),OemToAnsi(STR0049))  //"Confirma dele‡Æo"
					ADEL(aHeader,nItem)
					ASIZE(aHeader,Len(aHeader)-1)
				Endif
			Endif
			If  Len(aHeader) == 0
				aHeader :={{Space(15),Space(03),Space(03),Space(01),Space(60)}}
			Endif
			oLbHeader:SetArray(aHeader)
			oLbheader:bLine   := { || { aHeader[oLbHeader:nAt,1] ,;
				aHeader[oLbHeader:nAt,2] ,;
				aHeader[oLbHeader:nAt,3] ,;
				aHeader[oLbHeader:nAt,4] ,;
				aHeader[oLbHeader:nAt,5] } }
			oLbHeader:Refresh(.f.)

		Elseif Folder =="D"
			IF  Len(aDetail)==1 .AND. (Empty(aDetail[1,1]) .AND. Empty(aDetail[1,2]) .AND. Empty(aDetail[1,3]) )
				MsgStop(OemToAnsi(STR0042),OemToAnsi(STR0049))  // "NÆo h  dados para dele‡Æo"
				Return
			Else
				If  MsgYesNo(OemToAnsi(STR0043),OemToAnsi(STR0049))  // "Confirma dele‡Æo"
					ADEL(aDetail,nItem)
					ASIZE(aDetail,Len(aDetail)-1)
				Endif
			Endif
			If  Len(aDetail) == 0
				aDetail :={{Space(15),Space(03),Space(03),Space(01),Space(60)}}
			Endif
			oLbDetail:SetArray(aDetail)
			oLbDetail:bLine   := { || { aDetail[oLbDetail:nAt,1] ,;
				aDetail[oLbDetail:nAt,2] ,;
				aDetail[oLbDetail:nAt,3] ,;
				aDetail[oLbDetail:nAt,4] ,;
				aDetail[oLbDetail:nAt,5] } }
			oLbDetail:Refresh(.f.)

		Else
			IF  Len(aTrail)==1 .AND. (Empty(aTrail[1,1]) .AND.  Empty(aTrail[1,2]) .AND. Empty(aDetail[1,3]) )
				MsgStop(OemToAnsi(STR0042),OemToAnsi(STR0049))  // "NÆo h  dados para dele‡Æo"
				Return
			Else
				If  MsgYesNo(OemToAnsi(STR0043),OemToAnsi(STR0049)) // "Confirma dele‡Æo"
					ADEL(aTrail,nItem)
					ASIZE(aTrail,Len(aTrail)-1)
				Endif
			Endif
			If  Len(aTrail) == 0
				aTrail :={{Space(15),Space(03),Space(03),Space(01),Space(60)}}
			Endif
			oLbTrail:SetArray(aTrail)
			oLbTrail:bLine   := { || { aTrail[oLbTrail:nAt,1] ,;
				aTrail[oLbTrail:nAt,2] ,;
				aTrail[oLbTrail:nAt,3] ,;
				aTrail[oLbTrail:nAt,4] ,;
				aTrail[oLbTrail:nAt,5] } }
			oLbTrail:Refresh(.f.)

		Endif

	Endif
	Return


	/*
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Fun‡…o    ³ TypeFile ³ Autor ³ Marcos Patricio       ³ Data ³ 05.02.96 ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡…o ³ Seta o tipo de arqruivo em uso                             ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Sintaxe   ³ TypeFile()                                                 ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Parametros³                                                            ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³ Uso      ³ MATCONF                                                    ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	Last change:  CIA   5 Feb 96    9:44 am
	*/

Static Function TypeFile()

	If  nRadio==1
		cType    :=Iif(nOpcf==1,STR0022,STR0023)  // "Remessa | SIGA.CPE" ### "Remessa | *.CPE"
	Else
		cType   :=Iif(nOpcf==1,STR0024,STR0025)     // "Retorno | SIGA.CPR"  ### "Retorno | *.CPR"
	Endif

	Return Nil


	/*
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Fun‡…o    ³ FldTools ³ Autor ³ Marcos Patricio                 ³ Data ³ 05.02.96 ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡…o ³ Barra de botäes das pastas                                           ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Sintaxe   ³ FldTools(oFld,oLbHeader,oLbDetail,oLbTrail,nHeader,nDetail,nTrail)   ³±±                                         ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Parametros³ oFld         - Objeto do Folder                                      ³±±
	±±³          ³ oLbHeader    - Objeto ListBox do Header                              ³±±
	±±³          ³ oLbDetail    - Objeto ListBox do Detail                              ³±±
	±±³          ³ oLbTrail     - Objeto ListBox do Trail                               ³±±
	±±³          ³ nHeader      - Referencia da pasta do Objeto Folder                  ³±±
	±±³          ³ nDetail      - Referencia da pasta do Objeto Folder                  ³±±
	±±³          ³ nTrail       - Referencia da pasta do Objeto Folder                  ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³ Uso      ³ MATCONF                                                              ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	Last change:  CIA   5 Feb 96    9:44 am
	*/

Static FUNCTION FldTools(oFld,oLbHeader,oLbDetail,oLbTrail,nHeader,nDetail,nTrail)

	// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	// ³ As barras de botäes utilizados nos folders tˆm que ser dife-³
	// ³ devido ao tratamento PIXEL feito no Protheus                ³
	// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	#IFNDEF PROTHEUS

		@ .1,02 BUTTON OemToAnsi(STR0044) SIZE 50,20 OF oFld:aDialogs[nHeader] ACTION (LinOut(oLbHeader:nAt,"H",.T.),oLbHeader:Refresh())  //"Incluir"
		@ .1,15 BUTTON OemToAnsi(STR0020) SIZE 50,20 OF oFld:aDialogs[nHeader] ACTION (LinDel(oLbHeader:nAt,"H",oLbHeader),oLbHeader:Refresh())  //"Excluir"
		@ .1,28 BUTTON OemToAnsi(STR0045) SIZE 50,20 OF oFld:aDialogs[nHeader] ACTION (LinOut(oLbHeader:nAt,"H",.F.),oLbHeader:Refresh()) //"Editar"

		@ .1,02 BUTTON OemToAnsi(STR0044) SIZE 50,20 OF oFld:aDialogs[nDetail] ACTION (LinOut(olbDetail:nAt,"D",.T.),oLbDetail:Refresh())  //"Incluir"
		@ .1,15 BUTTON OemToAnsi(STR0020) SIZE 50,20 OF oFld:aDialogs[nDetail] ACTION (LinDel(oLbDetail:nAt,"D",oLbHeader,oLbDetail),oLbDetail:Refresh())  //"Excluir"
		@ .1,28 BUTTON OemToAnsi(STR0045) SIZE 50,20 OF oFld:aDialogs[nDetail] ACTION (LinOut(oLbDetail:nAt,"D",.F.),oLbDetail:Refresh()) //"Editar"

		@ .1,02 BUTTON OemToAnsi(STR0044) SIZE 50,20 OF oFld:aDialogs[nTrail] ACTION (LinOut(oLbTrail:nAt,"T",.T.),oLbTrail:Refresh())  //"Incluir"
		@ .1,15 BUTTON OemToAnsi(STR0020) SIZE 50,20 OF oFld:aDialogs[nTrail] ACTION (LinDel(oLbTrail:nAt,"T",oLbHeader,oLbDetail,oLbTrail),oLbTrail:Refresh())  //"Excluir"
		@ .1,28 BUTTON OemToAnsi(STR0045) SIZE 50,20 OF oFld:aDialogs[nTrail] ACTION (LinOut(oLbTrail:nAt,"T",.F.),oLbTrail:Refresh()) //"Editar"

	#ELSE

		@ .8,02 BUTTON OemToAnsi(STR0044) SIZE 25,10 PIXEL OF oFld:aDialogs[nHeader] ACTION (LinOut(oLbHeader:nAt,"H",.T.),oLbHeader:Refresh())  //"Incluir"
		@ .8,28 BUTTON OemToAnsi(STR0020) SIZE 25,10 PIXEL OF oFld:aDialogs[nHeader] ACTION (LinDel(oLbHeader:nAt,"H",oLbHeader),oLbHeader:Refresh())  //"Excluir"
		@ .8,54 BUTTON OemToAnsi(STR0045) SIZE 25,10 PIXEL OF oFld:aDialogs[nHeader] ACTION (LinOut(oLbHeader:nAt,"H",.F.),oLbHeader:Refresh()) //"Editar"

		@ .8,02 BUTTON OemToAnsi(STR0044) SIZE 25,10 PIXEL OF oFld:aDialogs[nDetail] ACTION (LinOut(olbDetail:nAt,"D",.T.),oLbDetail:Refresh())  //"Incluir"
		@ .8,28 BUTTON OemToAnsi(STR0020) SIZE 25,10 PIXEL OF oFld:aDialogs[nDetail] ACTION (LinDel(oLbDetail:nAt,"D",oLbHeader,oLbDetail),oLbDetail:Refresh())  //"Excluir"
		@ .8,54 BUTTON OemToAnsi(STR0045) SIZE 25,10 PIXEL OF oFld:aDialogs[nDetail] ACTION (LinOut(oLbDetail:nAt,"D",.F.),oLbDetail:Refresh()) //"Editar"

		@ .8,02 BUTTON OemToAnsi(STR0044) SIZE 25,10 PIXEL OF oFld:aDialogs[nTrail] ACTION (LinOut(oLbTrail:nAt,"T",.T.),oLbTrail:Refresh())  //"Incluir"
		@ .8,28 BUTTON OemToAnsi(STR0020) SIZE 25,10 PIXEL OF oFld:aDialogs[nTrail] ACTION (LinDel(oLbTrail:nAt,"T",oLbHeader,oLbDetail,oLbTrail),oLbTrail:Refresh())  //"Excluir"
		@ .8,54 BUTTON OemToAnsi(STR0045) SIZE 25,10 PIXEL OF oFld:aDialogs[nTrail] ACTION (LinOut(oLbTrail:nAt,"T",.F.),oLbTrail:Refresh()) //"Editar"

	#ENDIF

	RETURN NIL


	/*
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Fun‡…o    ³ X043Form ³ Autor ³ Wagner Xavier         ³ Data ³          ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡…o ³ Grava um Array no Novo Arquivo de Comunicao Bancaria       ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	*/
FuncTion x043Form(aComun,nIdent)

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


	/*
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Fun‡…o    ³ ChkLi043 ³ Autor ³ Wagner Xavier         ³ Data ³          ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡…o ³ Funcao de validacao da posicao Inicial                     ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	*/

FuncTion ChkLi043(cPos,nItem,Folder,lProcess)
	LOCAL lRet      := .F.
	Local cPosChk   := "000"

	If  nRadio == 1
		If  lProcess
			cPosChk := If(Folder=="H",aHeader[Len(aHeader),3],If(Folder=="D",aDetail[Len(aDetail),3],aTrail[Len(aTrail),3]))
		Elseif !lProcess .And. nItem > 1
			cPosChk := If(Folder=="H",aHeader[nItem-1,3],If(Folder=="D",aDetail[nItem-1,3],aTrail[nItem-1,3]))
		Endif
		IF  Val(cPos) == Val(cPosChk)+1
			lRet := .T.
		EndIF
	Else
		lRet := .T.
	Endif
	if  !lRet
		MsgStop(OemToAnsi(STR0046),OemToAnsi(STR0049))  // "Posi‡Æo inicial inv lida"
	endif

	Return lRet


	/*
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Fun‡…o    ³ ChkLf043 ³ Autor ³ Wagner Xavier         ³ Data ³          ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡…o ³ Funcao de validacao da posicao Final                       ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	*/
Function ChkLf043(cPosIni,cPosFim,nItem,Folder)
	LOCAL lRet := .T.
	IF  nRadio==1
		IF  (Val(cPosFim) < Val(cPosIni)) .And. (Val(cPosFim) <= 400)
			lRet := .F.
			MsgStop(OemToAnsi(STR0047),OemToAnsi(STR0049))  // "Posi‡Æo final menor que a inicial"
		EndIF
	EndIF
	Return lRet