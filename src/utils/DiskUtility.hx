package utils;

import haxe.display.Display.Package;
#if cpp
@:headerCode('
#include <sys/statvfs.h>
#include <stdio.h>
')
#end

class DiskUtility {
    public static function fetchDisk():String {
        #if cpp
        var result:String = "";
        untyped __cpp__('
            struct statvfs stat;
            if (statvfs("/", &stat) == 0) {
                unsigned long long total = (unsigned long long)stat.f_blocks * stat.f_frsize;
                unsigned long long free = (unsigned long long)stat.f_bavail * stat.f_frsize;
                unsigned long long used = total - free;

                double usedGiB = (double)used / 1073741824.0;
                double totalGiB = (double)total / 1073741824.0;
                int percent = (int)(((double)used / (double)total) * 100.0);

                char buffer[64];
                snprintf(buffer, sizeof(buffer), "%.1f GiB / %.1f GiB (%d%%)", usedGiB, totalGiB, percent);
                result = String(buffer);
            }
        ');
        return result;
        #else
        return "N/A";
        #end
    }
}