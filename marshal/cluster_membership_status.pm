#!/usr/bin/perl

# Copyright (c) 2020 Sorint.lab S.p.A.
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

#ClusterMembershipStatus returns a ClusterMembershipStatus struct from the output of the host
#fetcher command. Host fields output is in key: value format separated by a newline
sub ClusterMembershipStatus {
    no warnings 'uninitialized';
    my $cmdOutput = shift;
    my %cms;

    for my $c (split /\n/, $cmdOutput) {
        my $line = $c;
        my ($key, $value) = split /:/, $line;
        $key=trim($key);
        $key =~ s{(\w+)}{\u\L$1}g;
        if ($key eq "Oraclecluster"){
            $cms{"oracleClusterware"} = parseBool(trim($value));
        } elsif ($key eq "Veritascluster"){
            $cms{"veritasClusterServer"} = parseBool(trim($value));
        } elsif ($key eq "Suncluster"){
            $cms{"sunCluster"} = parseBool(trim($value));
        } elsif ($key eq "Aixcluster"){
            $cms{"hacmp"} = parseBool(trim($value));
        } 
        $value=trim($value);
    }

    return %cms;
}

1;
