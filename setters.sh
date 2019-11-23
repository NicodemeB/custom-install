setFromScratch(){
	FROMSCRATCH=$1
}

setShell(){
	SHELL=$1
}

setDrisi() {
	DISTRI=$1
	if [ "$DISTRI" = "macos" ] ; then 
		# echo "ok let's use brew"
		continue
	elif [ "$DISTRI" = "debian" ] ; then
		PACKETMANAGER='apt'
		continue
	elif [ "$DISTRI" = "redhat" ] ; then
		PACKETMANAGER='yum'
		continue
	else
		display $RED ERROR "What you entered is not supported"
		exit -1;
	fi
}

setVerbose () {
	VERBOSE=$1
}

setWebCV () {
	WEBCV=$1
}
setOpenVPN () {
	OPENVPN=$1
}