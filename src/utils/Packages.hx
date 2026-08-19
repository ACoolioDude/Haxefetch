package utils;

import sys.io.File;
import sys.FileSystem;

class Packages {
    public static function fetchPackage():String {
        #if sys
        var counts:Array<String> = [];
        var bedrockRoot = fetchBedrockPackages();

        for (root in bedrockRoot) {
            // Debian/GNU Linux based system (dpkg)
            if (FileSystem.exists(root + "/var/lib/dpkg/status")) {
                try {
                    var content = File.getContent(root + "/var/lib/dpkg/status");
                    var count = 0;
                    for (line in content.split("\n")) {
                        if (StringTools.startsWith(line, "Status: install ok installed")) {
                            count++;
                        }
                    }
                    if (count > 0) {
                        var entry = Configuration.packageManager ? '$count (dpkg)' : '${count}';
                        if (!counts.contains(entry)) {
                            counts.push(entry);
                        }
                    }
                } catch (e:Dynamic) {}
            }

            // RPM based system (rpm)
            if (FileSystem.exists(root + "/var/lib/rpm")) {
                var rpmCount = Haxefetch.executeCount("rpm", ["-qa"]);
                if (rpmCount > 0) {
                    var entry = Configuration.packageManager ? '$rpmCount (rpm)' : '${rpmCount}';
                    if (!counts.contains(entry)) {
                        counts.push(entry);
                    }
                }
            }

            // Arch Linux based system (pacman)
            if (FileSystem.exists(root + "/var/lib/pacman/local")) {
                try {
                    var entries = FileSystem.readDirectory(root + "/var/lib/pacman/local");
                    var count = entries.filter(e -> !StringTools.startsWith(e, "ALPM")).length;
                    if (count > 0) {
                        var entry = Configuration.packageManager ? '$count (pacman)' : '$count';
                        if (!counts.contains(entry)) {
                            counts.push(entry);
                        }
                    }
                } catch (e:Dynamic) {}
            }

            // Void Linux based system (xbps)
            if (FileSystem.exists(root + "/var/db/xbps")) {
                try {
                    var pkgs = FileSystem.readDirectory(root + "/var/db/xbps").filter(e -> StringTools.endsWith(e, ".plist"));
                    if (pkgs.length > 0) {
                        var entry = Configuration.packageManager ? '${pkgs.length} (xbps)' : '${pkgs.length}';
                        if (!counts.contains(entry)) {
                            counts.push(entry);
                        }
                    }
                } catch (e:Dynamic) {}
            }

            // Alpine Linux based system (apk)
            if (FileSystem.exists(root + "/lib/apk/db/installed")) {
                try {
                    var lines = File.getContent(root + "/lib/apk/db/installed").split("\n");
                    var count = lines.filter(l -> StringTools.startsWith(l, "P:")).length;
                    if (count > 0) {
                        var entry = Configuration.packageManager ? '$count (apk)' : '$count';
                        if (!counts.contains(entry)) {
                            counts.push(entry);
                        }
                    }
                } catch (e:Dynamic) {}
            }

            // NixOS based system (nix)
            if (FileSystem.exists(root + '/home/${Sys.getEnv("USER")}/.nix-profile/etc/profile.d/nix.sh') || FileSystem.exists("/nix/store")) {
                var nixCount = Haxefetch.executeCount("nix-store", ["-q", "--requisites", "/run/current-system"]);
                if (nixCount > 0) {
                    var entry = Configuration.packageManager ? '$nixCount (nix)' : '${nixCount}';
                    if (!counts.contains(entry)) {
                        counts.push(entry);
                    }
                }
            }

            // Slackware Linux based system (slackpkg)
            if (FileSystem.exists(root + "/var/log/packages")) {
                try {
                    var total = FileSystem.readDirectory(root + "/var/log/packages").length;
                    if (total > 0) {
                        var entry = Configuration.packageManager ? '$total (pkgtools)' : '${total}';
                        if (!counts.contains(entry)) {
                            counts.push(entry);
                        }
                    }
                } catch (e:Dynamic) {}
            }

            // GNU Guix based system (guix)
            var path = Sys.getEnv("HOME") + "/.guix-profile/manifest";
            if (FileSystem.exists(path)) {
                try {
                    var line = File.getContent(path).split("\n");
                    var count = line.filter(l -> StringTools.contains(l, "(manifest-entry)")).length;
                    if (count > 0) {
                        var entry = Configuration.packageManager ? '$count (guix)' : '${count}';
                        if (!counts.contains(entry)) {
                            counts.push(entry);
                        }
                    }
                }
            }

            // Gentoo Linux based system (emerge/portage)
            if (FileSystem.exists(root + "/var/db/pkg")) {
                try {
                    var total = 0;
                    for (category in FileSystem.readDirectory(root + "/var/db/pkg")) {
                        var catPath = root + '/var/db/pkg/$category';
                        if (FileSystem.isDirectory(catPath)) {
                            total += FileSystem.readDirectory(catPath).length;
                        }
                    }
                    if (total > 0) {
                        var entry = Configuration.packageManager ? '$total (emerge)' : '${total}';
                        if (!counts.contains(entry)) {
                            counts.push(entry);
                        }
                    }
                } catch (e:Dynamic) {}
            }

            // Solus based system (eopkg)
            if (FileSystem.exists(root + "/var/lib/eopkg/package")) {
                try {
                    var count = FileSystem.readDirectory(root + "/var/lib/eopkg/package").length;
                    if (count > 0) {
                        var entry = Configuration.packageManager ? '$count (eopkg)' : '${count}';
                        if (!counts.contains(entry)) {
                            counts.push(entry);
                        }
                    }
                } catch (e:Dynamic) {}
            }

            // KISS Linux (kiss)
            if (FileSystem.exists(root + "/var/db/kiss/installed")) {
                try {
                    var count = FileSystem.readDirectory(root + "/var/db/kiss/installed").length;
                    if (count > 0) {
                        var entry = Configuration.packageManager ? '$count (kiss)' : '${count}';
                        if (!counts.contains(entry)) {
                            counts.push(entry);
                        }
                    }
                }
            }

            // Paldo Linux (upkg)
            if (FileSystem.exists(root + "/var/lib/upkg/db")) {
                try {
                    var count = FileSystem.readDirectory(root + "/var/lib/upkg/db").length;
                    if (count > 0) {
                        var entry = Configuration.packageManager ? '$count (upkg)' : '${count}';
                        if (!counts.contains(entry)) {
                            counts.push(entry);
                        }
                    }
                }
            }

            // PiSi Linux (pisi)
            if (FileSystem.exists(root + "/var/lib/pisi/package")) {
                try {
                    var count = FileSystem.readDirectory(root + "/var/lib/pisi/package").length;
                    if (count > 0) {
                        var entry = Configuration.packageManager ? '$count (pisi)' : '${count}';
                        if (!counts.contains(entry)) {
                            counts.push(entry);
                        }
                    } 
                }
            }

            // Snaps
            var path = root + "/var/lib/snapd/snaps";
            if (FileSystem.exists(path)) {
                try {
                    var snaps = FileSystem.readDirectory(path).filter(e -> StringTools.endsWith(e, ".snap"));
                    if (snaps.length > 0) {
                        var count = snaps.length;
                        var entry = Configuration.packageManager ? '$count (snaps)' : '${count}';
                        if (!counts.contains(entry)) {
                            counts.push(entry);
                        }
                    }
                }
            }
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
        
        return counts.join(", ");
        #else
        return "Unknown";
        #end
    }

    private static function fetchBedrockPackages():Array<String> {
        var root:Array<String> = [];

        if (FileSystem.exists("/bedrock/bin/brl") && FileSystem.exists("/bedrock/strata")) {
            try {
                var strata = FileSystem.readDirectory("/bedrock/strata");
                for (str in strata) {
                    root.push("/bedrock/strata/" + str);
                }
                if (root.length > 0) return root;
            } catch (e:Dynamic) {}
        } return [""];
    }
}