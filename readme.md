<div align="center">
<h2>Apostle</h2>
<p>My Nixos configuration<br>(tack + dendritic pattern)<br>FlakeLess Config</p>
</div>

<br>

![Desktop Overview](assets/mango-1.png)
<br>
![(Neovim(handle by mnw) | nitch | bottom)](assets/mango-2.png)
<br>
![Zed-editor](assets/mango-3.png)
![Librewolf | equibop](assets/mango-4.png)
<br>
![Komikku the Manga Reader](assets/mango-5.png)
<br>

> [!WARNING]
> Very cursed config. I will adapt this config to be mine. Studying Purpose Originally from [Iamvismorf/Greenhouse](https://github.com/Iamvismorf/Greenhouse.git)
<br>

> [!WARNING]
> Later i will completely remove the _mkStoreSymlink. I will use the hjem-impure more precisely.
<br>

#### You have been warned
The entry point is [./modules/hosts](modules/hosts)

<br>

## Features
+ [modules/hosts/default.nix](modules/hosts/default.nix) Automatic host creation
+ [.tack](.tack/default.nix) Alternative for Flake 
+ [utils/_recursiveImport](utils/_recursiveImport.nix) 
    + see [./default.nix](default.nix) for example usage
+ [Impure symlink](utils/_mkStoreSymlink.nix) dotfiles experience like in traditional UNIX systems
    + see ./modules/hosts/hostName/hjem/username/username.nix for example usage
+[hjem-impure](./modules/hosts/kagura/hjem/antonio/antonio.nix) alternative for _mkStoreSymlink using hjem-impure
+ [inputs.nix](inputs.nix) Automatic inputs creation
+ [Nvim config](./dots/neovim/default.nix)
    + plugin manage by npins via mnw [start-plugins](./dots/neovim/start-plugins.json) & [opt-plugins](./dots/neovim/opt-plugins.json)   
+ [Just recipes](Justfile)

## Credits
+ [Rexcrazy804/Zaphkiel](https://github.com/Rexcrazy804/Zaphkiel)
+ [denful/dendritic-unflake](https://github.com/denful/dendritic-unflake)
+ [Iamvismorf/Greenhouse](https://github.com/Iamvismorf/Greenhouse.git)
+ [manic-systems/tack](https://github.com/manic-systems/tack)
+ [pinning with npins blog by Jade](https://jade.fyi/blog/pinning-nixos-with-npins/)
+ [pinning with npins blog by piegames](https://piegames.de/dumps/pinning-nixos-with-npins-revisited/)
