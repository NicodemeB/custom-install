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