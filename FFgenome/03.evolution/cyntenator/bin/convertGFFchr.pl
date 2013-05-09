#!/usr/bin/perl
use Getopt::Long;

GetOptions (\%opt,"gff:s","project:s","help");


my $help=<<USAGE;

Convert gff format file to cyntenator txt format.
Example:
Os01g0100100 1 1903 9816 +
Sb01g001001  1 2000 3000 +

Run: perl convertGFF.pl -gff Rice.gff -project Os
-gff: GFF file 
-project: prefix for chromosome name in txt, Os01

USAGE

print $help and exit if (keys %opt < 1); 
`mkdir $opt{project}.chr`;
my %chr;
open IN, "$opt{gff}" or die "$!";
open OUT, ">$opt{project}.txt" or die "$!";
print OUT "#genome\n";
while(<IN>){
    chomp $_;
    my @unit=split("\t",$_);
    if ($unit[2] eq "mRNA"){
         my $start=$unit[3]; 
         my $end  =$unit[4];
         my $strand=$unit[6];
         $unit[0]=~s/[a-zA-Z]//g;
         $unit[0]=~s/\_//g;
         $unit[0] = "0".$unit[0] if (length $unit[0] == 1);
         my $chr =$unit[0];
         unless (exists $chr{$chr}){
             writefile("chr$chr.txt","#genome");
         }
         $chr{$chr}=1;
         my $gene;
         if ($unit[8] =~/ID=(.*?);/){
             $gene=$1;
         }
         my $line= "$gene\t$chr\t$start\t$end\t$strand";
         print OUT "$line\n";
         writefile("chr$chr.txt",$line);
    }
}
close IN;
close OUT;

sub writefile
{
my ($file,$line)=@_;
open FH, ">>$opt{project}.chr/$file" or die "$!";
   print FH "$line\n";
close FH;
}

