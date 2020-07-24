#!/bin/bash
#  钉钉自动打卡主程序
# 1、负责更新 github 项目更新拉取 以及 执行结果的文件上传
# 2、负责读取 config 文件内容 、写入执行结果文件
# 3、负责检查执行环境 如：配置文件 拉取结果  当前时段内的上次执行结果
#
# 4、调用 config.sh 与 record.sh 
# 
# 
clear(){
    rm -rf $path/home.xml
    rm -rf $path/ui1.xml
    rm -rf $path/ui2.xml
    rm -rf $path/dialog.xml
    rm -rf $path/result.xml
}
#更新配置文件
#sh config.sh update
#检查是否是上班打卡时间段
path=/Users/wangfang/Desktop/androidToolShell/shs
today=$(date +"%Y-%m-%d")
chmod 777 $path/config.sh

sh $path/config.sh isAmTime
amTime=$?
if [ $amTime -eq 0 ]
then 
    #检查现有打卡记录 
    amRecord=$(sh $path/record.sh am)
    #如果是上班打卡时间打卡操作 runAdb
    if [ $amRecord -eq 0 ]
        then echo "有记录 $(date)" >> $path/log/$today.log; exit 0;
    else
        sh $path/autoding.sh
        if [ $? -eq 0 ]
        then
            echo "执行成功";
            sh $path/record.sh record am true
            sh $path/email.sh vvweilong@126.com "上班打卡成功"
            clear
        else
            echo "执行失败";
            sh $path/record.sh record am false
            sh $path/email.sh vvweilong@126.com "上班班打卡失败"
            clear
        fi
    fi
    

fi
#检查是否是下班打卡时间段
sh $path/config.sh isPmTime
pmTime=$?
if [ $pmTime -eq 0 ]
then 
    #检查现有打卡记录 
    sh $path/record.sh pm
    if [ $? -eq 0 ]
        then echo "有记录 $(date)" >> $path/log/$today.log; exit 0;
    else
        #如果是下班打卡时间打卡操作 runAdb
        sh $path/autoding.sh
        if [ $? -eq 0 ]
        then
            echo "执行成功";
            sh $path/record.sh record pm true;
#            sh $path/email.sh vvweilong@126.com "下班打卡成功"
            clear
        else
            echo "执行失败";
            sh $path/record.sh record pm false;
#            sh $path/email.sh vvweilong@126.com "下班打卡失败"
            clear
        fi
    fi
fi


exit 0;
