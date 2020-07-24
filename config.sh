#!/bin/bash
# 配置文件主程序
# 主要负责 config 文件的解析与写入 
# 提供比较方法来与 config 文件中的时间配置进行对比
#
#
# key value 
# checkInStartTime=9:00:00
# checkInEndTime=10:00:00
# checkOutStartTime=19:00:00
# checkOutStartTime=21:00:00
# 

configPath=~/Desktop/androidToolShell/shs
fileName=config.txt
logFile=config.log

inStartTime=09:00:00
outStartTime=19:00:00
inEndTime=10:00:00
outEndTime=21:00:00
#读取配置到内存
readConfigToM(){
    while read line 
    do 
        #将 key value 分离
        key=${line%=*}
        value=${line#*=}

        case $key in
        "checkInStartTime") inStartTime=$value
        ;;
        "checkInEndTime") inEndTime=$value
        ;;
        "checkOutStartTime") outStartTime=$value
        ;;
        "checkOutEndTime") outEndTime=$value
        ;;
        esac
    done <$configPath/$fileName
    echo "上班打卡时间 $inStartTime ~ $inEndTime"
    echo "下班打卡时间 $outStartTime ~ $outEndTime"
}

updateConfig(){
    # cd $configPath
    branchName=$(sh $configPath/gitHelp.sh getBranchName)
    echo $branchName
}
#是否是工作日
isWeekDay(){
    week=$(date +'%w')
#    echo weekDay $week
    if [ $week -le 6 ]&&[ $week -ge 1 ]
    then return 0;
    else return 1;
    fi
}

isCheckInTime(){
    curTime=$(date +"%s")
    if [[ $curTime -le $(date -j -f "%H:%M:%S" $inStartTime +"%s") ]]
    then return 1;
    fi
    if [[ $curTime -ge $(date -j -f "%H:%M:%S" $inEndTime +"%s") ]]
    then return 1;
    fi
    return 0;
}

isCheckOutTime(){
    curTime=$(date +"%s")
    if [[ $curTime -le $(date -j -f "%H:%M:%S" $outStartTime +"%s") ]]
    then return 1;
    fi
    if [[ $curTime -ge $(date -j -f "%H:%M:%S" $outEndTime +"%s") ]]
    then return 1;
    fi
    return 0;
}

# $1 配置文件路径
# $2 调用的方法



case $1 in 
    #调用更新方法
    "update")
    updateConfig
    ;;
    "isAmTime")
        readConfigToM
        isWeekDay
        r0=$?
        if [ $r0 -eq 1 ]
        then exit 1;
        fi
        isCheckInTime
        r=$?
        exit $r
    ;;
    "isPmTime")
        readConfigToM
        isWeekDay
        r0=$?
        if [ $r0 -eq 1 ]
        then exit 1;
        fi
        isCheckOutTime
        r=$?
        exit $r
    ;;
esac

exit 0;
