use strict;
use warnings;
use utf8;
use MySQL::Explain::Parser qw/parse/;
use Test::More;
use Test::Deep;

my $explain = <<'...';
+----+-------------+------------+--------+---------------+---------+---------+----------------+------+-------------+
| id | select_type | table      | type   | possible_keys | key     | key_len | ref            | rows | Extra       |
+----+-------------+------------+--------+---------------+---------+---------+----------------+------+-------------+
|  1 | PRIMARY     | <derived2> | ALL    | NULL          | NULL    | NULL    | NULL           |  237 |             |
|  1 | PRIMARY     | Country    | eq_ref | PRIMARY       | PRIMARY | 3       | C1.CountryCode |    1 |             |
|  2 | DERIVED     | City       | ALL    | NULL          | NULL    | NULL    | NULL           | 4079 | Using where |
+----+-------------+------------+--------+---------------+---------+---------+----------------+------+-------------+
...

my $parsed = parse($explain);

cmp_deeply($parsed, [
    {
        id            => 1,
        select_type   => 'PRIMARY',
        table         => '<derived2>',
        type          => 'ALL',
        possible_keys => undef,
        key           => undef,
        key_len       => undef,
        ref           => undef,
        rows          => 237,
        Extra         => '',
    },
    {
        id            => 1,
        select_type   => 'PRIMARY',
        table         => 'Country',
        type          => 'eq_ref',
        possible_keys => 'PRIMARY',
        key           => 'PRIMARY',
        key_len       => 3,
        ref           => 'C1.CountryCode',
        rows          => 1,
        Extra         => '',
    },
    {
        id            => 2,
        select_type   => 'DERIVED',
        table         => 'City',
        type          => 'ALL',
        possible_keys => undef,
        key           => undef,
        key_len       => undef,
        ref           => undef,
        rows          => 4079,
        Extra         => 'Using where',
    },
]);

done_testing;

