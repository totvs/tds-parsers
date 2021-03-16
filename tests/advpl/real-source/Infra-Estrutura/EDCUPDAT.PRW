#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³EDCUPDAT º Autor ³ EMERSON DIB	     º Data ³  03/02/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ RDMAKE PARA ATUALIZACAO DOS DADOS DO EEC, EE9, SW8 e SB1   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SIGAEDC                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

*-----------------*
Function EDCUPDAT()
	*-----------------*

	// AtualizaArqs()
	AtualizaSW8()
	AtualizaEEC()
	AtualizaSB1()

	SW8->(DbSetOrder(1))
	RETURN
	*-----------------------------*
STATIC Function AtualizaArqs()
	*-----------------------------*
	Local cFilSW4 := xFilial("SW4")
	Local cFilSW5 := xFilial("SW5")
	Local cFilSW8 := xFilial("SW8")
	Local cFilSWP := xFilial("SWP")
	Local cAto, cHawb, nReg, nTotArq:= SW4->(RecCount())

	BEGIN SEQUENCE

		SW8->(DbSetOrder(3))
		SW4->(DbGotop())
		SW4->(DBSEEK(cFilSW4,.T.))
		DO WHILE ! SW4->(EOF()) .AND. SW4->W4_FILIAL=cFilSW4
			nReg += 1
			// Verifica o SW5
			If SW5->(DBSEEK(cFilSW5+SW4->W4_PGI_NUM))

				// Ato Atual
				cAto := SW4->W4_ATO_CON
				cHawb:= SW5->W5_HAWB
				Do While ! SW5->(EOF()) .AND. SW5->W5_FILIAL=cFilSW5 .And. SW5->W5_PGI_NUM == SW4->W4_PGI_NUM
					Reclock('SW5',.F.)
					SW5->W5_AC := cAto
					SW5->(MSUNLOCK())

					// Verifica o SW8
					SW8->(DBSEEK(cFilSW8+SW5->W5_HAWB+SW5->W5_PGI_NUM+SW5->W5_PO_NUM+SW5->W5_SI_NUM+SW5->W5_CC+SW5->W5_COD_I+STR(SW5->W5_REG,4,0)))
					Do While ! SW8->(EOF()) .AND. SW8->W8_FILIAL=cFilSW8 .And. SW8->W8_HAWB+SW8->W8_PGI_NUM+SW8->W8_PO_NUM+SW8->W8_SI_NUM+SW8->W8_CC+SW8->W8_COD_I+STR(SW8->W8_REG,4,0) == SW5->W5_HAWB+SW5->W5_PGI_NUM+SW5->W5_PO_NUM+SW5->W5_SI_NUM+SW5->W5_CC+SW5->W5_COD_I+STR(SW5->W5_REG,4,0)
						Reclock('SW8',.F.)
						SW8->W8_AC     := cAto
						SW8->(MSUNLOCK())
						SW8->(DbSkip())
					Enddo
					SW5->(DbSkip())
				Enddo

				// Verifica o SWP
				SWP->(DBSEEK(cFilSWP+SW4->W4_PGI_NUM))
				Do While ! SWP->(EOF()) .AND. SWP->WP_FILIAL=cFilSWP .And. SWP->WP_PGI_NUM == SW4->W4_PGI_NUM
					Reclock('SWP',.F.)
					SWP->WP_AC := cAto
					SWP->(MSUNLOCK())
					SWP->(DbSkip())
				Enddo
			Endif
			SW4->(DbSkip())
		Enddo

		SW8->(DbSetOrder(1))

	END SEQUENCE

	RETURN

	*-----------------------------*
STATIC Function AtualizaSW8()
	*-----------------------------*
	Local cFilSW8 := xFilial("SW8"), nReg:=0, nTotSW8:= SW8->(RecCount())

	SA5->(DBSETORDER(3))
	SW8->(DBGOTOP())

	Do While ! SW8->(EOF())
		nReg+=1
		If Empty(SW8->W8_UNID)
			If SA5->A5_PRODUTO<>SW8->W8_COD_I .or. SA5->A5_FABR<>SW8->W8_FABR .or. SA5->A5_FORNECE<>SW8->W8_FORN
				SA5->(dbSeek(xFilial("SA5")+SW8->W8_COD_I+SW8->W8_FABR+SW8->W8_FORN))
			EndIf
			If Empty(SA5->A5_UNID)
				If SB1->B1_COD <> SW8->W8_COD_I
					SB1->(dbSeek(xFilial("SB1")+SW8->W8_COD_I))
				EndIf
				cUnid := SB1->B1_UM
			Else
				cUnid := SA5->A5_UNID
			EndIf

			Reclock('SW8',.F.)
			SW8->W8_UNID  := cUnid
			SW8->(MSUNLOCK())
		EndIf
		SW8->(DbSkip())
	Enddo
	SA5->(DBSETORDER(1))
	Return .T.

	*----------------------------*
STATIC Function AtualizaEEC()
	*----------------------------*
	Local cFilEEC := xFilial("EEC"),nReg:=0, nTotEEc:= EEC->(RecCount()), cFilEE9 := xFilial("EE9")
	Local nDec := AVSX3("EE9_PERCOM",4), nTotComis, nTotFob
	EE9->(DBSETORDER(2))

	EEC->(DBGOTOP())
	Do While ! EEC->(EOF())
		nReg+=1
		If EEC->EEC_COBCAMB $ "SN " .OR. EEC->EEC_AMOSTR $ "SN " .OR. EEC->EEC_PRECOA $ "SN " .OR. EEC->EEC_PGTANT $ "SN " .OR. EEC->EEC_EXLIMP $ "SN " .OR. EEC->EEC_BRUEMB $ "SN "
			Reclock('EEC',.F.)
			If EEC->EEC_BRUEMB == "S"
				EEC->EEC_BRUEMB := "1"
			ElseIf EEC->EEC_BRUEMB == "N"
				EEC->EEC_BRUEMB := "2"
			Endif
			If EEC->EEC_EXLIMP == "S"
				EEC->EEC_EXLIMP := "1"
			ElseIf EEC->EEC_EXLIMP == "N"
				EEC->EEC_EXLIMP := "2"
			Endif
			If EEC->EEC_PGTANT == "S"
				EEC->EEC_PGTANT := "1"
			ElseIf EEC->EEC_PGTANT == "N"
				EEC->EEC_PGTANT := "2"
			Endif
			If EEC->EEC_PRECOA == "S"
				EEC->EEC_PRECOA := "1"
			ElseIf EEC->EEC_PRECOA == "N"
				EEC->EEC_PRECOA := "2"
			Endif
			If EEC->EEC_COBCAMB == "S"
				EEC->EEC_COBCAMB := "1"
			ElseIf EEC->EEC_COBCAMB == "N"
				EEC->EEC_COBCAMB := "2"
			Endif
			If EEC->EEC_AMOSTR == "S"
				EEC->EEC_AMOSTR := "1"
			ElseIf EEC->EEC_AMOSTR == "N"
				EEC->EEC_AMOSTR := "2"
			Endif
			EEC->(MSUNLOCK())
		Endif
		EE9->(DBSEEK(cFilEEC+EEC->EEC_PREEMB))

		nTotComis := 0
		nTotFob := (EEC->EEC_TOTPED+EEC->EEC_DESCON)-(EEC->EEC_FRPREV+EEC->EEC_FRPCOM+EEC->EEC_SEGPRE+EEC->EEC_DESPIN+AvGetCpo("EEC->EEC_DESP1")+AvGetCpo("EEC->EEC_DESP2"))
		IF (EEC->EEC_TIPCVL == "1" )
			// Percetual (Pegar direto)
			nTotComis := EEC->EEC_VALCOM
		ElseIF (EEC->EEC_TIPCVL == "2" )
			nTotComis := Round(100*(EEC->EEC_VALCOM/nTotFob),2)
		Endif
		If nTotComis > 99.99
			nTotComis := 99.99
		EndIf

		If nTotComis # 0
			Do While ! EE9->(EOF()) .AND. cFilEEC = cFilEE9 .AND. EE9->EE9_PREEMB = EEC->EEC_PREEMB
				RecLock("EE9",.F.)
				EE9->EE9_PERCOM := Round(nTotComis,nDec)
				EE9->(MsUnlock())
				EE9->(DBSKIP())
			EndDo
		EndIf

		EEC->(DbSkip())
	Enddo

	Return .T.


	*----------------------------*
STATIC Function AtualizaSB1()
	*----------------------------*
	Local cFilSB1 := xFilial("SB1"),nReg:=0, nTotSB1:= SB1->(RecCount())
	Private cFilSB1Aux:= xFilial("SB1")
	Private lAbriuExp := AbreArqExp("SB1",ALLTRIM(GETMV("MV_EMPEXP",,"")),ALLTRIM(GETMV("MV_FILEXP",,"  ")),cFilSB1Aux) // Abre arq. produtos de outra Empresa/Filial de acordo com os parametros.
	SB1->(DBSETORDER(1))

	SB1->(DBGOTOP())
	Do While ! SB1->(EOF())
		nReg+=1
		If SB1->B1_ANUENTE $ "SN " .OR. SB1->B1_MIDIA $ "SN "
			Reclock('SB1',.F.)
			If SB1->B1_ANUENTE == "S"
				SB1->B1_ANUENTE := "1"
			ElseIf SB1->B1_ANUENTE == "N"
				SB1->B1_ANUENTE := "2"
			Endif
			If SB1->B1_MIDIA == "S"
				SB1->B1_MIDIA := "1"
			ElseIf SB1->B1_MIDIA == "N"
				SB1->B1_MIDIA := "2"
			Endif
			SB1->(MSUNLOCK())
		Endif
		SB1->(DbSkip())
	Enddo
	If lAbriuExp
		FechaArqExp("SB1",.T.)
	Endif

	Return .T.

