package utils;

import haxe.Resource;
import haxe.macro.Context;
import haxe.macro.Expr;
import sys.FileSystem;
import sys.io.File;

class Logo {
    public static function fetchLogo(distroName:String, size:String = "normal", overrideLogo:String = ""):Array<String> {
        var raw:String = null;
        /*var resolve = resolvePath(customLogo);

        if (resolve != "" && FileSystem.exists(resolve)) {
            try {
                raw = File.getContent(resolve);
            } catch (e:Dynamic) {}
        }*/

        if (raw == null) {
            var logo = (overrideLogo != "") ? overrideLogo : distroName;
            var low = logo.toLowerCase();
            var key = fetchDistro(low);

            if (key != null) {
                var small = (size.toLowerCase() == "small");
                var resourceKey = small ? '${key}_small' : key;

                raw = Resource.getString(resourceKey);
                if (raw == null && small) raw = Resource.getString(key);
            }
        }

        if (raw != null) {
            var target = (overrideLogo != "") ? overrideLogo : distroName;
            var color = fetchColor(target); 
            var txt = StringTools.replace(raw, "\r\n", "\n");

            if (txt.indexOf("$1") != -1) {
                txt = StringTools.replace(txt, "$1", color.primary);
                txt = StringTools.replace(txt, "$2", color.secondary);
                txt = StringTools.replace(txt, "$3", color.third);
                txt = StringTools.replace(txt, "$reset", Colors.RESET);
                return txt.split("\n");
            }

            var lines = txt.split("\n");
            var colored = new Array<String>();
            for (line in lines) {
                colored.push(color.primary + line + Colors.RESET);
            }
            return colored;
        }

        return fetchTux();
    }

    private static function fetchDistro(low:String):Null<String> {
        switch (low) {
            case _ if (low.indexOf("aerynos") != -1): return "aeryn";
            case _ if (low.indexOf("alpine") != -1): return "alpine";
            case _ if (low.indexOf("arch") != -1): return "arch";
            case _ if (low.indexOf("artix") != -1): return "artix";
            case _ if (low.indexOf("bazzite") != -1): return "bazzite";
            case _ if (low.indexOf("cachyos") != -1): return "cachy";
            case _ if (low.indexOf("debian") != -1): return "debian";
            case _ if (low.indexOf("endeavouros") != -1): return "endeavour";
            case _ if (low.indexOf("fedora") != -1): return "fedora";
            case _ if (low.indexOf("gentoo") != -1): return "gentoo";
            case _ if (low.indexOf("Kubuntu") != -1 || low.indexOf("kubuntu") != -1 || low.indexOf("kde-ubuntu") != -1): return "kubuntu";
            case _ if (low.indexOf("LinuxFromScratch") != -1 || low.indexOf("lfs") != -1): return "lfs";
            case _ if (low.indexOf("manjaro") != -1): return "manjaro";
            case _ if (low.indexOf("mx") != -1): return "mx";
            case _ if (low.indexOf("linuxmint") != -1 || low.indexOf("linux-mint") != -1): return "mint";
            case _ if (low.indexOf("nixos") != -1): return "nix";
            case _ if (low.indexOf("opensuse") != -1 || low.indexOf("opensuse-microos") != -1 || low.indexOf("opensuse-leap") != -1 || low.indexOf("opensuse-tumbleweed") != -1 || low.indexOf("opensuse-slowroll") != -1): return "suse";
            case _ if (low.indexOf("parch") != -1): return "parch";
            case _ if (low.indexOf("pop") != -1): return "pop";
            case _ if (low.indexOf("slackware") != -1): return "slack";
            case _ if (low.indexOf("solus") != -1): return "solus"; 
            case _ if (low.indexOf("steamos") != -1): return "steam";
            case _ if (low.indexOf("ubuntu") != -1 || low.indexOf("ubuntu-cinnamon") != -1 || low.indexOf("ubuntu-mate") != -1 || low.indexOf("ubuntu-sway") != -1 || low.indexOf("uwuntu") != -1): return "ubuntu";
            case _ if (low.indexOf("void") != -1): return "void";
            case _ if (low.indexOf("Xubuntu") != -1): return "xubuntu";
            case _ if (low.indexOf("Zorin") != -1): return "zorin";
            default: return null;
        }
    }

    private static function fetchColor(low:String):{primary:String, secondary:String, third:String} {
        switch (low) {
            case "aerynos": return { primary: Colors.GREEN, secondary: Colors.YELLOW, third: Colors.BLUE };
            case "alpine" : return { primary: Colors.BLUE, secondary: Colors.WHITE, third: Colors.BLUE };
            case "arch": return { primary: Colors.WHITE, secondary: Colors.BLUE, third: Colors.BLUE };
            case "artix": return { primary: Colors.CYAN, secondary: Colors.CYAN, third: Colors.CYAN };
            case "cachyos" : return { primary: Colors.CYAN, secondary: Colors.CYAN, third: Colors.CYAN };
            case "debian" : return { primary: Colors.COLOR_88, secondary: Colors.COLOR_88, third: Colors.COLOR_88 };
            case "endeavour" : return { primary: Colors.fg(99), secondary: Colors.fg(211), third: Colors.fg(141) };
            case "fedora" : return { primary: Colors.COLOR_17, secondary: Colors.WHITE, third: Colors.COLOR_17 };
            case "gentoo" : return { primary: Colors.WHITE, secondary: Colors.fg(98), third: Colors.fg(183) };
            case "manjaro" | "manjaro-arm": return { primary: Colors.GREEN, secondary: Colors.GREEN, third: Colors.GREEN};
            case "nix" : return { primary: Colors.WHITE, secondary: Colors.COLOR_63, third: Colors.fg(243) };
            case "pop" : return { primary: Colors.BRIGHT_CYAN, secondary: Colors.WHITE, third: Colors.CYAN };
            case "parch": return { primary: Colors.COLOR_55, secondary: Colors.COLOR_55, third: Colors.COLOR_55 };
            case "void": return { primary: Colors.WHITE, secondary: Colors.COLOR_22, third: Colors.COLOR_22 };

            default: return { primary: Colors.WHITE, secondary: Colors.WHITE, third: Colors.WHITE };
        };
    }

    private static function fetchTux():Array<String> {
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
        if (!FileSystem.exists(filePath)) return Context.parse("[]", Context.currentPos());
        
        var content = File.getContent(filePath);
        var lines = content.split("\n");

        return macro $v{lines};
    }

    /*private static function resolvePath(path:String):String {
        if (path == null || path == "") return "";

        var cleanPath = StringTools.trim(path);
        if ((StringTools.startsWith(cleanPath, "'") && StringTools.endsWith(cleanPath, "'")) || (StringTools.startsWith(cleanPath, '"') &&  StringTools.endsWith(cleanPath, '"'))) {
            cleanPath = cleanPath.substring(1, cleanPath.length -1);
        }

        if (StringTools.startsWith(cleanPath, "~")) {
            var home = Sys.getEnv("HOME");
            if (home != null && home != "") {
                return home + path.substr(1);
            }
        }
        return path;
    }*/
}