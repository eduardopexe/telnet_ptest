#!/bin/bash

#/opt/IBM/netcool/core/precision/perl/bin/perl /labperl/tim_teste/teste_telnet.pl &

/opt/IBM/netcool/core/precision/perl/bin/perl /tim_teste/telnet/teste_telnet.pl /tim_teste/lists/telnet/tft_00.txt tft00 &
sleep 1;
/opt/IBM/netcool/core/precision/perl/bin/perl /tim_teste/telnet/teste_telnet.pl /tim_teste/lists/telnet/tft_01.txt tft01 &
sleep 1;
/opt/IBM/netcool/core/precision/perl/bin/perl /tim_teste/telnet/teste_telnet.pl /tim_teste/lists/telnet/tft_02.txt tft02 &
sleep 1;
/opt/IBM/netcool/core/precision/perl/bin/perl /tim_teste/telnet/teste_telnet.pl /tim_teste/lists/telnet/tft_03.txt tft03 &
sleep 1;
/opt/IBM/netcool/core/precision/perl/bin/perl /tim_teste/telnet/teste_telnet.pl /tim_teste/lists/telnet/tft_04.txt tft04 &

exit
