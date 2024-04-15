#Script para teste telnet de portas para multiplos endereços ips

#Modulos perl necessarios para instalção
Expect

#Para consultar o modulo instalado execute o comando:
cpan -l | grep Expect

#Para instalar :

perl -MCPAN -e shell
install Expect

#Arquivo de entrada: lista com ips e portas para teste:
# arquivo: /telnet_pteste/lists/lista_teste_telnet00.txt
#ips;portas;controle;origem;
#10.221.113.210/32;22,3389;Tuffin 37305;10.16.7.192/26,10.174.21.64/26;

#Geração de lista de ips/portas para teste:
#arquivo perl : 00_glist_telnet_tst.pl
#comando: 
perl /telnet_pteste/glist/00_glist_telnet_tst.pl

#lista origem padrao: /telnet_pteste/lists/lista_teste_telnet00.txt
#lista destino padrao: /telnet_pteste/lists/lista_completa00.txt
#para mudar arquivo origem: ARGV[0]
#para mudar destino : ARGV[1]
#exemplo1: perl /telnet_pteste/glist/00_glist_telnet_tst.pl
#arvivo origem exemplo 1: /telnet_pteste/lists/lista_teste_telnet00.txt
#arvivo destino exemplo 1: /telnet_pteste/lists/lista_completa00.txt
#exemplo2: perl /telnet_pteste/glist/00_glist_telnet_tst.pl /telnet_pteste/lists/lt_telnet.txt /telnet_pteste/lists/lt_to_test.txt
#arvivo origem exemplo 2: /telnet_pteste/lists/lt_telnet.txt
#arvivo destino exemplo 2: /telnet_pteste/lists/lt_to_test.txt
