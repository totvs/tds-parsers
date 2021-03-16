/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ DATA   ³ BOPS ³Program.³ALTERACAO                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³02.12.99³24097A³Alice   ³Permitir incluir periodo com mais de 31 dias   ³±±
±±ÀÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
#Include "FiveWin.ch"
#Include "CFGX045.ch"

// O bloco abaixo des-inverte um data composta por mes/dia para dia/mes
// para tratamento das datas digitadas em formato invertido.
STATIC bTrataData

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ CFGx045  ³ Autor ³ Pilar S. Albaladejo   ³ Data ³31.07.95  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Tabela de Periodos Contabeis (22)                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CFGx045(void)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Sem Argumentos                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Configurador   ³ Fun‡„o Relacionada ³ Entrada Dados (Todos)³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
Last change:  CIA  14 Feb 96    3:00 pm
*/
Function Cfgx045()
	*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	*³ Definicao das variaveis                                      ³
	*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Local   nCont
	Local   cRegistro
	Local   nTam
	Local   oTabela
	Local   oDlg
	Private aTabela := {}

	// O bloco abaixo des-inverte um data composta por mes/dia para dia/mes
	// para tratamento das datas digitadas em formato invertido.
	bTrataData := { |cMesAno| IF(UPPER(__Language) != "ENGLISH", cMesAno,RIGHT(cMesAno,2)+SUBSTR(cMesAno,3,1)+LEFT(cMesAno,2))}

	*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	*³ Leitura do arquivo de tabelas								³
	*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For nCont := 1 To 17
		dbSelectArea("SX5")
		If  dbSeek(cFilial+ "22" + StrZero(nCont,2))
			// Obtem o periodo
			cRegistro := IF(UPPER(__Language)="ENGLISH",X5_DESCENG,;
				IF(UPPER(__Language)="PORTUGUESE", X5_DESCRI, X5_DESCSPA))
				IF UPPER(__Language) != "ENGLISH"
					AADD(aTabela,{StrZero(nCont,2),SubStr(cRegistro,1,5),SubStr(cRegistro,7,5)})
				ELSE
					AADD(aTabela,{StrZero(nCont,2), InvPeriodo(SubStr(cRegistro,1,5)),;
						InvPeriodo(SubStr(cRegistro,7,5))})
				ENDIF
			Endif
		Next nCont

		*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		*³ Completa o numero de faixas da tabela                        ³
		*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nTam := Len(aTabela)
		If  nTam < 17
			For nCont := nTam+1 To 17
				AADD(aTabela,{StrZero(nCont,2),Space(05),Space(05)} )
			Next nCont
		Endif

		DEFINE MSDIALOG oDlg TITLE OemToAnsi(STR0001) From 9,0 To 27,50 OF oMainWnd // "Cadastramento da Tabela de Per¡odos Cont beis"

		@ 1.0,0.0 LISTBOX oTabela 	VAR cVarQ Fields;
			HEADER      OemToAnsi(STR0002),; // "Per¡odo"
		OemToAnsi(STR0003),; // "Dia/Mˆs Inicial"
		OemToAnsi(STR0004); // "Dia/Mˆs Final"
		COLSIZES 50,40,40;
			SIZE 160,120 ON DBLCLICK (EditTab(oTabela:nAt),oTabela:Refresh()) NOSCROLL

		oTabela:SetArray(aTabela)
		oTabela:bLine := { || { aTabela[oTabela:nAt,1],aTabela[oTabela:nAt,2],aTabela[oTabela:nAt,3]}}

		DEFINE SBUTTON FROM 15  ,169  TYPE 1 ACTION (nOpca := 1,If(Cfgx045Ok(),oDlg:End(),nOpca:=0) ) ENABLE OF oDlg
		DEFINE SBUTTON FROM 27.5,169  TYPE 2 ACTION oDlg:End() ENABLE OF oDlg

		#IFNDEF PROTHEUS
			ACTIVATE MSDIALOG oDlg CENTERED ON INIT TabTools(oTabela,oDlg)
		#ELSE
			ACTIVATE MSDIALOG oDlg CENTERED
		#ENDIF

		Return Nil


		/*
		ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
		±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
		±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
		±±³Fun‡…o    ³ Cf045Mes ³ Autor ³ Pilar S. Albaladejo   ³ Data ³31.07.95  ³±±
		±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
		±±³Descri‡…o ³ Valida se o mes foi digitado corretamente                  ³±±
		±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
		±±³Sintaxe e ³ cf045Mes(cExp1)		                                      ³±±
		±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
		±±³Parametros³ Mes/Ano 				                                      ³±±
		±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
		±±³ Uso      ³ Configurador   ³ Fun‡„o Relacionada ³ Entrada Dados (Todos)³±±
		±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
		±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
		ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
		*/
	STATIC FuncTion cf045Mes(cMes)

		If  Empty(cMes)
			Help(" ",1,"VAZIOTAB22")
			Return .F.
		Endif
		If  Val(SubStr(cMes,1,2)) > 31 .Or. Val(SubStr(cMes,1,2)) < 1
			Help(" ",1,"DIATAB22")
			Return .F.
		Endif
		If  Val(SubStr(cMes,4,2)) > 12 .Or. Val(SubStr(cMes,4,2)) < 1
			Help(" ",1,"MESTAB22")
			Return .F.
		Endif

		Return .T.

		/*
		ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
		±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
		±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
		±±³Fun‡…o    ³ Cf045Ini ³ Autor ³ Pilar S. Albaladejo   ³ Data ³03.08.95  ³±±
		±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
		±±³Descri‡…o ³ Valida se dia digitado e' o proximo apos o anterior -Inicio³±±
		±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
		±±³Sintaxe e ³ cf045Ini(cExp1,nExp1)	                                   ³±±
		±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
		±±³Parametros³ Dia/Mes,Numero do elemento                                 ³±±
		±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
		±±³ Uso      ³ Configurador   ³ Fun‡„o Relacionada ³ Entrada Dados (Todos)³±±
		±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
		±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
		ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
		*/
	STATIC FuncTion cf045Ini(cMes,nPos)
		Local dDataFim
		Local dDataINI

		If  nPos == 1				// Nao analisa 1a. posicao, pois nao ha data anterior.
			Return .T.
		Else
			//	Verifica se o proximo dia e' 01 caso o anterior seja o ultimo do mes
			If  (SubStr(EVAL(bTrataData,aTabela[nPos-1,3]),1,2) == "30" .And. ;
					SubStr(EVAL(bTrataData,aTabela[nPos-1,3]),4,2) $ "04~06~09~11") .Or.;
					(SubStr(EVAL(bTrataData,aTabela[nPos-1,3]),1,2) == "31")
				If  SubStr(cMes,1,2) != "01"
					Help(" ",1,"DTTAB22")
					Return .F.
				Else
					If  SubStr(EVAL(bTrataData,aTabela[nPos-1,3]),4,2) == SubStr(cMes,4,2)
						Help(" ",1,"DTTAB22")
						Return .F.
					Endif
				Endif
				//	Se o ultimo dia nao e' o ultimo do mes, verifica se o mes anterior
				//	e' menor que o atual. Se for -> erro
			ElseIf Abs( Val( SubStr(EVAL(bTrataData,aTabela[nPos-1,3]),4,2) ) - Val(SubStr(cMes,4,2))) > 1
				Help(" ",1,"DTTAB22")
				Return .F.
				//	Se o ultimo dia nao e' o ultimo do mes e o mes e' o mesmo para ambos,
				// verifica se a diferenca entre os dias e' maior que 1, se for -> erro
			ElseIf  SubStr(EVAL(bTrataData,aTabela[nPos-1,3]),4,2) == SubStr(cMes,4,2)
				If	Abs(Val(SubStr(EVAL(bTrataData,aTabela[nPos-1,3]),1,2)) - Val(SubStr(cMes,1,2))) > 1;
						.Or. Val(SubStr(EVAL(bTrataData,aTabela[nPos-1,3]),1,2)) >= Val(SubStr(cMes,1,2))
					Help(" ",1,"DTTAB22")
					Return .F.
				Endif
			ElseIf SubStr(cMes,1,2) != "01" .And. SubStr(EVAL(bTrataData,aTabela[nPos-1,3]),4,2) != SubStr(cMes,4,2)
				Help(" ",1,"DTTAB22")
				Return .F.
			ElseIf (SubStr(EVAL(bTrataData,aTabela[nPos-1,3]),4,2) <> SubStr(cMes,4,2))

				dDataFim := SubStr(EVAL(bTrataData,aTabela[nPos-1,3]),1,2)+"/"
				dDataFim += SubStr(EVAL(bTrataData,aTabela[nPos-1,3]),4,2)+"/"
				dDataFim += SubStr(StrZero(Year(dDataBase),4),3,2)
				dDataFim := Ctod(dDataFim,"DDMMYY")
				dDataIni := cMes+"/"
				dDataIni := dDataIni+SubStr(StrZero(Year(dDataBase),4),3,2)
				dDataIni := Ctod(dDataIni,"DDMMYY")

				If	(dDataIni <> (dDataFim+1))
					Help(" ",1,"DTTAB22")
					Return .F.
				EndIf

			Endif
		Endif
		Return .T.

		/*
		ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
		±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
		±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
		±±³Fun‡…o    ³ Cf045Fim ³ Autor ³ Pilar S. Albaladejo   ³ Data ³03.08.95  ³±±
		±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
		±±³Descri‡…o ³ Valida se dia digitado e' o proximo apos o anterior -Final ³±±
		±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
		±±³Sintaxe   ³ cf045Fim(cExp1,nExp1)	                                   ³±±
		±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
		±±³Parametros³ Dia/Mes Final,Dia/Mes Inicial                              ³±±
		±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
		±±³ Uso      ³ Configurador   ³ Fun‡„o Relacionada ³ Entrada Dados (Todos)³±±
		±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
		±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
		ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
		*/
	STATIC FuncTion cf045Fim(cMesFim,cMesIni)

		If  SubStr(cMesIni,4,2) != "12"
			dDataIni 	:=  Ctod(SubStr(cMesIni,1,5)+"/"+SubStr(StrZero(Year(dDataBase),4),3,2),"DDMMYY")
			If  SubStr(cMesFim,1,2) != "31"
				dDataFim := Ctod(SubStr(cMesFim,1,5)+"/"+SubStr(StrZero(Year(dDataBase),4),3,2),"DDMMYY")
			Else
				dDataFim := LastDay(Ctod("01/"+SubStr(cMesFim,4,2)+ "/"+SubStr(StrZero(Year(dDataBase),4),3,2),"DDMMYY"))
			Endif
			If  dDataFim <= dDataIni
				Help(" ",1,"DTTAB22")
				Return .F.
			Endif
		Else
			//	Mes de Dezembro
			If  SubStr(cMesIni,4,2) == SubStr(cMesFim,4,2)
				If  SubStr(cMesIni,1,2) >= SubStr(cMesFim,1,2)
					Help(" ",1,"DTTAB22")
					Return .F.
				Endif
			Else
				If  SubStr(cMesFim,4,2) != "01"
					Help(" ",1,"DTTAB22")
					Return .F.
				Endif
			Endif
		Endif

		Return .T.


	Function CFGX045OK()
		Local nCont

		Local   lErro := .F.

		If  nOpca == 1
			//	Confere cada um dos elementos da tabela
			For nCont := 1 To 17
				If  !Cf045Mes(EVAL(bTrataData,aTabela[nCont,2]))
					lErro := .T.
					Exit
				ElseIf !Cf045Mes(EVAL(bTrataData,aTabela[nCont,3]))
					lErro := .T.
					Exit
				ElseIf !Cf045Ini(EVAL(bTrataData,aTabela[nCont,2]),nCont)
					lErro := .T.
					Exit
				ElseIf !Cf045Fim(EVAL(bTrataData,aTabela[nCont,3]),EVAL(bTrataData,aTabela[nCont,2]))
					lErro := .T.
					Exit
				Endif
			Next nCont

			If  lErro
				lErro := .F.
				Help (" ",1,"TABELA22" )
				Return .F.
			Endif

			For nCont := 1 To 17
				dbSelectArea("SX5")
				If  dbSeek(cFilial+ "22" + StrZero(nCont,2))
					RecLock("SX5")
				Else
					RecLock("SX5",.T.)
					Replace X5_FILIAL   With 	cFilial
					Replace X5_TABELA	With	"22"
					Replace X5_CHAVE	With	StrZero(nCont,2)
				Endif
				Replace &(IF(UPPER(__Language)="ENGLISH","X5_DESCENG",;
					IF(UPPER(__Language)="PORTUGUESE", "X5_DESCRI", "X5_DESCSPA"))) With;
						EVAL(bTrataData,aTabela[nCont,2])+"-"+EVAL(bTrataData,aTabela[nCont,3])
					MsUnlock()
				Next nCont
				//	Analisa se a tabela esta preenchida corretamente
				If  Empty(DataTabela(.T.))
					Return .F.
				Endif
			Endif

			Return .T.

			/*
			±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
			±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
			±±³Fun‡…o    ³EditTab   ³ Autor ³ Marcos Patricio       ³ Data ³ 14.02.96 ³±±
			±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
			±±³Descri‡…o ³ Acepta linha da Tabela                                     ³±±
			±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
			±±³Sintaxe   ³ EditTab(nItem)                                             ³±±
			±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
			±±³Parametros³ nItem    - Item do array                                   ³±±
			±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
			±±³ Uso      ³ CONFIGURADOR                                               ³±±
			±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
			±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
			Last change:  CIA   5 Feb 96    9:44 am
			*/
		Function  EditTab(nItem,lAction)

			Local nOpca     :=0
			Local cPeriodo  :=""
			Local cMesIni   :=Space(05)
			Local cMesFim   :=Space(05)
			Local lVazio    :=.F.
			Local oDlg

			If  Len(aTabela)==1 .AND. (Empty(aTabela[1,1]) .AND. Empty(aTabela[1,2]) .AND. Empty(aTabela[1,3]) )
				MsgStop(OemToAnsi(STR0005),OemToAnsi(STR0006)) //"N„o h  dados para altera‡„o" ### "Tabela de Per¡odos Cont beis"
				Return
			Else
				cPeriodo   :=aTabela[nItem,1]
				cMesIni    :=aTabela[nItem,2]
				cMesFim    :=aTabela[nItem,3]
			Endif

			DEFINE MSDIALOG oDlg TITLE OemToAnsi(STR0006) FROM  15,6 TO 142,366 PIXEL OF oMainWnd // "Tabela de Per¡odos Cont beis"

			@ -2, 2 TO 48, 179 OF oDlg  PIXEL

			@ 08,05 SAY     oEmToAnsi(STR0002)               SIZE 22, 07 OF oDlg PIXEL // "Per¡odo"
			@ 07,53 MSGET   cPeriodo Picture "@X"   SIZE 70, 10 OF oDlg PIXEL When .F.

			@ 21,05 SAY     OemToAnsi(STR0003)    SIZE 46, 07 OF oDlg PIXEL // "Dia/Mˆs Inicial"
			@ 20,53 MSGET   cMesIni  Picture "99/99"        Valid Cf045Mes(EVAL(bTrataData,cMesIni)) .And. Cf045Ini(EVAL(bTrataData,cMesIni),nItem)     SIZE 21, 10 OF oDlg PIXEL

			@ 34,05 SAY     OemToAnsi(STR0004)      SIZE 41, 07 OF oDlg PIXEL // "Dia/Mˆs Final"
			@ 33,53 MSGET   cMesFim  Picture "99/99"        Valid Cf045Mes(EVAL(bTrataData,cMesFim)) .And. Cf045Fim(EVAL(bTrataData,cMesFim),EVAL(bTrataData,cMesIni))  SIZE 21, 10 OF oDlg PIXEL

			DEFINE SBUTTON FROM 51,124 TYPE 1 ENABLE OF oDlg ACTION (nOpca:=1, If( ((Cf045Mes(EVAL(bTrataData,cMesIni)) .And. Cf045Ini(EVAL(bTrataData,cMesIni),nItem)) .And. (Cf045Mes(EVAL(bTrataData,cMesFim)) .And. Cf045Fim(EVAL(bTrataData,cMesFim),EVAL(bTrataData,cMesIni))) ) ,oDlg:End(),nOpca:=0))
			DEFINE SBUTTON FROM 51,152 TYPE 2 ENABLE OF oDlg ACTION oDlg:End()

			ACTIVATE MSDIALOG oDlg CENTERED

			If  nOpca == 1
				aTabela[nItem]   :={cPeriodo,cMesIni,cMesFim}
			Endif

			Return Nil


		Function TabTools(oTabela,oDlg)

			Local oBarTabela

			DEFINE BUTTONBAR oBarTabela SIZE 25,25 3D TOP OF oDlg

			DEFINE BUTTON RESOURCE "EDIT"     OF oBarTabela ACTION (EditTab(oTabela:nAt),oTabela:Refresh())  TOOLTIP oEmtoAnsi(STR0007) // "Editar"

			Return Nil


			#IFDEF PROTHEUS
				// Para nao ocorrer erro no PROTHEUS, inclui a chamada do x020
				// (Conf.Imp/Exp) que nao existe para o Windows.
			Function CFGX020()
				HELP(" ",1,"NOPROTHEUS")
				Return

			#ENDIF

			// Inverte o dia/mes de um periodo para mes/dia
		STATIC FUNCTION InvPeriodo( cPeriodo )
			LOCAL cRet

			IF UPPER(__Language) != "ENGLISH"
				cRet := cPeriodo
			ELSE
				cRet := SubStr(cPeriodo,4,2)+SubStr(cPeriodo,3,1)+Left(cPeriodo,2)
			ENDIF

			RETURN cRet
