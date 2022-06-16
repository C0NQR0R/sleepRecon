#!/bin/bash 
bold="\e[1m"
red="\e[31m"
green="\e[32m"
blue="\e[34m"
end="\e[0m"
VERSION="2022-06-1"
icon="\U2705"
PLC=$(pwd) 

################################################
# Output will be Here sleepRecon/output/

ToolBanner(){
cat <<"EOF"
			
      _                    ______                         
     | |                  (_____ \                        
  ___| | _____ _____ ____  _____) )_____  ____ ___  ____  
 /___) || ___ | ___ |  _ \|  __  /| ___ |/ ___) _ \|  _ \ 
|___ | || ____| ____| |_| | |  \ \| ____( (__| |_| | | | |
(___/ \_)_____)_____)  __/|_|   |_|_____)\____)___/|_| |_|
                    |_|                                   
	Finally you can sleep well :D xD | @qaramany0x01

EOF

}
############### Spinner  ###############

spinner(){
	processing="${1}"
	while true; 
	do
		dots=(
			"/"
			"-"
			"\\"
			"|"
			)
		for dot in ${dots[@]};
		do
			printf "[${dot}] ${processing} \U1F50E"
			printf "                                    \r"
			sleep 0.3
		done
		
	done
}

############### Making Directories for OutPut ###############

HouseKeeping(){
echo -e -n "$green Enter Company Name : $end" ; read company_name


echo -e -n "$green Enter The domain : $end" ; read domain_name

mkdir -p output/$company_name/subdomainEnum/
mkdir -p output/$company_name/aliveSubdomains/
mkdir -p output/$company_name/screenShots/
mkdir -p output/$company_name/urls/vulns
mkdir -p output/$company_name/urls/params/
results=output/$company_name

echo -e ""
echo -e ""

echo -e "$blue Directories are ready to use :D $end"
echo -e ""
echo -e ""

echo -e "$blue Output will be under : $end"
echo -e "$blue $PLC/$results/ $end"

 
}




################## Subdomain Enum ##################

# - Subfinder - #

subfinder_subs(){

spinner "${bold}SubFinder${end}" & PID="$!" 
subfinder -all -silent -d $domain_name 1> $results/subdomainEnum/$domain_name-subfinder.txt 2> /dev/null
kill ${PID}
echo -e "$bold[-] SubFinder $end:$red $(wc -l < $results/subdomainEnum/$domain_name-subfinder.txt ) $end$icon" 

}

# - WaybackMachine - #
wayback_subs(){
spinner "${bold}WaybackMachine${end}" & PID="$!" 
curl -sk "http://web.archive.org/cdx/search/cdx?url=*.$domain_name&output=txt&fl=original&collapse=urlkey&page=" | awk -F/ '{gsub(/:.*/, "", $3); print $3}' | sort -u 1> $results/subdomainEnum/$domain_name-wayback_subs.txt 2>/dev/null
kill ${PID}
echo -e "$bold[-] WaybackMachine $end:$red $(wc -l < $results/subdomainEnum/$domain_name-wayback_subs.txt ) $end"

}
# - Crt.sh - #

crt_subs(){
spinner "${bold}Crt.sh ${end}" & PID="$!" 
curl -sk "https://crt.sh/?q=%.$domain_name&output=json" | tr ',' '\n' | awk -F'"' '/name_value/ {gsub(/\*\./, "", $4); gsub(/\\n/,"\n",$4);print $4}' | sort -u 1> $results/subdomainEnum/$domain_name-crt.sh_subs.txt 2>/dev/null
kill ${PID}
echo -e "$bold[-] Crt.sh $end:$red $(wc -l < $results/subdomainEnum/$domain_name-crt.sh_subs.txt ) $end$icon"

}


# - Bufferover  - #

bufferover_subs(){
spinner "${bold}Bufferover ${end}" & PID="$!" 
curl -s "https://dns.bufferover.run/dns?q=.$domain_name" | grep $domain_name | awk -F, '{gsub("\"", "", $2); print $2}' | sort -u 1> $results/subdomainEnum/$domain_name-bufferover.txt 2>/dev/null
kill ${PID}
echo -e "$bold[-] Bufferover $end:$red $(wc -l < $results/subdomainEnum/$domain_name-bufferover.txt ) $end$icon" # $red $end


}


# - Findomain - #

findomain_subs(){
spinner "${bold}Findomain${end}" & PID="$!" 
findomain -t $domain_name -q 1> $results/subdomainEnum/$domain_name-findomain.txt 2> /dev/null 
kill ${PID}
echo -e "$bold[-] Findomain $end:$red $(wc -l < $results/subdomainEnum/$domain_name-findomain.txt ) $end$icon"


}

# - Assetfinder  - #

assetfinder_subs(){
spinner "${bold}Assetfinder${end}" & PID="$!" 
assetfinder --subs-only $domain_name 1> $results/subdomainEnum/$domain_name-assetfinder.txt 2> /dev/null
kill ${PID}
echo -e "$bold[-] Assetfinder $end:$red $(wc -l < $results/subdomainEnum/$domain_name-assetfinder.txt ) $end$icon"

}

# - Amass Enum mode - #

amass_subs(){
spinner "${bold}Amass${end}" & PID="$!" 
amass enum -passive -norecursive -noalts -d $domain_name 1> $results/subdomainEnum/$domain_name-amass.txt 2>/dev/null	
kill ${PID}
echo -e "$bold[-] Amass $end:$red $(wc -l < $results/subdomainEnum/$domain_name-amass.txt ) $end$icon"

}

# - Remove Duplicates and Sorting subdomains into one file - #

sorting_subs(){
spinner "${red}Sorting Subdomains${end}" & PID="$!" 
cat $results/subdomainEnum/* | sort -u 1> $results/subdomainEnum/$domain_name-all-subs.txt 2> /dev/null 
kill ${PID}
echo -e "$green[-] All Subdomains $end:$red $( wc -l < $results/subdomainEnum/$domain_name-all-subs.txt ) $end$icon"

}

# - Function to Call Subdomain Enum functions - #


callingAllSubsFunction(){
echo -e "$red Starting Subdomain Enumuration .... $end"
echo ""

subfinder_subs
wayback_subs
crt_subs
bufferover_subs
findomain_subs
assetfinder_subs
amass_subs
sorting_subs
echo ""

echo -e "$red Subdomain Enumuration Done results will under :$end"
echo -e "$results/subdomainEnum/"

echo ""
echo -e "$bold------------------------------------$end"
echo ""

}





################## Done Subdomain Enum ##################




################## Collecting Alive Subdomains ##################


gettingAlive(){
echo -e "$red Starting Alive Subdomains Checking .... $end"

spinner "${red}Alive${end}" & PID="$!" 
cat $results/subdomainEnum/$domain_name-all-subs.txt | httpx -silent -ports 80,8443,443,8080 1> $results/aliveSubdomains/$domain_name-alive-subs.txt 2> /dev/null 
kill ${PID}
echo -e "$green[-] Alive Subdomains Result $end:$red $(wc -l < $results/aliveSubdomains/$domain_name-alive-subs.txt ) $end$icon"

echo -e ""
echo -e "$red Done Alive Subdomains Checking results are in :$end"
echo -e "$results/aliveSubdomains/"
echo -e ""

}

################## Start Screen Shots Taking ##################



gettingUrls(){
	cd $PLC
	echo -e ""

	echo -e "$green Starting Urls Getallurls .... $end"

	spinner "${red}Getallurls ${end}" & PID="$!" 
	getallurls -subs $domain_name 1> output/$company_name/urls/$domain_name-getallurls.txt 2> /dev/null
	echo -e "$bold[-] Getallurls $end:$red $(wc -l < output/$company_name/urls/$domain_name-getallurls.txt ) $end$icon"
	
	kill ${PID}
	echo -e ""

	echo -e "$green Starting Urls Waybackurls .... $end"
	spinner "${red}Waybackurls ${end}" & PID="$!" 
	echo $domain_name | waybackurls 1> output/$company_name/urls/$domain_name-waybackurls.txt 2> /dev/null
	echo -e "$bold[-] waybackurls $end:$red $(wc -l < output/$company_name/urls/$domain_name-waybackurls.txt ) $end$icon"
	kill ${PID}

echo -e ""

}


#########################################################################
gettingParameters(){
	echo -e "$green Starting Endpoints Collecting .... $end"

cat output/$company_name/urls/$domain_name-waybackurls.txt  | sort -u | unfurl --unique keys 1> output/$company_name/urls/params/$domain_name-paramlist.txt 2> /dev/null
	echo -e "$bold[-] paramlist $end:$red $(wc -l < output/$company_name/urls/params/$domain_name-paramlist.txt ) $end$icon" 2> /dev/null

cat output/$company_name/urls/$domain_name-waybackurls.txt  | sort -u | grep -P ".php" 1> output/$company_name/urls/params/$domain_name-phpurls.txt 2> /dev/null
	echo -e "$bold[-] php urls $end:$red $(wc -l < output/$company_name/urls/params/$domain_name-phpurls.txt ) $end$icon" 2> /dev/null


cat output/$company_name/urls/$domain_name-waybackurls.txt  | sort -u | grep -P ".asp" 1> output/$company_name/urls/params/$domain_name-aspurls.txt 2> /dev/null
	echo -e "$bold[-] aspx urls $end:$red $(wc -l < output/$company_name/urls/params/$domain_name-aspurls.txt ) $end$icon" 2> /dev/null

cat output/$company_name/urls/$domain_name-waybackurls.txt  | sort -u | grep -P ".jsp" 1> output/$company_name/urls/params/$domain_name-jspurls.txt 2> /dev/null
	echo -e "$bold[-] jsp urls $end:$red $(wc -l < output/$company_name/urls/params/$domain_name-jspurls.txt ) $end$icon" 2> /dev/null
cat output/$company_name/urls/$domain_name-waybackurls.txt  | sort -u | grep -P ".json" 1> output/$company_name/urls/params/$domain_name-jsonurls.txt 2> /dev/null
	echo -e "$bold[-] json urls $end:$red $(wc -l < output/$company_name/urls/params/$domain_name-jsonurls.txt ) $end$icon" 2> /dev/null
echo -e "$bold[-] Done paramlist,php,aspx,jsp  $end"


echo -e ""
echo -e "$bold------------------------------------$end"
echo -e ""

	}

gettingGfLinks(){
	echo -e "$green Starting Parameters Vulns Collecting .... $end"

	cat output/$company_name/urls/$domain_name-waybackurls.txt | grep = | gf xss 1> output/$company_name/urls/vulns/$domain_name-xss
	cat output/$company_name/urls/$domain_name-waybackurls.txt | grep = | gf ssti 1> output/$company_name/urls/vulns/$domain_name-ssti
	cat output/$company_name/urls/$domain_name-waybackurls.txt | grep = | gf sqli 1> output/$company_name/urls/vulns/$domain_name-sqli
	cat output/$company_name/urls/$domain_name-waybackurls.txt | grep = | gf redirect 1> output/$company_name/urls/vulns/$domain_name-redirect
	cat output/$company_name/urls/$domain_name-waybackurls.txt | grep = | gf rce 1> output/$company_name/urls/vulns/$domain_name-rce
	cat output/$company_name/urls/$domain_name-waybackurls.txt | grep = | gf idor 1> output/$company_name/urls/vulns/$domain_name-idor
	cat output/$company_name/urls/$domain_name-waybackurls.txt | grep = | gf ssrf 1> output/$company_name/urls/vulns/$domain_name-ssrf
	cat output/$company_name/urls/$domain_name-waybackurls.txt | grep = | gf lfi 1> output/$company_name/urls/vulns/$domain_name-lfi

echo -e "$bold[-] Done Parameters using Gf $end"
echo -e ""
echo -e "$bold------------------------------------$end"
echo -e ""
}




gettingScreenShots(){
echo -e "$red Starting ScreenShots Checking .... $end"
spinner "${red}Gowitness-ScreenShots${end}" & PID="$!" 
cd $PLC/output/$company_name/screenShots/
sleep 2
kill ${PID}

kill $(lsof -t -i:7171) 2> /dev/null
gowitness file -f $PLC/$results/aliveSubdomains/$domain_name-alive-subs.txt &
gowitness report serve &>/dev/null &
echo -e "The Report Created , Check it http://localhost:7171"
cd $PLC

echo -e "$red Done ScreenShots .... $end"
echo -e ""
echo -e "$bold------------------------------------$end"
echo -e ""
}



######### Running Functions Section #########


ToolBanner
HouseKeeping
echo -e ""
echo -e ""
echo -e "$bold------------------ Let's Do Some Shits xD ------------------$end"
echo -e ""

callingAllSubsFunction
gettingAlive
gettingUrls
gettingParameters
gettingGfLinks
gettingScreenShots

echo -e ""
echo -e "$bold---------------- Done wih love Happy Hunting -----------------$end"
echo -e ""
