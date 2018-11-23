package Utils::Protseq;
use strict;
 
use Exporter;
our @ISA = qw(Exporter);
our @EXPORT = qw(ParseProtseq);
use Tie::IxHash;
 
sub ParseProtseq {

	my %args=@_;
	my $file=$args{"file"};
	#defino variables
	my $ID;
	my $seq;
	my %hash;
	tie %hash, 'Tie::IxHash';
	open(PROTSEQ,$file) || die $!;
	while(my $line=<PROTSEQ>){
		chomp($line);
		if($line=~/^>/){
			$line=~s/^>(.*)//g;
			$ID=$1;
			
		}
		if($line=~/[A-Z]/){
			$line=~s/([A-Z]+)//g;
			$seq=$1;
			$hash{$ID}{ID}=$ID;
			$hash{$ID}{seq}=$seq;
			$ID="";
			$seq="";
		}
		
	}
	close PROTSEQ;
	return(%hash);

}

1;

=head1 NAME

Utils::Protseq -Basic Operations in Perl

=head1 SYNOPSIS

	use Utils::Protseq;
	my $data_protseq=ParseProtseq(file=>$file_protseq);
	print $data_protseq{ID}


=head1 DESCRIPTION

The Utils::Protseq module reads fasta protein sequence files and returns each field as a hash key.

=head2 Functions:

=over 2

=item B<-ParseProtseq>

	This function reads an interpro2go file and returns each field as a hash key and its contents as a value.

=back

=head1 AUTHOR

Beatriz Plata Barril	<platabarril@gmail.com>

=head1 COPYRIGHT AND DISCLAIMER

This program is Copyright 2017 by Beatriz Plata Barril.
This program is free software; you can redistribute it and/or
modify it under the terms of the Perl Artistic License or the
GNU General Public License as published by the Free Software
Foundation; either version 2 of the License, or (at your option) any
later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

If you do not have a copy of the GNU General Public License write to
the Free Software Foundation, Inc., 675 Mass Ave, Cambridge,
MA 02139, USA.