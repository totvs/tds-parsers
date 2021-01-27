
/*
Programa..: ECOUPDAT.PRW
Objetivo..: CORRECAO DO ARQUIVOS SIGAECO
Data/Hora.: 03/09/2002
Obs.......: Tabelas Utilizadas:
"EC1" "EC2" "EC3" "EC4" "EC5" "EC6" "EC7" "EC8" "EC9" "ECA" "SYS"

*** ESTA ROTINA DEVE SER EXECUTADA POR FILIAL ***
*/

*------------------------------*
FUNCTION ECOUPDAT()
	*------------------------------*
	PRIVATE cFilEC8:=xFilial("EC8"),cFilEC2:=xFilial("EC2"),cFilEC3:=xFilial("EC3"),cFilEC4:=xFilial("EC4"),;
		cFilEC5:=xFilial("EC5"),cFilEC7:=xFilial("EC7"),cFilEC9:=xFilial("EC9"),cFilEC2:=xFilial("EC2"),;
		cFilECA:=xFilial("ECA"),cFilSW2:=xFilial("SW2"),cFilSW9:=xFilial("SW9"),cFilEC6:=xFilial("EC6"),;
		cFilEC1:=xFilial("EC1"),cFilSYS:=xFilial("SYS")

	EC8->(DbSetOrder(1))
	EC2->(DbSetOrder(1))
	EC3->(DbSetOrder(3))
	EC4->(DbSetOrder(1))
	EC5->(DbSetOrder(1))
	EC7->(DbSetOrder(2))
	EC9->(DbSetOrder(1))
	ECA->(DbSetOrder(3))
	EC6->(DbSetOrder(1))
	EC1->(DbSetOrder(1))
	SYS->(DbSetOrder(1))

	UPD_EC5()
	UPD_EC2()
	UPD_EC6()
	UPD_EC1()
	UPD_SYS()

	EC8->(DbSetOrder(1))
	EC2->(DbSetOrder(1))
	EC3->(DbSetOrder(1))
	EC4->(DbSetOrder(1))
	EC5->(DbSetOrder(1))
	EC7->(DbSetOrder(1))
	EC9->(DbSetOrder(1))
	ECA->(DbSetOrder(1))
	EC6->(DbSetOrder(1))
	EC1->(DbSetOrder(1))
	SYS->(DbSetOrder(1))

	RETURN .T.
	*----------------------------*
STATIC FUNCTION UPD_EC5()
	*----------------------------*
	EC5->(DBSEEK(cFilEC5))

	DO WHILE EC5->(!EOF()) .AND. EC5->EC5_FILIAL==cFilEC5

		// Atualiza o EC2
		IF EC2->(DBSEEK(cFilEC2+EC5->EC5_HAWB)) .And. ;
				(EC2->EC2_FORN+EC2->EC2_MOEDA) # (EC5->EC5_FORN+EC5->EC5_MOE_FO)
			RECLOCK("EC2",.F.)
			EC2->EC2_FORN :=EC5->EC5_FORN
			EC2->EC2_MOEDA:=EC5->EC5_MOE_FO
			EC2->(MSUNLOCK())
		ENDIF

		If !Empty(EC5->EC5_FORN) .Or. !Empty(EC5->EC5_MOE_FO)
			// Atualiza o EC8
			EC8->(DBSEEK(cFilEC8+EC5->EC5_HAWB+SPACE(LEN(EC5->EC5_FORN+EC5->EC5_MOE_FO))))
			Do While EC8->(!Eof()) .And. EC8->EC8_HAWB+EC8->EC8_FORN+EC8->EC8_MOEDA == EC5->EC5_HAWB+SPACE(LEN(EC5->EC5_FORN+EC5->EC5_MOE_FO))
				RECLOCK("EC8",.F.)
				EC8->EC8_FORN :=EC5->EC5_FORN
				EC8->EC8_MOEDA:=EC5->EC5_MOE_FO
				EC8->(MSUNLOCK())
				EC8->(DbGotop())
				EC8->(DBSEEK(cFilEC8+EC5->EC5_HAWB+SPACE(LEN(EC5->EC5_FORN+EC5->EC5_MOE_FO))))
			Enddo

			// Atualiza o ECA
			ECA->(DBSEEK(cFilECA+Space(Len(EC5->EC5_FORN))+EC5->EC5_INVOIC))
			Do While ECA->(!Eof()) .And. ECA->ECA_FILIAL = cFilECA .And. ECA->ECA_FORN+ECA->ECA_INVOIC == Space(Len(EC5->EC5_FORN))+EC5->EC5_INVOIC
				RECLOCK("ECA",.F.)
				ECA->ECA_FORN   := EC5->EC5_FORN
				ECA->ECA_MOEDA  := EC5->EC5_MOE_FO
				ECA->ECA_TPMODU := 'IMPORT'
				ECA->(MSUNLOCK())
				ECA->(DbGotop())
				ECA->(DBSEEK(cFilECA+Space(Len(EC5->EC5_FORN))+EC5->EC5_INVOIC))
			Enddo
		Endif

		If !Empty(EC5->EC5_FORN)
			// Atualiza o EC9
			EC9->(DBSEEK(cFilEC9+Space(Len(EC5->EC5_FORN))+EC5->EC5_INVOIC))
			Do While EC9->(!Eof()) .And. EC9->EC9_FILIAL = cFilEC9 .And. EC9->EC9_FORN+EC9->EC9_INVOIC == Space(Len(EC5->EC5_FORN))+EC5->EC5_INVOIC
				RECLOCK("EC9",.F.)
				EC9->EC9_FORN :=EC5->EC5_FORN
				EC9->(MSUNLOCK())
				EC9->(DbGotop())
				EC9->(DBSEEK(cFilEC9+Space(Len(EC5->EC5_FORN))+EC5->EC5_INVOIC))
			Enddo
		Endif

		EC5->(DBSKIP())
	ENDDO

	RETURN .T.
	*----------------------------*
STATIC FUNCTION UPD_EC2()
	*----------------------------*
	EC2->(DBSEEK(cFilEC2))

	DO WHILE EC2->(!EOF()) .AND. EC2->EC2_FILIAL==cFilEC2

		If !Empty(EC2->EC2_FORN) .OR. !Empty(EC2->EC2_MOEDA)
			// Atualiza o EC3
			EC3->(DBSEEK(cFilEC3+EC2->EC2_HAWB+SPACE(LEN(EC2->EC2_FORN+EC2->EC2_MOEDA))))
			Do While EC3->(!Eof()) .And. EC3->EC3_FILIAL = cFilEC3 .And. EC3->EC3_HAWB+EC3->EC3_FORN+EC3->EC3_MOEDA == EC2->EC2_HAWB+SPACE(LEN(EC2->EC2_FORN+EC2->EC2_MOEDA))
				RECLOCK("EC3",.F.)
				EC3->EC3_FORN :=EC2->EC2_FORN
				EC3->EC3_MOEDA:=EC2->EC2_MOEDA
				EC3->(MSUNLOCK())
				EC3->(DbGotop())
				EC3->(DBSEEK(cFilEC3+EC2->EC2_HAWB+SPACE(LEN(EC2->EC2_FORN+EC2->EC2_MOEDA))))
			ENDDO

			// Atualiza o EC4
			EC4->(DBSEEK(cFilEC4+EC2->EC2_HAWB+SPACE(LEN(EC2->EC2_FORN+EC2->EC2_MOEDA))))
			Do While EC4->(!Eof()) .And. EC4->EC4_FILIAL = cFilEC4 .And. EC4->EC4_HAWB+EC4->EC4_FORN+EC4->EC4_MOEDA == EC2->EC2_HAWB+SPACE(LEN(EC2->EC2_FORN+EC2->EC2_MOEDA))
				RECLOCK("EC4",.F.)
				EC4->EC4_FORN :=EC2->EC2_FORN
				EC4->EC4_MOEDA:=EC2->EC2_MOEDA
				EC4->(MSUNLOCK())
				EC4->(DbGotop())
				EC4->(DBSEEK(cFilEC4+EC2->EC2_HAWB+SPACE(LEN(EC2->EC2_FORN+EC2->EC2_MOEDA))))
			ENDDO


			//Atualiza o EC7
			EC7->(DBSEEK(cFilEC7+EC2->EC2_HAWB+SPACE(LEN(EC2->EC2_FORN+EC2->EC2_MOEDA))))
			Do While EC7->(!Eof()) .And. EC7->EC7_FILIAL = cFilEC7 .And. EC7->EC7_HAWB+EC7->EC7_FORN+EC7->EC7_MOEDA == EC2->EC2_HAWB+SPACE(LEN(EC2->EC2_FORN+EC2->EC2_MOEDA))
				RECLOCK("EC7",.F.)
				EC7->EC7_FORN :=EC2->EC2_FORN
				EC7->EC7_MOEDA:=EC2->EC2_MOEDA
				EC7->(MSUNLOCK())
				EC7->(DbGotop())
				EC7->(DBSEEK(cFilEC7+EC2->EC2_HAWB+SPACE(LEN(EC2->EC2_FORN+EC2->EC2_MOEDA))))
			ENDDO
		Endif

		EC2->(DBSKIP())
	ENDDO

	RETURN .T.
	*----------------------------*
STATIC FUNCTION UPD_EC6()
	*----------------------------*
	LOCAL nRecno

	EC6->(DBSEEK(cFilEC6))

	DO WHILE EC6->(!EOF()) .AND. EC6->EC6_FILIAL==cFilEC6

		// Grava no campo ECA_TPMODU o flag 'IMPORT'
		If Empty(EC6->EC6_TPMODU)
			EC6->(DBSKIP(-1))
			nRecno := EC6->(Recno())
			EC6->(DBSKIP())

			RECLOCK("EC6",.F.)
			EC6->EC6_TPMODU :='IMPORT'
			EC6->(MSUNLOCK())
			EC6->(DbGoto(nRecno))
		Endif
		EC6->(DBSKIP())
	ENDDO

	RETURN .T.

	*----------------------------*
STATIC FUNCTION UPD_EC1()
	*----------------------------*
	LOCAL nRecno

	EC1->(DBSEEK(cFilEC1))

	DO WHILE EC1->(!EOF()) .AND. EC1->EC1_FILIAL==cFilEC1

		// Grava no campo EC1_TPMODU o flag 'IMPORT'
		If Empty(EC1->EC1_TPMODU)
			EC1->(DBSKIP(-1))
			nRecno := EC1->(Recno())
			EC1->(DBSKIP())

			RECLOCK("EC1",.F.)
			EC1->EC1_TPMODU :='IMPORT'
			EC1->(MSUNLOCK())
			EC1->(DbGoto(nRecno))
		Endif
		EC1->(DBSKIP())
	ENDDO

	RETURN .T.

	*----------------------------*
STATIC FUNCTION UPD_SYS()
	*----------------------------*
	LOCAL nRecno

	SYS->(DBSEEK(cFilSYS))

	DO WHILE SYS->(!EOF()) .AND. SYS->YS_FILIAL==cFilSYS

		// Grava no campo YS_TPMODU o flag 'I'
		If Empty(SYS->YS_TPMODU)
			SYS->(DBSKIP(-1))
			nRecno := SYS->(Recno())
			SYS->(DBSKIP())

			RECLOCK("SYS",.F.)
			SYS->YS_TPMODU :='I'
			SYS->(MSUNLOCK())
			SYS->(DbGoto(nRecno))
		Endif
		SYS->(DBSKIP())
	ENDDO

	RETURN .T.