#!/usr/bin/perl

#use strict;
#use warnings;
use Expect;
use Time::Local;
use Cwd qw();


my $path = Cwd::cwd();

@pth=split(/\//,$path);
$dirlocal=pop(@pth);

$path_main="";

foreach $dirp (@pth){

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


$arqv_ltstx=@ARGV[0];
$codtst1=@ARGV[1];

$t=time();
$datat=get_data_log();

if(!$arqv_ltstx){
	$arqv_ltstx="/tim_teste/results/fping/fpt_tim00.txt";
}

if(!$codtst1){
	$codtst=$t."_def_".$datat;
}
else{

	$codtst=$t."_".$codtst1."_".$datat;
}

#abre arquivo de lista para testes
open(lhx,"$arqv_ltstx");
@dth=<lhx>;
close(lhx);

$arqv_res=$hash_paths{"results_fping"}."/".$codtst."_res.txt";
open(lres,">$arqv_res");

%hash_total=();
$hash_total{"ok"}=0;
$hash_total{"loss"}=0;
$hash_total{"falha"}=0;
$hash_total{"total"}=0;

foreach $item (@dth){

	$item=~s/\n//g;
	$item=~s/\r//g;
	$status="ver";
	
	if ($item=~/xmt\/rcv/){
	
	$hash_total{"total"}++;
	
	   if ($item=~/avg/){
	   
			($ipt,$psent,$prcv,$pctloss,$min,$avg,$max)=$item=~m/(\d+\.\d+\.\d+\.\d+)\s+:\s+xmt\/rcv\/%loss\s=\s(\d+)\/(\d+)\/(\d+)%,.*=\s(\d+.*)\/(\d+.*)\/(\d+.*)/;
	        
			if ($pctloss eq '0'){
			
				$status="ok";
				
				$hash_total{"ok"}++;
			}
			else{
		            #print $item."\n";	
                            #print "$ipt,$psent,$prcv,$pctloss,$min,$avg,$max \n";
		  	    $status="loss";
			    $hash_total{"loss"}++;
			}
			
	   }
	   else{
	   
	        $min="";
			$avg="";
			$max="";
			($ipt,$psent,$prcv,$pctloss)=$item=~m/(\d+\.\d+\.\d+\.\d+)\s+:\s+xmt\/rcv\/%loss\s=\s(\d+)\/(\d+)\/(\d+)%/;
			
			$status="falha";
			$hash_total{"falha"}++;
	   }
	
	   $t=time();
	   $datat=get_data_log("data_hora");
	   print lres "$t;$datat;$status;$ipt;$psent;$prcv;$pctloss;$min;$avg;$max;\n";

    }
	else{
	
		next;
	
	}

}

$t=time();
$datat=get_data_log("data_hora");

print "$t;$datat";
print ";".$hash_total{"ok"};
print ";".$hash_total{"loss"};
print ";".$hash_total{"falha"};
print ";".$hash_total{"total"};
print ";\n";

close(lres);
exit
