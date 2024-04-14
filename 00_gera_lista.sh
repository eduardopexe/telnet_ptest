#!/bin/bash

#####################################################
# Author	: Eduardo Pexe [IcaroTech]
# Date		: Jun 03, 2022
# Version	: 1.0
# Descricao     : Gera arquivo lista teste portas telnet
#####################################################
#$1 filtro lista controle
#$2 arquivo destino filtro
#$numero de instancias

perl /tim_teste/glist/00_glist_telnet_tst.pl

#echo "cat ""/tim_teste/lists/lista_completa00.txt | grep '"$1"'" ">" "/tim_teste/lists/"$2;

comando="/tim_teste/lists/lista_completa00.txt";
com2="/tim_teste/lists/"$2;

cat $comando | grep $1 > $com2;

echo $comando " -- " $com2;

/tim_teste/01_telnet_start.sh $2 $3;

exit
