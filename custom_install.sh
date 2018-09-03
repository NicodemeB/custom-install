#!/bin/sh

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NORMAL='\033[0m'

FROMSCRATCH=0
DISTRI="debian"
VERBOSE=0

# agrs:
# 	1 : color name
#	2 : message type
#	3 : message
display(){
	printf "$1[$2] - $3 ${NORMAL}\n" 
}

setFromScratch(){
	FROMSCRATCH=$1
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
		echo "FU, wtf you entered is not supported, so bye bitch"
		exit -1;
	fi
}

setVerbose () {
	VERBOSE=$1
}

optspec=":d:h:fv-:"
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
			
        *)
            if [ "$OPTERR" != 1 ] || [ "${optspec:0:1}" = ":" ]; then
                echo "Non-option argument: '-${OPTARG}'" >&2
            fi
            ;;

    esac
done


display $YELLOW INFO "Here is the summary of the install : \n\
distribution \t: $DISTRI\n\
from-scratch \t: $FROMSCRATCH\n\
backdoor \t: WIP"

while true; do
    read -p "Do you wish to install this program? (y/n) : " yn
    case $yn in
        [Yy]* ) break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done

display $YELLOW WARNING "Please type 'exit' after ohmyzsh installating to continue the install"

# read -n 1 -s -r -p "Press any key to continue"
# echo ""
# echo next



# exit 0

if [ $FROMSCRATCH -eq 1 ] ; then 
	display $BLUE INFO "ok let's do it from scratch"
	case "$DISTRI" in 
		debian) 
			if [ "$(whoami)" = "root" ] ; then
			   continue
			else
				display $RED ERROR "Please perform from scratch install from root account"
			    exit
			fi
			display $BLUE INFO "ok let's install git htop curl zsh screen net-tools dnsutils"
			apt install git htop curl zsh screen net-tools dnsutils
			display $BLUE INFO "packages installed"	
			;;

		macos)
			display $BLUE INFO "ok let's install brew screen"
			/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
			display $BLUE INFO "brew installed"

			display $BLUE INFO "ok let's install git htop zsh"
			brew install git htop curl zsh screen
			display $BLUE INFO "packages installed"
			;;
	esac
fi

display $BLUE INFO "ok let's install ohmyzsh"
sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
display $BLUE INFO "ohmyzsh installed"

display $BLUE INFO "ok let's customize ohmyzsh"
sed -i 's/robbyrussell/agnoster/' ~/.zshrc
sed -i 's/plugins=(git)/plugins=(\n\tgit\n\tnanoc\n\tz\n\tzsh-autosuggestions\n\t)/' ~/.zshrc
sed -i "s/prompt_segment blue black '%~'/prompt_segment blue black '%c'/" ~/.oh-my-zsh/themes/agnoster.zsh-theme
display $BLUE INFO "ohmyzsh customized"


display $BLUE INFO "ok let's customize screen"
echo "defscrollback 5000" > ~/.screenrc
echo "termcapinfo xterm* ti@:te@%" >> ~/.screenrc
display $BLUE INFO "screen customized"


if [ "$DISTRI" = "macos" ] ; then 
	git clone https://github.com/powerline/fonts.git --depth=1
	cd fonts 
	./install.sh
	cd .. 
	rm -rf fonts

	git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions
fi

curl -L https://iterm2.com/shell_integration/zsh -o ~/.iterm2_shell_integration.zsh
echo "source ~/.iterm2_shell_integration.zsh" >> ~/.zshrc

zsh -c "source ~/.zshrc"

zsh















