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

# Charsetpdb returns PDB charset value from the output of the charset_pdb fetcher command.

sub Charsetpdb {
    no warnings 'uninitialized';
    my $cmdOutput = shift;
    my $charsetPDB;

    for my $c (split /\n/, $cmdOutput) {
        my $line = $c;
        
        my @values = split (/\|\|\|/, $line);
        if ( scalar @values ne 1 ) {
            next;
        }

        my ($charset) = split (/\|\|\|/, $line);

        $charsetPDB=trim($charset);
    }

    return $charsetPDB;
}

1;