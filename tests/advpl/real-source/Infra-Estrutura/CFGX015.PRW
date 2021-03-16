
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ DATA   ³ BOPS ³Prograd.³ALTERACAO                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³13.10.98³18117A³Mauricio³Permitir no com 4 digitos.     			         ³±±
±±ÀÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
#Include "protheus.ch"
#Include "cfgx015.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ CFGx015  ³ Autor ³ Wagner Xavier         ³ Data ³08.07.92  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Configurador da Impress„o de Cheques                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CFGx015(void)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parƒmetros³ Sem Argumentos                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Configurador   ³ Fun‡„o Relacionada ³ Entrada Dados (Todos)³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

FuncTion Cfgx015()

	PRIVATE aRotina := { { STR0001  , "AxPesqui" , 0 , 1 },;  // "Pesquisar"
	{ STR0002  , "AxVisual" , 0 , 2 },;  // "Visualizar"
	{ STR0003 , "Cf15Conf" , 0 , 3 } }  // "Configurar"

	PRIVATE cCadastro := STR0007 // "Configuracao de Cheques"

	mBrowse( 6, 1,22,75,"SA6" )

	Return

	/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Fun‡„o    ³ Cf15Conf ³ Autor ³ Vinicius Barreira     ³ Data ³28.11.95  ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡„o ³ Configurador da Impress„o de Cheques                       ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Sintaxe   ³ CF15Conf()                                                 ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Parƒmetros³ Sem Argumentos                                             ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³ Uso      ³ Configurador   ³ Fun‡„o Relacionada ³ Entrada Dados (Todos)³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	/*/

Function cf15Conf()
	Local nSaveRec := SA6->(Recno())
	Local nOpc := 0
	LOCAL cBancocfg,cLayOut,cArqfim
	Local nRadio := 2
	Local nTipoChq := 1  //Cheque Normal
	Local oRadio
	Local cTitulo

	PRIVATE cSimbCfg,cImpvercfg,cMenscfg,cImpCopcfg,nQtdCopcfg,cImpSeqcfg
	PRIVATE cL2cfg:=cL3cfg:=cL4cfg:=cL6cfg:=cL12cfg:=cL16cfg:=cL17cfg:=" "
	PRIVATE cL1cfg:=cL5cfg:=cL7cfg:=cL8cfg:=cL9cfg:=cL10cfg:=cL11cfg:=cL14cfg:="  "
	PRIVATE cL13cfg:=cL15cfg:="   "

	/*/
	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³     Acessa ao Banco e recupera o padrao de impressao     ³
	³   da impressora de cheques modelo AUTOCHECK-DataRegis.   ³
	³       Conteudo do Campo A6_LAYOUT                        ³
	ÃÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
	³ Posicao³N§Bytes³Conteudo                                 ³
	ÃÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
	³     1  ³      2³Numero de Linhas do Cheque //Imp Normal  ³
	³     3  ³      1³Medidas Sextos ou Oitavos  //Imp Normal  ³
	³     4  ³      1³Linha em que sera impresso o valor       ³
	³     5  ³      1³Linha de impressao da 1¦linha do extenso ³
	³     6  ³      2³Coluna da 1¦ linha do extenso            ³
	³     8  ³      1³Linha da 2¦ linha do extenso             ³
	³     9  ³      2³Coluna da 2¦ linha do extenso            ³
	³    11  ³      2³Linha de impressao do Favorecido         ³
	³    13  ³      2³Coluna de impressao do Favorecido        ³
	³    15  ³      2³Linha de impressao da Cidade,Estado,Data ³
	³    17  ³      2³Coluna da virgula impressa no cheque     ³
	³    19  ³      1³Numero de casas para impress„o do ano    ³
	³    20  ³      3³Coluna para impress„o do ano             ³
	³    23  ³      2³Tamanho da 2¦ linha do extenso           ³
	³    25  ³      3³Coluna em que ser  impresso o valor      ³
	³    28  ³      1³Se deve compactar os caracteres do cheque³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	/*/

	cBancocfg:= SA6->A6_COD
	nOpc := 0

	If cPaisLoc == "BRA"
		// Tipos de configuracao de cheque
		// 1 -> Cheques Normais (SA6->A6_LAYOUT)
		// 2 -> Cheques CPMF (SA6->A6_LAYIPMF)

		//Tela de escolha do tipo do cheque
		DEFINE MSDIALOG oDlga FROM  094,1 TO 230,300 TITLE STR0037 PIXEL //"Tipo de Cheque a Configurar"

		@ 05,07 TO 45, 145 OF oDlga  PIXEL
		@ 10,10 Radio oRadio VAR nTipoChq ITEMS STR0038,STR0039 3D SIZE 125,10 OF oDlga PIXEL //"Cheques Normais"###"Cheques CPMF"

		DEFINE SBUTTON FROM 048,055 TYPE 1 ENABLE OF oDlga ACTION oDlga:End()
		ACTIVATE MSDIALOG oDlga CENTERED
	Else
		nTipoChq := 1
	Endif

	//Restaura configuracao atual
	RestOpcoes(nTipoChq)

	// Conversao das variaveis usadas nos check-box
	oImpVer := oImpCop := oImpSeq := o16 := oMesNum := Nil
	lImpVer := IIf(cImpVercfg == "S",.T.,.F.)
	lImpCop := Iif(cImpCopcfg == "S",.T.,.F.)
	lImpSeq := Iif(cImpSeqcfg == "S",.T.,.F.)
	l16     := Iif(cl16cfg    == "S",.T.,.F.)
	lMesNum := Iif(cl17cfg    == "S",.T.,.F.)

	DEFINE MSDIALOG oDlg FROM  38,1 TO 385,526 TITLE IIF(nTipoChq == 1,STR0040,STR0041)  PIXEL  //  //"Configuracao de Cheques"###"Configuracao de Cheques CPMF"

	@ -1, 4 TO 165, 128 LABEL "" OF oDlg  PIXEL
	@ -1, 134 TO 151, 262 LABEL "" OF oDlg  PIXEL
	@ 009, 016   SAY xPadL(STR0008,63) SIZE 63, 7 OF oDlg PIXEL // "Código do Banco"
	@ 020, 016   SAY xPadL(STR0009,63) SIZE 63, 7 OF oDlg PIXEL  // "Símbolo da Moeda"
	@ 031, 016   SAY xPadL(STR0010,63) SIZE 63, 7 OF oDlg PIXEL  // "Imprime no Verso"
	@ 042, 016   SAY xPadL(STR0011,61) SIZE 61, 7 OF oDlg PIXEL  // "Mensagem no Verso"
	@ 064, 016   SAY xPadL(STR0012,61) SIZE 61, 7 OF oDlg PIXEL  // "Imprime Cópia"
	@ 075, 016   SAY xPadL(STR0013,72) SIZE 72, 7 OF oDlg PIXEL	  // "Quantidade de Cópias"
	@ 088, 016   SAY xPadL(STR0014,81) SIZE 81, 7 OF oDlg PIXEL  // "Imprime Sequencia p/Cópia"
	@ 100, 016   SAY xPadL(STR0015,69) SIZE 69, 7 OF oDlg PIXEL  // "Imprime Compactado"
	@ 113, 016   SAY xPadL(STR0047,69) SIZE 69, 7 OF oDlg PIXEL  // "Mes em formato numerico"

	If nTipoChq == 1 //cheques normais
		@ 125, 016   SAY xPadL(STR0016,81) SIZE 81, 7 OF oDlg PIXEL  // "Nro.de Casas p/Ano"
		@ 138, 016   SAY xPadL(STR0017,53) SIZE 53, 7 OF oDlg PIXEL  // "Coluna do Ano"
		@ 150, 016   SAY xPadL(STR0018,87) SIZE 87, 7 OF oDlg PIXEL // "Tamanho das Linhas-Extenso"
	Else					//cheques cpmf
		@ 125, 016   SAY xPadL(STR0018,87) SIZE 87, 7 OF oDlg PIXEL // "Tamanho das Linhas-Extenso"
	Endif

	@ 006, 139   SAY xPadL(STR0019,63) SIZE 63, 7 OF oDlg PIXEL  // "Linhas do Formulário"
	@ 018, 139   SAY xPadL(STR0020,92) SIZE 92, 7 OF oDlg PIXEL  // "Medidas em 1/6 ou 1/8 Pol. (1/6)"
	@ 029, 139   SAY xPadL(STR0021,63) SIZE 63, 7 OF oDlg PIXEL  // "Linha do Valor"
	@ 040, 139   SAY xPadL(STR0022,65) SIZE 65, 7 OF oDlg PIXEL  // "1a. Linha do Extenso"
	@ 052, 139   SAY xPadl(STR0031,96) SIZE 96, 7 OF oDlg PIXEL  // "Coluna da 1a. Linha do Extenso"
	@ 063, 139   SAY xPadL(STR0023,61) SIZE 61, 7 OF oDlg PIXEL  // "2a. Linha do Extenso"
	@ 075, 139   SAY xPadL(STR0024,96) SIZE 96, 7 OF oDlg PIXEL  // "Coluna da 2a. Linha do Extenso"

	If nTipoChq == 1  //Cheque Normal
		@ 087, 139   SAY xPadL(STR0025,81) SIZE 81, 7 OF oDlg PIXEL  // "Linha do Favorecido"
		@ 098, 139   SAY xPadL(STR0026,61) SIZE 61, 7 OF oDlg PIXEL  // "Coluna do Favorecido"
		@ 111, 139   SAY xPadL(STR0027,53) SIZE 53, 7 OF oDlg PIXEL  // "Linha da Data"
		@ 124, 139   SAY xPadL(STR0028,53) SIZE 53, 7 OF oDlg PIXEL  // "Coluna da Vírgula"
		@ 136, 139   SAY xPadL(STR0030,53) SIZE 53, 7 OF oDlg PIXEL  // "Coluna do Valor"
	Else	           //Cheque CPMF
		@ 087, 139   SAY xPadL(STR0042,53) SIZE 53, 7 OF oDlg PIXEL //"Linha do Local"
		@ 098, 139   SAY xPadL(STR0043,61) SIZE 61, 7 OF oDlg PIXEL //"Coluna do Local"
		@ 111, 139   SAY xPadL(STR0044,53) SIZE 53, 7 OF oDlg PIXEL //"Coluna da Data"
		@ 124, 139   SAY xPadL(STR0045,53) SIZE 81, 7 OF oDlg PIXEL //"Coluna do Bco/Agencia"
		@ 136, 139   SAY xPadL(STR0046,53) SIZE 53, 7 OF oDlg PIXEL //"Coluna da Conta"
	Endif

	@ 007, 097   MSGET cBancocfg SIZE 22, 10 OF oDlg PIXEL READONLY
	@ 020, 097   MSGET cSimbcfg SIZE 22, 10 OF oDlg PIXEL Valid !Empty(cSimbcfg)
	@ 032, 097   CHECKBOX oImpVercfg VAR lImpVer PROMPT "" SIZE 11, 10 OF oDlg PIXEL
	@ 051, 012   MSGET cMenscfg SIZE 109, 10 OF oDlg PIXEL Picture "@S30"
	@ 063, 097   CHECKBOX oImpCopcfg VAR lImpCop PROMPT "" SIZE 11, 10 OF oDlg PIXEL
	@ 074, 097   MSGET nQtdCopcfg SIZE 15, 10 OF oDlg PIXEL Pict "9"
	@ 087, 097   CHECKBOX oImpSeqcfg VAR lImpSeq PROMPT "" SIZE 11, 10 OF oDlg PIXEL
	@ 099, 097   CHECKBOX ol16 VAR l16 PROMPT "" SIZE 11, 10 OF oDlg PIXEL
	@ 111, 097   CHECKBOX olMesNum VAR lMesNum PROMPT "" SIZE 11, 10 OF oDlg PIXEL

	If nTipoChq == 1  //Cheques Normais
		@ 122, 097   MSGET cl12cfg  SIZE 15, 10 OF oDlg PIXEL  Pict "9"   Valid cL12cfg$"1234"
		@ 135, 097   MSGET cl13cfg  SIZE 15, 10 OF oDlg PIXEL  Pict "999" Valid !Empty(cL13cfg)
		@ 148, 097   MSGET cl14cfg  SIZE 15, 10 OF oDlg PIXEL  Pict "99"  Valid !Empty(cL14cfg)
	Else
		@ 122, 097   MSGET cl14cfg  SIZE 15, 10 OF oDlg PIXEL  Pict "99"  Valid !Empty(cL14cfg)
	Endif

	@ 004, 235   MSGET cl1cfg   SIZE 16, 10 OF oDlg PIXEL  Pict "99"  Valid !Empty(cL1cfg)
	@ 016, 235   MSGET cl2cfg   SIZE 16, 10 OF oDlg PIXEL  Pict "9"   Valid cL2cfg$"68"
	@ 027, 235   MSGET cl3cfg   SIZE 16, 10 OF oDlg PIXEL  Pict "9"   Valid !Empty(cL3cfg)
	@ 038, 235   MSGET cl4cfg   SIZE 16, 10 OF oDlg PIXEL  Pict "9"   Valid !Empty(cL4cfg)
	@ 050, 235   MSGET cl5cfg   SIZE 16, 10 OF oDlg PIXEL  Pict "99"  Valid !Empty(cL5cfg)
	@ 061, 235   MSGET cl6cfg   SIZE 16, 10 OF oDlg PIXEL  Pict "9"   Valid !Empty(cL6cfg)
	@ 073, 235   MSGET cl7cfg   SIZE 16, 10 OF oDlg PIXEL  Pict "99"  Valid !Empty(cL7cfg)

	If nTipoChq == 1  //Cheque normal
		@ 085, 235   MSGET cl8cfg   SIZE 16, 10 OF oDlg PIXEL  Pict "99"  Valid !Empty(cL8cfg)
		@ 096, 235   MSGET cl9cfg   SIZE 16, 10 OF oDlg PIXEL  Pict "99"  Valid !Empty(cL9cfg)
		@ 109, 235   MSGET cl10cfg  SIZE 16, 10 OF oDlg PIXEL  Pict "99"  Valid !Empty(cL10cfg)
		@ 122, 235   MSGET cl11cfg  SIZE 16, 10 OF oDlg PIXEL  Pict "99"  Valid !Empty(cL11cfg)
		@ 134, 235   MSGET cl15cfg  SIZE 16, 10 OF oDlg PIXEL  Pict "999" Valid !Empty(cL15cfg)
	Else //Cheque CPMF
		@ 085, 235   MSGET cl8cfg   SIZE 16, 10 OF oDlg PIXEL  Pict "99"  Valid !Empty(cL8cfg)
		@ 096, 235   MSGET cl9cfg   SIZE 16, 10 OF oDlg PIXEL  Pict "99"  Valid !Empty(cL9cfg)
		@ 109, 235   MSGET cl10cfg  SIZE 16, 10 OF oDlg PIXEL  Pict "99"  Valid !Empty(cL10cfg)
		@ 122, 235   MSGET cl11cfg  SIZE 16, 10 OF oDlg PIXEL  Pict "99"  Valid !Empty(cL11cfg)
		@ 134, 235   MSGET cl15cfg  SIZE 16, 10 OF oDlg PIXEL  Pict "999" Valid !Empty(cL15cfg)
	Endif

	DEFINE SBUTTON FROM 154, 173 TYPE 1 ENABLE OF oDlg ACTION (nOpc := 1,oDlg:End())
	DEFINE SBUTTON FROM 154, 203 TYPE 2 ENABLE OF oDlg ACTION (oDlg:End())

	ACTIVATE MSDIALOG oDlg CENTERED

	IF nOpc==1

		Begin Transaction

			// Conversao das variaveis usadas no checkbox
			cImpVercfg := IIf(lImpVer ,"S","N")
			cImpCopcfg := Iif(lImpCoP ,"S","N")
			cImpSeqcfg := Iif(lImpSeq ,"S","N")
			cl16cfg    := Iif(l16     ,"S","N")
			cl17cfg    := Iif(lMesNum ,"S","N")

			dbSelectArea("SX6")
			dbSetOrder(1)
			If dbSeek("MV_SIMB1")
				RecLock("SX6",.F.)
				Replace X6_CONTEUD With cSimbcfg
			Endif
			dbSelectArea("SA6")

			cL1cfg  := StrZero( Val( cL1CFG ),2,0 )
			cL2cfg  := StrZero( Val( cL2CFG ),1,0 )
			cL3cfg  := StrZero( Val( cL3CFG ),1,0 )
			cL4cfg  := StrZero( Val( cL4CFG ),1,0 )
			cL5cfg  := StrZero( Val( cL5CFG ),2,0 )
			cL6cfg  := StrZero( Val( cL6CFG ),1,0 )
			cL7cfg  := StrZero( Val( cL7CFG ),2,0 )
			cL8cfg  := StrZero( Val( cL8CFG ),2,0 )
			cL9cfg  := StrZero( Val( cL9CFG ),2,0 )
			cL10cfg := StrZero( Val( cL10CFG ),2,0 )
			cL11cfg := StrZero( Val( cL11CFG ),2,0 )
			cL12cfg := StrZero( Val( cL12CFG ),1,0 )
			cL13cfg := StrZero( Val( cL13CFG ),3,0 )
			cL14cfg := StrZero( Val( cL14CFG ),2,0 )
			cL15cfg := StrZero( Val( cL15CFG ),3,0 )

			cLayOut :=	cL1cfg+cL2cfg+cL3cfg+cL4cfg+;
				cL5cfg+cL6cfg+cL7cfg+cL8cfg+;
				cL9cfg+cL10cfg+cL11cfg+cL12cfg+;
				cL13cfg+cL14cfg+cL15cfg+cL16cfg+cL17cfg

			DEFINE MSDIALOG oDlg FROM  094,1 TO 230,300 TITLE STR0033 PIXEL //"Gravar Configuracoes"

			@ 05,07 TO 45, 145 OF oDlg  PIXEL
			@ 10,10 Radio oRadio VAR nRadio;
				ITEMS STR0034,;	//"Para todas as contas deste banco"
			STR0036,;	//"Apenas para contas deste banco nesta filial"
			STR0035;		//"Apenas esta conta corrente"
			3D SIZE 125,10 OF oDlg PIXEL

			DEFINE SBUTTON FROM 048,055 TYPE 1 ENABLE OF oDlg ACTION oDlg:End()
			ACTIVATE MSDIALOG oDlg CENTERED

			// Repassa para todos as contas do banco independente da Filial
			If nRadio == 1
				dbGoTop()
				While !EOF()
					If SA6->A6_COD == cBancocfg
						RecLock("SA6")
						If nTipoChq == 1
							Replace A6_LAYOUT With cLayOut
						Else
							Replace A6_LAYIPMF With cLayOut
						Endif
					Endif
					dbSkip()
				Enddo
				//Repassa para todas as contas do banco na filial
			ElseIf nRadio == 2
				dbSeek( xFilial("SA6") + cBancocfg )  // Procura o primeiro cadastrado
				While !EOF() .and. xFilial("SA6") == SA6->A6_FILIAL .AND. SA6->A6_COD == cBancocfg
					RecLock("SA6")
					If nTipoChq == 1
						Replace A6_LAYOUT With cLayOut
					Else
						Replace A6_LAYIPMF With cLayOut
					Endif
					dbSkip()
				Enddo
				// Apenas nesta conta
			ElseIf nRadio == 3
				RecLock("SA6")
				If nTipoChq == 1
					Replace A6_LAYOUT With cLayOut
				Else
					Replace A6_LAYIPMF With cLayOut
				Endif
			Endif

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Grava como parƒmetros alguns dos campos dos cheques     ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSelectArea("SX6")

			GETMV("MV_IMPCOP")
			RecLock("SX6")
			SX6->X6_Conteud := cImpCopcfg
			MsUnlock()
			GETMV("MV_QTDCOP")
			RecLock("SX6")
			SX6->X6_Conteud := str(nQtdCopcfg,1,0)
			MsUnlock()
			GETMV("MV_IMPSEQ")
			RecLock("SX6")
			SX6->X6_Conteud := cImpSeqcfg
			MsUnlock()
			GetMv("MV_IMPVER")
			RecLock("SX6")
			SX6->X6_CONTEUD := cImpVercfg
			MsUnlock()
			GetMv("MV_MENS")
			RecLock("SX6")
			SX6->X6_CONTEUD := cMenscfg
			MsUnlock()

		End Transaction
	EndIF

	SA6->(dbGoto( nSaveRec ))


	/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Fun‡„o    ³RestOpcoes³ Autor ³ Wagner Xavier         ³ Data ³08.07.92  ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡„o ³Verifica as op‡”es j  configuradas ou cria default          ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Sintaxe e ³RestOpcoes()                                                ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Parametros³ Sem Argumentos                                             ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³ Uso      ³ Configurador   ³ Fun‡„o Relacionada ³ Entrada Dados (Todos)³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	/*/
Static FuncTion RestOpcoes(nTipoChq)

	cSimbcfg   := GETMV("MV_SIMB1")
	cImpVercfg := GETMV("MV_IMPVER")
	cMenscfg   := GETMV("MV_MENS")
	cMenscfg   := Iif( Empty(cMenscfg), STR0032, cMenscfg ) // "Cheque favorecido a           "
	cMenscfg   := IIf( Len(cMenscfg) < 40,  cMenscfg += Spac(40-Len(cMenscfg)), cMenscfg )

	cImpCopcfg := GETMV("MV_IMPCOP")
	nQtdCopcfg := GETMV("MV_QTDCOP")
	cImpSeqcfg := GETMV("MV_IMPSEQ")

	If nTipoChq == 1   //Cheque Normal
		IF !Empty(SA6->A6_LAYOUT)
			cL1cfg  := StrZero( Val( SubStr( SA6->A6_LAYOUT, 1,2 ) ),2,0 )
			cL2cfg  := StrZero( Val( SubStr( SA6->A6_LAYOUT, 3,1 ) ),1,0 )
			cL3cfg  := StrZero( Val( SubStr( SA6->A6_LAYOUT, 4,1 ) ),1,0 )
			cL4cfg  := StrZero( Val( SubStr( SA6->A6_LAYOUT, 5,1 ) ),1,0 )
			cL5cfg  := StrZero( Val( SubStr( SA6->A6_LAYOUT, 6,2 ) ),2,0 )
			cL6cfg  := StrZero( Val( SubStr( SA6->A6_LAYOUT, 8,1 ) ),1,0 )
			cL7cfg  := StrZero( Val( SubStr( SA6->A6_LAYOUT, 9,2 ) ),2,0 )
			cL8cfg  := StrZero( Val( SubStr( SA6->A6_LAYOUT,11,2 ) ),2,0 )
			cL9cfg  := StrZero( Val( SubStr( SA6->A6_LAYOUT,13,2 ) ),2,0 )
			cL10cfg := StrZero( Val( SubStr( SA6->A6_LAYOUT,15,2 ) ),2,0 )
			cL11cfg := StrZero( Val( SubStr( SA6->A6_LAYOUT,17,2 ) ),2,0 )
			cL12cfg := StrZero( Val( SubStr( SA6->A6_LAYOUT,19,1 ) ),1,0 )
			cL13cfg := StrZero( Val( SubStr( SA6->A6_LAYOUT,20,3 ) ),3,0 )
			cL14cfg := StrZero( Val( SubStr( SA6->A6_LAYOUT,23,2 ) ),2,0 )
			cL15cfg := StrZero( Val( SubStr( SA6->A6_LAYOUT,25,3 ) ),3,0 )
			cL16cfg := SubStr( SA6->A6_LAYOUT,28,1 )
			cL17cfg := SubStr( SA6->A6_LAYOUT,29,1 )
		EndIF
	Else
		IF !Empty(SA6->A6_LAYIPMF)
			cL1cfg  := StrZero( Val( SubStr( SA6->A6_LAYIPMF, 1,2 ) ),2,0 )
			cL2cfg  := StrZero( Val( SubStr( SA6->A6_LAYIPMF, 3,1 ) ),1,0 )
			cL3cfg  := StrZero( Val( SubStr( SA6->A6_LAYIPMF, 4,1 ) ),1,0 )
			cL4cfg  := StrZero( Val( SubStr( SA6->A6_LAYIPMF, 5,1 ) ),1,0 )
			cL5cfg  := StrZero( Val( SubStr( SA6->A6_LAYIPMF, 6,2 ) ),2,0 )
			cL6cfg  := StrZero( Val( SubStr( SA6->A6_LAYIPMF, 8,1 ) ),1,0 )
			cL7cfg  := StrZero( Val( SubStr( SA6->A6_LAYIPMF, 9,2 ) ),2,0 )
			cL8cfg  := StrZero( Val( SubStr( SA6->A6_LAYIPMF,11,2 ) ),2,0 )
			cL9cfg  := StrZero( Val( SubStr( SA6->A6_LAYIPMF,13,2 ) ),2,0 )
			cL10cfg := StrZero( Val( SubStr( SA6->A6_LAYIPMF,15,2 ) ),2,0 )
			cL11cfg := StrZero( Val( SubStr( SA6->A6_LAYIPMF,17,2 ) ),2,0 )
			cL12cfg := StrZero( Val( SubStr( SA6->A6_LAYIPMF,19,1 ) ),1,0 )
			cL13cfg := StrZero( Val( SubStr( SA6->A6_LAYIPMF,20,3 ) ),3,0 )
			cL14cfg := StrZero( Val( SubStr( SA6->A6_LAYIPMF,23,2 ) ),2,0 )
			cL15cfg := StrZero( Val( SubStr( SA6->A6_LAYIPMF,25,3 ) ),3,0 )
			cL16cfg := SubStr( SA6->A6_LAYIPMF,28,1 )
			cL17cfg := SubStr( SA6->A6_LAYIPMF,29,1 )
		EndIF
	Endif
	Return .T.
