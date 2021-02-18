#!/bin/sh

read -p "输入需要发布的pod目录：" projectPath

# we need to extract the ssh/git URL as the runner uses a tokenized URL
export CI_PUSH_REPO=`echo $CI_REPOSITORY_URL | perl -pe 's#.*@(.+?(\:\d+)?)/#git@\1:#'`
 
echo $CI_PUSH_REPO
# runner runs on a detached HEAD, create a temporary local branch for editing
#git checkout -b ci_processing
#git config --global user.name "My Runner"
#git config --global user.email "runner@gitlab.example.org"
#git remote set-url --push origin "${CI_PUSH_REPO}"

if [[ $projectPath == "" ]]; then
	projectPath=$(cd `dirname $0`;pwd)
fi
project_name=${projectPath##*/}
cd $projectPath
podspec="$(ls *.podspec)"
VersionString=`grep -E 's.version.*=' $podspec|cut -d "\"" -f2|cut -d "\"" -f1|cut -d "'" -f2|cut -d "'" -f1`

echo "===========projectPath:$projectPath==========="
echo "===========project_name:$project_name==========="
echo "===========podspec:$podspec==========="
echo "===========VersionString:$VersionString==========="
echo "===========打tag $VersionString==========="

#git fetch
#git checkout master
#git pull origin master
#echo "===========git 重置master==========="
#git reset --hard origin/master
echo "===========git 删除tag${VersionString}==========="
git tag -d ${VersionString}
echo "===========git push删除tag${VersionString}==========="
git push origin :refs/tags/${VersionString}
echo "===========打tag $VersionString==========="
git tag ${VersionString}
echo "===========git push==========="
git push origin ${VersionString}

#发布
echo "===========push到源码库==========="
pod repo push CYTCocoaPodsSpecs $podspec --allow-warnings --use-libraries --verbose --sources=https://github.com/CocoaPods/Specs.git,http://git.drcuiyutao.com/iOS/CYTCocoaPodsSpecs.git,https://github.com/aliyun/aliyun-specs.git
echo "===========push到源码库完成==========="

#二进制
echo "准备二进制"
pod package $podspec --force --no-mangle --exclude-deps --spec-sources=http://git.drcuiyutao.com/iOS/CYTCocoaPodsSpecs.git,https://github.com/CocoaPods/Specs.git,https://github.com/aliyun/aliyun-specs.git --verbose
echo "===========二进制完成==========="

read -p "等待修改podspec：" num

binaryDir=$(find  $projectPath  -name  $project_name"-*" -type d)
echo "===========二进制文件夹目录：$binaryDir==========="

cd $binaryDir
pwd

newpodspec="$(ls *.podspec)"

#查找source
source=$(sed -n '/s.source/p' $newpodspec)

#替换source

newSource='  s.source = { :http => "http:\/\/pkg.drcuiyutao.com\/Apps\/CYTCocoaPods-Binary\/'$project_name'\/'$VersionString'\/'$project_name'.zip" }'
sed -i '' "s/${source}/$newSource/g" $newpodspec
sed -i '' "s/ios\//$project_name\//g" $newpodspec

#目录下的ios重命名为项目名
mv ios $project_name
#zip压缩
zipName="$project_name.zip"
zip --symlinks -r $zipName $project_name
echo "===========压缩完成==========="
echo "===========当前目录$(cd `dirname $0`;pwd)==========="
echo "===========上传至共享==========="
mountDir="smb"
if [ ! -d $mountDir ]; then
    mkdir -p $mountDir
fi
mount -t smbfs //hudi:hdDrcui5456@192.168.0.251/share/iOS/Apps/CYTCocoaPods-Binary $mountDir
VERSIONDIR="${mountDir}/${project_name}/${VersionString}"
if [ ! -d ${VERSIONDIR} ]; then
    mkdir -p ${VERSIONDIR}
fi
cp -rv $zipName ${VERSIONDIR}
umount $mountDir
echo "===========上传共享完成==========="

echo "===========push到二进制库==========="
#push
pod repo push CYTCocoaPods-BinarySpec $newpodspec --allow-warnings --use-libraries --verbose
echo "===========push到二进制库完成==========="

pwd
#删除二进制文件夹
echo "===========删除二进制文件夹==========="
cd ..
rm -rf $binaryDir


exit 0
