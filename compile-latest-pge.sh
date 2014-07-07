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
# Version 0.2.0
# Check GitHub for the latest version of the script
# https://github.com/Luigifan/platgenwohl-compile-script
function COMPILE_LATEST_EDITOR()
{
	workDir=`pwd`
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
	version=`cat version.txt`
	find '(' -name main.cpp -o -name mainwindow.cpp -o -name mainwindow.h -o -name mainwindow.ui -o -name PlatGenWohl_Editor.pro -o -name version.txt -o -name _resources -o -name about_dialog -o -name common_features -o -name data_configs -o -name edit_level -o -name edit_npc -o -name file_formats -o -name item_select_dialog -o -name languages -o -name level_scene -o -name libs -o -name main_window -o -name npc_dialog -o -name *.sh ')' -prune -o -exec rm -rf {} \;
	echo "Compiling v$version.."
	{ #try
		qmake
		echo "qmake completed successfully!"
	} || { #catch
		echo "qmake couldn't complete!"
		mv log qmake_log.txt
	}
	{ #try
		echo "Running make"
		echo "make is currently being output to 'make_output.txt' in this scripts directory"
		make >& $workDir/make_output.txt
		echo "make completed successfully!"
		echo "Build complete!"
		echo "---------------------------------------------------------------------------"
	} || { #catch
		echo "make couldn't complete!"
		mv log make_log.txt
	}
	echo "Would you like to copy all the files to the desktop? (select no if build failed)"
	PS3="Select option (1, 2): "
	options=("Yes" "No")
	select opt in "${options[@]}"
	do
		case $opt in
			"Yes")
				COPY_FILES_DESKTOP;
				break
				;;
			"No")
				echo "Will not copy!"
				break
				;;
		esac
	done
	break;
}
function COPY_FILES_DESKTOP()
{
	clear
	version2=`cat version.txt`
	echo "Copying files to $HOME/platgenwohl_$version2"
	if [ -d "$HOME/Desktop/platgenwohl_$version2" ]; then
		echo "We detected an existing directory. Would you like to remove it?"
		echo "Please make sure there aren't any important files in there."
		PS3="Select option (1, 2): "
		options=("Yes" "No")
		select opt in "${options[@]}"
		do
			case $opt in
				"Yes")
					echo "Removing $HOME/Desktop/platgenwohl_$version2"
					rm -rf "$HOME/Desktop/platgenwohl_$version2"
					break
					;;
				"No")
					echo "Will rename existing directory!"
					sudo mv "$HOME/Desktop/platgenwohl_$version2" "$HOME/Desktop/platgenwohl_$version2_old"
					break
					;;
			esac
		done
	fi
	mkdir "$HOME/Desktop/platgenwohl_$version2"
	cp -a "pge_editor" "$HOME/Desktop/platgenwohl_$version2/pge_editor"
	chmod +x "$HOME/Desktop/platgenwohl_$version2/pge_editor"
	cd ..
	cd "Content"
	echo "Copying configs..."
	cp -ar "configs" "$HOME/Desktop/platgenwohl_$version2/configs"
	echo "Copying data..."
	cp -ar "data" "$HOME/Desktop/platgenwohl_$version2/data"
	echo "Copying help..."
	cp -ar "help" "$HOME/Desktop/platgenwohl_$version2/help"
	echo "Done! Just get the SMBX_Graphics.zip from Wohlstand or an existing SMBX installation"
	break;
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
			echo "not implemented"
			;;
		"Sync Repos")
			echo "not implemented"
			;;
		"Quit")
			echo "Goodbye!"
			break
			;;
	esac
done
#
