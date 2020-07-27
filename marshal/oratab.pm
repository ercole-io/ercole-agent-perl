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

# Licenses returns a list of licenses from the output of the licenses fetcher command.
sub Oratab { 
    no warnings 'uninitialized';
    my $cmdOutput = shift;

	my @oratab;
    for my $line (split /\n/, $cmdOutput) {
        my ($dbname, $oraclehome) = split /:/, $line;
        my %oratabEntry;
        $dbname=trim($dbname);
        $oraclehome=trim($oraclehome);

        $oratabEntry{'dbName'} = $dbname;
        $oratabEntry{'oracleHome'} = $oraclehome;

        push(@oratab, {%oratabEntry});
    }
    return @oratab;
}

sub RunningDatabases { 
    no warnings 'uninitialized';
    my $cmdOutput = shift;

	my @list = ();
    for my $line (split /\n/, $cmdOutput) {
        my $line = trim($line);
    
        next if $line eq "";

        push(@list, $line);
    }
    return @list;
}

1;