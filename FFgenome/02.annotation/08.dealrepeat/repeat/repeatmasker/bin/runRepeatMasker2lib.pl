#!/usr/bin/perl
### cut the fasta into subfiles and run repeatmasker by qsub-sge.pl
### report statistic of result file
use strict;
use warnings;
use File::Basename qw(basename dirname); 


die "Usage: perl runrepeatmasker2lib.pl infile lib> log" if (@ARGV < 2);
my $infile=$ARGV[0];
my $lib=$ARGV[1];
my $filename=basename($infile);
print "$infile\t$filename\n";

my $outdir=".";
my $repeat2gff="/share/raid12/chenjinfeng/tools/bin/repeat_to_gff.pl";
my $fastadeal="/share/raid12/chenjinfeng/tools/bin/fastaDeal.pl";
my $repeatmasker="/share/raid1/genome/bin/RepeatMasker";
my $statTE="/share/raid12/chenjinfeng/tools/bin/stat_TE.pl";
my $qsub="/share/raid12/chenjinfeng/tools/bin/qsub-sge.pl";
## cut file and push file name to array

`$fastadeal -cutf 30 $infile -outdir $outdir`;
my @subfiles=glob("./$filename.cut/*.*");

## write shell file 
my $repeatshell="$filename".".sh";
open OUT, ">$repeatshell" or die "can not open my shell out";
foreach (@subfiles){
    print "$_\n";
    print OUT "$repeatmasker -lib $lib -nolow -no_is -norna -engine wublast $_ > $_.log 2> $_.log2\n";
}
close OUT;

## run shell by qsub-sge.pl
`$qsub --reqsub $repeatshell`;
`cat $outdir/$filename.cut/*.out > $outdir/$filename.RepeatMasker.out`;
`cat $outdir/$filename.cut/*.masked > $outdir/$filename.RepeatMasker.masked`;
`cat $outdir/$filename.cut/*.tbl > $outdir/$filename.RepeatMasker.tbl`;
`cat $outdir/$filename.cut/*.cat > $outdir/$filename.RepeatMasker.cat`;
`perl $repeat2gff $outdir/$filename.RepeatMasker.out`;
`perl $statTE --repeat $outdir/$filename.RepeatMasker.out --rank all > $outdir/$filename.RepeatMasker.out.stat.all`;
`perl $statTE --repeat $outdir/$filename.RepeatMasker.out --rank type > $outdir/$filename.RepeatMasker.out.stat.type`;
`perl $statTE --repeat $outdir/$filename.RepeatMasker.out --rank subtype > $outdir/$filename.RepeatMasker.out.stat.subtype`;
`perl $statTE --repeat $outdir/$filename.RepeatMasker.out --rank family > $outdir/$filename.RepeatMasker.out.stat.family`;
`rm -R $outdir/$filename.cut`;


