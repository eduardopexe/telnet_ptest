#!/usr/bin/perl

#use strict;
#use warnings;

$arquivo_ping=@ARGV[0];

if (!$arquivo_ping){

	$arquivo_ping="/telnet_ptest/results/fping/1653427884_def_24_05_2022_res.txt";

}

#abre arquivo de lista para testes
open(lhx,"$arquivo_ping");
@dth=<lhx>;
close(lhx);

%hash_ips=();

foreach $itn (@dth){

	$itn=~s/\n//g;
	$itn=~s/\r//g;
	#1653422656;24/05/2022 17:04:16;ok;10.221.25.5,3,3,0,19.1,19.9,20.7;
	@dtx=split(/;/,$itn);
	
	$t=$dtx[0];
	$dtlog=$dtx[1];
	$status=$dtx[2];
	$ip=$dtx[3];
	$ipsent=$dtx[4];
	$iprcv=$dtx[5];
	$iploss=$dtx[6];	
    $iplmin=$dtx[7];
    $iplavg=$dtx[8];
    $iplmax=$dtx[9];
print "$ip $status \n";
	
	$hash_ips{$ip}{"status"}=$status;
	$hash_ips{$ip}{"dt"}=$dtlog;	
	
}

#########################################################
$arquivo_telnet=@ARGV[1];

if (!$arquivo_telnet){

	$arquivo_telnet="/telnet_ptest/results/resultado_teste_telnet.txt";

}

#abre arquivo de lista para testes
open(lhz,"$arquivo_telnet");
@dtz=<lhz>;
close(lhz);

open(resx,">res_telnet_e_ping.txt");

print resx "iptelnet;porta;label;rede_origem;status_telnet;status_ping;\n";

foreach $it (@dtz){


	$it=~s/\n//g;
	$it=~s/\r//g;	

	@dtx=split(/;/,$it);
	#versao1
	#10.221.25.23;3389;Tuffin 37308;10.221.25.0/24;ok;
	
	$iptel=$dtx[0];
	$porta=$dtx[1];
	$label=$dtx[2];
	$rede_origem=$dtx[3];
	$status_telnet=$dtx[4];
	$status_ping=$hash_ips{$iptel}{"status"};
	
    print resx "$iptel;$porta;$label;$rede_origem;$status_telnet;$status_ping;\n";

}

close(resx);

exit

