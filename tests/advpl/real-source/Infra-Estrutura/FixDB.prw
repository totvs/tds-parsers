#include "Protheus.CH"
#include "FixDB.CH"

//Variaveis eetaticas usadas pelo meter e timer
Static n01Tasks
Static n02Tasks
Static n01Complete
Static n02Complete
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FixDB     �Autor  �Microsiga           � Data � 27/Jan/2006 ���
�������������������������������������������������������������������������͹��
���Desc.     �Funcao para compatibilizar bases de dados                   ���
�������������������������������������������������������������������������͹��
���Uso       �Associado as correcoes de BOPS                              ���
�������������������������������������������������������������������������͹��
���Parametro �Numero do Bops ( ExpC1 )                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Main ;
    Function FixDB( cBops )

    Local cMsg 			:= ''
    Local cDriver       := 'DBFCDX'
    Local cTitle		:= 'Protheus ' + Subs(GetADV97(), 3, 1) + ' FixDB '

    Default cBops 		:= ''


    Private cMtTxt1 	:= ''
    Private cMtTxt2 	:= ''
    Private cMsgText	:= ''
    Private aRegs	 	:= {}  //regua 1
    Private aEmpresa 	:= {}  //regua 2
    Private oMainWnd


    #ifdef WNTX
        cDriver := 'DBFNTX'
    #endif
    #ifdef WAXS
        cDriver := 'DBFCDXAX'
    #endif
    #ifdef WCODB
        cDriver := 'DBFCDXTTS'
    #endif
    RddSetDefault(cDriver)

    DEFINE FONT oFont NAME "Arial" SIZE 0, -11 BOLD

    cMsg += STR0001 + " " + cBops + "." + Chr(13) + Chr(10) + Chr(13) + Chr(10)
    cMsg += STR0002

    oMainWnd 			:= MSDIALOG():Create()
    oMainWnd:cName		:= "oMainWnd"
    oMainWnd:cCaption	:= "FixDB: BOPS " + cBops
    oMainWnd:nLeft		:= 0
    oMainWnd:nTop		:= 0
    oMainWnd:nWidth		:= 552
    oMainWnd:nHeight	:= 262
    oMainWnd:lShowHint	:= .F.
    oMainWnd:lCentered	:= .T.
    oMainWnd:bInit 		:=	{ || if( Aviso( STR0003, cMsg, {STR0004, STR0005}, 2 ) == 2 .and. OpenSm0(), ;
        ( FixDBFun( cBops )  , oMainWnd:End() ) , ;
        ( MsgAlert( STR0006 ), oMainWnd:End() ) ) }

    @ 005, 005 GET oMsgText VAR cMsgText MEMO SIZE 263, 065 FONT oFont READONLY PIXEL OF oMainWnd

    n01Tasks 	:= 1000
    n02Tasks 	:= 1000
    n01Complete := 0
    n02Complete := 0
    cMtTxt1 	:= STR0022
    cMtTxt2 	:= STR0023

    @ 072, 005 SAY oMtTxt1 VAR cMtTxt1 OF oMainWnd PIXEL FONT oFont SIZE 263,10
    @ 081, 005 METER oMeter01 VAR n01Complete TOTAL n01Tasks SIZE 263,10 OF oMainWnd PIXEL

    @ 094, 005 SAY oMtTxt2 VAR cMtTxt2 OF oMainWnd PIXEL FONT oFont SIZE 263,10
    @ 103, 005 METER oMeter02 VAR n02Complete TOTAL n02Tasks SIZE 263,10 OF oMainWnd PIXEL

    oMainWnd:Activate()

Return


	/*
	�����������������������������������������������������������������������������
	�����������������������������������������������������������������������������
	�������������������������������������������������������������������������Ŀ��
	���Fun��o    �OpenSM0    � Autor �Microsiga             � Data �07/01/2003���
	�������������������������������������������������������������������������Ĵ��
	���Descri��o � Efetua a abertura do SM0                                   ���
	�������������������������������������������������������������������������Ĵ��
	��� Uso      � Atualizacao                                                ���
	��������������������������������������������������������������������������ٱ�
	�����������������������������������������������������������������������������
	�����������������������������������������������������������������������������
	*/
    Static ;
    Function OpenSM0()

    Local lOpen := .F.
    Local nLoop := 0

    For nLoop := 1 To 20
        dbUseArea( .T.,, "SIGAMAT.EMP", "SM0", .T., .T. )
        If !Empty( Select( "SM0" ) )
            lOpen := .T.
            dbSetIndex("SIGAMAT.IND")
            Exit
        EndIf
        Sleep( 500 )
    Next nLoop

    If !lOpen
        Aviso(STR0007, STR0008, { "OK" })
    EndIf

Return lOpen



	/*
	�����������������������������������������������������������������������������
	�����������������������������������������������������������������������������
	�������������������������������������������������������������������������ͻ��
	���Programa  �FixDBFun  �Autor  �Microsiga           � Data �  31/01/06   ���
	�������������������������������������������������������������������������͹��
	���Desc.     �Funcao complementar do processamento de ajustes de Base     ���
	���          �de Dados. (Processamento por Bops)                          ���
	�������������������������������������������������������������������������͹��
	���Sintaxe   �FixDBFun ( ExpC1 )                                          ���
	�������������������������������������������������������������������������͹��
	���Parametros�ExpC1 - Numero do Bops                                      ���
	�������������������������������������������������������������������������ͼ��
	�����������������������������������������������������������������������������
	�����������������������������������������������������������������������������
	*/
    Static ;
    Function FixDBFun( cBops )
    Default cBops := ''

    //��������������������������������������������������������������Ŀ
    //� Array de Empresas (segunda regua: Empresa + Filial)          �
    //����������������������������������������������������������������
    DbSelectArea('SM0')
    DbSetOrder(1)
    DbGoTop()
    While ( ! Eof() )
        Aadd( aEmpresa, {M0_CODIGO, M0_FILIAL} )
        DbSkip()
    EndDo

    //�����������������������������������������������������Ŀ
    //� Monta o numero do Bops completo - 11 posicoes       �
    //�������������������������������������������������������
    cBops := StrZero( Val( cBops), 11)

    //�����������������������������������������������������Ŀ
    //� processamento                                       �
    //�������������������������������������������������������
    FixDBExec( cBops )

    DbCloseAll()
Return


	/*/
    �����������������������������������������������������������������������������
    �����������������������������������������������������������������������������
    �������������������������������������������������������������������������ͻ��
    ���Funcao    �Varias    �Autor  �Microsiga           � Data �  31/01/06   ���
    �������������������������������������������������������������������������͹��
    ���Desc.     �Funcoes para controle das reguas de processamento e mensa-  ���
    ���          �gens                                                        ���
    �������������������������������������������������������������������������͹��
    ���Sintaxe   �FixResetRegua( )                                            ���
    ���          �FixStartRegua ( )                                           ���
    ���          �FixSet01 ( n01 )                                            ���
    ���          �FixSet02 ( n02 )                                            ���
    ���          �FixInc01( cNewText, lClean )                                ���
    ���          �FixInc02( cNewText, lClean )                                ���
    ���          �FixMtMsg( cText1, cText2 )                                  ���
    ���          �FixShowMsg( cShow, lClean, lCRLF)                           ���
    �������������������������������������������������������������������������ͼ��
    �����������������������������������������������������������������������������
    �����������������������������������������������������������������������������
	/*/

    // ------------------------------------------------------

    Static ;
    Function FixResetRegua ( )
    n01Complete := 0
    n02Complete := 0
    oMeter01:Set( 0 )
    oMeter02:Set( 0 )
    oMeter01:Refresh()
    oMeter02:Refresh()
    cMsgText     := ''
    FixMtMsg('','')
    oMsgText:Refresh()
Return

    // ------------------------------------------------------

    Static ;
    Function FixStartRegua ( )
    n01Complete := 0
    n02Complete := 0
    oMeter01:Set( 0 )
    oMeter02:Set( 0 )
    oMeter01:Refresh()
    oMeter02:Refresh()
Return

    // ------------------------------------------------------

    Static ;
    Function FixSet01 ( n01 )
    n01Complete := 0
    n01Tasks    := n01
    oMeter01:Set( 0 )
    oMeter01:SetTotal( n01 )
Return

    // ------------------------------------------------------

    Static ;
    Function FixSet02 ( n02 )
    n02Complete := 0
    n02Tasks    := n02
    oMeter02:Set( 0 )
    oMeter02:SetTotal( n02 )
Return

    // ------------------------------------------------------

    Static ;
    Function FixInc02(cNewText, lClean)
    DEFAULT lClean := .F.
    n02Complete ++
    oMeter02:Set( n02Complete )
    If ( cNewText != Nil )
        FixShowMsg(cNewText, lClean, .F.)
    EndIf
Return

    // ------------------------------------------------------

    Static ;
    Function FixInc01( cNewText, lClean )
    DEFAULT lClean := .F.
    n01Complete ++
    oMeter01:Set( n01Complete )
    If ( cNewText != Nil )
        FixShowMsg(cNewText, lClean, .F.)
    EndIf
Return

    // ------------------------------------------------------

    Static ;
    Function FixMtMsg(cText1,cText2)
    DEFAULT cText1 := ''
    DEFAULT cText2 := ''
    cMtTxt1 := cText1
    cMtTxt2 := cText2
    oMtTxt1:Refresh()
    oMtTxt2:Refresh()
Return

    // ------------------------------------------------------

    Static ;
    Function FixShowMsg(cShow,lClean,lCRLF)
    DEFAULT cShow := ''
    DEFAULT lClean := .F.
    DEFAULT lCRLF := .T.
    If len(cMsgText) >= 500000 .Or. lClean
        cMsgText := ''
    EndIf
    cMsgText += cShow + CRLF + If(lCRLF,CRLF,'')
Return

	/*
	�����������������������������������������������������������������������������
	�����������������������������������������������������������������������������
	�������������������������������������������������������������������������ͻ��
	���Programa  �FixLog    �Autor  �Andre Veiga         � Data �  27/11/01   ���
	�������������������������������������������������������������������������͹��
	���Desc.     �Gera arquivo de Log para informar se alguma coisa nao       ���
	���          �funcionou corretamente no processamento.                    ���
	�������������������������������������������������������������������������͹��
	���Sintaxe   �FixLog( ExpC1, ExpC2 )                                      ���
	�������������������������������������������������������������������������͹��
	���Parametros�ExpC1 - Path e nome do arquivo para gerar o log             ���
	���          �ExpC2 - Texto a ser gravado no arquivo de log.              ���
	�������������������������������������������������������������������������ͼ��
	�����������������������������������������������������������������������������
	�����������������������������������������������������������������������������
	*/
    Static ;
    Function FixLog( cArquivo, cTexto )
    Local nHdl 	:= 0
    If !File(cArquivo)
        nHdl := FCreate(cArquivo)
    Else
        nHdl := FOpen(cArquivo,2)
    Endif
    FSeek(nHdl,0,2)
    cTexto += Chr(13)+Chr(10)
    FWrite(nHdl, cTexto, Len(cTexto))
    FClose(nHdl)
Return


	/*
	�����������������������������������������������������������������������������
	�����������������������������������������������������������������������������
	�������������������������������������������������������������������������ͻ��
	���Programa  �FixDBExec �Autor  �Microsiga           � Data �  31/01/06   ���
	�������������������������������������������������������������������������͹��
	���Desc.     �Funcao de execucao das rotinas de processamento de acordo   ���
	���          �com o Bops relacionado                                      ���
	�������������������������������������������������������������������������͹��
	���Sintaxe   �FixDBExec (cExpC1 )                                         ���
	�������������������������������������������������������������������������͹��
	���Parametros�ExpC1 - Numero do Bops                                      ���
	�������������������������������������������������������������������������ͼ��
	�����������������������������������������������������������������������������
	�����������������������������������������������������������������������������
	*/
    Static ;
    Function FixDBExec( cBops )
    Local cNomeArq
    Local cExtArq	:= ".##R"
    Local nJ
    Default cBops 	:= ''

    //��������������������������������������������������������������������Ŀ
    //� Inicializacao da Regua 2 - Controle por Empresa + Filial           �
    //����������������������������������������������������������������������
    FixSet02( Len( aEmpresa ) )
    FixStartRegua()

    For nJ:=1 To Len( aEmpresa )

        RPCSetType(3)
        RPCSetEnv( aEmpresa[nJ][1], aEmpresa[nJ][2] )

        cText:= STR0009 + " " + aEmpresa[nJ][1] + " - " + STR0010 + ": " + aEmpresa[nJ][2]
        FixInc02( cText )
        oMsgText:Refresh()
        //�����������������������������������������������������������������������Ŀ
        //� Gravacao do Log de inicio do ajuste para a empresa+filial posicionada �
        //�������������������������������������������������������������������������
        cNomeArq	:= "FIX"+AllTrim( Str( Val(cBops)))
        cLogFile	:= __RelDir + cNomeArq + cExtArq
        FixLog( cLogFile, Dtoc( date() )+" "+Time()+" - "+STR0011+" "+Trim(aEmpresa[nJ][1])+", "+STR0012+" "+Trim(aEmpresa[nJ][2])+"." )

        //����������������������������������������������������������Ŀ
        //� CASE PRINCIPAL                                           �
        //� Processamento das Funcoes de Ajuste por Bops             �
        //� Para cada Tarefa (aRegs) sera executada a funcao         �
        //������������������������������������������������������������
        Do Case
        Case cBops = '0000EXEMPLO'   //Exemplo 01 de Rotina de Ajuste
            FixDBExemp( )
            //�����������������������������������������������������������Ŀ
            //� Nesta secao sao chamadas as rotinas especificas de ajuste �
            //�������������������������������������������������������������
        Case cBops = '000000xxxxx'
            //FixDBxxxxx( )
        Case cBops = '00000090953'   //Exemplo 02 de Rotina de Ajuste
            FixDB90953( )
        OtherWise
            MsgAlert(STR0013 + " " + cBops)
            FixLog( cLogFile, Dtoc( date() )+" "+Time()+ " - " + STR0014 + " " + cBops + "." )
        EndCase
        //��������������������������������������������������������������������Ŀ
        //� Gravacao do Log da finalizacao do ajuste por empresa+filial        �
        //����������������������������������������������������������������������
        FixLog( cLogFile, Dtoc( date() ) + " " + Time() + " - " + STR0015 + " " + Trim(aEmpresa[nJ][1]) + ", " + STR0012 + " " + Trim(aEmpresa[nJ][2]) + "." )

    Next

    //��������������������������������������������������������������������Ŀ
    //� Gravacao do Log da finalizacao do ajuste e aviso ao usuario        �
    //����������������������������������������������������������������������
    FixLog( cLogFile, Dtoc( date() )+" "+Time()+" - " + STR0016)
    FixLog( cLogFile, "" )

    MsgAlert( STR0017+Chr(13)+Chr(10)+STR0018+" '"+cLogFile+"' " + STR0019 )
    FixResetRegua ( )

Return




	/*
	�����������������������������������������������������������������������������
	�����������������������������������������������������������������������������
	�������������������������������������������������������������������������ͻ��
	���Programa  �FixDBExemp�Autor  �Microsiga           � Data �  31/01/06   ���
	�������������������������������������������������������������������������͹��
	���Desc.     �Rotina de processamento especifica do Bops Exemplo          ���
	�������������������������������������������������������������������������͹��
	���Sintaxe   �FixDBExemp( )                                               ���
	�������������������������������������������������������������������������ͼ��
	�����������������������������������������������������������������������������
	�����������������������������������������������������������������������������
	*/
    Static ;
    Function FixDBExemp( )
    Local nI

    //��������������������������������������������������������������������Ŀ
    //� Define criterios para a selecao de registros a serem ajustados     �
    //� e monta o vetor de aRegs, que controlara a regua do processamento  �
    //����������������������������������������������������������������������
    Aadd( aRegs, '001')
    Aadd( aRegs, '002')
    Aadd( aRegs, '003')

    //��������������������������������������������������������������������Ŀ
    //� Inicializacao da Regua 1 - Controle por Registro a ser ajustado    �
    //����������������������������������������������������������������������
    FixSet01( Len( aRegs ) )
    FixLog( cLogFile, Space( Len( Dtoc( date() )+" "+Time()+" - " ) )+ProcName() )

    For nI:=1 To Len( aRegs )

        cText:= STR0020 + ": " + aRegs[nI] //STR0020 "Registro"
        FixInc01( cText )
        oMsgText:Refresh()

        //��������������������������������������������������������������������Ŀ
        //� Nesta secao sao montadas as condicoes e os replaces dos ajustes    �
        //����������������������������������������������������������������������
        // EXECUCAO DO AJUSTE NO REGISTRO POSICIONADO

        //��������������������������������������������������������������������Ŀ
        //� Gravacao do Log da alteracao no registro posicionado               �
        //����������������������������������������������������������������������
        FixLog( cLogFile, Space( Len( Dtoc( date() )+" "+Time()+" - " ) )+STR0021 + " "+aRegs[nI] ) //STR0021 "Atualizando registro"
    Next

Return

	/*
	�����������������������������������������������������������������������������
	�����������������������������������������������������������������������������
	�������������������������������������������������������������������������ͻ��
	���Programa  �FixDB90953�Autor  �Microsiga           � Data �  31/01/06   ���
	�������������������������������������������������������������������������͹��
	���Desc.     �Rotina de processamento especifica do Bops 90953            ���
	�������������������������������������������������������������������������͹��
	���Sintaxe   �FixDB90953( )                                               ���
	�������������������������������������������������������������������������ͼ��
	�����������������������������������������������������������������������������
	�����������������������������������������������������������������������������
	*/
    Static ;
    Function FixDB90953( )

    Local nI
    Local naTam := 200

    //��������������������������������������������������������������������Ŀ
    //� Define criterios para a selecao de registros a serem ajustados     �
    //� e monta o vetor de aRegs, que controlara a regua do processamento  �
    //����������������������������������������������������������������������

    For nI := 1 To naTam
        Aadd(aRegs, Replicate("0", (Len(AllTrim(Str(naTam))) - Len(AllTrim(Str(nI)))) ) + AllTrim(Str(nI)) )
    Next nI

    //��������������������������������������������������������������������Ŀ
    //� Inicializacao da Regua 1 - Controle por Registro a ser ajustado    �
    //����������������������������������������������������������������������
    FixSet01( Len( aRegs ) )
    FixLog( cLogFile, Space( Len( Dtoc( date() )+" "+Time()+" - " ) )+ProcName() )

    For nI:=1 To Len( aRegs )

        cText:= STR0020 + ": " + aRegs[nI] //STR0020 "Registro"
        FixInc01( cText )
        oMsgText:Refresh()

        //��������������������������������������������������������������������Ŀ
        //� Nesta secao sao montadas as condicoes e os replaces dos ajustes    �
        //����������������������������������������������������������������������
        // EXECUCAO DO AJUSTE NO REGISTRO POSICIONADO

        //��������������������������������������������������������������������Ŀ
        //� Gravacao do Log da alteracao no registro posicionado               �
        //����������������������������������������������������������������������
        FixLog( cLogFile, Space( Len( Dtoc( date() )+" "+Time()+" - " ) )+STR0021+aRegs[nI] ) //STR0021 "Atualizando registro"
    Next

Return
