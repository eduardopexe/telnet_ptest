#!/usr/bin/perl

#use strict;
#use warnings;
use Expect;
use Data::Dumper;



open(lhx,"listaips0.txt");

@dth=<lhx>;

close(lhx);
open(lres,">lista_completa00.txt");
%hash_ips=();
foreach $item (@dth){

	$item=~s/\n//g;
    $item=~s/\r//g;

	@dti=split(/;/,$item);
	#hostname;ip;cliente;ambiente;username;password;protocolo;
	$ip=@dti[0];
	$porta=@dti[1];
	$nome_rede=@dti[2];
	
	if ($ip=~/\//){
	
	    print "nao testa rede $ip ";
		@ips=split(/\./,$ip);
		$dip=pop(@ips);
		
		$ipu="";
		
		foreach $lip1 (@ips){
		
			$ipu.=$lip1.".";
		}
		
		#$dip0=chomp($ipu);
		
		print "$ipu -> $ip;$porta;$nome_rede \n";
		
		$hash_ips{$ipu}{"porta"}="$porta";
		$hash_ips{$ipu}{"label"}="$nome_rede";
		$hash_ips{$ipu}{"rede"}="$ip";
		
	}
    else{
		print lres "$ip;$porta;$nome_rede;;\n";
	}
}

open(lhx2,"lista_redes.txt");

@dth2=<lhx2>;

close(lhx2);

foreach $itp (@dth2){

	$itp=~s/\n//g;
    $itp=~s/\r//g;
	$itp=~s/\s//g;
	
	@ips=split(/\./,$itp);
	
	$iprede=$ips[0].".".$ips[1].".".$ips[2].".";
	
	$ip=$itp;
	$porta=$hash_ips{$iprede}{"porta"};
	$rede=$hash_ips{$iprede}{"rede"};
	$nome_rede=$hash_ips{$iprede}{"label"};
	
	print  lres "$ip;$porta;$nome_rede;$rede;\n";
}



close(lres);
exit
