#!/bin/sh

# 发布
function push(){
	# public pod  
	# trunk之前需要提前register  pod trunk register orta@cocoapods.org 'Orta Therox' --description='macbook air'
	# pod trunk push $podspec --allow-warnings --use-libraries --verbose

	# private pod
	# pod repo push “yourRepoName” $podspec --allow-warnings --use-libraries --verbose
}

# 获取当前脚本所在目录
cd $(dirname "$0")

podspec="$(ls *.podspec)"

VersionString=`grep -E 's.version.*=' $podspec|cut -d "\"" -f2|cut -d "\"" -f1|cut -d "'" -f2|cut -d "'" -f1`
echo $VersionString

read -p "提交（1）or 发布（2）：" num
if [[ $num == 1 ]]; then
    git add .
    git commit -m $VersionString

    git tag ${VersionString}
    git push origin master --tags
	read -p "是否发布pod（Y/N）：" push
	if [[ $push == 'Y' || $push == 'y' ]]; then
		push
	fi
else
	push
fi


