#!/bin/bash

red='\033[0;31m'
green='\033[0;32m'
blue='\033[0;34m'
yellow='\033[0;33m'
plain='\033[0m'

cur_dir=$(pwd)


[[ $EUID -ne 0 ]] && echo -e "${red}Fatal error: ${plain} Please run this script with root privilege \n " && exit 1


# Check OS and set release variable
if [[ -f /etc/os-release ]]; then
    source /etc/os-release
    release=$ID
elif [[ -f /usr/lib/os-release ]]; then
    source /usr/lib/os-release
    release=$ID
else
    echo "Failed to check the system OS, please contact the author!" >&2
    exit 1
fi
echo "The OS release is: $release"

arch() {
    case "$(uname -m)" in
    x86_64 | x64 | amd64) echo 'amd64' ;;
    armv8* | armv8 | arm64 | aarch64) echo 'arm64' ;;
    *) echo -e "${green}Unsupported CPU architecture! ${plain}" && rm -f install.sh && exit 1 ;;
    esac
}

echo "arch: $(arch)"

default_ip=$(hostname -I|cut -f1 -d ' ')

# Prompt the user with the default value
read -p "ip khod ra vared konid ya Enter bezanid [$default_ip]: " user_input


# Use the default value if the user input is empty
ipv4="${user_input:-$default_ip}"

# Output the final IP address
echo "The IP address is: $ipv4"



if [[ -e /etc/debian_version ]]; then
		OS="debian"
		source /etc/os-release
		if [[ $ID == "ubuntu" ]]; then
			OS="ubuntu"
			MAJOR_UBUNTU_VERSION=$(echo "$VERSION_ID" | cut -d '.' -f1)
			if [[ $MAJOR_UBUNTU_VERSION -lt 18 ]]; then
				echo "⚠️ Your version of Ubuntu is not supported. Please Install On Ubuntu 20"
				echo ""
				exit
			fi
		else
			echo "⚠️ Your OS not supported. Please Install On Ubuntu 20"
			echo ""
			read -rp "Please enter 'Y' to exit, or press the any key to continue installation ：" back2menuInput
   			 case "$back2menuInput" in
       			 y) exit 1 ;;
   			 esac
		fi
fi

install_base() {
    case "${release}" in
    ubuntu | debian | armbian)
        apt-get update && apt-get install -y -q wget curl tar mariadb-server redis-server certbot
        ;;
    centos | almalinux | rocky | ol)
        yum -y update && yum install -y -q wget curl tar mariadb redis-server certbot
        ;;
    fedora | amzn | virtuozzo)
        dnf -y update && dnf install -y -q wget curl tar mariadb redis-server certbot
        ;;
    arch | manjaro | parch)
        pacman -Syu && pacman -Syu --noconfirm wget curl tar mariadb redis-server certbot
        ;;
    opensuse-tumbleweed)
        zypper refresh && zypper -q install -y wget curl tar mariadb redis-server certbot
        ;;
    *)
        apt-get update && apt install -y -q wget curl tar mariadb redis-server certbot
        ;;
    esac
	snap install yq
}

install_panel() {
	# curl backend
	local server_ip=$(curl -s https://api.ipify.org)
	read -p "damane khod ra vared konid: " domain_name

	certbot certonly --standalone --non-interactive --agree-tos --email rezvanniazi@proton.me -d $domain_name

	cd /usr/local/

	if ([[ -e /usr/local/mtxpanel-linux-x64 ]]); then
		cd mtxpanel-linux-x64
		backend_port=$(grep 'port:' config.yml | awk -F': ' '{print $2}' | tr -d '"')
		mysql_username=$(grep 'username:' config.yml | awk -F': ' '{print $2}' | tr -d '"')
		mysql_password=$(grep 'password:' config.yml | awk -F': ' '{print $2}' | tr -d '"')
		mysql_database=$(grep 'database:' config.yml | awk -F': ' '{print $2}' | tr -d '"')
		cd ..
		rm -rf mtxpanel-linux-x64
	else
		read -p "Port backend vared konid: " backend_port
		read -p "lotfan user mysql ra vared konid: " mysql_username
		read -p "lotfan password mysql ra vared konid: " mysql_password
	fi

	mysql -e "drop USER '${mysql_username}'@'localhost'" &
	wait
	mysql -e "CREATE USER '${mysql_username}'@'localhost' IDENTIFIED BY '${mysql_password}';" &
	wait
	mysql -e "GRANT ALL ON *.* TO '${mysql_username}'@'localhost';" &


	read -p "Lotfan Token Github ra vared konid: " github_token

	# Verify token by making an authenticated API request
	response=$(curl -s -o /dev/null -w "%{http_code}" -H "Authorization: Bearer ${github_token}" \
	"https://api.github.com/repos/rezvanniazi/ts-panel-backend2/releases/latest")

	if [ "$response" -eq 200 ]; then
		echo "✅ Token is valid. Proceeding..."
		
		# Get asset ID (original logic)
		asset_id=$(curl -Ls -H "Authorization: Bearer ${github_token}" \
		"https://api.github.com/repos/rezvanniazi/ts-panel-backend2/releases/latest" | \
		jq -r '.assets[] | select(.name == "mtxpanel-linux-x64.tar.gz") | .id')

		if [ -n "$asset_id" ]; then
			echo "🔹 Asset ID: $asset_id"
			
		else
			echo "❌ Error: Asset 'mtxpanel-linux-x64.tar.gz' not found!"
			exit 1
		fi

	elif [ "$response" -eq 401 ]; then
		echo "❌ Error: Invalid token! (Unauthorized)"
		exit 1
	else
		echo "❌ Error: GitHub API request failed (HTTP $response)"
		exit 1
	fi

	curl -L -H "Authorization: Bearer ${github_token}"   -H "Accept: application/octet-stream"   https://api.github.com/repos/rezvanniazi/ts-panel-backend2/releases/assets/${asset_id} -O mtxpanel-linux-x64.tar.gz


	if [[ $? -ne 0 ]]; then
            echo -e "${red}Downloading panel failed, please be sure that your server can access GitHub ${plain}"
            exit 1
    fi
	
	tar -xvzf mtxpanel-linux-x64.tar.gz
	wait

	cd mtxpanel-linux-x64

	ln -s /etc/letsencrypt/live/$domain_name/fullchain.pem certs/
	ln -s /etc/letsencrypt/live/$domain_name/privkey.pem certs/

	sed -i "s/port: \"9686\"/port: \"$backend_port\"/g" config.yml
	sed -i "s/server: \"localhost\"/server: \"$ipv4\"/g" config.yml
	sed -i "s/username: \"temp\"/server: \"$mysql_username\"/g" config.yml
	sed -i "s/password: \"temp\"/password: \"$mysql_password\"/g" config.yml
	sed -i "s/database: \"temp\"/database: \"$mysql_database\"/g" config.yml

	touch .env

	echo PATH_TO_PARENT_TS=/home/mtxpanel/server > .env

	cp mtxpanel.service /etc/systemd/system/

	systemctl enable mtxpanel
	systemctl start mtxpanel

	if ([[ -e /home/mtxpanel/server ]]); then
		echo "Server Folder Already Exists"
	else
		mkdir -p /home/mtxpanel
		mkdir /home/mtxpanel/server

		cd /home/mtxpanel/server

		wget -4 -O TeaSpeak-files.tar.gz https://github.com/rezvanniazi/ts-backend-installer/blob/main/TeaSpeak-files.tar.gz
		
		tar -xvzf TeaSpeak-files.tar.gz
		rm -rf TeaSpeak-files.tar.gz
	fi
	clear


	echo -e "${green}Ip backend shoma: https://$domain_name:$backend_port"
	
	echo -e "${yellow} Lotfan protocol_key.txt khod ra dakhele posheye /home/mtxpanel/server/ gharar dahid"

	exit 0
}


echo -e "${green}Running...${plain}"

install_base
install_panel



