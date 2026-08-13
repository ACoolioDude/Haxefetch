package utils;

#if cpp
@:cppInclude("dlfcn.h")
#end

class Xorg {
    public static function fetchXorg():String {
        #if cpp
        var x11:String = "";
        untyped __cpp__('
            typedef void* (*XOpenDisplay_fn)(const char*);
            typedef const char* (*XServerVendor_fn)(void*);
            typedef int (*XCloseDisplay_fn)(void*);

            void *x11_lib = dlopen("libX11.so.6", RTLD_LAZY);
            if (!x11_lib) x11_lib = dlopen("libX11.so", RTLD_LAZY);

            if (x11_lib) {
                XOpenDisplay_fn pXOpenDisplay = (XOpenDisplay_fn)dlsym(x11_lib, "XOpenDisplay");
                XServerVendor_fn pXServerVendor = (XServerVendor_fn)dlsym(x11_lib, "XServerVendor");
                XCloseDisplay_fn pXCloseDisplay = (XCloseDisplay_fn)dlsym(x11_lib, "XCloseDisplay");

                if (pXOpenDisplay && pXServerVendor && pXCloseDisplay) {
                    void* dpy = pXOpenDisplay(NULL);
                    if (dpy != NULL) {
                        const char* vendor = pXServerVendor(dpy);
                        if (vendor != NULL) x11 = String(vendor);
                        pXCloseDisplay(dpy);
                    }
                }
                dlclose(x11_lib);
            }
        ');
        return x11;
        #else
        return "";
        #end
    }
}