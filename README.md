# Steam-Deck-RA-Core-Updater

![Script](https://github.com/lajoshanostra/Steam-Deck-RA-Core-Updater/blob/develop/image.png)

This script is designed to assist in downloading *all* RetroArch cores and info files from Libretro instead of relying on Steam DLC.
It is meant to be as easy-to-use as possible, as there are a lot of Steam Deck users not entirely familiar with Linux.🐧

I have seen many users on the Steam Deck forums on Reddit and elsewhere relying on the Flatpak version of RetroArch from the Discover Store due to the core availability over the Steam version, and the Steam version relying on it's DLC. 

It doesn't have to be that way! You can manually download the cores and drop the files into the Steam RetroArch directory. 

This script will simplify that process for end-users, because ☁️**STEAM CLOUD SAVES**☁️ are more beneficial than just about anything!

## What this script does
- Prompt the user on what version of RetroArch cores they wish to download (e.g. 1.10.3)
- Prompt the user on where their version of RetroArch is installed (internal, sd)
- Cleanup the currently installed cores directory
- Git clones the [Libretro core info files](https://github.com/libretro/libretro-core-info.git) into your cores directory
- Downloads the RetroArch_cores.7z from the [Libretro Buildbot page](https://buildbot.libretro.com/stable/1.10.3/linux/x86_64/), based on the user input version
- Extracts cores
- Final cleanup of unused files from the cores archive

## How to use this script
### From the Steam Deck
- On your Steam Deck, switch to Desktop Mode and download the Bash script `update_RA_cores.sh` from this repository
- By default, this should download to your Downloads folder at `/home/deck/Downloads`
- Right-click on the file in Dolphin (default File Explorer)-> Properties
- Click on the `Permissions` tab, and ensure that you select the checkbox next to `Is Executable` -> click `OK`


![Permissions](https://github.com/lajoshanostra/Steam-Deck-RA-Core-Updater/blob/main/permissions.png?raw=true)


- Right-click on the file again -> select `Run in Konsole`. This will run the script in the Steam Deck's default Terminal (Konsole)

### From a computer
- Download `update_RA_cores.sh` and `scp` the file to your Steam Deck.
- Open a `ssh` to your Steam Deck
- Make the script exectuable: `chmod +X update_RA_cores.sh`
- Run the script (as sudo): `sudo sh update_RA_cores.sh`
---
- You will be greeted by a familar rodent, with short instructions on how to use the script
- The script will prompt you on what version of RetroArch cores you wish to download. Currently the mainline version is `1.16.0`. 
- The script will then prompt you whether your Steam Version of RetroArch is installed on `internal` memory, or `sd` memory. Please select either `internal` or `sd`
- A confirmation prompt will appear, displaying which version you have selected, and where your RetroArch is installed. Select `yes` to continue or `no` to exit the script
---
- That's it~! The script will take care of the rest!
- Once you see `Success` on screen, close the Konsole window, return to Game Mode, launch, RetroArch, and start playing!
