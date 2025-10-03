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
    run  "Removing useless tools" "sudo apt-get purge aircrack-ng netsniff-ng oscanner hitori caido nikto hashdeep tali ophcrack wireshark pixiewps ettercap-graphical aisleriot four-in-a-row gnome-2048 gnome-chess gnome-klotski gnome-mahjongg gnome-mines gnome-nibbles gnome-robots gnome-sudoku gnome-taquin iagno libgme0:amd64 libgnome-games-support-1-3:amd64 libgnome-games-support-common libmanette-0.2-0:amd64 lightsoff quadrapassel swell-foop quadrapassel netdiscover dmitry -y"
fi


read -p "Are you hacking a web? [Y/n] " choice
choice=${choice:-y}

if [[ "$choice" =~ ^[Yy]$ ]]; then
    run "Changing Dir" "mkdir -p $HOME/web-tools/ && cd $HOME/web-tools/"
    run "Installing yakit" "wget https://github.com/yaklang/yakit/releases/download/v1.4.4-0830/Yakit-1.4.4-0830-linux-amd64.AppImage -O ./yakit.AppImage && mv ./yakit.AppImage ./yakit && chmod +x ./yakit"
    run "Installing xray" "wget https://github.com/chaitin/xray/releases/download/1.9.11/xray_linux_amd64.zip && unzip ./xray_linux_amd64.zip && mv ./xray_linux_amd64 ./xray && chmod +x ./xray"
    run "Installing rad" "wget https://github.com/chaitin/rad/releases/download/1.0/rad_linux_amd64.zip -O ./rad_linux_amd64.zip && unzip ./rad_linux_amd64.zip &&  mv ./rad_linux_amd64 ./rad && chmod +x ./rad"
    run "Installing rustcan" "wget https://github.com/bee-san/RustScan/releases/download/2.4.1/x86_64-linux-rustscan.tar.gz.zip -O ./x86_64-linux-rustscan.tar.gz.zip && unzip ./x86_64-linux-rustscan.tar.gz.zip && tar -zxvf ./x86_64-linux-rustscan.tar.gz && chmod +x ./rustscan"
    run "Cleaning zip" "rm ./xray_linux_amd64.zip ./rad_linux_amd64.zip ./x86_64-linux-rustscan.tar.gz ./x86_64-linux-rustscan.tar.gz.zip"

    run "Installing AWVS" "sudo systemctl start docker && sudo docker pull ghcr.io/xrsec/awvs:24.4.240427095 && sudo docker run -it -d --name awvs -p 127.0.0.1:3443:3443 --restart=always ghcr.io/xrsec/awvs:24.4.240427095 && echo $(hostname -I | awk '{print $2}') awvs.lan | sudo tee -a /etc/hosts && sudo wget -O /usr/local/share/ca-certificates/RootCA.crt https://cdn.jsdelivr.net/gh/XRSec/AWVS-Update@main/.github/resources/ca.cer && sudo update-ca-certificates && docker exec -i 'awvs' bash -c 'apt update -y && apt upgrade -y && apt install -y libsqlite3-dev wget && wget https://raw.githubusercontent.com/ngductung/acunetix23/main/check-tools.sh --no-check-certificate -O ./check-tools.sh && chmod +x ./check-tools.sh && ./check-tools.sh'"
    printf '%s\n' "Success!" \
    "URL: https://awvs.lan:3443/#/login" \
    "UserName: awvs@awvs.lan" \
    "PassWord: Awvs@awvs.lan"

    run "Installing observer_ward" "wget https://github.com/emo-crab/observer_ward/releases/download/v2025.9.18/observer-ward_v2025.9.18_x86_64-unknown-linux-musl.deb && sudo dpkg -i observer-ward_v2025.9.18_x86_64-unknown-linux-musl.deb"
    run "Installing mitmproxy" "git clone https://github.com/mitmproxy/mitmproxy.git && cd mitmproxy && uv run mitmproxy"
    run "Add environment variables" "echo 'export PATH=\"\$HOME/web-tools/:\$PATH\"' >> $HOME/.bashrc"
fi

read -p "Are you hacking IPSEC? [Y/n] " choice
choice=${choice:-y}
if [[ "$choice" =~ ^[Yy]$ ]]; then
    run "Install ike-scan" "cd $HOME && git clone https://github.com/royhills/ike-scan.git && cd ike-scan && ./configure && make"
    run "Add environment variables" "echo 'export PATH=\"\$HOME/ike-scan/:\$PATH\"' >> $HOME/.bashrc && source $HOME/.bashrc"
fi

source $HOME/.bashrc
echo "Done! Happy Hacking!😊"
