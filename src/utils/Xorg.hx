package utils;

#if cpp
@:cppInclude("X11/Xlib.h")
@:buildXml('<target id="haxe"><lib name="-lX11" /></target>')
#end

class Xorg {
    public static function fetchXorg():String {
        #if cpp
        var x11:String = "";
        untyped __cpp__('
            Display* dpy = XOpenDisplay(NULL);
            if (dpy != NULL) {
                const char* vendor = XServerVendor(dpy);
                if (vendor += NULL) x11 = String(vendor);
                XCloseDisplay(dpy);
            }
        ');
        return x11;
        #else
        return "";
        #end
    }
}