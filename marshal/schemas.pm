#!/usr/bin/perl

# Copyright (c) 2022 Sorint.lab S.p.A.
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
        my (undef, undef, $user, $total, $tables, $indexes, $lob, $accountStatus) = split /\|\|\|/, $line;
        $user=trim($user);
        $total=parseInt(trim($total));
        $tables=parseInt(trim($tables));
        $indexes=parseInt(trim($indexes));
        $lob=parseInt(trim($lob));
        $accountStatus=trim($accountStatus);
        $schema{'user'} = $user;
        $schema{'total'} = $total;
        $schema{'tables'} = $tables;
        $schema{'indexes'} = $indexes;
        $schema{'lob'} = $lob;
        $schema{'accountStatus'} = $accountStatus;

        push(@schemas, {%schema});
    }

    return \@schemas;
}


1;


