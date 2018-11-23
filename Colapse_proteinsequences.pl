#!/usr/bin/perl

BEGIN {
	use Getopt::Long;
	die "You have an *old* version of Getopt::Long, please ",
	    "update it asap!!\n"
	    unless Getopt::Long->VERSION >= 2.5;
}

use strict;
use warnings;
use Getopt::Long;
use Utils::Protseq;
use Utils::Colapsed;
use Tie::IxHash;
# use List::Compare;
# use List::MoreUtils qw(uniq);

my $file_protseq;
my $file_colapsed;
my $help;
my %data_protseq;
tie %data_protseq, 'Tie::IxHash';
my %data_colapsed;
tie %data_colapsed, 'Tie::IxHash';

GetOptions(
	"file1|f1=s" => \$file_protseq,
	"file2|f2=s" => \$file_colapsed,
	"help"=>\$help
);

if($file_protseq and $file_colapsed){
	open(OUT,">Colapsed_protseq.faa") || die "No puedo crear Colapsed_protseq.faa\n";
	
	%data_protseq=ParseProtseq(file=>$file_protseq);
	
	%data_colapsed=ParseColapsed(file=>$file_colapsed);
	
	foreach my $valorP (keys %data_protseq){
		# print $valorP."\n";
		foreach my $valorC (keys %data_colapsed){
			if($data_protseq{$valorP}{ID} eq $data_colapsed{$valorC}{ID}){
				print OUT "\n>".$data_colapsed{$valorC}{ID}."\n";
				
			}
		}
		print OUT $data_protseq{$valorP}{seq}; 
	}
	print "\nColapsed protein sequence file has been created.\n\n";
	close OUT;
	
}
else{
        my $usage = qq{
          $0 

            Getting help:
                [--help]

            Needed parameters:
				[file1|f1] : Protein sequence FASTA file
				[file2|f2] : Annotation colapsed .txt file
				
				
            Examples:
             Process file
              $0 -file1 prot_seq.faa -file2 Colapsed_annotation.txt
 			        
		};

print STDERR $usage;
exit();
	
}