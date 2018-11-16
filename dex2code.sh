#!/bin/sh

# 脚本所在目录
SHELL_DIR=$(cd "$(dirname "$0")";pwd)

# 定义将jar包反编译的函数
decompileDex(){
   echo "----"$1
   # dex路径
   dexPath=$1
   # dex完整文件名
   dexName=${dexPath##*/}
   # dex不带后缀的文件名
   dexNameWithoutSuffix=${dexName%.*}
   # dex目录
   dexDir=${dexPath%/*}
   #-------------dex2jar过程---------------------------------------
   # 切换到dex所在目录的路径，因为下一步的d2j-ex2jar.sh脚本会默认在dex所在的目录里生成包含反编译后代码的jar包
   cd $dexDir

   # 用d2j进行dex2jar操作
   sh $SHELL_DIR/dex-tools/d2j-dex2jar.sh $dexPath --force

   # dex2jar后jar包路径
   dex2JarOutputJarPath=$dexDir"/"$dexNameWithoutSuffix"-dex2jar.jar"
   echo "===="$dex2JarOutputJarPath
   #--------------jar2code过程-------------------------------------
   # 反编译后代码的输出目录
   outputCodeDir=$dexDir"/"$dexNameWithoutSuffix"_CODE"
   # 如果反编译后代码的输出目录已存在，删除
   if [ -d $outputCodeDir ]; then
      rm -r $outputCodeDir
   fi

   # 创建代码输出目录
   mkdir $outputCodeDir

   # 用fernflower decompiler进行jar2code操作
   java -jar $SHELL_DIR/fernflower.jar $dex2JarOutputJarPath $outputCodeDir

   # 包含反编译后代码的jar包的路径
   outputCodeJarPath=$outputCodeDir"/"$dexNameWithoutSuffix"-dex2jar.jar"
   # 解压反编译后代码所在的jar包
   unzip $outputCodeJarPath -d $outputCodeDir

   # 删除前面的两个jar包
   rm -r $dex2JarOutputJarPath
   rm -r $outputCodeJarPath

   # 成功结束
   echo "---------------done decompiling this dex---------------"
}

if [ $# -eq 1 ]
then
   echo $1
   dexPath=$1
   decompileDex $dexPath
else
   echo "参数个数必须是1个，且是要反编译的dex文件路径"
   exit 1
fi
