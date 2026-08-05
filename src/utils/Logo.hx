package utils;

import haxe.Resource;
import haxe.macro.Context;
import haxe.macro.Expr;
import sys.FileSystem;
import sys.io.File;

class Logo {
    public static function fetchLogo(distroName:String):Array<String> {
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
            return Context.parse("[]", Context.currentPos());
        }
        var content = File.getContent(filePath);
        var lines = content.split("\n");

        return macro $v{lines};
    }
}