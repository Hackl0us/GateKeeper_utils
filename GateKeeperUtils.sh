#!/bin/bash

#声明使用函数
function check_user (){
	if [ `whoami` != root ];then 
		echo "请输入当前用户密码："
		fi
	}
	
#未签名/未知签名App路径作为参数，解除GateKeeper对其限制
if [ $# -eq 1 ];then
	check_user;
	sudo xattr -rd com.apple.quarantine "$1"
	
cat << EOF
	**********************************
	正在尝试解锁GateKeeper对App的限制...
	**********************************
EOF
	
	echo "Done & Enjoy :)"
	exit 0
fi

#直接运行脚本，检测GateKeeper状态
#若关闭，则可根据提示开启。若开启，则可根据提示可关闭。

echo "正在检测GateKeeper状态..."
check_user;

status=`sudo spctl --status | awk -F " " '{print $2}'`
clear

if [ $status == "enabled" ];then
	echo -e "目前GateKeeper状态: \033[32m开启\033[0m"
	echo ""
	echo -e "是否\033[33m禁用? (y)\033[0m"
	read input
	
	if [ $input == "y" ];then
		sudo spctl --master-disable
		echo -e "\033[31mGateKeeper已关闭.\033[0m"
	else
		echo -e "\033[33m输入错误.\033[0m"
		exit 1
	fi
	
elif [ $status == "disabled" ];then
	echo -e "目前GateKeeper状态:\033[31m关闭\033[0m"
	echo ""
	echo -e "是否\033[33m启动? (y)\033[0m"
	
	read input
	if [ $input == "y" ];then
		sudo spctl --master-enable
		echo -e "\033[32mGateKeeper已开启.\033[0m"
	else
		echo -e "\033[33m输入错误.\033[0m"
		exit 1
	fi
else
	echo "Command ERROR!"
	exit 1
fi
exit 0