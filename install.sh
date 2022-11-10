#! /bin/bash 
speedtest
sudo apt install figlet -y
figlet "Installing Requirements" 
sudo apt update -y
sudo apt upgrade -y
sudo apt install python -y
sudo apt install python2 -y
sudo apt install python3 -y
sudo apt install python-pip -y
sudo apt install python3-pip -y
sudo apt install git -y
sudo apt install php -y

echo "[+] Installing Go-Lang....." 
wget https://go.dev/dl/go1.19.2.linux-amd64.tar.gz
cp go1.19.2.linux-amd64.tar.gz /root/
rm -rf /usr/local/go && tar -C /usr/local -xzf go1.19.2.linux-amd64.tar.gz
export PATH=$PATH:/usr/local/go/bin
go version

figlet "Installing Recon Tools"
echo "[+]Installing ffuf...."
go install github.com/ffuf/ffuf@latest
cp /root/go/bin/ffuf /usr/local/bin/
echo "[+]Installing qsreplace...."
go install github.com/tomnomnom/qsreplace@latest
cp /root/go/bin/qsreplace /usr/local/bin/
echo "[+]Installing httpx, httprobe...."
go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest
cp /root/go/bin/httpx /usr/local/bin/
go install github.com/tomnomnom/httprobe@latest 
cp /root/go/bin/httprobe /usr/local/bin/
echo "[+]Installing gf-patterns...."
go install github.com/tomnomnom/gf@latest
cp /root/go/bin/gf /usr/local/bin/
echo "[+]Installing kxss, Gxss...."
go install github.com/KathanP19/Gxss@latest
cp /root/go/bin/Gxss /usr/local/bin/
go install github.com/Emoe/kxss@latest
cp /root/go/bin/kxss /usr/local/bin/
echo "[+]Installing ScreenShoters (Eye & GoWitness)...."
git clone https://github.com/FortyNorthSecurity/EyeWitness.git
mv EyeWitness /opt/
sudo /opt/EyeWitness/Python/setup/setup.sh
go install github.com/sensepost/gowitness@latest
cp /root/go/bin/gowitness /usr/local/bin/

#--------------------------------------Installing SubDomains Finders--------------------------------------------------
echo "[+] Installing Assestfinder..." 
go install github.com/tomnomnom/assetfinder@latest
cp /root/go/bin/assetfinder /usr/local/bin
echo "[+] Installing SubFinder......." 
go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
cp /root/go/bin/subfinder /usr/local/bin/
echo "[+] Installing Findomain........"
curl -LO https://github.com/findomain/findomain/releases/latest/download/findomain-linux.zip
unzip findomain-linux.zip
chmod +x findomain
sudo mv findomain /usr/bin/findomain
findomain --help
echo "[+] Installing Amass......." 
go install -v github.com/OWASP/Amass/v3/...@master
cp /root/go/bin/amass /usr/local/bin/
echo "[+] Installing SubList3r........." 
git clone https://github.com/aboul3la/sublist3r.git 
mv sublist3r /opt/
pip3 install -r /opt/sublist3r/requirements.txt
#------------------------------------------Installing Url Crawlers ---------------------------------------------------
echo "[+] Installing Waybackurls....." 
go install github.com/tomnomnom/waybackurls@latest
cp /root/go/bin/waybackurls /usr/local/bin/
echo "[+] Installing gau - Get All Urls" 
go install github.com/lc/gau/v2/cmd/gau@latest
cp /root/go/bin/gau /usr/local/bin/
echo "[+] Installing gauplus........" 
go install github.com/bp0lr/gauplus@latest
cp /root/go/bin/gauplus /usr/local/bin/
echo "[+] Installing Paramspider......"
git clone https://github.com/devanshbatham/paramspider.git
mv paramspider /opt/
pip3 install -r /opt/paramspider/requirements.txt

echo "Installing Dalfox..."
go install github.com/hahwul/dalfox/v2@latest
cp /root/go/bin/dalfox /usr/local/bin/
