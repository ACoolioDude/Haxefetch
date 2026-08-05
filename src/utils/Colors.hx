package utils;

class Colors {
    public static var RESET:String   = "\x1b[0m";
    public static var BOLD:String    = "\x1b[1m";

    public static var RED:String     = "\x1b[31m";
    public static var GREEN:String   = "\x1b[32m";
    public static var YELLOW:String  = "\x1b[33m";
    public static var BLUE:String    = "\x1b[34m";
    public static var MAGENTA:String = "\x1b[35m";
    public static var CYAN:String    = "\x1b[36m";
    public static var WHITE:String   = "\x1b[37m";

    public static function colorize(name:String, color:String):String {
        return '${color}${BOLD}${name}${RESET}';
    }

    public static function stripAnsi(str:String):String {
        var r = ~/\x1b\[[0-9;]*m/g;
        return r.replace(str, "");
    }

    public static function getColorBlocks():String {
        return "\x1b[40m  " +
               "\x1b[41m  " +
               "\x1b[42m  " +
               "\x1b[43m  " +
               "\x1b[44m  " +
               "\x1b[45m  " +
               "\x1b[46m  " +
               "\x1b[47m  " + RESET;
    }
}