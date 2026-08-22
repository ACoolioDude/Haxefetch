package;

import sys.io.Process;

#if cpp
@:headerCode('
#include <ostream>
')
#end

class Haxefetch {
    static var user:String;
    static var hostname:String;
    static var host:String;
    static var distro:String;
    static var init:String;
    static var initSuffix:String;
    static var kernel:String;
    static var desktop:String;
    static var session:String;
    static var protocol:String;        
    static var gpu:String;
    static var birthday:String;
    static var birth:String;
    static var logoColor:String;
    static var logo:Array<String>;
    static var logoWidth:Int = 0;

    static function main():Void {
        #if cpp
        untyped __cpp__("std::atexit([](){ printf(\"\\033[?25h\"); fflush(stdout); });");
        #end

        Commands.parse(Sys.args());
        Configuration.loadConfig();

        fetchStatic();
        fetch();
    }

    public static function fetchStatic():Void {
        user = getEnvironment("USER", getEnvironment("USERNAME", "user"));
        logo = Logo.fetchLogo(distro, Configuration.logoSize, Configuration.logo, logoColor);
        hostname = SystemUtils.fetchHostname();
        host = SystemUtils.fetchHost();
        distro = SystemUtils.fetchDistro();
        init = SystemUtils.fetchInit();
        initSuffix = (init != "") ? ' [${Colors.colorize(init, Colors.GREEN)}]' : '';
        kernel = SystemUtils.fetchKernel();
        desktop = XdgSession.fetchDestkop();
        session = XdgSession.fetchSession();
        protocol = XdgSession.fetchProtocol();
        gpu = GPUUtility.fetchGPU();
        birthday = SystemUtils.fetchBirthday();
        birth = SystemUtils.fetchInstalledDate();

        var target = (Configuration.logo != null && Configuration.logo != "") ? Configuration.logo : distro;
        var object = Logo.fetchColor(target);
        var mainColor = (object != null && object.primary != null) ? object.primary : Colors.RESET;
        var customColor = Colors.getColors(Configuration.logoColor);
        logoColor = (customColor != "" && customColor != null) ? customColor : mainColor;

        logo = Logo.fetchLogo(distro, Configuration.logoSize, Configuration.logo, logoColor);

        logoWidth = 0;
        for (line in logo) {
            var visibleLen = Colors.stripAnsi(line).length;
            if (visibleLen > logoWidth) logoWidth = visibleLen;
        }
    }

    public static function fetch():Void {
        var memory = Memory.memoryStats();
        var ram = memory.ram;
        var swap = memory.swap;
        var cpu = CPUUtility.fetchCPU();
        var gpu = GPUUtility.fetchGPU();
        var disk = DiskUtility.fetchDisk();
        var packages = Packages.fetchPackage();
        var packageSuffix = (packages != "") ? packages : '';
        var uptime = SystemUtils.fetchUptime();
        var separator:String = " ";

        var modules:Map<String, String> = [
            "hostname" => Configuration.showHostname ? Colors.colorize(user, Colors.RED) + "@" + Colors.colorize(hostname, Colors.RED) : null,
            "host"     => (Configuration.showHost && host != null) ? (Configuration.showHost ? Colors.colorize(Configuration.hostString, logoColor) + Configuration.separator + separator + host : null) : null,
            "os"       => Configuration.showDistro ? Colors.colorize(Configuration.distroString, logoColor) + Configuration.separator + separator + distro + (Configuration.init ? initSuffix : "") : null,
            "kernel"   => Configuration.showKernel ? Colors.colorize(Configuration.kernelString, logoColor) + Configuration.separator +separator + kernel : null,
            "de"       => (desktop != null && desktop != "N/A" && desktop != "" && Configuration.showDesktop) ? Colors.colorize(Configuration.desktopString, logoColor) + Configuration.separator + separator + desktop : null,
            "wm"       => (Configuration.showSession && session != null && session != "") ? Colors.colorize(Configuration.sessionString, logoColor) + Configuration.separator + separator + session + (Configuration.protocol ? ' (${protocol})' : '') : null,
            "ram"      => Configuration.showRAM ? Colors.colorize(Configuration.ramString, logoColor) + Configuration.separator + separator + ram : null,
            "swap"     => Configuration.showSWAP ? Colors.colorize(Configuration.swapString, logoColor) + Configuration.separator + separator + swap : null,
            "cpu"      => Configuration.showCPU ? Colors.colorize(Configuration.cpuString, logoColor) + Configuration.separator + separator + cpu : null,
            "gpu"      => Configuration.showGPU ? Colors.colorize(Configuration.gpuString, logoColor) + Configuration.separator +separator + gpu : null,
            "disk"     => Configuration.showDisk ? Colors.colorize(Configuration.diskString, logoColor) + Configuration.separator + separator + disk : null,
            "packages" => Configuration.showPackages ? Colors.colorize(Configuration.packageString, logoColor) + Configuration.separator + separator + packageSuffix : null,
            "uptime"   => Configuration.showUptime ? Colors.colorize(Configuration.uptimeString, logoColor) + Configuration.separator + separator + uptime : null,
            "birthday" => Configuration.showBirthday ? Colors.colorize(Configuration.birthdayString, logoColor) + Configuration.separator + separator + birthday : null,
            "birth"    => Configuration.showBirth ? Colors.colorize(Configuration.birthString, logoColor) + Configuration.separator + separator + birth : null,
            "colors"   => Configuration.showBlock ? Colors.getColorBlocks() : null
        ];

        var infoLine:Array<String> = Configuration.modules.map(function(key) return modules.get(key)).filter(function(line) return line != null);

        var maximumLine = logo.length > infoLine.length ? logo.length : infoLine.length;
        for (i in 0...maximumLine) {
            var left = i < logo.length ? logo[i] : "";
            var right = i < infoLine.length ? infoLine[i] : "";

            if (logoColor != "" && logoColor != null) {
                var color = Colors.getColors(logoColor);
                if (color != "") left = color + Colors.stripAnsi(left) + Colors.RESET; 
            }

            var visibleLeftLen = Colors.stripAnsi(left).length;
            var padding = (logoWidth + 3) - visibleLeftLen;
            if (padding < 0) padding = 0;
            
            var space = StringTools.lpad("", " ", padding);
            Sys.println('$left$space$right\x1B[K');
        }
    }

    public static function fetchLive():Void {
        Sys.print("\x1B[?25l");

        #if cpp
        untyped __cpp__("std::atexit([](){ printf(\"\\033[?25h\"); fflush(stdout); });");
        #end

        while (true) {
            Sys.print("\x1B[H");
            fetch();
            Sys.sleep(0.5);
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