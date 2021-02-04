###PARSER-Não remover esta linha(Framework Logix)###
#-----------------------------------------------------------------------#
# SISTEMA.: SUPRIMENTOS                                                 #
# FUNCAO..: SUP3761                                                     #
# OBJETIVO: DEFINICOES/INICIALIZACAO DE VARIAVEIS UTILIZADAS NO SUP3760 #
# AUTOR...: TATIANE WIESE - IVAN PAULO RONCHI                           #
# DATA....: 01/11/1996                                                  #
#-----------------------------------------------------------------------#######

DATABASE logix

  GLOBALS
 DEFINE p_cod_empresa       LIKE empresa.cod_empresa,
         g_ies_obj_entrada   LIKE cod_fiscal_sup.ies_obj_entrada,
         p_cod_empresa_dest  LIKE empresa.cod_empresa,
         p_user              LIKE usuario.nom_usuario,
         p_ies_fornec_ativo  LIKE fornecedor.ies_fornec_ativo,
         p_ies_cod_operac    CHAR(01),
         p_ies_tip_entrada   LIKE cod_fiscal_sup.ies_tip_entrada,
         p_ies_cod_cgc       CHAR(01),
         p_ies_cod_fornec    CHAR(01),
         g_ies_grafico       SMALLINT,
         p_ies_dat_fabr_ar   CHAR(01),
         p_cod_secao_rec     LIKE ordem_sup.cod_secao_receb,
         p_cod_operacao      LIKE estoque_operac.cod_operacao,
         p_conta             SMALLINT,
         p_tmp_transpor      LIKE fornecedor.tmp_transpor,
         p_cod_tip_despesa   LIKE ordem_sup.cod_tip_despesa,
         p_ies_entr_sem_ped  SMALLINT,
         p_sup_cap           SMALLINT,
         p_sup_mes           SMALLINT,
         p_cod_grp_desp_nfr  DECIMAL(15,2),
         p_ies_item_nfd_nfr  CHAR(1),
         p_ies_entrada_maior CHAR(1),
         p_ies_incl_cap      SMALLINT,
         p_ies_imp_iss       CHAR(01),
         p_tip_desp_cons_fat DECIMAL(4,0),
         p_aguarda_fatura    CHAR(1),
         p_cons_data         SMALLINT,
         p_qtd_dias_emis_doc DECIMAL(5,0),
         p_nom_reduz_cli     CHAR(10),
         p_cgc_cpf1          CHAR(3),
         p_cgc_cpf2          CHAR(3),
         p_cgc_cpf3          CHAR(3),
         p_cgc_cpf4          CHAR(4),
         p_cgc_cpf5          CHAR(2),
         p_ord_forn          SMALLINT,
         p_tipo              CHAR(8),
         p_quantos           SMALLINT,
         p_aguard_5          SMALLINT,
         p_num_ar376         LIKE aviso_rec.num_aviso_rec,
         p_ind_sal           SMALLINT,
         p_entrou            SMALLINT,
         p_entrou_pedido     CHAR(01),
         p_nfe_vendas        SMALLINT,
         p_ies_oc            LIKE estoque_operac.ies_oc,
         p_ar_os             SMALLINT,
         p_ies_aguard_nfe    LIKE nf_sup.ies_nf_aguard_nfe,
         p_argumento         LIKE aviso_rec.ies_contabil,
         p_item_fornec       RECORD LIKE item_fornec.*,
         p_item1             RECORD LIKE item.*,
         p_clientes          RECORD LIKE clientes.*,
         p_par_diverg_rec    RECORD LIKE par_diverg_rec.*,
         p_ar_os_esp         RECORD LIKE ar_os_esp.*,
         p_dif_aceite        LIKE ordem_sup.pre_unit_oc,
         p_somatorio_dif     LIKE ordem_sup.pre_unit_oc,
         p_cod_uni_feder_f   LIKE fornecedor.cod_uni_feder,
         p_cod_unid_feder    LIKE cidades.cod_uni_feder,
         p_cod_pais          LIKE uni_feder.cod_pais,
         p_val_base          LIKE aviso_rec.val_base_c_frete_d,
         p_aviso_rec_compl   RECORD
                               cod_empresa          LIKE aviso_rec_compl.cod_empresa,
                               num_aviso_rec        LIKE aviso_rec_compl.num_aviso_rec,
                               cod_transpor         LIKE aviso_rec_compl.cod_transpor,
                               den_transpor         LIKE aviso_rec_compl.den_transpor,
                               num_placa_veic       LIKE aviso_rec_compl.num_placa_veic,
                               num_di               LIKE aviso_rec_compl.num_di,
                               ies_incl_import      LIKE aviso_rec_compl.ies_incl_import,
                               num_lote_pat         LIKE aviso_rec_compl.num_lote_pat,
                               cod_operacao         LIKE aviso_rec_compl.cod_operacao,
                               cod_empresa_orig     LIKE aviso_rec_compl.cod_empresa_orig,
                               cod_moeda_forn       LIKE aviso_rec_compl.cod_moeda_forn,
                               num_embarque         LIKE aviso_rec_compl.num_embarque,
                               ies_situacao         LIKE aviso_rec_compl.ies_situacao,
                               nom_usuario          LIKE aviso_rec_compl.nom_usuario,
                               dat_proces           LIKE aviso_rec_compl.dat_proces,
                               hor_operac           LIKE aviso_rec_compl.hor_operac,
                               cod_fiscal_compl     LIKE aviso_rec_compl.cod_fiscal_compl,
                               filial               DECIMAL(10,0)
                         END RECORD,
         p_sequencia         LIKE aviso_rec.num_seq,
         p_cod_fornec144     LIKE fornecedor.cod_fornecedor,
         p_ind5              SMALLINT,
         p_cod_pais_emp      LIKE uni_feder.cod_pais,
         p_status            SMALLINT,
         p_ies_obj_entrada_fisc LIKE cod_fiscal_sup.ies_obj_entrada,
         p_cod_item_oc       LIKE item.cod_item,
         p_num_nf            LIKE nf_sup.num_nf,
         p_cancel            INTEGER,
         p_ies_pagamento     LIKE cond_pgto_cap.ies_pagamento,
         p_msg_qtd           CHAR(01),
         p_ies_cons          SMALLINT,
         p_cod_ret_iss       DECIMAL(03,0),
         p_cod_ret_inss      DECIMAL(03,0),
         p_cod_ret_inss_rur  DECIMAL(03,0),
         p_count_estrut      SMALLINT,
         p_val_cotacao       LIKE cotacao.val_cotacao,
         p_ies_tip_frete     LIKE modo_embarque.ies_tip_frete,
         p_sup449_cap        SMALLINT,
         p_sup449_mes        SMALLINT,
         p_pedidos           CHAR(4800),
         p_pedidos_p1        CHAR(500),
         p_pedidos_p2        CHAR(500),
         p_pedidos_p3        CHAR(200),
         p_pedidos_p4        CHAR(500),
         p_pedidos_p5        CHAR(500),
         p_pedidos_p6        CHAR(200),
         p_pedidos_p7        CHAR(500),
         p_pedidos_p8        CHAR(500),
         p_pedidos_p9        CHAR(200),
         p_pedidos_p10       CHAR(500),
         p_pedidos_p11       CHAR(500),
         p_pedidos_p12       CHAR(200),
         p_inclu_item        CHAR(01),
         p_val_tot_liq       DECIMAL(17,2),
         p_val_tot_liq_ant   DECIMAL(17,2),
         p_ordens            CHAR(7200),
         p_ordens_p1         CHAR(500),
         p_ordens_p2         CHAR(500),
         p_ordens_p3         CHAR(500),
         p_ordens_p4         CHAR(300),
         p_ordens_p5         CHAR(500),
         p_ordens_p6         CHAR(500),
         p_ordens_p7         CHAR(500),
         p_ordens_p8         CHAR(300),
         p_ordens_p9         CHAR(500),
         p_ordens_p10        CHAR(500),
         p_ordens_p11        CHAR(500),
         p_ordens_p12        CHAR(300),
         p_ordens_p13        CHAR(500),
         p_ordens_p14        CHAR(500),
         p_ordens_p15        CHAR(500),
         p_ordens_p16        CHAR(300),
         p_prog_ordem        CHAR(2400),
         p_prog_ordem1       CHAR(300),
         p_prog_ordem2       CHAR(300),
         p_prog_ordem3       CHAR(300),
         p_prog_ordem4       CHAR(300),
         p_prog_ordem5       CHAR(300),
         p_prog_ordem6       CHAR(300),
         p_prog_ordem7       CHAR(300),
         p_prog_ordem8       CHAR(300),
         p_qtd_entreg        CHAR(10400),
         p_qtd_entreg1       CHAR(500),
         p_qtd_entreg2       CHAR(500),
         p_qtd_entreg3       CHAR(500),
         p_qtd_entreg4       CHAR(500),
         p_qtd_entreg5       CHAR(500),
         p_qtd_entreg6       CHAR(100),
         p_qtd_entreg7       CHAR(500),
         p_qtd_entreg8       CHAR(500),
         p_qtd_entreg9       CHAR(500),
         p_qtd_entreg10      CHAR(500),
         p_qtd_entreg11      CHAR(500),
         p_qtd_entreg12      CHAR(100),
         p_qtd_entreg13      CHAR(500),
         p_qtd_entreg14      CHAR(500),
         p_qtd_entreg15      CHAR(500),
         p_qtd_entreg16      CHAR(500),
         p_qtd_entreg17      CHAR(500),
         p_qtd_entreg18      CHAR(100),
         p_qtd_entreg19      CHAR(500),
         p_qtd_entreg20      CHAR(500),
         p_qtd_entreg21      CHAR(500),
         p_qtd_entreg22      CHAR(500),
         p_qtd_entreg23      CHAR(500),
         p_qtd_entreg24      CHAR(100),
         p_modifica_qtd      CHAR(01),
         p_retorno_3760      SMALLINT,
         p_houve_erro        SMALLINT,
         g_cod_forn_sup3850  LIKE fornecedor.cod_fornecedor,
         p_ies_interf_cre    CHAR(01),
         p_entra_array       CHAR(01),
         p_saldo_frete       LIKE frete_sup.val_frete,
         p_saldo_icms        LIKE frete_sup.val_tot_icms_frt_d,
         p_saldo_icms_c      LIKE frete_sup.val_tot_icms_frt_d,
         p_saldo_frete_ant   LIKE frete_sup.val_frete,
         p_saldo_icms_ant    LIKE frete_sup.val_tot_icms_frt_d,
         p_entra_tot         CHAR(01),
         p_pedido_sele       CHAR(4800),
         p_pedido_sele1      CHAR(500),
         p_pedido_sele2      CHAR(500),
         p_pedido_sele3      CHAR(200),
         p_pedido_sele4      CHAR(500),
         p_pedido_sele5      CHAR(500),
         p_pedido_sele6      CHAR(200),
         p_pedido_sele7      CHAR(500),
         p_pedido_sele8      CHAR(500),
         p_pedido_sele9      CHAR(200),
         p_pedido_sele10     CHAR(500),
         p_pedido_sele11     CHAR(500),
         p_pedido_sele12     CHAR(200),
         p_ordem_sele        CHAR(7200),
         p_ordem_sele1       CHAR(500),
         p_ordem_sele2       CHAR(500),
         p_ordem_sele3       CHAR(500),
         p_ordem_sele4       CHAR(300),
         p_ordem_sele5       CHAR(500),
         p_ordem_sele6       CHAR(500),
         p_ordem_sele7       CHAR(500),
         p_ordem_sele8       CHAR(300),
         p_ordem_sele9       CHAR(500),
         p_ordem_sele10      CHAR(500),
         p_ordem_sele11      CHAR(500),
         p_ordem_sele12      CHAR(300),
         p_ordem_sele13      CHAR(500),
         p_ordem_sele14      CHAR(500),
         p_ordem_sele15      CHAR(500),
         p_ordem_sele16      CHAR(300),
         p_declarad_sele     CHAR(240),
         p_ies_reservou      CHAR(01),
         p_ind3              SMALLINT,
         p_ind9              SMALLINT,
         p_num_prog_cham     SMALLINT,
         p_tot_itens         SMALLINT,
         p_cod_item_pop      LIKE item.cod_item,
         p_num_conhec        LIKE frete_sup.num_conhec,
         p_ser_conhec        LIKE nf_sup.ser_conhec,
         p_ssr_conhec        LIKE nf_sup.ssr_conhec,
         p_cod_transpor      LIKE nf_sup.cod_transpor,
         p_fornec_incl_item  LIKE pedido_sup.cod_fornecedor,
         p_tip_recebimento   CHAR(01),
         p_ies_informou_ped  CHAR(01),
         p_qtd_array         LIKE aviso_rec.qtd_declarad_nf,
         p_val_array         LIKE aviso_rec.val_liquido_item,
         p_ind_tela          SMALLINT,
         p_nom_resp_aceite_er LIKE nf_sup.nom_resp_aceite_er,
         p_diferenca_f       LIKE estoque_trans.cus_tot_movto_p,
         p_diferenca_p       LIKE estoque_trans.cus_tot_movto_p,
         p_frete_sup         RECORD LIKE  frete_sup.*,
         p_frete_sup_compl   RECORD LIKE  frete_sup_compl.*,
         p_plano_contas      RECORD LIKE  plano_contas.*,
         p_des_pendencia     LIKE  frete_sup_erro.des_pendencia,
         p_it_prg_entr       CHAR(297),
         p_it_prg_entr_reser CHAR(500),
         p_item_sup          RECORD LIKE item_sup.*,
         p_item                 RECORD LIKE item.*,
         p_par_estoque       RECORD LIKE par_estoque.*,
         p_parametros         CHAR(01),
         p_ind2              SMALLINT,
         p_ies_contrib_ipi   CHAR(01),
         p_soma_reserva2     LIKE aviso_rec.qtd_declarad_nf,
         p_soma_reserva3     LIKE aviso_rec.qtd_declarad_nf,
         p_val_soma_reserva2 LIKE aviso_rec.val_liquido_item,
         p_val_soma_reserva3 LIKE aviso_rec.val_liquido_item,
         p_prx_seq           LIKE aviso_rec.num_seq,
         p_num_seq           SMALLINT,
         p_cod_fiscal_forma  CHAR(04),
         p_qtd_declarad_nf   LIKE aviso_rec.qtd_declarad_nf,
         p_val_liquido_item  LIKE aviso_rec.val_liquido_item,
         p_primeira_vez      SMALLINT,
         comando3            CHAR(200),
         p_conta_lanc        SMALLINT

  DEFINE p_ies_achou_itsup   SMALLINT,
         p_ies_nf_transf     SMALLINT,
         gr_uni_feder        RECORD LIKE uni_feder.*,
         p_ies_pc_ant_fornec CHAR(01),
         p_cod_moeda_ped     LIKE pedido_sup.cod_moeda,
         p_ies_indexacao     LIKE par_sup_pad.par_ies,
         p_ies_item_cont_aut CHAR(01),
         p_ies_item_insp_aut CHAR(01),
         p_cod_seg_merc      DECIMAL(2,0),
         p_cod_cla_uso       DECIMAL(2,0),
         p_item_parametro    RECORD LIKE item_parametro.*,
         p_ies_cont_insp_aut CHAR(01),
         p_oper_trans_unid   LIKE estoque_operac.cod_operacao,
         p_cod_emp_transf    LIKE empresa.cod_empresa,
         p_ies_obt_inf_com   CHAR(01),
         g_ies_nf_permuta    SMALLINT,
         g_nat_oper_permuta  LIKE nat_operacao.cod_nat_oper,
         g_operac_permuta    LIKE estoque_operac.cod_operacao,
         g_cod_emp_permuta   LIKE empresa.cod_empresa,
         p_cond_pgto_cap     RECORD LIKE cond_pgto_cap.*,
         p_uni_feder         RECORD LIKE uni_feder.*

  DEFINE p_array_ped_itens  ARRAY[999] OF RECORD
                            num_oc           LIKE ordem_sup.num_oc,
                            num_pedido       LIKE ordem_sup.num_pedido,
                            num_prog_entrega LIKE prog_ordem_sup.num_prog_entrega,
                            ies_item_estoq   LIKE ordem_sup.ies_item_estoq,
                            cod_item         LIKE ordem_sup.cod_item,
                            den_item         CHAR(50),
                            cod_unid_med     LIKE ordem_sup.cod_unid_med,
                            pct_ipi          LIKE ordem_sup.pct_ipi,
                            pre_unit_oc      LIKE ordem_sup.pre_unit_oc,
                            pct_aceite_dif   LIKE ordem_sup.pct_aceite_dif,
                            ies_liquida_oc   LIKE ordem_sup.ies_liquida_oc,
                            qtd_entregue     LIKE prog_ordem_sup.qtd_recebida
                            END RECORD
  DEFINE p_array_ped_aux    ARRAY[999] OF RECORD
                            cod_fornecedor   LIKE pedido_sup.cod_fornecedor,
                            qtd_entregue     LIKE prog_ordem_sup.qtd_recebida
                            END RECORD
  DEFINE g_num_aviso_rec     LIKE ar_x_nf_pend.num_aviso_rec,
         g_cod_fornecedor    LIKE ar_x_nf_pend.cod_fornecedor,
         g_num_nf            LIKE ar_x_nf_pend.num_nf,
         g_ser_nf            LIKE ar_x_nf_pend.ser_nf,
         g_ssr_nf            LIKE ar_x_nf_pend.ssr_nf,
         g_cod_item          LIKE ar_x_nf_pend.cod_item,
         g_num_seq           LIKE ar_x_nf_pend.num_seq

  DEFINE p_cod_oper_ant   LIKE aviso_rec_compl.cod_operacao

  DEFINE p_nfe_import          SMALLINT,
         p_nfm_import          SMALLINT,
         g_prim_rateio         SMALLINT,
         g_proc_ini_os163407   DECIMAL(6,0),
         p_processo_imp        RECORD LIKE processo_imp.*,
         p_proc_item           RECORD LIKE proc_item.*,
         g_val_desp_tot        DECIMAL(18,2),
         g_icms_total_nf       CHAR(01),
         g_dat_icms_tot_nf     DATE

  DEFINE p_aviso_rec         RECORD LIKE aviso_rec.*,
         p_nf_sup            RECORD LIKE nf_sup.*,
         p_par_sup           RECORD LIKE par_sup.*,
         p_par_sup_compl     RECORD LIKE par_sup_compl.*,
         p_par_sup_compl_1   RECORD LIKE par_sup_compl_1.*,
         p_ar_ped            RECORD LIKE ar_ped.*,
         p_ar_diverg         RECORD LIKE ar_diverg.*,
         p_prog_ordem_sup    RECORD LIKE prog_ordem_sup.*,
         p_empresa           RECORD LIKE empresa.*,
         p_ordem_sup         RECORD LIKE ordem_sup.*,
         p_par_con           RECORD LIKE par_con.*,
         p_ies_contab_aen    LIKE par_con.ies_contab_aen,
         p_cod_fiscal_item   LIKE aviso_rec.cod_fiscal_item,
         p_pre_unit_nf       LIKE aviso_rec.pre_unit_nf,
         p_prim_digito       CHAR(01),
         p_ult_digitos       CHAR(03),
         p_cod_uni_feder     LIKE fornecedor.cod_uni_feder,
         p_dest_aviso_rec    RECORD LIKE dest_aviso_rec.*,
         p_fat_conver_unid   LIKE ordem_sup.fat_conver_unid,
         p_fator_unid        LIKE fat_conver.fat_conver_unid,
         p_num_conta_sal     LIKE plano_contas.num_conta,
         p_fornecedor        RECORD LIKE fornecedor.*,
         p_maior_data        DATE,
         p_menor_data        DATE,
         p_pedido_sup        RECORD LIKE pedido_sup.*,
         p_ies_tem_inspecao  LIKE item.ies_tem_inspecao,
         p_dados_tela        RECORD
                                cod_empresa       LIKE aviso_rec.cod_empresa,
                                cod_empresa_estab LIKE nf_sup.cod_empresa_estab,
                                filial            DECIMAL(10),
                                num_aviso_rec     LIKE aviso_rec.num_aviso_rec,
                                cod_fornecedor    LIKE fornecedor.cod_fornecedor,
                                num_nf            LIKE nf_sup.num_nf,
                                ser_nf            LIKE nf_sup.ser_nf,
                                ssr_nf            LIKE nf_sup.ssr_nf,
                                ies_especie_nf    LIKE nf_sup.ies_especie_nf,
                                ies_nf_aguard_nfe LIKE nf_sup.ies_nf_aguard_nfe,
                                cod_emp_benef     LIKE empresa.cod_empresa,
                                cod_operac_estoq  LIKE estoque_operac.cod_operacao,
                                cod_operacao      CHAR(05),
                                cod_fiscal_compl  INTEGER,
                                dat_emis_nf       LIKE nf_sup.dat_emis_nf,
                                dat_entrada_nf    LIKE nf_sup.dat_entrada_nf,
                                cnd_pgto_nf       LIKE nf_sup.cnd_pgto_nf,
                                cod_mod_embar     LIKE nf_sup.cod_mod_embar,
                                ies_impostos      CHAR(01)
                             END RECORD,
         p_codigos      RECORD
                          cod_operac_estoq  LIKE estoque_operac.cod_operacao,
                          cod_operacao      CHAR(05),
                          cod_fiscal_compl  INTEGER,
                          cod_mod_embar     LIKE nf_sup.cod_mod_embar
                        END RECORD,
         p_dados_tela_f RECORD
                    val_ipi_nf          DECIMAL(17,2),
                    val_tot_icms_nf_d   DECIMAL(17,2),
                    val_tot_nf_d        DECIMAL(17,2) ,
                    ies_desc_acres      CHAR(01)
             END RECORD,
         p_dados_telar  RECORD
                          cod_empresa       LIKE aviso_rec.cod_empresa,
                          cod_empresa_estab LIKE nf_sup.cod_empresa_estab,
                          filial            DECIMAL(10),
                          num_aviso_rec     LIKE aviso_rec.num_aviso_rec,
                          cod_fornecedor    LIKE fornecedor.cod_fornecedor,
                          num_nf            LIKE nf_sup.num_nf,
                          ser_nf            LIKE nf_sup.ser_nf,
                          ssr_nf            LIKE nf_sup.ssr_nf,
                          ies_especie_nf    LIKE nf_sup.ies_especie_nf,
                          ies_nf_aguard_nfe LIKE nf_sup.ies_nf_aguard_nfe,
                          cod_emp_benef     LIKE empresa.cod_empresa,
                          cod_operac_estoq  LIKE estoque_operac.cod_operacao,
                          cod_operacao      CHAR(05),
                          cod_fiscal_compl  INTEGER,
                          dat_emis_nf       LIKE nf_sup.dat_emis_nf,
                          dat_entrada_nf    LIKE nf_sup.dat_entrada_nf,
                          cnd_pgto_nf       LIKE nf_sup.cnd_pgto_nf,
                          cod_mod_embar     LIKE nf_sup.cod_mod_embar,
                          ies_impostos      CHAR(01)
                       END RECORD,
         p_dados_telar_f RECORD
                    ipi              DECIMAL(17,2),
                    icms             DECIMAL(17,2),
                    tot_nf           DECIMAL(17,2)
                     END RECORD,
         p_formonly    RECORD
                          raz_social         LIKE fornecedor.raz_social,
                          des_cnd_pgto       LIKE cond_pgto_cap.des_cnd_pgto,
                          tex_tip_frete      CHAR(15)
                       END RECORD,
         p_formonlyr   RECORD
                          raz_social         LIKE fornecedor.raz_social,
                          des_cnd_pgto       LIKE cond_pgto_cap.des_cnd_pgto,
                          tex_tip_frete      CHAR(15)
                       END RECORD,

         p_funcao_menu       CHAR(30),
         p_cod_item          LIKE item_sup.cod_item,
         p_dif_aceita        DECIMAL(17,2),
         p_val_dif_aceita    DECIMAL(17,2),
         p_cont_aut_terc     SMALLINT

   DEFINE p_array_compl ARRAY[999] OF
         RECORD
            ies_item_estoq      LIKE aviso_rec.ies_item_estoq       ,
            ies_liberacao_insp  LIKE aviso_rec.ies_liberacao_insp   ,
            ies_controle_lote   LIKE aviso_rec.ies_controle_lote    ,
            cod_local_estoq     LIKE item.cod_local_estoq           ,
            cod_cla_fisc        LIKE item.cod_cla_fisc              ,
            num_pedido          LIKE pedido_sup.num_pedido          ,
            num_oc              LIKE ordem_sup.num_oc               ,
            num_prog_entrega    LIKE prog_ordem_sup.num_prog_entrega,
            ies_diverg_preco    LIKE ar_diverg.ies_tip_diverg       ,
            ies_bloqueada       CHAR(01)                            ,
            qtd_declarad_nf     LIKE aviso_rec.qtd_declarad_nf      ,
            ar_com_pc           CHAR(01)                            ,
            move_estoque        CHAR(01)                            ,
            cod_lin_prod        LIKE item.cod_lin_prod              ,
            cod_lin_recei       LIKE item.cod_lin_recei             ,
            cod_seg_merc        LIKE item.cod_seg_merc              ,
            cod_cla_uso         LIKE item.cod_cla_uso               ,
            qtd_reserva_prog    LIKE ar_ped.qtd_reservada           ,
            alterou_val_liquido SMALLINT                            ,
            pct_ipi_tabela      LIKE aviso_rec.pct_ipi_tabela       ,
            pct_aceite_dif      LIKE ordem_sup.pct_aceite_dif       ,
            tot_reserv_dif      LIKE ordem_sup.qtd_solic            ,
            ies_liquida_oc      LIKE ordem_sup.ies_liquida_oc       ,
            pre_unit_nf         LIKE aviso_rec.pre_unit_nf          ,
            val_reserva_prog    LIKE aviso_rec.val_liquido_item     ,
            ies_tip_item        LIKE item.ies_tip_item              ,
            val_ii              LIKE proc_item.val_ii               ,
            val_desp_imp        DECIMAL(15,2)
         END RECORD

      DEFINE p_array         ARRAY[999] OF RECORD
                        seq                CHAR(03),
                        cod_item           LIKE item.cod_item,
                        qtd_declarad_nf    LIKE aviso_rec.qtd_declarad_nf,
                        cod_unid_med_nf    LIKE aviso_rec.cod_unid_med_nf,
                        pre_unit_nf        LIKE aviso_rec.pre_unit_nf,
                        val_liquido_item   LIKE aviso_rec.val_liquido_item,
                        den_item           CHAR(50),
                        cod_cla_fisc_nf    LIKE aviso_rec.cod_cla_fisc_nf,
                        pct_ipi            LIKE aviso_rec.pct_ipi_declarad
                             END RECORD,
         p_ind, p_ind1       SMALLINT

   #----------------------------------#
   # Modificação realizada para o WMS #
   #----------------------------------#
   DEFINE p_array_wms     ARRAY[999] OF RECORD
                             seq                CHAR(03),
                             cod_item           LIKE wms_item_complemento.item_deposit,
                             qtd_declarad_nf    LIKE aviso_rec.qtd_declarad_nf,
                             cod_unid_med_nf    LIKE aviso_rec.cod_unid_med_nf,
                             pre_unit_nf        LIKE aviso_rec.pre_unit_nf,
                             val_liquido_item   LIKE aviso_rec.val_liquido_item,
                             den_item           CHAR(50),
                             cod_cla_fisc_nf    LIKE aviso_rec.cod_cla_fisc_nf,
                             pct_ipi            LIKE aviso_rec.pct_ipi_declarad
                          END RECORD
  #-----------------------------------#

  DEFINE ga_nf_item_fiscal   ARRAY[999] OF RECORD
                             val_base_ipi   LIKE nf_item_fiscal.val_base_ipi,
                             val_ipi        LIKE nf_item_fiscal.val_ipi,
                             val_base_icms  LIKE nf_item_fiscal.val_base_icm
                             END RECORD

  DEFINE p_array_it_prg_entr  ARRAY[999,50] OF
         RECORD
            num_prog_entrega   LIKE prog_ordem_sup.num_prog_entrega,
            qtd_reservada      LIKE prog_ordem_sup.qtd_recebida    ,
            qtd_solic          LIKE prog_ordem_sup.qtd_solic       ,
            val_reservado      LIKE prog_ordem_sup_com.val_receb   ,
            val_solic          LIKE prog_ordem_sup_com.val_solic
         END RECORD

  DEFINE p_nota  RECORD
                    cod_empresa         LIKE nf_sup.cod_empresa,
                    num_aviso_rec       LIKE nf_sup.num_aviso_rec,
                    ies_nf_com_erro     LIKE nf_sup.ies_nf_com_erro,
                    nom_resp_aceite_er  LIKE nf_sup.nom_resp_aceite_er,
                    ies_incl_cap        LIKE nf_sup.ies_incl_cap,
                    dat_entrada_nf      LIKE nf_sup.dat_entrada_nf,
                    dat_emis_nf         LIKE nf_sup.dat_emis_nf,
                    cod_fornecedor      LIKE nf_sup.cod_fornecedor,
                    num_nf              LIKE nf_sup.num_nf,
                    ser_nf              LIKE nf_sup.ser_nf,
                    ssr_nf              LIKE nf_sup.ssr_nf,
                    ies_especie_nf      LIKE nf_sup.ies_especie_nf,
                    ies_nf_aguard_nfe   LIKE nf_sup.ies_nf_aguard_nfe
                 END RECORD

  DEFINE p_array_pedidos     ARRAY[999] OF RECORD
                             num_pedido       LIKE pedido_sup.num_pedido,
                             num_oc           LIKE ordem_sup.num_oc,
                             num_prog_entrega LIKE ar_ped.num_prog_entrega,
                             num_pc_forn      LIKE prog_ordem_sup.num_pedido_fornec
                             END RECORD

  DEFINE p_sub, p_ind8         SMALLINT,
         p_cod_empresa_arg     LIKE empresa.cod_empresa,
         p_num_aviso_rec_arg   LIKE aviso_rec.num_aviso_rec,
         p_cons_arg            SMALLINT

  DEFINE p_cod_ret_imp         LIKE nf_sup.cod_imp_renda,
         p_ies_fis_jur         CHAR(01)
  DEFINE p_cotacao_preco       RECORD LIKE cotacao_preco.*
  DEFINE p_versao              CHAR(018)

  DEFINE p_ies_imp_renda       CHAR(01)
  DEFINE p_ies_imp_ret_inss    CHAR(01)
  DEFINE p_perc_ret_inss       DECIMAL(5,3)
  DEFINE p_base_calc_ret_inss  DECIMAL(17,2)
  DEFINE p_ies_imp_inss_rur    CHAR(01)
  DEFINE p_perc_ret_inss_rur   DECIMAL(5,3)
  DEFINE p_base_calc_inss_rur  DECIMAL(17,2)
  DEFINE p_motivo_isencao      CHAR(200)

  DEFINE p_array_volta      ARRAY[999] OF
   RECORD
        cod_fornecedor     LIKE pedido_sup.cod_fornecedor,
        num_pedido         LIKE pedido_sup.num_pedido,
        num_oc             LIKE ordem_sup.num_oc,
        num_prog_entrega   LIKE prog_ordem_sup.num_prog_entrega,
        cod_item           LIKE ordem_sup.cod_item             ,
        den_item           CHAR(32)                            ,
        cod_unid_med       LIKE ordem_sup.cod_unid_med         ,
        qtd_entregue       LIKE prog_ordem_sup.qtd_recebida,
        num_ped_forn       LIKE prog_ordem_sup.num_pedido_fornec
   END RECORD

  DEFINE p_array_dev_trans     ARRAY[999] OF RECORD
                        val_desc_item      LIKE aviso_rec.val_desc_item,
                        ies_tip_incid_ipi  LIKE aviso_rec.ies_tip_incid_ipi,
                        ies_incid_icms_ite LIKE aviso_rec.ies_incid_icms_ite,
                        ies_bi_tributacao  CHAR(01)
                             END RECORD
  DEFINE p_array_imp        ARRAY[999] OF RECORD
                            quantidade       LIKE aviso_rec.qtd_declarad_nf,
                            val_ii_tot       LIKE proc_item.val_ii,
                            val_ii           LIKE proc_item.val_ii,
                            val_desp_imp_tot DECIMAL(15,2),
                            val_desp_imp     DECIMAL(15,2),
                            val_ipi_tot      LIKE proc_item.val_ipi,
                            val_ipi          LIKE proc_item.val_ipi,
                            val_icms_tot     LIKE proc_item.val_icms,
                            val_icms         LIKE proc_item.val_icms,
                            val_da_icms      DECIMAL(15,2),
                            cod_cla_fisc     LIKE proc_item.cod_ncm
                            END RECORD

  DEFINE p_ar_proc_imp      RECORD LIKE aviso_rec_proc_imp.*
  DEFINE g_ies_wis_instalado CHAR(01),
         g_ies_tex_inst      CHAR(01)
  DEFINE g_ies_wms_instalado CHAR(01)
  DEFINE g_ies_transf_benef  SMALLINT,
         g_ies_retorno_ind   SMALLINT,
         g_ret_sem_ind       SMALLINT,
         g_baixou_terceiro   SMALLINT,
         g_passou_skip_lote  SMALLINT

  DEFINE g_ies_tip_controle LIKE nat_operacao.ies_tip_controle,
         g_pergunta         CHAR(01),
         g_uf_trans_nfdr    LIKE par_sup_pad.par_ies,
         g_ser_mark         SMALLINT

 DEFINE ga_man_moviment    ARRAY[100] OF RECORD
                                          serie            LIKE man_moviment_serie.serie,
                                          item             LIKE man_moviment_serie.item,
                                          num_docum        LIKE man_moviment_serie.num_docum,
                                          tip_docum        LIKE man_moviment_serie.tip_docum,
                                          status_ordem     LIKE man_moviment_serie.status_ordem,
                                          loc_est_debitad  LIKE man_moviment_serie.loc_est_debitad,
                                          programa         LIKE man_moviment_serie.programa
                                        END RECORD

 DEFINE g_ind_tela         SMALLINT,
        g_item_branco      SMALLINT,
        p_cod_emp_atual    LIKE empresa.cod_empresa,
        g_ind_nfe          SMALLINT

 DEFINE g_gerar_cred_impostos_nfm_import CHAR(01)

 DEFINE p_array_compl1 ARRAY[999] OF
         RECORD
            cod_tip_despesa LIKE aviso_rec.cod_tip_despesa
         END RECORD

  DEFINE g_modifica_nf_transito SMALLINT,
         g_nao_inclui           SMALLINT

  DEFINE g_den_item             LIKE item.den_item

###variaveis abaixo são utilizadas no sup3762, sup1561 e também no sup3760 (definido como variavel global)
 DEFINE g_devol_nf_parcial        SMALLINT,
        g_devol_consig_total      SMALLINT,
        g_array_devolucao         SMALLINT,
        g_devol_venda_total       SMALLINT,
        g_itens_nf_devol_parcial  CHAR(01),
        g_contagem_autom_devol    CHAR(01),
        g_tipo_sgbd               CHAR(003),
        g_ies_excl_end_zero       CHAR(01)
 END GLOBALS
