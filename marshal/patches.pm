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

sub Patches {
    no warnings 'uninitialized';
    my $cmdOutput = shift;
    my @patches;

    for my $c (split /\n/, $cmdOutput) {
        my %patch;
        my $line = $c;
        my (undef, undef, undef, $database, $version, $patchID, $action, $description, $date) = split /\|\|\|/, $line;
        $database=trim($database);
        $version=trim($version);
        $patchID=trim($patchID);
        $action=trim($action);
        $description=trim($description);
        $date=trim($date);
        $patch{'Database'} = $database;
        $patch{'Version'} = $version;
        $patch{'PatchID'} = $patchID;
        $patch{'Action'} = $action;
        $patch{'Description'} = $description;
        $patch{'Date'} = $date;
        
        push(@patches, {%patch});
    }

    return \@patches;
}

1;