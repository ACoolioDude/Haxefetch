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
        var initSuffix = (init != "") ? ' [${Colors.colorize(init, Colors.GREEN)}]' : '';
        var logo = Logo.fetchLogo(distro, Configuration.logoSize);
        var kernel = SystemUtils.fetchKernel();
        var desktop = XdgSession.fetchDestkop();
        var session = XdgSession.fetchSession();
        var protocol = XdgSession.fetchProtocol();        
        var ram = memory.ram;
        var ramType = Memory.fetchRAMType();
        var typeSuffix = (ramType != "") ? ' [${Colors.colorize(ramType, Colors.GREEN)}]' : '';
        var swap = memory.swap;
        var cpu = CPUUtility.fetchCPU();
        var gpu = GPUUtility.fetchGPU();
        var disk = DiskUtility.fetchDisk();
        var packages = Packages.fetchPackage();
        var haxe = SystemUtils.fetchHaxe();
        var opengl = SystemUtils.fetchOpenGL();
        var vulkan = SystemUtils.fetchVulkan();
        var uptime = SystemUtils.fetchUptime();
        var birthday = SystemUtils.fetchBirthday();
        var birth = SystemUtils.fetchInstalledDate();
        var separator:String = " ";

        var modules:Map<String, String> = [
            "hostname" => Configuration.showHostname ? Colors.colorize(user, Colors.RED) + "@" + Colors.colorize(hostname, Colors.RED) : null,
            "host"     => (Configuration.showHost && host != null) ? (Configuration.showHost ? Colors.colorize(Configuration.hostString, Colors.YELLOW) + separator + host : null) : null,
            "os"       => Configuration.showDistro ? Colors.colorize(Configuration.distroString, Colors.YELLOW) + separator + distro + (Configuration.init ? initSuffix : "") : null,
            "kernel"   => Configuration.showKernel ? Colors.colorize(Configuration.kernelString, Colors.YELLOW) + separator + kernel : null,
            "de"       => (desktop != null && desktop != "N/A" && desktop != "" && Configuration.showDesktop) ? Colors.colorize(Configuration.desktopString, Colors.YELLOW) + separator + desktop : null,
            "wm"       => (Configuration.showSession && session != null && session != "") ? Colors.colorize(Configuration.sessionString, Colors.YELLOW) + separator + session + (Configuration.protocol ? ' (${protocol})' : '') : null,
            "ram"      => Configuration.showRAM ? Colors.colorize(Configuration.ramString, Colors.YELLOW) + separator + ram + (Configuration.ramType ? typeSuffix : "") : null,
            "swap"     => Configuration.showSWAP ? Colors.colorize(Configuration.swapString, Colors.YELLOW) + separator + swap : null,
            "cpu"      => Configuration.showCPU ? Colors.colorize(Configuration.cpuString, Colors.YELLOW) + separator + cpu : null,
            "gpu"      => Configuration.showGPU ? Colors.colorize(Configuration.gpuString, Colors.YELLOW) + separator + gpu : null,
            "disk"     => Configuration.showDisk ? Colors.colorize(Configuration.diskString, Colors.YELLOW) + separator + disk : null,
            "packages" => Configuration.showPackages ? Colors.colorize(Configuration.packageString, Colors.YELLOW) + separator + packages : null,
            "haxe"     => Configuration.showHaxe ? Colors.colorize(Configuration.haxeString, Colors.YELLOW) + separator + haxe : null,
            "opengl"   => Configuration.showOpenGL ? Colors.colorize(Configuration.openglString, Colors.YELLOW) + separator + opengl : null,
            "vulkan"   => Configuration.showVulkan ? Colors.colorize(Configuration.vulkanString, Colors.YELLOW) + separator + vulkan : null,
            "uptime"   => Configuration.showUptime ? Colors.colorize(Configuration.uptimeString, Colors.YELLOW) + separator + uptime : null,
            "birthday" => Configuration.showBirthday ? Colors.colorize(Configuration.birthdayString, Colors.YELLOW) + separator + birthday : null,
            "birth"    => Configuration.showBirth ? Colors.colorize(Configuration.birthString, Colors.YELLOW) + separator + birth : null,
            "colors"   => Configuration.showBlock ? Colors.getColorBlocks() : null
        ];

        var infoLine:Array<String> = Configuration.modules.map(function(key) return modules.get(key)).filter(function(line) return line != null);

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