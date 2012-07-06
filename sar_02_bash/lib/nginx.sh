
nginx_pwd="/usr/share/nginx/html/sar"

function generate_html() {
cat << EOF
<html>
EOF

mypwd=${PWD}
cd ${nginx_pwd}

for i in *.png ; do
cat << EOF
<img src="$i">
EOF
done

cd ${mypwd}

cat << EOF
</html>
EOF
}

function nginx_html() {
HTML="${nginx_pwd}/index.html"
 echo "kopiuje ..."
 cp -f output/*.png /usr/share/nginx/html/sar/
 echo "tworze plik html ..."
 generate_html > ${HTML}
 echo "DONE"
}

nginx_html

