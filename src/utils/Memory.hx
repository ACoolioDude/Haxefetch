package utils;

import sys.FileSystem;
import sys.io.File;

class Memory {
    public static function memoryStats():{ram:String, swap:String} {
        var totalMemory:Float = 0.0;
        var freeMemory:Float = 0.0;
        var availableMemory:Float = 0.0;
        var bufferedMemory:Float = 0.0;
        var cachedMemory:Float = 0.0;
        var totalSwap:Float = 0.0;
        var freeSwap:Float = 0.0;

        if (FileSystem.exists("/proc/meminfo")) {
            try {
                var fin = File.read("/proc/meminfo", false);
                
                while (true) {
                    try {
                        var line = fin.readLine();
                        var colonIdx = line.indexOf(":");
                        if (colonIdx == -1) continue;

                        var key = StringTools.trim(line.substring(0, colonIdx));
                        var value = extractDigits(line.substring(colonIdx + 1));

                        switch (key) {
                            case "MemTotal": totalMemory = value;
                            case "MemFree": freeMemory = value;
                            case "MemAvailable": availableMemory = value;
                            case "Buffers": bufferedMemory = value;
                            case "Cached": cachedMemory = value;
                            case "SwapTotal": totalSwap = value;
                            case "SwapFree": freeSwap = value;
                            default: 
                        }
                    } catch (e:haxe.io.Eof) {
                        break;
                    }
                }
                fin.close();
            } catch (e:Dynamic) {}
        }

        var ramString = "N/A";
        if (totalMemory > 0) {
            var usedKylo = (availableMemory > 0) ? (totalMemory - availableMemory) : (totalMemory - freeMemory - bufferedMemory - cachedMemory);
            if (usedKylo < 0) usedKylo = 0;

            var usedGiga = roundDecimal(usedKylo / (1024.0 * 1024.0), 2);
            var totalGiga = roundDecimal(totalMemory / (1024.0 * 1024.0), 2);
            var percentage = Math.floor((usedKylo / totalMemory) * 100.0);
            var colors = (percentage >= 85) ? Colors.RED : (percentage >= 60 ? Colors.YELLOW : Colors.GREEN);
            var coloredPact = Colors.colorize('$percentage%', colors);
 
            Configuration.ramPercent ? ramString = '${usedGiga} GiB / ${totalGiga} GiB (${coloredPact})' : ramString = '${usedGiga} GiB / ${totalGiga} GiB';
        }

        var swapString = "Disabled";
        if (totalSwap > 0) {
            var usedSwapKilo = totalSwap - freeSwap;
            if (usedSwapKilo < 0) usedSwapKilo = 0;

            var usedSwapGiga = roundDecimal(usedSwapKilo / (1024.0 * 1024.0), 2);
            var totalSwapGiga = roundDecimal(totalSwap / (1024.0 * 1024.0), 2);
            var percentage = Math.floor((usedSwapKilo / totalSwap) * 100.0);
            var colors = (percentage >= 85) ? Colors.RED : (percentage >= 60 ? Colors.YELLOW : Colors.GREEN);
            var coloredPact = Colors.colorize('$percentage%', colors);

            Configuration.swapPercent ? swapString = '${usedSwapGiga} GiB / ${totalSwapGiga} GiB (${coloredPact})' : swapString = '${usedSwapGiga} GiB / ${totalSwapGiga} GiB';
        }

        return {ram: ramString, swap: swapString};
    }

    private static function extractDigits(raw:String):Float {
        var sb = new StringBuf();
        for (i in 0...raw.length) {
            var code = raw.charCodeAt(i);
            if (code >= 48 && code <= 57) {
                sb.addChar(code);
            } else if (sb.length > 0) {
                break;
            }
        }
        var numStr = sb.toString();
        if (numStr.length == 0) return 0.0;
        
        var parsed = Std.parseFloat(numStr);
        return Math.isNaN(parsed) ? 0.0 : parsed;
    }

    private static function roundDecimal(val:Float, precision:Int):Float {
        var factor = Math.pow(10, precision);
        return Math.round(val * factor) / factor;
    }

    public static function fetchRAMType():String {
        try {
            var process = Haxefetch.runCmd("sh", ["-c", "inxi --m --c 0 2>/dev/null | grep -i 'type:' | awk -F 'type:' '{print $2}' | awk '{print $1}' | grep -ivE 'no|none|unknown|n/a' | head -n 1"]);
            var type = StringTools.replace(process, ",", "");
            if (type.toLowerCase() != "" && type.toLowerCase() != "no" && type.toLowerCase() != "none" && type.toLowerCase() != "unknown" && type.toLowerCase() != "n/a") {
                return type;
            }
        } catch (e:Dynamic) {}
        return "";
    }
}