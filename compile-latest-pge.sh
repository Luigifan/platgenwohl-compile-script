#!/bin/bash
#    _____  _       _    _____ ______   __          __   _     _ 
#   |  __ \| |     | |  / ____|  ____|  \ \        / /  | |   | |
#   | |__) | | __ _| |_| |  __| |__   _ _\ \  /\  / /__ | |__ | |
#   |  ___/| |/ _` | __| | |_ |  __| | '_ \ \/  \/ / _ \| '_ \| |
#   | |    | | (_| | |_| |__| | |____| | | \  /\  / (_) | | | | |
#   |_|    |_|\__,_|\__|\_____|______|_| |_|\/  \/ \___/|_| |_|_|
#                                                                
#
# Script created by Luigifan2010
# Version 0.1
# Check GitHub for the latest version of the script
# 
function COMPILE_LATEST_EDITOR()
{
	clear
	echo "Will compile latest PlatGEnWohl"
	echo "If at any time you want to force quit, press Ctrl+C on your keyboard."
	echo "Be warned! This could cause corrupted files and/or incomplete compilations."
	echo "--------------------------------------------------------------------------------"
	echo "Now working in home directory.."
	cd 
	if [ -f "master.zip" ]; then
		rm master.zip
	fi
	wget https://github.com/Wohlstand/PlatGEnWohl/archive/master.zip
	if [ ! -f "/usr/bin/unzip" ]; then
		echo "Need to install unzip, hold tight and type your password if prompted"
		sudo apt-get install unzip
	fi
	echo "Unzipping.."
	unzip -o master.zip -d "platgenwohl-master"
	echo "Done unzipping!"
	echo "--------------------------------------------------------------------------------"
	echo "Now working in the 'platgenwohl-master' directory.."
	cd platgenwohl-master
	cd PlatGEnWohl-master
	cd Editor
	echo "Compiling.."
	qmake
	make
	{ #try
		qmake &&
		mv output
		echo "qmake completed successfully!"
	} || { #catch
		echo "qmake couldn't complete!"
		mv log
	}
	{ #try
		make &&
		mv output
		echo "make completed successfully!"
		echo "Build complete!"
	} || { #catch
		echo "qmake couldn't complete!"
		mv log
	}
	echo="Would you like to copy all the files to the desktop? (select no if build failed)"
	PS3="Select option (1, 2): "
	options=("Yes" "No")
	select opt in "${options[@]}"
	do
		case $opt in
			"Yes")
				COPY_FILES_DESKTOP;
				;;
			"No")
				echo "Will not copy!"
				break
				;;
		esac
	done
}
function COPY_FILES_DESKTOP()
{
	echo "Copying files to desktop directory 'platgenwohl_scriptcompiled'"
	if [ -d "~/Desktop/platgenwohl_scriptcompiled" ]; then
		printf="We detected an existing directory. Would you like to remove it?\nPlease make sure there aren't any important files in there."
		PS3="Select option (1, 2): "
		options=("Yes" "No")
		select opt in "${options[@]}"
		do
			case $opt in
				"Yes")
					rm -rf "~/Desktop/platgenwohl_scriptcompiled"
					;;
				"No")
					echo "Will rename existing directory!"
					sudo mv "~/Desktop/platgenwohl_scriptcompiled" "~/Desktop/platgenwohl_scriptcompiled_old"
					break
					;;
	fi
	mkdir "~/Desktop/platgenwohl_scriptcompiled"
	cp -a "pge_editor" "~/Desktop/platgenwohl_scriptcompiled/pge_editor"
	chmod +x "~/Desktop/platgenwohl_scriptcompiled/pge_editor"
	cd ..
	cd "Content"
	echo "Copying configs..."
	cp -ar "configs" "~/Desktop/platgenwohl_scriptcompiled/configs"
	echo "Copying data..."
	cp -ar "data" "~/Desktop/platgenwohl_scriptcompiled/data"
	echo "Copying help..."
	cp -ar "help" "~/Desktop/platgenwohl_scriptcompiled/help"
	echo "Done!"
}
########
clear
echo ".______________________________________."
echo "|                                      |"
echo "|     PlatGEnWohl Compiler Script      |"
echo "|          By Luigifan2010             |"
echo "|                                      |"
echo "|                                      |"
echo "|          Select an Option            |"
echo "|______________________________________|"
echo ""
#echo "1. Compile Latest"
#echo "2. Remove Current"
#echo "3. Sync"
PS3="Select an option (1, 2, 3, 4): "
options=($"Compile Latest" $"Remove Current" $"Sync Repos" $"Quit")
select opt in "${options[@]}"
do
	case $opt in
		"Compile Latest")
			echo "will compile latest"
			COMPILE_LATEST_EDITOR;
			;;
		"Remove Current")
			echo "will remove current repo"
			;;
		"Sync Repos")
			echo "Will sync repos"
			;;
		"Quit")
			echo "Goodbye!"
			break
			;;
	esac
done
#
