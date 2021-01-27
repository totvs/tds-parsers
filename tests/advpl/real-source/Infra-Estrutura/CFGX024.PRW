
#include "protheus.ch"
#Include "cfgx024.ch"
#Include "MsOle.Ch"

Function cfgx024(cFileTRM,cCaption)

	Local oDlg
	Local oRadio

	Private cCpt    :=IIf(cCaption==NIL,"XXXXXXXXXX",cCaption)
	Private cFile   :=IIf(cFileTRm==NIL,"",cFileTRM)
	Private nOpca   :=1
	Private cType   :=""
	Private oTermo
	Private cTermo

	// Verifico se existe o .DOC do arquivo .TRM
	// Caso existir sera prioridade

	If cFileTrm <> Nil .And. ".TRM" $ Upper(cFileTrm) .And. File(StrTran(Upper(cFileTrm), ".TRM", ".DOC"))
		Return StrTran(Upper(cFileTrm), ".TRM", ".DOC")
	Endif

	If cFileTrm <> Nil .And. ".DOC" $ Upper(cFileTRM)
		Return cFileTrm
	Endif

	// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	// ³ Recupera o desenho padrao de atualizacoes                   ³
	// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DEFINE MSDIALOG oDlg FROM  120,1 TO 243,293 TITLE OemToAnsi(STR0001) PIXEL  // "Edi‡„o dos Termos de Abertura/Encerramento"


	@ 10,17 Say OemToAnsi(STR0001) SIZE 150,7 OF oDlg PIXEL  // "Edi‡Æo dos termos de abertura e encerramento"
	If cCpt != "XXXXXXXXXX"
		@ 18,40 Say OemToAnsi(STR0002+cCpt)                         SIZE 100,7 OF oDlg PIXEL   // "referentes "
	Endif
	@ 38, 024 Button OemToAnsi(STR0003)         SIZE 33, 11 OF oDlg PIXEL   Action(nOpca:=1,ChgFile(),cTermo:="",Iif(!Empty(cFile),EditTermo(),nOpca:=0),oDlg:End()) Font oDlg:oFont // "Novo"
	@ 38, 057 Button OemToAnsi(STR0004)     SIZE 33, 11 OF oDlg PIXEL   Action(nOpca:=2,ChgFile(),Iif(!Empty(cFile),RestFile() ,nOpca:=0),oDlg:End()) Font oDlg:oFont  // "Restaura"
	@ 38, 090 Button OemToAnsi(STR0005)     SIZE 33, 11 OF oDlg PIXEL   Action(nopca:=0,oDlg:End()) Font oDlg:oFont  // "Cancelar"

	ACTIVATE MSDIALOG oDlg CENTERED


	Return cFile

	/*
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Fun‡…o    ³ChgFile   ³ Autor ³ Marcos Patricio       ³ Data ³ 05.02.96 ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡…o ³ Escolhe arquivo ou cria arquivo para padroniza‡Æo CNAB     ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Sintaxe   ³ ChgFile()                                                  ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Parametros³                                                            ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³ Uso      ³ MATCONF                                                    ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	Last change:  CIA  26 Mar 96    5:21 pm
	*/

Function ChgFile()

	Local cFileChg
	Local cType     := ""

	cType   :=OemToAnsi(STR0006) // "Termos | *.TRM | Configuracao | *.INI "

	cFileChg    :=cGetFile(cType, OemToAnsi(STR0007+Subs(cType,1,7) ) ) // "Selecione arquivo "

	If  Empty(cFileChg)
		cFile:=""
		Return
	Endif

	cFile := Alltrim(cFileChg)

	If  nOpca == 1
		If  File(cFile)
			cFile:=""
			MsgInfo(OemToAnsi(STR0008),OemToAnsi(cCpt))  // "Arquivo j  existe !!!"
			Return
		Endif
	Else
		cType   :=OemToAnsi(STR0009) // "Termos | "+cFile
	Endif

	Return


	/*
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Fun‡…o    ³EditTermo ³ Autor ³ Marcos Patricio       ³ Data ³ 05.02.96 ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡…o ³ Escolhe arquivo ou cria arquivo para padroniza‡Æo CNAB     ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Sintaxe   ³ EditTermo()                                                ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Parametros³                                                            ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³ Uso      ³ MATCONF                                                    ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	Last change:  CIA   5 Feb 96    9:44 am
	*/

Function EditTermo()

	Local oDlg

	DEFINE MSDIALOG oDlg FROM 134,10  TO 400,612 TITLE OemToAnsi(cCpt+" "+STR0010+Space(05)+cFile) PIXEL // "Termos de Abertura e Encerramento"

	DEFINE FONT oFontTST NAME "Courier New" SIZE 6,15
	@ 02,01 GET oTermo VAR cTermo SIZE 299, 116 OF oDlg FONT oFontTST PIXEL MEMO
	oTermo:bRClicked := {||AllwaysTrue()}

	DEFINE SBUTTON FROM 121, 246 TYPE 1 ENABLE OF oDlg ACTION (nOpca:= 1,SaveFile(),oDlg:End())
	DEFINE SBUTTON FROM 121, 273 TYPE 2 ENABLE OF oDlg ACTION (nOpca:= 0, oDlg:End())

	ACTIVATE MSDIALOG oDlg


	Return Nil


	/*
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Fun‡…o    ³ SaveFile ³ Autor ³ Marcos Patricio       ³ Data ³ 05.02.96 ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡…o ³ Seta o tipo de arqruivo em uso                             ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Sintaxe   ³ SaveFile()                                                 ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Parametros³                                                            ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³ Uso      ³ MATCONF                                                    ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	Last change:  CIA   5 Feb 96    9:44 am
	*/

Static Function SaveFile()


	Local cFileback :=cFile

	IF  nOpca == 2
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Escolhe o nome do Arquivo a ser salvo                        ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		ChgFile()
		If  Empty(cFile)
			Return .F.
		Endif

		If  cFile#cFileBack .AND. File(cFile)
			If  !MsgYesNo(OemToAnsi(STR0011),OemToAnsi(cCpt))  // "Arquivo j  existe grava por cima"
				cFile   :=""
				Return .F.
			Endif
		Endif
	Else
		If  !MsgYesNo(OemToAnsi(STR0012),OemToAnsi(cCpt))  // "Confirma Grava‡Æo ?"
			Return .F.
		Endif
	EndIF

	nTerHdl:=MSFCREATE(cFile,0)

	FSEEK(nTerHdl,0,0)

	If  !Empty(cTermo)
		FWRITE(nTerHdl,cTermo)
	Endif

	FCLOSE(nTerHdl)

	Commit

	Return .T.


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
Static Function RestFile()

	Local xBuffer
	Local nTamArq

	If  !File(cFile)
		cFile:=""
		MsgInfo(OemToAnsi(STR0013 ),OemToAnsi(cCpt))  // "Arquivo nÆo existe !!!"
		Return
	Endif

	nTerHdl :=FOPEN(cFile,2+64)
	nTamArq :=FSEEK(nTerHdl,0,2)
	xBuffer :=Space(nTamArq)

	FSEEK(nTerHdl,0,0)
	FREAD(nTerHdl,@xBuffer,nTamArq)

	cTermo  :=xBuffer

	FCLOSE(nTerHdl)

	EditTermo()

	Return


	/*
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Fun‡…o    ³ TpFile   ³ Autor ³ Marcos Patricio       ³ Data ³ 05.02.96 ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡…o ³ Seta o tipo de arqruivo em uso                             ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Sintaxe   ³ TpFile()                                                   ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Parametros³                                                            ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³ Uso      ³ MATCONF                                                    ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	Last change:  CIA   5 Feb 96    9:44 am
	*/

Function TpFile()

	If  Empty(cType)
		cType   :=OemToAnsi(STR0006) // "Termos | *.TRM"
	Endif

	Return Nil


	/*
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Fun‡…o    ³ ImpTerm()³ Autor ³ Juan Jose Pereira     ³ Data ³ 13/03/95 ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡…o ³ Imprime Termo de Abertura/Encerramento de Livro            ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Sintaxe   ³ ImpTerm(cArquivo,aVariavel,cImpCtrl)                       ³±±
	±±³          ³ Parametros:                                                ³±±
	±±³          ³ cArquivo=Nome do Arquivo que contem script a ser impresso  ³±±
	±±³          ³          XXXXXXXX.XXX                                      ³±±
	±±³          ³ aVariavel=Array com                                        ³±±
	±±³          ³           {{Variavel no script,Conteudo a Substituir},...} ³±±
	±±³          ³ cImpCtrl=Caracter de Controle de Impressao                 ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³ Uso      ³ Generico                                                   ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	*/

Function ImpTerm(cArquivo,aVariavel,cImpCtrl,lGraph,aGraph,lRelPers,oReport)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Define variaveis                                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	Local 	cTermo      :=""
	Local   aTermo      :={""}
	Local   i           :=1
	Local   j           :=1
	Local   nTamArq     :=0
	Local   aParametros :={}
	Local   nLinTermo   :=0
	Local   nColTermo   :=0
	Local   CR          := Chr(13)+Chr(10)
	Local	cAux		:=	""
	Local	cAux2		:=	""
	Local	nY			:=	0

	Default lRelPers    := .F.

	If cArquivo <> Nil .And. ".DOC" $ Upper(cArquivo) .And. File(cArquivo)
		TermoViaWord(cArquivo)	// Retorno falso pois nao eh impresso pelo sistema e sim pelo WORD
		Return .F.				// utilizando .TRM apos saida da funcao eh dado EJECT que nao deve
	Endif						// ser feito


	If ValType(lGraph) <> "L"
		lGraph := .F.
	Else
		If ValType(aGraph) <> "A"
			Return .F.
		Endif
		oPrt := aGraph[1]
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se arquivo existe                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	If  Empty(cArquivo) .or. !File(cArquivo)
		Return .f.
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Carrega arquivo                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	nTerHdl :=FOPEN(cArquivo,2+64)
	nTamArq :=FSEEK(nTerHdl,0,2)
	xBuffer :=Space(nTamArq)
	FSEEK(nTerHdl,0,0)
	FREAD(nTerHdl,@xBuffer,nTamArq)
	FCLOSE(nTerHdl)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Ao desmontar o arquivo para impressao, transfor- ³
	//³ ma os Chr(141) para Chr(13) atraves da HardCr()  ³
	//³ e elimina os codigos Chr(10) de quebra de linha  ³
	//³ para que o contole da quebra seja feito apenas   ³
	//³ pelo chr(13) na montagem do Vetor de Impressao   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	cTermo  := strtran(xBuffer , chr(10) , "")

	While !empty(cTermo)
		i := at( chr(13), cTermo )
		If i > 0
			AADD(aTermo,Left(cTermo,i-1))
			cTermo := Substr(cTermo,i+1)
		Else
			aadd(aTermo,cTermo)
			cTermo:=""
		Endif
	EndDo

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Substitui variaveis                              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	nTamTerm:=Len(aTermo)

	nNumPar:=0
	aEval(aVariavel,{ |x| IIf(!Empty(x[1]),nNumPar:=nNumPar+1,)})

	For i:=1 to nTamTerm
		For j:=1 to nNumPar
			cTipo:=Valtype(aVariavel[j,2])
			Do Case
			Case cTipo=="N"
				cValor:=LTrim(Str(aVariavel[j,2]))
			Case cTipo=="D"
				cValor:=DtoC(aVariavel[j,2])
			Case cTipo=="L"
				cValor:=IIF(aVariavel[j,2],STR0014,STR0015) // "SIM"  ### "NAO"
			Case cTipo=="C"
				cValor:=aVariavel[j,2]
			EndCase
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Tratamento para substituir exatamente o campo requerido, pois estava     ³
			//³   ocorrendo de existir um campo _CPF e _CPFRES na mesma tabela e        ³
			//³   quando ele iria procurar o _CPF para substituir, alterava onde estava ³
			//³   o _CPFRES.                                                            ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If At(aVariavel[j,1], aTermo[i])>0
				cAux	:=	SubStr(aTermo[i],At(aVariavel[j,1], aTermo[i]))
				cAux2	:=	""
				For nY := 1 To Len(cAux)
					If IsAlpha(SubStr(cAux,nY,1)) .Or. SubStr(cAux,nY,1)$"_1234567890"
						cAux2 += SubStr(cAux,nY,1)
					Else
						Exit
					EndIf
				Next nY

				//Somente quando for o mesmo campo entre a tabela e o exigido no layout do termo.
				If cAux2==aVariavel[j,1]
					aTermo[i]:=StrTran(aTermo[i],aVariavel[j,1],cValor)
				EndIf
			EndIf
		Next
	Next

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Imprime termo                                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	nLinTermo:=0
	nColTermo:=0

	If !lGraph
		If !lRelPers
			@ nLinTermo, nColTermo PSAY cImpCtrl // Caracter de Controle de Impressao

			For i:=1 to nTamTerm
				@ nLinTermo++, nColTermo PSAY aTermo[i]
			Next
		Else
			For i:=1 to nTamTerm
				oReport:PrintText(aTermo[i])
			Next
		Endif
	Else
		nLinTermo := aGraph[3]
		oPrt:Say(nLinTermo+=1,00,cImpCtrl)	// Caracter de Controle de Impressao
		For i:=1 to nTamTerm
			oPrt:Say(nLinTermo+=15,00,aTermo[i],aGraph[2])
		Next
	Endif

	Return .t.

	/*
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Fun‡ao    ³TermoViaWord³ Autor ³ Wagner Mobile Costa ³ Data ³ 08/04/02 ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡…o ³ Imprime Termo de Abertura/Encerramento de Livro utilizando ³±±
	±±³          ³ integracao com MsWord                                      ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Parametros³ ExpC1  = Nome do arquivo .DOC que contem variaveis de auto-³±±
	±±³          ³          macao de documento, as substituicoes estao no ar- ³±±
	±±³          ³          quivo cArquivo + .INI                             ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³ Uso      ³ Generico                                                   ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	*/

Function TermoViaWord(cArquivo)

	Local 	oWord, cVar, uConteudo
	Local 	bError
	Local 	cPathTmp	:= Alltrim(QdoPath()[3]) /// QdoPath() na QdoxFun.prw
	Local	nPrint		:= nFecha := 1

	__CopyFile(cArquivo, cPathTmp+cArquivo)

	aSavSet:=__SetSets()

	oWord := OLE_CreateLink()

	OLE_SetPropertie( oWord, oleWdPrintBack, .F.)
	OLE_SetPropertie( oWord, oleWdVisible, .T.)

	OLE_OpenFile(oWord, cPathTmp+cArquivo)

	If File(StrTran(Upper(cArquivo), ".DOC", ".INI"))
		FT_FUse(StrTran(Upper(cArquivo), ".DOC", ".INI"))
		FT_FGotop()

		bError 	:= 	ErrorBlock({|e| ApMsgAlert(StrTran(Upper(cArquivo), ".DOC", ".INI") +;
			Chr(13) + Chr(10) + "Variavel " + cVar + Chr(13) + Chr(10) +;
			"Definida incorretamente como " +;
			Subs(cLinha, At("=", cLinha) + 1, Len(cLinha))) })

		While ( !FT_FEof() )
			cLinha 	  := FT_FREADLN()
			cVar	  := Left(cLinha, At("=", cLinha) - 1)
			uConteudo := AllTrim(Subs(cLinha, At("=", cLinha) + 1, Len(cLinha)))
			If cVar = "PRINT_WORD_PADRAO"
				nPrint := Val(uConteudo)
			ElseIf cVar = "FECHA_WORD"
				nFecha := Val(uConteudo)
			Else
				uConteudo := &uConteudo
				If uConteudo <> Nil
					OLE_SetDocumentVar(oWord, cVar, uConteudo)
				eNDIF
			Endif
			FT_FSkip()
		EndDo

		ErrorBlock(bError)
		FT_FUse()
	Endif

	OLE_UpdateFields( oWord )

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Qtde de Copias ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	OLE_SetProperty( oWord, '208', .F. )
	If nPrint = 1
		OLE_PrintFile( oWord, 'PART', 1, 1, 1)
	Endif

	If nFecha = 1
		OLE_CloseFile( oWord )
		OLE_CloseLink( oWord )
	Endif

	__SetSets(aSavSet)
	Set(24,Set(24),.t.)

	Return .T.
