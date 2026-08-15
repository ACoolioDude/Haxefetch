package utils;

import haxe.Resource;
import haxe.macro.Context;
import haxe.macro.Expr;
import sys.FileSystem;
import sys.io.File;

class Logo {
    public static function fetchLogo(distroName:String, size:String = "normal"):Array<String> {
        var low = distroName.toLowerCase();
        var key = fetchDistro(low);

        if (key != null) {
            var small = (size.toLowerCase() == "small");
            var resourceKey = small ? '${key}_small' : key;

            var raw = Resource.getString(resourceKey);
            if (raw == null && small) raw = Resource.getString(key);

            if (raw != null) {
                var color = fetchColor(key); 
                var txt = StringTools.replace(raw, "\r\n", "\n");

                if (txt.indexOf("$1") != -1) {
                    txt = StringTools.replace(txt, "$1", color.primary);
                    txt = StringTools.replace(txt, "$2", color.secondary);
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
        }

        return fetchTux();
    }

    private static function fetchDistro(low:String):Null<String> {
        switch (low) {
            case _ if (low.indexOf("alpine") != -1): return "apline";
            case _ if (low.indexOf("arch") != -1): return "arch";
            case _ if (low.indexOf("artix") != -1): return "artix";
            case _ if (low.indexOf("bazzite") != -1): return "bazzite";
            case _ if (low.indexOf("cachyos") != -1): return "cachy";
            case _ if (low.indexOf("debian") != -1): return "debian";
            case _ if (low.indexOf("endeavouros") != -1): return "endeavour";
            case _ if (low.indexOf("fedora") != -1): return "fedora";
            case _ if (low.indexOf("gentoo") != -1): return "gentoo";
            case _ if (low.indexOf("LinuxFromScratch") != -1 || low.indexOf("lfs") != -1): return "lfs";
            case _ if (low.indexOf("manjaro") != -1): return "manjaro";
            case _ if (low.indexOf("linuxmint") != -1): return "mint";
            case _ if (low.indexOf("nixos") != -1): return "nix";
            case _ if (low.indexOf("opensuse") != -1 || low.indexOf("opensuse-microos") != -1 || low.indexOf("opensuse-leap") != -1 || low.indexOf("opensuse-tumbleweed") != -1 || low.indexOf("opensuse-slowroll") != -1): return "suse";
            case _ if (low.indexOf("parch") != -1): return "parch";
            case _ if (low.indexOf("pop") != -1): return "pop";
            case _ if (low.indexOf("slackware") != -1): return "slack";
            case _ if (low.indexOf("solus") != -1): return "solus"; 
            case _ if (low.indexOf("steamos") != -1): return "steam";
            case _ if (low.indexOf("ubuntu") != -1 || low.indexOf("ubuntu-cinnamon") != -1 || low.indexOf("ubuntu-mate") != -1 || low.indexOf("ubuntu-sway") != -1 || low.indexOf("uwuntu") != -1): return "ubuntu";
            case _ if (low.indexOf("void") != -1): return "void";
            default: return null;
        }
    }

    private static function fetchColor(low:String):{primary:String, secondary:String} {
        switch (low) {
            case "alpine" : return { primary: Colors.BLUE, secondary: Colors.BLUE };
            case "arch": return { primary: Colors.BLUE, secondary: Colors.BLUE };
            case "artix": return { primary: Colors.CYAN, secondary: Colors.CYAN };
            case "cachyos" : return { primary: Colors.CYAN, secondary: Colors.CYAN };
            case "debian" : return { primary: Colors.COLOR_88, secondary: Colors.COLOR_88 };
            case "endeavour" : return { primary: Colors.COLOR_54, secondary: Colors.COLOR_54 };
            case "fedora" : return { primary: Colors.WHITE, secondary: Colors.COLOR_17 };
            case "gentoo" : return { primary: Colors.WHITE, secondary: Colors.MAGENTA };
            case "manjaro" | "manjaro-arm": return { primary: Colors.GREEN, secondary: Colors.GREEN };
            case "nix" : return { primary: Colors.WHITE, secondary: Colors.COLOR_63 };
            case "pop" : return { primary: Colors.BRIGHT_CYAN, secondary: Colors.CYAN };
            case "parch": return { primary: Colors.COLOR_55, secondary: Colors.COLOR_55 };
            case "void": return { primary: Colors.COLOR_22, secondary: Colors.COLOR_22 };
            default: return { primary: Colors.WHITE, secondary: Colors.WHITE };
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
}