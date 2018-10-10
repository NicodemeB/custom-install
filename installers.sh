fromScratchInstall () {
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
}

shellInstall() {
	if [ $SHELL -eq 1 ] ; then 
		display $YELLOW WARNING "Please type 'exit' after ohmyzsh installating to continue the install"
		sleep 2
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
	fi
}

WebCVInstall () {
	display $BLUE INFO "test"
	if [ $WEBCV -eq 1 ] ; then 
		case "$DISTRI" in 
			debian) 
				if [ "$(whoami)" = "root" ] ; then
				   continue
				else
					display $RED ERROR "Please perform install from root account"
				    exit
				fi
				display $BLUE INFO "ok let's install webCV"

				installWeb


				;;

			macos)
				display $RED ERROR "Not supported"
				;;
		esac
	fi
}

OpenVPNInstall () {
	if [ $OPENVPN -eq 1 ] ; then 
		case "$DISTRI" in 
			debian) 
				if [ "$(whoami)" = "root" ] ; then
				   continue
				else
					display $RED ERROR "Please perform install from root account"
				    exit
				fi
				display $BLUE INFO "ok let's install openvpn-server"
				
				installOpenVPN
				
				;;

			macos)
				display $RED ERROR "Not supported"
				;;
		esac
	fi
}
