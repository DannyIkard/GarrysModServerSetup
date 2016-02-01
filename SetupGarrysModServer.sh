#!/bin/bash
clear


#----------- Get steam username and password for SteamCMD login ----------
sudo printf "%s" ""
printf "\n\n%s" "Enter your steam login: "; read STEAMUSERNAME
printf "%s" "Enter your steam password: "; read -s STEAMPASSWORD



#----------- Install dependencies and directories ------------------------
su -c "echo 'deb http://ftp.us.debian.org/debian/ testing main contrib non-free' >> /etc/apt/sources.list" root
sudo apt-get update
sudo apt-get upgrade
sudo apt-get -y -t testing libc6
sudo apt-get -y install lib32gcc1 libpng12-0 lib32stdc++6 lib32tinfo5
mkdir -p ~/Steam/steamapps/common/Starbound/ 2>/dev/null
cd ~/steamcmd



#-----------If steamcmd.sh doesn't exist, download it --------------------
if [ ! -f steamcmd.sh ]; then
  wget http://media.steampowered.com/installer/steamcmd_linux.tar.gz
  tar zxvf steamcmd_linux.tar.gz
  chmod +x steamcmd.sh
fi



#----------- Create server start/stop/restart script ---------------------
sudo bash -c "cat << EOF > /usr/local/bin/garrysmodserver
#!/bin/bash
case \"\\\$1\" in
start)
cd ~/Steam/steamapps/common/GarrysMod
./srcds_run -game garrysmod +maxplayers 12 +sv_setsteamaccount DF0C875F201DCBB35B6DB58C9B2E973A +map gm_flatgrass &
;;
stop)
killall -SIGTERM srcds_linux
;;
restart)
killall -SIGINT srcds_linux
;;
esac
exit 0
EOF"
sudo chmod +x /usr/local/bin/garrysmodserver



#----------- Create systemctl service ------------------------------------
USER=$(whoami)
sudo bash -c "cat << EOF > /lib/systemd/system/garrysmodserver.service
[Unit]
Description=Manage Garrys Mod Server

[Service]
Type=forking
ExecStart=/usr/local/bin/garrysmodserver start
ExecStop=/usr/local/bin/garrysmodserver stop
ExecReload=/usr/local/bin/garrysmodserver restart
User=$USER

[Install]
WantedBy=multi-user.target
EOF"



#----------- Enable systemctl service ------------------------------------
sudo systemctl daemon-reload
sudo systemctl enable garrysmodserver.service



#----------- Run SteamCMD to update or install ---------------------------
#--Garry's Mod                               =4020
#--Counter-Strike: Source Dedicated Server   =232330
#--Team Fortress 2                           =440
#--Half-Life 2: Dedicated Server             =232370
./steamcmd.sh +login anonymous +app_update 4020 +app_update 232330 +app_update 440 +app_update 232370 +quit

#--Half-Life 2: Episode One                  =380
#--Half-Life 2: Episode Two                  =420
./steamcmd.sh +login $STEAMUSERNAME $STEAMPASSWORD +app_update 380 +app_update 420 +quit




#----------- Run SteamCMD to update or install ---------------------------
cd /home/k12/Steam/steamapps/common/GarrysModDS
./srcds_run -game garrysmod +maxplayers 12 +sv_setsteamaccount DF0C875F201DCBB35B6DB58C9B2E973A +map gm_flatgrass
exit 0