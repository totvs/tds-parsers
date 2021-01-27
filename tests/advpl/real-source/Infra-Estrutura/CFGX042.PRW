#INCLUDE "FiveWin.Ch"
#include "cfgx042.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ CFGX042  ³ Autor ³ Jose Lucas            ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Criacao e Manutencao do arquivo de Alcadas                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ void CFGX042(void)                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Sem Argumentos                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Configurador   ³ Fun‡„o Relacionada ³ Entrada Dados (Todos)³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ ARQUIVO DE ALCADAS      ³³ MODULOS DO SISTEMA                            ³
³ Memoria de Calculos     ³³-----------------------------------------------³
ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´³ Compras                                       ³
³ Registro - USUARIOS     ³³                                               ³
³ - Chr(1)              1 ³³                                               ³
³ - Senha do Usuario    6 ³³                                               ³
³ - Nome do Usuario    30 ³³                                               ³
³ - Limite Operacao    12 ³³                                               ³
³ - Limite Mensal      12 ³³                                               ³
³ - Total Liberados    12 ³³                                               ³
³ - Limite Inferior    09 ³³ TOTAL 82                                      ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*/
Function CFGX042()
	Local aDados:= {Space(06),Space(30),0.00,0.00,0.00,0.00,0}
	Local nElemento, aUsuarios,nOpc,cNome,cSenhaAnt,cNomeAnt,cArqPsw
	Local oLbx,oDlg,lRet := .F.,nTamAlca
	Local a042G := {}

	#IFDEF PROTHEUS
		Help(" ",1,"NOPROTHEUS")
		Return
	#ELSE

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Definicao de variaveis locais                                ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cNome     := Space(15)
		cSenhaAnt := Space(06)
		cNomeAnt  := Space(15)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Definicao dos arquivos a serem utilizados                    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cArqPsw   := "SIGAADV.PSS"

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Checar a existencia do Arquivo das Senhas.                   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !FILE(cArqPsw)
			Help(" ",1,"NOPSW")
			Return
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Abre ou Cria o Arquivo de Alcadas                            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !File(cArqAlca)
			nHdlAlca := MSFCREATE(cArqAlca,0)
		Else
			nHdlAlca := FOPEN(cArqAlca,2+64)
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Le o arquivo de Alcadas e Mostrar os Usuarios com Alcadas.   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nTamAlca := FSEEK(nHdlAlca,0,2)
		FSEEK(nHdlAlca,0,0)
		aUsuarios := {}
		nLidos := 0
		cRegistro := Space(82)
		While nLidos < nTamAlca
			cRegistro := Space(82)
			FREAD(nHdlAlca,@cRegistro,82)
			cNome  := EnCript(SubStr(cRegistro,8,30),1)
			AADD(aUsuarios,cNome)
			nLidos += 82
		End

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Mostra os usuarios ja cadastrados                            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If Empty(aUsuarios)
			AADD(aUsuarios,Space(15))
		Endif
		nElemento := Len(aUsuarios)

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³  Desenha a tela Principal                                    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		While .T.
			nElemento := 1
			nOpc := 0
			DEFINE MSDIALOG oDlg RESOURCE "CFGX042" TITLE oemtoansi(STR0012) OF oMainWnd

			REDEFINE LISTBOX oLbx FIELDS HEADER OemToAnsi(STR0001)  ID 101  OF oDlg;  // "Usu rios"
			ON CHANGE (nElemento:=oLbx:nAt)
			oLbx:SetArray(aUsuarios)
			oLbx:bLine := {||  {aUsuarios[oLbx:nAt]} }

			REDEFINE SBUTTON TYPE 4 ID 201 ENABLE OF oDlg ACTION (nOpc:= 1,oDlg:End())
			REDEFINE SBUTTON TYPE 11 ID 202 ENABLE OF oDlg ACTION (nOpc:= 2,oDlg:End())
			REDEFINE SBUTTON TYPE 3 ID 203 ENABLE OF oDlg ACTION (nOpc:= 3,oDlg:End())

			REDEFINE SBUTTON TYPE 2 ID 204 ENABLE OF oDlg ACTION (nOpc := 0,oDlg:End)

			ACTIVATE MSDIALOG oDlg

			If nOpc == 1
				a042G:= X042Get(1,nElemento,@aUsuarios,@aDados,@cSenhaAnt,@cNomeAnt)
				If a042G[1]
					X042Inclui(nHdlAlca,aDados)
				Endif
			Elseif nOpc == 2
				a042G:= X042Get(2,nElemento,@aUsuarios,@aDados,@cSenhaAnt,@cNomeAnt)
				If a042G[1]
					X042Altera(aUsuarios,nElemento,aDados,cSenhaAnt,cNomeAnt,a042G[2])
				Endif
			Elseif nOpc == 3
				a042G:= X042Get(3,nElemento,@aUsuarios,@aDados,@cSenhaAnt,@cNomeAnt)
				If a042G[1]
					X042Deleta(aUsuarios,nElemento,aDados,cSenhaAnt,cNomeAnt,a042G[2])
				Endif
			Else
				Exit
			Endif
		Enddo
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Recupera a Integridade dos dados                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nTamAlca := FSEEK(nHdlAlca,0,2)
		If nTamAlca > 0
			FCLOSE(nHdlAlca)
		Else
			FCLOSE(nHdlAlca)
			FERASE(cArqAlca)
		EndIf

		/*/
		ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
		±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
		±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
		±±³Fun‡…o    ³ X042Inclui³ Autor ³ Jose Lucas           ³ Data ³ 28/09/93 ³±±
		±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
		±±³Descri‡…o ³ Inclusao de Usuarios.                                      ³±±
		±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
		±±³Sintaxe   ³ Void X042Inclui()               	                          ³±±
		±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
		±±³Parametros³                                                            ³±±
		±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
		±±³ Uso      ³ CFGX042                                                    ³±±
		±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
		±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
		ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
		/*/
	Function X042Inclui(nHdlAlca,aDados)

		FSEEK(nHdlAlca,0,2)
		FWRITE(nHdlAlca,CHR(1),1)
		FWRITE(nHdlAlca,EnCript(aDados[1],0),6)
		FWRITE(nHdlAlca,EnCript(aDados[2],0),30)
		FWRITE(nHdlAlca,EnCript(StrZero(aDados[3],12,2),0),12)
		FWRITE(nHdlAlca,EnCript(StrZero(aDados[4],12,2),0),12)
		FWRITE(nHdlAlca,EnCript(StrZero(aDados[5],12,2),0),12)
		FWRITE(nHdlAlca,EnCript(StrZero(aDados[6],09,0),0),09)

		Return


		/*/
		ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
		±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
		±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
		±±³Fun‡…o    ³ X042Altera³ Autor ³ Jose Lucas           ³ Data ³ 28/09/93 ³±±
		±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
		±±³Descri‡…o ³ Alteracao do registro de Alcadas.                          ³±±
		±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
		±±³Sintaxe   ³ Void X042Altera(ExpA1,ExpN1)         	                    ³±±
		±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
		±±³Parametros³ ExpA1 := Array conteundo os nomes dos Usuarios.            ³±±
		±±³          ³ ExpN1 := Posicao do Usuario no Array.                      ³±±
		±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
		±±³ Uso      ³ CFGX042                                                    ³±±
		±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
		±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
		ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
		/*/
	Function X042Altera(aUsuarios,nElemento,aDados,cSenhaAnt,cNomeAnt,cSenhaA)
		LOCAL cBuffer,nTamAlca,nLidos,cRegistro
		LOCAL aUsuaTemp := {},nX
		LOCAL lTrue := .T.
		LOCAL lFalse:= .F.
		LOCAL cEmpresa,cSX2,cIndSX2
		LOCAL cOldFilter
		LOCAL nReg,aDBF :={},cFilSX2,lCdxAxs := .F.
		#IFDEF CDX
			lCdxAxs := .T.
		#ENDIF

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Le o arquivo desde o inicio e joga num array Temporario para ³
		//³ depois fazer a gravacao.           				              ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nTamAlca := FSEEK(nHdlAlca,0,2)
		nLidos := 1
		FSEEK(nHdlAlca,0,0)
		While nLidos < nTamAlca
			cBuffer := Space(82)
			FREAD(nHdlAlca,@cBuffer,82)
			AADD(aUsuaTemp,cBuffer)
			nLidos += 82
		End
		FCLOSE(nHdlAlca)
		If SubStr(aUsuaTemp[nElemento],2,36) == EnCript(cSenhaAnt,0)+EnCript(cNomeAnt,0)
			cRegistro := EnCript(aDados[1],0)
			cRegistro += EnCript(aDados[2],0)
			cRegistro += EnCript(StrZero(aDados[3],12,2),0)
			cRegistro += EnCript(StrZero(aDados[4],12,2),0)
			cRegistro += EnCript(StrZero(aDados[5],12,2),0)
			cRegistro += EnCript(StrZero(aDados[6],09,0),0)
			aUsuaTemp[nElemento] := CHR(1)+cRegistro
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Recria o arquivo SIGAMAT.ALC                                 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nHdlAlca:=MSFCREATE(cArqAlca,0)
		FSEEK(nHdlAlca,0,2)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Regrava o arquivo SIGAMAT.ALC com alteracao                  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		For nx := 1 To Len(aUsuaTemp)
			cBuffer := aUsuaTemp[nx]
			FWRITE(nHdlAlca,cBuffer,82)
		Next nx

		If cSenhaAnt <> cSenhaA

			dbSelectArea("SM0")
			dbSetOrder(1)
			dbGotop()

			While !Eof()

				If cEmpresa == SM0->M0_CODIGO
					dbSkip()
					Loop
				EndIf

				cEmpresa := SM0->M0_CODIGO
				cSX2 		:= "SX2"+SM0->M0_CODIGO+"0"					// Monta o SX2
				cIndSX2 	:= cSX2+IIf(lCdxAxs,"","1")

				dbSelectArea("SX2")
				cFIlSX2 := dbFilter()
				dbCloseArea()

				If Select("SX2") <= 0
					dbUseArea(.T.,,cSX2,"SX2",.T.,.F.)
					If !File(cIndSx2+RetIndExt())
						Index on X2_CHAVE to &(cIndSx2)
					Else
						DbSetIndex(cIndSx2)
					Endif
				EndIf

				dbSetOrder(1)
				cOldFilter := dbFilter()
				dbClearFilter()
				dbSeek("SC7")

				cArquivo := RetArq(__cRdd,TRIM(x2_path)+TRIM(x2_arquivo),.T.)

				If Ascan(aDBF,TRIM(X2_ARQUIVO)) = 0
					Aadd(aDBF,TRIM(x2_arquivo))

					// Abre o Arquivo e indices do Pedido de Compra (SC7)
					ChkFile("SC7",.t.)

					dbSelectArea("SC7")
					dbSetOrder(1)
					cIndex := CriaTrab(nil,.f.)
					cKey := IndexKey()
					cPriv := cSenhaAnt
					#IFNDEF TOP
						cCondicao := 'C7_CODLIB = EnCript(cPriv,0)+"   S" '
					#ELSE
						cCondicao := 'C7_CODLIB == "'+EnCript(cPriv,0)+"   S"+'"'
					#ENDIF
					IndRegua("SC7",cIndex,cKey,,cCondicao,STR0002)  // "Selecionando Registros..."
					nIndex1 := RetIndex("SC7")
					dbSelectArea("SC7")
					#IFNDEF TOP
						dbSetIndex(cIndex+OrdBagExt())
					#ENDIF
					dbSetOrder(nIndex1+1)
					dbGoTop()
					nReg := 0
					While !Eof()
						dbSkip()
						nReg := RecNo()
						dbSkip(-1)
						RecLock("SC7",.F.)
						Replace C7_CODLIB With EnCript(cSenhaA,0)+"   S"
						MsUnLock()
						dbGoTo(nReg)
					End

					dbCloseArea()

				EndIf

				dbSelectArea("SM0")
				dbSkip()
			End

			dbSelectArea("SX2")
			dbCloseArea()

			dbSelectArea("SM0")
			DbSeek(cEmpAnt+cFilAnt)

			cSX2 		:= "SX2"+SM0->M0_CODIGO+"0"
			USE &cSX2 Alias SX2 SHARED NEW


			cIndSx2 := cSX2+IIF(lCdxAxs,"","1")+RetIndExt()
			If !MsFile(cIndSx2)
				Index On X2_CHAVE To &(cIndSx2)
			Else
				dbSetIndex(cIndSx2)
			Endif
			Set Filter to &cFIlSX2
			dbGoTop()

		EndIf

		Return

		/*/
		ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
		±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
		±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
		±±³Fun‡…o    ³ X042Deleta³ Autor ³ Jose Lucas           ³ Data ³ 28/09/93 ³±±
		±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
		±±³Descri‡…o ³ Exclusao do registro de Alcadas.                           ³±±
		±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
		±±³Sintaxe   ³ Void X042Deleta(ExpA1,ExpN1)   	                          ³±±
		±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
		±±³Parametros³ ExpA1 := Array conteundo os nomes dos Usuarios.            ³±±
		±±³          ³ ExpN1 := Posicao do Usuario no Array.                      ³±±
		±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
		±±³ Uso      ³ CFGX042                                                    ³±±
		±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
		±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
		ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
		/*/
	Function X042Deleta(aUsuarios,nElemento,aDados,cSenhaAnt,cNomeAnt)
		LOCAL nOpcao,cBuffer,nLidos,nQtdVetor,nTamAlca
		LOCAL aUsuaTemp := Array(99)
		LOCAL lTrue := .T.
		LOCAL lFalse:= .F.
		LOCAL cEmpresa,cSX2,cIndSX2
		LOCAL cOldFilter
		LOCAL nReg,aDBF :={},cFilSX2,lCdxAxs := .F.

		#IFDEF CDX
			lCdxAxs := .T.
		#ENDIF


		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Le o arquivo desde o inicio e joga num array Temporario para ³
		//³ depois fazer a gravacao.						        				  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nTamAlca := FSEEK(nHdlAlca,0,2)
		nLidos := 0
		nQtdVetor := 1
		FSEEK(nHdlAlca,0,0)
		While nLidos <= nTamAlca
			cBuffer := Space(82)
			FREAD(nHdlAlca,@cBuffer,82)
			aUsuaTemp[nQtdVetor] := cBuffer
			nLidos += 82
			nQtdVetor ++
		End
		FCLOSE(nHdlAlca)

		If SubStr(aUsuaTemp[nElemento],2,36) == EnCript(cSenhaAnt,0)+EnCript(cNomeAnt,0)
			ADEL(aUsuaTemp,nElemento)
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Recria o arquivo SIGAMAT.ALC                                 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nHdlAlca:=MSFCREATE(cArqAlca,0)
		FSEEK(nHdlAlca,0,2)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Regrava o arquivo SIGAMAT.ALC com alteracao                  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If Len(aUsuaTemp) > 0
			For nx := 1 To Len(aUsuaTemp)
				If aUsuaTemp[nx] != Nil
					cBuffer := aUsuaTemp[nx]
					If !Empty(cBuffer)
						FWRITE(nHdlAlca,cBuffer,82)
					EndIf
				EndIf
			Next nx
		EndIf

		dbSelectArea("SM0")
		dbSetOrder(1)
		dbGotop()

		While !Eof()

			If cEmpresa == SM0->M0_CODIGO
				dbSkip()
				Loop
			EndIf

			cEmpresa := SM0->M0_CODIGO
			cSX2 		:= "SX2"+SM0->M0_CODIGO+"0"					// Monta o SX2
			cIndSX2 	:= cSX2+IIF(lCdxAxs,"","1")

			dbSelectArea("SX2")
			cFIlSX2 := dbFilter()
			dbCloseArea()

			If Select("SX2") <= 0
				dbUseArea(.T.,,cSX2,"SX2",.T.,.f.)
				If !File(cIndSX2+RetIndExt())
					Index On X2_CHAVE to &(cIndSx2)
				Else
					dbSetIndex(cIndSX2)
				Endif

			EndIf

			dbSetOrder(1)
			cOldFilter := dbFilter()
			dbClearFilter()
			dbSeek("SC7")

			cArquivo := RetArq(__cRDD,TRIM(x2_path)+TRIM(x2_arquivo),.t.)

			If Ascan(aDBF,cArquivo) = 0
				Aadd(aDBF,cArquivo)

				// Abre o Arquivo e indices do Pedido de Compra (SC7)
				While  !ChkFile("SC7",.T.)
					Help("",1,"ABREEXCL")
				Enddo

				dbSelectArea("SC7")
				dbSetOrder(1)
				cIndex := CriaTrab(nil,.f.)
				cKey := IndexKey()
				cPriv := cSenhaAnt
				#IFNDEF TOP
					cCondicao := 'C7_CODLIB = EnCript(cPriv,0)+"   S"'
				#ELSE
					cCondicao := 'C7_CODLIB == "'+EnCript(cPriv,0)+"   S"+'"'
				#ENDIF

				IndRegua("SC7",cIndex,cKey,,cCondicao,STR0002)  // "Selecionando Registros..."
				nIndex1 := RetIndex("SC7")
				dbSelectArea("SC7")
				#IFNDEF TOP
					dbSetIndex(cIndex+OrdBagExt())
				#ENDIF
				dbSetOrder(nIndex1+1)
				dbGoTop()
				nReg := 0
				While !Eof()
					dbSkip()
					nReg := RecNo()
					dbSkip(-1)
					RecLock("SC7",.F.)
					Replace C7_CODLIB With Space(Len(C7_CODLIB))
					MsUnLock()
					dbGoTo(nReg)
				End

				dbCloseArea()
			EndIf

			dbSelectArea("SM0")
			dbSkip()
		End

		dbSelectArea("SX2")
		dbCloseArea()

		dbSelectArea("SM0")
		DbSeek(cEmpAnt+cFilAnt)

		cSX2 		:= "SX2"+SM0->M0_CODIGO+"0"
		cIndSx2  :=  cSx2+IIF(lCdxAxs,"","1")+RetIndExt()
		USE &cSX2 Alias SX2 SHARED NEW
		If !MsFile(cIndSx2)
			Index On X2_CHAVE TO &(cIndSx2)
		Else
			dbSetIndex(cIndSX2)
		Endif
		Set Filter to &cFIlSX2
		dbGoTop()

		Return .T.
		/*/
		ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
		±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
		±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
		±±³Fun‡…o    ³ X042LeAlca³ Autor ³ Jose Lucas           ³ Data ³ 28/09/93 ³±±
		±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
		±±³Descri‡…o ³ Le o registro de Alcada para alteracao ou delecao.         ³±±
		±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
		±±³Sintaxe   ³ Void X042LeAlca(ExpN1)         	                          ³±±
		±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
		±±³Parametros³ ExpN1 := Posicao do Usuario no Array.                      ³±±
		±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
		±±³ Uso      ³ CFGX042                                                    ³±±
		±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
		±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
		ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
		/*/
	Function X042LeAlca(nElemento,aDados,cSenhaAnt,cNomeAnt)
		LOCAL nAchou, cRegistro, nLidos, nInicio, cEmpFilial, nPosicao,nTamAlca
		LOCAL cValor:="", cValorMes:="", cLiberados:="", cValorInf:=""

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Posiciona no inicio do registro referente ao usuario         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		FSEEK(nHdlAlca,0,0)
		nTamAlca := FSEEK(nHdlAlca,0,2)
		nPosicao := FSEEK(nHdlAlca,0,0)

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Localiza o inicio dos dados do usuario escolhido             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nAchou := 0
		nLidos := 0
		While nLidos < nTamAlca
			cRegistro := Space(82)
			FREAD(nHdlAlca,@cRegistro,82)
			nAchou++
			nLidos += 82
			IF nAchou == nElemento
				Exit
			EndIF
		EndDO

		cSenhaA := EnCript(SubStr(cRegistro,  2 , 6),1)        // Senha do Usuario
		cNome   := EnCript(SubStr(cRegistro,  8 ,30),1)        // Nome do Usuario
		cValor  := EnCript(SubStr(cRegistro, 38 ,12),1)        // Limite por Operacao
		cValorMes  := EnCript(SubStr(cRegistro, 50 ,12),1)     // Limite Mensal
		cLiberados := EnCript(SubStr(cRegistro, 62 ,12),1)     // Total de Pedidos Liberados
		cValorInf  := EnCript(SubStr(cRegistro, 74 ,09),1)     // Limite Inferior

		aDados[1] := cSenhaA
		aDados[2] := cNome
		aDados[3] := Val(cValor)
		aDados[4] := Val(cValorMes)
		aDados[5] := Val(cLiberados)
		aDados[6] := Val(cValorInf)

		cSenhaAnt := cSenhaA
		cNomeAnt := cNome

		/*/
		ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
		±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
		±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
		±±³Fun‡…o    ³ X042Senha ³ Autor ³ Jose Lucas           ³ Data ³ 28/09/93 ³±±
		±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
		±±³Descri‡…o ³ Funcao para validar Senha dos Usuarios.                    ³±±
		±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
		±±³Sintaxe   ³ ExpL := X042Senha(ExpC1)       	                          ³±±
		±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
		±±³Parametros³ ExpL1 := .T. ou .F.                                        ³±±
		±±³          ³ ExpC1 := Codigo da Senha.                                  ³±±
		±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
		±±³ Uso      ³ CFGX042                                                    ³±±
		±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
		±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
		ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
		/*/
	STATIC Function X042Senha(nOpcao,nElemento,cSenhaA,cNome)
		LOCAL cRegistro, nLidos, nPosicao,aUsuarios := {}
		LOCAL lExist, nUsuario := 0, aRet

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verificar se a Senha ja existe no Arquivo de Senhas          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		PswOrder(3)
		If PswSeek(cSenhaA)
			aRet := PswRet(1)
			cNome := aRet[1][2]
		Else
			Help(" ",1,"NOSENHA")
			Return .F.
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Evitar duplicidade da Senha no Arquivo de Alcadas.           ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nTamAlca := FSEEK(nHdlAlca,0,2)
		FSEEK(nHdlAlca,0,0)
		nLidos := 0
		aUsuarios := {}
		While nLidos < nTamAlca
			cRegistro := Space(82)
			FREAD(nHdlAlca,@cRegistro,82)
			AADD(aUsuarios,{ cRegistro } )
			nLidos += 82
		End

		lExist := .F.
		For nx := 1 To Len(aUsuarios)
			If SubStr(aUsuarios[nx][1],2,6) == EnCript(cSenhaA,0)
				lExist := .T.
				nUsuario := nx
			EndIf
		Next
		If nOpcao == 1
			If lExist
				Help(" ",1,"ALCADA")
				Return .F.
			EndIf
		Else
			If lExist .And. nElemento != nUsuario
				Help(" ",1,"ALCADA")
				Return .F.
			EndIf
		Endif
		Return .T.

		/*/
		ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
		±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
		±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
		±±³Fun‡…o    ³X042Mensal ³ Autor ³ Gilson Nascimento    ³ Data ³ 15/07/95 ³±±
		±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
		±±³Descri‡…o ³ Impedir a digitacao do Limite Mensal < Limite Operacao     ³±±
		±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
		±±³Sintaxe   ³ X042Mensal(ExpN1,ExpN2)         	                          ³±±
		±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
		±±³Parametros³ ExpN1 := Valor Limite Mensal                               ³±±
		±±³          ³ ExpN2 := Valor Limite Operacao                             ³±±
		±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
		±±³ Uso      ³ CFGX042                                                    ³±±
		±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
		±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
		ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
		/*/
	STATIC Function X042Mensal(nValorMes,alcalo)
		LOCAl lRet := .T.
		If nValorMes < alcalo
			Help(" ",1,"MENSAL")
			lRet := .F.
		EndIf
		Return(lRet)

		/*/
		ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
		±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
		±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
		±±³Fun‡…o    ³X042Inferio³ Autor ³ Gilson Nascimento    ³ Data ³ 14/07/95 ³±±
		±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
		±±³Descri‡…o ³ Impedir a digitacao do Limite Inferior >= Limite Operacao  ³±±
		±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
		±±³Sintaxe   ³ X042Inferior(ExpN1,ExpN2)      	                          ³±±
		±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
		±±³Parametros³ ExpN1 := Valor Limite Inferior                             ³±±
		±±³          ³ ExpN2 := Valor Limite Operacao                             ³±±
		±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
		±±³ Uso      ³ CFGX042                                                    ³±±
		±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
		±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
		ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
		/*/
	Static Function x042Inferior(nValorInf,alcalo)
		Local lRet := .T.,oDlg
		If nValorInf >= alcalo
			Help(" ",1,"INFERIOR")
			lRet:=.F.
		Endif
		Return(lRet)

		/*/
		ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
		±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
		±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
		±±³Fun‡…o    ³X042Get    ³ Autor ³ Gilson Nascimento    ³ Data ³ 14/07/95 ³±±
		±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
		±±³Descri‡…o ³ Recebe dados para gravacao em arquivo                      ³±±
		±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
		±±³Sintaxe   ³ X042GET                                                    ³±±
		±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
		±±³ Uso      ³ CFGX042 - Rotinas p/ inclusao, alteracao e exclusao        ³±±
		±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
		±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
		ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
		/*/
	Static Function X042GET(nOpc,nElemento,aUsuarios,aDados,cSenhaAnt,cNomeAnt)
		Local cSenhaA,cNome, alcalo, nValorMes, nLiberados, nSaldo, nValorInf
		Local lRet := .F.,oDlg,oSay,cMoeda,cSimbol,cCifrao

		If Len(aUsuarios) == 0
			If nOpc == 2 .or. nOpc == 3
				Help(" ",1,"ARQVAZIO")
				Return {.F.,SPACE(6)}
			EndIf
		Elseif Empty(aUsuarios[1]) .and. nOpc != 1
			Help(" ",1,"ARQVAZIO")
			Return {.F.,SPACE(6)}
		Endif

		If nOpc != 1
			X042LeAlca(nElemento,@aDados,@cSenhaAnt,@cNomeAnt)
			cSenhaA:= aDados[1]
			cNome := aDados[2]
			nalcalo := aDados[3]
			nValorMes:= aDados[4]
			nLiberados:= aDados[5]
			nValorInf := aDados[6]
			nSaldo := aDados[7]
		Else
			cSenhaA:= Space(06)
			cNome := Space(30)
			nalcalo := 0.00
			nValorMes:= 0.00
			nLiberados:= 0.00
			nSaldo := 0.00
			nValorInf := 0
		Endif

		cSimbol := "MV_SIMB" + GETMV("MV_MFORTE")
		cCifrao := GETMV(cSimbol)
		cSimbol := "MV_MOEDA" + GETMV("MV_MFORTE")
		cMoeda  := GETMV(cSimbol)


		nSaldo := (nValorMes - nLiberados)
		While .T.
			lRet := .F.
			DEFINE MSDIALOG oDlg RESOURCE "CFGX042A" TITLE oemtoansi(STR0012) OF oMainWnd

			REDEFINE SAY oSay PROMPT OemToAnsi(STR0003) ID 10 OF oDlg // "Senha"
			REDEFINE SAY oSay PROMPT OemToAnsi(STR0004) ID 11 OF oDlg  // "Usu rio "
			REDEFINE SAY oSay PROMPT OemToAnsi(STR0005) ID 12 OF oDlg  // "Limite por Opera‡„o"
			REDEFINE SAY oSay PROMPT OemToAnsi(STR0006) ID 13 OF oDlg  // "Limite Inferior"
			REDEFINE SAY oSay PROMPT OemToAnsi(STR0007) ID 14 OF oDlg  // "Limite Mensal"
			REDEFINE SAY oSay PROMPT OemToAnsi(STR0008) ID 15 OF oDlg  // "Total Liberados"
			REDEFINE SAY oSay PROMPT OemToAnsi(STR0009) ID 16 OF oDlg  // "Saldo"


			REDEFINE GROUP LABEL OemToAnsi(STR0010) ID 111 OF oDlg // "Moeda"

			REDEFINE MSGET  cSenhaA ID 102 OF oDlg ;
				VALID  X042Senha(nOpc,nElemento,cSenhaA,@cNome)  WHEN   (nOpc !=3 )

			REDEFINE MSGET  cNome ID 103 OF oDlg WHEN  .F.

			REDEFINE MSGET  nAlcalo ID 105 OF oDlg PICTURE  "@E 999999999";
				VALID  (nAlcalo > 0)  WHEN   (nOpc !=3)

			REDEFINE MSGET  nValorInf ID 106 OF oDlg PICTURE "@E 999999999" ;
				VALID  X042Inferior(nValorInf,nAlcalo) WHEN (nOpc !=3)

			REDEFINE MSGET  nValorMes ID 107 OF oDlg PICTURE "@E 999999999.99" ;
				VALID  (X042Mensal(nValorMes,nAlcalo) .and. MostraSaldo(@nSaldo,nValorMes,nLiberados))  WHEN   (nOpc !=3)

			REDEFINE MSGET  nLiberados ID 109 OF oDlg  WHEN   (nOpc !=3) ;
				VALID MostraSaldo(@nSaldo,nValorMes,nLiberados)

			REDEFINE MSGET  oSaldo VAR nSaldo ID 110 OF oDlg PICTURE "@E 999999999.99" ;
				WHEN .F.


			REDEFINE SAY oSay Prompt cCifrao  ID 17 OF oDlg
			REDEFINE SAY oSay Prompt cMoeda   ID 18 OF oDlg
			//   REDEFINE GROUP oGroup  ID 111 OF oDlg
			//  	oGroup:oFont := oDlg:oFont

			REDEFINE SBUTTON TYPE 1 ID 201 ENABLE OF oDlg ACTION (lRet := .T.,oDlg:End())
			REDEFINE SBUTTON TYPE 2 ID 202 ENABLE OF oDlg ACTION (lRet := .F.,oDlg:End())

			ACTIVATE MSDIALOG oDlg CENTERED

			If lRet
				If nOpc != 3
					If(Empty(cSenhaA) .or. (nAlcalo==0.00.or.nValorMes==0.00.or.nValorInf==0.00))
						Help(" ",1,"OBRIGAT")
						lRet := .F.
					Endif
					If nValorMes < nAlcalo
						HELP(" ",1,"MENSAL")
						lRet := .F.
					Endif
					If nValorInf >= nAlcalo
						HELP(" ",1,"INFERIOR")
						lRet := .F.
					Endif
					If lRet
						aDados[1] := cSenhaA
						aDados[2] := cNome
						aDados[3] := nAlcalo
						aDados[4] := nValorMes
						aDados[5] := nLiberados
						aDados[6] := nValorInf
						aDados[7] := nSaldo
						If nopc ==1
							If !Empty(aUsuarios[1])
								AADD(aUsuarios,cNome)
							Else
								aUsuarios[1] := cNome
							Endif
						Else
							aUsuarios[nElemento] := cNome
						Endif
						Exit
					Endif
				Else
					ADEL(aUsuarios,nElemento)
					aUsuarios := ASIZE(aUsuarios,Len(aUsuarios)-1)
					If Len(aUsuarios) == 0
						AADD(aUsuarios,Space(15))
					Endif
					Exit
				Endif
			Else
				Exit
			EndIf
		Enddo
		Return {lRet,cSenhaA}


	Static Function MostraSaldo(nSaldo,nValorMes,nLiberados)
		nSaldo := (nValorMes - nLiberados)
		Return .T.

	#ENDIF