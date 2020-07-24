#!/bin/bash
# 目标关键字
key=$1
# 文件内容
fileName=$2
# 判断包含方法
contain(){
strA=$1
strB=$2
result=0
if [[ "$strA" =~ "$strB" ]]
# 包含
then return 0
fi
return 1
}

#adb shell uiautomator dump /sdcard/ui.xml
#adb pull /sdcard/ui.xml

#xmlFile=$(<ui.xml)
xmlFile=$(<$fileName)
## 结果 0-存在 1-不存在
checkResult=1
##遍历 每一行
for line in $xmlFile
    do
        contain $line $key
        if [ $? == 0 ]
        then checkResult=0;
        fi
done
#if [ $checkResult == 1 ]
#then $checkResult
#else $checkResult
#fi
exit $checkResult
