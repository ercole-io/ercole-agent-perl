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

# Tablespaces returns information about database tablespaces extracted
# from the tablespaces fetcher command output.
sub Tablespaces {
    no warnings 'uninitialized';
    my $cmdOutput = shift;
    my @tablespaces;

    for my $c (split /\n/, $cmdOutput) {
        my %tablespace;
        my $line = $c;
        my (undef, undef, $database, $name, $maxSize, $total, $used, $usedPerc, $status) = split /\|\|\|/, $line;
        $database=trim($database);
        $name=trim($name);
        $maxSize=trim($maxSize);
        $total=trim($total);
        $used=trim($used);
        $usedPerc=trim($usedPerc);
        $status=trim($status);
        $tablespace{'Database'} = $database;
        $tablespace{'Name'} = $name;
        $tablespace{'MaxSize'} = $maxSize;
        $tablespace{'Total'} = $total;
        $tablespace{'Used'} = $used;
        $tablespace{'UsedPerc'} = $usedPerc;
        $tablespace{'Status'} = $status;

        push(@tablespaces, {%tablespace});
    }

    return \@tablespaces;
}

1;