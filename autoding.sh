#!/bin/bash

#0 先检查是否在时间内 参数1 是否强制执行
curData=$(date +"%Y-%m-%d")


writeLog(){
    echo $(date +"%H:%M:%S") $1 >> $path/log/"$curData".log
}

tap(){
    adb shell input tap $1 $2
}
close(){
    adb shell am force-stop com.alibaba.android.rimet
}


source ~/.bash_profile
path=~/Desktop/androidToolShell/shs
#1、首先确认 dd 关闭
#执行adb命令进行强制关闭
close
#echo "关闭app" $?
#
#2、打卡dd
adb shell monkey -p com.alibaba.android.rimet 1 --pct-touch
#echo "打开app " $?
sleep 5s
echo "-------------------------"
#权限
chmod 777 $path/checkElement.sh
chmod 777 $path/dumpXml.sh
# 获取界面元素
##确认进入主页 是否进入首页 检查是否包含工作台 字样
#sh $path/dumpXml.sh home
#sleep 2s
#sh $path/checkElement.sh 工作台 $path/home.xml
#if [ $? == 0 ]
#then writeLog "已经进入首页" $'date'
#else writeLog "不是首页 关闭app 跳转至程序开头" exit 1
#fi
#
##3、查找元素位置  todo
#4、点击控制台
#echo "点击工作台"
tap 520 2250
#加个延迟 等待 界面加载
sleep 5s
#确认进入控制台页面
#sh $path/dumpXml.sh ui1
#sleep 2s
#sh $path/checkElement.sh 考勤打卡 $path/ui1.xml
#if [ $? == 0 ]
#then writeLog "已经进入工作台"
#else writeLog "不是工作台 关闭app 跳转至程序开头"
#    sh $path/checkElement.sh 考勤 $path/ui1.xml
#    if ! [ $? == 0 ] #再尝试一次
#    then exit 1;
#    fi
#fi
#5、获取考勤打卡图标位置
#6、执行点击操作
#7、确认进入考勤界面
#echo "点击上班考勤入口图标"
tap 900 1100
sleep 5s
#检查是否进入到考勤页
#8、获取上班/下班 打卡位置
sh $path/dumpXml.sh ui2
#上班考勤状态
#9、执行点击操作
sleep 2s
sh $path/checkElement.sh 上班打卡 $path/ui2.xml
if [ $? == 0 ]
then writeLog "已经进入考勤界面 上班考勤"
#    tap 500 600
fi
#上班考勤圆圈
##下班考勤状态
sh $path/checkElement.sh 下班打卡 $path/ui2.xml
#logTime
if [ $? == 0 ]
then writeLog "已经进入考勤界面 下班考勤"
    tap 500 1100
fi
##下班考勤圆圈
checkConfirm(){
    sleep 8
    sh $path/dumpXml.sh dialog
    sleep 2s
    sh $path/checkElement.sh 确定 $path/dialog.xml
    if [ $? == 0 ]
    then writeLog "点击对话框确认"
    tap 750 1250
    fi
}
##更新下班考勤状态
sh $path/checkElement.sh 更新打卡 $path/ui2.xml
#logTime
if [ $? == 0 ]
then writeLog "已经进入考勤界面 更新下班考勤"
    tap 150 1150
    # 检查 确认弹框
    checkConfirm
else exit 1;
fi
#更新下班考勤

sleep 4s
sh $path/dumpXml.sh result
close
sleep 2s
sh $path/checkElement.sh 成功 $path/result.xml

if [ $? == 0 ]
then exit 0;
else exit 1;
fi

