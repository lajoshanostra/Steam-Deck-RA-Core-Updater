#!/bin/bash

			  ### Gotta Go Fast! ###

cat << "EOF"
        ______     _              ___           _       _____
        | ___ \   | |            / _ \         | |     /  __ \
        | |_/ /___| |_ _ __ ___ / /_\ \_ __ ___| |__   | /  \/ ___  _ __ ___  ___
        |    // _ \ __| '__/ _ \|  _  | '__/ __| '_ \  | |    / _ \| '__/ _ \/ __|
        | |\ \  __/ |_| | | (_) | | | | | | (__| | | | | \__/\ (_) | | |  __/\__ \
        \_| \_\___|\__|_|  \___/\_| |_/_|  \___|_| |_|  \____/\___/|_|  \___||___/
                ___------__
         |\__-- /\       _-
         |/    __      -          ####################################################
         //\  /  \    /__         #    This script will download RetroArch Linux     #
         |  o|  0|__     --_      #    Cores and unpack them in your RA directory    #
         \\____-- __ \   ___-     #                                                  #
         (@@    __/  / /_         #     All you need to do is input the latest       #
            -_____---   ---       # version number of RA (e.g. 1.16.0) when prompted,#
             //  \ \\   ___-      #     and where RA is installed (internal, sd)     #
           //|\__/  \\  \         #						     #
           \_-\_____/  \-\	  #        Written by lajoshanostra 2023	     #
                // \\--\|	  #       https://github.com/lajoshanostra           #
           ____//  ||_		  ####################################################
          /_____\ /___\
                  ______                    _                 _
                  |  _  \                  | |               | |
                  | | | |_____      ___ __ | | ___   __ _  __| | ___ _ __
                  | | | / _ \ \ /\ / / '_ \| |/ _ \ / _` |/ _` |/ _ \ '__|
                  | |/ / (_) \ V  V /| | | | | (_) | (_| | (_| |  __/ |
                  |___/ \___/ \_/\_/ |_| |_|_|\___/ \__,_|\__,_|\___|_|


EOF

# Styles

border_color_info="#1375c2"
border_color_waiting="#f9bb01"
border_color_success="#107c10"

color_text() {
    text=$1
    gum style --foreground "#013bb0" "$text"
}

color_text_2() {
    text=$1
    gum style --foreground "#f9bb01" "$text"
}

color_text_warning() {
    text=$1
    gum style --foreground "#f03b3e" "$text"
}


gum style \
    --border rounded \
    --border-foreground "$border_color_waiting" \
    --align center \
    --width 100 \
    --margin "10 10 10" \
    --padding "10 10 10" \
    "This script requires being run as $(color_text_warning "sudo"), and will make the Steam Filesystem $(color_text_2 "no longer immutable"). We will also install two packages using pacman: jq and gum." \
    "" \
    "There will be an option to $(color_text_2 "re-enable") the immutable file system, and uninstall jq and gum at the end of the script. $(color_text_warning "Continue???")" && gum confirm || exit

# Make FS writeable, download gum and jq

sudo steamos-readonly disable && pacman -S --needed gum jq

# User input version number of RA Cores to be downloaded

gum style \
    --align center \
    --width 100 \
    --padding "2" \
    "What $(color_text "version") of Retroarch Cores will you be updating to? Latest are listed below:"

curl -s "https://api.github.com/repos/libretro/RetroArch/tags" | jq '.[0,1,2,3,4].name' > tags.json  
sed 's/["v]//g' tags.json > versions.json

VERSION=$(cat versions.json | gum choose)

# User input where RA is installed and setting variables
# Input will be set as variable name $LOCATION
# Following is an if, then, else, then statement
# If location is internal -> Set $RA_DIRECTORY to path-to internal storage location of RetroArch
# If location is on the SD Card -> Set $RA_DIRECTORY to path-to sd card location of RetroArch
# $RA_DIRECTORY will then be used as the path to download RA Core Info Files and Cores themselves

gum style \
    --align center \
    --width 100 \
    --padding "2" \
    "Where is RetroArch installed on your Steam Deck? $(color_text "internal"), $(color_text_2 "sd")?:"

LOCATION=$(gum choose --height 15 "internal" "sd")

if [ $LOCATION = 'internal' ]
then
        RA_DIRECTORY=/home/deck/.local/share/Steam/steamapps/common/RetroArch/cores
elif [ $LOCATION = 'sd' ]
then
        RA_DIRECTORY=/run/media/mmcblk0p1/steamapps/common/RetroArch/cores
fi

# Confirmation check before proceeding with downloads

gum style \
    --border rounded \
    --border-foreground "$border_color_info" \
    --align center \
    --width 100 \
    --padding "2" \
    "You have input RA Cores Version $(color_text "'$VERSION'") to install, and $(color_text_2 "'$LOCATION'") memory, as to where RetroArch is installed. Continue?" && gum confirm || exit

# Clean up Cores folder and start Cores download process. Git clones fail if cores folder has any files hidden or otherwise, including . current directory and .. parent directory

gum style \
    --border double \
    --border-foreground "$border_color_waiting" \
    --align center \
    --width 100 \
    --padding "2" \
    "Downloading RetroArch_cores.7z and Core Info Files now..."

rm -rf tags.json versions.json $RA_DIRECTORY
gum spin -s dot --title 'Downloading RA Core Info Files...' -- git clone https://github.com/libretro/libretro-core-info.git $RA_DIRECTORY
gum spin -s dot --title 'Downloading RA Cores...' -- wget -q "https://buildbot.libretro.com/stable/$VERSION/linux/x86_64/RetroArch_cores.7z" -P $RA_DIRECTORY
cd $RA_DIRECTORY
gum spin -s dot --title 'Extracting cores and cleaning up...' -- 7z e RetroArch_cores.7z >> /dev/null

# Further cleanup -- RetroArch_cores.7z include several empty folders

rm -rf RetroArch_cores.7z configure cores retroarch RetroArch-Linux-x86_64 RetroArch-Linux-x86_64.AppImage.home

gum style \
    --border rounded \
    --border-foreground "$border_color_success" \
    --align center \
    --width 100 \
    --padding "2" \
    "Success! Enjoy the latest RetroArch!"

exit