#!/usr/bin/perl

# Copyright (c) 2022 Sorint.lab S.p.A.
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

# GrantDba returns a list of grants from the output of the grant_dba fetcher command.

sub GrantDba {
    no warnings 'uninitialized';
    my $cmdOutput = shift;
    my @grants;

    for my $c (split /\n/, $cmdOutput) {
        my %grant;
        my $line = $c;
        my ($grantee, $adminoption, $defaultrole) = split (/\|\|\|/, $line);

        $grantee=trim($grantee);
        $adminoption=trim($adminoption);
        $defaultrole=trim($defaultrole);

        $grant{'grantee'} = $grantee;
        $grant{'adminOption'} = $adminoption;
        $grant{'defaultRole'} = $defaultrole;
        push(@grants, {%grant});
    }

return \@grants;

}

1;