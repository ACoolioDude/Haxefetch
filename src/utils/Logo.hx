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
        if (low.indexOf("arch") != -1) return "arch";
        if (low.indexOf("artix") != -1) return "artix";
        if (low.indexOf("cachyos") != -1) return "cachy";
        if (low.indexOf("gentoo") != -1) return "gentoo";
        if (low.indexOf("debian") != -1) return "debian";
        if (low.indexOf("fedora") != -1) return "fedora";
        if (low.indexOf("nixos") != -1) return "nix";
        if (low.indexOf("void") != -1) return "void";
        return null;
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