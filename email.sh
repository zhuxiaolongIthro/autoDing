#!/bin/bash

#参数 1 收件人
#参数 2 题目
#参数 3 附件文件路径

#手动输入 邮件内容
receiver=$1
#todo 检查收件人格式
title=$2
#内容 其他脚本执行的结果日志 通过文件的形式写入到邮件中
textContent=$3

#sh msmtp -f # 读取结构中的发件邮箱
#msmtp -t # 读取结构中的收件邮箱
#fileContent<$filePath
mailData="to:$1\n"\
"subject:$2\n"\
"\n$textContent\n"
source ~/.bash_profile
echo $mailData |msmtp -t







