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
use lib "./lib/JSON";
use PP;

#Host returns a Host struct from the output of the host
#fetcher command. Host fields output is in key: value format separated by a newline
sub Filesystems {
    no warnings 'uninitialized';
    my $cmdOutput = shift;
    my $lines = "";

    for my $c (split /\n/, $cmdOutput) {
        $lines .= "{";
        my $line = $c;
        $line = join(" ", split(' ', $line));
        my ($filesystem, $fstype, $size, $used, $available, $usedperc, $mountedon) = split (' ', $line);
        $lines.= marshalKey("filesystem").marshalString(trim($filesystem)).", ";
        $lines.= marshalKey("type").marshalString(trim($fstype)).", ";
        $lines.= marshalKey("size").parseInt(trim($size)).", ";
        $lines.= marshalKey("usedSpace").parseInt(trim($used)).", ";
        $lines.= marshalKey("availableSpace").parseInt(trim($available)).", ";
        $lines.= marshalKey("mountedOn").marshalString(trim($mountedon)).", ";
        $lines.= "}\n";
    }

    $lines =~ s/, }/}/g;
    $lines =~ s/},]/}]/g;

    my @filesystem = split ("\n", $lines);

    my @m;

    for my $i (@filesystem){
        my $lines = $i;
        my $fs = JSON::PP::decode_json($lines);

        push(@m, $fs);
    }

    return @m;
}

1;
