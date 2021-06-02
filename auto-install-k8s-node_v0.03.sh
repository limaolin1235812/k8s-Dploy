#!/bin/bash
# 2021年6月1日15:09:09
# auto install k8s version 1.20.4
# Email 2911811686@qq.com
# by author limaolin
#####################################
if ! rpm -q ipvsadm >/dev/unll;then
	IPV1="192.168.1.130"
	IPV2="192.168.1.131"
	IPV3="192.168.1.132"
	#k8s环境配置HOST解析
	echo >/etc/hosts
	cat >>/etc/hosts<<-EOF
	127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
	::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
	${IPV1} k8s-mast  node1
	${IPV2} k8s-node1 node2
	${IPV3} k8s-node2 node3
	EOF
	#关闭swapoff；交换内存空间
	swapoff -a
	sed -i 's/.*swap.*/#&/' /etc/fstab

	#安装ipset、ipvsadm
	yum install -y ipset ipvsadm
	#Linux内核参数设置&优化
	cat >>/etc/modules-load.d/ipvs.conf <<-EOF
	# Load IPVS at boot
	ip_vs
	ip_vs_rr
	ip_vs_wrr
	ip_vs_sh
	nf_conntrack_ipv4
	EOF
	systemctl enable --now systemd-modules-load.service
	#确认内核模块加载成功
	lsmod | grep -e ip_vs -e nf_conntrack_ipv4
	#配置内核参数;
	cat <<-EOF >>  /etc/sysctl.d/k8s.conf
	net.bridge.bridge-nf-call-ip6tables = 1
	net.bridge.bridge-nf-call-iptables = 1
	EOF
	sysctl --system
else
	echo Successfuly ipvsadm
fi

if ! rpm -q  docker-ce >/dev/unll;then
	# 安装依赖软件包
	yum install -y yum-utils device-mapper-persistent-data lvm2
	# 添加Docker repository，这里使用国内阿里云yum源
	yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
	# 安装docker-ce，这里直接安装最新版本
	yum install -y docker-ce
	#修改docker配置文件
	mkdir -pv /etc/docker
	cat > /etc/docker/daemon.json <<-EOF
	{
	  "exec-opts": ["native.cgroupdriver=systemd"],
	  "log-driver": "json-file",
	  "log-opts": {
	    "max-size": "100m"
	  },
	  "storage-driver": "overlay2",
	  "storage-opts": [
	    "overlay2.override_kernel_check=true"
	  ],
	  "registry-mirrors": ["https://uyah70su.mirror.aliyuncs.com"]
	}
	EOF
	# 注意，由于国内拉取镜像较慢，配置文件最后增加了registry-mirrors
	mkdir -p /etc/systemd/system/docker.service.d
	# 重启docker服务
	systemctl daemon-reload
	systemctl enable docker.service
	systemctl start docker.service
	ps -aux |grep docker
else
	echo Successfuly docker
fi

if ! rpm -q kubeadm-1.20.4 >/dev/unll;then
	#mast 和node节点同时添加yum源
	#Kubernetes Master节点上安装Docker、Etcd和Kubernetes、Flannel网络，添加kubernetes源指令如下
	cat>>/etc/yum.repos.d/kubernetes.repo<<-EOF
	[kubernetes]
	name=Kubernetes
	baseurl=https://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64
	enabled=1
	gpgcheck=0
	repo_gpgcheck=0
	gpgkey=https://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg
	EOF
	#安装Kubeadm；
	yum install -y kubeadm-1.20.4 kubelet-1.20.4 kubectl-1.20.4
	#启动kubelet服务
	#systemctl enable kubelet.service
	#systemctl start kubelet.service
else
	echo Successfuly  kubeadm-1.20.4
fi
