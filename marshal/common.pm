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
use lib "./lib/JSON";
use PP;


sub marshalValue {
    no warnings 'uninitialized';
    my $s = shift;

    if ($s eq "Y" || $s eq "N"){
        return parseBool();
    }

    if ($s eq ""){
        return "\""."\"";
    }

    if ($s =~ /\D/) {

        # is not a number
        return "\"".$s."\"";
    } else {

        # is a number
        return $s;
    }
}


sub marshalString {
    my $s = shift;
    return "\"" . $s . "\"";
}


sub marshalKey {
    my $s = shift;
    return "\"" . $s . "\" : ";
}


sub trim {
    no warnings 'uninitialized';
    my $s = shift;
    $s =~ s/^\s+|\s+$//g;
    return $s;
}


sub parseBool {
    no warnings 'uninitialized';
    my $s = shift;

    my $json = '{"true": true, "false": false}';
    my $jsondec = JSON::PP::decode_json $json;
    my $t = $jsondec->{true};
    my $f = $jsondec->{false};

    if ($s eq "Y"){
        $s = $t;
    } elsif ($s eq "TRUE") {
        $s = $t;
    } else {
        $s = $f;
    }
    return $s;

    # $feature{'Status'} = $f;
    # if ($value eq "Y"){
    #     $feature{'Status'} = $t;
    # }


    # if ($s eq "Y"){
    #     return "true";
    # } else {
    #     return "false";
    # }
}

#arrive a string and we convert it into an int;
sub parseInt {
    my $s = shift;

    die "Cannot convert ".$s."to int" unless $s =~ m/[-+]?[0-9]+/;

    return $s + 0;
}


sub parseNumber {
    my $s = shift;

    $s =~ s/,/\./ ;

    die "Cannot convert \"".$s."\" to number" unless $s =~ m/[-+]?[0-9]*\.?[0-9]+/;

    return $s + 0.0;
}


sub parseNullableNumber {
    my $s = shift;

    my $null;
    if ($s eq "") {
        return $null;
    } elsif ($s eq "N/A") {
        return $null;
    } else {
        return parseNumber($s);
    }
}


#s is supposed to be non null and already trimmed
sub parseCount { #to improve
    my $s = shift; #string

    if ($s eq "") {
        return 0;
    }

    return parseInt($s);
}


sub logPrintln {
    my @s = @_;

    getTime();

    print @s;
    print "\n";
}


sub getTime {
    my $ymd = sub{
        sprintf '%04d/%02d/%02d',$_[5]+1900, $_[4]+1, $_[3];
      }
      ->(localtime);

    print STDERR $ymd." ";
    my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime();

    printf STDERR ("%02d:%02d:%02d", $hour, $min, $sec);
    print STDERR " ";
}

1;
