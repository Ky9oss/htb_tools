sudo apt-get -y install win64
sudo dpkg --add-architecture i386 && sudo apt-get -y update 
sudo apt-get -y install wine32:i386
sudo apt install winetricks -y
# winetricks dotnet40
