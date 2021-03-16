################################################################################
### atencao atencao atencao atencao atencao atencao atencao atencao atencao ###
###############################################################################
###                                                                         ###
### por motivos de tamanho deste arquivo fonte, os comandos de  selecao em  ###
### tabelas (select), que eram identicos em diversas partes do mesmo foram  ###
### unificados. para manter este principio, procure a seguinte string:      ###
###                      "busca_" + <nome da tabela>                        ###
### exemplo: para verificar se ja existe uma selecao que possa ser          ###
###         utilizada para a tabela ordem_sup, procure "busca_ordem_sup".   ###
###                                                                         ###
###############################################################################

#-------------------------------------------------------------------#
# sistema.: suprimentos                                             #
# programa: sup3760                                                 #
# modulos.: sup3760 log0010 log0030 log0040 log0050 log0060 sup0520 #
# objetivo: manutencao de notas fiscais                             #
# autor...: tatiane wiese                                           #
# data....: 18/11/1994                                              #
#                                                                   #
# ******************** a t e n c a o  ! ! ! ! ********************* #
# favor manter a identacao neste  programa (tres colunas),  para  o #
# melhor entendimento do programa nas manutencoes posteriores.      #
# ***************************************************************** #
#-------------------------------------------------------------------#

define m_msg                             char(200)

define m_num_nf_cap                      char(07),
m_informou_grade                  smallint

