VERBOSE=0

while [[ $# -gt 0 ]]; do
    case "$1" in
        -v|--verbose)
            VERBOSE=1
            shift
            ;;
        *)
            shift
            ;;
    esac
done

run() {
    # $1 = 自定义步骤信息, $2 = 命令
    if [[ $VERBOSE -eq 1 ]]; then
        echo "[#]: $1"
        eval "$2" # eval 同步阻塞执行
    else
        echo "[#]: $1"
        eval "$2" > /dev/null 2>&1
    fi

    if [[ $? -ne 0 ]]; then
        echo "[ERROR]: $1 Failed ！"
    fi
}

read -p "Are you hacking a windows domain? [Y/n] " choice
choice=${choice:-y}

if [[ "$choice" =~ ^[Yy]$ ]]; then
    run "Install NetExec(lastest version)" "pipx install git+https://github.com/Pennyw0rth/NetExec"
    run "Install AvaloniaILSpy" "git clone https://github.com/icsharpcode/AvaloniaILSpy && wget https://github.com/icsharpcode/AvaloniaILSpy/releases/download/v7.2-rc/Linux.x64.Release.zip -O $HOME/AvaloniaILSpy.zip && unzip $HOME/AvaloniaILSpy.zip && unzip $HOME/ILSpy-linux-x64-Release.zip"
    run "Add environment variables" "echo 'export PATH=\"\$HOME/artifacts/linux-x64:\$PATH\"' >> $HOME/.bashrc && source $HOME/.bashrc"
fi


read -p "Do you want to remove some useless tools to free up space? [Y/n] " choice
choice=${choice:-y}

if [[ "$choice" =~ ^[Yy]$ ]]; then
    run  "Remove useless tools" "sudo apt-get purge aircrack-ng netsniff-ng oscanner hitori caido nikto hashdeep tali ophcrack wireshark pixiewps ettercap-graphical aisleriot four-in-a-row gnome-2048 gnome-chess gnome-klotski gnome-mahjongg gnome-mines gnome-nibbles gnome-robots gnome-sudoku gnome-taquin iagno libgme0:amd64 libgnome-games-support-1-3:amd64 libgnome-games-support-common libmanette-0.2-0:amd64 lightsoff quadrapassel swell-foop quadrapassel netdiscover dmitry -y"
fi


read -p "Are you hacking a web? [Y/n] " choice
choice=${choice:-y}

if [[ "$choice" =~ ^[Yy]$ ]]; then
    run "Install yakit" "wget https://github.com/yaklang/yakit/releases/download/v1.4.4-0830/Yakit-1.4.4-0830-linux-amd64.AppImage -O $HOME/yakit.AppImage && chmod +x $HOME/yakit.AppImage && (nohup $HOME/yakit.AppImage &)"
    run "Install xray" "wget https://github.com/chaitin/xray/releases/download/1.9.11/xray_linux_amd64.zip -O $HOME/xray_linux_amd64.zip && unzip $HOME/xray_linux_amd64.zip && mv $HOME/xray_linux_amd64 $HOME/xray && chmod +x $HOME/xray"
    run "Install rad" "wget https://github.com/chaitin/rad/releases/download/1.0/rad_linux_amd64.zip -O $HOME/rad_linux_amd64.zip && unzip $HOME/rad_linux_amd64.zip && mv $HOME/rad_linux_amd64 $HOME/rad && chmod +x $HOME/rad"
    run "Add environment variables" "echo 'export PATH=\"\$HOME/:\$PATH\"' >> $HOME/.bashrc && source $HOME/.bashrc"
fi


echo "Done! Happy Hacking!😊"
