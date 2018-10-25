#!/bin/sh

# 获取当前脚本所在目录
cd $(dirname "$0")

podspec="$(ls *.podspec)"

VersionString=`grep -E 's.version.*=' $podspec|cut -d "\"" -f2|cut -d "\"" -f1|cut -d "'" -f2|cut -d "'" -f1`
echo $VersionString

git add .
git commit -m $VersionString

git tag ${VersionString}
git push origin master --tags
#发布
pod repo push “yourRepoName” $podspec --allow-warnings --use-libraries --verbose
