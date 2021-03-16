#INCLUDE "ESTUPDAT.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ESTUPDAT  ³ Autor ³Rodrigo de A. Sartorio ³ Data ³ 03.09.02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Programa de compatibilizacao dos movimentos de CQ          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ COMPATIBILIZACAO DA VERSAO 609 PARA VERSAO 710             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Function ESTUPDAT()
	Local aArea:=GetArea()
	Local cWhile:="",cEndereco:=""
	dbSelectArea("SDB")
	dbSetOrder(1)
	dbSelectArea("SD7")
	dbSetOrder(1)
	dbSeek(xFilial())
	UpdSet01(LastRec())
	While !Eof() .And. D7_FILIAL == xFilial()
		UpdInc01(STR0001,.T.)  //"Aguarde, Atualizando Arquivo de CQ..."
		If !Localiza(D7_PRODUTO)
			dbSkip()
			Loop
		EndIf
		cWhile:=D7_FILIAL+D7_NUMERO+D7_PRODUTO+D7_LOCAL
		cEndereco:=""
		If D7_SEQ == StrZero(1,Len(D7_SEQ))
			// Posiciona no arquivo de DISTRIBUICAO
			dbSelectArea("SDB")
			dbSeek(xFilial()+SD7->D7_PRODUTO+SD7->D7_LOCAL+SD7->D7_NUMSEQ)
			While !EOF() .And. DB_FILIAL+DB_PRODUTO+DB_LOCAL+DB_NUMSEQ == xFilial()+SD7->D7_PRODUTO+SD7->D7_LOCAL+SD7->D7_NUMSEQ
				If DB_ESTORNO <> "S"
					cEndereco:=DB_LOCALIZ
					Exit
				EndIf
				dbSelectArea("SDB")
				dbSkip()
			End
			// Grava nas linhas de liberacao do CQ o endereco original
			dbSelectArea("SD7")
			dbSkip()
			While !Eof() .And. !Empty(cEndereco) .And. D7_FILIAL+D7_NUMERO+D7_PRODUTO+D7_LOCAL == cWhile
				UpdInc01(STR0001,.T.)  //"Aguarde, Atualizando Arquivo de CQ..."
				If Empty(D7_LOCALIZ)
					Reclock("SD7",.F.)
					Replace D7_LOCALIZ With cEndereco
					MsUnlock()
				EndIf
				dbSkip()
			End
		Else
			dbSelectArea("SD7")
			dbSkip()
		EndIf
	End
	RestArea(aArea)
	RETURN