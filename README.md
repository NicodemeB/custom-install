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