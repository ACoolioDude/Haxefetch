# Haxefetch

Haxefetch is fetch program inspired by fastfetch, neofetch, pfetch, nerdfetch, hyfetch, etc and it is written in Haxe. [Don't know what's Haxe? Read more](https://haxe.org/) and [learn Haxe if you don't know!](https://haxe.org/documentation/introduction/)

<img width="943" height="475" alt="image" src="https://github.com/user-attachments/assets/e99e8ff1-815f-433a-806d-0bf7a38a7cf1" />
<p align="center">(Haxefetch preview)</p>
<img width="736" height="206" alt="image" src="https://github.com/user-attachments/assets/b238c8c7-70b9-441c-9318-c10c657c65fb" />
<p align="center">(Haxefetch commads)</p>

## Dependencies
 - `inxi` - Required to show RAM type (optional / not optional)
 - `vulkaninfo` and `vulkantools` - Required to show Vulkan version (optional / not optional)
 - `glxinfo` and `mesa-utils` - Required to show OpenGL version (optional / not optional)


## How to use this?

If you want to use, follow this:
<details>
    <summary>Getting a binary</summary>

If you prefer binary,  -> [go here](https://github.com/ACoolioDude/Haxefetch/blob/main/binary/haxefetch) <-
</details>

<details>
    <summary>Getting Haxe and it's dependencies</summary>

1. Install dependencies.
   - Debian/Ubuntu: `apt-get install haxe inxi mesa-utils vulkaninfo vulkan-tools git g++`
   - Fedora/RHEL/RPM: `dnf install haxe inxi mesa-dri-drivers vulkan-headers vulkan-loader vulkan-tools git g++`
   - openSUSE Leap/Tumbleweed: `zypper install inxi haxe Mesa git g++`
   - Arch: `pacman -S base-devel haxe inxi mesa mesa-utils vulkan-headers vulkan-tools git` (note for Arch users. If you get `cannot create Vulkan instance` error or it prints N/A, you need to install GPU Vulkan driver for your iGPU/dGPU specifically)
   - Gentoo: `emerge --ask --verbose dev-lang/haxe sys-apps/inxi media-libs/mesa x11-apps/mesa-progs media-libs/vulkan-loader dev-util/vulkan-headers dev-util/vulkan-tools dev-vcs/git sys-devel/gcc` (if you have packages that are masked, [unmask them](https://wiki.gentoo.org/wiki/Knowledge_Base:Unmasking_a_package))
2. Clone my repo.
   - `git clone https://github.com/ACoolioDude/Haxefetch.git`
2. Setup development.
   - `cd Haxefetch` > `haxelib setup` (requires Haxe!) > Set haxelib environent to Haxefetch folder `home/$USER/Haxefetch/.haxelib` > install HXCPP `haxelib install hxcpp`
3. Compile Haxefetch.
   - `haxe build.hxml`
</details>


