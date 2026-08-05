package;

import haxe.display.Display.Package;
import haxe.io.Output;
import haxe.macro.Compiler;
import haxe.display.Display.Define;
import sys.io.Process;
import sys.FileSystem;
import sys.io.File;

class Haxefetch {
    static function main() {
        var memory = Memory.memoryStats();

        var user = getEnvironment("USER", getEnvironment("USERNAME", "user"));
        var host = SystemUtils.fetchHost();
        var distro = SystemUtils.fetchDistro();
        var init = SystemUtils.fetchInit();
        var logo = Logo.fetchLogo(distro);
        var kernel = SystemUtils.fetchKernel();
        var session = SystemUtils.fetchSession();        
        var ram = memory.ram;
        var swap = memory.swap;
        var cpu = SystemUtils.fetchCPU();
        var packages = SystemUtils.fetchPackage();
        var haxe = SystemUtils.fetchHaxe();
        var opengl = SystemUtils.fetchOpenGL();
        var vulkan = SystemUtils.fetchVulkan();
        var uptime = SystemUtils.fetchUptime();
        var birthday = SystemUtils.fetchBirthday();
        var birth = SystemUtils.fetchInstalledDate();
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

    public static function roundDecimal(val:Float, precision:Int):Float {
        var factor = Math.pow(10, precision);
        return Math.round(val * factor) / factor;
    }

    public static function executeCount(cmd:String, args:Array<String>):Int {
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

    public static function runCmd(cmd:String, args:Array<String>):String {
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