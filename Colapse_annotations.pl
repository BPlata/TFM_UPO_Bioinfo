#!/usr/bin/perl

use strict;
use warnings;

BEGIN {
	use Getopt::Long;
	die "You have an *old* version of Getopt::Long, please ",
	    "update it asap!!\n"
	    unless Getopt::Long->VERSION >= 2.5;
}

use Getopt::Long;
use List::Compare;
use List::MoreUtils qw(uniq);

my $file;
my $help;

GetOptions(
	"file=s"=>\$file,
	"help"=>\$help
);

if($file){
	open(FILE,$file) || die "Can't open $file\n";
	open(OUT,">Colapsed_annotations.txt")|| die "No puedo crear Colapsed_annotations.txt\n";
	#definición de variables.
	my $ID="";
	my $genename="";
	my $desc="";
	my $enz="";
	my $GO="";
	my $keywd="";
	my $pathway="";
	my $GOSLIM="";
	
	my @GOs=();
	my @anot=();
	my @ref=();
	my $noanotid="";
	
	my $lc="";
	my @inters=();
	my $cp1="";
	my $cp2="";
	my @union=();
	my @combi=();
	
	my @uniqGO=();
	my $uniqGO="";
	my @anot_2=();
	my $ID_ref="";
	my $gene_ref="";
	my $desc_ref="";
	my @enz_ref=();
	my @keywd_ref=();
	my $pathway_ref="";
	my @GOSLIM_ref=();

	my @GOSLIMs=();
	my @combi_GOSLIM=();
	my @uniqGOSLIM=();
	my $uniqGOSLIM="";
	my @keywds=();
	my @combi_kw=();
	my @uniq_kw=();
	my $uniq_kw="";
	my @enzs=();
	my @combi_enz=();
	my @uniq_enz=();
	my $uniq_enz="";
	

	
	print "\nBuscando igualdades en anotaciones...\n\n";
	
	while(<FILE>){
		chomp $_;
			
			@anot=split(/\t/,$_);	#Separamos los campos por tabulador y los incluimos en un array
			#Asignamos cada campo a su variable.
			$ID=$anot[0];
			$genename=$anot[1];
			$desc=$anot[2];
			$enz=$anot[3];
			$GO=$anot[4];
			$keywd=$anot[5];
			$pathway=$anot[6];
			$GOSLIM=$anot[7];
			
			if($GO){
				@GOs=split(/;/,$GO);	#Separamos cada término GO y los incluimos en un array.
			}else{
				@GOs=();
			}

			if($enz){
				@enzs=split(/;/,$enz);
			}else{
				@enzs=();
			}

			if($keywd){
				@keywds=split(/;/,$keywd);
			}else{
				@keywds=();
			}

			if($GOSLIM){
				@GOSLIMs=split(/;/,$GOSLIM);
			}else{
				@GOSLIMs=();
			}
				
						
			if ((scalar(@GOs)==0) and (scalar(@ref)!=0)){	#Si el gen actual no está anotado y tenemos gen en @ref, incluimos el ID en una variable y vamos concatenando los siguientes ID de genes no anotados.
				$noanotid.=$ID."\n";
				next;			
			}else{	#Si el gen actual está anotado:		
				if(scalar(@ref)==0){	#Si @ref está vacío, le asignamos el valor de @GO. Renombramos cada variable actual como variable_ref. Incluimos el @GO actual en el array @combi.
					@ref=(@GOs);
					$ID_ref=$ID;
					$gene_ref=$genename;
					$desc_ref=$desc;
					@enz_ref=(@enzs);
					@keywd_ref=(@keywds);
					if($pathway){
						$pathway_ref=$pathway;
					}else{
						$pathway_ref="";
					}
					@GOSLIM_ref=(@GOSLIMs);

					push @combi, @GOs;
					push @combi_enz, @enzs;
					push @combi_kw, @keywds;
					push @combi_GOSLIM, @GOSLIMs;
					
				}else{	#Si @ref no está vacío, lo comparamos con el @GO del gen actual.
					$lc = List::Compare-> new(\@ref, \@GOs);
					@inters=$lc->get_intersection;
					@union=$lc->get_union;
					
					$cp1=$#inters/(abs($#ref)+0.1)*100;
					$cp2=$#inters/(abs($#GOs)+0.1)*100;
					
					if(($cp1>75)|| ($cp2>75)){	#Si hay una igualdad >75% de GO entre @ref y @GO actual, añadimos @GO al array @combi.
						push @combi, @GOs;
						push @combi_enz, @enzs;
						push @combi_kw, @keywds;
						push @combi_GOSLIM, @GOSLIMs;
						$noanotid=""; #Vaciamos la variable de IDs de genes no anotados.
					}else{	#Si @ref y @GO no se parecen en al menos un 75%, seleccionamos los GO no repetidos (uniq) que hemos incluido en @combi.
						@uniqGO=uniq(@combi);
						$uniqGO=join(";",@uniqGO);
						@uniq_enz=uniq(@combi_enz);
						$uniq_enz=join(";",@uniq_enz);
						@uniq_kw=uniq(@combi_kw);
						$uniq_kw=join(";",@uniq_kw);
						@uniqGOSLIM=uniq(@combi_GOSLIM);
						$uniqGOSLIM=join(";",@uniqGOSLIM);
						@anot_2=join("\t",$ID_ref,$gene_ref,$desc_ref,$uniq_enz,$uniqGO,$uniq_kw,$pathway_ref,$uniqGOSLIM);	#Creamos un array con la anotación nueva de los genes combinados que tenían anotación similar siendo consecutivos.
						if($ID_ref){
							print OUT "@anot_2\n";
						}
						print OUT $noanotid;
						#Reseteamos la variable de ID de no anotados y renombramos el resto como variable_ref.
						$noanotid="";
						@ref=(@GOs);
						$ID_ref=$ID;
						$gene_ref=$genename;
						$desc_ref=$desc;
						@enz_ref=(@enzs);
						@keywd_ref=(@keywds);
						if($pathway){
							$pathway_ref=$pathway;
						}else{
							$pathway_ref="";
						}
						@GOSLIM_ref=(@GOSLIMs);
						@combi=(@GOs);
						@combi_enz=(@enzs);
						@combi_kw=(@keywds);
						@combi_GOSLIM=(@GOSLIMs);
					}
				}
			}
			
	}
	print OUT "$ID_ref\t$gene_ref\t$desc_ref\t@enz_ref\t@ref\t@keywd_ref\t$pathway_ref\t@GOSLIM_ref\n";
	print OUT "$noanotid";
	print "Se ha generado el archivo Colapsed_annotations.txt\n\n";
	close FILE;
	close OUT;

}
else{
        my $usage = qq{
          $0 

            Getting help:
                [--help]

            Needed parameters:
				[file|f] : Annotation file
				
				
            Examples:
             Process file
              $0 -file prot_seq_uniref90_goslim.tsv
 			        
		};

print STDERR $usage;
exit();
	
}