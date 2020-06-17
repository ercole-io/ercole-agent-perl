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
        } elsif ($key eq "Cpufrequency"){
            $key = "CPUFrequency";
        } elsif ($key eq "Cpusockets"){
            $key = "CPUSockets";
        } elsif ($key eq "Threadspercore"){
            $key = "ThreadsPerCore";
        } elsif ($key eq "Corespersocket"){
            $key = "CoresPerSocket";
        } elsif ($key eq "Os"){
            $key = "OS";
        } elsif ($key eq "Osversion"){
            $key = "OSVersion";
        } elsif ($key eq "Kernelversion"){
            $key = "KernelVersion";
        } elsif ($key eq "Memorytotal"){
            $key = "MemoryTotal";
        } elsif ($key eq "Swaptotal"){
            $key = "SwapTotal";
        } elsif ($key eq "Oraclecluster"){
            next;
        } elsif ($key eq "Veritascluster"){
            next;
        } elsif ($key eq "Suncluster"){
            next;
        } elsif ($key eq "Aixcluster"){
            next;
        } elsif ($key eq "Virtual"){
            $key = "HardwareAbstraction";
        } elsif ($key eq "Type"){
            $key = "HardwareAbstractionTechnology";
        } 
        $value=trim($value);

        if ($key eq "CPUCores" || $key eq "CPUThreads" || $key eq "CPUSockets" || $key eq "MemoryTotal" || $key eq "SwapTotal" || $key eq "ThreadsPerCore" || $key eq "CoresPerSocket" ){
            $value = parseInt($value);
        } elsif ($key eq "HardwareAbstraction") {
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
