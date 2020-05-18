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

# PSU returns a PSU hash from the output of the PSU
# fetcher command. Host fields output is in CSV format separated by '|||'
sub PSU {
    no warnings 'uninitialized';
    my $cmdOutput = shift;
    my @psus;

    for my $c (split /\n/, $cmdOutput) {
        my %psu;
        my $line = $c;
        my ($description, $date) = split /\|\|\|/, $line;
        $description=trim($description);
        $date=trim($date);
        $psu{'Description'} = $description;
        $psu{'Date'} = $date;
        push(@psus, {%psu});
    }

    return \@psus;
}

1;