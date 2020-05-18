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

sub Features2 {
    no warnings 'uninitialized';
    my $cmdOutput = shift;
    my @features;

    for my $c (split /\n/, $cmdOutput) {
        my %feature;
        my $line = $c;
        my ($product, $feature, $detectedUsages, $currentlyUsed, $firstUsageDate, $lastUsageDate, $extraFeatureInfo) = split /\|\|\|/, $line;
        $product=trim($product);
        $feature=trim($feature);
        $detectedUsages=trim($detectedUsages);
        $currentlyUsed=trim($currentlyUsed);
        $firstUsageDate=trim($firstUsageDate);
        $lastUsageDate=trim($lastUsageDate);
        $extraFeatureInfo=trim($extraFeatureInfo);

        $feature{'Product'} = $product;
        $feature{'Feature'} = $feature;
        $feature{'DetectedUsages'} = parseInt($detectedUsages);
        $feature{'CurrentlyUsed'} = parseBool($currentlyUsed);
        $feature{'FirstUsageDate'} = $firstUsageDate;
        $feature{'LastUsageDate'} = $lastUsageDate;
        $feature{'ExtraFeatureInfo'} = $extraFeatureInfo;      

        push(@features, {%feature});
    }

    return \@features;
}

1;