package Utils::Colapsed;
use strict;
 
use Exporter;
our @ISA = qw(Exporter);
our @EXPORT = qw(ParseColapsed);
use Tie::IxHash;
 
sub ParseColapsed {
	my %args=@_;
	my $file=$args{"file"};
	#defino variables
	my @anot;
	my $ID;
	my %hash;
	tie %hash, 'Tie::IxHash';
	open(COLAPSED,$file) || die $!;
	while(<COLAPSED>){
		chomp $_;
		@anot=split(/\t/,$_);
		$ID=$anot[0];
		$hash{$ID}{ID}=$ID;
		$ID="";
		
	}
	close COLAPSED;
	return(%hash);
}

1;

=head1 NAME

Utils::Colapsed -Basic Operations in Perl

=head1 SYNOPSIS

	use Utils::Colapsed;
	my $data_colapsed=ParseColapsed(file=>$file_colapsed);
	print $data_colapsed{ID}


=head1 DESCRIPTION

The Utils::Colapsed module reads colapsed annotation files created by the Colapse_annotations program and returns each field as a hash key.

=head2 Functions:

=over 2

=item B<-ParseColapsed>

	This function reads an colapsed annotation files created by the Colapse_annotations program file and returns each field as a hash key and its contents as a value.

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