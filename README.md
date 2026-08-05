# Haxefetch

<img width="974" height="470" alt="image" src="https://github.com/user-attachments/assets/f138cfa2-5a97-490a-bf62-6a4f1e2869ca" />

Haxefetch is fetch program inspired by fastfetch, neofetch, pfetch, nerdfetch, hyfetch, etc and it is written in Haxe. [Don't know what's Haxe? Read more](https://haxe.org/)

## Dependencies
 - `vulkaninfo` and `vulkantools` - Required to show Vulkan version
 - `glxinfo` and `mesa-utils` - Required to show OpenGL version


## How to use this?

If you want to use, follow this:
<details>
    <summary>Getting a binary</summary>

If you prefer binary, -> [go here](https://github.com/ACoolioDude/Haxefetch/blob/main/binary/haxefetch) <-
</details>

<details>
    <summary>Getting Haxe and it's dependencies</summary>

1. Install Haxe (it can be any).
   - Debian/Ubuntu: `apt-get install haxe`
   - Fedora/RHEL/RPM: `dnf install haxe`
   - openSUSE Leap/Tumbleweed: `zypper install haxe`
   - Arch: `pacman -S --noconfirm haxe`
   - Gentoo: `emerge --ask --verbose dev-lang/haxe` (if you have packages that are masked, [unmask them](https://wiki.gentoo.org/wiki/Knowledge_Base:Unmasking_a_package)) 
3. Install `g++`, if not present already.
4. Install git.
</details>

<details>
    <summary>Building Haxefetch</summary>

1. Clone my repo.
   - `https://github.com/ACoolioDude/Haxefetch`
2. Setup development.
   - `cd Haxefetch` > `haxelib setup` (requires Haxe!) > Set haxelib environent to Haxefetch folder > install HXCPP `haxelib install hxcpp`
3. Compile Haxefetch.
   - `haxe build.hxml`
</details>


