#!/usr/bin/perl
use strict;
use warnings;
 
#This is a very simple genotype imputer. Please only use extremely high quality, diagnostic, SNPs in single-copy portions of the genome. This program works well for those SNPS, if you meet those assumptions.
#The program will output imputed genotypes in each window across the genome (to adjust window size, alter the $window parameter), based on the SNPs within that window and surrounding windows.

my $in = $ARGV[0];
#my $header = $ARGV[1];
open IN, $in;
#open IN1, $header;


#uncomment this if there is a header in the data file. 
#$header = (<IN1>);
#print "$header\n";
my $genotype = "NA";
my $position = 0;
my $window = 1000000;
my $lastchr = "NA";
my $window_start = 0;
my @counts = ();
my @genotypes = ();
my @averages = ();
my $chr = "NA";
my $bp = 0;
my @tab = ();
my @lastgenotypes = ();
my @chr_windows=();
my @window_starts = ();
my @chr_counts=();
my $window_count = 0;

#read in the datafile and assign genotypes to windows
while (<IN>){
	chomp $_;
	@tab = split "\t", $_;
	$chr= $tab[0];
	$bp =$tab[1];

    	if ($chr eq $lastchr){
            if ($bp < $window_start + $window){
        	for (my $i = 0; $i < (scalar @tab) -11; $i++){
 			unless ($tab[$i+11] eq "NA"){
				$genotypes[$i]=$genotypes[$i]+$tab[$i+11];
				$counts[$i]++;
				if ($chr_counts[$i]<1){
					for (my $k=0; $k<= scalar @window_starts; $k++){
						$chr_windows[$i][$k]=$tab[$i+11];
					}
				}
				$chr_counts[$i]++;	
			}
		}
 	      }           
              else {
			for (my $j = 0; $j < (scalar @tab) -11; $j++){
				if ($counts[$j] > 0){
		                    	my $average = $genotypes[$j] / $counts[$j];
					my $geno = "";
	                		if ($average > 1.5){
        	                		$geno = 2;
                	    		}
                	    		elsif ($average > 0.5){
                        			$geno = 1;
                    			}
                   			else {
                        			$geno = 0;
                    			}
					$chr_windows[$j][$window_count]=$geno;
					
					$lastgenotypes[$j]=$geno;
					$chr_counts[$j]++;
				}
				else { 
					$chr_windows[$j][$window_count]=$lastgenotypes[$j];
				}
				if ($tab[$j+11] eq "NA"){
                                	$genotypes[$j]=0;
                                	$counts[$j]=0;
				}
				else {
	                                $genotypes[$j]=$tab[$j+11];
                                	$counts[$j]=1;
					if ($chr_counts[$j]<1){
	                                        for (my $k=0; $k<= scalar @window_starts; $k++){
        	                                        $chr_windows[$j][$k]=$tab[$j+11];
                	                        }

                        	        }
                                	$chr_counts[$j]++;

                        	}	


			}
			$window_count++;
                   

                	$window_start = $window * (int ($bp / $window) );
			push @window_starts, $window_start;
		}
        }
        
        else {
            unless ($lastchr eq "NA") {
	    }
            for (my $j = 0; $j < (scalar @tab) -11; $j++){
                if($lastchr eq "NA"){$lastgenotypes[$j]="NA"}
		elsif ($counts[$j] > 0){
                        my $average = $genotypes[$j] / $counts[$j];
			my $geno = "";
                        if ($average > 1.33){
                                                $geno = 2;
                        }
                        elsif ($average > 0.66){
                                                $geno = 1;
                        }
                        else {
                                                $geno = 0;
                        }
			$chr_windows[$j][$window_count]=$geno;
                }
              	else { 			$chr_windows[$j][$window_count]=$lastgenotypes[$j];
			
		}
		




                if ($tab[$j+11] eq "NA"){
                                        $genotypes[$j]=0;
                                        $counts[$j]=0;
					$chr_counts[$j]= 0;
					$lastgenotypes[$j]="NA";
                                }
                else {
                                        $genotypes[$j]=$tab[$j+11];
                                        $counts[$j]=1;
					$chr_counts[$j] = 1;
					$lastgenotypes[$j]=$tab[$j+11];
              	}
				
                                
               	}
		unless ($lastchr eq "NA"){
			print "\n";

			my $start=0;
			for (my $n = 0; $n < (scalar @window_starts); $n++){
				$start = shift @window_starts;
				print "$lastchr\t$start\t";
				for (my $o = 0; $o < (scalar @tab) - 11; $o++){
					print "$chr_windows[$o][$n]\t";
				}
				print "\n";

			}

			
		}
		$lastchr = $chr;
		@window_starts = ();
                $window_start = $window * (int ($bp / $window) );
		push @window_starts, $window_start;
		@chr_windows = ();		
		$window_count = 0;
        }
}


#            print "$lastchr\t$window_start\t";
            for (my $j = 0; $j < (scalar @tab) -11; $j++){
                if ($counts[$j] > 0){
                        my $average = $genotypes[$j] / $counts[$j];
			my $geno = "";
                                        if ($average > 1.3){
                                                $geno = 2;
                                        }
                                        elsif ($average > 0.4){
                                                $geno = 1;
                                        }
                                        else {
                                                $geno = 0;
                                        }
#                                        print "$geno\t";
                           }
#                                else { print "$lastgenotypes[$j]\t";}
}
my $start=0;

#print out imputed genotype windows

for (my $n = 0; $n < (scalar @window_starts); $n++){
				$start = shift @window_starts;
                                print "$lastchr\t$start\t";
                                for (my $o = 0; $o < (scalar @tab) - 11; $o++){
                                        print "$chr_windows[$o][$n]\t";
                                }
                                print "\n";

}

print "\n";
