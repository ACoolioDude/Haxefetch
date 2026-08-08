package;

import sys.io.Process;

class Haxefetch {
    static function main():Void {
        Commands.parse(Sys.args());
        Configuration.loadConfig();
        var memory = Memory.memoryStats();

        var user = getEnvironment("USER", getEnvironment("USERNAME", "user"));
        var host = SystemUtils.fetchHost();
        var distro = SystemUtils.fetchDistro();
        var init = SystemUtils.fetchInit();
        var logo = Logo.fetchLogo(distro, Configuration.logoSize);
        var kernel = SystemUtils.fetchKernel();
        var desktop = SystemUtils.fetchDestkop();
        var session = SystemUtils.fetchSession();
        var protocol = SystemUtils.fetchProtocol();        
        var ram = memory.ram;
        var ramType = Memory.fetchRAMType();
        var typeSuffix = (ramType != "") ? ' (${Colors.colorize(ramType, Colors.GREEN)})' : '';
        var swap = memory.swap;
        var cpu = SystemUtils.fetchCPU();
        var gpu = SystemUtils.fetchGPU();
        var disk = DiskUtility.fetchDisk();
        var packages = SystemUtils.fetchPackage();
        var haxe = SystemUtils.fetchHaxe();
        var opengl = SystemUtils.fetchOpenGL();
        var vulkan = SystemUtils.fetchVulkan();
        var uptime = SystemUtils.fetchUptime();
        var birthday = SystemUtils.fetchBirthday();
        var birth = SystemUtils.fetchInstalledDate();
        var separator:String = " ";

        var infoLine:Array<String> = [
            Configuration.showHost ? Colors.colorize(user, Colors.RED) + "@" + Colors.colorize(host, Colors.RED) : null,
            Configuration.showDistro ? Colors.colorize("OS:", Colors.YELLOW) + separator + distro : null,
            Configuration.showKernel ? Colors.colorize("Kernel:", Colors.YELLOW) + separator + kernel : null,
            
            (desktop != null && desktop != "N/A" && desktop != "" && Configuration.showDesktop) ? 
                Colors.colorize("DE:", Colors.YELLOW) + separator + desktop : null,
            
            (Configuration.showSession && session != null && session != "") ?
                Colors.colorize("WM:", Colors.YELLOW) + separator + session + " (" + protocol + ")" : null,

            Configuration.showRAM ? Colors.colorize("RAM:", Colors.YELLOW) + separator + ram + typeSuffix : null,
            Configuration.showSWAP ? Colors.colorize("SWAP:", Colors.YELLOW) + separator + swap : null,
            Configuration.showCPU ? Colors.colorize("CPU:", Colors.YELLOW) + separator + cpu : null,
            Configuration.showGPU ? Colors.colorize("GPU:", Colors.YELLOW) + separator + gpu : null,
            Configuration.showDisk ? Colors.colorize("Disk:", Colors.YELLOW) + separator + disk : null,
            Configuration.showPackages ? Colors.colorize("Packages:", Colors.YELLOW) + separator + packages : null,
            Configuration.showHaxe ? Colors.colorize("Haxe:", Colors.YELLOW) + separator + haxe : null,
            Configuration.showOpenGL ? Colors.colorize("OpenGL:", Colors.YELLOW) + separator + opengl : null,
            Configuration.showVulkan ? Colors.colorize("Vulkan:", Colors.YELLOW) + separator + vulkan : null,
            Configuration.showUptime ? Colors.colorize("Uptime:", Colors.YELLOW) + separator + uptime : null,
            Configuration.showBirthday ? Colors.colorize("OS Birthday:", Colors.YELLOW) + separator + birthday : null,
            Configuration.showBirth ? Colors.colorize("OS Birth:", Colors.YELLOW) + separator + birth : null,
            Configuration.showBlock ? Colors.getColorBlocks() : null
        ].filter(function(line) return line != null);

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