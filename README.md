[![Build Status](https://travis-ci.org/moznion/MySQL-Explain-Parser.png?branch=master)](https://travis-ci.org/moznion/MySQL-Explain-Parser) [![Coverage Status](https://coveralls.io/repos/moznion/MySQL-Explain-Parser/badge.png?branch=master)](https://coveralls.io/r/moznion/MySQL-Explain-Parser?branch=master)
# NAME

MySQL::Explain::Parser - Parser for result of EXPLAIN of MySQL

# SYNOPSIS

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

# DESCRIPTION

MySQL::Explain::Parser is the parser for result of EXPLAIN of MySQL.

This module provides `parse()` function.
This function receives the result of EXPLAIN, and returns the parsed result as array reference that contains hash reference.

# FUNCTIONS

- parse($explain : Str)

    Returns the parsed result of EXPLAIN as ArrayRef\[HashRef\]. This function can be exported.

# LICENSE

Copyright (C) moznion.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# AUTHOR

moznion <moznion@gmail.com>
