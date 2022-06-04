#!/bin/bash

LT_DIRROOT="/srv/www/linux/man";
LT_DOMAIN="http://linux.tamer.pw";

mkdir -p $LT_DIRROOT;

rm "${LT_DIRROOT}/sitemap.txt";
rm "${LT_DIRROOT}/1/sitemap.txt";
rm "${LT_DIRROOT}/2/sitemap.txt";
rm "${LT_DIRROOT}/3/sitemap.txt";
rm "${LT_DIRROOT}/4/sitemap.txt";
rm "${LT_DIRROOT}/5/sitemap.txt";
rm "${LT_DIRROOT}/6/sitemap.txt";
rm "${LT_DIRROOT}/7/sitemap.txt";
rm "${LT_DIRROOT}/8/sitemap.txt";
rm "${LT_DIRROOT}/index.html";
rm "${LT_DIRROOT}/1/index.html";
rm "${LT_DIRROOT}/2/index.html";
rm "${LT_DIRROOT}/3/index.html";
rm "${LT_DIRROOT}/4/index.html";
rm "${LT_DIRROOT}/5/index.html";
rm "${LT_DIRROOT}/6/index.html";
rm "${LT_DIRROOT}/7/index.html";
rm "${LT_DIRROOT}/8/index.html";

touch "${LT_DIRROOT}/man/sitemap.txt";
echo "${LT_DOMAIN}/man/index.htm" >> "${LT_DIRROOT}/sitemap.txt";
echo "${LT_DOMAIN}/man/1/index.htm" >> "${LT_DIRROOT}/sitemap.txt";
echo "${LT_DOMAIN}/man/2/index.htm" >> "${LT_DIRROOT}/sitemap.txt";
echo "${LT_DOMAIN}/man/3/index.htm" >> "${LT_DIRROOT}/sitemap.txt";
echo "${LT_DOMAIN}/man/4/index.htm" >> "${LT_DIRROOT}/sitemap.txt";
echo "${LT_DOMAIN}/man/5/index.htm" >> "${LT_DIRROOT}/sitemap.txt";
echo "${LT_DOMAIN}/man/6/index.htm" >> "${LT_DIRROOT}/sitemap.txt";
echo "${LT_DOMAIN}/man/7/index.htm" >> "${LT_DIRROOT}/sitemap.txt";
echo "${LT_DOMAIN}/man/8/index.htm" >> "${LT_DIRROOT}/sitemap.txt";
echo "${LT_DOMAIN}/man/1/sitemap.txt" >> "${LT_DIRROOT}/sitemap.txt";
echo "${LT_DOMAIN}/man/2/sitemap.txt" >> "${LT_DIRROOT}/sitemap.txt";
echo "${LT_DOMAIN}/man/3/sitemap.txt" >> "${LT_DIRROOT}/sitemap.txt";
echo "${LT_DOMAIN}/man/4/sitemap.txt" >> "${LT_DIRROOT}/sitemap.txt";
echo "${LT_DOMAIN}/man/5/sitemap.txt" >> "${LT_DIRROOT}/sitemap.txt";
echo "${LT_DOMAIN}/man/6/sitemap.txt" >> "${LT_DIRROOT}/sitemap.txt";
echo "${LT_DOMAIN}/man/7/sitemap.txt" >> "${LT_DIRROOT}/sitemap.txt";
echo "${LT_DOMAIN}/man/8/sitemap.txt" >> "${LT_DIRROOT}/sitemap.txt";

FOOTER='<footer style="text-align: center;"><a href="https://blog.tamer.pw" target="_blank">Blog</a>';
FOOTER+=' | <a href="https://github.com/linuxtamer" target="_blank">Contact</a>';
FOOTER+='</footer>\n';
FOOTER+="</div>\n</body>\n</html>\n";

man -k '' | while read LT_LINE; do

	LT_NAME=$(echo $LT_LINE | awk '{ print $1 ; }');
	LT_SECTION=$(echo $LT_LINE | cut -d')' -f1|cut -d'(' -f2);
	LT_SECTION="${LT_SECTION:0:1}";
	LT_DESC=$(echo $LT_LINE | awk -F ' - ' '{ print $2 ; }' );
	LT_PATH=$(whereis -m $LT_NAME | awk '{ print $2 ; }');
	LT_PRE="${LT_NAME:0:1}";
	LT_EXT="${LT_PATH##*.}";

	if [ -f "/usr/share/man/man${LT_SECTION}/${LT_NAME}.${LT_SECTION}.gz" ]; then
		LT_PATH="/usr/share/man/man${LT_SECTION}/${LT_NAME}.${LT_SECTION}.gz";
	fi

	case $LT_SECTION in
		1) let LT_CATEGORY="user";;
		2) let LT_CATEGORY="system";;
		3) let LT_CATEGORY="library";;
		4) let LT_CATEGORY="special";;
		5) let LT_CATEGORY="file";;
		6) let LT_CATEGORY="games";;
		7) let LT_CATEGORY="conventions";;
		8) let LT_CATEGORY="administration";;
		*) let LT_CATEGORY="other";;
	esac

	if [[  $LT_EXT == gz && $LT_PRE != _  && $LT_PRE != '[' && ${#LT_NAME} -gt 1 ]]
	then
		mkdir -p ${LT_DIRROOT}/${LT_SECTION};

		if [ ${LT_NAME} == "index" ]; then
			LT_LINK="${LT_SECTION}/${LT_NAME}.cmd.html";
		else
			LT_LINK="${LT_SECTION}/${LT_NAME}.html";
		fi

		printf '<p><a href="/man/%s">%s</a> %s</p>\n' "${LT_LINK}" "${LT_NAME}" "${LT_DESC}" >> "${LT_DIRROOT}/${LT_SECTION}/index.html";
		printf "%s/man/%s\n" "${LT_DOMAIN}" "${LT_LINK}" >> "${LT_DIRROOT}/${LT_SECTION}/sitemap.txt";

		HTML='<!DOCTYPE html>\n<html lang=en-US>\n<head>\n<meta charset=utf-8>\n';
		HTML+=$(printf '<title>Linux command %s</title>\n' "${LT_NAME}");
		HTML+=$(printf '<meta name="description" content="Linux command %s %s">\n' "${LT_NAME}" "${LT_DESC}");
		HTML+=$(printf '<meta name="keywords" content="linux, command, %s, bsd, %s">\n' "${LT_NAME}" "${LT_DESC}" );
		HTML+='<meta name="robots" content="index,follow">\n';
		HTML+='<meta name="viewport" content="width=device-width, initial-scale=1">\n';
		HTML+='</head>\n<body>\n<div class="container">\n';
		echo -e $HTML >> ${LT_NAME}.html;
		zcat $LT_PATH | pandoc --from man --to html >> ${LT_NAME}.html;
		echo -e $FOOTER >> ${LT_NAME}.html;

		if [ ${LT_NAME} == "intro" ]; then
			cut intro.html >> tmp.html;
			cut "${LT_DIRROOT}/${LT_SECTION}/index.html" >> tmp.html;
			mv tmp.html "${LT_DIRROOT}/${LT_SECTION}/index.html";
		fi

		mv ${LT_NAME}.html ${LT_DIRROOT}/${LT_SECTION}/${LT_NAME}.html ;

		echo "${LT_SECTION}) ${LT_NAME} -> ${LT_DESC} == ${LT_PATH} ";
	fi
done

