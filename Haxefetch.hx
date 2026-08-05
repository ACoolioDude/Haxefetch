package;

import haxe.display.Display.Package;
import haxe.io.Output;
import haxe.macro.Compiler;
import haxe.Resource;
import haxe.display.Display.Define;
import haxe.macro.Expr;
import sys.io.Process;
import sys.FileSystem;
import sys.io.File;

class Haxefetch {
    static function main() {
        var memory = Memory.memoryStats();

        var user = getEnvironment("USER", getEnvironment("USERNAME", "user"));
        var host = fetchHost();
        var distro = fetchDistro();
        var init = fetchInit();
        var logo = fetchLogo(distro);
        var kernel = fetchKernel();
        var session = fetchSession();        
        var ram = memory.ram;
        var swap = memory.swap;
        var cpu = fetchCPU();
        var packages = fetchPackage();
        var haxe = fetchHaxe();
        var opengl = fetchOpenGL();
        var vulkan = fetchVulkan();
        var uptime = fetchUptime();
        var birthday = fetchBirthday();
        var birth = fetchInstalledDate();
        var separator:String = " ";

        var infoLine:Array<String> = [
            host,
            "OS:" + separator + distro + " (" + init + ")",
            "Kernel:" + separator + kernel,
            "WM:" + separator + session,
            "RAM:" + separator + ram,
            "SWAP:" + separator + swap,
            "CPU:" + separator + cpu,
            "Packages:" + separator + packages,
            "Haxe:" + separator + haxe,
            "OpenGL:" + separator + opengl,
            "Vulkan:" + separator + vulkan,
            "Uptime:" + separator + uptime,
            "OS Birthday:" + separator + birthday,
            "OS Birth:" + separator + birth
        ];

        var logoWidth = 0;
        for (line in logo) {
            if (line.length > logoWidth) logoWidth = line.length;
        }

        var maximumLine = Math.floor(Math.max(logo.length, infoLine.length));
        for (i in 0...maximumLine) {
            var left = i < logo.length ? logo[i] : "";
            var right = i < infoLine.length ? infoLine[i] : "";

            var leftPadding = StringTools.rpad(left, separator, logoWidth + 3);
            Sys.println('$leftPadding$right');
        }
    }
    
    static function getEnvironment(key:String, fallback:String):String {
        var value = Sys.getEnv(key);
        return (value != null) ? value : fallback;
    }

    static function fetchLogo(distroName:String):Array<String> {
        var low = distroName.toLowerCase();

        if (low.indexOf("arch") != -1) {
            var arch = Resource.getString("arch");
            return arch.split("\n");
        }

        if (low.indexOf("artix") != -1) {
            var arch = Resource.getString("artix");
            return arch.split("\n");
        }

        if (low.indexOf("cachyos") != -1) {
            var cachyos = Resource.getString("cachy");
            return cachyos.split("\n");
        }

        if (low.indexOf("gentoo") != -1) {
            var gentoo = Resource.getString("gentoo");
            return gentoo.split("\n");
        }

        if (low.indexOf("debian") != -1) {
            var debian = Resource.getString("debian");
            return debian.split("\n");
        }

        if (low.indexOf("fedora") != -1) {
            var fedora = Resource.getString("fedora");
            return fedora.split("\n");
        }

        if (low.indexOf("nixos") != -1) {
            var nixos = Resource.getString("nix");
            return nixos.split("\n");
        }

        if (low.indexOf("void") != -1) {
            var void = Resource.getString("void");
            return void.split("\n");
        }

        return fetchTux();
    }

    static function fetchTux():Array<String> {
        return [
            "   .--.",
            "  |o_o |",
            "  |:_/ |",
            " //   \\ \\",
            "(|     | )",
            "/'\\_   _/'\\",
            "\\___)=(___)"
        ];
    }

    static macro function embedLogo(filePath:String):Expr {
        if (!FileSystem.exists(filePath)) {
            return haxe.macro.Context.parse("[]", haxe.macro.Context.currentPos());
        }
        var content = File.getContent(filePath);
        var lines = content.split("\n");

        return macro $v{lines};
    }

    static function fetchHost():String {
        #if sys
        if (FileSystem.exists("/etc/hostname")) {
            return StringTools.trim(File.getContent("/etc/hostname"));
        }
        #end
        return "Haxefetch";
    }

    static function fetchDistro():String {
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

    static function fetchInit():String {
        if (FileSystem.exists("/run/systemd/system")) return "systemD";
        if (FileSystem.exists("/run/openrc") || FileSystem.exists("/run/openrc/softlevel")) return "OpenRC";
        if (FileSystem.exists("/run/runit")) return "Runit";
        if (FileSystem.exists("/run/dinit")) return "Dinit";
        if (FileSystem.exists("/run/s6")) return "S6";
        
        var rawCommand = runCmd("ps", ["-p", "1", "-o", "comm="]);
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

    static function fetchKernel():String {
        try {
            var p = new Process("uname", ["-r"]);
            var kernel = StringTools.trim(p.stdout.readLine());
            p.close();
            return kernel;
        } catch (e:Dynamic) {
            return Sys.systemName();
        }
    }

    static function fetchSession():String {
        #if sys
        var sessionType:String = Sys.getEnv("XDG_SESSION_TYPE");
        var desktop:String = Sys.getEnv("XDG_CURRENT_DESKTOP");

        if (sessionType == null || sessionType == "") sessionType = "Unknown";
        if (desktop == null || desktop == "") {
            desktop = Sys.getEnv("DESKTOP_SESSION");
            if (desktop == null || desktop == "") desktop = "Unknown";
        }

        if (sessionType != "Unknown" && sessionType.length > 0) {
            sessionType = sessionType.charAt(0).toUpperCase() + sessionType.substr(1).toLowerCase();
        }

        return desktop + " (" + sessionType + ")";
        #end
        return "N/A";
    }

    static function roundDecimal(val:Float, precision:Int):Float {
        var factor = Math.pow(10, precision);
        return Math.round(val * factor) / factor;
    }

    static function fetchPackage():String {
        #if sys
        var counts:Array<String> = [];

        if (FileSystem.exists("/var/lib/pacman/local")) {
            try {
                var entries = FileSystem.readDirectory("/var/lib/pacman/local");
                var count = entries.filter(e -> !StringTools.startsWith(e, "ALPM")).length;
                counts.push('$count (Pacman)');
            } catch (e:Dynamic) {}
        }

        if (FileSystem.exists("/var/lib/dpkg/status")) {
            try {
                var content = File.getContent("/var/lib/dpkg/status");
                var count = 0;
                for (line in content.split("\n")) {
                    if (StringTools.startsWith(line, "Status: install ok installed")) {
                        count++;
                    }
                }
                if (count > 0) counts.push('$count (DPKG)');
            } catch (e:Dynamic) {}
        }

        if (FileSystem.exists("/var/lib/rpm")) {
            var rpmCount = executeCount("rpm", ["-qa"]);
            if (rpmCount > 0) counts.push('$rpmCount (RPM)');
        }

        if (FileSystem.exists("/var/db/xbps")) {
            try {
                var pkgs = FileSystem.readDirectory("/var/db/xbps").filter(e -> StringTools.endsWith(e, ".plist"));
                counts.push('${pkgs.length} (XBPS)');
            } catch (e:Dynamic) {}
        }

        if (FileSystem.exists("/lib/apk/db/installed")) {
            try {
                var lines = File.getContent("/lib/apk/db/installed").split("\n");
                var count = lines.filter(l -> StringTools.startsWith(l, "P:")).length;
                counts.push('$count (Apk)');
            } catch (e:Dynamic) {}
        }

        if (FileSystem.exists('/home/${Sys.getEnv("USER")}/.nix-profile/etc/profile.d/nix.sh') || FileSystem.exists("/nix/store")) {
            var nixCount = executeCount("nix-store", ["-q", "--requisites", "/run/current-system"]);
            if (nixCount > 0) counts.push('$nixCount (Nix)');
        }

        if (FileSystem.exists("/var/log/packages")) {
            try {
                var total = FileSystem.readDirectory("/var/log/packages").length;
                if (total > 0) counts.push('$total (Slackpkg)');
            } catch (e:Dynamic) {}
        }

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

        if (FileSystem.exists("/var/db/pkg")) {
            try {
                var total = 0;
                for (category in FileSystem.readDirectory("/var/db/pkg")) {
                    var catPath = '/var/db/pkg/$category';
                    if (FileSystem.isDirectory(catPath)) {
                        total += FileSystem.readDirectory(catPath).length;
                    }
                }
                if (total > 0) counts.push('$total (Portage)');
            } catch (e:Dynamic) {}
        }

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

    static function executeCount(cmd:String, args:Array<String>):Int {
        try {
            var p = new Process(cmd, args);
            var count = 0;
            try {
                while (true) {
                    p.stdout.readLine();
                    count++;
                }
            } catch (e:haxe.io.Eof) {}
            p.close();
            return count;
        } catch (e:Dynamic) {
            return 0;
        }
    }

    static function fetchCPU():String {
        try {
            var output = runCmd("lscpu", []);
            var modelName = "";
            var threads = "";

            for (line in output.split("\n")) {
                if (line.indexOf("Model name:") != -1) {
                    modelName = StringTools.trim(line.split(":")[1]);
                }
                if (line.indexOf("CPU(s):") != -1 && threads == "") {
                    threads = StringTools.trim(line.split(":")[1]);
                }
            }

            if (modelName != "") {
                return '$modelName';
                // return '$modelName ($threads)';
            }
        } catch (e:Dynamic) {}
        return runCmd("uname", ["-m"]);
    }

    static function fetchHaxe():String {
        #if haxe_ver
        return Compiler.getDefine("haxe");
        #else
        return "N/A";
        #end
    }

    static function fetchOpenGL():String {
        try {
            var output = runCmd("glxinfo", ["-B"]);
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

    static function fetchVulkan():String {
        try {
            var output = runCmd("vulkaninfo", ["--summary"]);
            for (line in output.split("\n")) {
                if (line.indexOf("Vulkan Instance Version:") != -1) {
                    var version = line.split(":")[1];
                    return StringTools.trim(version);
                }
            }
        } catch (e:Dynamic) {}
        return "N/A";
    }

    static function fetchUptime():String {
        var res = runCmd("uptime", ["-p"]);
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

    static function fetchBirthday():String {
        try {
            var status = FileSystem.stat("/");
            var birthdaySeconds = status.ctime.getTime() / 1000.0;
            var birthdayNow = Date.now().getTime() / 1000.0;
            var birthdayDays = Math.floor((birthdayNow - birthdaySeconds) / 86400.0);

            if (birthdayDays >= 0) return '${birthdayDays}d';
        } catch (e:Dynamic) {}

        try {
            var birthdayStat = runCmd("stat", ["-c", "%W", "/"]);
            var birth = Std.parseFloat(birthdayStat);
            if (!Math.isNaN(birth) && birth > 0) {
                var now = Date.now().getTime() / 1000.0;
                var days = Math.floor((now - birth ) / 86400.0);
                return '${days}d';
            }        
        } catch (e:Dynamic) {}
        return "N/A";
    }

    static function fetchInstalledDate():String {
        try {
            var status = FileSystem.stat("/");
            var date = status.ctime;

            var day = StringTools.lpad(Std.string(date.getDate()), "0", 2);
            var month = StringTools.lpad(Std.string(date.getMonth() + 1), "0", 2);
            var year = date.getFullYear();
            return '$day.$month.$year.';
        } catch (e:Dynamic) {}

        try {
            var bithDate = runCmd("stat", ["-c", "%W", "/"]);
            var birth = Std.parseInt(bithDate);
            if (birth != null && birth > 0) {
                var output = runCmd("date", ["-d", '@$birth', "+%d.+%m.%Y"]);
                return StringTools.trim(output);
            }
        } catch (e:Dynamic) {}
        return "N/A";
    }

    static function runCmd(cmd:String, args:Array<String>):String {
        try {
            var p = new Process(cmd, args);
            var stdout = p.stdout.readAll().toString();
            p.close();
            return StringTools.trim(stdout);
        } catch (e:Dynamic) {
            return "N/A";
        }
    }
}