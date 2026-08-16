package utils;

import haxe.macro.Compiler;
import sys.FileSystem;
import sys.io.File;
import sys.io.Process;

class SystemUtils {
    public static function fetchHostname():String {
        #if sys
        if (FileSystem.exists("/etc/hostname")) {
            return StringTools.trim(File.getContent("/etc/hostname"));
        }
        #end
        return "Haxefetch";
    }

    public static function fetchHost():String {
        var bios:String = readFile("/sys/class/dmi/id/bios_vendor");
        var board:String = readFile("/sys/clas/dmi/id/board_vendor");
        var family:String = readFile("/sys/class/dmi/id/product_family");
        var version:String = readFile("/sys/class/dmi/id/product_version");
        var name:String = readFile("/sys/class/dmi/id/product_name");

        var vendor:String = "";
        var model:String = "";

        if (bios != "" && bios != "None")
            vendor = bios
        else if (board != "" && board != "None")
            vendor = board;

        if (version != "" && version != "None" && version != "System Version")
            model = version;
        else if (family != "" && family != "None")
            model = family;
        else if (name != "" && name != "None" && name != "System Product Name")
            model = name;
        if (model == "") return "";

        if (name != "" && name != model && name != "None" && name != "System Product Name") model += " (" + name + ")";
        if (vendor != "") {
            var lowerM = model.toLowerCase();
            var lowerV = vendor.toLowerCase();
            if (lowerM.indexOf(lowerV) == -1) model = '${vendor} ${model}';
        }
        
        return model;
    }

    private static function readFile(path:String):String {
        if (sys.FileSystem.exists(path)) {
            try {
                var content = sys.io.File.getContent(path);
                if (content != null) return StringTools.trim(content);
            } catch (e:Dynamic) {}
        }

        var output = Haxefetch.runCmd("cat", [path]);
            if (output != null && output != "") {
            return StringTools.trim(output);
        }
        return "";
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