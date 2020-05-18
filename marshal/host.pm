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

#Host returns a Host struct from the output of the host
#fetcher command. Host fields output is in key: value format separated by a newline
sub Host {
    no warnings 'uninitialized';
    my $cmdOutput = shift;
    my %host;

    for my $c (split /\n/, $cmdOutput) {
        my $line = $c;
        my ($key, $value) = split /:/, $line;
        $key=trim($key);
        $key =~ s{(\w+)}{\u\L$1}g;
        if ($key eq "Cpumodel"){
            $key = "CPUModel";
        } elsif ($key eq "Cpucores"){
            $key = "CPUCores";
        } elsif ($key eq "Cputhreads"){
            $key = "CPUThreads";
        } elsif ($key eq "Os"){
            $key = "OS";
        } elsif ($key eq "Memorytotal"){
            $key = "MemoryTotal";
        } elsif ($key eq "Swaptotal"){
            $key = "SwapTotal";
        } elsif ($key eq "Oraclecluster"){
            $key = "OracleCluster";
        } elsif ($key eq "Veritascluster"){
            $key = "VeritasCluster";
        } elsif ($key eq "Suncluster"){
            $key = "SunCluster";
        } 
        $value=trim($value);

        if ($key eq "CPUCores" || $key eq "CPUThreads" || $key eq "Socket" || $key eq "MemoryTotal" || $key eq "SwapTotal"){
            $value = parseInt($value);
        } elsif ($key eq "OracleCluster" || $key eq "VeritasCluster" || $key eq "SunCluster" || $key eq "Virtual"){
            $value = parseBool($value);
        }

        $host{$key} = $value;
    }

    return %host;
}

1;