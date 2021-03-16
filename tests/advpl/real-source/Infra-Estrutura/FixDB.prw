#include "Protheus.CH"
#include "FixDB.CH"

//Variaveis eetaticas usadas pelo meter e timer
Static n01Tasks
Static n02Tasks
Static n01Complete
Static n02Complete
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFixDB     บAutor  ณMicrosiga           บ Data ณ 27/Jan/2006 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao para compatibilizar bases de dados                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณAssociado as correcoes de BOPS                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametro ณNumero do Bops ( ExpC1 )                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
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
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
	ฑฑณFun…o    ณOpenSM0    ณ Autor ณMicrosiga             ณ Data ณ07/01/2003ณฑฑ
	ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
	ฑฑณDescri…o ณ Efetua a abertura do SM0                                   ณฑฑ
	ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
	ฑฑณ Uso      ณ Atualizacao                                                ณฑฑ
	ฑฑภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
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
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
	ฑฑบPrograma  ณFixDBFun  บAutor  ณMicrosiga           บ Data ณ  31/01/06   บฑฑ
	ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
	ฑฑบDesc.     ณFuncao complementar do processamento de ajustes de Base     บฑฑ
	ฑฑบ          ณde Dados. (Processamento por Bops)                          บฑฑ
	ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
	ฑฑบSintaxe   ณFixDBFun ( ExpC1 )                                          บฑฑ
	ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
	ฑฑบParametrosณExpC1 - Numero do Bops                                      บฑฑ
	ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
	*/
    Static ;
    Function FixDBFun( cBops )
    Default cBops := ''

    //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
    //ณ Array de Empresas (segunda regua: Empresa + Filial)          ณ
    //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
    DbSelectArea('SM0')
    DbSetOrder(1)
    DbGoTop()
    While ( ! Eof() )
        Aadd( aEmpresa, {M0_CODIGO, M0_FILIAL} )
        DbSkip()
    EndDo

    //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
    //ณ Monta o numero do Bops completo - 11 posicoes       ณ
    //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
    cBops := StrZero( Val( cBops), 11)

    //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
    //ณ processamento                                       ณ
    //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
    FixDBExec( cBops )

    DbCloseAll()
Return


	/*/
    ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
    ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
    ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
    ฑฑบFuncao    ณVarias    บAutor  ณMicrosiga           บ Data ณ  31/01/06   บฑฑ
    ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
    ฑฑบDesc.     ณFuncoes para controle das reguas de processamento e mensa-  บฑฑ
    ฑฑบ          ณgens                                                        บฑฑ
    ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
    ฑฑบSintaxe   ณFixResetRegua( )                                            บฑฑ
    ฑฑบ          ณFixStartRegua ( )                                           บฑฑ
    ฑฑบ          ณFixSet01 ( n01 )                                            บฑฑ
    ฑฑบ          ณFixSet02 ( n02 )                                            บฑฑ
    ฑฑบ          ณFixInc01( cNewText, lClean )                                บฑฑ
    ฑฑบ          ณFixInc02( cNewText, lClean )                                บฑฑ
    ฑฑบ          ณFixMtMsg( cText1, cText2 )                                  บฑฑ
    ฑฑบ          ณFixShowMsg( cShow, lClean, lCRLF)                           บฑฑ
    ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
    ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
    ฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
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
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
	ฑฑบPrograma  ณFixLog    บAutor  ณAndre Veiga         บ Data ณ  27/11/01   บฑฑ
	ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
	ฑฑบDesc.     ณGera arquivo de Log para informar se alguma coisa nao       บฑฑ
	ฑฑบ          ณfuncionou corretamente no processamento.                    บฑฑ
	ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
	ฑฑบSintaxe   ณFixLog( ExpC1, ExpC2 )                                      บฑฑ
	ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
	ฑฑบParametrosณExpC1 - Path e nome do arquivo para gerar o log             บฑฑ
	ฑฑบ          ณExpC2 - Texto a ser gravado no arquivo de log.              บฑฑ
	ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
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
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
	ฑฑบPrograma  ณFixDBExec บAutor  ณMicrosiga           บ Data ณ  31/01/06   บฑฑ
	ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
	ฑฑบDesc.     ณFuncao de execucao das rotinas de processamento de acordo   บฑฑ
	ฑฑบ          ณcom o Bops relacionado                                      บฑฑ
	ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
	ฑฑบSintaxe   ณFixDBExec (cExpC1 )                                         บฑฑ
	ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
	ฑฑบParametrosณExpC1 - Numero do Bops                                      บฑฑ
	ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
	*/
    Static ;
    Function FixDBExec( cBops )
    Local cNomeArq
    Local cExtArq	:= ".##R"
    Local nJ
    Default cBops 	:= ''

    //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
    //ณ Inicializacao da Regua 2 - Controle por Empresa + Filial           ณ
    //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
    FixSet02( Len( aEmpresa ) )
    FixStartRegua()

    For nJ:=1 To Len( aEmpresa )

        RPCSetType(3)
        RPCSetEnv( aEmpresa[nJ][1], aEmpresa[nJ][2] )

        cText:= STR0009 + " " + aEmpresa[nJ][1] + " - " + STR0010 + ": " + aEmpresa[nJ][2]
        FixInc02( cText )
        oMsgText:Refresh()
        //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
        //ณ Gravacao do Log de inicio do ajuste para a empresa+filial posicionada ณ
        //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
        cNomeArq	:= "FIX"+AllTrim( Str( Val(cBops)))
        cLogFile	:= __RelDir + cNomeArq + cExtArq
        FixLog( cLogFile, Dtoc( date() )+" "+Time()+" - "+STR0011+" "+Trim(aEmpresa[nJ][1])+", "+STR0012+" "+Trim(aEmpresa[nJ][2])+"." )

        //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
        //ณ CASE PRINCIPAL                                           ณ
        //ณ Processamento das Funcoes de Ajuste por Bops             ณ
        //ณ Para cada Tarefa (aRegs) sera executada a funcao         ณ
        //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
        Do Case
        Case cBops = '0000EXEMPLO'   //Exemplo 01 de Rotina de Ajuste
            FixDBExemp( )
            //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
            //ณ Nesta secao sao chamadas as rotinas especificas de ajuste ณ
            //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
        Case cBops = '000000xxxxx'
            //FixDBxxxxx( )
        Case cBops = '00000090953'   //Exemplo 02 de Rotina de Ajuste
            FixDB90953( )
        OtherWise
            MsgAlert(STR0013 + " " + cBops)
            FixLog( cLogFile, Dtoc( date() )+" "+Time()+ " - " + STR0014 + " " + cBops + "." )
        EndCase
        //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
        //ณ Gravacao do Log da finalizacao do ajuste por empresa+filial        ณ
        //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
        FixLog( cLogFile, Dtoc( date() ) + " " + Time() + " - " + STR0015 + " " + Trim(aEmpresa[nJ][1]) + ", " + STR0012 + " " + Trim(aEmpresa[nJ][2]) + "." )

    Next

    //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
    //ณ Gravacao do Log da finalizacao do ajuste e aviso ao usuario        ณ
    //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
    FixLog( cLogFile, Dtoc( date() )+" "+Time()+" - " + STR0016)
    FixLog( cLogFile, "" )

    MsgAlert( STR0017+Chr(13)+Chr(10)+STR0018+" '"+cLogFile+"' " + STR0019 )
    FixResetRegua ( )

Return




	/*
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
	ฑฑบPrograma  ณFixDBExempบAutor  ณMicrosiga           บ Data ณ  31/01/06   บฑฑ
	ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
	ฑฑบDesc.     ณRotina de processamento especifica do Bops Exemplo          บฑฑ
	ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
	ฑฑบSintaxe   ณFixDBExemp( )                                               บฑฑ
	ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
	*/
    Static ;
    Function FixDBExemp( )
    Local nI

    //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
    //ณ Define criterios para a selecao de registros a serem ajustados     ณ
    //ณ e monta o vetor de aRegs, que controlara a regua do processamento  ณ
    //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
    Aadd( aRegs, '001')
    Aadd( aRegs, '002')
    Aadd( aRegs, '003')

    //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
    //ณ Inicializacao da Regua 1 - Controle por Registro a ser ajustado    ณ
    //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
    FixSet01( Len( aRegs ) )
    FixLog( cLogFile, Space( Len( Dtoc( date() )+" "+Time()+" - " ) )+ProcName() )

    For nI:=1 To Len( aRegs )

        cText:= STR0020 + ": " + aRegs[nI] //STR0020 "Registro"
        FixInc01( cText )
        oMsgText:Refresh()

        //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
        //ณ Nesta secao sao montadas as condicoes e os replaces dos ajustes    ณ
        //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
        // EXECUCAO DO AJUSTE NO REGISTRO POSICIONADO

        //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
        //ณ Gravacao do Log da alteracao no registro posicionado               ณ
        //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
        FixLog( cLogFile, Space( Len( Dtoc( date() )+" "+Time()+" - " ) )+STR0021 + " "+aRegs[nI] ) //STR0021 "Atualizando registro"
    Next

Return

	/*
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
	ฑฑบPrograma  ณFixDB90953บAutor  ณMicrosiga           บ Data ณ  31/01/06   บฑฑ
	ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
	ฑฑบDesc.     ณRotina de processamento especifica do Bops 90953            บฑฑ
	ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
	ฑฑบSintaxe   ณFixDB90953( )                                               บฑฑ
	ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
	*/
    Static ;
    Function FixDB90953( )

    Local nI
    Local naTam := 200

    //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
    //ณ Define criterios para a selecao de registros a serem ajustados     ณ
    //ณ e monta o vetor de aRegs, que controlara a regua do processamento  ณ
    //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

    For nI := 1 To naTam
        Aadd(aRegs, Replicate("0", (Len(AllTrim(Str(naTam))) - Len(AllTrim(Str(nI)))) ) + AllTrim(Str(nI)) )
    Next nI

    //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
    //ณ Inicializacao da Regua 1 - Controle por Registro a ser ajustado    ณ
    //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
    FixSet01( Len( aRegs ) )
    FixLog( cLogFile, Space( Len( Dtoc( date() )+" "+Time()+" - " ) )+ProcName() )

    For nI:=1 To Len( aRegs )

        cText:= STR0020 + ": " + aRegs[nI] //STR0020 "Registro"
        FixInc01( cText )
        oMsgText:Refresh()

        //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
        //ณ Nesta secao sao montadas as condicoes e os replaces dos ajustes    ณ
        //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
        // EXECUCAO DO AJUSTE NO REGISTRO POSICIONADO

        //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
        //ณ Gravacao do Log da alteracao no registro posicionado               ณ
        //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
        FixLog( cLogFile, Space( Len( Dtoc( date() )+" "+Time()+" - " ) )+STR0021+aRegs[nI] ) //STR0021 "Atualizando registro"
    Next

Return
