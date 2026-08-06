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

                case "-c" | "--config":
                    Configuration.generateConfiguration();

                default:
                    Sys.println('Unknown command ${args}');
                    Sys.println("Try -h or --help for current commands");
                    Sys.exit(0);
            }
        }
    }

    public static function fetchHelp():Void {
        Sys.println('In order to customise this:\n');

        var instructions:String = 'Generate configuration with "haxefetch --config" (it is located into /home/USER/.config/haxefetch directory)';
        var examples:String = 'Here are examples:\n\nshow_hostname=true\nshow_distro=true\nshow_window_manager=true\nshow_ram=true\nshow_swap=true\nshow_cpu=true\nshow_gpu=true\nshow_package=true\nshow_haxe_version=true\nshow_opengl_version=true\nshow_vulkan_version=true\nshow_uptime=true\nshow_birthday=true\nshow_birth=true';

        Sys.println('${instructions}\n${examples}');
    }
}