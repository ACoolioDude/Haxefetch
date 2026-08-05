package;

import sys.io.Process;

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
            Colors.colorize(host, Colors.RED),
            Colors.colorize("OS:", Colors.YELLOW) + separator + distro + " (" + Colors.colorize(init, Colors.GREEN) + ")",
            Colors.colorize("Kernel:", Colors.YELLOW) + separator + kernel,
            Colors.colorize("WM:", Colors.YELLOW) + separator + session,
            Colors.colorize("RAM:", Colors.YELLOW) + separator + ram,
            Colors.colorize("SWAP:", Colors.YELLOW) + separator + swap,
            Colors.colorize("CPU:", Colors.YELLOW) + separator + cpu,
            Colors.colorize("Packages:", Colors.YELLOW) + separator + packages,
            Colors.colorize("OpenGL:", Colors.YELLOW) + separator + opengl,
            Colors.colorize("Vulkan:", Colors.YELLOW) + separator + vulkan,
            Colors.colorize("Uptime:", Colors.YELLOW) + separator + uptime,
            Colors.colorize("OS Birthday:", Colors.YELLOW) + separator + birthday,
            Colors.colorize("OS Birth:", Colors.YELLOW) + separator + birth
        ];

        var logoWidth = 0;
        for (line in logo) {
            var visibleLen = Colors.stripAnsi(line).length;
            if (visibleLen > logoWidth) logoWidth = visibleLen;
        }

        var maximumLine = logo.length > infoLine.length ? logo.length : infoLine.length;
        for (i in 0...maximumLine) {
            var left = i < logo.length ? logo[i] : "";
            var right = i < infoLine.length ? infoLine[i] : "";

            var visibleLeftLen = Colors.stripAnsi(left).length;
            var padding = (logoWidth + 3) - visibleLeftLen;
            if (padding < 0) padding = 0;
            
            var space = StringTools.lpad("", " ", padding);
            Sys.println('$left$space$right');
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