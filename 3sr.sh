#! /bin/bash 
url=$1

figlet "3srRecon"






if [ ! -d "$url" ]; then
      mkdir $url
fi
if [ ! -d "$url/recon" ]; then
      mkdir $url/recon
fi
echo "[+]Enumurating SubDomains Using Assetfinder..." 
assetfinder $url >> $url/recon/assetfinder.txt
cat $url/recon/assetfinder.txt | grep $url >> $url/recon/final.txt
rm $url/recon/assetfinder.txt

echo "[+]Enumurating SubDomains Using SubFinder..."
subfinder -d $url -o $url/recon/subfinder.txt
cat $url/recon/subfinder.txt | grep $url >> $url/recon/final.txt
rm $url/recon/subfinder.txt

echo "[+]Enumurating SubDomains Using Findomain..." 
findomain -t $url -q >> $url/recon/findomain.txt
cat $url/recon/findomain.txt | grep $url >> $url/recon/final.txt
rm $url/recon/findomain.txt

echo "[+]Enumurating SubDomains Using Sublist3r..."
python3 /opt/Sublist3r/sublist3r.py -d $url -o $1/recon/sublist3r.txt
cat $url/recon/sublist3r.txt | grep $url >> $url/recon/final.txt
rm $1/recon/sublist3r.txt 

echo "[+]Enumurating SubDomains Using Amass..." 
amass enum -d $url >> $url/recon/amass.txt
cat $url/recon/amass.txt | grep $url >> $url/recon/final.txt
rm $url/recon/amass.txt

echo "[+]Filtering Repeated Domains........." 
cat $url/recon/final.txt | sort -u | tee $url/recon/final_subs.txt 
rm $url/recon/final.txt 

echo "[+]Total Unique SubDomains" 
cat $url/recon/final_subs.txt | wc -l
#--------------------------------------------------------------------------------------------------
#-----------------------------------Filtering Live SubDomains--------------------------------------
#--------------------------------------------------------------------------------------------------
echo "[+]Removing Dead Domains Using httpx....." 
cat $url/recon/final_subs.txt | httpx --silent  >> $url/recon/live_check.txt

echo "[+]Removing Dead Domains Using httprobe....." 
cat $url/recon/final_subs.txt | httprobe >> $url/recon/live_check.txt

echo "[+]Analyzing Both httpx & httprobe....."
cat $url/recon/live_check.txt | sed 's/https\?:\/\///' | sort -u | tee $url/recon/live_subs.txt 
rm $url/recon/live_check.txt

echo "[+]Total Unique Live SubDomains....."
cat $url/recon/live_subs.txt | wc -l
#--------------------------------------------------------------------------------------------------
#-----------------------------------Enumurating Urls-----------------------------------------
#--------------------------------------------------------------------------------------------------
echo "[+]Enumurating Params From Paramspider...." 
python3 /opt/paramspider/paramspider.py --level high -d $url -p noor -o $1/recon/urls.txt
echo "[+]Enumurating Params From Waybackurls...." 
cat $1/recon/live_subs.txt | waybackurls | sort -u >> $1/recon/urls.txt
#echo "[+]Enumurating Params From gau Tool...." 
#gau --subs  $url | sort -u >> $url/recon/urls.txt 
#echo "[+]Enumurating Params From gauPlus Tool...." 
#cat $url/recon/live_subs.txt | gauplus | sort -u >> $1/recon/urls.txt

echo "[+]Filtering Dups..." 
cat $1/recon/urls.txt | sort -u | tee $1/recon/final_urls.txt 

rm $url/recon/urls.txt

echo "[+]Total Unique Params Found...." 
cat $url/recon/final_urls.txt | wc -l
#--------------------------------------------------------------------------------------------------
#-----------------------------------Enumurating Parameters-----------------------------------------
#--------------------------------------------------------------------------------------------------
echo "[+]Filtering Paramas From urls..." 
cat $1/recon/final_urls.txt | grep = | qsreplace noor >> $url/recon/final_params.txt 
figlet "Fuzzing Urls"
#--------------------------------------------------------------------------------------------------
#-------------------------------Checking For HTMLi Injection---------------------------------------
#--------------------------------------------------------------------------------------------------
echo "[+]Testing For HTML Injection...." 
cat $url/recon/final_params.txt | qsreplace '"><u>hyper</u>' | tee $url/recon/temp.txt && cat $url/recon/temp.txt | while read host do ; do curl --silent --path-as-is --insecure "$host" | grep -qs "<u>hyper</u>" && echo "$host"; done > $url/htmli.txt
rm $url/recon/temp.txt
#--------------------------------------------------------------------------------------------------
#-------------------------------Checking For XSS Injection-----------------------------------------
#--------------------------------------------------------------------------------------------------
echo "[+]Testing For XSS Injection...." 
dalfox file $url/htmli.txt -o $url/xss.txt
