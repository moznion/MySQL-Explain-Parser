[![Build Status](https://travis-ci.org/moznion/MySQL-Explain-Parser.png?branch=master)](https://travis-ci.org/moznion/MySQL-Explain-Parser) [![Coverage Status](https://coveralls.io/repos/moznion/MySQL-Explain-Parser/badge.png?branch=master)](https://coveralls.io/r/moznion/MySQL-Explain-Parser?branch=master)
# NAME

MySQL::Explain::Parser - Parser for result of EXPLAIN of MySQL

# SYNOPSIS

    use utf8;
    use MySQL::Explain::Parser qw/parse/;

    my $explain = <<'...';
    +----+-------------+-------+-------+---------------+---------+---------+------+------+----------+-------------+
    | id | select_type | table | type  | possible_keys | key     | key_len | ref  | rows | filtered | Extra       |
    +----+-------------+-------+-------+---------------+---------+---------+------+------+----------+-------------+
    |  1 | PRIMARY     | t1    | index | NULL          | PRIMARY | 4       | NULL | 4    | 100.00   |             |
    |  2 | SUBQUERY    | t2    | index | a             | a       | 5       | NULL | 3    | 100.00   | Using index |
    +----+-------------+-------+-------+---------------+---------+---------+------+------+----------+-------------+
    ...

    my $parsed = parse($explain);
    # =>
    #    [
    #        {
    #            'id'            => '1',
    #            'select_type'   => 'PRIMARY',
    #            'table'         => 't1',
    #            'type'          => 'index',
    #            'possible_keys' => undef,
    #            'key'           => 'PRIMARY',
    #            'key_len'       => '4',
    #            'ref'           => undef
    #            'rows'          => '4',
    #            'filtered'      => '100.00',
    #            'Extra'         => '',
    #        },
    #        {
    #            'id'            => '2',
    #            'select_type'   => 'SUBQUERY',
    #            'table'         => 't2',
    #            'type'          => 'index',
    #            'possible_keys' => 'a',
    #            'key'           => 'a',
    #            'key_len'       => '5',
    #            'ref'           => undef
    #            'rows'          => '3',
    #            'filtered'      => '100.00',
    #            'Extra'         => 'Using index',
    #        }
    #    ]
]

# DESCRIPTION

MySQL::Explain::Parser is the parser for result of EXPLAIN of MySQL.

This module provides `parse()` function.
This function receives the result of EXPLAIN, and returns the parsed result as array reference that contains hash reference.

This module treat SQL's `NULL` as Perl's `undef`.

# FUNCTIONS

- parse($explain : Str)

    Returns the parsed result of EXPLAIN as ArrayRef\[HashRef\]. This function can be exported.

    Please refer to the following page to get information about format of EXPLAIN result: [http://dev.mysql.com/doc/refman/5.6/en/explain-output.html](http://dev.mysql.com/doc/refman/5.6/en/explain-output.html)

- parse\_extended($explain : Str)

    Returns the parsed result of EXPLAIN EXTENDED as ArrayRef\[HashRef\]. This function can be exported.

    Please refer to the following page to get information about format of EXPLAIN EXTENDED result: [http://dev.mysql.com/doc/refman/5.6/en/explain-extended.html](http://dev.mysql.com/doc/refman/5.6/en/explain-extended.html)

    e.g.
        my $explain = <<'...';
        \*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\* 1. row \*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*
                   id: 1
          select\_type: PRIMARY
                table: t1
                 type: index
        possible\_keys: NULL
                  key: PRIMARY
              key\_len: 4
                  ref: NULL
                 rows: 4
             filtered: 100.00
                Extra:
        \*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\* 2. row \*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*
                   id: 2
          select\_type: SUBQUERY
                table: t2
                 type: index
        possible\_keys: a
                  key: a
              key\_len: 5
                  ref: NULL
                 rows: 3
             filtered: 100.00
                Extra: Using index
        ...

        my $parsed = parse_extended($explain);

# LICENSE

Copyright (C) moznion.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# AUTHOR

moznion <moznion@gmail.com>
