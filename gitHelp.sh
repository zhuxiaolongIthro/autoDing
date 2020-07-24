#!/bin/bash
# 负责进行 git 操作的脚本
# 获取当前所在分支名称
# 获取所有分支列表
# 获取当前分支 code
# 

curBranch=''
getCurrentBranchName(){
    curBranch=$(git symbolic-ref --short HEAD)
    # echo $curBranch
}

pullBranch(){
    git pull origin $1:curBranch
    if [ $? -eq 1 ]
    then  echo "拉取失败"; exit 1;
    fi
    return 0;
}
pushBranch(){
    git push origin $1:curBranch
    if [ $? -eq 1 ]
    then echo "push失败"; exit 1;
    fi
    return 0;
}

case $1 in
 "getBranchName")
    getCurrentBranchName
 ;;
 "pull")
    if [ -n $2 ]
    then pullBranch $2
    else getCurrentBranchName;pullBranch curBranch 
    fi
    
 ;;
 "push")
    if [ -n $2 ]
    then pushBranch $2
    else getCurrentBranchName;pushBranch curBranch 
    fi
 ;;
 esac