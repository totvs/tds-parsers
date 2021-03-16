#include "protheus.ch"

#DEFINE SX3_USADO "ÇÇÇÇÇÇÇÇÇÇÇÇÇÇá"
#DEFINE SX3_NAO_USADO "€€€€€€€€€€€€€€€"
#DEFINE SX3_OBRIGAT "€"
#DEFINE SX3_NAO_OBRIGAT " "

User Function UpdWiz3(lWizard)
    Local nX,nI
    Local cTexto := ""
    Local aUso := {}	// campos que serão alterados para usado/nao usado
    Local aObr := {}	// campos que serão alterados para obrigatório/nao obrigatorio
    Local aX3AltTam := {} 	// Armazena os campos que sofrerão alteração no tamanho e necessitam rodar o
    // atualizador no banco.
    // 	[1] Alias
    //	[2] Campo
    Local aXAInc := {}		// Array com as pastas que serão criadas
    // 	Array[1]
    //		[1] - Alias
    //		[2] - Descrição Português
    //		[3] - Descrição Espanhol
    //		[4] - Descrição Inglês
    //		[5] - Propri
    //	Array[2] - campos que serão associados a pasta


    Private aArqUpd := {}	// armazena as tabelas que serão atualizadas no banco de dados.

    Default lWizard := .F.
	/*
	ALTERACOES PADROES:
	Comente as linhas abaixo de deseja que nao sejam aplicadas cada uma das alteracoes abaixo
	*/
    //------------------------------------------------------------------------------------------
    // altera o usado do campo E2_CODBAR
    //------------------------------------------------------------------------------------------
    cTexto	+=	UsoE2Codbar()
    //------------------------------------------------------------------------------------------
    // Altera o obrigatório dos campos principais de cadastro de produto, fornecedor,
    //------------------------------------------------------------------------------------------
    cTexto	+=	Obrig_Cad(@aObr)
    //------------------------------------------------------------------------------------------
    // Cria novas pastas para separar os enderecos do cadastro de clientes e despoluir a tela
    //------------------------------------------------------------------------------------------
    cTexto	+=	Endereco_SA1()
    //------------------------------------------------------------------------------------------
    // Aumenta o tamanho da parcela para duas posicoes
    //------------------------------------------------------------------------------------------
    cTexto	+=	Aumenta_Parc(@aX3AltTam)
    //------------------------------------------------------------------------------------------
    // Aumenta o tamanho dos campos de municipio e e-mail do cadastro de clientes
    //------------------------------------------------------------------------------------------
    cTexto	+=	AumentaSA1(@aX3AltTam)
    //------------------------------------------------------------------------------------------
    // Aumenta o tamanho dos campos de municipio e e-mail do cadastro de fornecedores
    //------------------------------------------------------------------------------------------
    cTexto	+=	AumentaSA2(@aX3AltTam)
    //------------------------------------------------------------------------------------------
    // Configurar campos de vendedores no pedido de vendas
    //------------------------------------------------------------------------------------------
    cTexto	+=	VendSC5(@aUso)
    //------------------------------------------------------------------------------------------
    // Configurar campos de condicao de pagamento tipo 9 no pedido de vendas
    //------------------------------------------------------------------------------------------
    cTexto	+=	SE4Tp9_SC5(@aUso)
    //------------------------------------------------------------------------------------------
    // Configurar campos de transportadora no pedido de vendas
    //------------------------------------------------------------------------------------------
    cTexto	+=	Transp_SC5(@aUso)
    //------------------------------------------------------------------------------------------
    // Configurar campos de controle de lote
    //------------------------------------------------------------------------------------------
    //cTexto	+=	EST_LOTE(@aUso)

    //------------------------------------------------------------------------------------------
    // Configurar campos de controle de localizacao e serie
    //------------------------------------------------------------------------------------------
    //cTexto	+=	EST_LOCALIZ(@aUso)

    //------------------------------------------------------------------------------------------
    // Altera o uso de  campos de acordo com um INI
    //------------------------------------------------------------------------------------------
    cTexto	+=	AcertaUso(@aUso)
    //------------------------------------------------------------------------------------------
    // Altera o uso de  campos de acordo com um INI
    //------------------------------------------------------------------------------------------
    cTexto	+=	AcertaObr(@aObr)


    //------------------------------------------------------------------------------------------
    // Acerta o uso dos campos
    If Len(aUso) > 0
        For nX:=1 To Len(aUso)
            SX3->(DbSetOrder(2))
            IF SX3->(DbSeek(aUso[nX,1]))
                cReserv  := X3Reserv(SX3->X3_RESERV)
                If (Subs(cReserv,7,1) == " " .and. Subs(cReserv,8,1) == "x") .Or. SX3->X3_PROPRI == "U"
                    If aUso[nX,2] == "1"
                        RecLock("SX3",.F.)
                        SX3->X3_USADO	:=	SX3_USADO
                        MsUnLock()
                        cTexto += "   Campo " + aUso[nX,1]+" configurado como USADO" + CRLF
                    Else
                        RecLock("SX3",.F.)
                        SX3->X3_USADO	:=	SX3_NAO_USADO
                        MsUnLock()
                        cTexto += "   Campo " + aUso[nX,1]+" configurado como NAO USADO" + CRLF
                    Endif
                Else
                    cTexto += "   Não é permitido alterar o uso do campo " + aUso[nX,1] + CRLF
                Endif
            Else
                cTexto += "   Campo " + aUso[nX,1]+" não encontrado" + CRLF
            Endif
        Next
    Endif
    //------------------------------------------------------------------------------------------

    //------------------------------------------------------------------------------------------
    // Acerta o obrigatório
    If Len(aObr) > 0
        For nX:=1 To Len(aObr)
            SX3->(DbSetOrder(2))
            IF SX3->(DbSeek(aObr[nX,1]))
                cReserv  := X3Reserv(SX3->X3_RESERV)
                If Subs(cReserv,7,1) == " " .or. SX3->X3_PROPRI == "U"
                    If aObr[nX,2] == "1"
                        RecLock("SX3",.F.)
                        SX3->X3_OBRIGAT	:=	SX3_OBRIGAT
                        MsUnLock()
                        cTexto += "   Campo " + aObr[nX,1]+" configurado como OBRIGATÓRIO" + CRLF
                    Else
                        RecLock("SX3",.F.)
                        SX3->X3_OBRIGAT:=	SX3_NAO_OBRIGAT
                        MsUnLock()
                        cTexto += "   Campo " + aObr[nX,1]+" configurado como NAO OBRIGATÓRIO" + CRLF
                    Endif
                Else
                    cTexto += "   Não é permitido alterar a obrigatoriedade do campo " + aObr[nX,1] + CRLF
                Endif
            Else
                cTexto += "   Campo " + aObr[nX,1]+" não encontrado" + CRLF
            Endif
        Next
    EndIf
    //------------------------------------------------------------------------------------------

    //------------------------------------------------------------------------------------------
    // Altera o tamanho dos campos no SX3
    For nI := 1 to len(aX3AltTam)
        IF SX3->(DbSeek(aX3AltTam[nI][2]))
            RecLock("SX3", .F.)
            SX3->X3_TAMANHO	:= aX3AltTam[nI][3]
            SX3->(MSUnlock())
            cTexto += "   Alterado o tamanho do campo " + aX3AltTam[nI][2] + " da tabela " + aX3AltTam[nI][1] + CRLF
        EndIf
        // Alimenta a variável para atualizar o banco de dados.
        If Ascan(aArqUpd, {|x| x == aX3AltTam[nI][1]}) == 0
            Aadd(aArqUpd, aX3AltTam[nI][1])
        EndIf
    Next
    //------------------------------------------------------------------------------------------

    //------------------------------------------------------------------------------------------
    // Efetua a alteração no banco.
    __SetX31Mode(.F.)
    For nI := 1 To Len(aArqUpd)
        cTexto += "Atualizando estruturas. Aguarde... ["+aArqUpd[ni]+"]" + CRLF
        If Select(aArqUpd[nI])>0
            dbSelecTArea(aArqUpd[nI])
            dbCloseArea()
        EndIf
        X31UpdTable(aArqUpd[nI])
        If __GetX31Error()
            cTexto += "Ocorreu um erro desconhecido durante a atualizacao da estrutura da tabela : "+aArqUpd[nI] + CRLF
        EndIf
    Next
    //------------------------------------------------------------------------------------------

    If lWizard
        Return cTexto
    EndIf
Return

    //--------------------------------------------------------------------------------
    // Habilita o uso do campo E2_CODBAR
    //--------------------------------------------------------------------------------
Static Function UsoE2CodBar()
    Local cTexto	:=	""
    If MsgYesNo("Habilitar o uso de código de barras no contas a pagar (E2_CODBAR)?")
        SX3->(DbSetOrder(2))
        IF SX3->(DbSeek("E2_CODBAR"))
            RecLock("SX3",.F.)
            SX3->X3_USADO := SX3_USADO
            SX3->X3_VLDUSER := "U_CODBAR()"
            SX3->(MsUnlock())
            // atualiza o texto para retorno
            cTexto += "Alterado o uso e a validação do usuário no campo E2_CODBAR."+CRLF
        EndIf
        //------------------------------------------------------------------------------------------

        //------------------------------------------------------------------------------------------
        // cria o gatilho
        If !SX7->(DbSeek(Padr("E2_CODBAR", len(SX7->X7_CAMPO))+"001"))
            RecLock("SX7",.T.)
            SX7->X7_CAMPO 	:= "E2_CODBAR"
            SX7->X7_SEQUENC := "001"
            SX7->X7_CDOMIN	:= "E2_CODBAR"
            SX7->X7_TIPO	:= "P"
            SX7->X7_REGRA	:= "U_CONVLD()"
            SX7->X7_PROPRI	:= "U"
            SX7->(Msunlock())
            // atualiza o texto para retorno
            cTexto += "Criado gatilho para o campo E2_CODBAR." + CRLF
        EndIf
    Endif
Return cTexto


    //--------------------------------------------------------------------------------
    // Altera o obrigat dos campos
    //--------------------------------------------------------------------------------
Static Function Obrig_Cad(aObr)
    Local aX3Obrigat := {'B1_POSIPI', 'B1_ORIGEM', 'A1_COD_MUN', 'A1_BAIRRO', 'A1_CEP', 'A1_PAIS', 'A1_INSCR', 'A2_COD_MUN', ;
        'A2_BAIRRO', 'A2_CEP', 'A2_PAIS', 'A2_INSCR', 'F4_SITTRIB', 'F4_CTIPI', 'F4_CSTPIS', 'F4_CSTCOF'}

    Local	cMensagem:=	"Definir os seguintes campos dos cadastros de cliente, fornecedor, produto e TES como obrigatorios? "+CRLF
    Local nI
    Local cTexto	:=	""
    aEval(aX3Obrigat,{|x| cMensagem+=x+"| " })
    If MsgYesNo(cMensagem)
        For nI := 1 to len(aX3Obrigat)
            aadd(aObr,{aX3Obrigat[nI],"1"})
        Next
    Endif

Return cTexto

    //--------------------------------------------------------------------------------
    // Organiza os campos de endereço em uma nova pasta
    //--------------------------------------------------------------------------------
Static Function Endereco_SA1()
    Local aXAinc	:=	{}
    Local nI,nJ
    Local cXAOrd	:=	""
    Local cTexto	:=	""
    Local aAux		:= {}
    Local nOrdEndE	:= 0
    Local nOrdCepE	:= 0

    //Private aCols := {}

    Aadd(aXAInc, {{	"SA1", "Endereços Adicionais", "Direcciones adicionales", "Additional addresses", "S"}, ;
        {"A1_ENDCOB","A1_BAIRROC","A1_CEPC","A1_ESTC","A1_MUNC","A1_ENDENT","A1_BAIRROE","A1_CEPE","A1_ESTE","A1_MUNE"}})

    If MsgYesNo("Reorganizar campos de endereço adicionais no cadastro de clientes em uma nova pasta?")

        For nI := 1 to len(aXAInc)
            // Verifica a ordem da pasta que será criada
            SXA->(DbSetOrder(1))
            SXA->(DbSeek(aXAInc[nI][1][1]))
            While !SXA->( Eof() ) .and. SXA->XA_ALIAS == aXAInc[nI][1][1]
                cXAOrd := SXA->XA_ORDEM
                SXA->( DbSkip() )
            EndDo
            cXAOrd := Soma1(cXAOrd)

            // cria a pasta
            RecLock("SXA", .T.)
            SXA->XA_ALIAS := aXAInc[nI][1][1]
            SXA->XA_ORDEM := cXAOrd
            SXA->XA_DESCRIC	:= aXAInc[nI][1][2]
            SXA->XA_DESCSPA	:= aXAInc[nI][1][3]
            SXA->XA_DESCENG	:= aXAInc[nI][1][4]
            SXA->XA_PROPRI	:= aXAInc[nI][1][5]
            SXA->(MsUnlock())

            // atualiza o texto para retorno
            cTexto += "Pasta " + aXAInc[nI][1][2] + " - ordem " + cXAOrd + " criada na tabela " + aXAInc[nI][1][1]+ CRLF

            // Associa os campos ao folder e marca como usado.
            SX3->(DbSetOrder(2))
            For nJ := 1 to len(aXAInc[nI][2])
                IF SX3->(DbSeek(aXAInc[nI][2][nJ]))
                    RecLock("SX3", .F.)
                    SX3->X3_FOLDER	:= cXAOrd
                    SX3->X3_USADO 	:= SX3_USADO

                    // altera a propriedade do campo para alterar
                    If Alltrim(aXAInc[nI][2][nJ]) == "A1_ESTE"
                        SX3->X3_VISUAL 	:= "A"
                    EndIf
                    SX3->(MSUnlock())
                    cTexto += "   Campo " + aXAInc[nI][2][nJ] + " associado à pasta " + cXAOrd + " da tabela " + aXAInc[nI][1][1] + CRLF
                EndIf
            Next

            // Altera a ordem do campo
            WizReordX3("SA1", "A1_ENDENT", "A1_ESTC")
        Next
    Endif
Return cTexto

    //--------------------------------------------------------------------------------
    // Aumenta o tamanho dos campos de parcela
    //--------------------------------------------------------------------------------
Static Function Aumenta_Parc(aX3AltTam)
    Local cTexto	:=	""
    Local cAlias := cX1Filter := cX3Filter :=	""
    Local nSize,nI
    Local aXGAlt	:=	{}
    If MsgYesNo("Aumentar o tamanho da parcela para 2 posições?")

        Aadd(aXGAlt, {"011", 2})

        For nI := 1 to len(aXGAlt)
            nSize := aXGAlt[nI][2]
            SXG->(DbSetOrder(1))
            IF SXG->(DbSeek(aXGAlt[nI][1]))
                If nSize >= SXG->XG_SIZEMIN .And. nSize <= SXG->XG_SIZEMAX
                    // grava a alteração no grupo de campos
                    RecLock("SXG",.F.)
                    SXG->XG_SIZE := aXGAlt[nI][2]
                    SXG->(MsUnlock())
                    cTexto += "Tamanho do grupo de campos " + aXGAlt[nI][1] + " - " + Alltrim(SXG->XG_DESCRI) + " alterado para " + Alltrim(Str(nSize)) + CRLF

                    cAlias := Alias()
                    // armazena os campos relacionado no SXG para alterar a base posteriormente.
                    DbSelectArea("SX3")
                    cX3Filter := DbFilter()
                    SET FILTER TO X3_GRPSXG == aXGAlt[nI][1]
                    DbGoTop()
                    While !Eof()
                        Aadd(aX3AltTam, {X3_ARQUIVO, X3_CAMPO, nSize })
                        DbSkip()
                    End
                    SET FILTER TO &(cX3Filter)

                    // atualiza as perguntas relacionadas ao grupo de campos
                    DbSelectArea("SX1")
                    cX1Filter := DbFilter()
                    SET FILTER TO X1_GRPSXG == aXGAlt[nI][1]
                    DbGoTop()
                    While !Eof()
                        RecLock("SX1",.F.)
                        SX1->X1_TAMANHO := nSize
                        DbSkip()
                        cTexto += "   Alterado o tamanho da pergunta " + Alltrim(X1_GRUPO) + " ordem " + X1_ORDEM + " para " + Alltrim(Str(nSize)) + CRLF
                    End
                    MsUnlock()
                    SET FILTER TO &(cX1Filter)

                    DbSelectArea(cAlias)
                EndIf
            EndIf
        Next
    Endif

Return cTexto

    //--------------------------------------------------------------------------------
    // Aumenta o tamanho dos campos da SA1
    //--------------------------------------------------------------------------------
Static Function AumentaSA1(aX3AltTam)
    Local nI				:=	0
    Local cTexto	:=	""
    If MsgYesNo("Aumentar tamanho dos campos de municipio e e-mail do cadastro de clientes?")

        Aadd(aX3AltTam, {"SA1", "A1_MUN", 60 })
        Aadd(aX3AltTam, {"SA1", "A1_EMAIL", 60 })

    Endif
Return cTexto

    //--------------------------------------------------------------------------------
    // Aumenta o tamanho dos campos da SA2
    //--------------------------------------------------------------------------------
Static Function AumentaSA2(aX3AltTam)
    Local nI				:=	0
    Local cTexto	:=	""
    If MsgYesNo("Aumentar o tamanho do campo de e-mail do cadastro de fornecedores?")

        Aadd(aX3AltTam, {"SA2", "A2_EMAIL", 60 })

    Endif
Return cTexto

    //--------------------------------------------------------------------------------
    // Altera o uso dos campos
    //--------------------------------------------------------------------------------
Static Function AcertaUso(aUso)
    Local cTexto	:=	cLine	:=	""
    Local nAt	:=	0

    If MsgYesNo("Usar arquivo WIZUSO.INI de configuração para acertar uso de um grupo de campos?"+CRLF+CRLF+;
            "O arquivo deve ter na primeira linha a palavra USO e um campo em cada linha com a seguinte sintaxe: NOME_DE_CAMPO=1 para configurar como usado e NOME_DE_CAMPO=0 para não usado")

        //	cFile	:=	cGetFile( "Configuração de usados|*.ini" , 'Configuração de uso', 0, '\', .F., nOR( GETF_LOCALHARD, GETF_LOCALFLOPPY,  GETF_NETWORKDRIVE	 ),.T.,.T. )

        IF FT_FUSE("WIZUSO.INI") > 0
            cLine	:=	FT_FREADLN()
            If "USO"$cLine
                FT_FSKIP()
                While !FT_FEOF()
                    cLine	:=	Upper(FT_FREADLN())
                    nAt	:=	At("=",cLine)
                    If nAT > 0 .And. SubStr(cLine,1,1) <> "#" .And. SubStr(cLine,1,1) <> "["
                        AAdd(aUso,{Substr(cLine,1,nAt-1),Substr(cLine,nAt+1,1)})
                    Endif
                    FT_FSKIP()
                Enddo
                FT_FUSE()
            Else
                cTexto	+=	"Arquivo wizuso.ini inválido"+CRLF
            Endif
        Else
            cTexto	+=	"Arquivo wizuso.ini não pode ser aberto"+CRLF
        Endif
    Endif

Return cTexto

Static Function AcertaObr(aObr)
    Local cTexto	:=	cLine	:=	cReserv	:=	""
    Local nAt,nX	:=	0

    If MsgYesNo("Usar arquivo WIZOBRIGAT.INI de configuração para acertar a obrigatoriedade de um grupo de campos?"+CRLF+CRLF+;
            "O arquivo deve ter na primeira linha a palavra OBRIGAT e um campo em cada linha com a seguinte sintaxe: NOME_DE_CAMPO=1 para configurar como OBRIGATORIO e NOME_DE_CAMPO=0 para OPCIONAL")

        //	cFile	:=	cGetFile( "Configuração de obrigatórios|*.ini" , 'Configuração de obrogatorio', 0, '\', .F., nOR( GETF_LOCALHARD, GETF_LOCALFLOPPY,  GETF_NETWORKDRIVE	 ),.T.,.T. )

        IF FT_FUSE("WIZOBRIGAT.INI") > 0
            cLine	:=	FT_FREADLN()
            If "OBRIGAT"$cLine
                FT_FSKIP()
                While !FT_FEOF()
                    cLine	:=	Upper(FT_FREADLN())
                    nAt	:=	At("=",cLine)
                    If nAT > 0 .And. SubStr(cLine,1,1) <> "#".And. SubStr(cLine,1,1) <> "["
                        AAdd(aObr,{Substr(cLine,1,nAt-1),Substr(cLine,nAt+1,1)})
                    Endif
                    FT_FSKIP()
                Enddo
                FT_FUSE()
            Else
                cTexto	+=	"Arquivo wizobrogat.ini inválido"+CRLF
            Endif
        Else
            cTexto	+=	"Arquivo wizobrogat.ini não pode ser aberto"+CRLF
        Endif
    Endif
Return cTexto

    //--------------------------------------------------------------------------------
    // Define a quantidade de vendedores no Pedido de Venda
    //--------------------------------------------------------------------------------
Static Function VendSC5(aUso)
    Local lTmp	:=	.F.
    Local nResp:=nOld:= 0
    Local nX	:=	0
    Local cTexto	:=	""
    If Type("lMsHelpAuto") <> "U"
        lTmp	:=	lMsHelpAuto
        lMsHelpAuto	:=	.F.
    Endif
    If (nResp	:=	Aviso("Configuração vendedores","Qual o número máximo de vendedores no Pedido de vendas?",{"0","1","2","3","4","5"}))  < 6
        If nResp == 1
            // não utiliza dados do vendedor, então desabilita os campos de vendedor e comissão de 1 a 5
            For nX := 1 to 5
                AAdd(aUso,{"C5_VEND" +Alltrim(Str(nX,1)),"0"})
                AAdd(aUso,{"C5_COMIS"+Alltrim(Str(nX,1)),"0"})
                AAdd(aUso,{"C6_COMIS"+Alltrim(Str(nX,1)),"0"})
            Next
        Else
            For nX := nResp-1 to 5
                IF nX > nResp-1
                    AAdd(aUso,{"C5_VEND" +Alltrim(Str(nX,1)),"0"})
                    AAdd(aUso,{"C5_COMIS"+Alltrim(Str(nX,1)),"0"})
                    AAdd(aUso,{"C6_COMIS"+Alltrim(Str(nX,1)),"0"})
                Else
                    AAdd(aUso,{"C5_VEND" +Alltrim(Str(nX,1)),"1"})
                    AAdd(aUso,{"C5_COMIS"+Alltrim(Str(nX,1)),"1"})
                    AAdd(aUso,{"C6_COMIS"+Alltrim(Str(nX,1)),"1"})
                EndIF
            Next
        EndIf
    Endif
    If Type("lMsHelpAuto") <> "U"
        lMsHelpAuto	:=	lTmp
    Endif
Return cTexto

    //--------------------------------------------------------------------------------
    // Define se usa o pagamento tipo 9
    //--------------------------------------------------------------------------------
Static Function SE4Tp9_SC5(aUso)
    Local cTexto	:=	""
    Local nX	:=	0
    If !MsgYesNo("Usa condição de pagamento tipo 9?")
        For nX:= 1 To 12
            AAdd(aUso,{"C5_PARC"+Alltrim(Str(nX)),"0"})
            AAdd(aUso,{"C5_DATA"+Alltrim(Str(nX)),"0"})
        Next
    Else
        For nX:= 1 To 12
            AAdd(aUso,{"C5_PARC"+Alltrim(Str(nX)),"1"})
            AAdd(aUso,{"C5_DATA"+Alltrim(Str(nX)),"1"})
        Next
    Endif
Return cTexto

    //--------------------------------------------------------------------------------
    // Define se usa transportadora no pedido de venda
    //--------------------------------------------------------------------------------
Static Function Transp_SC5(aUso)
    Local cTexto :=	""
    If !MsgYesNo("Usa transportadora nos pedidos de venda?")
        AAdd(aUso,{"C5_TRANSP","0"})
        AAdd(aUso,{"C5_REDESP","0"})
    Else
        AAdd(aUso,{"C5_TRANSP","1"})
        AAdd(aUso,{"C5_REDESP","1"})
    Endif
Return cTexto


Static Function EST_LOTE(aUSo)
    Local cTexto	:=	""
    Local nResp	:=	0
    Local lTMP	:=	.F.

    //No controle de lote tem muitos campos que nao podem ser tirados de uso, avaliar se vale a pena
    If Type("lMsHelpAuto") <> "U"
        lTmp	:=	lMsHelpAuto
        lMsHelpAuto	:=	.F.
    Endif
    nResp	:=	Aviso("Controle de lote","Usa controle de lote?",{"Lote","Sublote","Não utiliza"})
    If Type("lMsHelpAuto") <> "U"
        lMsHelpAuto	:=	lTmp
    Endif

    If nResp == 1
        PutMV("MV_LOTE","L")
        DbSelectArea("SX3")
        SET FILTER TO RIGHT(Alltrim(SX3->X3_CAMPO),8) == "_NUMLOTE" .OR.RIGHT(Alltrim(SX3->X3_CAMPO),7) == "_NUMLOT"
        DbGoTop()
        While !EOF()
            AAdd(aUso,{SX3->X3_CAMPO,"0"})
            DbSkip()
        Enddo
        DbSelectArea("SX3")
        SET FILTER to
        SET FILTER TO RIGHT(Alltrim(SX3->X3_CAMPO),8) == "_LOTECTL" .OR.RIGHT(Alltrim(SX3->X3_CAMPO),7) == "_LOTECT"
        DbGoTop()
        While !EOF()
            AAdd(aUso,{SX3->X3_CAMPO,"1"})
            DbSkip()
        Enddo
        SET FILTER to
    ElseIf nResp == 2
        PutMV("MV_LOTE","S")
        DbSelectArea("SX3")
        SET FILTER TO RIGHT(Alltrim(SX3->X3_CAMPO),8) == "_NUMLOTE" .OR.RIGHT(Alltrim(SX3->X3_CAMPO),7) == "_NUMLOT" .Or.RIGHT(Alltrim(SX3->X3_CAMPO),8) == "_LOTECTL" .OR.RIGHT(Alltrim(SX3->X3_CAMPO),7) == "_LOTECT"
        DbGoTop()
        While !EOF()
            AAdd(aUso,{SX3->X3_CAMPO,"1"})
            DbSkip()
        Enddo
        DbSelectArea("SX3")
        SET FILTER to
    ElseIf nResp == 3
        PutMV("MV_LOTE","N")
        DbSelectArea("SX3")
        SET FILTER TO RIGHT(Alltrim(SX3->X3_CAMPO),8) == "_NUMLOTE" .OR.RIGHT(Alltrim(SX3->X3_CAMPO),7) == "_NUMLOT" .Or.RIGHT(Alltrim(SX3->X3_CAMPO),8) == "_LOTECTL" .OR.RIGHT(Alltrim(SX3->X3_CAMPO),7) == "_LOTECT"
        DbGoTop()
        While !EOF()
            AAdd(aUso,{SX3->X3_CAMPO,"0"})
            DbSkip()
        Enddo
        DbSelectArea("SX3")
        SET FILTER to
    Endif

Return cTexto

Static Function	EST_LOCALIZ(aUso)
    Local cTexto	:=	""
    Local nResp	:=	0
    Local lTMP	:=	.F.
    //No controle de localizacao e serie tem muitos campos que nao podem ser tirados de uso, avaliar se vale a pena
    If Type("lMsHelpAuto") <> "U"
        lTmp	:=	lMsHelpAuto
        lMsHelpAuto	:=	.F.
    Endif

    nResp	:=	Aviso("Controle de localizacao fisica","Usa localizacao fisica?",{"Endereco","End+Num.Serie","Não utiliza"})

    If Type("lMsHelpAuto") <> "U"
        lMsHelpAuto	:=	lTmp
    Endif

    If nResp == 1
        PutMV("MV_LOCALIZ","S")
        DbSelectArea("SX3")
        SET FILTER TO RIGHT(Alltrim(SX3->X3_CAMPO),8) == "_LOCALIZ" .OR.RIGHT(Alltrim(SX3->X3_CAMPO),7) == "_LOCALI"
        DbGoTop()
        While !EOF()
            AAdd(aUso,{SX3->X3_CAMPO,"1"})
            DbSkip()
        Enddo
        DbSelectArea("SX3")
        SET FILTER to
        SET FILTER TO RIGHT(Alltrim(SX3->X3_CAMPO),8) == "_NUMSERI" .OR.RIGHT(Alltrim(SX3->X3_CAMPO),7) == "_NUMSER"
        DbGoTop()
        While !EOF()
            AAdd(aUso,{SX3->X3_CAMPO,"0"})
            DbSkip()
        Enddo
        SET FILTER to
    ElseIf nResp == 2
        PutMV("MV_LOCALIZ","S")
        DbSelectArea("SX3")
        SET FILTER TO RIGHT(Alltrim(SX3->X3_CAMPO),8) == "_LOCALIZ" .OR.RIGHT(Alltrim(SX3->X3_CAMPO),7) == "_LOCALI" .or.RIGHT(Alltrim(SX3->X3_CAMPO),8) == "_NUMSERI" .OR.RIGHT(Alltrim(SX3->X3_CAMPO),7) == "_NUMSER"
        DbGoTop()
        While !EOF()
            AAdd(aUso,{SX3->X3_CAMPO,"1"})
            DbSkip()
        Enddo
        DbSelectArea("SX3")
        SET FILTER to
    Endif

Return cTexto
