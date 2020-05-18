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

package config;

use strict;
use warnings;
use diagnostics;
use lib "./marshal";
use common;

# ReadConfig reads the configuration file from the current dir
# or /opt/ercole-agent
sub ReadConfig{
    my $baseDir = getBaseDir();
    my $configFile = $baseDir . "/config.json";
        
    if (not(-e $configFile)){
        $configFile = "/opt/ercole-agent/config.json";
    }

    my $err = open(my $FHR, '<', $configFile)
    or die "Cannot open the file or $!";

    my @lines = <$FHR>; #file into array
    
    #without this while, $! = Inappropriate ioctl for device
    while (<$FHR>){} #read file

    my $raw;
    if ($!){
        print "Unable to read configuration file: $!";
        print "\n";
    } else {
        $raw = join('', @lines); #array into string
    };
    close($FHR);
   
    $raw =~ s/{//g;
    $raw =~ s/}//g;
    $raw =~ s/":/"=>/g;
      
    my %config;

    my @list = split (/,/, $raw);

    foreach my $i (@list) {
        my ($key,$value)= split(/"=>/, $i);
        $key =~ s/"//g;
        $value=~ s/"//g;
        $key = marshal::trim($key);
        $value = marshal::trim($value);
        $config{$key} = $value;
    }
    
    if (not($config{"oratab"})){
        $config{"oratab"} = "/etc/oratab";
    }
    if (not($config{"hosttype"})){
        $config{"hosttype"} = "oracledb";
    }

    return %config;
}

sub getBaseDir {
    return $ENV{PWD};
}

1;