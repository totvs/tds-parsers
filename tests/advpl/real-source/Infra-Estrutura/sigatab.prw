#include "protheus.ch"

Static __aTabs

Function IsTabOk(cAlias,cModo,aResp)
    Local ni, lRet := .t., cStr, nRec, lFlag

    DEFAULT __aTabs := LoadTabInfo()

    If Ascan(__aTabs,{|x| x[2][1] == cAlias}) == 0
        Return lRet
    EndIf

    DEFAULT cAlias:= SX2->X2_CHAVE
    DEFAULT cModo := SX2->X2_MODO

    If ( SX2->X2_CHAVE != cAlias )
        nRec := SX2->(Recno())
        If ( ! SX2->(dbSeek(cAlias)) )
            SX2->(dbGoto(nRec))
            Return lRet
        EndIf
        SX2->(dbGoto(nRec))
    EndIf

    cStr	:= Alltrim(SX2->X2_PATH)+Alltrim(SX2->X2_ARQUIVO)
    aResp	:= {}

    If ( !LockByName(cStr,.t.,.f.,.t.) )     // Jah Tem estacao no Ar Que checou
        Return lRet
    EndIf

    For ni := 1 to Len(__aTabs)
        If __aTabs[ni,2,1] == cAlias
            lFlag := .t.

            If __aTabs[ni,2,2] == "="
                If cModo != SX2MODO(__aTabs[ni,1,1])
                    lFlag := .f.
                EndIf
            ElseIf __aTabs[ni,2,2] == "C" .and. cModo == "C"
                IF SX2MODO(__aTabs[ni,1,1])  != __aTabs[ni,1,2]
                    lFlag := .f.
                EndIf
            ElseIf __aTabs[ni,2,2] == "E" .and. cModo == "E"
                If SX2MODO(__aTabs[ni,1,1])  != __aTabs[ni,1,2]
                    lFlag := .f.
                EndIf
            EndIf

            IF !lFlag
                lRet := .f.
                AADD(aResp,"Config. do X2_MODO : "+cAlias+" incompativel com "+__aTabs[ni,1,1])
            EndIf
        EndIf

    Next

Return lRet

    // ------------------------------------------------------

Function LoadTabInfo()
    Local aRet := {}

    // Exemplo de configuração

    //AADD(aRet,{{"SB1","?"},{"SB5","="}}   //SB1 COMPARTILHADO OU EXCLUSIVO, o SB5 eh IGUAL
    //AADD(aRet,{{"SA1","E"},{"SC5"","E"}}  // SE o SA1 FOR EXCLUSIVO, o SC5 TEM QUE SER EXCLUSIVO
    //AADD(aRet,{{"SE1","?"},{"SE2","="}}  // SE1 COMPRTILHADO OU EXCLUSIVO, o SE2 eh IGUAL
    //AADD(aRet,{{"SE1","?"},{"SE5","="}}  // SE1 COMPRTILHADO OU EXCLUSIVO, o SE5 eh IGUAL, consequentemente SE2 tambem estah checado

    Aadd(aRet, {{"SW0", "?"},{"SW1","="}})
    Aadd(aRet, {{"SW2", "?"},{"SW3","="}})
    Aadd(aRet, {{"SW2", "?"},{"SW4","="}})
    Aadd(aRet, {{"SW2", "?"},{"SW5","="}})
    Aadd(aRet, {{"SW2", "?"},{"SW6","="}})
    Aadd(aRet, {{"SW2", "?"},{"SW7","="}})
    Aadd(aRet, {{"SW2", "?"},{"SW8","="}})
    Aadd(aRet, {{"SW2", "?"},{"SW9","="}})
    Aadd(aRet, {{"SW2", "?"},{"SWD","="}})

    Aadd(aRet, {{"SW2", "?"},{"SWN","="}})
    Aadd(aRet, {{"SW2", "?"},{"SWW","="}})
    Aadd(aRet, {{"SWA", "?"},{"SWB","="}})
    Aadd(aRet, {{"EE1", "?"},{"EE2","="}})
    Aadd(aRet, {{"EE1", "?"},{"EE3","="}})
Return aRet

    // ------------------------------------------------------

Function SX2MODO(cAlias)
    Local nPos, cModo, nRec
    Local cAux := '/'+cArqTab
    nPos := AT('/'+cAlias, cAux)

    If nPos > 0
        cModo := Subs(cArqTab,nPos+3,1)
    Else
        nRec := SX2->(Recno())
        If !SX2->(dbSeek(cAlias))
            UserException("Falta Registro no SX2 --> "+cAlias)
        EndIf
        cModo := SX2->X2_MODO
        SX2->(dbGoto(nRec))
    EndIf

    If cModo != "E"
        cModo := "C"
    EndIf

Return cModo

