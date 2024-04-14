#!/bin/bash

#####################################################
# Author	: Eduardo Pexe [IcaroTech]
# Date		: Jun 03, 2022
# Version	: 1.0
# Descricao     : Teste de portas telnet
#####################################################
#$1 lista com ips e portas para teste telnet
#$2 numero de testes simultaneos [instancias]



dirperl="/opt/IBM/netcool/core/precision/perl/bin/perl";
dirscript="/tim_teste/telnet/teste_telnet.pl";
 
lista="/tim_teste/lists/"$1;

numlinhas=$(wc -l $lista | cut -d" " -f1);

echo " --- "$numlinhas"# \n";

        if [ -z "$2" ]; then

                dv=$((5));

        else

                dv=$2;

        fi

	dvz=$((numlinhas%dv));

	if [ "$dvz" -gt "0" ]; then

		partes=$(bc <<< "scale=0;($numlinhas/$dv)");
		numlines=$(($partes+1));
		echo "--->>>>"$partes"-----!-"$numlines"\n";

        else

		partes=$(bc <<< "scale=0;($numlinhas/$dv)");
		numlines=$(($partes+0));
#		echo "--->>>>#"$partes"-----!#-"$numlines"\n";
        fi	

############divide arquivo

        dir_destino="/tim_teste/lists/telnet/tfx_"

	split -d -l $numlines $lista $dir_destino --additional-suffix=".txt"

echo $lista" --- "$numlinhas" |||| "$numlines" dv: "$dv"\n";
        COUNT=0;

	while [ $COUNT -lt $dv ]; do

#        	echo $partes" ---- "$COUNT" ";

                if [ $COUNT -lt 10 ]; then

			sufix="0"$COUNT;

		else

			sufix=$COUNT;

                fi

                arqv_split=$dir_destino$sufix".txt"
                #echo $arqv_split;

                echo $dirperl $dirscript $arqv_split "tfx_"$sufix

                $dirperl $dirscript $arqv_split "tfx_"$sufix & 
                COUNT=$(($COUNT+1));
                #partes=$(($COUNT-1));   
        done

exit
