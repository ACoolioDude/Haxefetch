# Haxefetch

Haxefetch is fetch program inspired by fastfetch, neofetch, pfetch, nerdfetch, hyfetch, etc and it is written in Haxe[Don't know what's Haxe? Read more](https://haxe.org/)

## Dependencies
 - `vulkaninfo` and `vulkantools` - Required to show Vulkan version
 - `glxinfo` and `mesa-utils` - Required to show OpenGL version


## Building

If you want to build this and configure on your own, follow this:
<details>
    <summary>Instructions</summary>

1. Install Haxe (it can be any).
   - i Debian/Ubuntu: `apt-get install haxe`
   - i Fedora/RHEL/RPM: `dnf install haxe`
   - i openSUSE Leap/Tumbleweed: `zypper install haxe`
   - i Arch: `pacman -S --noconfirm haxe`
   - i Gentoo: `emerge --ask --verbose dev-lang/haxe` (if you have packages that are masked, unmask them)
3. Install `g++`, if not present already.
4. Install git.
</details>

<details>
    <summary>Compile and configure</summary>

1. Clone my repo.
   - i `https://github.com/ACoolioDude/Haxefetch`
2. Setup development.
   - i `cd Haxefetch` > `haxelib setup` (requires Haxe!) > Set haxelib environent to Haxefetch folder > install HXCPP `haxelib install hxcpp`
3. Compile Haxefetch.
   - i `haxe build.hxml`
</details>