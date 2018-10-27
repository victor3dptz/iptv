#!/bin/bash

rm -f ./tmp/*.m3u
rm -f ./tmp/out.tmp
clear
#curl -A "Mozilla/4.0 (compatible; MSIE 5.01; Windows NT 5.0)" "https://secure.topiptv.info/list.php?login=victor3d&password=geheim&type=m3u" > ./tmp/1.m3u
wget -P ./tmp http://iptv.slynet.tv/FreeSlyNet.m3u -O ./tmp/2.m3u
wget -P ./tmp http://iptv.slynet.tv/FreeBestTV.m3u -O ./tmp/3.m3u
wget -P ./tmp http://iptv.slynet.tv/FreeWorldTV.m3u -O ./tmp/4.m3u

#echo "#EXTM3U" > ./tmp/out.tmp
awk 'NR<2 {print $1}' original.template > ./tmp/out.tmp
for i in 2 3 4
do
awk -F "," 'NR>1 {if (match($1,"#EXTINF")){print "#EXTINF:-1,"$2} else {if (match($1,"://")){print $1}}}' ./tmp/$i.m3u >> ./tmp/out.tmp
done

# Очистка от говна
awk '/PremiumSlyNet|==|Самообновляемый|ВКонтакте|Наш сайт|gmail.com/{ n=2 }; n {n--;next}; 1' ./tmp/out.tmp > ./iptv.m3u

# Только CDN
grep -B1 trtcanlitv ./iptv.m3u > ./tmp/out.tmp
grep -B1 cdn ./iptv.m3u >> ./tmp/out.tmp
awk 'NR<2 {print $0}' original.template > ./iptv-cdn.m3u
awk '{if (match($0,"--")) {next} else { print $0}}' ./tmp/out.tmp >> ./iptv-cdn.m3u

# Проверка валидных каналов
#bash ./check.sh iptv.m3u
