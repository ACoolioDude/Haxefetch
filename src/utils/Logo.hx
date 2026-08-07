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
            var resource = small ? '${key}_small' : key;

            var raw = Resource.getString(resource);
            if (raw == null && small) raw = Resource.getString(resource);
            if (raw != null) return StringTools.replace(raw, "\r\n", "\n").split("\n");
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
            case _ if (low.indexOf("slackware") != -1): return "slack";
            case _ if (low.indexOf("solus") != -1): return "solus"; 
            case _ if (low.indexOf("steamos") != -1): return "steam";
            case _ if (low.indexOf("ubuntu") != -1 || low.indexOf("ubuntu-cinnamon") != -1 || low.indexOf("ubuntu-mate") != -1 || low.indexOf("ubuntu-sway") != -1 || low.indexOf("uwuntu") != -1): return "ubuntu";
            case _ if (low.indexOf("void") != -1): return "void";
            default: return null;
        }
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