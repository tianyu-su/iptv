#!/bin/bash
egp_url='https://gitee.com/styUnv/tv/raw/gd/e.xml'
icon_prefix='https://gitee.com/styUnv/tv/raw/gd/icon/'
save_threshold=50


TMP_DIR='/tmp/tv_tmp'
fanming_git=$TMP_DIR/fanming_live
iplist_git=$TMP_DIR/iptv_api
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


count=$(grep -o "tvg-name" "$output_file" | wc -l)
count=$(echo $count | tr -d ' ')

if [ $count -gt $save_threshold ]; then
    echo "最新频道个数为 $count，大于阈值 $save_threshold"
    if ! git diff --staged --quiet; then
        echo "开始执行 git push 操作"
        git add -A
        git commit -a -m "update live source"
        git push --force
    fi
else
    echo "最新频道个数为 $count，未超过阈值 $save_threshold，不执行 git push 操作。"
fi

rm $TMP_DIR
