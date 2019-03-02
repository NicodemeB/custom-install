
installDependencies () {
	display $BLUE INFO "installing dependencies"
	echo Y |apt install openvpn curl python3
}

enableRouting() {
	display $BLUE INFO "enabling routing"
	echo 1 > /proc/sys/net/ipv4/ip_forward
	sed -i 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/' /etc/sysctl.conf
}

initServerFile() {
	display $BLUE INFO "initiating server files"

	gunzip -c /usr/share/doc/openvpn/examples/sample-config-files/server.conf.gz > /etc/openvpn/server.conf
	sed -i 's/;push "redirect-gateway def1 bypass-dhcp"/push "redirect-gateway def1 bypass-dhcp"/' /etc/openvpn/server.conf
	sed -i "s/;push \"dhcp-option DNS 208.67.222.222\"/push \"dhcp-option DNS ${DNS}\"/" /etc/openvpn/server.conf
	sed -i 's/;user nobody/user nobody/' /etc/openvpn/server.conf
	sed -i 's/;group nogroup/group nogroup/' /etc/openvpn/server.conf

	sed -i 's/tls-auth/;tls-auth/' /etc/openvpn/server.conf
}

uncommentVars() {
	sed -i "s/#set_var EASYRSA_REQ_COUNTRY/set_var EASYRSA_REQ_COUNTRY/" $1
	sed -i "s/#set_var EASYRSA_REQ_PROVINCE/set_var EASYRSA_REQ_PROVINCE/" $1
	sed -i "s/#set_var EASYRSA_REQ_CITY/set_var EASYRSA_REQ_CITY/" $1
	sed -i "s/#set_var EASYRSA_REQ_ORG/set_var EASYRSA_REQ_ORG/" $1
	sed -i "s/#set_var EASYRSA_REQ_EMAIL/set_var EASYRSA_REQ_EMAIL/" $1
	sed -i "s/#set_var EASYRSA_REQ_OU/set_var EASYRSA_REQ_OU/" $1
}

editVars () {
	sed -i "s/US/${KEY_COUNTRY}" $1
	sed -i "s/California/${KEY_PROVINCE}" $1
	sed -i "s/San Francisco/${KEY_CITY}" $1
	sed -i "s/Copyleft Certificate Co/${KEY_ORG}" $1
	sed -i "s/me@example.net/${KEY_EMAIL}" $1
	sed -i "s/My Organizational Unit/${KEY_OU}" $1

# NOT TESTED
	sed -i "s/\#set_var EASYRSA_REQ_CN         \"ChangeMe\"/set_var EASYRSA_REQ_CN         \"${KEY_CN}\"/" $1
}


buildCA() {
	display $BLUE INFO "building CA"
	# # cp -r /usr/share/easy-rsa/ /etc/openvpn
	# cd
	# git clone https://github.com/OpenVPN/easy-rsa-old.git
	# # rm -rf /etc/openvpn/easy-rsa/*
	# mkdir /etc/openvpn/easy-rsa
	# cp ~/easy-rsa-old/easy-rsa/2.0/* /etc/openvpn/easy-rsa
	# cd /etc/openvpn/easy-rsa
	# # mv openssl.cnf openssl.cnf.bak
	# ln -s openssl-1.0.0.cnf openssl.cnf
	# cd 
	# rm -rf ~/easy-rsa-old




	wget -P /etc/openvpn/ https://github.com/OpenVPN/easy-rsa/releases/download/v3.0.4/EasyRSA-3.0.4.tgz
	cd /etc/openvpn/
	tar xvf EasyRSA-3.0.4.tgz
	cd /etc/openvpn/EasyRSA-3.0.4/
	cp vars.example vars

	uncommentVars /etc/openvpn/EasyRSA-3.0.4/vars
	editVars /etc/openvpn/EasyRSA-3.0.4/vars

	./easyrsa init-pki
	./easyrsa build-ca nopass







	# mkdir /etc/openvpn/easy-rsa/keys

	# sed -i "s/export KEY_COUNTRY=\"US\"/export KEY_COUNTRY=\"${KEY_COUNTRY}\"/" /etc/openvpn/easy-rsa/vars
	# sed -i "s/export KEY_PROVINCE=\"CA\"/export KEY_PROVINCE=\"${KEY_PROVINCE}\"/" /etc/openvpn/easy-rsa/vars
	# sed -i "s/export KEY_CITY=\"SanFrancisco\"/export KEY_CITY=\"${KEY_CITY}\"/" /etc/openvpn/easy-rsa/vars
	# sed -i "s/export KEY_ORG=\"Fort-Funston\"/export KEY_ORG=\"${KEY_ORG}\"/" /etc/openvpn/easy-rsa/vars
	# sed -i "s/export KEY_EMAIL=mail@host.domain//" /etc/openvpn/easy-rsa/vars
	# sed -i "s/export KEY_EMAIL=\"me@myhost.mydomain\"/export KEY_EMAIL=\"${KEY_EMAIL}\"/" /etc/openvpn/easy-rsa/vars
	# sed -i "s/export KEY_OU=changeme/export KEY_OU=\"${KEY_OU}\"/" /etc/openvpn/easy-rsa/vars
	# sed -i "s/export KEY_NAME=changeme/export KEY_NAME=\"${KEY_NAME}\"/" /etc/openvpn/easy-rsa/vars
	# sed -i "s/export KEY_CN=changeme/export KEY_CN=KEY_CN/" /etc/openvpn/easy-rsa/vars
	# sed -i "s/export PKCS11_MODULE_PATH=changeme//" /etc/openvpn/easy-rsa/vars
		
	# openssl dhparam -out /etc/openvpn/dh2048.pem 2048
	# # cp /etc/ssl/openssl.cnf /etc/openvpn/easy-rsa/openssl-1.1.0.cnf
	# cd /etc/openvpn/easy-rsa
	# . ./vars
	# ./clean-all
	# ./pkitool --initca
	# sleep 1
	# ./pkitool --server server
}

copyKeysAndCertificates () {
	display $BLUE INFO "Copying server files"
	testFile /etc/openvpn/easy-rsa/keys/server.crt
	testFile /etc/openvpn/easy-rsa/keys/server.key
	testFile /etc/openvpn/easy-rsa/keys/ca.crt

	cp /etc/openvpn/easy-rsa/keys/server.crt /etc/openvpn 
	cp /etc/openvpn/easy-rsa/keys/server.key /etc/openvpn 
	cp /etc/openvpn/easy-rsa/keys/ca.crt /etc/openvpn 
}

generateClientCertificate () {
	display $BLUE INFO "generating client certificate"
	CLIENTNAME=$1
	export KEY_CN=$1
	cd /etc/openvpn/easy-rsa/
	./pkitool $CLIENTNAME

	mkdir /etc/openvpn/easy-rsa/keys/$CLIENTNAME
	mv /etc/openvpn/easy-rsa/keys/$CLIENTNAME.csr /etc/openvpn/easy-rsa/keys/$CLIENTNAME/
	mv /etc/openvpn/easy-rsa/keys/$CLIENTNAME.crt /etc/openvpn/easy-rsa/keys/$CLIENTNAME/
	mv /etc/openvpn/easy-rsa/keys/$CLIENTNAME.key /etc/openvpn/easy-rsa/keys/$CLIENTNAME/

	cp /usr/share/doc/openvpn/examples/sample-config-files/client.conf /etc/openvpn/easy-rsa/keys/$CLIENTNAME/$CLIENTNAME.ovpn
	sed -i "s/my-server-1/${VPN_SERVER_IP_DOMAIN}/" /etc/openvpn/easy-rsa/keys/$CLIENTNAME/$CLIENTNAME.ovpn
	sed -i 's/;user nobody/user nobody/' /etc/openvpn/easy-rsa/keys/$CLIENTNAME/$CLIENTNAME.ovpn
	sed -i 's/;group nogroup/group nogroup/' /etc/openvpn/easy-rsa/keys/$CLIENTNAME/$CLIENTNAME.ovpn

	sed -i 's/ca ca.crt/;ca ca.crt/' /etc/openvpn/easy-rsa/keys/$CLIENTNAME/$CLIENTNAME.ovpn
	sed -i 's/cert client.crt/;cert client.crt/' /etc/openvpn/easy-rsa/keys/$CLIENTNAME/$CLIENTNAME.ovpn
	sed -i 's/key client.key/;key client.key/' /etc/openvpn/easy-rsa/keys/$CLIENTNAME/$CLIENTNAME.ovpn

	sed -i 's/tls-auth ta.key 1/;tls-auth ta.key 1/' /etc/openvpn/easy-rsa/keys/$CLIENTNAME/$CLIENTNAME.ovpn
		
	echo '<ca>' >> /etc/openvpn/easy-rsa/keys/$CLIENTNAME/$CLIENTNAME.ovpn
	cat /etc/openvpn/ca.crt >> /etc/openvpn/easy-rsa/keys/$CLIENTNAME/$CLIENTNAME.ovpn
	echo '</ca>' >> /etc/openvpn/easy-rsa/keys/$CLIENTNAME/$CLIENTNAME.ovpn

	echo '<cert>' >> /etc/openvpn/easy-rsa/keys/$CLIENTNAME/$CLIENTNAME.ovpn
	cat /etc/openvpn/easy-rsa/keys/$CLIENTNAME/$CLIENTNAME.crt >> /etc/openvpn/easy-rsa/keys/$CLIENTNAME/$CLIENTNAME.ovpn
	echo '</cert>' >> /etc/openvpn/easy-rsa/keys/$CLIENTNAME/$CLIENTNAME.ovpn

	echo '<key>' >> /etc/openvpn/easy-rsa/keys/$CLIENTNAME/$CLIENTNAME.ovpn
	cat /etc/openvpn/easy-rsa/keys/$CLIENTNAME/$CLIENTNAME.key >> /etc/openvpn/easy-rsa/keys/$CLIENTNAME/$CLIENTNAME.ovpn
	echo '</key>' >> /etc/openvpn/easy-rsa/keys/$CLIENTNAME/$CLIENTNAME.ovpn

	mv /etc/openvpn/easy-rsa/keys/$CLIENTNAME/$CLIENTNAME.ovpn /etc/openvpn/easy-rsa/keys/$CLIENTNAME/$VPN_SERVER_IP_DOMAIN.ovpn

	display $BLUE INFO "client config .ovpn file can be found @ /etc/openvpn/easy-rsa/keys/$CLIENTNAME/$VPN_SERVER_IP_DOMAIN.ovpn"
}

installOpenVPN () {
	installDependencies
	initServerFile
	enableRouting
	buildCA
	# copyKeysAndCertificates
	# systemctl restart openvpn
	# generateClientCertificate $CLIENT_NAME
	# systemctl daemon-reload
	# systemctl restart openvpn
}



