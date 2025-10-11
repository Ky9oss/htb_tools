#!/bin/bash
## Init in Parrot Security and Hackthebox Pwnbox
## By Ky9oss

VERBOSE=0
AD_DIR="$HOME/ad-tools"
WEB_DIR="$HOME/web-tools"

while [ $# -gt 0 ]; do
    case "$1" in
        -v|--verbose)
            VERBOSE=1
            shift
            ;;
        --) 
            shift
            break
            ;;
        -*) 
            printf 'Unknown option: %s\n' "$1" >&2
            exit 2
            ;;
        *) 
            break
            ;;
    esac
done

run() {
    if [ $# -lt 2 ]; then
        printf 'run: usage: run "description" command [args...]\n' >&2
        return 2
    fi

    desc=$1
    shift

    printf '[*]: %s...\n' "$desc"

    if [ "$VERBOSE" -eq 1 ]; then
        "$@"
        status=$?
    else
        "$@" > /dev/null 2>&1
        status=$?
    fi

    if [ $status -ne 0 ]; then
        printf '[ERROR]: %s Failed (exit %d)\n' "$desc" "$status" >&2
    fi

    return $status
}

printf 'Do you want to remove useless tools to free up space? [Y/n] '
read -r choice
choice=${choice:-y}

if [ "$choice" = "Y" ] || [ "$choice" = "y" ]; then
    run  "Removing useless tools" \
        "sudo apt-get purge aircrack-ng netsniff-ng oscanner hitori caido nikto \
        hashdeep tali ophcrack wireshark pixiewps ettercap-graphical aisleriot  \
        four-in-a-row gnome-2048 gnome-chess gnome-klotski gnome-mahjongg  \
        gnome-mines gnome-nibbles gnome-robots gnome-sudoku gnome-taquin iagno \
        libgme0:amd64 libgnome-games-support-1-3:amd64 libgnome-games-support-common \
        libmanette-0.2-0:amd64 lightsoff quadrapassel swell-foop quadrapassel \
        netdiscover dmitry -y"
fi

printf "Are you hacking Active Directory? [Y/n] "
read -r choice
choice=${choice:-y}

if [ "$choice" = "Y" ] || [ "$choice" = "y" ]; then
    run "Creating directory $AD_DIR" \
        "mkdir -p $AD_DIR && cd $AD_DIR"

    run "Installing NetExec(lastest version)" \
        "pipx install git+https://github.com/Pennyw0rth/NetExec"

    run "Installing AvaloniaILSpy" \
        "wget https://github.com/icsharpcode/AvaloniaILSpy/releases/download/v7.2-rc/Linux.x64.Release.zip -O $AD_DIR/AvaloniaILSpy.zip && \
        unzip $AD_DIR/AvaloniaILSpy.zip && \
        unzip $AD_DIR/ILSpy-linux-x64-Release.zip"
fi


printf "Are you hacking Web? [Y/n] "
read -r choice
choice=${choice:-y}

if [ "$choice" = "Y" ] || [ "$choice" = "y" ]; then
    run "Changing Dir" \
        "mkdir -p $WEB_DIR && cd $WEB_DIR"

    run "Installing Rust" \
        "(curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y) && \
        . '$HOME/.cargo/env' " 

    run "Installing yakit" \
        "wget https://github.com/yaklang/yakit/releases/download/v1.4.4-0830/Yakit-1.4.4-0830-linux-amd64.AppImage -O ./yakit.AppImage && mv ./yakit.AppImage ./yakit && chmod +x ./yakit"

    run "Installing xray" \
        "wget https://github.com/chaitin/xray/releases/download/1.9.11/xray_linux_amd64.zip && unzip ./xray_linux_amd64.zip && mv ./xray_linux_amd64 ./xray && chmod +x ./xray"

    run "Installing rad" \
        "wget https://github.com/chaitin/rad/releases/download/1.0/rad_linux_amd64.zip -O ./rad_linux_amd64.zip && unzip ./rad_linux_amd64.zip &&  mv ./rad_linux_amd64 ./rad && chmod +x ./rad"

    run "Installing rustcan" \
        "wget https://github.com/bee-san/RustScan/releases/download/2.4.1/x86_64-linux-rustscan.tar.gz.zip -O ./x86_64-linux-rustscan.tar.gz.zip && unzip ./x86_64-linux-rustscan.tar.gz.zip && tar -zxvf ./x86_64-linux-rustscan.tar.gz && chmod +x ./rustscan"

    run "Cleaning zip" \
        "rm ./xray_linux_amd64.zip ./rad_linux_amd64.zip ./x86_64-linux-rustscan.tar.gz ./x86_64-linux-rustscan.tar.gz.zip"

    run "Installing AWVS" \
        "sudo systemctl start docker && sudo docker pull ghcr.io/xrsec/awvs:24.4.240427095 && sudo docker run -it -d --name awvs -p 127.0.0.1:3443:3443 --restart=always ghcr.io/xrsec/awvs:24.4.240427095 && echo $(hostname -I | awk '{print $2}') awvs.lan | sudo tee -a /etc/hosts"

    run "Activating AWVS" \
        "sudo wget -O /usr/local/share/ca-certificates/RootCA.crt https://cdn.jsdelivr.net/gh/XRSec/AWVS-Update@main/.github/resources/ca.cer && sudo update-ca-certificates && sudo docker exec -i 'awvs' bash -c 'apt update -y && apt upgrade -y && apt install -y libsqlite3-dev wget && wget https://raw.githubusercontent.com/ngductung/acunetix23/main/check-tools.sh --no-check-certificate -O ./check-tools.sh && chmod +x ./check-tools.sh && ./check-tools.sh'"

    printf '%s\n' "Success!" \
    "URL: https://awvs.lan:3443/#/login" \
    "UserName: awvs@awvs.lan" \
    "PassWord: Awvs@awvs.lan"

    run "Installing observer_ward" \
        "wget https://github.com/emo-crab/observer_ward/releases/download/v2025.9.18/observer-ward_v2025.9.18_x86_64-unknown-linux-musl.deb && sudo dpkg -i observer-ward_v2025.9.18_x86_64-unknown-linux-musl.deb"

    run "Installing mitmproxy" \
        "git clone https://github.com/mitmproxy/mitmproxy.git && cd mitmproxy && curl -LsSf https://astral.sh/uv/install.sh | sh && uv run mitmproxy"

    run "Add environment variables" \
        "echo 'export PATH=\"\$HOME/web-tools/:\$PATH\"' >> $HOME/.bashrc"

fi


printf "Are you hacking IPSEC? [Y/n] "
read -r choice
choice=${choice:-y}

if [ "$choice" = "Y" ] || [ "$choice" = "y" ]; then
    run "Install ike-scan" \
        "cd $HOME && git clone https://github.com/royhills/ike-scan.git && cd ike-scan && ./configure && make"

    run "Add environment variables" \
        "echo 'export PATH=\"\$HOME/ike-scan/:\$PATH\"' >> $HOME/.bashrc"
fi


source $HOME/.bashrc
printf "Done! Happy Hacking!😊"
