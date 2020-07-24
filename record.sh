#!/bin/bash

# 2020/7/16-am:true
# 2020/7/16-pm:true
# 2020/7/17-am:false
# 2020/7/17-pm:true
# 2020/7/18-am:true
# 2020/7/18-pm:true
 

recordPath=~/Desktop/androidToolShell/shs
fileName=record.txt

today=$(date +"%y/%m/%d")
#echo "today is " $today

writeRecord(){
    currentTime=$(date +"%Y/%m/%d")
    echo "$currentTime-$1":$2 >> $recordPath/$fileName
}

getTodayAmRecord(){
    while read line 
    do 
        key=${line%:*}
        value=${line#*:}
        # echo $key $value
        #判断日期是否是今天
        if ! [[ "$key" =~ "$today" ]]
        then continue;
        fi
        if ! [[ "$key" =~ "am" ]]
        then continue;
        fi
        if [ "$value" == 'true' ]
        then return 0;
        fi

        if [ "$value" == 'false' ]
        then return 1;
        fi
    done <$recordPath/$fileName

    return 1;
}

getTodayPmRecord(){
while read line
    do 
        key=${line%:*}
        value=${line#*:}
        #判断日期是否是今天
        if ! [[ "$key" =~ "$today" ]]
        then continue;
        fi
        if ! [[ "$key" =~ "pm" ]]
        then continue;
        fi
        if [ "$value" == 'true' ]
        then return 0;
        fi

        if [ "$value" == 'false' ]
        then return 1;
        fi
    done <$recordPath/$fileName

    return 1;
}

case $1 in
    "am")
        getTodayAmRecord
        exit $?
        ;;
    "pm")
        getTodayPmRecord
        exit $?
        ;;
    "record")
        writeRecord $2 $3
    ;;
    *)
        echo "错误" $1
    ;;
esac
exit 0;
