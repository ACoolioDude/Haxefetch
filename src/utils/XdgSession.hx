package utils;

class XdgSession {
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

            if (token.indexOf("GNOME") != -1) return formatDesktop("GNOME", "gnome-shell", ["--version"]);
            if (token.indexOf("KDE") != -1 || token.indexOf("PLASMA") != -1) return formatDesktop("KDE Plasma", "plasmashell", ["--version"]);
            if (token.indexOf("TDE") != -1 || token.indexOf("TRINITY") != -1) return formatDesktop("TDE", "tde-config", ["--version"]);
            if (token.indexOf("CINNAMON") != -1) return formatDesktop("Cinnamon", "cinnamon", ["--version"]);
            if (token.indexOf("XFCE") != -1) return formatDesktop("XFCE", "xfce4-about", ["-V"]);
            if (token.indexOf("MATE") != -1) return formatDesktop("MATE", "mate-about", ["-v"]);
            if (token.indexOf("BUDGIE") != -1) return formatDesktop("Budgie", "budgie-desktop", ["--version"]);
            if (token.indexOf("COSMIC") != -1) return formatDesktop("COSMIC", "cosmic-comp", ["--version"]);
            if (token.indexOf("LXDE") != -1) return formatDesktop("LXDE", "lxsession", ["--version"]);
            if (token.indexOf("LXQT") != -1) return formatDesktop("LXQt", "lxqt-session", ["-v"]);
            if (token.indexOf("DEEPIN") != -1 || token.indexOf("DDE") != -1) return formatDesktop("Deepin", "dde-dock", ["--version"]);
        }
        return null;
    }

    private static function formatDesktop(name:String, execution:String, arguments:Array<String>):String {
        var process = Haxefetch.runCmd(execution, arguments);
        if (process != null && process != "") {
            var register = ~/\b\d+\.\d+(\.\d+)?\b/;
            if (register.match(process)) return '${name} ${register.matched(0)}';
        }

        return name;
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
                    case _ if (upper.indexOf("COSMIC-COMP") != -1 || upper.indexOf("COSMIC") != -1): return "Cosmic Comp";
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
                    case _ if (upper.indexOf("TWIN") != -1 || upper.indexOf("TDE") != -1 || upper.indexOf("TRINITY") != -1): return "Twin";
                    case _ if (upper.indexOf("MUFFIN") != -1 || upper.indexOf("CINNAMON") != -1 || upper.indexOf("X-CINNAMON") != -1): return "Muffin";
                    case _ if (upper.indexOf("MACRO") != -1 || upper.indexOf("MATE") != -1): return "Macro";
                    case _ if (upper.indexOf("OPENBOX") != -1 || upper.indexOf("LXQT") != -1 || upper.indexOf("LXDE") != -1): return "OpenBox";
                    case _ if (upper.indexOf("I3") != -1): return "i3";
                    case _ if (upper.indexOf("AWESOME") != -1): return "Awesome";
                    case _ if (upper.indexOf("BSPWM") != -1): return "Bspwm";
                    case _ if (upper.indexOf("XMONAD") != -1): return "XMonad";
                    case _ if (upper.indexOf("OXWM") != -1): return "OXWM"; // Tony Banters my beloved guy
                    case _ if (upper.indexOf("QTILE") != -1): return "QTile";

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
            "cosmic-comp" => "Cosmic Comp",
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
            "twin" => "Twin",
            "muffin" => "Muffin",
            "macro" => "Macro",
            "openbox" => "OpenBox",
            "i3" => "i3",
            "awesome" => "Awesome",
            "bspwm" => "Bspwm",
            "xmonad" => "XMonad",
            "oxwm" => "OXWM", // Tony Banters my beloved guy  
            "dwm" => "DWM",
            "qtile" => "QTile"
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
                case "x11": return checkProtocol();
                case "xlibre": return "XLibre";
                case "tty": return null;
                case _: checkProtocol();
            }
        }

        return checkProtocol();
    }

    private static function checkProtocol():Null<String> {
        if (Sys.getEnv("WAYLAND_DISPLAY") != null && Sys.getEnv("WAYLAND_DISPLAY") != "") return "Wayland";
        if (Sys.getEnv("DISPLAY") != null && Sys.getEnv("DISPLAY") != "") {
            var xorg = Xorg.fetchXorg().toLowerCase();
            if (xorg.indexOf("xlibre") != -1) return "XLibre";
            return "X11";
        } 
        return null;
    }
}