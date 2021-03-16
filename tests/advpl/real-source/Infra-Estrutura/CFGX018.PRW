/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ CFGx018  ³ Autor ³ Vinicius Barreira     ³ Data ³ 06.02.96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Configurador da Impress„o de Boletos                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ CFGx018(void)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Sem Argumentos                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Configurador   ³ Fun‡„o Relacionada ³ Entrada Dados (Todos)³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#include "FiveWin.ch"
#include "cfgx018.ch"

Function Cfgx018()
	LOCAL cArqfim
	LOCAL lJaCarregou := .F.,i
	LOCAL nLaco := 0,cArquivos,cAlias
	LOCAL oDlg,oCbx,oGet

	PRIVATE cL2:=cL3:=cL4:=cL6:="   "
	PRIVATE cL1:=cL5:=cL7:=cL8:=cL9:=cL10:=cL11:=cL12:=cL13:="   "
	PRIVATE cC2:=cC3:=cC4:=cC6:="   "
	PRIVATE cC1:=cC5:=cC7:=cC8:=cC9:=cC10:=cC11:=cC12:=cC13:="   "
	PRIVATE cC14:=cC15:="   "
	PRIVATE cL14:=cL15:="   "
	PRIVATE cSal:="   "
	PRIVATE cCol:=" "
	PRIVATE cPas:="   "
	PRIVATE cEqu:=" "
	PRIVATE cSex:=" "
	PRIVATE cMsg1 := cMsg2 := cMsg3 := space(80)
	PRIVATE cbanco := ""
	PRIVATE aBancos := {}
	PRIVATE nOpc := 0
	PRIVATE aObjGet := Array(38)


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Caso nao seja versao ACER, os arquivos SA1,SA6,SE1,SM4 deverao ³
	//³ ser abertos.                                                   ³
	//³ SA1->Cadastro de Clientes,SA6->Cadastro de Bancos,             ³
	//³ SE1->Titulos a Receber,SM4->Formulas                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea( "SX2" )
	Set Filter To
	cArquivos := "SE1"+"SA1"+"SA6"+ "SM4"
	For i  := 1 To Len(cArquivos) Step 3
		cAlias := Substr(cArquivos,i,3)
		dbSeek(cAlias)
		cArqFim := RetArq(__cRdd,Alltrim(SX2->X2_PATH)+TRIM(SX2->X2_ARQUIVO),.t.)
		If !MSFile(cArqFim)
			Help(" ",1,"NOFILE")
			Return
		Else
			IF !ChkFile(cAlias,.T.)
				HELP(" ",1,"EXCLUSIVO")
				dbSelectarea("SX2")
				return
			Endif
		Endif
	Next i


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Carrega o Array usado pelo ComboBox de escolha dos Bancos      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SA6")
	dbSeek( cFilial )
	While SA6->A6_FILIAL == cFilial .And. !Eof()

		lJaCarregou := .F.
		For nLaco := 1 to Len( aBancos )
			If Left( aBancos[nLaco] , Len(SA6->A6_COD) ) == SA6->A6_COD
				lJaCarregou := .T.
				Exit
			Endif
		EndFor
		If .NOT. lJaCarregou
			AADD( aBancos, SA6->A6_COD + " " + SA6->A6_NREDUZ  )
		Endif
		dbSkip()
	End
	If Len( aBancos ) > 0
		cBanco := aBancos[1]
		RestConf( .F. )
	Endif
	For nLaco := 1 to Len( aObjGet )
		aObjGet[nLaco] := oGet
	EndFor

	nOpc := 0
	DEFINE MSDIALOG oDlg FROM 36,1 TO 375,600 TITLE OemToAnsi(STR0001) PIXEL	// "Configura‡„o da Impress„o de Boletos"

	@ 015, 004 TO 169, 124 LABEL OemToAnsi(STR0002) OF oDlg  PIXEL  // "Conte£do do Boleto"
	@ 019, 068 TO 165,  95 LABEL OemToAnsi(STR0003) OF oDlg  PIXEL // "Lin"
	@ 019,  96 TO 165, 122 LABEL OemToAnsi(STR0004) OF oDlg  PIXEL // "Col"
	@ -02, 128 TO 046, 262 LABEL ""    OF oDlg  PIXEL
	@ 002, 206 TO 045, 232 LABEL OemToAnsi(STR0003) OF oDlg  PIXEL // "Lin"
	@ 002, 234 TO 045, 259.5 LABEL OemToAnsi(STR0004) OF oDlg  PIXEL // "Col"
	@ 048, 128 TO 119, 299 LABEL OemToAnsi(STR0005) OF oDlg  PIXEL // "Formata‡„o do Boleto"
	@ 052, 248 TO 117, 276 LABEL ""    OF oDlg  PIXEL
	@ 120, 128 TO 169, 299 LABEL OemToAnsi(STR0006) OF oDlg  PIXEL // "Mensagem"
	@ -02, 264 TO 046, 299 LABEL ""    OF oDlg  PIXEL

	@ 003, 004 COMBOBOX oCbx Var cBanco ITEMS aBancos SIZE 120, 105 OF oDlg PIXEL ON CHANGE RESTCONF(.T.)
	@ 025, 008 SAY OemToAnsi(STR0007)      SIZE 69, 07 OF oDlg PIXEL 		// "Local de Pagamento"
	@ 024, 070 MSGET aObjget[01] Var cL1   SIZE 12, 10 OF oDlg PIXEL Picture "999"
	@ 024,  97 MSGET aObjget[02] Var cC1   SIZE 12, 10 OF oDlg PIXEL Picture "999"
	@ 037, 008 SAY OemToAnsi(STR0008)      SIZE 70, 07 OF oDlg PIXEL 		// "Vencimento"
	@ 035, 070 MSGET aObjget[03] Var cL2   SIZE 12, 10 OF oDlg PIXEL Picture "999"
	@ 035,  97 MSGET aObjget[04] Var cC2   SIZE 12, 10 OF oDlg PIXEL Picture "999"
	@ 048, 008 SAY OemToAnsi(STR0009)      SIZE 70, 07 OF oDlg PIXEL 		// "Data Documento"
	@ 047, 070 MSGET aObjget[05] Var cL3   SIZE 12, 10 OF oDlg PIXEL Picture "999"
	@ 047,  97 MSGET aObjget[06] Var cC3   SIZE 12, 10 OF oDlg PIXEL Picture "999"
	@ 060, 008 SAY OemToAnsi(STR0010)  	 SIZE 70, 07 OF oDlg PIXEL				// "N£mero do Documento"
	@ 058, 070 MSGET aObjget[07] Var cL4   SIZE 12, 10 OF oDlg PIXEL Picture "999"
	@ 058,  97 MSGET aObjget[08] Var cC4   SIZE 12, 10 OF oDlg PIXEL Picture "999"
	@ 071, 008 SAY OemToAnsi(STR0011) 		 SIZE 70, 07 OF oDlg PIXEL				// "Esp‚cie do Documento"
	@ 069, 070 MSGET aObjget[09] Var cL5   SIZE 12, 10 OF oDlg PIXEL Picture "999"
	@ 069,  97 MSGET aObjget[10] Var cC5   SIZE 12, 10 OF oDlg PIXEL Picture "999"
	@ 082, 008 SAY OemToAnsi(STR0012)      SIZE 69, 07 OF oDlg PIXEL     		// "Aceite"
	@ 081, 070 MSGET aObjget[11] Var cL6   SIZE 12, 10 OF oDlg PIXEL Picture "999"
	@ 081,  97 MSGET aObjget[12] Var cC6   SIZE 12, 10 OF oDlg PIXEL Picture "999"
	@ 094, 008 SAY OemToAnsi(STR0013)      SIZE 70, 07 OF oDlg PIXEL      		//"Valor em R$"
	@ 092, 070 MSGET aObjget[13] Var cL7   SIZE 12, 10 OF oDlg PIXEL Picture "999"
	@ 092,  97 MSGET aObjget[14] Var cC7   SIZE 12, 10 OF oDlg PIXEL Picture "999"
	@ 105, 008 SAY OemToAnsi(STR0014)  SIZE 68, 07 OF oDlg PIXEL  				// "Valor em Outra Moeda"
	@ 104, 070 MSGET aObjget[15] Var cL8   SIZE 12, 10 OF oDlg PIXEL Picture "999"
	@ 104,  97 MSGET aObjget[16] Var cC8   SIZE 12, 10 OF oDlg PIXEL Picture "999"
	@ 117, 008 SAY OemToAnsi(STR0015)      SIZE 69, 07 OF oDlg PIXEL      		 //"Sacado"
	@ 115, 070 MSGET aObjget[17] Var cL9   SIZE 12, 10 OF oDlg PIXEL Picture "999"
	@ 115,  97 MSGET aObjget[18] Var cC9   SIZE 12, 10 OF oDlg PIXEL Picture "999"
	@ 128, 008 SAY OemToAnsi(STR0016)     SIZE 70, 07 OF oDlg PIXEL     		 // "Endere‡o / Bairro"
	@ 127, 070 MSGET aObjget[19] Var cL10  SIZE 12, 10 OF oDlg PIXEL Picture "999"
	@ 127,  97 MSGET aObjget[20] Var cC10  SIZE 12, 10 OF oDlg PIXEL Picture "999"
	@ 140, 008 SAY OemToAnsi(STR0017) SIZE 69, 07 OF oDlg PIXEL					// "Data do Processamento"
	@ 138, 070 MSGET aObjget[21] Var cL14  SIZE 12, 10 OF oDlg PIXEL Picture "999"
	@ 138,  97 MSGET aObjget[22] Var cC14  SIZE 12, 10 OF oDlg PIXEL Picture "999"
	@ 151, 008 SAY OemToAnsi(STR0018)  SIZE 69, 07 OF oDlg PIXEL					// "Munic¡pio/Estado/Cep"
	@ 149, 070 MSGET aObjget[23] Var cL11  SIZE 12, 10 OF oDlg PIXEL Picture "999"
	@ 149,  97 MSGET aObjget[24] Var cC11  SIZE 12, 10 OF oDlg PIXEL Picture "999"

	@ 011, 138 SAY OemToAnsi(STR0019)    SIZE 70, 07 OF oDlg PIXEL 				//"In¡cio da Mensagem"
	@ 009, 207 MSGET aObjget[25] Var cL12  SIZE 12, 10 OF oDlg PIXEL Picture "999"
	@ 009, 235 MSGET aObjget[26] Var cC12  SIZE 12, 10 OF oDlg PIXEL Picture "999"
	@ 022, 138 SAY OemToAnsi(STR0020)  SIZE 70, 07 OF oDlg PIXEL					// "Esp‚cie do Numer rio"
	@ 020, 207 MSGET aObjget[27] Var cL13  SIZE 12, 10 OF oDlg PIXEL Picture "999"
	@ 020, 235 MSGET aObjget[28] Var cC13  SIZE 12, 10 OF oDlg PIXEL Picture "999"
	@ 033, 138 SAY OemToAnsi(STR0021)              SIZE 70, 07 OF oDlg PIXEL 	//"Carteira"
	@ 032, 207 MSGET aObjget[29] Var cL15  SIZE 12, 10 OF oDlg PIXEL Picture "999"
	@ 032, 235 MSGET aObjget[30] Var cC15  SIZE 12, 10 OF oDlg PIXEL Picture "999"

	@ 060, 138 SAY OemToAnsi(STR0022)  SIZE 78, 7 OF oDlg PIXEL  // "Medidas em 1/6 ou 1/8 (6/8)"
	@ 058, 251 MSGET aObjget[31] Var cSex  SIZE 24, 10 OF oDlg PIXEL Picture "9"   Valid cSex $ "68"
	@ 071, 138 SAY OemToAnsi(STR0023)   SIZE 78, 07 OF oDlg PIXEL    // "Salto Entre Boletos"
	@ 069, 251 MSGET aObjget[32] Var cSal  SIZE 16, 10 OF oDlg PIXEL Picture "999"
	@ 082, 138 SAY OemToAnsi(STR0024) SIZE 78, 07 OF oDlg PIXEL   // "Colunas do Formul rio"
	@ 081, 251 MSGET aObjget[33] Var cCol  SIZE 24, 10 OF oDlg PIXEL Picture "9"   Valid cCol $ "12"
	@ 094, 138 SAY OemToAnsi(STR0025)   SIZE 78, 7 OF oDlg PIXEL   // "Distƒncia entre Colunas"
	@ 092, 251 MSGET aObjget[34] Var cPas  SIZE 16, 10 OF oDlg PIXEL Picture "999" When cCol == "2"
	@ 105, 138 SAY OemToAnsi(STR0026) SIZE 78, 7 OF oDlg PIXEL    // "2a.Coluna ‚ C¢pia da 1a.?"
	@ 104, 251 MSGET aObjget[35] Var cEqu  SIZE 24, 10 OF oDlg PIXEL Picture "!"   Valid cEqu $ "SN"  When cCol == "2"

	@ 129, 137 MSGET aObjget[36] Var cMsg1 SIZE 156,10 OF oDlg PIXEL Picture "@S31" valid cfgx018Bug()
	@ 141, 137 MSGET aObjget[37] Var cMsg2 SIZE 156,10 OF oDlg PIXEL Picture "@S31" valid cfgx018Bug()
	@ 153, 137 MSGET aObjget[38] Var cMsg3 SIZE 156,10 OF oDlg PIXEL Picture "@S31" valid cfgx018Bug()

	DEFINE SBUTTON FROM 09, 268 TYPE 1 ENABLE OF oDlg Action (nOpc:=1,oDlg:End())
	DEFINE SBUTTON FROM 27, 268 TYPE 2 ENABLE OF oDlg Action (nOpc:=0,oDlg:End())

	ACTIVATE MSDIALOG oDlg Centered

	*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	*³ Recebe as coordenadas para impress„o do boleto.              ³
	*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	/*  ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³ COORDENADAS DO CAMPO A6_BOLETO                               ³
	³ 001 = Linha do Local de Pagamento                            ³
	³ 004 = Coluna do Local de Pagamento                           ³
	³ 007 = Linha do Vencimento                                    ³
	³ 010 = Coluna do Vencimento                                   ³
	³ 013 = Linha da Data do Documento                             ³
	³ 016 = Coluna da Data do Documento                            ³
	³ 019 = Linha do Numero do Documento                           ³
	³ 022 = Coluna do Numero do Documento                          ³
	³ 025 = Linha da Especie do Documento                          ³
	³ 028 = Coluna da Especie do Documento                         ³
	³ 031 = Linha do Aceite                                        ³
	³ 034 = Coluna do Aceite                                       ³
	³ 037 = Linha do Valor em moeda vigente no pais                ³
	³ 040 = Coluna do Valor em moeda vigente no pais               ³
	³ 043 = Linha do Valor em outra moeda                          ³
	³ 046 = Coluna do Valor em outra moeda                         ³
	³ 049 = Linha do Sacado                                        ³
	³ 052 = Coluna do Sacado                                       ³
	³ 055 = Linha do Endereco / Bairro                             ³
	³ 058 = Coluna do Endereco / Bairro                            ³
	³ 061 = Linha do Municipio / Estado / CEP                      ³
	³ 064 = Coluna do Municipio / Estado / CEP                     ³
	³ 067 = Linha do Inicio da Mensagem                            ³
	³ 070 = Coluna do Inicio da Mensagem                           ³
	³ 073 = Salto entre Boletos                                    ³
	³ 076 = Colunas do Formulario (1/2)                            ³
	³ 077 = Distancia entre colunas                                ³
	³ 080 = Segunda Coluna e copia da primeira?                    ³
	³ 081 = Linha da Especie de Numerario                          ³
	³ 084 = Coluna da Especie de Numerario                         ³
	³ 087 = Medidas em 1/6" ou 1/8" (6/8)                          ³
	³ 088 = Linha da Data de Processamento                         ³
	³ 091 = Coluna da Data de Processamento                        ³
	³ 094 = Linha da Carteira                                      ³
	³ 097 = Coluna da Carteira                                     ³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/

	If cCol == "1"
		cPas := Space( 3 )
		cEqu := " "
	Endif

	IF nOpc == 1
		cBoleto := cL1+cC1+cL2+cC2+cL3+cC3+cL4+cC4+cL5+cC5+cL6+cC6+cL7+cC7+cL8+cC8+cL9+cC9+cL10+cC10+cL11+cC11+cL12+cC12+cSal+cCol+cPas+cEqu+cL13+cC13+cSex+cL14+cC14+cL15+cC15
		cMensag := cMsg1+cMsg2+cMsg3
		dbGoTop()
		Begin Transaction
			While !Eof()
				IF SA6->A6_COD == Left(cBanco,Len( SA6->A6_COD) )
					RecLock("SA6")
					SA6->A6_BOLETO := cBoleto
					SA6->A6_MENSAGE:= cMensag
				EndIF
				dbSkip( )
			EndDO
		End Transaction
	Endif

	#IFNDEF ACER
		dbSelectArea( "SA6" )
		dbCloseArea( )
		dbSelectArea( "SA1" )
		dbCloseArea( )
		dbSelectArea( "SE1" )
		dbCloseArea( )
		dbSelectArea ("SM4" )
		dbCloseArea( )
	#EndIF

	/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Fun‡…o    ³RestConfig³ Autor ³ Vinicius Barreira     ³ Data ³ 06.02.96 ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡…o ³Verifica as op‡”es j  configuradas ou cria default          ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Sintaxe e ³RestConf()                                                  ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Parametros³ Sem Argumentos                                             ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³ Uso      ³ Configurador   ³ Fun‡„o Relacionada ³ Entrada Dados (Todos)³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	*/
Static FuncTion RestConf( lRefresh )
	Local nLaco := 0

	If SA6->( dbSeek(  xFilial("SA6") + Left( cbanco, Len(SA6->A6_COD) ) ) ) .and. !Empty( SA6->A6_BOLETO )
		cL1  := SubStr( SA6->A6_BOLETO, 1,3 )
		cC1  := SubStr( SA6->A6_BOLETO, 4,3 )
		cL2  := SubStr( SA6->A6_BOLETO, 7,3 )
		cC2  := SubStr( SA6->A6_BOLETO,10,3 )
		cL3  := SubStr( SA6->A6_BOLETO,13,3 )
		cC3  := SubStr( SA6->A6_BOLETO,16,3 )
		cL4  := SubStr( SA6->A6_BOLETO,19,3 )
		cC4  := SubStr( SA6->A6_BOLETO,22,3 )
		cL5  := SubStr( SA6->A6_BOLETO,25,3 )
		cC5  := SubStr( SA6->A6_BOLETO,28,3 )
		cL6  := SubStr( SA6->A6_BOLETO,31,3 )
		cC6  := SubStr( SA6->A6_BOLETO,34,3 )
		cL7  := SubStr( SA6->A6_BOLETO,37,3 )
		cC7  := SubStr( SA6->A6_BOLETO,40,3 )
		cL8  := SubStr( SA6->A6_BOLETO,43,3 )
		cC8  := SubStr( SA6->A6_BOLETO,46,3 )
		cL9  := SubStr( SA6->A6_BOLETO,49,3 )
		cC9  := SubStr( SA6->A6_BOLETO,52,3 )
		cL10 := SubStr( SA6->A6_BOLETO,55,3 )
		cC10 := SubStr( SA6->A6_BOLETO,58,3 )
		cL11 := SubStr( SA6->A6_BOLETO,61,3 )
		cC11 := SubStr( SA6->A6_BOLETO,64,3 )
		cL12 := SubStr( SA6->A6_BOLETO,67,3 )
		cC12 := SubStr( SA6->A6_BOLETO,70,3 )
		cL13 := SubStr( SA6->A6_BOLETO,81,3 )
		cC13 := SubStr( SA6->A6_BOLETO,84,3 )
		cSal := SubStr( SA6->A6_BOLETO,73,3 )
		cCol := SubStr( SA6->A6_BOLETO,76,1 )
		cPas := SubStr( SA6->A6_BOLETO,77,3 )
		cEqu := SubStr( SA6->A6_BOLETO,80,1 )
		cSex := SubStr( SA6->A6_BOLETO,87,1 )
		cL14 := SubStr( SA6->A6_BOLETO,88,3 )
		cC14 := SubStr( SA6->A6_BOLETO,91,3 )
		cL15 := SubStr( SA6->A6_BOLETO,94,3 )
		cC15 := SubStr( SA6->A6_BOLETO,97,3 )

		IF !Empty(SA6->A6_MENSAGE)
			cMsg1 := SubStr(SA6->A6_MENSAGE,001,080)
			cMsg2 := SubStr(SA6->A6_MENSAGE,081,080)
			cMsg3 := SubStr(SA6->A6_MENSAGE,161,080)
		Endif

	Else
		cL2:=cL3:=cL4:=cL6:="   "
		cL1:=cL5:=cL7:=cL8:=cL9:=cL10:=cL11:=cL12:=cL13:="   "
		cC2:=cC3:=cC4:=cC6:="   "
		cC1:=cC5:=cC7:=cC8:=cC9:=cC10:=cC11:=cC12:=cC13:="   "
		cC14:=cC15:="   "
		cL14:=cL15:="   "
		cSal:="   "
		cCol:=" "
		cPas:="   "
		cEqu:=" "
		cSex:=" "
		cMsg1 := cMsg2 := cMsg3 := space(80)
	EndIF

	If lRefresh
		For nlaco := 1 to len( aObjGet )
			aObjGet[nLaco]:Refresh()
		EndFOr
	Endif

	Return .T.


	/*/
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Fun‡…o    ³ CA010Form³ Autor ³ Claudinei M. Benzi    ³ Data ³ 10/11/92 ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡…o ³ Rotina verificadora da formula digitada                    ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³ Uso      ³ CFGX018                                                    ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	*/
FUNCTION cfgx018Bug(void)
	LOCAL xResult,cForm:=&(ReadVar())
	LOCAL bBlock:=ErrorBlock(),bErro := ErrorBlock( { |e| ChekBug(e) } )
	PRIVATE lRet:=.T.

	IF Empty(cForm)
		Return .T.
	Endif

	BEGIN SEQUENCE
		xResult := &cForm
	END SEQUENCE

	ErrorBlock(bBlock)
	Return lRet

	/*/
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Fun‡…o    ³ ChekBug  ³ Autor ³ Claudinei M. Benzi    ³ Data ³ 10/11/92 ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡…o ³ Rotina analizadora do erro                                 ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³ Uso      ³ CFGX018                                                    ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	*/
Static Function Chekbug(e)
	IF e:gencode > 0
		HELP(" ",1,"ERR_MSG",,e:Description,1,1)
		lRet:=.F.
	Endif
	Break
