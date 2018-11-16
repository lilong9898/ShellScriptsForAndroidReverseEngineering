#!/bin/sh

# 脚本所在目录
SHELL_DIR=$(cd "$(dirname "$0")";pwd)

# 定义将jar包反编译的函数
decompileJar(){
    # jar包路径
    jarPath=$1
    # jar包完整文件名
    jarName=${jarPath##*/}
    # jar包不带后缀的文件名
    jarNameWithoutSuffix=${jarName%.*}
    # jar包所在目录
    jarDir=${jarPath%/*}
    
    # 反编译后代码的输出目录
    outputCodeDir=$jarDir"/"$jarNameWithoutSuffix"CODE"
    # 反编译后代码所在的jar包路径
    outputCodeJarPath=$outputCodeDir"/"$jarNameWithoutSuffix".jar"

    # 如果反编译后代码的输出目录已存在，删除
    if [ -d $outputCodeDir ]; then
       rm -r $outputCodeDir
    fi

    # 创建代码输出目录
    mkdir $outputCodeDir

    # 用fernflower decompiler进行jar2code操作
    java -jar $SHELL_DIR"/fernflower.jar" $jarPath $outputCodeDir

    # 解压反编译后代码所在的jar包
    unzip $outputCodeJarPath -d $outputCodeDir

    # 删除前面的jar包
    rm $outputCodeJarPath
}

if [ $# -eq 1 ]
then
   echo $1
   jarPath=$1
   decompileJar $jarPath
else
   echo "参数个数必须是1个，且是要反编译的jar包路径"
   exit 1
fi


# 成功结束
echo "---------------done-----------------"
exit 0
