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

# SegmentAdvisor returns a SegmentAdvisor hash from the output of the SegmentAdvisor
# fetcher command. Host fields output is in CSV format separated by '|||'
sub SegmentAdvisor {
    no warnings 'uninitialized';
    my $cmdOutput = shift;
    my @segmentAdvisors;
    my $count = 0;


    for my $c (split /\n/, $cmdOutput) {
        my %segmentAdvisor;
        my $line = $c;
        my ($hostname, $dbname, $segmentOwner, $segmentName, $segmentType, $partitionName, $reclaimable, $recommendation) = split /\|\|\|/, $line;

        if ($count > 2) {
            $segmentOwner=trim($segmentOwner);
            $segmentName=trim($segmentName);
            $segmentType=trim($segmentType);
            $partitionName=trim($partitionName);
            $reclaimable=trim($reclaimable);
            $recommendation=trim($recommendation);
            $segmentAdvisor{'SegmentOwner'} = $segmentOwner;
            $segmentAdvisor{'SegmentName'} = $segmentName;
            $segmentAdvisor{'SegmentType'} = $segmentType;
            $segmentAdvisor{'PartitionName'} = $partitionName;
            $segmentAdvisor{'Reclaimable'} = $reclaimable;
            $segmentAdvisor{'Recommendation'} = $recommendation;
            push(@segmentAdvisors, {%segmentAdvisor});            
        }
        $count++;  
    }

    return \@segmentAdvisors;

}

1;