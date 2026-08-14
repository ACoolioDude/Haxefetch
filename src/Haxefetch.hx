package;

import sys.io.Process;

class Haxefetch {
    static function main():Void {
        Commands.parse(Sys.args());
        Configuration.loadConfig();
        var memory = Memory.memoryStats();

        var user = getEnvironment("USER", getEnvironment("USERNAME", "user"));
        var hostname = SystemUtils.fetchHostname();
        var host = SystemUtils.fetchHost();
        var distro = SystemUtils.fetchDistro();
        var init = SystemUtils.fetchInit();
        var initSuffix = (init != "") ? ' (${Colors.colorize(init, Colors.GREEN)})' : '';
        var logo = Logo.fetchLogo(distro, Configuration.logoSize);
        var kernel = SystemUtils.fetchKernel();
        var desktop = SystemUtils.fetchDestkop();
        var session = SystemUtils.fetchSession();
        var protocol = SystemUtils.fetchProtocol();        
        var ram = memory.ram;
        var ramType = Memory.fetchRAMType();
        var typeSuffix = (ramType != "") ? ' (${Colors.colorize(ramType, Colors.GREEN)})' : '';
        var swap = memory.swap;
        var cpu = CPU.fetchCPU();
        var gpu = GPU.fetchGPU();
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
            Configuration.showHostname ? Colors.colorize(user, Colors.RED) + "@" + Colors.colorize(hostname, Colors.RED) : null,

            (Configuration.showHost && host != null) ?
                (Configuration.showHost ? Colors.colorize(Configuration.hostString, Colors.YELLOW) + separator + host : null) : null,

            Configuration.showDistro ? Colors.colorize(Configuration.distroString, Colors.YELLOW) + separator + distro + initSuffix : null,
            Configuration.showKernel ? Colors.colorize(Configuration.kernelString, Colors.YELLOW) + separator + kernel : null,
            
            (desktop != null && desktop != "N/A" && desktop != "" && Configuration.showDesktop) ? 
                Colors.colorize(Configuration.desktopString, Colors.YELLOW) + separator + desktop : null,
            
            (Configuration.showSession && session != null && session != "") ?
                Colors.colorize(Configuration.sessionString, Colors.YELLOW) + separator + session + " (" + protocol + ")" : null,

            Configuration.showRAM ? Colors.colorize(Configuration.ramString, Colors.YELLOW) + separator + ram + typeSuffix : null,
            Configuration.showSWAP ? Colors.colorize(Configuration.swapString, Colors.YELLOW) + separator + swap : null,
            Configuration.showCPU ? Colors.colorize(Configuration.cpuString, Colors.YELLOW) + separator + cpu : null,
            Configuration.showGPU ? Colors.colorize(Configuration.gpuString, Colors.YELLOW) + separator + gpu : null,
            Configuration.showDisk ? Colors.colorize(Configuration.diskString, Colors.YELLOW) + separator + disk : null,
            Configuration.showPackages ? Colors.colorize(Configuration.packageString, Colors.YELLOW) + separator + packages : null,
            Configuration.showHaxe ? Colors.colorize(Configuration.haxeString, Colors.YELLOW) + separator + haxe : null,
            Configuration.showOpenGL ? Colors.colorize(Configuration.openglString, Colors.YELLOW) + separator + opengl : null,
            Configuration.showVulkan ? Colors.colorize(Configuration.vulkanString, Colors.YELLOW) + separator + vulkan : null,
            Configuration.showUptime ? Colors.colorize(Configuration.uptimeString, Colors.YELLOW) + separator + uptime : null,
            Configuration.showBirthday ? Colors.colorize(Configuration.birthdayString, Colors.YELLOW) + separator + birthday : null,
            Configuration.showBirth ? Colors.colorize(Configuration.birthString, Colors.YELLOW) + separator + birth : null,
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

            var logoColor = Colors.getColors(Configuration.logoColor);
            if (logoColor != "") left = logoColor + Colors.stripAnsi(left) + Colors.RESET;

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