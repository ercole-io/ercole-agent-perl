#!/usr/bin/perl

# Copyright (c) 2019 Sorint.lab S.p.A.
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

package marshal;

use strict;
use warnings;
use diagnostics;
use lib "./marshal";
use common;


sub Schemas {
    no warnings 'uninitialized';
    my $cmdOutput = shift;
    my @schemas;

    for my $c (split /\n/, $cmdOutput) {
        my %schema;
        my $line = $c;
        my (undef, undef, $database, $user, $total, $tables, $indexes, $lob) = split /\|\|\|/, $line;
        $database=trim($database);
        $user=trim($user);
        $total=trim($total);
        $tables=trim($tables);
        $indexes=trim($indexes);
        $lob=trim($lob);
        $schema{'Database'} = $database;
        $schema{'User'} = $user;
        $schema{'Total'} = parseInt($total);
        $schema{'Tables'} = parseInt($tables);
        $schema{'Indexes'} = parseInt($indexes);
        $schema{'LOB'} = parseInt($lob);

        push(@schemas, {%schema});
    }

    return \@schemas;
}


1;


