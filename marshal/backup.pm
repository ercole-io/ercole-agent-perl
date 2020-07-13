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

# Backups returns a Backups hash from the output of the backups
# fetcher command. Host fields output is in CSV format separated by '|||'
sub Backups {
    no warnings 'uninitialized';
    my $cmdOutput = shift;
    my @backups;

    for my $c (split /\n/, $cmdOutput) {
        my %backup;
        my $line = $c;
        my @weekDaysArray;
        my ($backupType, $hour, $weekDays, $avgBckSize, $retention) = split /\|\|\|/, $line;
        $backupType=trim($backupType);
        $hour=trim($hour);
        @weekDaysArray=split /,/, trim($weekDays);
        $avgBckSize=parseNumber(trim($avgBckSize));
        $retention=trim($retention);
        $backup{'backupType'} = $backupType;
        $backup{'hour'} = $hour;
        $backup{'weekDays'} = \@weekDaysArray;
        $backup{'avgBckSize'} = $avgBckSize;
        $backup{'retention'} = $retention;
        push(@backups, {%backup});
    }

    return \@backups;
}

1;