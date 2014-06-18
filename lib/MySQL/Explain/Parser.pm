package MySQL::Explain::Parser;
use 5.008005;
use strict;
use warnings;
use utf8;
use parent "Exporter";

our $VERSION = "0.01";
our @EXPORT_OK = qw/parse parse_extended/;

sub parse {
    my ($explain) = @_;

    my @rows = split /\r?\n/, $explain;

    shift @rows; # Skip the top of outline

    # Skip bottom unnecessary line(s)
    if (pop(@rows) =~ /\A\d+\s+rows/) {
        pop @rows;
    }

    my $index_row = shift @rows;
    my @indexes = grep {$_} split /\|/, $index_row;
    my @indexes_length = map {length $_} @indexes;
    map {s/\s//g} @indexes; ## no critic

    shift @rows; # Skip the separator between header and body

    my @parsed;
    my $num_of_indexes = scalar @indexes;
    for my $row (@rows) {
        my %parsed;
        my $begin_pos = 0;
        for (my $i = 0; $i < $num_of_indexes; $i++) {
            my $length = $indexes_length[$i];
            my ($item) = substr($row, $begin_pos + 1, $length) =~ /\A\s*(.*?)\s*\Z/;

            $begin_pos += $length + 1;

            $parsed{$indexes[$i]} = $item eq 'NULL' ? undef : $item;
        }
        push @parsed, \%parsed;
    }

    return \@parsed;
}

sub parse_extended {
    my ($explain) = @_;

    my @parsed;
    my @explains;
    my @rows = split /\r?\n/, $explain;
    for my $row (@rows) {
        if ($row =~ /\A\*+\s\d/) {
            if (@explains) {
                push @parsed, _parse_yaml_like(\@explains);
            }
            @explains = ();
            next;
        }

        $row =~ s/\A\s*//;
        push @explains, $row;
    }

    if (@explains) {
        push @parsed, _parse_yaml_like(\@explains);
    }

    return \@parsed;
}

sub _parse_yaml_like {
    my ($explains) = @_;

    if ($explains->[-1] =~ /\A\d+\s+rows/) {
        pop @$explains;
    }

    my %parsed;
    for my $explain (@$explains) {
        (my $v = $explain) =~ s/\s*?([^:]*):\s*//;
        my $k = $1;
        if ($v eq 'NULL') {
            $v = undef;
        }
        $parsed{$k} = $v;
    }
    return \%parsed;
}

1;
__END__

=encoding utf-8

=head1 NAME

MySQL::Explain::Parser - Parser for result of EXPLAIN of MySQL

=head1 SYNOPSIS

    use utf8;
    use MySQL::Explain::Parser qw/parse/;

    my $explain = <<'...';
    +----+-------------+------------+--------+---------------+---------+---------+----------------+------+-------------+
    | id | select_type | table      | type   | possible_keys | key     | key_len | ref            | rows | Extra       |
    +----+-------------+------------+--------+---------------+---------+---------+----------------+------+-------------+
    |  1 | PRIMARY     | Country    | eq_ref | PRIMARY       | PRIMARY | 3       | C1.CountryCode |    1 |             |
    |  2 | DERIVED     | City       | ALL    | NULL          | NULL    | NULL    | NULL           | 4079 | Using where |
    +----+-------------+------------+--------+---------------+---------+---------+----------------+------+-------------+
    ...

    my $parsed = parse($explain);
    # =>
    #    [
    #        {
    #            id            => 1,
    #            select_type   => 'PRIMARY',
    #            table         => 'Country',
    #            type          => 'eq_ref',
    #            possible_keys => 'PRIMARY',
    #            key           => 'PRIMARY',
    #            key_len       => 3,
    #            ref           => 'C1.CountryCode',
    #            rows          => 1,
    #            Extra         => '',
    #        },
    #        {
    #            id            => 2,
    #            select_type   => 'DERIVED',
    #            table         => 'City',
    #            type          => 'ALL',
    #            possible_keys => undef,
    #            key           => undef,
    #            key_len       => undef,
    #            ref           => undef,
    #            rows          => 4079,
    #            Extra         => 'Using where',
    #        },
    #    ]
]

=head1 DESCRIPTION

MySQL::Explain::Parser is the parser for result of EXPLAIN of MySQL.

This module provides C<parse()> function.
This function receives the result of EXPLAIN, and returns the parsed result as array reference that contains hash reference.

=head1 FUNCTIONS

=over 4

=item * parse($explain : Str)

Returns the parsed result of EXPLAIN as ArrayRef[HashRef]. This function can be exported.

=back

=head1 LICENSE

Copyright (C) moznion.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

moznion E<lt>moznion@gmail.comE<gt>

=cut

