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
            $key = "cpuModel";
        } elsif ($key eq "Cpucores"){
            $key = "cpuCores";
        } elsif ($key eq "Cputhreads"){
            $key = "cpuThreads";
        } elsif ($key eq "Cpufrequency"){
            $key = "cpuFrequency";
        } elsif ($key eq "Cpusockets"){
            $key = "cpuSockets";
        } elsif ($key eq "Threadspercore"){
            $key = "threadsPerCore";
        } elsif ($key eq "Corespersocket"){
            $key = "coresPerSocket";
        } elsif ($key eq "Os"){
            $key = "os";
        } elsif ($key eq "Osversion"){
            $key = "osVersion";
        } elsif ($key eq "Kernelversion"){
            $key = "kernelVersion";
        } elsif ($key eq "Memorytotal"){
            $key = "memoryTotal";
        } elsif ($key eq "Swaptotal"){
            $key = "swapTotal";
        } elsif ($key eq "Oraclecluster"){
            next;
        } elsif ($key eq "Veritascluster"){
            next;
        } elsif ($key eq "Suncluster"){
            next;
        } elsif ($key eq "Aixcluster"){
            next;
        } elsif ($key eq "Virtual"){
            $key = "hardwareAbstraction";
        } elsif ($key eq "Type"){
            $key = "hardwareAbstractionTechnology";
        } 
        $value=trim($value);

        if ($key eq "cpuCores" || $key eq "cpuThreads" || $key eq "cpuSockets" || $key eq "memoryTotal" || $key eq "swapTotal" || $key eq "threadsPerCore" || $key eq "coresPerSocket" ){
            $value = parseInt($value);
        } elsif ($key eq "hardwareAbstraction") {
            $value = parseBool($value);
            if ($value eq parseBool("Y")) {
                $value = "VIRT";
            } else {
                $value = "PH";
            }
        }

        $host{$key} = $value;
    }

    return %host;
}

1;
