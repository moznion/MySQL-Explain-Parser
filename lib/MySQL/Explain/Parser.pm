package MySQL::Explain::Parser;
use 5.008005;
use strict;
use warnings;
use parent "Exporter";

our $VERSION = "0.01";
our @EXPORT_OK = qw/parse/;

sub parse {
    my ($explain) = @_;

    my @rows = split /\r?\n/, $explain;

    shift @rows; # Skip the top of outline
    pop @rows; # Skip the bottom of outline

    my $index_row = shift @rows;
    my @indexes = grep {$_} split /\|/, $index_row;
    my @indexes_length = map {length $_} @indexes;
    map {s/\s//g} @indexes; ## no critic

    shift @rows; # Skip the separator between header and body

    my @parsed;
    my $num_of_indexes = scalar @indexes;
    for my $row (@rows) {
        my %parsed;
        my $begin = 0;
        for (my $i = 0; $i < $num_of_indexes; $i++) {
            my $range = $indexes_length[$i];
            my ($item) = substr($row, $begin + 1, $range) =~ /\A\s*(.*?)\s*\Z/;

            $begin += $range + 1;

            $parsed{$indexes[$i]} = $item eq "NULL" ? undef : $item;
        }
        push @parsed, \%parsed;
    }

    return \@parsed;
}

1;
__END__

=encoding utf-8

=head1 NAME

MySQL::Explain::Parser - It's new $module

=head1 SYNOPSIS

    use MySQL::Explain::Parser;

=head1 DESCRIPTION

MySQL::Explain::Parser is ...

=head1 LICENSE

Copyright (C) moznion.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

moznion E<lt>moznion@gmail.comE<gt>

=cut

