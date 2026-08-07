# Haxefetch

Haxefetch is fetch program inspired by fastfetch, neofetch, pfetch, nerdfetch, hyfetch, etc and it is written in Haxe. [Don't know what's Haxe? Read more](https://haxe.org/) and [learn Haxe if you don't know!](https://haxe.org/documentation/introduction/)

<img width="962" height="466" alt="image" src="https://github.com/user-attachments/assets/822f6a7a-bf14-43ef-8c0e-d38534468b5d" />
<p align="center">(Haxefetch preview)</p>
<img width="736" height="206" alt="image" src="https://github.com/user-attachments/assets/b238c8c7-70b9-441c-9318-c10c657c65fb" />
<p align="center">(Haxefetch commads)</p>

## Dependencies
 - `inxi` - Required to show RAM type (optional)
 - `vulkaninfo` and `vulkantools` - Required to show Vulkan version (not optional)
 - `glxinfo` and `mesa-utils` - Required to show OpenGL version (not optional)


## How to use this?

If you want to use, follow this:
<details>
    <summary>Getting a binary</summary>

If you prefer binary,  -> [go here](https://github.com/ACoolioDude/Haxefetch/blob/main/binary/haxefetch) <-
</details>

<details>
    <summary>Getting Haxe and it's dependencies</summary>

1. Install dependencies.
   - Debian/Ubuntu: `apt-get install haxe mesa-utils vulkaninfo vulkan-tools`
   - Fedora/RHEL/RPM: `dnf install haxe mesa-dri-drivers vulkan-headers vulkan-loader vulkan-tools`
   - openSUSE Leap/Tumbleweed: `zypper install haxe Mesa`
   - Arch: `pacman -S haxe mesa mesa-utils vulkan-headers vulkan-tools`
   - Gentoo: `emerge --ask --verbose dev-lang/haxe media-libs/mesa x11-apps/mesa-progs media-libs/vulkan-loader dev-util/vulkan-headers dev-util/vulkan-tools` (if you have packages that are masked, [unmask them](https://wiki.gentoo.org/wiki/Knowledge_Base:Unmasking_a_package)) 
3. Install `g++`, if not present already.
4. Install git.
</details>

<details>
    <summary>Building Haxefetch</summary>

1. Clone my repo.
   - `git clone https://github.com/ACoolioDude/Haxefetch.git`
2. Setup development.
   - `cd Haxefetch` > `haxelib setup` (requires Haxe!) > Set haxelib environent to Haxefetch folder > install HXCPP `haxelib install hxcpp`
3. Compile Haxefetch.
   - `haxe build.hxml`
</details>


