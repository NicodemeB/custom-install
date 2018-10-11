RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NORMAL='\033[0m'

display(){
	printf "$1[$2] - $3 ${NORMAL}\n" 
}

checkRoot() {
	if [ "$(whoami)" = "root" ] ; then
	   continue
	else
		display $RED ERROR "Please perform from scratch install from root account"
	    exit
	fi
}

disableIPv6 () {
	if [ "$DISTRI" = "debian" ] ; then
		IPV6=$(cat /etc/sysctl.conf |grep -c 'net.ipv6.conf.all.disable_ipv6 = 1')
		if [ $IPV6 -eq 0 ] ; then
			echo 'net.ipv6.conf.all.disable_ipv6 = 1' >> /etc/sysctl.conf
			sysctl -p
			display $BLUE INFO 'IPv6 disabled'
		fi
	fi
}


installBasicNeeds () {
	if [ "$DISTRI" = "debian" ] ; then
		if [ $(getent passwd | awk -F: -v user="$(whoami)" '$1 == user {print $NF}') != "/bin/zsh" ] ; then
			apt update
			echo y |apt install git zsh htop
			echo '/bin/zsh' |chsh root 
		fi
	fi
}

# args - file to test existence
testFile () {
	if [ ! -f $1 ]; then
	    display $RED ERROR "File not $1 found!"
	    exit
	fi
}

importVars () {
	KEY_COUNTRY=$(cat vars.json | python3 -c "import sys, json; print(json.load(sys.stdin)['openvpn']['KEY_COUNTRY'])")
	KEY_PROVINCE=$(cat vars.json | python3 -c "import sys, json; print(json.load(sys.stdin)['openvpn']['KEY_PROVINCE'])")
	KEY_CITY=$(cat vars.json | python3 -c "import sys, json; print(json.load(sys.stdin)['openvpn']['KEY_CITY'])")
	KEY_ORG=$(cat vars.json | python3 -c "import sys, json; print(json.load(sys.stdin)['openvpn']['KEY_ORG'])")
	KEY_EMAIL=$(cat vars.json | python3 -c "import sys, json; print(json.load(sys.stdin)['openvpn']['KEY_EMAIL'])")
	KEY_OU=$(cat vars.json | python3 -c "import sys, json; print(json.load(sys.stdin)['openvpn']['KEY_OU'])")
	KEY_NAME=$(cat vars.json | python3 -c "import sys, json; print(json.load(sys.stdin)['openvpn']['KEY_NAME'])")
	KEY_CN=$(cat vars.json | python3 -c "import sys, json; print(json.load(sys.stdin)['openvpn']['KEY_CN'])")
	DNS=$(cat vars.json | python3 -c "import sys, json; print(json.load(sys.stdin)['openvpn']['DNS'])")
	VPN_SERVER_IP_DOMAIN=$(cat vars.json | python3 -c "import sys, json; print(json.load(sys.stdin)['openvpn']['VPN_SERVER_IP_DOMAIN'])")
	CLIENT_NAME=$(cat vars.json | python3 -c "import sys, json; print(json.load(sys.stdin)['openvpn']['CLIENT_NAME'])")
}
