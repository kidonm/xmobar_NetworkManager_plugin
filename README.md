# xmobar_NetworkManager_plugin
Xmobar plugin for NetworkManager

A simple plugin which for now displays the ESSID of Network the computer is connected to, or not connected at all.
Utilizes DBus to ask the NetworkManager. 

To install the plugin please refer to : http://projects.haskell.org/xmobar/#installingremoving-a-plugin
The plugin itself is located in the ```src/Plugins``` folder. You can edit the ```src/Config.hs``` file by yourself or use sample ```Config.hs``` supplied with this repository. 

Xmobar configuration is then located inside ```config``` folder.

## Sample installation
```
 cd <this repositor>
 cp src/Plugins/NetworkManager.hs <your xmobar sources>/src/Plugins/
 cp src/Config.hs <your xmobar sources>/src/ # when in doubt, edit it by yourself
 cabal install -fall_extenions
 xmobar config/.xmobarrc
```
