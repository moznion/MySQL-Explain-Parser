#!/usr/bin/env perl

use strict;
use warnings;
use utf8;
use Data::Dumper;
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
print Dumper($parsed);

