package utils;

import sys.io.File;
import sys.FileSystem;

class Packages {
    public static function fetchPackage():String {
        #if sys
        var counts:Array<String> = [];

        // Debian/GNU Linux based system (dpkg)
        if (FileSystem.exists("/var/lib/dpkg/status")) {
            try {
                var content = File.getContent("/var/lib/dpkg/status");
                var count = 0;
                for (line in content.split("\n")) {
                    if (StringTools.startsWith(line, "Status: install ok installed")) {
                        count++;
                    }
                }
                if (count > 0) Configuration.packageManager ? counts.push('$count (dpkg)') : counts.push('$count');
            } catch (e:Dynamic) {}
        }

        // RPM based system (rpm)
        if (FileSystem.exists("/var/lib/rpm")) {
            var rpmCount = Haxefetch.executeCount("rpm", ["-qa"]);
            if (rpmCount > 0) Configuration.packageManager ? counts.push('$rpmCount (rpm)') : counts.push('${rpmCount}');
        }

        // Arch Linux based system (pacman)
        if (FileSystem.exists("/var/lib/pacman/local")) {
            try {
                var entries = FileSystem.readDirectory("/var/lib/pacman/local");
                var count = entries.filter(e -> !StringTools.startsWith(e, "ALPM")).length;
                Configuration.packageManager ? counts.push('$count (pacman)') : counts.push('$count');
            } catch (e:Dynamic) {}
        }

        // Void Linux based system (xbps)
        if (FileSystem.exists("/var/db/xbps")) {
            try {
                var pkgs = FileSystem.readDirectory("/var/db/xbps").filter(e -> StringTools.endsWith(e, ".plist"));
                Configuration.packageManager ? counts.push('${pkgs.length} (xbps)') : counts.push('${pkgs.length}');
            } catch (e:Dynamic) {}
        }

        // Alpine Linux based system (apk)
        if (FileSystem.exists("/lib/apk/db/installed")) {
            try {
                var lines = File.getContent("/lib/apk/db/installed").split("\n");
                var count = lines.filter(l -> StringTools.startsWith(l, "P:")).length;
                Configuration.packageManager ? counts.push('$count (apk)') : counts.push('$count');
            } catch (e:Dynamic) {}
        }

        // NixOS based system (nix)
        if (FileSystem.exists('/home/${Sys.getEnv("USER")}/.nix-profile/etc/profile.d/nix.sh') || FileSystem.exists("/nix/store")) {
            var nixCount = Haxefetch.executeCount("nix-store", ["-q", "--requisites", "/run/current-system"]);
            if (nixCount > 0) Configuration.packageManager ? counts.push('$nixCount (nix)') : counts.push('$nixCount');
        }

        // Slackware Linux based system (slackpkg)
        if (FileSystem.exists("/var/log/packages")) {
            try {
                var total = FileSystem.readDirectory("/var/log/packages").length;
                if (total > 0) Configuration.packageManager ? counts.push('$total (slackpkg)') : counts.push('$total');
            } catch (e:Dynamic) {}
        }

        // GNU Guix based system (guix)
        var user = Sys.getEnv("USER");
        var guixProfile = '/home/$user/.guix-profile';
        if (FileSystem.exists(guixProfile)) {
            try {
                var binPath = '$guixProfile/bin';
                if (FileSystem.exists(binPath)) {
                    var total = FileSystem.readDirectory(binPath).length;
                    Configuration.packageManager ? counts.push('$total (guix)') : counts.push('$total');
                }
            } catch (e:Dynamic) {}
        }

        // Gentoo Linux based system (emerge/portage)
        if (FileSystem.exists("/var/db/pkg")) {
            try {
                var total = 0;
                for (category in FileSystem.readDirectory("/var/db/pkg")) {
                    var catPath = '/var/db/pkg/$category';
                    if (FileSystem.isDirectory(catPath)) {
                        total += FileSystem.readDirectory(catPath).length;
                    }
                }
                if (total > 0) Configuration.packageManager ? counts.push('$total (emerge)') : counts.push('${total}');
            } catch (e:Dynamic) {}
        }

        // Solus based system (eopkg)
        if (FileSystem.exists("/var/lib/eopkg/package")) {
            try {
                var count = FileSystem.readDirectory("/var/lib/eopkg/package").length;
                return Configuration.packageManager ? '$count (eopkg)' : '${count}';
            } catch (e:Dynamic) {}
        }

        // Flatpak
        var path:Array<String> = [
            "/var/lib/flatpak/app", 
            Sys.getEnv("HOME") + "/.local/share/flatpak/app"
        ];
        var flatpaks = 0;

        for (paths in path) {
            if (paths != null && FileSystem.exists(paths) && FileSystem.isDirectory(paths)) {
                try {
                    flatpaks += FileSystem.readDirectory(paths).length;
                } catch (e:Dynamic) {}
            }
        }
        if (flatpaks > 0) {
            if (Configuration.packageManager) {
                counts.push('$flatpaks (flatpak)');
            } else { 
                counts.push('${flatpaks}');
            }
        }

        if (counts.length > 0) {
            return counts.join(", ");
        }

        #end
        return "Unknown";
    }
}