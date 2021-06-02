#!/bin/bash
# auto admin k8s mast
# 2021年6月2日10:49:29
# Email 2911811686@qq.com
#################################

function token_node(){
export KUBECONFIG=/etc/kubernetes/admin.conf
#通过执行这个指令获得添加集群的配置信息
echo 获得信息 ，在node节点上执行
echo 
kubeadm token create --print-join-command
}

function token_mast(){
export KUBECONFIG=/etc/kubernetes/admin.conf
#查看Token的详细信息
UI=`cat /etc/hosts|grep node1|awk 'NR<2{print $3}'`
IP=`ssh ${UI} ifconfig eth0 |grep netmask|awk '{print $2}'`
ECU=`kubectl get svc -n kubernetes-dashboard |grep NodePort|awk  '{print $5}'|awk -F: '{print $2}'|sed 's/TCP//g;s@/@@g'`
#获取刚刚创建的用户对应的Token名称；
kubectl get secrets -n kube-system | grep dashboard
echo 查看Token的详细信息 输入下的web,Token ;
echo 
kubectl describe secrets -n kube-system $(kubectl get secrets -n kube-system | grep dashboard |awk '{print $1}')
echo
echo 通过浏览器访问Dashboard WEB，https://$IP:$ECU/ ，输入Token登录即可
}

clear

echo -e   "\033[35m
			Welcome to use the Shell script written by Li Maolin
					The menu is as follows
			
				1  获得新集群node配置信息
				2  获取web Server https Token 登记信息 \033[0m"

read -p "Please enter the service menu: " service
case $service in
	(1)
 	token_node       
        ;;
	(2)
	token_mast
	;;
        (*)
        echo -e  "\033[33mUsage:{/bin/bash $0 1|2|3|4|help}\033[0m"
        exit 0
esac
