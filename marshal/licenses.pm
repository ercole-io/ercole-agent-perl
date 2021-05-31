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
sub Licenses {
    no warnings 'uninitialized';
    my $cmdOutput = shift;
    my @licenses;

    for my $c (split /\n/, $cmdOutput) {
        my %license;
        my $line = $c;

        my $count = () = $line =~ /;/g; #count the number of ";". If they are 2, there are 3 string maybe empty

        if (($count+1) == 3){
            my ($key, $value) = split /;/, $line;
            $key=trim($key);
            $value=trim($value);
            my $old = "\t";
            my $new = "" ;
            $value =~ s/$old/$new/g;
            $license{'name'} = $key;
            $license{'count'} = parseCount($value);
            push(@licenses, {%license});
        }
    }

    return \@licenses;

}

1;