#!/bin/sh

decompileApk(){
    # apk包路径
    apkPath=$1
    # apk包完整文件名
    apkName=${apkPath##*/}
    # apk包不带后缀的文件名
    apkNameWithoutSuffix=${apkName%.*}
    # jar包所在目录
    apkDir=${apkPath%/*}

    # apktool的结果输出目录
    apkToolOutputDir=$apkDir"/"$apkNameWithoutSuffix"_FORRES"
    # 试着删除apktool的结果输出目录，再重新建立
    if [ -d $apkToolOutputDir ]; then
        rm -r $apkToolOutputDir
    fi
    # 运行apktool
    sudo apktool d $1 -o $apkToolOutputDir -f
    # 授予apktool的结果输出目录以读写权限
    sudo chmod -R a+rw $apkToolOutputDir

    # 解压原apk
    # 解压到的目录
    apkUnzipOutputDir=$apkDir"/"$apkNameWithoutSuffix"_decompiled"
    # 解压到的目录先试着删除，再重新建立
    rm -r $apkUnzipOutputDir
    mkdir $apkUnzipOutputDir
    # 解压
    unzip $apkPath -d $apkUnzipOutputDir
    # 将apktool结果输出目录里的androidManifest.xml和res目录拷贝到apk解压到的目录
    cp $apkToolOutputDir"/AndroidManifest.xml" $apkUnzipOutputDir
    cp -r $apkToolOutputDir"/res" $apkUnzipOutputDir
    # 删除apktool的结果输出目录
    rm -r $apkToolOutputDir
    # 反编译apk解压到的目录中的dex，考虑多个dex的情况，用find和awk处理
    find $apkUnzipOutputDir -name "classes*.dex"|awk '{cmd="dex2code "$1;system(cmd);}'
}

if [ $# -eq 1 ]
then
    decompileApk $1
else
    echo "参数必须是1个，是要反编译的apk路径"
    exit 1
fi
