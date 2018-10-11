# custom-install

## Simply run :
<!--sh -c "$(curl -fsSL https://raw.githubusercontent.com/NicodemeB/custom-install/master/custom_install.sh)"-->
```bash
git clone https://github.com/NicodemeB/custom-install.git
cd custom_install 
./custom_install.sh -f -d debian
```
## Usage

All script is build to be run on a `zsh` environement. somme functionnalities are not properly working on `bash`. Make sure to use `zsh` shell! (which is automacaly installed by this tool)

Most of the configurations required a root level, so they must be perform with the root user. Only `--shell` arg does not require root privileges.

```help
-d  --distri {debian/macos}		select the correct tager os
-s  --shell						install ohmyszh customized
-f  --from-scratch 				install few plugins, for iterms etc
-w	--webCV						install apache2 and configured webCV
-o	--openvpn					install an openvpn server
```

<!--
### debian - from scratch 
```bash
curl https://raw.githubusercontent.com/NicodemeB/custom-install/master/custom_install.sh | bash --from-scratch --distri debian
```

### macos - from scratch 
```bash
curl https://raw.githubusercontent.com/NicodemeB/custom-install/master/custom_install.sh | bash --from-scratch --distri macos
```

sh -c "$(wget https://raw.githubusercontent.com/NicodemeB/custom-install/master/custom_install.sh -O -)"-->


## Variables 
Varibales for all installations are stored in a JSON file [vars.json](vars.json). If you need to edit variables, best method is to download the git in local, change vars, and than execute it in ssh to the remote machine as following :

```bash
scp -r custom-install root@192.168.250.166: >> /dev/null 2> /dev/null ; ssh root@192.168.250.166 'cd ~/custom-install ; echo y |./custom_install.sh'
```

Where you can setup args

### OpenVPN


### webCV 

First usage is to deploy a webCV, but the deployed web site can be any other type of site. Only the github link is important. Make sur to change it, and change github credentilas too.



