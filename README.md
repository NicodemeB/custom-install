# custom-install

## Simply run :
<!--sh -c "$(curl -fsSL https://raw.githubusercontent.com/NicodemeB/custom-install/master/custom_install.sh)"-->
```bash
git clone https://github.com/NicodemeB/custom-install.git
cd custom_install 
./custom_install.sh -f -d debian
```
## Usage
```bash
-d | --distri {debian/macos}
-f | --from-scratch 
```
From scratch instal must be done by root user

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
Varibales for all installations are stored in a JSON file. If you need to edit variables, best method is to download the git in local, change vars, and than execute it in ssh ass following :

```zsh
scp -r custom-install root@192.168.250.166: >> /dev/null 2> /dev/null ; ssh root@192.168.250.166 'cd ~/custom-install ; echo y |./custom_install.sh'
```

Where you can setup argss

### OpenVPN

