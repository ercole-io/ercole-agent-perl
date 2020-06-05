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
            $segmentsSize, $used, $allocated, $elapsed, $dbtime, $dailycpuusage, $work, $asm, $dataguard) = split /\|\|\|/, $line;
        $name=trim($name);
        $uniqueName=trim($uniqueName);
        $instanceNumber=trim($instanceNumber);
        $status=trim($status);
        $version=trim($version);
        $platform=trim($platform);
        $archiveLog=trim($archiveLog);
        $charset=trim($charset);
        $ncharset=trim($ncharset);
        $blockSize=trim($blockSize);
        $cpuCount=trim($cpuCount);
        $sgaTarget=trim($sgaTarget);
        $pgaTarget=trim($pgaTarget);
        $memoryTaget=trim($memoryTaget);
        $sgaMaxSize=trim($sgaMaxSize);
        $segmentsSize=trim($segmentsSize);
        $used=trim($used);
        $allocated=trim($allocated);
        $elapsed=trim($elapsed);
        $dailycpuusage=trim($dailycpuusage);
        $dbtime=trim($dbtime);
        $work=trim($work);
        $asm=trim($asm);
        $dataguard=trim($dataguard);

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
        $db{'Used'} = $used;
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
        $db{'Features2'}=[];
        $db{'Licenses'}=[];
        $db{'ADDMs'}=[];
        $db{'SegmentAdvisors'}=[];
        $db{'LastPSUs'}=[];
        $db{'Backups'}=[];
    }

    return %db;
}

1;