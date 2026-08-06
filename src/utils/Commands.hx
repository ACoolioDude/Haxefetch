package utils;

class Commands {
    public static final HAXEFETCH_VERSION:String = "1.0.0-a";

    public static function parse(argument:Array<String>):Void {
        for (args in argument) {
            switch (args) {
                case "-h" | "--help":
                    fetchHelp();
                    Sys.exit(0);
                
                case "-v" | "--version":
                    Sys.println("Haxefetch: " + HAXEFETCH_VERSION + " (Built on Haxe " + SystemUtils.fetchHaxe() + ")");
                    Sys.exit(0);
                
                default:
                    Sys.println('Unknown command ${args}');
                    Sys.println("Try -h or --help for current commands");
                    Sys.exit(0);
            }
        }
    }

    public static function fetchHelp():Void {
        Sys.println('In order to customise this:\n');

        var core:String = "Haxefetch.hx is core of this fetch program and you can see how you can customise options, etc.";
        var color:String = "Colors.hx is class file where you can add your custom colors (needs to be on different format)";
        var logo:String = "Logo.hx is class where you can add you custom distribution logo based of name from /etc/os-release";
        var memory:String = "Memory.hx is class where it handles RAM and SWAP usage";
        var utils:String = "SystemUtils.hx is class where it handles the core of fetch program inside of Haxefetch.hx";

        Sys.println('${core}\n${color}\n${logo}\n${memory}\n${utils}');
    }
}