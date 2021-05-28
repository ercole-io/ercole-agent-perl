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

        my ($name, $dbID, $role, $uniqueName, $instanceNumber, $instanceName, $status, $version, $platform, $archiveLog,
            $charset, $ncharset, $blockSize,$cpuCount, $sgaTarget, $pgaTarget, $memoryTarget, $sgaMaxSize,
            $segmentsSize, $datafileSize, $allocable, $elapsed, $dbtime, $dailycpuusage, $work, $asm,
            $dataguard) = split /\|\|\|/, $line;
        $name=trim($name);
        $dbID=trim($dbID);
        $role=trim($role);
        $uniqueName=trim($uniqueName);
        $instanceNumber=parseInt(trim($instanceNumber));
        $instanceName=trim($instanceName);
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
        $memoryTarget=parseNumber(trim($memoryTarget));
        $sgaMaxSize=parseNumber(trim($sgaMaxSize));
        $segmentsSize=parseNumber(trim($segmentsSize));
        $datafileSize=parseNumber(trim($datafileSize));
        $allocable=parseNumber(trim($allocable));
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

        $db{'name'} = $name;
        $db{'dbID'} = $dbID;
        $db{'role'} = $role;
        $db{'uniqueName'} = $uniqueName;
        $db{'instanceNumber'} = $instanceNumber;
        $db{'instanceName'} = $instanceName;
        $db{'status'} = $status;
        $db{'version'} = $version;
        $db{'platform'} = $platform;
        $db{'archivelog'} = $archiveLog;
        $db{'charset'} = $charset;
        $db{'nCharset'} = $ncharset;
        $db{'blockSize'} = $blockSize;
        $db{'cpuCount'} = $cpuCount;
        $db{'sgaTarget'} = $sgaTarget;
        $db{'pgaTarget'} = $pgaTarget;
        $db{'memoryTarget'} = $memoryTarget;
        $db{'sgaMaxSize'} = $sgaMaxSize;
        $db{'segmentsSize'} = $segmentsSize;
        $db{'datafileSize'} = $datafileSize;
        $db{'allocable'} = $allocable;
        $db{'elapsed'} = $elapsed;
        $db{'dbTime'} = $dbtime;
        $db{'dailyCPUUsage'} = $dailycpuusage;
        $db{'work'} = $work;
        $db{'asm'} = parseBool($asm);
        $db{'dataguard'} = parseBool($dataguard);

        if ($dailycpuusage eq '') {
            $db{'dailyCPUUsage'} = $work;
        }

        #empty fields
        $db{'patches'}=[];
        $db{'tablespaces'}=[];
        $db{'schemas'}=[];
        $db{'licenses'}=[];
        $db{'addms'}=[];
        $db{'segmentAdvisors'}=[];
        $db{'psus'}=[];
        $db{'backups'}=[];
        $db{'featureUsageStats'}=[];
        $db{'services'}=[];
    }

    return %db;
}

1;
