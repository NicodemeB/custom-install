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
		# echo "ok will use apt"
		continue
	else
		echo "What you entered is not supported"
		exit -1;
	fi
}

setVerbose () {
	VERBOSE=$1
}

setWebCV () {
	WEBCV=1
}
setOpenVPN () {
	OPENVPN=1
}