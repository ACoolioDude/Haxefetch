package utils;

import haxe.macro.Compiler;
import sys.FileSystem;
import sys.io.File;
import sys.io.Process;

class SystemUtils {
    public static function fetchHost():String {
        #if sys
        if (FileSystem.exists("/etc/hostname")) {
            return StringTools.trim(File.getContent("/etc/hostname"));
        }
        #end
        return "Haxefetch";
    }

    public static function fetchDistro():String {
        #if sys
        if (FileSystem.exists("/etc/os-release")) {
            try {
                var lines = File.getContent("/etc/os-release").split("\n");
                for (line in lines) {
                    var cleanLine = StringTools.trim(line);

                    if (StringTools.startsWith(cleanLine, "PRETTY_NAME=")) {
                        var parts = cleanLine.split("=");
                        if (parts.length > 1) {
                            var name = parts[1];
                            return StringTools.replace(name, "\"", "");
                        }
                    }
                }
            } catch (e:Dynamic) {}
        }
        #end
        return Sys.systemName();
    }

    public static function fetchInit():String {
        if (FileSystem.exists("/run/systemd/system")) return "systemD";
        if (FileSystem.exists("/run/openrc") || FileSystem.exists("/run/openrc/softlevel")) return "OpenRC";
        if (FileSystem.exists("/run/runit")) return "Runit";
        if (FileSystem.exists("/run/dinit")) return "Dinit";
        if (FileSystem.exists("/run/s6")) return "S6";
        
        var rawCommand = Haxefetch.runCmd("ps", ["-p", "1", "-o", "comm="]);
        var command = StringTools.trim(rawCommand);

        if (command != "" && command != "N/A") {
            switch (command) {
                case "systemd": return "systemD";
                case "openrc-init": return "OpenRC";
                case "runit": return "Runit";
                case "dinit": return "Dinit";
                case "s6-svscan": return "S6";
                default: return command;
            }
        }

        return "Unknown";
    }

    public static function fetchKernel():String {
        try {
            var p = new Process("uname", ["-r"]);
            var kernel = StringTools.trim(p.stdout.readLine());
            p.close();
            return kernel;
        } catch (e:Dynamic) {
            return Sys.systemName();
        }
    }

    public static function fetchDestkop():Null<String> {
        var environmentKey = ["XDG_CURRENT_DESKTOP", "XDG_SESSION_DESKTOP", "DESKTOP_SESSION", "CURRENT_DESKTOP"];
        var rawEnvironment:String = "";

        for (key in environmentKey) {
            var value = Sys.getEnv(key);
            if (value != null && StringTools.trim(value) != "") {
                rawEnvironment = value;
                break;
            }
        }
        if (rawEnvironment == "") return null;

        var part = rawEnvironment.split(":");
        for (parts in part) {
            var token = StringTools.trim(parts).toUpperCase();
            if (token == "") continue;

            if (token.indexOf("GNOME") != -1) return "GNOME";
            if (token.indexOf("KDE") != -1 || token.indexOf("PLASMA") != -1) return "KDE Plasma";
            if (token.indexOf("CINNAMON") != -1) return "Cinnamon";
            if (token.indexOf("XFCE") != -1) return "XFCE";
            if (token.indexOf("MATE") != -1) return "MATE";
            if (token.indexOf("BUDGIE") != -1) return "Budgie";
            if (token.indexOf("COSMIC") != -1) return "Cosmic";
            if (token.indexOf("LXDE") != -1) return "LXDE";
            if (token.indexOf("LXQT") != -1) return "LXQt";
            if (token.indexOf("DEEPIN") != -1 || token.indexOf("DDE") != -1) return "Deepin";
        }
        return null;
    }

    public static function fetchSession():String {
        var environmentKey = ["XDG_CURRENT_DESKTOP", "XDG_SESSION_DESKTOP", "DESKTOP_SESSION"];
        for (key in environmentKey) {
            var value = Sys.getEnv(key);
            if (value != null && value != "") {
                var clean = StringTools.trim(value);
                var upper = clean.toUpperCase();

                switch (upper) {
                    // Wayland
                    case _ if (upper.indexOf("KWIN") != -1 || upper.indexOf("KDE") != -1 || upper.indexOf("PLASMA") != -1): return "KWin";
                    case _ if (upper.indexOf("MUTTER") != -1 || upper.indexOf("GNOME") != -1 || upper.indexOf("BUDGIE") != -1): return "Mutter";
                    case _ if (upper.indexOf("SWAY") != -1): return "Sway";
                    case _ if (upper.indexOf("HYPRLAND") != -1): return "Hyprland";
                    case _ if (upper.indexOf("NIRI") != -1): return "Niri";
                    case _ if (upper.indexOf("MANGO") != -1): return "Mango";
                    case _ if (upper.indexOf("DWL") != -1): return "DWL";
                    case _ if (upper.indexOf("RIVER") != -1): return "River";
                    case _ if (upper.indexOf("LABWC") != -1): return "LabWC";
                    case _ if (upper.indexOf("WAYFIRE") != -1): return "Wayfire";
                    case _ if (upper.indexOf("XFWL") != -1): return "XFWL";

                    // X11/Xorg
                    case _ if (upper.indexOf("XFCE") != -1): return "Xfwm4";
                    case _ if (upper.indexOf("MUFFIN") != -1 || upper.indexOf("CINNAMON") != -1 || upper.indexOf("X-CINNAMON") != -1): return "Muffin";
                    case _ if (upper.indexOf("MACRO") != -1 || upper.indexOf("MATE") != -1): return "Macro";
                    case _ if (upper.indexOf("OPENBOX") != -1 || upper.indexOf("LXQT") != -1): return "OpenBox";
                    case _ if (upper.indexOf("I3") != -1): return "i3";
                    case _ if (upper.indexOf("AWESOME") != -1): return "Awesome";
                    case _ if (upper.indexOf("BSPWM") != -1): return "Bspwm";
                    case _ if (upper.indexOf("XMONAD") != -1): return "XMonad";
                    case _ if (upper.indexOf("OXWM") != -1): return "OXWM"; // Tony Banters my beloved guy

                    default: return null;
                }
                
                return clean;
            }

            var currentSession = checkSession();
            if (currentSession != null) return currentSession;
        }

        return null;
    }

    private static function checkSession():Null<String> {
        var wm = [
            //Wayland
            "kwin" => "KWin",
            "mutter" => "Mutter",
            "sway" => "Sway",
            "hyprland" => "Hyprland",
            "niri" => "Niri",
            "mangowc" => "Mango",
            "dwl" => "DWL",
            "river" => "River",
            "labwc" => "LabWC",
            "wayfire" => "Wayfire",
            "xfwl" => "XFWL",

            // X11/Xorg
            "xfwm4" => "Xfwm4",
            "muffin" => "Muffin",
            "macro" => "Macro",
            "openbox" => "OpenBox",
            "i3" => "i3",
            "awesome" => "Awesome",
            "bspwm" => "Bspwm",
            "xmonad" => "XMonad",
            "oxwm" => "OXWM", // Tony Banters my beloved guy  
            "dwm" => "DWM"
        ];

        for (process in wm.keys()) {
            var output = StringTools.trim(Haxefetch.runCmd("pgrep", ["-x", process]));
            if (output != "" && output != "N/A" && output != null) return wm.get(process);
        }
        return null;
    }

    public static function fetchProtocol():Null<String> {
        var protocolType = Sys.getEnv("XDG_SESSION_TYPE");
        if (protocolType != null && protocolType != "") {
            switch (protocolType.toLowerCase()) {
                case "wayland": return "Wayland";
                case "x11": return "X11";
                case "xlibre": return "XLibre";
                case "tty": return null;
                case _: checkProtocol();
            }
        }

        return checkProtocol();
    }

    private static function checkProtocol():Null<String> {
        if (Sys.getEnv("WAYLAND_DISPLAY") != null && Sys.getEnv("WAYLAND_DISPLAY") != "") return "Wayland";
        if (Sys.getEnv("DISPLAY") != null && Sys.getEnv("DISPLAY") != "") return "X11";
        return null;
    }

    public static function fetchCPU():String {
        try {
            var output = Haxefetch.runCmd("lscpu", []);
            var modelName = "";
            var threads = "";
            var cores = "";

            for (line in output.split("\n")) {
                if (line.indexOf("Model name:") != -1) {
                    modelName = StringTools.trim(line.split(":")[1]);
                }
                if (line.indexOf("CPU(s):") != -1 && threads == "") {
                    threads = StringTools.trim(line.split(":")[1]);
                }
                if (line.indexOf("Core(s) per socket:") != -1 && cores == "") {
                    cores = StringTools.trim(line.split(":")[1]);
                }
            }

            if (modelName != "") {
                return  '${modelName} (${Colors.colorize(cores, Colors.GREEN)} cores / ${Colors.colorize(threads, Colors.GREEN)} threads)';
            }
        } catch (e:Dynamic) {}
        return Haxefetch.runCmd("uname", ["-m"]);
    }

    public static function fetchGPU():String {
        try {
            var process = Haxefetch.runCmd("lspci", []);
            if (process != "N/A" && process != "") {
                var line = process.split("\n");
                for (lines in line) {
                    var low = lines.toLowerCase();
                    if (low.indexOf("vga compatible controller:") != -1 || low.indexOf("3d controller:") != -1)  {
                        var part = lines.split(":");
                        if (part.length >= 3) return fetchActualGPU(part[2]);
                    }
                }
            }
        } catch (e:Dynamic) {}
        return "N/A";
    }

    public static function fetchActualGPU(raw:String):String {
        var string = raw;
        var bracketStart = string.indexOf("[");
        var bracketEnd = string.indexOf("]");

        if (bracketStart != -1 && bracketEnd > bracketStart) {
            var insideBracket = string.substring(bracketStart + 1, bracketEnd);

            if (string.indexOf("Intel") != -1 && insideBracket.indexOf("Intel") == 1) {
                string = "Intel " + insideBracket;
            } else if (string.indexOf("NVIDIA") != -1 && insideBracket.indexOf("NVIDIA") == 1) {
                string = "NVIDIA " + insideBracket;
            } else if ((string.indexOf("AMD") != -1 || string.indexOf("ATI") != -1) && insideBracket.indexOf("AMD") == -1) {
                string = "AMD " + insideBracket;
            } else {
                string = insideBracket;
            }
        }

        string = StringTools.replace(string, "Intel Corporation ", "Intel ");
        string = StringTools.replace(string, "NVIDIA Corporation ", "NVIDIA");
        string = StringTools.replace(string, "Advanced Micro Devices, Inc. [AMD/ATI] ", "AMD ");
        string = StringTools.replace(string, "AMD/ATI", "AMD ");

        var revIdX = string.indexOf("(rev");
        if (revIdX != -1) string = string.substring(0, revIdX);

        return StringTools.trim(string);
    }

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
                if (count > 0) counts.push('$count (dpkg)');
            } catch (e:Dynamic) {}
        }

        // RPM based system (rpm)
        if (FileSystem.exists("/var/lib/rpm")) {
            var rpmCount = Haxefetch.executeCount("rpm", ["-qa"]);
            if (rpmCount > 0) counts.push('$rpmCount (rpm)');
        }

        // Arch Linux based system (pacman)
        if (FileSystem.exists("/var/lib/pacman/local")) {
            try {
                var entries = FileSystem.readDirectory("/var/lib/pacman/local");
                var count = entries.filter(e -> !StringTools.startsWith(e, "ALPM")).length;
                counts.push('$count (pacman)');
            } catch (e:Dynamic) {}
        }

        // Void Linux based system (xbps)
        if (FileSystem.exists("/var/db/xbps")) {
            try {
                var pkgs = FileSystem.readDirectory("/var/db/xbps").filter(e -> StringTools.endsWith(e, ".plist"));
                counts.push('${pkgs.length} (XBPS)');
            } catch (e:Dynamic) {}
        }

        // Alpine Linux based system (apk)
        if (FileSystem.exists("/lib/apk/db/installed")) {
            try {
                var lines = File.getContent("/lib/apk/db/installed").split("\n");
                var count = lines.filter(l -> StringTools.startsWith(l, "P:")).length;
                counts.push('$count (apk)');
            } catch (e:Dynamic) {}
        }

        // NixOS based system (nix)
        if (FileSystem.exists('/home/${Sys.getEnv("USER")}/.nix-profile/etc/profile.d/nix.sh') || FileSystem.exists("/nix/store")) {
            var nixCount = Haxefetch.executeCount("nix-store", ["-q", "--requisites", "/run/current-system"]);
            if (nixCount > 0) counts.push('$nixCount (nix)');
        }

        // Slackware Linux based system (slackpkg)
        if (FileSystem.exists("/var/log/packages")) {
            try {
                var total = FileSystem.readDirectory("/var/log/packages").length;
                if (total > 0) counts.push('$total (slackpkg)');
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
                    counts.push('$total (guix)');
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
                if (total > 0) counts.push('$total (emerge)');
            } catch (e:Dynamic) {}
        }

        // Solus based system (eopkg)
        if (FileSystem.exists("/var/lib/eopkg/package")) {
            try {
                var count = FileSystem.readDirectory("/var/lib/eopkg/package").length;
                return '$count (eopkg)';
            } catch (e:Dynamic) {}
        }

        // Flatpak
        if (FileSystem.exists("/var/lib/flatpak/exports/app")) {
            try {
                var apps = FileSystem.readDirectory("/var/lib/flatpak/exports/app");
                if (apps.length > 0) counts.push('${apps.length} (Flatpak)');
            } catch (e:Dynamic) {}
        }

        if (counts.length > 0) {
            return counts.join(", ");
        }
        #end
        return "Unknown";
    }

    public static function fetchHaxe():String {
        #if haxe_ver
        return Compiler.getDefine("haxe");
        #else
        return "N/A";
        #end
    }

    public static function fetchOpenGL():String {
        try {
            var output = Haxefetch.runCmd("glxinfo", ["-B"]);
            for (line in output.split("\n")) {
                var clean = StringTools.trim(line);
                if (clean.indexOf("version string:") != -1) {
                    var parts = clean.split("version string:");
                    if (parts.length > 1) {
                        var versionString = StringTools.trim(parts[1]);
                        var token = versionString.split(" ");
                        if (token.length > 0) return token[0];
                    }
                }
            }
        } catch (e:Dynamic) {}
        return "N/A";
    }

    public static function fetchVulkan():String {
        try {
            var output = Haxefetch.runCmd("vulkaninfo", ["--summary"]);
            for (line in output.split("\n")) {
                if (line.indexOf("Vulkan Instance Version:") != -1) {
                    var version = line.split(":")[1];
                    return StringTools.trim(version);
                }
            }
        } catch (e:Dynamic) {}
        return "N/A";
    }

    public static function fetchUptime():String {
        var res = Haxefetch.runCmd("uptime", ["-p"]);
        if (res != "" && res != "N/A") {
            // Reformat 'up 2 hours, 15 minutes' to '2h 15m'
            res = StringTools.replace(res, "up ", "");
            res = StringTools.replace(res, " hours", "h");
            res = StringTools.replace(res, " hour", "h");
            res = StringTools.replace(res, " minutes", "m");
            res = StringTools.replace(res, " minute", "m");
            res = StringTools.replace(res, " days", "d");
            res = StringTools.replace(res, " day", "d");
            return StringTools.replace(res, ",", "");
        }
        return "N/A";
    }

    public static function fetchBirthday():String {
        try {
            var status = FileSystem.stat("/");
            var birthdaySeconds = status.ctime.getTime() / 1000.0;
            var birthdayNow = Date.now().getTime() / 1000.0;
            var birthdayDays = Math.floor((birthdayNow - birthdaySeconds) / 86400.0);

            if (birthdayDays >= 0) return '${birthdayDays}d';
        } catch (e:Dynamic) {}

        try {
            var birthdayStat = Haxefetch.runCmd("stat", ["-c", "%W", "/"]);
            var birth = Std.parseFloat(birthdayStat);
            if (!Math.isNaN(birth) && birth > 0) {
                var now = Date.now().getTime() / 1000.0;
                var days = Math.floor((now - birth ) / 86400.0);
                return '${days}d';
            }        
        } catch (e:Dynamic) {}
        return "N/A";
    }

    public static function fetchInstalledDate():String {
        try {
            var status = FileSystem.stat("/");
            var date = status.ctime;

            var day = StringTools.lpad(Std.string(date.getDate()), "0", 2);
            var month = StringTools.lpad(Std.string(date.getMonth() + 1), "0", 2);
            var year = date.getFullYear();
            return '$day.$month.$year.';
        } catch (e:Dynamic) {}

        try {
            var bithDate = Haxefetch.runCmd("stat", ["-c", "%W", "/"]);
            var birth = Std.parseInt(bithDate);
            if (birth != null && birth > 0) {
                var output = Haxefetch.runCmd("date", ["-d", '@$birth', "+%d.+%m.%Y"]);
                return StringTools.trim(output);
            }
        } catch (e:Dynamic) {}
        return "N/A";
    }
}