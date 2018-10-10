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
