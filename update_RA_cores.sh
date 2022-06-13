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
    -_____---   ---       # version number of RA (e.g. 1.10.3) when prompted,#
     //  \ \\   ___-      #     and where RA is installed (internal, sd)     #
   //|\__/  \\  \         #						     #
   \_-\_____/  \-\	  #        Written by lajoshanostra 2022	     #
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

####################################################################################################
#			User input version number of RA Cores to be downloaded      		   #
#			     Buildbot pages are separated by version number			   #
# 			     Input will be set as variable name $VERSION			   #
####################################################################################################

read -e -p "What version of Retroarch Cores will you be updating to (e.g 1.10.3)?:" VERSION

####################################################################################################
# 			User input where RA is installed and setting variables			   #
# 			    Input will be set as variable name $LOCATION			   #
# 			    Following is an if, then, else, then statement			   #
# If location is internal -> Set $RA_DIRECTORY to path-to internal storage location of RetroArch   #
# If location is on the SD Card -> Set $RA_DIRECTORY to path-to sd card location of RetroArch      #
# $RA_DIRECTORY will then be used as the path to download RA Core Info Files and Cores themselves  #
####################################################################################################

read -e -p "Where is RetroArch installed on your Steam Deck? (internal, sd)?:" LOCATION

if [ $LOCATION = 'internal' ]
then
        RA_DIRECTORY=/home/deck/.local/share/Steam/steamapps/common/RetroArch/cores
elif [ $LOCATION = 'sd' ]
then
        RA_DIRECTORY=/run/media/mmcblk0p1/steamapps/common/RetroArch/cores
fi

[[ "$(read -e -p 'You have input RA Cores Version '$VERSION' to install, and '$LOCATION' memory, as to where RetroArch is installed. Continue? [y/N]> '; echo $REPLY)" == [Yy]* ]]


####################################################################################################################################################################################
# Clean up Cores folder and start Cores download process. Git clones fail if cores folder has any files hidden or otherwise, including . current directory and .. parent directory #
####################################################################################################################################################################################

echo Downloading RetroArch_cores.7z and Core Info Files now

rm -rf $RA_DIRECTORY
git clone https://github.com/libretro/libretro-core-info.git $RA_DIRECTORY
wget "https://buildbot.libretro.com/stable/$VERSION/linux/x86_64/RetroArch_cores.7z" -P $RA_DIRECTORY
cd $RA_DIRECTORY && 7z e RetroArch_cores.7z

####################################################################################################
#		Further cleanup -- RetroArch_cores.7z include several empty folders		   #
####################################################################################################

rm -rf configure cores retroarch RetroArch-Linux-x86_64 RetroArch-Linux-x86_64.AppImage.home

cat << "EOF"

		 _____                             
		/  ___|                            
		\ `--. _   _  ___ ___ ___  ___ ___ 
		 `--. \ | | |/ __/ __/ _ \/ __/ __|
		/\__/ / |_| | (_| (_|  __/\__ \__ \
		\____/ \__,_|\___\___\___||___/___/

EOF

echo You may now close this window. Have fun!
