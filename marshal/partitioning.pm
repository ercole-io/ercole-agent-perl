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

# Partitioning returns a list of partitioning from the output of the partitioning or partitioning_pdb fetcher command.

sub Partitioning {
    no warnings 'uninitialized';
    my $cmdOutput = shift;
    my @partitionings;

    for my $c (split /\n/, $cmdOutput) {
        my %partitioning;
        my $line = $c;
        my ($owner, $segmentname, $partitionname, $segmenttype, $mb) = split (/\|\|\|/, $line);

        $owner=trim($owner);
        $segmentname=trim($segmentname);
        $partitionname=trim($partitionname);
        $segmenttype=trim($segmenttype);
        $mb=parseNumber(trim($mb));

        $partitioning{'owner'} = $owner;
        $partitioning{'segmentName'} = $segmentname;
        $partitioning{'partitionName'} = $partitionname;
        $partitioning{'segmentType'} = $segmenttype;
        $partitioning{'mb'} = $mb;
        push(@partitionings, {%partitioning});
    }

return \@partitionings;

}

1;