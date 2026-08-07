# Haxefetch

Haxefetch is fetch program inspired by fastfetch, neofetch, pfetch, nerdfetch, hyfetch, etc and it is written in Haxe. [Don't know what's Haxe? Read more](https://haxe.org/) and [learn Haxe if you don't know!](https://haxe.org/documentation/introduction/)

<img width="966" height="466" alt="image" src="https://github.com/user-attachments/assets/95ecf5fd-3f5b-41d4-aae4-f4710a0726f1" />
<p align="center">(Haxefetch preview)</p>
<img width="1113" height="295" alt="image" src="https://github.com/user-attachments/assets/c6fd4b9e-cd3e-484a-a005-17eeea5b411f" />
<p align="center">(Haxefetch commads)</p>

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


