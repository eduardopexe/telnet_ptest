#!/usr/bin/perl

#####################################################
# Author        : Eduardo Pexe 
# Date          : Jun 03, 2022
# Version       : 1.0
# Descricao     : Teste de portas telnet
#####################################################
#lista origem padrao: /tim_teste/lists/lista_teste_telnet00.txt
#lista destino padrao: /tim_teste/lists/lista_completa00.txt
#para mudar arquivo origem: ARGV[0]
#para mudar destino : ARGV[1]
#exemplo1: perl /tim_teste/glist/00_glist_telnet_tst.pl
#arvivo origem exemplo 1: /tim_teste/lists/lista_teste_telnet00.txt
#arvivo destino exemplo 1: /tim_teste/lists/lista_completa00.txt
#exemplo2: perl /tim_teste/glist/00_glist_telnet_tst.pl /tim_teste/lists/lt_telnet.txt /tim_teste/lists/lt_to_test.txt
#arvivo origem exemplo 2: /tim_teste/lists/lt_telnet.txt
#arvivo destino exemplo 2: /tim_teste/lists/lt_to_test.txt

#use strict;
#use warnings;
use Expect;
use Data::Dumper;

use Cwd qw();


my $path = Cwd::cwd();

@pth=split(/\//,$path);
$dirlocal=pop(@pth);

$path_main="";

foreach $dirp (@pth){

	if (!$dirp) {
		next;
	}
	$path_main.="/".$dirp;

}

%hash_paths=();

$hash_paths{"local"}=$path;
$hash_paths{"main"}=$path_main;
$hash_paths{"lists"}=$path_main."/lists";
$hash_paths{"results"}=$path_main."/results";
$hash_paths{"results_telnet"}=$path_main."/results/telnet";
$hash_paths{"logs_telnet"}=$path_main."/logs/telnet";
$hash_paths{"results_fping"}=$path_main."/results/fping";
$hash_paths{"logs_fping"}=$path_main."/logs/fping";
$hash_paths{"logs"}=$path_main."/logs";

#lista_teste_telnet00.txt
#ips;portas;controle;origem;
#10.221.113.210/32;22,3389;Tuffin 37305;10.16.7.192/26,10.174.21.64/26;


$arqv_tst=@ARGV[0];

if (!$arqv_tst){

	$arqv_tst=$hash_paths{"lists"}."/lista_teste_telnet00.txt";
}

$arqv_lsaida=@ARGV[1];

if (!$arqv_lsaida){

	$arqv_lsaida=$hash_paths{"lists"}."/lista_completa00.txt";
}

open(lhx,"$arqv_tst");
@dth=<lhx>;
close(lhx);

open(lres,">$arqv_lsaida");
%hash_ips=();

%hash_ambientes=();

foreach $item (@dth){

	$item=~s/\n//g;
    $item=~s/\r//g;
	
	if ($item=~/^ips/){
		next;
	}
	
	@dti=split(/;/,$item);
	#lista_teste_telnet00.txt
	#ips;portas;controle;origem;
	#10.221.113.210/32;22,3389;Tuffin 37305;10.16.7.192/26,10.174.21.64/26;
	
	$ipx=@dti[0];
	@portas=split(/\,/,@dti[1]);
	$nome_rede=@dti[2];
	$origem_rede=@dti[3];
	
	$hash_ambientes{$nome_rede}=$nome_rede;
	
	if ($ipx=~/\//){
	
	    #print "nao testa rede $ip ";
		@ipsr=split(/\//,$ipx);
		$maskrede=@ipsr[1];
		$ipn=@ipsr[0];
		
		@ipnetmask=split(/\./,$ipn);
		
		$ipa=@ipnetmask[0];
		$ipb=@ipnetmask[1];
		$ipc=@ipnetmask[2];
		$ipd=@ipnetmask[3];

	    $bitsa="";
		$bitsb="";
		$bitsc="";
		$bitsd="";
		$range="";
        $ip_start="";
		$ip_end="";
			
		if ($maskrede eq '32'){
		
			$ipf=$ipn;
		
		}
		else{
		

			$ipf=$ipn;
			
			if ($maskrede<8){
			
			    $bitsd=256;
				$bitsc=256;
				$bitsb=256;
				$bitsa=2**(8-$maskrede);
				$range="a";
				
				$ip_start=$ipa;
				$ip_end=$ipa+$bitsa-1;
			}	

			if ($maskrede>7 and $maskrede<16){
			
			    $bitsd=256;
				$bitsc=256;
				$bitsb=2**(16-$maskrede);
				$range="b";
				$ip_start=$ipb;
				$ip_end=$ipb+$bitsb-1;				
			}	

			if ($maskrede>15 and $maskrede<24){
			
			    $bitsd=256;
				$bitsc=2**(24-$maskrede);
				$range="c";
				$ip_start=$ipc;
				$ip_end=$ipc+$bitsc-1;		
			}
			
			if ($maskrede>23){
			
				$bitsd=2**(32-$maskrede);
				$range="d";
				$ip_start=$ipd;
				$ip_end=$ipd+$bitsd;	
	            $ip_end=$ipd+$bitsd-1;
				
                				
			}

			
		}
		
		#print "msk: $maskrede - ips $ip_start ||| ipe $ip_end ||| bd $bitsd || c bitsc || b $bitsb || a $bitsa\n"; 
		
		if (!$range){
		
		    print "no range : $ipf | $nome_rede | start: $ip_start | end: $ip_end \n";
			$hash_ips{$ipf}=$nome_rede;
			$hash_ips{$ipf}{$nome_rede}=$nome_rede;
			foreach $iporta (@portas){
					
				print lres "$ipf;$iporta;$nome_rede;$origem_rede;$ipx;\n";
				
			}
		}
		else{
		
			print "range $range : $ipf $nome_rede || $ipx | start: $ip_start | end: $ip_end\n";
			
			if ($range eq 'd'){
				
				$i=$ip_start;
				while($i<$ip_end){
				    
					if ($i==0){
						
						$i++;
					
					}
					$ipt=$ipa.".".$ipb.".".$ipc.".".$i;
					$hash_ips{$ipt}=$nome_rede;
					$hash_ips{$ipt}{$nome_rede}=$nome_rede;
					$i++;
##
                   #print "$ipt ||| $i || range $range ||| $ipx\n";
					foreach $iporta (@portas){
		
						print lres "$ipt;$iporta;$nome_rede;$origem_rede;$ipx;\n";
				
					}
##					
				}
			}
			
#####

			if ($range eq 'c'){
				
				$i=$ip_start;
				while($i<$ip_end){
				
					if ($i==0){
						
						$i++;
					
					}
					$ipt=$ipa.".".$ipb.".".$i;
					$i++;
##
                    $d=0;
					
					while($d<255){
						$d++;
						$ipt.=".".$d;
						$hash_ips{$ipt}=$nome_rede;	
						$hash_ips{$ipt}{$nome_rede}=$nome_rede;						
						foreach $iporta (@portas){
		
							print lres "$ipt;$iporta;$nome_rede;$origem_rede;$ipx;\n";
				
						}
					}
##					
				}
			}

#####

#####

			if ($range eq 'b'){
				
				$i=$ip_start;
				while($i<$ip_end){
				
					if ($i==0){
						
						$i++;
					
					}
					$ipt=$ipa.".".$i;
					$i++;
                    $c=0;      
                    #$d=0;
					
					while($c<255){
						$c++;
						$ipt.=".".$c;
						$d=0;
						while($d<255){
							$d++;
							$ipt.=".".$d;
							$hash_ips{$ipt}=$nome_rede;
							$hash_ips{$ipt}{$nome_rede}=$nome_rede;							
							foreach $iporta (@portas){
		
								print lres "$ipt;$iporta;$nome_rede;$origem_rede;$ipx;\n";
				
							}
						}
					}
##					
				}
			}

#####

#####

			if ($range eq 'a'){
				
				$i=$ip_start;
				while($i<$ip_end){
				
					if ($i==0){
						
						$i++;
					
					}
					$ipt=$i;
					$i++;
                    $b=0;      
                    #$d=0;
					
					while($b<255){
						$b++;
						$ipt.=".".$b;
						$c=0;
						while($c<255){
							$c++;
							$ipt.=".".$c;
							$d=0;
							while($d<255){
								$d++;
								$ipt.=".".$d;
								$hash_ips{$ipt}=$nome_rede;
								$hash_ips{$ipt}{$nome_rede}=$nome_rede;
								foreach $iporta (@portas){				
									
									print lres "$ipt;$iporta;$nome_rede;$origem_rede;$ipx;\n";
				
								}
							}
						}
					}
##					
				}
			}

#####		
		}

		
	}
    else{
		
		
		foreach $iporta (@portas){
		
		    $hash_ips{$ipx}=$nome_rede;
			$hash_ips{$ipx}{$nome_rede}=$nome_rede;
			print lres "$ipx;$iporta;$nome_rede;$origem_rede;;\n";
		
		}
	}
}

###abre arquivos ambientes
#$hash_paths{"lists"}
$l=0;
#foreach $amb (keys %hash_ambientes){

#	$mno=$amb;
#	$mno=~s/\s//g;
#	$mno=lc($mno);
	
#   $hash_ambientes{$amb}=$mno;
#	$hash_ambientes{$amb}{'handlef'}="lhanf".$l;
#	$hash_ambientes{$amb}{'handlet'}="lhant".$l;	
#	$hash_ambientes{$amb}{'lista_telnet'}=$hash_paths{"lists"}."/"."telnet_tim_".$mno.".txt";
#	$hash_ambientes{$amb}{'lista_fping'}=$hash_paths{"lists"}."/"."fping_tim_".$mno.".txt";
		
#	$saida=$hash_ambientes{$amb}{'handlef'};
	
#	print "$amb ||| $saida --- $hash_ambientes{$amb}{'lista_fping'}\n";
	
#	open($saida,">$hash_ambientes{$amb}{'lista_fping'}");

#	$l++;
#}

$arqvu=$hash_paths{"lists"}."/"."fping_tim_ipg.txt";
open(luni,">$arqvu");
foreach $ipfp (keys %hash_ips){

	$nome=$hash_ips{$ipfp};
	#$nome=~s/\s//g;
	#$nome=lc($nome);
	$saida=$hash_ambientes{$nome}{'handlef'};
	
	print "$saida ||| $ipfp ||| $nome \n";
	
	#print $saida "$ipfp\n";
	print luni "$ipfp\n";
}

#foreach $amb (keys %hash_ambientes){

	#close($hash_ambientes{$amb}{'lista_fping'});
#}

close(luni);
close(lres);
exit
