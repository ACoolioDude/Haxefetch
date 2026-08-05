# Haxefetch

<img width="969" height="464" alt="image" src="https://github.com/user-attachments/assets/8ed4e309-8505-4f43-a0c1-f4d78c14ebf5" />

Haxefetch is fetch program inspired by fastfetch, neofetch, pfetch, nerdfetch, hyfetch, etc and it is written in Haxe [Don't know what's Haxe? Read more](https://haxe.org/)

## Dependencies
 - `vulkaninfo` and `vulkantools` - Required to show Vulkan version
 - `glxinfo` and `mesa-utils` - Required to show OpenGL version


## Building

If you want to build this and configure on your own, follow this:
<details>
    <summary>Instructions</summary>

1. Install Haxe (it can be any).
   - Debian/Ubuntu: `apt-get install haxe`
   - Fedora/RHEL/RPM: `dnf install haxe`
   - openSUSE Leap/Tumbleweed: `zypper install haxe`
   - Arch: `pacman -S --noconfirm haxe`
   - Gentoo: `emerge --ask --verbose dev-lang/haxe` (if you have packages that are masked, unmask them) 
3. Install `g++`, if not present already.
4. Install git.
</details>

<details>
    <summary>Compile and configure</summary>

1. Clone my repo.
   - `https://github.com/ACoolioDude/Haxefetch`
2. Setup development.
   - `cd Haxefetch` > `haxelib setup` (requires Haxe!) > Set haxelib environent to Haxefetch folder > install HXCPP `haxelib install hxcpp`
3. Compile Haxefetch.
   - `haxe build.hxml`
</details>
