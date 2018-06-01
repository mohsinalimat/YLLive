#使用方法

if [ ! -d ./IPADir ];
then
mkdir -p IPADir;
fi

#工程绝对路径
project_path=$(cd `dirname $0`; pwd)

#工程名 将XXX替换成自己的工程名
project_name=YLLive

#scheme名 将XXX替换成自己的sheme名
scheme_name=YLLive

#打包模式 Debug/Release
development_mode=Debug

#build文件夹路径
build_path=${project_path}/build

#plist文件所在路径
exportOptionsPlistPath=${project_path}/exportTest.plist

#导出.ipa文件所在路径
exportIpaPath=${project_path}/IPADir/${development_mode}

number=2

if [ $number == 1 ];then
development_mode=Release
exportOptionsPlistPath=${project_path}/exportAppstore.plist
else
development_mode=Debug
exportOptionsPlistPath=${project_path}/exportTest.plist
fi


echo '///-----------'
echo '/// 正在清理工程'
echo '///-----------'
xcodebuild \
clean -configuration ${development_mode} -quiet  || exit


echo '///--------'
echo '/// 清理完成'
echo '///--------'
echo ''

echo '///-----------'
echo '/// 正在编译工程:'${development_mode}
echo '///-----------'
xcodebuild \
archive -workspace ${project_path}/${project_name}.xcworkspace \
-scheme ${scheme_name} \
-configuration ${development_mode} \
-archivePath ${build_path}/${project_name}.xcarchive  -quiet  || exit

echo '///--------'
echo '/// 编译完成'
echo '///--------'
echo ''

echo '///----------'
echo '/// 开始ipa打包'
echo '///----------'

xcodebuild -exportArchive -archivePath ${build_path}/${project_name}.xcarchive \
-configuration ${development_mode} \
-exportPath ${exportIpaPath} \
-exportOptionsPlist ${exportOptionsPlistPath} \
-quiet || exit

if [ -e $exportIpaPath/$scheme_name.ipa ]; then

echo '///----------'
echo '/// ipa包已导出'
echo '///----------'
open $exportIpaPath
else
echo '///-------------'
echo '/// ipa包导出失败 '
echo '///-------------'
fi
echo '///------------'
echo '/// 打包ipa完成  '
echo '///-----------='
echo ''

echo '///-------------'
echo '/// 开始发布ipa包 '
echo '///-------------'

if [ $number == 1 ];then

#验证并上传到App Store
# 将-u 后面的XXX替换成自己的AppleID的账号，-p后面的XXX替换成自己的密码
altoolPath="/Applications/Xcode.app/Contents/Applications/Application Loader.app/Contents/Frameworks/ITunesSoftwareService.framework/Versions/A/Support/altool"
"$altoolPath" --validate-app -f ${exportIpaPath}/${scheme_name}.ipa -u XXX -p XXX -t ios --output-format xml
"$altoolPath" --upload-app -f ${exportIpaPath}/${scheme_name}.ipa -u  XXX -p XXX -t ios --output-format xml
else

echo '///-----------'
echo '/// 开始上传到蒲公英'
echo '///-----------'

#上传到蒲公英
#蒲公英aipKey
MY_PGY_API_K=6c5c0b6656720dca52a99110ad1e224d
#蒲公英uKey
MY_PGY_UK=3d5a80ad1eb4eb7da8dc37caab6cd8d8

curl -F "file=@${exportIpaPath}/${scheme_name}.ipa" -F "uKey=${MY_PGY_UK}" -F "_api_key=${MY_PGY_API_K}" https://qiniu-storage.pgyer.com/apiv1/app/upload

echo '///-----------'
echo '/// 上传到蒲公英成功、请下载！'
echo '///-----------'

fi

exit 0


