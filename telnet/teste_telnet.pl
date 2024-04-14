#!/usr/bin/perl

#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
#
# Author  : Eduardo Pexe (Icaro Tech)
# Date	: Feb 23rd, 2022
# Version : 1.0
#
# This perl script execute a telnet test designed for tim network generated lists
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
#
# Modules used
#
#------------------------------------------------------------------
#use strict;
#use warnings;
use Expect;
use Data::Dumper;
use Time::Local;
use Cwd qw();

my $path = Cwd::cwd();

@pth=split(/\//,$path);
$dirlocal=pop(@pth);

$path_main="/tim_teste";


%hash_paths=();

#$hash_paths{"local"}=$path;
$hash_paths{"main"}=$path_main;
$hash_paths{"lists"}=$path_main."/lists";
$hash_paths{"results"}=$path_main."/results";
$hash_paths{"results_telnet"}=$path_main."/results/telnet";
$hash_paths{"logs_telnet"}=$path_main."/logs/telnet";
$hash_paths{"results_fping"}=$path_main."/results/fping";
$hash_paths{"logs_fping"}=$path_main."/logs/fping";
$hash_paths{"logs"}=$path_main."/logs";

sub get_data_log {

    my $formato=$_[0];
	
	
	my @months = qw( Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec );
	my @days = qw(Sun Mon Tue Wed Thu Fri Sat Sun);

	my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime();

	#$data_log=$mday."/".$mon."/".$year." ".$hour.":".$min;
	
	my $data_log;

	if ($formato){

		if ($formato eq 'data_hora'){
		
			$data_log = sprintf("%02d/%02d/%04d %02d:%02d:%02d", $mday,$mon+1, $year+1900, $hour, $min, $sec);
		}
		
		if ($formato eq 'data_hora_mysql'){
		
			$data_log = sprintf("%04d-%02d-%02d %02d:%02d:%02d", $year+1900,$mon+1, $mday , $hour, $min, $sec);

		}

		if ($formato eq 'data'){
		
			$data_log = sprintf("%02d/%02d/%04d", $mday,$mon+1, $year+1900, $hour, $min, $sec);
		}
		
	}
	else {

		$data_log = sprintf("%02d_%02d_%04d", $mday,$mon+1, $year+1900, $hour, $min, $sec);

	}
	
	return $data_log;
}

sub check_server {

	my $host=$_[0];
	#my $user=$_[1];
	#my $pass=$_[2];
	my $port=$_[1];
	my $timeout=$_[2];
	my $data;
	
	$exp= Expect->spawn("telnet $host $port");
	$exp->after();
	$exp->restart_timeout_upon_receive(1);	
	$exp->expect($timeout,">");
	$data = $exp->before();	
        $exp->send("\n");

        #sleep(5);
	return $data;

}

#teste_telnet.pl caminho_arquivo_lista_teste codcontrole
#teste_telnet.pl /labperl/tim_teste/lists/lista_completa00.txt tim1

$arqv_ltst=@ARGV[0];
$codtst1=@ARGV[1];

$t=time();
$datat=get_data_log();

if(!$arqv_ltst){
	$arqv_ltst="/labperl/tim_teste/lists/lista_completa00.txt";
}

if(!$codtst1){
	$codtst=$t."_def_".$datat;
}
else{

	$codtst=$t."_".$codtst1."_".$datat;
}

#abre arquivo de lista para testes
open(lhx,"$arqv_ltst");
@dth=<lhx>;
close(lhx);

#abre arquivo de resultados
#ip;porta;controle;rede;
#10.221.113.207;22;Tuffin 37305;;

$arqv_res=$hash_paths{"results_telnet"}."/".$codtst."_res.txt";
open(lres,">$arqv_res");
print lres "timestamp;data;status_teste;ip;porta;controle;origem;mascara rede;\n";

$arqvlog=$hash_paths{"logs"}."/telnet/".$codtst."_log.txt";
open(llogx,">$arqvlog");

foreach $item (@dth){

	$item=~s/\n//g;
    $item=~s/\r//g;

	$t=time();
	$datat=get_data_log("data_hora");
	@dti=split(/;/,$item);
	
	#ip;porta;controle;rdorigem;rede;
	#10.221.113.210;22;Tuffin 37305;10.16.7.192/26,10.174.21.64/26;10.221.113.210/32;
	$ip=@dti[0];
	$porta=@dti[1];
	$nome_rede=@dti[2];
	$rd_origem=@dti[3];
    $mask=@dti[4];
	
	if ($ip=~/\// or $ip=~/^ip/){
	
	    print "nao testa rede $ip ";
		next;
	}
	
	$teste_telnet=check_server($ip,$porta,"5");
	
	print llogx "#############\n";
	print llogx "$teste_telnet";

	
	@dts=split(/\n/,$teste_telnet);

    #print "###########saida $teste_telnet fim saida \n###########";
	
	$status_teste="naook";

	foreach $tst (@dts){

        #print " ----> $tst --------- \n";	
		if ($tst=~/Connected to /){
			
			$status_teste="ok";
            last;
		}
	}
	

	
	print lres "$t;$datat;$status_teste;$ip;$porta;$nome_rede;$rd_origem;$mask;\n";
	print llogx "$t;$datat;$status_teste;$ip;$porta;$nome_rede;$rd_origem;$mask;\n";
	print llogx "\n###^-> IP: $ip ; Porta: $porta :: Status: $status_teste#####\n";	
	
}

close(lres);
close(llogx);
exit
