package utils;

import sys.io.File;
import sys.FileSystem;
import haxe.io.Path;

class Configuration {
    public static var showHost:Bool = true;

    public static var showDistro:Bool = true;
    // public static var distroString:String = "OS";

    public static var showKernel:Bool = true;
    // public static var kernelString:String = "Kernel:";

    public static var showDesktop:Bool = true;
    // public static var desktopString:String = "DE:";

    public static var showSession:Bool = true;
    // public static var sessionString:String = "WM:";

    public static var showRAM:Bool = true;
    // public static var ramString:String = "RAM:";

    public static var showSWAP:Bool = true;
    // public static var swapString:String = "SWAP:";

    public static var showCPU:Bool = true;
    // public static var cpuString:String = "CPU:";

    public static var showGPU:Bool = true;
    // public static var gpuString:String = "GPU:";

    // Custom options
    public static var showPackages:Bool = true;
    public static var showHaxe:Bool = true;
    public static var showOpenGL:Bool = true;
    public static var showVulkan:Bool = true;
    public static var showUptime:Bool = true;
    public static var showBirthday:Bool = true;
    public static var showBirth:Bool = true;

    public static function loadConfig():Void {
        var main = Sys.getEnv("HOME");
        if (main == null || main == "") return;

        var configDirectory = Path.join([main, ".config", "haxefetch"]);
        var configFile = Path.join([configDirectory, "config.conf"]);

        if (!FileSystem.exists(configFile)) {
            createConfiguration(configDirectory, configFile, false);
            return;
        }

        try {
            var configContent = File.getContent(configFile);
            var line = configContent.split("\n");

            for (i in 0...line.length) {
                var lineNumber = i + 1;
                var lines = line[i];
                var trims = StringTools.trim(lines);

                if (trims == "" || StringTools.startsWith(trims, "#") || StringTools.startsWith(trims, ";") || StringTools.startsWith(trims, "[") && StringTools.endsWith(trims, "]")) continue;
                if (trims.indexOf("=") == -1) {
                    Sys.println('Error in configuration of Haxefetch [Line ${lineNumber}]: Invalid config syntax. Missing "=" for -> "${trims}" <-');
                    Sys.exit(1);
                }
                
                var part = trims.split("=");
                var keyValue = StringTools.trim(part[0]);
                var value = StringTools.trim(part.slice(1).join("="));

                if (keyValue == "") {
                    Sys.println('Error in configuration of Haxefetch [Line ${lineNumber}]: Missing key option before "="');
                    Sys.exit(1);
                }

                try {
                    parseConfigOptions(keyValue, value, lineNumber);
                } catch (e:Dynamic) {
                    Sys.println('Error in configuration of Haxefetch [Line ${lineNumber}]: Failed to parse "${keyValue}" -> ${e}');
                    Sys.exit(1);
                }
            }
        } catch (e:Dynamic) {
            Sys.println('Fatal error appeared: Cannot read config file: ${e}. Is directory and configuration correct?');
            Sys.exit(1);
        }
    }

    public static function generateConfiguration():Void {
        var home = Sys.getEnv("HOME");
        if (home == null || home == "") {
            Sys.println('Haxefetch error: Could not determine user directory? Does home directory exist?');
            Sys.exit(1);
        }

        var configDirectory = Path.join([home, ".config", "haxefetch"]);
        var configFile = Path.join([configDirectory, "config.conf"]);

        createConfiguration(configDirectory, configFile, true);
    }

    private static function parseConfigOptions(key:String, value:String, lineNumber:Int):Void {
        switch (key) {
            case "show_hostname": showHost = parseBool(value);
            case "show_distro": showDistro = parseBool(value);
            case "show_kernel": showKernel = parseBool(value);
            case "show_desktop_environment": showDesktop = parseBool(value);
            case "show_window_manager": showSession = parseBool(value);
            case "show_ram": showSession = parseBool(value);
            case "show_swap": showSWAP = parseBool(value);
            case "show_cpu": showCPU = parseBool(value);
            case "show_gpu": showGPU = parseBool(value);
            case "show_package": showPackages = parseBool(value);
            case "show_haxe_version": showHaxe = parseBool(value);
            case "show_opengl_version": showOpenGL = parseBool(value);
            case "show_vulkan_version": showVulkan = parseBool(value);
            case "show_uptime": showUptime = parseBool(value);
            case "show_birthday": showBirthday = parseBool(value);
            case "show_birth": showBirth = parseBool(value);
            default:
                Sys.println('Error in configuration of Haxefetch [Line ${lineNumber}]: Unknown option key "${key}"');
                Sys.exit(1);
        }
    }

    private static function parseBool(value:String):Bool {
        var low = value.toLowerCase();
        if (low == "true") return true;
        if (low == "false") return false;

        throw 'Invalid bool options "${value}" (expected only true or false)';
    }

    private static function createConfiguration(directory:String, path:String, creation:Bool):Void {
        try {
            if (!FileSystem.exists(directory)) FileSystem.createDirectory(directory);

            var defaults =
                "# Haxefetch configuration\n" +
                "# CURRENTLY ON ALPHA!\n" +
                "show_hostname=true\n" +
                "show_distro=true\n" +
                "show_desktop_environment=true\n" +
                "show_window_manager=true\n" +
                "show_ram=true\n" +
                "show_swap=true\n" +
                "show_cpu=true\n" +
                "show_gpu=true\n" +
                "show_package=true\n" +
                "show_haxe_version=true\n" +
                "show_opengl_version=true\n" +
                "show_vulkan_version=true\n" +
                "show_uptime=true\n" +
                "show_birthday=true\n" +
                "show_birth=true\n";

            File.saveContent(path, defaults);

            if (creation) {
                Sys.println('Generated config in: ${directory}"');
                Sys.exit(1);
            }
        } catch (e:Dynamic) {
            Sys.println('Genereting config failed: ${e}');
            if (creation) Sys.exit(1);
        }
    }
}