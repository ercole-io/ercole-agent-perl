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

sub Database {
    no warnings 'uninitialized';
    my $cmdOutput = shift;
    my %db;

    for my $c (split /\n/, $cmdOutput) {
        my %patch;
        my $line = $c;
    
        my ($name, $uniqueName, $instanceNumber, $status, $version, 
            $platform, $archiveLog, $charset, $ncharset, $blockSize, 
            $cpuCount, $sgaTarget, $pgaTarget, $memoryTaget, $sgaMaxSize, 
            $segmentsSize, $datafileSize, $allocated, $elapsed, $dbtime, $dailycpuusage, $work, $asm, $dataguard) = split /\|\|\|/, $line;
        $name=trim($name);
        $uniqueName=trim($uniqueName);
        $instanceNumber=parseInt(trim($instanceNumber));
        $status=trim($status);
        $version=trim($version);
        $platform=trim($platform);
        $archiveLog=trim($archiveLog);
        $charset=trim($charset);
        $ncharset=trim($ncharset);
        $blockSize=parseInt(trim($blockSize));
        $cpuCount=parseInt(trim($cpuCount));
        $sgaTarget=parseNumber(trim($sgaTarget));
        $pgaTarget=parseNumber(trim($pgaTarget));
        $memoryTaget=parseNumber(trim($memoryTaget));
        $sgaMaxSize=parseNumber(trim($sgaMaxSize));
        $segmentsSize=parseNumber(trim($segmentsSize));
        $datafileSize=parseNumber(trim($datafileSize));
        $allocated=parseNumber(trim($allocated));
        $elapsed=parseNullableNumber(trim($elapsed));
        $dailycpuusage=parseNullableNumber(trim($dailycpuusage));
        $dbtime=parseNullableNumber(trim($dbtime));
        $work=parseNullableNumber(trim($work));
        $asm=parseBool(trim($asm));
        $dataguard=parseBool(trim($dataguard));

        if ($archiveLog eq "ARCHIVELOG"){
            $archiveLog=parseBool("Y");
        } elsif ($archiveLog eq "NOARCHIVELOG"){
            $archiveLog=parseBool("N");
        } else {
             die "archivelog value should be ARCHIVELOG or NOARCHIVELOG";
        }

        $db{'Name'} = $name;
        $db{'UniqueName'} = $uniqueName;
        $db{'InstanceNumber'} = $instanceNumber;
        $db{'Status'} = $status;
        $db{'Version'} = $version;
        $db{'Platform'} = $platform;
        $db{'Archivelog'} = $archiveLog;
        $db{'Charset'} = $charset;
        $db{'NCharset'} = $ncharset;
        $db{'BlockSize'} = $blockSize;
        $db{'CPUCount'} = $cpuCount;
        $db{'SGATarget'} = $sgaTarget;
        $db{'PGATarget'} = $pgaTarget;
        $db{'MemoryTarget'} = $memoryTaget;
        $db{'SGAMaxSize'} = $sgaMaxSize;
        $db{'SegmentsSize'} = $segmentsSize;
        $db{'DatafileSize'} = $datafileSize;
        $db{'Allocated'} = $allocated;
        $db{'Elapsed'} = $elapsed;
        $db{'DBTime'} = $dbtime;
        $db{'DailyCPUUsage'} = $dailycpuusage;
        $db{'Work'} = $work;
        $db{'ASM'} = parseBool($asm);
        $db{'Dataguard'} = parseBool($dataguard);
	    if ($dailycpuusage eq '') {
		    $db{'DailyCPUUsage'} = $work;
    	}

        #empty fields
        $db{'Patches'}=[];
        $db{'Tablespaces'}=[];
        $db{'Schemas'}=[];
        $db{'Features'}=[];
        $db{'Licenses'}=[];
        $db{'ADDMs'}=[];
        $db{'SegmentAdvisors'}=[];
        $db{'PSUs'}=[];
        $db{'Backups'}=[];
        $db{'FeatureUsageStats'}=[];
    }

    return %db;
}

1;