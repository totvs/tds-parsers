#Include "Protheus.ch"
#include "Dbtree.ch"
#Include "Folder.ch"
#Include "Cfgx044.ch"

/*��������������������������������������������������������������������������������������
����������������������������������������������������������������������������������������
������������������������������������������������������������������������������������Ŀ��
��� Fun�ao     � CFGX044    � Autor � Newton Rogerio Ghiraldelli � Data � 15/05/2000 ���
������������������������������������������������������������������������������������Ĵ��
��� Descri�ao  � Montagem do lay-out de arquivo SISPAG.                              ���
������������������������������������������������������������������������������������Ĵ��
��� Sintaxe    � CFGX044()                                                           ���
������������������������������������������������������������������������������������Ĵ��
��� Parametros � void       �...                                                     ���
������������������������������������������������������������������������������������Ĵ��
��� Uso        � Configurador                                                        ���
������������������������������������������������������������������������������������Ĵ��
��� Observacao � Nao tem                                                             ���
�������������������������������������������������������������������������������������ٱ�
����������������������������������������������������������������������������������������
�����������������   ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL   �����������������
����������������������������������������������������������������������������������������
������������������������������������������������������������������������������������Ŀ��
���   Data   �    BOPS     � Programador  �               Alteracao                  ���
������������������������������������������������������������������������������������Ĵ��
���          �             �              �                                          ���
�������������������������������������������������������������������������������������ٱ�
����������������������������������������������������������������������������������������
��������������������������������������������������������������������������������������*/

Function CFGX044( void )

	/*/
	���������������������������������������������������������������������������������������Ŀ
	� Define Variaveis.                                                                     �
	�����������������������������������������������������������������������������������������
	/*/

	Local oDlg

	Private nOpc1   := 1
	Private nBcoHdl := 0
	Private cFile   := ""
	Private cType   := ""
	Private aDet	 := {}
	Private aGer	 := {}
	Private oLbDet
	Private oTree

	/*/
	���������������������������������������������������������������������������������������Ŀ
	� Define janela de escolha da selecao do arquivo Sispag.                                �
	�����������������������������������������������������������������������������������������
	/*/

	DEFINE	MSDIALOG	oDlg;
		FROM		094, 001;
		TO			273, 293;
		TITLE           OemToAnsi( STR0001 ); // "Estrutura��o SisPag"
	PIXEL

	@ 010, 017	SAY	OemToAnsi( STR0002 ); // "Arquivos de LayOut utilizados em SisPag"
	SIZE	150, 007;
		OF		oDlg;
		PIXEL

	@ 027, 007	TO 	058, 139;
		OF		oDlg;
		PIXEL

	@ 068, 007	BUTTON	OemToAnsi( STR0003 ); // "Novo"
	SIZE		33, 11;
		OF			oDlg;
		PIXEL;
		ACTION	(	nOpc1 := 1,;
		cType   := Iif( nOpc1 == 1, OemToAnsi( STR0004 ) + 'SIGA.PAG', OemToAnsi( STR0004 ) + '*.PAG' ),; // "Arquivo de Comunica��o SisPag | " ### "Arquivo de Comunica��o SisPag | "
	CFG44ChArq(),;
    If( !Empty( cFile ), CFG44EdArq( cFile ,.f. ), nOpc1 := 0 ) );
			FONT 		oDlg:oFont

		@ 068, 040	BUTTON	OemToAnsi( STR0005 );  // "Restaura"
		SIZE		33, 11;
			OF			oDlg;
			PIXEL;
			ACTION	( 	nOpc1 := 2,;
			cType   := Iif( nOpc1 == 1, OemToAnsi( STR0004 ) + 'SIGA.PAG', OemToAnsi( STR0004 ) + '*.PAG' ),; // "Arquivo de Comunica��o SisPag | " ### "Arquivo de Comunica��o Sispag | "
		CFG44ChArq(),;
            If( !Empty( cFile ), CFG44EdArq( cFile, .f. ), nOpc1 := 0 ) );
				FONT 		oDlg:oFont

			@ 068, 073	BUTTON	OemToAnsi( STR0006 );  // "Excluir"
			SIZE		33, 11;
				OF			oDlg;
				PIXEL;
				ACTION	(	nOpc1 := 3,;
				cType   := Iif( nOpc1 == 1, OemToAnsi( STR0004 ) + 'SIGA.PAG', OemToAnsi( STR0004 ) + '*.PAG' ),; // "Arquivo de Comunica��o Sispag | " ### "Arquivo de Comunica��o Sispag | "
			CFG44ChArq(),;
                If( !Empty( cFile ), CFG44EdArq( cFile, .t. ),nOpc1 := 0 ) );
					FONT		oDlg:oFont

				@ 068, 106	BUTTON	OemToAnsi( STR0007 );  // "Cancelar"
				SIZE		33, 11;
					OF			oDlg;
					PIXEL;
					ACTION	(	nOpc1 := 4,;
					oDlg:End() );
					FONT		oDlg:oFont

				ACTIVATE	MSDIALOG	oDlg;
					CENTERED

				RETURN nil

				/*��������������������������������������������������������������������������������������
				����������������������������������������������������������������������������������������
				������������������������������������������������������������������������������������Ŀ��
				��� Fun�ao     � CFG44ChArq � Autor � Newton Rogerio Ghiraldelli � Data � 15/05/2000 ���
				������������������������������������������������������������������������������������Ĵ��
				��� Descri�ao  � Escolhe arquivo ou cria arquivo para padronizacao SisPag.           ���
				������������������������������������������������������������������������������������Ĵ��
				��� Sintaxe    � CFG44ChArq()                                                        ���
				������������������������������������������������������������������������������������Ĵ��
				��� Parametros � Nao tem                                                             ���
				������������������������������������������������������������������������������������Ĵ��
				��� Uso        � Configurador                                                        ���
				������������������������������������������������������������������������������������Ĵ��
				��� Observacao � Nao tem                                                             ���
				�������������������������������������������������������������������������������������ٱ�
				����������������������������������������������������������������������������������������
				��������������������������������������������������������������������������������������*/

    Function CFG44ChArq()

				/*/
				���������������������������������������������������������������������������������������Ŀ
				� Define Variaveis.                                                                     �
				�����������������������������������������������������������������������������������������
				/*/

				Local cFileChg

				/*/
				���������������������������������������������������������������������������������������Ŀ
				� Monta e valida janela de selecao de arquivos.                                         �
				�����������������������������������������������������������������������������������������
				/*/

    If Empty( cType )
					cType   := Iif( nOpc1 == 1, OemToAnsi( STR0004 ) + 'SIGA.PAG', OemToAnsi( STR0004 ) + '*.PAG' ) // "Arquivo de Comunica��o Sispag | " ### "Arquivo de Comunica��o SisPag | "
    Endif

				cFileChg := cGetFile( cType, OemToAnsi( OemToAnsi( STR0008 )+ Subs( cType, 1, 7 ) ) ) // "Selecione arquivo "

    If Empty( cFileChg )
					cFile := ""
					Return
    Endif

    If "."$cFileChg
					cFileChg := Substr( cFileChg, 1, rat( ".", cFileChg )-1 )
    Endif

				cFileChg := alltrim( cFileChg )
				cFile    := Alltrim( cFileChg + Right( cType, 4 ) )

    If nOpc1 == 1
        If	File( cFile )
						cFile := ""
						Help( " ", 1, "AX014EXIST" )
						Return
        Endif
    Else
					cType := OemToAnsi( STR0004 )   // "Arquivo de Comunica��o SisPag | "
    Endif

				Return

				/*��������������������������������������������������������������������������������������
				����������������������������������������������������������������������������������������
				������������������������������������������������������������������������������������Ŀ��
				��� Fun�ao     � CFG44EdArq � Autor � Newton Rogerio Ghiraldelli � Data � 15/05/2000 ���
				������������������������������������������������������������������������������������Ĵ��
				��� Descri�ao  � Monta janela de edicao do arquivo para padronizacao SisPag.         ���
				������������������������������������������������������������������������������������Ĵ��
				��� Sintaxe    � CFG44ChArq( cFile, lDeleta )                                        ���
				������������������������������������������������������������������������������������Ĵ��
				��� Parametros � cFile      � Nome do arquivo a ser criado ou aberto.                ���
				���            � lDeleta    � Permite apagar oum nao dados do vetotr aDet.           ���
				������������������������������������������������������������������������������������Ĵ��
				��� Uso        � Configurador                                                        ���
				������������������������������������������������������������������������������������Ĵ��
				��� Observacao � Nao tem                                                             ���
				�������������������������������������������������������������������������������������ٱ�
				����������������������������������������������������������������������������������������
				��������������������������������������������������������������������������������������*/

Function CFG44EdArq( cFile, lDeleta )

				/*/
				���������������������������������������������������������������������������������������Ŀ
				� Define Variaveis.                                                                     �
				�����������������������������������������������������������������������������������������
				/*/

				Local oDlgMain
				Local	oTree
				Local nOpca:=0
				Local nControl  := 0
				Local RecDup :="Folder6"
				Local RecUni :="Folder5"

				Private cGet
				Private oBtn01
				Private oBtn02
				Private oBtn03
				Private oBtn04


				aDet :={{Space(15),Space(03),Space(03),Space(01),Space(60)}}

				/*/
				���������������������������������������������������������������������������������������Ŀ
				� Monta a janela principal de tratamento da estruturacao Sispag.                        �
				�����������������������������������������������������������������������������������������
				/*/

				DEFINE	MSDIALOG	oDlgMain;
					FROM		8, 0;
					TO			28,80;
					TITLE		OemtoAnsi( STR0001 )+ Space( 05 ); // "Estrutura��o SisPag"
				OF			oMainWnd

				DEFINE	DBTREE	oTree;
					FROM 		005, 005;
					TO 		145, 080;
					CARGO;
					OF			oDlgMain;
					ON			CHANGE ( CFG44MtDet( @oLbDet, @oTree ) )

				oTree:lValidLost:= .f.

				DBADDTREE	oTree;
					PROMPT 	OemToAnsi( STR0011 ); 									// "Sispag       "
				RESOURCE RecUni,RecDup;
					CARGO 	"1  "
				DBADDTREE	oTree;
					PROMPT 	OemToAnsi( STR0012 ); 					// "Arquivo      "
				RESOURCE	RecUni,RecDup;
					CARGO 	"11 "
				DBADDITEM	oTree;
					PROMPT 	OemToAnsi( STR0016 ); 	// "Header       "
				RESOURCE RecUni;
					CARGO 	"111"
				DBADDITEM	oTree;
					PROMPT 	OemToAnsi( STR0018 ); 	// "Trailler     "
				RESOURCE	RecUni;
					CARGO 	"112"
				DBENDTREE 	oTree
				DBADDTREE	oTree;
					PROMPT 	OemToAnsi( STR0013 ); 					// "Lote - Seg. A"
				RESOURCE RecUni,RecDup;
					CARGO 	"12 "
				DBADDITEM	oTree;
					PROMPT 	OemToAnsi( STR0016 ); 	// "Header       "
				RESOURCE RecUni;
					CARGO 	"121"
				DBADDITEM	oTree;
					PROMPT 	OemToAnsi( STR0017 ); 	// "Detail       "
				RESOURCE RecUni;
					CARGO 	"122"
				DBADDITEM	oTree;
					PROMPT 	OemToAnsi( STR0018 ); 	// "Trailler     "
				RESOURCE RecUni;
					CARGO 	"123"
				DBENDTREE 	oTree
				DBADDTREE	oTree;
					PROMPT 	OemToAnsi( STR0014 ); 					// "Lote - Seg. B"
				RESOURCE RecUni,RecDup;
					CARGO 	"13 "
				DBADDITEM	oTree;
					PROMPT 	OemToAnsi( STR0016 ); 	// "Header       "
				RESOURCE RecUni;
					CARGO 	"131"
				DBADDITEM	oTree;
					PROMPT 	OemToAnsi( STR0017 ); 	// "Detail       "
				RESOURCE RecUni;
					CARGO 	"132"
				DBADDITEM	oTree;
					PROMPT 	OemToAnsi( STR0018 ); 	// "Trailler     "
				RESOURCE RecUni;
					CARGO 	"133"
				DBENDTREE 	oTree
				DBADDTREE	oTree;
					PROMPT 	OemToAnsi( STR0015 ); 					// "Lote - Seg. J"
				RESOURCE RecUni,RecDup;
					CARGO 	"14 "
				DBADDITEM	oTree;
					PROMPT 	OemToAnsi( STR0016 ); 	// "Header       "
				RESOURCE RecUni;
					CARGO 	"141"
				DBADDITEM	oTree;
					PROMPT 	OemToAnsi( STR0017 ); 	// "Detail       "
				RESOURCE RecUni;
					CARGO 	"142"
				DBADDITEM	oTree;
					PROMPT 	OemToAnsi( STR0018 ); 	// "Trailler     "
				RESOURCE RecUni;
					CARGO 	"143"
				DBENDTREE 	oTree
				DBADDTREE	oTree;
					PROMPT 	OemToAnsi( STR0035 ); 					// "Lote - Seg. N"
				RESOURCE RecUni,RecDup;
					CARGO 	"15 "
				DBADDITEM	oTree;
					PROMPT 	OemToAnsi( STR0016 ); 	// "Header       "
				RESOURCE RecUni;
					CARGO 	"151"
				DBADDITEM	oTree;
					PROMPT 	OemToAnsi( STR0017 ); 	// "Detail       "
				RESOURCE RecUni;
					CARGO 	"152"
				DBADDITEM	oTree;
					PROMPT 	OemToAnsi( STR0018 ); 	// "Trailler     "
				RESOURCE RecUni;
					CARGO 	"153"
				DBENDTREE 	oTree
				DBADDTREE	oTree;
					PROMPT 	OemToAnsi( STR0036 ); 					// "Lote - Seg. O"
				RESOURCE RecUni,RecDup;
					CARGO 	"16 "
				DBADDITEM	oTree;
					PROMPT 	OemToAnsi( STR0016 ); 	// "Header       "
				RESOURCE RecUni;
					CARGO 	"161"
				DBADDITEM	oTree;
					PROMPT 	OemToAnsi( STR0017 ); 	// "Detail       "
				RESOURCE RecUni;
					CARGO 	"162"
				DBADDITEM	oTree;
					PROMPT 	OemToAnsi( STR0018 ); 	// "Trailler     "
				RESOURCE RecUni;
					CARGO 	"163"
				DBENDTREE 	oTree
				DBADDTREE	oTree;
					PROMPT 	OemToAnsi( STR0037 ); 					// "Lote - Seg. W"
				RESOURCE RecUni,RecDup;
					CARGO 	"17 "
				DBADDITEM	oTree;
					PROMPT 	OemToAnsi( STR0017 ); 	// "Detail       "
				RESOURCE RecUni;
					CARGO 	"171"
				DBENDTREE 	oTree
				DBENDTREE	oTree


				@ 003, 083 TO 130,314 OF oDlgMain PIXEL

				@ 008, 105	BUTTON 	oBtn01;
					PROMPT	OemToAnsi( STR0019 ); //"Incluir"
				SIZE		50, 12;
					OF			oDlgMain;
					PIXEL;
					ACTION	(	CFG44GtArq( oLbDet:nAt,.t., oTree ),;
					oLbDet:Refresh() )

				@ 008, 175	BUTTON 	oBtn02;
					PROMPT	OemToAnsi( STR0020 ); //"Excluir"
				SIZE 		50, 12;
					OF 		oDlgMain;
					PIXEL;
					ACTION	( 	CFG44DlArq( oLbDet:nAt, oLbDet, oTree ),;
					oLbDet:Refresh() )

				@ 008, 245	BUTTON 	oBtn03;
					PROMPT	OemToAnsi( STR0021 ); //"Editar"
				SIZE		50,12;
					OF			oDlgMain;
					PIXEL;
					ACTION	(	CFG44GtArq( oLbDet:nAt,.f., oTree ),;
					oLbDet:Refresh() )

				oBtn01:Hide()
				oBtn02:Hide()
				oBtn03:Hide()

				@ 022, 087	LISTBOX	oLbDet;
					FIELDS;
					HEADER	OemToAnsi( STR0022 ),; // "Campo"
				OemToAnsi( STR0023 ),; // "Pos. Inicial"
				OemToAnsi( STR0024 ),; // "Pos. Final"
				OemToAnsi( STR0025 ),; // "Decimais"
				OemToAnsi( STR0026 );  // "Conte�do"
				COLSIZES 50,30,30,30,30 ;
					SIZE		222,100;
					OF 		oDlgMain;
					PIXEL;
					ON 		DBLCLICK ( 	CFG44GtArq( oLbDet:nAt, .f., oTree ),;
					oLbDet:Refresh() )

				oLbDet:SetArray( aDet )
				oLbDet:bLine := { || {	aDet[oLbDet:nAt,1], aDet[oLbDet:nAt,2], aDet[oLbDet:nAt,3], aDet[oLbDet:nAt,4], aDet[oLbDet:nAt,5] } }
				oLbDet:Hide()

				DEFINE	SBUTTON	oBtn04;
					FROM		135, 250;
					TYPE		1;
					ENABLE;
					OF			oDlgMain;
					PIXEL;
					ACTION 	( If( lDeleta, CFG44ApArq( cFile ), CFG44GrArq() ),aGer := {}, oDlgMain:End() )

				oBtn04:Hide()

				DEFINE	SBUTTON;
					FROM		135, 282;
					TYPE		2;
					ENABLE;
					OF 		oDlgMain;
					ACTION	( aGer := {}, oDlgMain:End());
					PIXEL

				ACTIVATE	DIALOG	oDlgMain;
					CENTERED

				SETAPILHA()

				Release Objects oTree

				RETURN Nil

				/*��������������������������������������������������������������������������������������
				����������������������������������������������������������������������������������������
				������������������������������������������������������������������������������������Ŀ��
				��� Fun�ao     � CFG44MtArq � Autor � Newton Rogerio Ghiraldelli � Data � 15/05/2000 ���
				������������������������������������������������������������������������������������Ĵ��
				��� Descri�ao  � Monta o vetor aDet conforme op��o selecionada no Tree.              ���
				������������������������������������������������������������������������������������Ĵ��
				��� Sintaxe    � CFG44MtArq( )                                                       ���
				������������������������������������������������������������������������������������Ĵ��
				��� Parametros � oLbDet     � Objeto de listbox do conte�do de aDet.                 ���
				���            � oTree      � Objeto do Tree de definicao dos segmentos do SisPag.   ���
				������������������������������������������������������������������������������������Ĵ��
				��� Uso        � Configurador                                                        ���
				������������������������������������������������������������������������������������Ĵ��
				��� Observacao � Nao tem                                                             ���
				�������������������������������������������������������������������������������������ٱ�
				����������������������������������������������������������������������������������������
				��������������������������������������������������������������������������������������*/

Function CFG44MtDet( oLbDet, oTree )

				/*/
				���������������������������������������������������������������������������������������Ŀ
				� Define Variaveis.                                                                     �
				�����������������������������������������������������������������������������������������
				/*/

				Local ni			:= 0
				Local nPos 		:= oTree:GetCargo()
				Local nBytes   := 0
				Local nTamArq  := 0
				Local xBuffer	:= Space( 85 )

				/*/
				���������������������������������������������������������������������������������������Ŀ
				� Monta o vetor aGer com as linhas do arquivo de Estrutura��o SisPag.                   �
				�����������������������������������������������������������������������������������������
				/*/

    If Len( aGer ) == 0
					nBytes	:= 0
					nBcoHdl	:= FOpen( cFile, 2 + 64 )
					nTamArq	:= FSeek( nBcoHdl, 0, 2 )
					FSeek( nBcoHdl, 0, 0 )
        While nBytes < nTamArq
						xBuffer := Space( 85 )
						FRead( nBcoHdl, @xBuffer, 85 )
						aAdd( aGer, {	Substr( xBuffer, 01, 01 ), SubStr( xBuffer, 02, 15 ) ,SubStr( xBuffer, 17, 03 ), SubStr( xBuffer, 20, 03 ) ,SubStr( xBuffer, 23, 01 ), SubStr( xBuffer, 24, 60 ) } )
						nBytes += 85
        Enddo
					FClose( nBcoHdl )
    Endif

				/*/
				���������������������������������������������������������������������������������������Ŀ
				� Monta estrutra Sispag conforme valor de ( Cargo ) do Tree                             �
				�����������������������������������������������������������������������������������������
				/*/

    If nPos == "1  "
					aDet  := { { Space( 15 ), Space( 03 ), Space( 03 ), Space( 01 ), Space( 60 ) } }
					oLbDet:SetArray( aDet )
					oLbDet:bLine := { || {	aDet[oLbDet:nAt,1], aDet[oLbDet:nAt,2], aDet[oLbDet:nAt,3], aDet[oLbDet:nAt,4], aDet[oLbDet:nAt,5] } }
					oBtn01:Hide();oBtn01:Refresh()
					oBtn02:Hide();oBtn02:Refresh()
					oBtn03:Hide();oBtn03:Refresh()
					oBtn04:Hide();oBtn04:Refresh()
					oLbDet:Hide();oLbDet:Refresh()
    ElseIf nPos == "11 "
					aDet  := { { Space( 15 ), Space( 03 ), Space( 03 ), Space( 01 ), Space( 60 ) } }
					oLbDet:SetArray( aDet )
					oLbDet:bLine := { || {	aDet[oLbDet:nAt,1], aDet[oLbDet:nAt,2], aDet[oLbDet:nAt,3], aDet[oLbDet:nAt,4], aDet[oLbDet:nAt,5] } }
					oBtn01:Hide();oBtn01:Refresh()
					oBtn02:Hide();oBtn02:Refresh()
					oBtn03:Hide();oBtn03:Refresh()
					oBtn04:Hide();oBtn04:Refresh()
					oLbDet:Hide();oLbDet:Refresh()
    ElseIf nPos == "111"
					aDet := {}
        If Len( aGer ) > 0
            For ni = 1 to Len( aGer )
                If aGer[ ni, 1 ] == "A" .or. aGer[ ni, 1 ] == Chr(1)
								aAdd( aDet, {	aGer[ ni, 2 ], aGer[ ni, 3 ], aGer[ ni, 4 ], aGer[ ni, 5 ], aGer[ ni, 6 ] } )
                Endif
            Next
        Endif
					oLbDet:SetArray( aDet )
					oLbDet:bLine := { || {	aDet[oLbDet:nAt,1], aDet[oLbDet:nAt,2], aDet[oLbDet:nAt,3], aDet[oLbDet:nAt,4], aDet[oLbDet:nAt,5] } }
					oBtn01:Show();oBtn01:Refresh()
					oBtn02:Show();oBtn02:Refresh()
					oBtn03:Show();oBtn03:Refresh()
					oBtn04:Show();oBtn04:Refresh()
					oLbDet:Show();oLbDet:Refresh()
    ElseIf nPos == "112"
					aDet := {}
        If Len( aGer ) > 0
            For ni = 1 to Len( aGer )
                If aGer[ ni, 1 ] == "F" .or. aGer[ ni, 1 ] == Chr(6)
								aAdd( aDet, {	aGer[ ni, 2 ], aGer[ ni, 3 ], aGer[ ni, 4 ], aGer[ ni, 5 ], aGer[ ni, 6 ] } )
                Endif
            Next
        Endif
					oLbDet:SetArray( aDet )
					oLbDet:bLine := { || {	aDet[oLbDet:nAt,1], aDet[oLbDet:nAt,2], aDet[oLbDet:nAt,3], aDet[oLbDet:nAt,4], aDet[oLbDet:nAt,5] } }
					oBtn01:Show();oBtn01:Refresh()
					oBtn02:Show();oBtn02:Refresh()
					oBtn03:Show();oBtn03:Refresh()
					oBtn04:Show();oBtn04:Refresh()
					oLbDet:Show();oLbDet:Refresh()
    ElseIf nPos == "12 "
					aDet := { { Space( 15 ), Space( 03 ), Space( 03 ), Space( 01 ), Space( 60 ) } }
					oLbDet:SetArray( aDet )
					oLbDet:bLine := { || {	aDet[oLbDet:nAt,1], aDet[oLbDet:nAt,2], aDet[oLbDet:nAt,3], aDet[oLbDet:nAt,4], aDet[oLbDet:nAt,5] } }
					oBtn01:Hide();oBtn01:Refresh()
					oBtn02:Hide();oBtn02:Refresh()
					oBtn03:Hide();oBtn03:Refresh()
					oBtn04:Hide();oBtn04:Refresh()
					oLbDet:Hide();oLbDet:Refresh()
    ElseIf nPos == "121"
					aDet		:= {}
        If Len( aGer ) > 0
            For ni = 1 to Len( aGer )
                If aGer[ ni, 1 ] == "B" .or. aGer[ ni, 1 ] == Chr(2)
								aAdd( aDet, {	aGer[ ni, 2 ], aGer[ ni, 3 ], aGer[ ni, 4 ], aGer[ ni, 5 ], aGer[ ni, 6 ] } )
                Endif
            Next
        Endif
					oLbDet:SetArray( aDet )
					oLbDet:bLine := { || {	aDet[oLbDet:nAt,1], aDet[oLbDet:nAt,2], aDet[oLbDet:nAt,3], aDet[oLbDet:nAt,4], aDet[oLbDet:nAt,5] } }
					oBtn01:Show();oBtn01:Refresh()
					oBtn02:Show();oBtn02:Refresh()
					oBtn03:Show();oBtn03:Refresh()
					oBtn04:Show();oBtn04:Refresh()
					oLbDet:Show();oLbDet:Refresh()
    ElseIf nPos == "122"
					aDet		:= {}
        If Len( aGer ) > 0
            For ni = 1 to Len( aGer )
                If aGer[ ni, 1 ] == "G" .or. aGer[ ni, 1 ] == Chr(7)
								aAdd( aDet, {	aGer[ ni, 2 ], aGer[ ni, 3 ], aGer[ ni, 4 ], aGer[ ni, 5 ], aGer[ ni, 6 ] } )
                Endif
            Next
        Endif
					oLbDet:SetArray( aDet )
					oLbDet:bLine := { || {	aDet[oLbDet:nAt,1], aDet[oLbDet:nAt,2], aDet[oLbDet:nAt,3], aDet[oLbDet:nAt,4], aDet[oLbDet:nAt,5] } }
					oBtn01:Show();oBtn01:Refresh()
					oBtn02:Show();oBtn02:Refresh()
					oBtn03:Show();oBtn03:Refresh()
					oBtn04:Show();oBtn04:Refresh()
					oLbDet:Show();oLbDet:Refresh()
    ElseIf nPos == "123"
					aDet		:= {}
        If Len( aGer ) > 0
            For ni = 1 to Len( aGer )
                If aGer[ ni, 1 ] == "D" .or. aGer[ ni, 1 ] == Chr(4)
								aAdd( aDet, {	aGer[ ni, 2 ], aGer[ ni, 3 ], aGer[ ni, 4 ], aGer[ ni, 5 ], aGer[ ni, 6 ] } )
                Endif
            Next
        Endif
					oLbDet:SetArray( aDet )
					oLbDet:bLine := { || {	aDet[oLbDet:nAt,1], aDet[oLbDet:nAt,2], aDet[oLbDet:nAt,3], aDet[oLbDet:nAt,4], aDet[oLbDet:nAt,5] } }
					oBtn01:Show();oBtn01:Refresh()
					oBtn02:Show();oBtn02:Refresh()
					oBtn03:Show();oBtn03:Refresh()
					oBtn04:Show();oBtn04:Refresh()
					oLbDet:Show();oLbDet:Refresh()
    ElseIf nPos == "13 "
					aDet := { { Space( 15 ), Space( 03 ), Space( 03 ), Space( 01 ), Space( 60 ) } }
					oLbDet:SetArray( aDet )
					oLbDet:bLine := { || {	aDet[oLbDet:nAt,1], aDet[oLbDet:nAt,2], aDet[oLbDet:nAt,3], aDet[oLbDet:nAt,4], aDet[oLbDet:nAt,5] } }
					oBtn01:Hide();oBtn01:Refresh()
					oBtn02:Hide();oBtn02:Refresh()
					oBtn03:Hide();oBtn03:Refresh()
					oBtn04:Hide();oBtn04:Refresh()
					oLbDet:Hide();oLbDet:Refresh()
    ElseIf nPos == "131"
					aDet		:= {}
        If Len( aGer ) > 0
            For ni = 1 to Len( aGer )
                If aGer[ ni, 1 ] == "B" .or. aGer[ ni, 1 ] == Chr(2)
								aAdd( aDet, {	aGer[ ni, 2 ], aGer[ ni, 3 ], aGer[ ni, 4 ], aGer[ ni, 5 ], aGer[ ni, 6 ] } )
                Endif
            Next
        Endif
					oLbDet:SetArray( aDet )
					oLbDet:bLine := { || {	aDet[oLbDet:nAt,1], aDet[oLbDet:nAt,2], aDet[oLbDet:nAt,3], aDet[oLbDet:nAt,4], aDet[oLbDet:nAt,5] } }
					oBtn01:Show();oBtn01:Refresh()
					oBtn02:Show();oBtn02:Refresh()
					oBtn03:Show();oBtn03:Refresh()
					oBtn04:Show();oBtn04:Refresh()
					oLbDet:Show();oLbDet:Refresh()
    ElseIf nPos == "132"
					aDet		:= {}
        If Len( aGer ) > 0
            For ni = 1 to Len( aGer )
                If aGer[ ni, 1 ] == "H" .or. aGer[ ni, 1 ] == Chr(8)
								aAdd( aDet, {	aGer[ ni, 2 ], aGer[ ni, 3 ], aGer[ ni, 4 ], aGer[ ni, 5 ], aGer[ ni, 6 ] } )
                Endif
            Next
        Endif
					oLbDet:SetArray( aDet )
					oLbDet:bLine := { || {	aDet[oLbDet:nAt,1], aDet[oLbDet:nAt,2], aDet[oLbDet:nAt,3], aDet[oLbDet:nAt,4], aDet[oLbDet:nAt,5] } }
					oBtn01:Show();oBtn01:Refresh()
					oBtn02:Show();oBtn02:Refresh()
					oBtn03:Show();oBtn03:Refresh()
					oBtn04:Show();oBtn04:Refresh()
					oLbDet:Show();oLbDet:Refresh()
    ElseIf nPos == "133"
					aDet		:= {}
        If Len( aGer ) > 0
            For ni = 1 to Len( aGer )
                If aGer[ ni, 1 ] == "D" .or. aGer[ ni, 1 ] == Chr(4)
								aAdd( aDet, {	aGer[ ni, 2 ], aGer[ ni, 3 ], aGer[ ni, 4 ], aGer[ ni, 5 ], aGer[ ni, 6 ] } )
                Endif
            Next
        Endif
					oLbDet:SetArray( aDet )
					oLbDet:bLine := { || {	aDet[oLbDet:nAt,1], aDet[oLbDet:nAt,2], aDet[oLbDet:nAt,3], aDet[oLbDet:nAt,4], aDet[oLbDet:nAt,5] } }
					oBtn01:Show();oBtn01:Refresh()
					oBtn02:Show();oBtn02:Refresh()
					oBtn03:Show();oBtn03:Refresh()
					oBtn04:Show();oBtn04:Refresh()
					oLbDet:Show();oLbDet:Refresh()
    ElseIf nPos == "14 "
					aDet := { { Space( 15 ), Space( 03 ), Space( 03 ), Space( 01 ), Space( 60 ) } }
					oLbDet:SetArray( aDet )
					oLbDet:bLine := { || {	aDet[oLbDet:nAt,1], aDet[oLbDet:nAt,2], aDet[oLbDet:nAt,3], aDet[oLbDet:nAt,4], aDet[oLbDet:nAt,5] } }
					oBtn01:Hide();oBtn01:Refresh()
					oBtn02:Hide();oBtn02:Refresh()
					oBtn03:Hide();oBtn03:Refresh()
					oBtn04:Hide();oBtn04:Refresh()
					oLbDet:Hide();oLbDet:Refresh()
    ElseIf nPos == "141"
					aDet		:= {}
        If Len( aGer ) > 0
            For ni = 1 to Len( aGer )
                If aGer[ ni, 1 ] == "C" .or. aGer[ ni, 1 ] == Chr(3)
								aAdd( aDet, {	aGer[ ni, 2 ], aGer[ ni, 3 ], aGer[ ni, 4 ], aGer[ ni, 5 ], aGer[ ni, 6 ] } )
                Endif
            Next
        Endif
					oLbDet:SetArray( aDet )
					oLbDet:bLine := { || {	aDet[oLbDet:nAt,1], aDet[oLbDet:nAt,2], aDet[oLbDet:nAt,3], aDet[oLbDet:nAt,4], aDet[oLbDet:nAt,5] } }
					oBtn01:Show();oBtn01:Refresh()
					oBtn02:Show();oBtn02:Refresh()
					oBtn03:Show();oBtn03:Refresh()
					oBtn04:Show();oBtn04:Refresh()
					oLbDet:Show();oLbDet:Refresh()
    ElseIf nPos == "142"
					aDet		:= {}
        If Len( aGer ) > 0
            For ni = 1 to Len( aGer )
                If aGer[ ni, 1 ] == "J" .or. aGer[ ni, 1 ] == Chr(9)
								aAdd( aDet, {	aGer[ ni, 2 ], aGer[ ni, 3 ], aGer[ ni, 4 ], aGer[ ni, 5 ], aGer[ ni, 6 ] } )
                Endif
            Next
        Endif
					oLbDet:SetArray( aDet )
					oLbDet:bLine := { || {	aDet[oLbDet:nAt,1], aDet[oLbDet:nAt,2], aDet[oLbDet:nAt,3], aDet[oLbDet:nAt,4], aDet[oLbDet:nAt,5] } }
					oBtn01:Show();oBtn01:Refresh()
					oBtn02:Show();oBtn02:Refresh()
					oBtn03:Show();oBtn03:Refresh()
					oBtn04:Show();oBtn04:Refresh()
					oLbDet:Show();oLbDet:Refresh()
    ElseIf nPos == "143"
					aDet		:= {}
        If Len( aGer ) > 0
            For ni = 1 to Len( aGer )
                If aGer[ ni, 1 ] == "E" .or. aGer[ ni, 1 ] == Chr(5)
								aAdd( aDet, {	aGer[ ni, 2 ], aGer[ ni, 3 ], aGer[ ni, 4 ], aGer[ ni, 5 ], aGer[ ni, 6 ] } )
                Endif
            Next
        Endif
					oLbDet:SetArray( aDet )
					oLbDet:bLine := { || {	aDet[oLbDet:nAt,1], aDet[oLbDet:nAt,2], aDet[oLbDet:nAt,3], aDet[oLbDet:nAt,4], aDet[oLbDet:nAt,5] } }
					oBtn01:Show();oBtn01:Refresh()
					oBtn02:Show();oBtn02:Refresh()
					oBtn03:Show();oBtn03:Refresh()
					oBtn04:Show();oBtn04:Refresh()
					oLbDet:Show();oLbDet:Refresh()
    ElseIf nPos == "15 "
					aDet := { { Space( 15 ), Space( 03 ), Space( 03 ), Space( 01 ), Space( 60 ) } }
					oLbDet:SetArray( aDet )
					oLbDet:bLine := { || {	aDet[oLbDet:nAt,1], aDet[oLbDet:nAt,2], aDet[oLbDet:nAt,3], aDet[oLbDet:nAt,4], aDet[oLbDet:nAt,5] } }
					oBtn01:Hide();oBtn01:Refresh()
					oBtn02:Hide();oBtn02:Refresh()
					oBtn03:Hide();oBtn03:Refresh()
					oBtn04:Hide();oBtn04:Refresh()
					oLbDet:Hide();oLbDet:Refresh()
    ElseIf nPos == "151"
					aDet		:= {}
        If Len( aGer ) > 0
            For ni = 1 to Len( aGer )
                If aGer[ ni, 1 ] == "C" .or. aGer[ ni, 1 ] == Chr(3)
								aAdd( aDet, {	aGer[ ni, 2 ], aGer[ ni, 3 ], aGer[ ni, 4 ], aGer[ ni, 5 ], aGer[ ni, 6 ] } )
                Endif
            Next
        Endif
					oLbDet:SetArray( aDet )
					oLbDet:bLine := { || {	aDet[oLbDet:nAt,1], aDet[oLbDet:nAt,2], aDet[oLbDet:nAt,3], aDet[oLbDet:nAt,4], aDet[oLbDet:nAt,5] } }
					oBtn01:Show();oBtn01:Refresh()
					oBtn02:Show();oBtn02:Refresh()
					oBtn03:Show();oBtn03:Refresh()
					oBtn04:Show();oBtn04:Refresh()
					oLbDet:Show();oLbDet:Refresh()
    ElseIf nPos == "152"
					aDet		:= {}
        If Len( aGer ) > 0
            For ni = 1 to Len( aGer )
                If aGer[ ni, 1 ] == "N" .or. aGer[ ni, 1 ] == Chr(16)
								aAdd( aDet, {	aGer[ ni, 2 ], aGer[ ni, 3 ], aGer[ ni, 4 ], aGer[ ni, 5 ], aGer[ ni, 6 ] } )
                Endif
            Next
        Endif
					oLbDet:SetArray( aDet )
					oLbDet:bLine := { || {	aDet[oLbDet:nAt,1], aDet[oLbDet:nAt,2], aDet[oLbDet:nAt,3], aDet[oLbDet:nAt,4], aDet[oLbDet:nAt,5] } }
					oBtn01:Show();oBtn01:Refresh()
					oBtn02:Show();oBtn02:Refresh()
					oBtn03:Show();oBtn03:Refresh()
					oBtn04:Show();oBtn04:Refresh()
					oLbDet:Show();oLbDet:Refresh()
    ElseIf nPos == "153"
					aDet		:= {}
        If Len( aGer ) > 0
            For ni = 1 to Len( aGer )
                If aGer[ ni, 1 ] == "I" .or. aGer[ ni, 1 ] == Chr(5)
								aAdd( aDet, {	aGer[ ni, 2 ], aGer[ ni, 3 ], aGer[ ni, 4 ], aGer[ ni, 5 ], aGer[ ni, 6 ] } )
                Endif
            Next
        Endif
					oLbDet:SetArray( aDet )
					oLbDet:bLine := { || {	aDet[oLbDet:nAt,1], aDet[oLbDet:nAt,2], aDet[oLbDet:nAt,3], aDet[oLbDet:nAt,4], aDet[oLbDet:nAt,5] } }
					oBtn01:Show();oBtn01:Refresh()
					oBtn02:Show();oBtn02:Refresh()
					oBtn03:Show();oBtn03:Refresh()
					oBtn04:Show();oBtn04:Refresh()
					oLbDet:Show();oLbDet:Refresh()
    ElseIf nPos == "16 "
					aDet := { { Space( 15 ), Space( 03 ), Space( 03 ), Space( 01 ), Space( 60 ) } }
					oLbDet:SetArray( aDet )
					oLbDet:bLine := { || {	aDet[oLbDet:nAt,1], aDet[oLbDet:nAt,2], aDet[oLbDet:nAt,3], aDet[oLbDet:nAt,4], aDet[oLbDet:nAt,5] } }
					oBtn01:Hide();oBtn01:Refresh()
					oBtn02:Hide();oBtn02:Refresh()
					oBtn03:Hide();oBtn03:Refresh()
					oBtn04:Hide();oBtn04:Refresh()
					oLbDet:Hide();oLbDet:Refresh()
    ElseIf nPos == "161"
					aDet		:= {}
        If Len( aGer ) > 0
            For ni = 1 to Len( aGer )
                If aGer[ ni, 1 ] == "C" .or. aGer[ ni, 1 ] == Chr(3)
								aAdd( aDet, {	aGer[ ni, 2 ], aGer[ ni, 3 ], aGer[ ni, 4 ], aGer[ ni, 5 ], aGer[ ni, 6 ] } )
                Endif
            Next
        Endif
					oLbDet:SetArray( aDet )
					oLbDet:bLine := { || {	aDet[oLbDet:nAt,1], aDet[oLbDet:nAt,2], aDet[oLbDet:nAt,3], aDet[oLbDet:nAt,4], aDet[oLbDet:nAt,5] } }
					oBtn01:Show();oBtn01:Refresh()
					oBtn02:Show();oBtn02:Refresh()
					oBtn03:Show();oBtn03:Refresh()
					oBtn04:Show();oBtn04:Refresh()
					oLbDet:Show();oLbDet:Refresh()
    ElseIf nPos == "162"
					aDet		:= {}
        If Len( aGer ) > 0
            For ni = 1 to Len( aGer )
                If aGer[ ni, 1 ] == "O" .or. aGer[ ni, 1 ] == Chr(17)
								aAdd( aDet, {	aGer[ ni, 2 ], aGer[ ni, 3 ], aGer[ ni, 4 ], aGer[ ni, 5 ], aGer[ ni, 6 ] } )
                Endif
            Next
        Endif
					oLbDet:SetArray( aDet )
					oLbDet:bLine := { || {	aDet[oLbDet:nAt,1], aDet[oLbDet:nAt,2], aDet[oLbDet:nAt,3], aDet[oLbDet:nAt,4], aDet[oLbDet:nAt,5] } }
					oBtn01:Show();oBtn01:Refresh()
					oBtn02:Show();oBtn02:Refresh()
					oBtn03:Show();oBtn03:Refresh()
					oBtn04:Show();oBtn04:Refresh()
					oLbDet:Show();oLbDet:Refresh()
    ElseIf nPos == "163"
					aDet		:= {}
        If Len( aGer ) > 0
            For ni = 1 to Len( aGer )
                If aGer[ ni, 1 ] == "K" .or. aGer[ ni, 1 ] == Chr(5)
								aAdd( aDet, {	aGer[ ni, 2 ], aGer[ ni, 3 ], aGer[ ni, 4 ], aGer[ ni, 5 ], aGer[ ni, 6 ] } )
                Endif
            Next
        Endif
					oLbDet:SetArray( aDet )
					oLbDet:bLine := { || {	aDet[oLbDet:nAt,1], aDet[oLbDet:nAt,2], aDet[oLbDet:nAt,3], aDet[oLbDet:nAt,4], aDet[oLbDet:nAt,5] } }
					oBtn01:Show();oBtn01:Refresh()
					oBtn02:Show();oBtn02:Refresh()
					oBtn03:Show();oBtn03:Refresh()
					oBtn04:Show();oBtn04:Refresh()
					oLbDet:Show();oLbDet:Refresh()
    ElseIf nPos == "17 "
					aDet := { { Space( 15 ), Space( 03 ), Space( 03 ), Space( 01 ), Space( 60 ) } }
					oLbDet:SetArray( aDet )
					oLbDet:bLine := { || {	aDet[oLbDet:nAt,1], aDet[oLbDet:nAt,2], aDet[oLbDet:nAt,3], aDet[oLbDet:nAt,4], aDet[oLbDet:nAt,5] } }
					oBtn01:Hide();oBtn01:Refresh()
					oBtn02:Hide();oBtn02:Refresh()
					oBtn03:Hide();oBtn03:Refresh()
					oBtn04:Hide();oBtn04:Refresh()
					oLbDet:Hide();oLbDet:Refresh()
    ElseIf nPos == "171"
					aDet		:= {}
        If Len( aGer ) > 0
            For ni = 1 to Len( aGer )
                If aGer[ ni, 1 ] == "W"
								aAdd( aDet, {	aGer[ ni, 2 ], aGer[ ni, 3 ], aGer[ ni, 4 ], aGer[ ni, 5 ], aGer[ ni, 6 ] } )
                Endif
            Next
        Endif
					oLbDet:SetArray( aDet )
					oLbDet:bLine := { || {	aDet[oLbDet:nAt,1], aDet[oLbDet:nAt,2], aDet[oLbDet:nAt,3], aDet[oLbDet:nAt,4], aDet[oLbDet:nAt,5] } }
					oBtn01:Show();oBtn01:Refresh()
					oBtn02:Show();oBtn02:Refresh()
					oBtn03:Show();oBtn03:Refresh()
					oBtn04:Show();oBtn04:Refresh()
					oLbDet:Show();oLbDet:Refresh()
    Endif

    If Len( aDet ) == 0
					aDet := { { Space( 15 ), Space( 03 ), Space( 03 ), Space( 01 ), Space( 60 ) } }
					oLbDet:SetArray( aDet )
					oLbDet:bLine := { || {	aDet[oLbDet:nAt,1], aDet[oLbDet:nAt,2], aDet[oLbDet:nAt,3], aDet[oLbDet:nAt,4], aDet[oLbDet:nAt,5] } }
					oBtn01:Show();oBtn01:Refresh()
					oBtn02:Show();oBtn02:Refresh()
					oBtn03:Show();oBtn03:Refresh()
					oBtn04:Show();oBtn04:Refresh()
					oLbDet:Show();oLbDet:Refresh()
					Return
    Endif

				Return

				/*��������������������������������������������������������������������������������������
				����������������������������������������������������������������������������������������
				������������������������������������������������������������������������������������Ŀ��
				��� Fun�ao     � CFG44GtArq � Autor � Newton Rogerio Ghiraldelli � Data � 16/05/2000 ���
				������������������������������������������������������������������������������������Ĵ��
				��� Descri�ao  � Monta a tela de Get dos dados a serem adicionados ao vetor aDet.    ���
				������������������������������������������������������������������������������������Ĵ��
				��� Sintaxe    � CFG44GtArq( nItem, lProcess, oTree )                                ���
				������������������������������������������������������������������������������������Ĵ��
				��� Parametros � nItem      � Posicao do dado no vetor aDet.                         ���
				���            � lProcess   � Informa se e inclusao( .t.) ou alteracao( .F. ).       ���
				���            � oTree      � Objeto do Tree de defini��o dos segmentos do SisPag.   ���
				������������������������������������������������������������������������������������Ĵ��
				��� Uso        � Configurador                                                        ���
				������������������������������������������������������������������������������������Ĵ��
				��� Observacao � Nao tem                                                             ���
				�������������������������������������������������������������������������������������ٱ�
				����������������������������������������������������������������������������������������
				��������������������������������������������������������������������������������������*/

Function CFG44GtArq( nItem, lProcess, oTree )

				/*/
				���������������������������������������������������������������������������������������Ŀ
				� Define Variaveis.                                                                     �
				�����������������������������������������������������������������������������������������
				/*/

				Local nPos		 := 0
				Local nOpca     := 0
				Local cPos		 := oTree:GetCargo()
				Local cReg		 := Space( 01 )
				Local cPosBco   := Space( 15 )
				Local cPosIni   := Space( 03 )
				Local cPosFin   := Space( 03 )
				Local cLenDec   := Space( 01 )
				Local cConteudo := Space( 60 )
				Local oDlgGet

				/*/
				���������������������������������������������������������������������������������������Ŀ
				� Verifica se ha dados para alteracao no vetor aDet.                                    �
				�����������������������������������������������������������������������������������������
				/*/

    If !lProcess
        If Len( aDet ) == 1 .And. ( Empty( aDet[1,1] ) .And. Empty( aDet[1,2] ) .And. Empty( aDet[1,3] ) )
						MsgStop(OemToAnsi( STR0027 ),OemToAnsi( STR0001 ) ) // "N�o h� dados para altera��o" ###  "Estrutura��o Sispag"
						Return
        Else
						cPosBco    :=OemToAnsi( aDet[nItem,1] )
						cPosIni    :=aDet[nItem,2]
						cPosFin    :=aDet[nItem,3]
						cLenDec    :=aDet[nItem,4]
						cConteudo  :=OemToAnsi( aDet[nItem,5] )
        Endif
    Endif

				/*/
				���������������������������������������������������������������������������������������Ŀ
				� Monta a tela do get de dados para o vetor aDet.                                       �
				�����������������������������������������������������������������������������������������
				/*/

				DEFINE	MSDIALOG	oDlg;
					FROM		015, 006;
					TO 		196, 366;
					TITLE		OemToAnsi( STR0001 );  // "Estrutura��o Sispag"
				PIXEL

				@ -2, 2	TO		074, 179;
					OF		oDlg;
					PIXEL

				@ 08, 05	SAY	OemToAnsi( STR0022 );  // "Campo"
				SIZE	22, 07;
					OF 	oDlg;
					PIXEL

				@ 07, 53	MSGET		cPosBco;
					PICTURE	"@X";
					SIZE		70, 10;
					OF 		oDlg;
					PIXEL

				@ 21, 05	SAY	OemToAnsi( STR0023 );  // "Pos. Inicial"
				SIZE	46, 07;
					OF		oDlg;
					PIXEL

				@ 20, 53	MSGET		cPosIni;
					PICTURE 	"999";
					VALID		CFG44CkLis( cPosIni, nItem, lProcess );
					SIZE		21, 10;
					OF			oDlg;
					PIXEL

				@ 34, 05	SAY	OemToAnsi( STR0024 ); // "Pos. Final"
				SIZE	41, 07;
					OF		oDlg;
					PIXEL

				@ 33, 53	MSGET		cPosFin;
					PICTURE	"999";
					VALID		CFG44CkLie( cPosIni, cPosFin, nItem );
					SIZE		21, 10;
					OF			oDlg;
					PIXEL

				@ 47, 05	SAY	OemToAnsi( STR0025 );  // "Decimais"
				SIZE	028,07;
					OF		oDlg;
					PIXEL

				@ 46, 53	MSGET		cLenDec;
					PICTURE	"9";
					SIZE		11, 10;
					OF 		oDlg;
					PIXEL

				@ 60, 05	SAY 	OemToAnsi( STR0026 );  // "Conte�do"
				SIZE	31,07;
					OF		oDlg;
					PIXEL

				@ 59, 53	MSGET cConteudo;
					SIZE	123,10;
					OF		oDlg;
					PIXEL

				DEFINE	SBUTTON;
					FROM		077, 124;
					TYPE		1;
					ENABLE;
					OF			oDlg;
					ACTION  (	cType   := Iif( nOpc1 == 1, OemToAnsi( STR0004 ) + 'SIGA.PAG', OemToAnsi( STR0004 ) + '*.PAG' ),; // "Arquivo de Comunica��o SisPag | " ### "Arquivo de Comunica��o SisPag | "
				nOpca := 1,;
    If( ( CFG44CkLis( cPosIni, nItem, lProcess ) .And. CFG44CkLie( cPosIni, cPosFin, nItem ) ),;
						oDlg:End(),;
						nOpca := 0 ) )

					DEFINE 	SBUTTON;
						FROM 		077, 152;
						TYPE		2;
						ENABLE;
						OF 		oDlg;
						ACTION	oDlg:End()

					ACTIVATE	MSDIALOG	oDlg;
						CENTERED

            If cPos == "111"
						cReg:= "A"
        ElseIf cPos == "112"
						cReg:= "F"
        ElseIf cPos == "121"
						cReg:= "B"
        ElseIf cPos == "122"
						cReg:= "G"
        ElseIf cPos == "123"
						cReg:= "D"
        ElseIf cPos == "131"
						cReg:= "B"
        ElseIf cPos == "132"
						cReg:= "H"
        ElseIf cPos == "133"
						cReg:= "D"
        ElseIf cPos == "141"
						cReg:= "C"
        ElseIf cPos == "142"
						cReg:= "J"
        ElseIf cPos == "143"
						cReg:= "E"
        ElseIf cPos == "151"
						cReg:= "C"
        ElseIf cPos == "152"
						cReg:= "N"
        ElseIf cPos == "153"
						cReg:= "I"
        ElseIf cPos == "161"
						cReg:= "C"
        ElseIf cPos == "162"
						cReg:= "O"
        ElseIf cPos == "163"
						cReg:= "K"
        ElseIf cPos == "171"
						cReg:= "W"
        Endif

        If nOpca == 1
            If	lProcess 	//Incluir
                If Len(aDet) == 1 .And. ( Empty(aDet[1,1]) .And. Empty(aDet[1,2]) .And. Empty(aDet[1,3]) .And. Empty(aDet[1,4]) .And. Empty(aDet[1,5]))
								aDet[1]   :={cPosBco,cPosIni,cPosFin,cLenDec,cConteudo}
                Else
								aAdd( aDet, {cPosBco, cPosIni, cPosFin, cLenDec, cConteudo } )
                Endif
							aAdd( aGer, { cReg, cPosBco, cPosIni, cPosFin, cLenDec, cConteudo } )
            Else 				//Alterar
                For nPos := 1 to Len( aGer )
                    If aGer[nPos,1] == cReg .and. aGer[nPos,2] == aDet[nItem,1] .And. aGer[nPos,3] == aDet[nItem,2] .And. aGer[nPos,4] == aDet[nItem,3] .And. aGer[nPos,5] == aDet[nItem,4] .And. aGer[nPos,6] == aDet[nItem,5]
									exit
                    Endif
                Next
							aDet[ nItem ] := { cPosBco, cPosIni, cPosFin, cLenDec, cConteudo }
							aGer[ nPos ] := { cReg, cPosBco, cPosIni, cPosFin, cLenDec, cConteudo }
            Endif
        Endif

					Return

					/*��������������������������������������������������������������������������������������
					����������������������������������������������������������������������������������������
					������������������������������������������������������������������������������������Ŀ��
					��� Fun�ao     � CFG44DlArq � Autor � Newton Rogerio Ghiraldelli � Data � 16/05/2000 ���
					������������������������������������������������������������������������������������Ĵ��
					��� Descri�ao  � Apaga um registro dos dados associados ao vetor aDet.               ���
					������������������������������������������������������������������������������������Ĵ��
					��� Sintaxe    � CFG44DlArq( nItem, oLbDet, oTree )                                  ���
					������������������������������������������������������������������������������������Ĵ��
					��� Parametros � nItem      � Posicao do dado no vetor aDet.                         ���
					���            � oLbDet     � Objeto de listbox do conte�do de aDet.                 ���
					���            � oTree      � Objeto do Tree de definicao dos segmentos do SisPag.   ���
					������������������������������������������������������������������������������������Ĵ��
					��� Uso        � Configurador                                                        ���
					������������������������������������������������������������������������������������Ĵ��
					��� Observacao � Nao tem                                                             ���
					�������������������������������������������������������������������������������������ٱ�
					����������������������������������������������������������������������������������������
					��������������������������������������������������������������������������������������*/

Function CFG44DlArq( nItem, oLbDet, oTree )

					/*/
					���������������������������������������������������������������������������������������Ŀ
					� Definicao de variaveis.                                                               �
					�����������������������������������������������������������������������������������������
					/*/

					Local nPos := 0
					Local cPos := oTree:GetCargo()
					Local cReg := Space( 01 )

					/*/
					���������������������������������������������������������������������������������������Ŀ
					� Executa rotina de dele��o de linhas do ADet e AGer.                                   �
					�����������������������������������������������������������������������������������������
					/*/

    If  nOpc1==3
						Return
    Endif

    If cPos == "111"
						cReg:= "A"
    ElseIf cPos == "112"
						cReg:= "F"
    ElseIf cPos == "121"
						cReg:= "B"
    ElseIf cPos == "122"
						cReg:= "G"
    ElseIf cPos == "123"
						cReg:= "D"
    ElseIf cPos == "131"
						cReg:= "B"
    ElseIf cPos == "132"
						cReg:= "H"
    ElseIf cPos == "133"
						cReg:= "D"
    ElseIf cPos == "141"
						cReg:= "C"
    ElseIf cPos == "142"
						cReg:= "J"
    ElseIf cPos == "143"
						cReg:= "E"
    ElseIf cPos == "151"
						cReg:= "C"
    ElseIf cPos == "152"
						cReg:= "N"
    ElseIf cPos == "153"
						cReg:= "I"
    ElseIf cPos == "161"
						cReg:= "C"
    ElseIf cPos == "162"
						cReg:= "O"
    ElseIf cPos == "163"
						cReg:= "K"
    Endif

    If	Len( aDet ) == 1 .And. ( Empty( aDet[1,1] ) .And.  Empty( aDet[1,2] ) .And. Empty( aDet[1,3] ) )
						MsgStop( OemToAnsi( STR0028 ), OemToAnsi( STR0001 ) )  // "N�o h� dados para dele��o" ### "Estrutura��o SisPag"
						Return
    Else
        If MsgYesNo( OemToAnsi( STR0029 ), OemToAnsi( STR0001 ) ) // "Confirma dele��o" ### "Estrutura��o Sispag"
            For nPos := 1 to Len( aGer )
                If aGer[nPos,2] == aDet[nItem,1] .And. aGer[nPos,3] == aDet[nItem,2] .And. aGer[nPos,4] == aDet[nItem,3] .And. aGer[nPos,5] == aDet[nItem,4] .And. aGer[nPos,6] == aDet[nItem,5]
									exit
                Endif
            Next
							aDel( aDet, nItem )
							aSize( aDet, Len( aDet ) - 1 )
            If nPos >0
								aDel( aGer, nPos )
								aSize( aGer, Len( aGer ) - 1 )
            Endif
        Endif
    Endif
    If Len( aDet ) == 0
						aDet := { { Space( 15 ), Space( 03 ), Space( 03 ), Space( 01 ), Space( 60 ) } }
    Endif

					oLbDet:SetArray( aDet )
					oLbDet:bLine := { || {	aDet[oLbDet:nAt,1], aDet[oLbDet:nAt,2], aDet[oLbDet:nAt,3], aDet[oLbDet:nAt,4], aDet[oLbDet:nAt,5] } }
					oBtn01:Show();oBtn01:Refresh()
					oBtn02:Show();oBtn02:Refresh()
					oBtn03:Show();oBtn03:Refresh()
					oBtn04:Show();oBtn04:Refresh()
					oLbDet:Show();oLbDet:Refresh()

					Return

					/*��������������������������������������������������������������������������������������
					����������������������������������������������������������������������������������������
					������������������������������������������������������������������������������������Ŀ��
					��� Fun�ao     � CFG44CkLis � Autor � Newton Rogerio Ghiraldelli � Data � 16/05/2000 ���
					������������������������������������������������������������������������������������Ĵ��
					��� Descri�ao  � Executa a verificacao da posicao inicial.                           ���
					������������������������������������������������������������������������������������Ĵ��
					��� Sintaxe    � CFG44CkLis( cPos, nItem, lProcess )                                 ���
					������������������������������������������������������������������������������������Ĵ��
					��� Parametros � cPos       � Posicao dentro do Tree.                                ���
					���            � nItem      � Posicao dentro do vetor aDet.                          ���
					���            � lProcess   � Informa se e inclusao( .t.) ou alteracao( .F. ).       ���
					������������������������������������������������������������������������������������Ĵ��
					��� Uso        � Configurador                                                        ���
					������������������������������������������������������������������������������������Ĵ��
					��� Observacao � Nao tem                                                             ���
					�������������������������������������������������������������������������������������ٱ�
					����������������������������������������������������������������������������������������
					��������������������������������������������������������������������������������������*/

Function CFG44CkLis( cPos, nItem, lProcess )

					/*/
					���������������������������������������������������������������������������������������Ŀ
					� Define Variaveis.                                                                     �
					�����������������������������������������������������������������������������������������
					/*/

					Local	lRet		:= .f.
					Local	cPosChk	:= "000"
					Local	lDifPag := GetNewPar("MV_DIFPAG",.F.)

					/*/
					���������������������������������������������������������������������������������������Ŀ
					� Executa validacao da posicao inicial.                                                 �
					�����������������������������������������������������������������������������������������
					/*/

    If !lDifPag
        If	lProcess
							cPosChk := aDet[ Len( aDet ), 3 ]
        Elseif !lProcess .And. nItem > 1
							cPosChk := aDet[ nItem - 1, 3 ]
        Endif
        If Val( cPos ) == Val( cPosChk ) + 1
							lRet := .t.
        Endif
    Else
						lRet := .T.
    EndIf

    If !lRet
						MsgStop( OemToAnsi( STR0030 ), OemToAnsi( STR0001 ) ) // "Posi��o inicial inv�lida" ### "Estrutura��o SisPag"
    Endif

					Return lRet

					/*��������������������������������������������������������������������������������������
					����������������������������������������������������������������������������������������
					������������������������������������������������������������������������������������Ŀ��
					��� Fun�ao     � CFG44CkLie � Autor � Newton Rogerio Ghiraldelli � Data � 16/05/2000 ���
					������������������������������������������������������������������������������������Ĵ��
					��� Descri�ao  � Executa a verificacao da posicao final.                             ���
					������������������������������������������������������������������������������������Ĵ��
					��� Sintaxe    � CFG44CkLie( cPosIni, cPosFim, nItem  )                              ���
					������������������������������������������������������������������������������������Ĵ��
					��� Parametros � cPosIni    � Posicao inicial.                                       ���
					���            � cPosFin    � Posicao final.                                         ���
					���            � nItem      � Posicao dentro do vetor aDet.                          ���
					������������������������������������������������������������������������������������Ĵ��
					��� Uso        � Configurador                                                        ���
					������������������������������������������������������������������������������������Ĵ��
					��� Observacao � Nao tem                                                             ���
					�������������������������������������������������������������������������������������ٱ�
					����������������������������������������������������������������������������������������
					��������������������������������������������������������������������������������������*/

Function CFG44CkLie( cPosIni, cPosFim, nItem )

					/*/
					���������������������������������������������������������������������������������������Ŀ
					� Define Variaveis.                                                                     �
					�����������������������������������������������������������������������������������������
					/*/

					Local lRet := .t.
					Local	lDifPag := GetNewPar("MV_DIFPAG",.F.)

					/*/
					���������������������������������������������������������������������������������������Ŀ
					� Executa validacao da posicao inicial.                                                 �
					�����������������������������������������������������������������������������������������
					/*/

    If !lDifPag
        If ( Val( cPosFim ) < Val( cPosIni ) ) .And. ( Val( cPosFim ) <= 400 )
							lRet := .f.
							MsgStop( OemToAnsi( STR0031 ), OemToAnsi( STR0001 ) ) // "Posi��o final menor que a inicial" ### "Estrutura��o SisPag"
        Endif
    EndIf

					Return lRet

					/*��������������������������������������������������������������������������������������
					����������������������������������������������������������������������������������������
					������������������������������������������������������������������������������������Ŀ��
					��� Fun�ao     � CFG44ApArq � Autor � Newton Rogerio Ghiraldelli � Data � 16/05/2000 ���
					������������������������������������������������������������������������������������Ĵ��
					��� Descri�ao  � Apaga arquivos de estruturacao Sispag.                              ���
					������������������������������������������������������������������������������������Ĵ��
					��� Parametros � cFile      � Nome do arquivo a ser criado ou aberto.                ���
					������������������������������������������������������������������������������������Ĵ��
					��� Parametros � Nao tem                                                             ���
					������������������������������������������������������������������������������������Ĵ��
					��� Uso        � Configurador                                                        ���
					������������������������������������������������������������������������������������Ĵ��
					��� Observacao � Nao tem                                                             ���
					�������������������������������������������������������������������������������������ٱ�
					����������������������������������������������������������������������������������������
					��������������������������������������������������������������������������������������*/

Function CFG44ApArq( cFile )

    If Len( aDet ) > 0
        If MsgYesNo( OemToAnsi( STR0032 ),OemToAnsi(STR0001)) // "Apaga arquivo "  ### "Estrutura��o Sispag"
							FClose( nBcoHdl )
							FErase( cFile )
        Endif
    Endif

					Return .t.

					/*��������������������������������������������������������������������������������������
					����������������������������������������������������������������������������������������
					������������������������������������������������������������������������������������Ŀ��
					��� Fun�ao     � CFG44GrArq � Autor � Newton Rogerio Ghiraldelli � Data � 16/05/2000 ���
					������������������������������������������������������������������������������������Ĵ��
					��� Descri�ao  � Grava arquivos de estruturacao Sispag.                              ���
					������������������������������������������������������������������������������������Ĵ��
					��� Sintaxe    � CFG44GrArq()                                                        ���
					������������������������������������������������������������������������������������Ĵ��
					��� Parametros � Nao tem                                                             ���
					������������������������������������������������������������������������������������Ĵ��
					��� Uso        � Configurador                                                        ���
					������������������������������������������������������������������������������������Ĵ��
					��� Observacao � Nao tem                                                             ���
					�������������������������������������������������������������������������������������ٱ�
					����������������������������������������������������������������������������������������
					��������������������������������������������������������������������������������������*/

Function CFG44GrArq()

					/*/
					���������������������������������������������������������������������������������������Ŀ
					� Definicao de variaveis.                                                               �
					�����������������������������������������������������������������������������������������
					/*/

					Local ni := 0
					Local cFileback :=cFile

					/*/
					���������������������������������������������������������������������������������������Ŀ
					� Valida nome do arquivo.                                                               �
					�����������������������������������������������������������������������������������������
					/*/

    If nOpc1 == 2
						cType   := Iif( nOpc1 == 1, OemToAnsi( STR0004 ) + 'SIGA.PAG', OemToAnsi( STR0004 ) + '*.PAG' ) // "Arquivo de Comunica��o SisPag | " ### "Arquivo de Comunica��o SisPag | "
						CFG44ChArq()
        If Empty( cFile )
							Return .f.
        Endif
        If cFile == cFileBack .Or. File( cFile )
            If !MsgYesNo( OemToAnsi( STR0033 ), OemToAnsi( STR0001 ) ) // "Arquivo de Estrutura��o Sispag j� existe. Grava por cima" ### "Estrutura��o Sispag"
								cFile   :=""
								Return .f.
            Endif
        Endif
    Else
        If !MsgYesNo( OemToAnsi( STR0034 ), OemToAnsi( STR0001 ) ) // "Confirma grava��o" ### "Estrutura��o Sispag"
							Return .f.
        Endif
    Endif

					/*/
					���������������������������������������������������������������������������������������Ŀ
					� Grava arquivo de estruturacao Sispag.                                                 �
					�����������������������������������������������������������������������������������������
					/*/

					fClose( nBcoHdl )
					nBcoHdl:=MsFCreate( cFile, 0 )
					FSeek( nBcoHdl, 0, 0 )
    For ni:=1 To Len( aGer )
						cReg:= aGer[ni][1] + aGer[ni][2] + aGer[ni][3] + aGer[ni][4] + aGer[ni][5] + aGer[ni][6]
        If !Empty( cReg )
							FWrite( nBcoHdl, cReg + Chr(13) + Chr(10), 85 )
        Endif
    Next ni
					FClose( nBcoHdl )

					Return .t.
