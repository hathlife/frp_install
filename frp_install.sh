#Get latest release tag
RELEASETAG=$(git ls-remote --tags https://github.com/fatedier/frp | sort -t '/' -k 2 -V | sed -e '/\^/d')
export FRP_VERSION=${RELEASETAG:0-6}
echo "The latest frp release is ${FRP_VERSION}"
mkdir -p /etc/frp
rm -rf /tmp/frp_${FRP_VERSION}_linux_amd64*
cd /tmp
 echo "Downloading tar package from Github......"
 wget -q "https://github.com/fatedier/frp/releases/download/v${FRP_VERSION}/frp_${FRP_VERSION}_linux_amd64.tar.gz"
 echo "Download complete."
 echo "Unpacking......"
 tar xzf frp_${FRP_VERSION}_linux_amd64.tar.gz
 echo "Installing binary files......"
 cp ./frp_${FRP_VERSION}_linux_amd64/frps /usr/bin && chmod +x /usr/bin/frps
 cp ./frp_${FRP_VERSION}_linux_amd64/frpc /usr/bin && chmod +x /usr/bin/frpc
 setcap cap_net_bind_service=ep /usr/bin/frps #Give frps binary access to well-known ports(smbd,NetBIOS,etc).
 echo "Installing configuration files......"
 test -e /etc/frp/frpc.ini  && echo "Configuration files exist." || echo "Configuration files do not exist. Copy templetes." && cp ./frp_${FRP_VERSION}_linux_amd64/frp*.ini /etc/frp
 echo "Configuration file is installed to /etc/frp ."
 cp ./frp_${FRP_VERSION}_linux_amd64/systemd/* /lib/systemd/system
 echo "Install complete."
 echo "See https://github.com/fatedier/frp/blob/master/README.md for configuration."
 echo "Use \"systemctl start frps\" or \"systemctl start frpc\" to start frpc/frps service."
 #systemctl enable frps
 #systemctl enable frpc
 rm -rf /tmp/frp_${FRP_VERSION}_linux_amd64*