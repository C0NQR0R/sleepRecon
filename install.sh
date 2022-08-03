#!/bin/bash

#installation Script idea Taken from https://github.com/bing0o/SubEnum/blob/master/setup.sh


echo "INstalling Requirements ...."


Findomain() {
	printf "                                \r"
	wget https://github.com/Edu4rdSHL/findomain/releases/latest/download/findomain-linux &>/dev/null
	chmod +x findomain-linux
	./findomain-linux -h &>/dev/null && { sudo mv findomain-linux /usr/local/bin/findomain; printf "[+] Findomain Installed !.\n"; } || printf "[!] Install Findomain manually: https://github.com/Findomain/Findomain/blob/master/docs/INSTALLATION.md\n"
}


Subfinder() {
	printf "                                \r"
	go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest &>/dev/null
	printf "[+] Subfinder Installed !.\n"
}


Amass() {
	printf "                                \r"
	go install -v github.com/OWASP/Amass/v3/...@master &>/dev/null
	printf "[+] Amass Installed !.\n"
}

Assetfinder() {
	printf "                                \r"
	go install github.com/tomnomnom/assetfinder@latest &>/dev/null
	printf "[+] Assetfinder Installed !.\n"
}





Pip() {
	printf "                                \r"
	sudo apt install pip &>/dev/null
	printf "[+] pip Installed !.\n"

}

Httpx() {
	printf "                                \r"
	go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest &>/dev/null
	printf "[+] Assetfinder Installed !.\n"
}


Getallurls(){
	printf "                                \r"
	go install github.com/lc/gau/v2/cmd/gau@latest &>/dev/null
	printf "[+] Gau Installed !.\n"

}


go install github.com/tomnomnom/waybackurls@latest

waybackurls() {
	printf "                                \r"
	go install github.com/tomnomnom/waybackurls@latest &>/dev/null
	printf "[+] waybackurls Installed !.\n"

}

Unfurl() {
	printf "                                \r"
	go install github.com/tomnomnom/unfurl@latest &>/dev/null
	printf "[+] Unfurl Installed !.\n"


}

## If you already installed Go lang You should install Gf manual



Gowitness() {
	printf "                                \r"
	go install github.com/sensepost/gowitness@latest &>/dev/null
	printf "[+] Gowitness Installed !.\n"


}

Gf(){
	printf "                                \r"
	go install github.com/gogf/gf/v2@latest &>/dev/null
	printf "[+] Gf Installed !.\n"
	
}

hash go 2>/dev/null && printf "[!] Golang is already installed.\n"  

export GOROOT=/usr/local/go
export GOPATH=$HOME/go
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin


hash findomain 2>/dev/null && printf "[!] Findomain is already installed.\n" || { printf "[+] Installing Findomain!" && Findomain; }
hash subfinder 2>/dev/null && printf "[!] subfinder is already installed.\n" || { printf "[+] Installing subfinder!" && Subfinder; }
hash amass 2>/dev/null && printf "[!] Amass is already installed.\n" || { printf "[+] Installing Amass!" && Amass; }
hash assetfinder 2>/dev/null && printf "[!] Assetfinder is already installed.\n" || { printf "[+] Installing Assetfinder!" && Assetfinder; }
hash httpx 2>/dev/null && printf "[!] httpx is already installed.\n" || { printf "[+] Installing httpx!" && Httpx; } 
hash gau 2>/dev/null && printf "[!] getallurls is already installed.\n" || { printf "[+] Installing getallurls!" && Getallurls; }
hash waybackurls 2>/dev/null && printf "[!] waybackurls is already installed.\n" || { printf "[+] Installing waybackurls!" && Waybackurls; }
hash unfurl 2>/dev/null && printf "[!] unfurl is already installed.\n" || { printf "[+] Installing unfurl!" && Unfurl; }
hash gf 2>/dev/null && printf "[!] gf is already installed.\n" || { printf "[+] Installing gf!" && Gf ; }
hash gowitness 2>/dev/null && printf "[!] gowitness is already installed.\n" || { printf "[+] Installing gowitness!" && Gowitness; }


list=(
	go
	findomain
	subfinder
	amass
	assetfinder
	httpx
	gau
	waybackurls
	unfurl
	gowitness
	gf

	
	)



r="\e[31m"
g="\e[32m"
e="\e[0m"

for prg in ${list[@]}
do
        hash $prg 2>/dev/null && printf "[$prg]$g Done$e\n" || printf "[$prg]$r Not Installed! Check Again.$e\n"
done




