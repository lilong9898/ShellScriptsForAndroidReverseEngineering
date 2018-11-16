## useful shell scripts for Android reverse engineering
### jar2code 
Decompile jar to java code (using fernflower decompiler)
```shell
   ./jar2code.sh $JAR_PATH
```
### dex2code  
Decompile dex to java code (using d2j-jar2dex & fernflower decompiler)
```shell
   ./dex2code.sh $DEX_PATH
```
### apk2code
Decompile apk's content to a folder:
- dex is decompiled to java code
- androidManifest & res folder's content xmls are decompiled to src form
```shell
   ./apk2code.sh $APK_PATH
```
