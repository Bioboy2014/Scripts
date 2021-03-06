#!/usr/bin/perl
use Getopt::Long;
use strict;
#use warnings;

our %opt;
GetOptions (\%opt,"fasta:s","project:s","help");


my $help=<<USAGE;
Classify NBS gene into CC-NBS-LRR, TIR-NBS-LRR, NBS-LRR, NBS.
perl $0 --fasta NBS.rice.fa --project rice
USAGE


if ($opt{help} or keys %opt < 1){
    print "$help\n";
    exit();
} 

my $refcc=findcoil();
my $reflrr=findLRR();
my $reftir=findTIR();

& classify($opt{fasta},$refcc,$reftir,$reflrr);


######################################

sub classify
{
my ($fasta,$cc,$tir,$lrr)=@_;
$/="\>";
my @sum;
my %hash;
open OUT1, ">$opt{project}.CC-NBS-LRR.fa" or die "$!";
open OUT2, ">$opt{project}.CC-NBS.fa" or die "$!";
open OUT3, ">$opt{project}.TIR-NBS-LRR.fa" or die "$!";
open OUT4, ">$opt{project}.TIR-NBS.fa" or die "$!";
open OUT5, ">$opt{project}.NBS-LRR.fa" or die "$!";
open OUT6, ">$opt{project}.NBS.fa" or die "$!";
open IN,"$fasta" or die "$!";
while (<IN>){
    next if (length $_ < 2);
    my @unit=split("\n",$_);
    my $temp=shift @unit;
    my @temp1=split(" ",$temp);
    my $head=$temp1[0];
    my $seq=join("\n",@unit);
    $seq=~s/\>//g;
    $seq=~s/\n//g;
    $seq=~s/\s//g;
    if (exists $cc->{$head} and exists $lrr->{$head}){
       $sum[0]++;
       print OUT1 ">$head\n$seq\n";
    }elsif(exists $cc->{$head}){
       $sum[1]++;
       print OUT2 ">$head\n$seq\n";
    }elsif(exists $tir->{$head} and exists $lrr->{$head}){
       $sum[2]++;
       print OUT3 ">$head\n$seq\n";
    }elsif(exists $tir->{$head}){
       $sum[3]++;
       print OUT4 ">$head\n$seq\n";
    }elsif(exists $lrr->{$head}){
       $sum[4]++;
       print OUT5 ">$head\n$seq\n";
    }else{
       $sum[5]++;
       print OUT6 ">$head\n$seq\n";
    }
}
$/="\n";
close IN;
close OUT1;
close OUT2;
close OUT3;
close OUT4;
close OUT5;
close OUT6;
print "CC-NBS-LRR: $sum[0]\nCC-NBS: $sum[1]\nTIR-NBS-LRR: $sum[2]\nTIR-NBS: $sum[3]\nNBS-LRR: $sum[4]\nNBS: $sum[5]\n";
}

##need hmmer2table.pl in this directory
sub findLRR
{
my %hash;
`hmmpfam ../../input/Pfam/LRR.smart.hmm $opt{fasta} > $opt{project}.LRR.hmmpfam`;
`perl hmmer2table.pl --hmmer $opt{project}.LRR.hmmpfam > $opt{project}.LRR.hmmpfam.table`;
open IN, "$opt{project}.LRR.hmmpfam.table" or die "$!";
while(<IN>){
    chomp $_;
    next if ($_=~/^$/);
    my @unit=split("\t",$_);
    next if ($unit[7] > 0.1);
    #print "$unit[0]\t$unit[7]\n";
    $hash{$unit[0]}= $unit[7] < $hash{$unit[0]} ? $unit[7] : $hash{$unit[0]};
}
close IN;
return \%hash;
}


sub findTIR
{
my %hash;
`hmmsearch --tblout $opt{project}.TIR.hmmsearch.tableout ../../input/Pfam/TIR.hmm $opt{fasta} > $opt{project}.TIR.hmmsearch`;
open IN, "$opt{project}.TIR.hmmsearch.tableout" or die "$!";
     while(<IN>){
            chomp $_;
            next if ($_=~/^#/ or $_=~/^$/);
            my @unit=split(" ",$_);
            next if ($unit[7] > 1);
            $hash{$unit[0]}=1;
     }
close IN;
return \%hash;
}


##cp /home/biosoftware/iprscan/data/new_coil.mat ./new.mat
sub findcoil
{
my %hash;
`/home/biosoftware/iprscan/bin/Linux/ncoils -c < $opt{fasta} > $opt{project}.ncoil 2> $opt{project}.ncoil.log`;
$/="\/\/\n";
open IN, "$opt{project}.ncoil" or die "$!";
while(<IN>){
   chomp $_;
   my $record=$_;
   my @unit=split("\n",$record);
   my $head=shift @unit;
   $head=$1 if ($head=~/\>(.*)$/);
   chomp $head;
   $head=~s/\s//g;   
   if ($unit[0]=~/\d+/){
      #print "$head";
      $hash{$head}=1;
   }
}
close IN;
$/="\n";
return \%hash;
}
