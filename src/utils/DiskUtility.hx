package utils;

#if cpp
@:headerCode('
#include <sys/statvfs.h>
#include <stdio.h>
#include <string.h>
#include <mntent.h>
')
#end

class DiskUtility {
    public static function fetchDisk():String {
        var diskString:String = "N/A";

        #if cpp
        var result:String = "";

        untyped __cpp__('
            struct statvfs stat;
            char fsType[32] = "unknown";

            if (statvfs("/", &stat) == 0) {
                FILE* mounts = setmntent("/proc/mounts", "r");
                if (mounts != NULL) {
                    struct mntent* ent;
                    while ((ent = getmntent(mounts)) != NULL) {
                        if (strcmp(ent->mnt_dir, "/") == 0) {
                            snprintf(fsType, sizeof(fsType), "%s", ent->mnt_type);
                            break;
                        }
                    }
                    endmntent(mounts);
                }

                unsigned long long total = (unsigned long long)stat.f_blocks * stat.f_frsize;
                unsigned long long free = (unsigned long long)stat.f_bavail * stat.f_frsize;
                unsigned long long used = total - free;

                double usedGiB = (double)used / 1073741824.0;
                double totalGiB = (double)total / 1073741824.0;
                int percent = (int)(((double)used / (double)total) * 100.0);

                const char* colorCode = "\\033[32m"; 
                if (percent >= 85) {
                    colorCode = "\\033[31m";
                } else if (percent >= 60) {
                    colorCode = "\\033[33m";
                }
                const char* resetCode = "\\033[0m";

                char buffer[256];
                snprintf(buffer, sizeof(buffer), "%.1f GiB / %.1f GiB (%s%d%%%s) [%s]", 
                         usedGiB, totalGiB, colorCode, percent, resetCode, fsType);
                result = String(buffer);
            }
        ');

        if (result != "") {
            return result;
        }
        #end

        return diskString;
    }
}