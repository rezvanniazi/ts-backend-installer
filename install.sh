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
server_ipv4="${user_input:-$default_ip}"

# Output the final IP address
echo "The IP address is: $server_ipv4"



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
        apt-get update && apt-get install -y -q wget curl tar mariadb-server redis-server certbot openssl jq
        ;;
    centos | almalinux | rocky | ol)
        yum -y update && yum install -y -q wget curl tar mariadb-server redis-server certbot openssl jq
        ;;
    fedora | amzn | virtuozzo)
        dnf -y update && dnf install -y -q wget curl tar mariadb-server  redis-server certbot openssl jq
        ;;
    arch | manjaro | parch)
        pacman -Syu && pacman -Syu --noconfirm wget curl tar mariadb-server  redis-server certbot openssl jq
        ;;
    opensuse-tumbleweed)
        zypper refresh && zypper -q install -y wget curl tar mariadb-server  redis-server certbot openssl jq
        ;;
    *)
        apt-get update && apt install -y -q wget curl tar mariadb-server  redis-server certbot openssl jq
        ;;
    esac
}

install_panel() {
	# curl backend
	local server_ip=$(curl -s https://api.ipify.org)
	read -p "damane khod ra vared konid: " domain_name

	certbot certonly --standalone --non-interactive --agree-tos --email rezvanniazi@proton.me -d $domain_name

	cd /usr/local/

	# Initialize is_update as false by default
	is_update=false

	if [[ -e /usr/local/mtxpanel-linux-x64 ]]; then

		is_update=true

    	cd mtxpanel-linux-x64

		mv logs/ /tmp/logs_backup 2>/dev/null || true

    	# Stop the service
    	systemctl stop mtxpanel
    
    	# Read variables from .env file
		if [[ -f .env ]]; then
			echo "Reading configuration from .env file..."
			# Use the robust loading method
			set -a
			source .env
			set +a
			
			backend_port="$PORT"
			mysql_username="$MYSQL_USERNAME"
			mysql_password="$MYSQL_PASSWORD"
			mysql_database="$MYSQL_DATABASE"
			mysql_host="$MYSQL_HOST"
			jwt_secret="$JWT_SECRET"
			jwt_refresh="$JWT_REFRESH"
		else
			echo "Error: .env file not found!"
			exit 1
		fi
    
		cd ..
		rm -rf mtxpanel-linux-x64
	else
		read -p "Port backend vared konid: " backend_port
		read -p "lotfan user mysql ra vared konid: " mysql_username
		read -p "lotfan password mysql ra vared konid: " mysql_password
		read -p "lotfan esm database mysql ra vared konid: " mysql_database

		jwt_secret=$(openssl rand -base64 32)
		jwt_refresh=$(openssl rand -base64 32)
	fi

	mysql -e "drop USER '${mysql_username}'@'localhost'" 2>/dev/null || true
	mysql -e "CREATE USER '${mysql_username}'@'localhost' IDENTIFIED BY '${mysql_password}';"
	mysql -e "GRANT ALL ON *.* TO '${mysql_username}'@'localhost';"
	mysql -e "FLUSH PRIVILEGES;"


	read -p "Lotfan Token Github ra vared konid: " github_token

	# Verify token by making an authenticated API request
	response=$(curl -s -o /dev/null -w "%{http_code}" -H "Authorization: Bearer ${github_token}" \
	"https://api.github.com/repos/rezvanniazi/ts-panel-backend-express/releases/latest")

	if [ "$response" -eq 200 ]; then
		echo "✅ Token is valid. Proceeding..."
		
		# Get asset ID (original logic)
		asset_id=$(curl -Ls -H "Authorization: Bearer ${github_token}" \
		"https://api.github.com/repos/rezvanniazi/ts-panel-backend-express/releases/latest" | \
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

	curl -L -H "Authorization: Bearer ${github_token}"   -H "Accept: application/octet-stream"   https://api.github.com/repos/rezvanniazi/ts-panel-backend-express/releases/assets/${asset_id} --output mtxpanel-linux-x64.tar.gz


	if [[ $? -ne 0 ]]; then
            echo -e "${red}Downloading panel failed, please be sure that your server can access GitHub ${plain}"
            exit 1
    fi
	
	mkdir -p mtxpanel-linux-x64

	mv /tmp/logs_backup mtxpanel-linux-x64/logs 2>/dev/null || true

	tar -xvzf mtxpanel-linux-x64.tar.gz -C mtxpanel-linux-x64
	wait

	cd mtxpanel-linux-x64

	mkdir -p certs

	ln -s /etc/letsencrypt/live/$domain_name/fullchain.pem certs/
	ln -s /etc/letsencrypt/live/$domain_name/privkey.pem certs/

cat > /usr/local/mtxpanel-linux-x64/.env << EOF
NODE_ENV="production"

PORT=$backend_port
JWT_SECRET=$jwt_secret
JWT_REFRESH=$jwt_refresh

MYSQL_HOST="localhost"
MYSQL_USERNAME="$mysql_username"
MYSQL_PASSWORD="$mysql_password"
MYSQL_DATABASE="$mysql_database"

EXPIRATION_CHECK="*/10 * * * *"
PANEL_SYNC_CHECK="* * * * *"
TEAMSPEAK_CHECK="* * * * *"

PATH_TO_PARENT_DIR="/home/mtxpanel/server"
EOF

	# Run appropriate SQL file based on update status
	if [ "$is_update" = true ]; then
		echo -e "${green}Updating database with differences.sql...${plain}"
		wget https://raw.githubusercontent.com/rezvanniazi/ts-backend-installer/main/differences.sql -O differences.sql
		wait

		if [[ -f differences.sql ]]; then

			mysql -u "$mysql_username" -p"$mysql_password" "$mysql_database" < differences.sql
			if [[ $? -eq 0 ]]; then
				echo -e "${green}Database updated successfully!${plain}"
			else
				echo -e "${red}Error updating database!${plain}"
				exit 1
			fi
		else
			echo -e "${red}Error: differences.sql not found!${plain}"
			exit 1
		fi
	else
		echo -e "${green}Installing fresh database with schema.sql...${plain}"
		# Create database if it doesn't exist
		wget https://raw.githubusercontent.com/rezvanniazi/ts-backend-installer/main/schema.sql -O schema.sql

		mysql -u "$mysql_username" -p"$mysql_password" -e "CREATE DATABASE IF NOT EXISTS $mysql_database;"
		
		if [[ -f schema.sql ]]; then
			mysql -u "$mysql_username" -p"$mysql_password" "$mysql_database" < schema.sql
			if [[ $? -eq 0 ]]; then
				echo -e "${green}Database installed successfully!${plain}"
			else
				echo -e "${red}Error installing database!${plain}"
				exit 1
			fi
		else
			echo -e "${red}Error: schema.sql not found!${plain}"
			exit 1
		fi
	fi

	cp mtxpanel.service /etc/systemd/system/

	# systemctl daemon-reload
	# systemctl enable mtxpanel
	# systemctl start mtxpanel

	if [[ -e /home/mtxpanel/server ]]; then
		echo "Server Folder Already Exists"
	else
		mkdir -p /home/mtxpanel
		mkdir /home/mtxpanel/server

		cd /home/mtxpanel/server

		wget -4 -O TeaSpeak-files.tar.gz https://raw.githubusercontent.com/rezvanniazi/ts-backend-installer/main/TeaSpeak-files.tar.gz
		
		tar -xvzf TeaSpeak-files.tar.gz
		rm -rf TeaSpeak-files.tar.gz
	fi


	echo -e "${green}Ip backend shoma: https://$domain_name:$backend_port${plain}"
	echo -e "${green}User Admin: admin${plain}"
	echo -e "${green}Password Admin: admin${plain}"

	echo -e "${red}Lotfan Company v user jadid besazid v user admin ro pak konid${plain}"


	exit 0
}


echo -e "${green}Running...${plain}"

install_base
install_panel