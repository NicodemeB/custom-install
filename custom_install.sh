#!/bin/sh

. ./tools.sh
. ./setters.sh
. ./installers.sh
. ./install-web.sh
. ./install-openvpn.sh

FROMSCRATCH=0
DISTRI="debian"
VERBOSE=0
SHELL=0
OPENVPN=0
WEBCV=0
# agrs:
# 	1 : color name
#	2 : message type
#	3 : message

optspec=":d:h:fvows-:"
while getopts "$optspec" optchar; do
    case "${optchar}" in
        -)
            case "${OPTARG}" in
            	help)
            		echo "usage: $0 [-v] [--loglevel[=]<value>]" >&2
            		exit 0
            		;;

                from-scratch)
                    # echo "Parsing option: '--${OPTARG}'" >&2;
                    setFromScratch 1
                    ;;

				verbose)
					# echo "Parsing option: '--${OPTARG}'" >&2;
					setVerbose 1
					;;

				distri)
					val="${!OPTIND}"; 
					OPTIND=$(( $OPTIND + 1 ))
					# echo "Parsing option: '--${OPTARG}', value: '${val}'" >&2;
					setDrisi $val
					;;

				shell)
					setShell 1
					;;

				webCV)
					setWebCV 1
					;;

				openvpn)
					setOpenVPN 1
					;;

				backdoor)
					echo "WIP"
					;;
	
                # loglevel=*)
                #     val=${OPTARG#*=}
                #     opt=${OPTARG%=$val}
                    # echo "Parsing option: '--${opt}', value: '${val}'" >&2
                #     ;;
                *)
            		if [ "$OPTERR" != 1 ] || [ "${optspec:0:1}" = ":" ]; then	
                        echo "Unknown option --${OPTARG}" >&2
                    fi
                    ;;
            esac;;
        h)
            echo "usage: $0 [-v] [--loglevel[=]<value>]" >&2
            exit 2
            ;;

        f)
            # echo "Parsing option: '-${optchar}'" >&2
            setFromScratch 1
            ;;

        v)
            # echo "Parsing option: '-${optchar}'" >&2
            setVerbose 1
            ;;

        d)
			# echo "Parsing option: '--${optchar}', value: '${OPTARG}'" >&2;
			setDrisi $OPTARG
			;;

		s) 
			setShell 1
			;;

		w)
			setWebCV 1
			;;

		o)
			setOpenVPN 1
			;;
			
        *)
            if [ "$OPTERR" != 1 ] || [ "${optspec:0:1}" = ":" ]; then
                echo "Non-option argument: '-${OPTARG}'" >&2
            fi
            ;;

    esac
done


display $YELLOW INFO "Here is the summary of the install : \n\
distribution \t: $DISTRI\n\
shell \t\t: $SHELL\n\
from-scratch \t: $FROMSCRATCH\n\
openvpn \t: $OPENVPN\n\
webCV \t\t: $WEBCV\n\
backdoor \t: WIP"

while true; do
    read -p "Do you wish to install this program? (y/n) : " yn
    case $yn in
        [Yy]* ) break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done

importVars
disableIPv6
installBasicNeeds
fromScratchInstall
shellInstall
WebCVInstall
OpenVPNInstall


# read -n 1 -s -r -p "Press any key to continue"
# echo ""
# echo next



# exit 0















