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

package logger;

use strict;
use warnings;
use diagnostics;


sub setLogDirectory{
    my $logDirectory = shift;
    if ( $logDirectory eq '' ) {
        return;
    }

    $logger::logDirectory = $logDirectory;
    print "ercole-agent will log on: $logger::logDirectory\n";
}


sub printLn {
    my @message = @_;
    my $time = getTime();

    if ( $logger::logDirectory eq '' ) {
        print "$time @message\n";
        return;
    }

    open my $log, ">>", "$logger::logDirectory/ercole-agent.log"
      or die "$logger::logDirectory/ercole-agent.log couldn't be opened: $!";

    print $log "$time @message\n";

    return;
}


sub getTime {
    my $ymd = sub{
        sprintf '%04d/%02d/%02d',$_[5]+1900, $_[4]+1, $_[3];
      }
      ->(localtime);

    my $time = $ymd." ";
    my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime();

    return $time . sprintf("%02d:%02d:%02d", $hour, $min, $sec) ;
}


1;