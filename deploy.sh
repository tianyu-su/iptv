#!/bin/bash

TMP_DIR='/tmp/tv_tmp'

fanming_git=$TMP_DIR/fanming_live
iplist_git=$TMP_DIR/iptv_api
egp_url='https://gitee.com/styUnv/tv/raw/master/e.xml'
icon_prefix='cc/icon/'

mkdir $TMP_DIR


git clone https://github.com/fanmingming/live.git  $fanming_git
cp -r -f $fanming_git/tv ./icon


git clone https://github.com/Guovin/iptv-api.git  $iplist_git
git -C $iplist_git checkout gd


escape_sed() {
    echo "$1" | sed 's/[\/&]/\\&/g'
}
escaped_icon_prefix=$(escape_sed "$icon_prefix")


input_file=$iplist_git/output/result.m3u
output_file="live.m3u"
sed -i.bak "s#x-tvg-url=\"[^\"]*\"#x-tvg-url=\"$egp_url\"#" "$input_file"
sed -i.bak "s#https://raw.githubusercontent.com/fanmingming/live/main/tv/#$escaped_icon_prefix#g" "$input_file"


cp "$input_file" "$output_file"
rm $TMP_DIR
