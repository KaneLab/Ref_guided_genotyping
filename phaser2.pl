#!/usr/bin/perl
use strict;
use warnings;

#This is a very simple phaser. Please only use extremely high quality, diagnostic, SNPs in single-copy portions of the genome. This program works well for those SNPS, if you meet those assumptions.
#The program will output imputed genotypes in each window across the genome (to adjust window size, alter the $window parameter), based on the SNPs within that window and surrounding windows.


my $window = 1000000;

my $in = $ARGV[0];
my $windows = $ARGV[1];
open IN, $in;
open IN1, $windows;

my %window_genotype = ();
my $last_chr = 0;

while (<IN1>){
	chomp $_;
	my @tabs = split "\t", $_;
	my $chr = $tabs[0];
 	my $bp = $tabs[1];
	for (my $h = 2; $h < scalar @tabs; $h++){
		if ($chr ne $last_chr){
			for (my $k=0; $k<= $bp; $k=($k+$window)){
                                                $window_genotype{$chr}{$k}{$h+9}=$tabs[$h];
	#					print "window $chr $k $window_genotype{$chr}{$k}{$h+9}\n";
                        }
		}
		$window_genotype{$chr}{$bp}{$h+9}=$tabs[$h];
		
	}
	$last_chr = $chr;
}



my $position = 0;
my $window_start = 0;
my @counts = ();
my @genotypes = ();
my @averages = ();
my $chr = "NA";
my $bp = 0;
my @tab = ();
my @lastgenotypes = ();
my $lastchr = "-9";
while (<IN>){
	chomp $_;
	@tab = split "\t", $_;
	$chr= $tab[0];
	$bp =$tab[1];
	print "$chr\t$bp\t";
    	if ($chr == $lastchr){
	        $window_start = $window * (int ($bp / $window) );
#               print "$chr\t$window_start\t";
#		print "hi\t$chr\t$lastchr\n";
       		for (my $i = 11; $i < (scalar @tab); $i++){
			if ($tab[$i] eq "NA"){
				if (exists $window_genotype{$chr}{$window_start}{$i}){
					if ($window_genotype{$chr}{$window_start}{$i} eq $lastgenotypes[$i] and $lastgenotypes[$i] ne "NA"){
						print "$lastgenotypes[$i]\t";
					}
					else {
						if ($lastgenotypes[$i] eq "NA") { print "$window_genotype{$chr}{$window_start}{$i}\t";}
						else { print "$lastgenotypes[$i]\t";}
					}
				}
				else {print "$lastgenotypes[$i]\t";}
			}
			else {
                                if ($window_genotype{$chr}{$window_start}{$i}){ 
					if ($window_genotype{$chr}{$window_start}{$i} eq $tab[$i]){
						print "$tab[$i]\t";
						$lastgenotypes[$i]=$tab[$i];
					}
				
					elsif ( $lastgenotypes[$i]eq$tab[$i]){	
						print "$tab[$i]\t";
					}
					else {
						print "$window_genotype{$chr}{$window_start}{$i}\t";
						$lastgenotypes[$i]=$window_genotype{$chr}{$window_start}{$i};
					}
				}
				else {
					if ($lastgenotypes[$i] eq "NA"){
						print "$tab[$i]\t";
						$lastgenotypes[$i]=$tab[$i];
					}
					else {
						print "$lastgenotypes[$i]\t";
					}
				}
			}
		}
    	}           
       	else {
		$lastchr = $chr;
		$window_start = $window * (int ($bp / $window) );
	
	#	print "hello$chr\t$window_start\t";
		for (my $j = 11; $j < (scalar @tab); $j++){	
                	if (exists ($window_genotype{$chr}{$window_start}{$j}) ){
				if ($window_genotype{$chr}{$window_start}{$j} eq $tab[$j]){
                        		print "$tab[$j]\t";
                         		$lastgenotypes[$j]=$tab[$j];
	                        }
				else {
                                	print "$window_genotype{$chr}{$window_start}{$j}\t";
                                	$lastgenotypes[$j]=$window_genotype{$chr}{$window_start}{$j};
 				}
			}
			else {
				print "nowindow $window_start on chromosome $chr in genotypes file\n";
				print "$tab[$j]\t";
				$lastgenotypes[$j]=$tab[$j];
			}
		}	

	}
	print "\n";
}
close IN;
close IN1;
exit;
