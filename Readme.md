.
├── [1.4K]  auto-admin-k8s-mast_v0.02.sh
├── [9.8K]  auto-Dashboard-deploy_v0.02.sh
├── [ 29K]  auto-install-k8s-mast_v0.03.sh
├── [2.9K]  auto-install-k8s-node_v0.03.sh
├── [ 232]  backup #历史脚本利用参考学习 
│   ├── [1.4K]  auto-admin-k8s-mast_v0.01.sh
│   ├── [9.2K]  auto-Dashboard-deploy_v0.01.sh
│   ├── [3.0K]  auto-install-k8s-mast_v0.01.sh
│   ├── [4.2K]  auto-install-k8s-mast_v0.02.sh
│   ├── [2.5K]  auto-install-k8s-node_v0.01.sh
│   └── [2.9K]  auto-install-k8s-node_v0.02.sh
├── [   0]  Readme.md 
└── [  73]  src 核心yaml配置文件
    ├── [ 40K]  calico.yaml
    ├── [4.7K]  kube-flannel.yml
    └── [7.5K]  recommended.yaml

#脚本执行顺序
# auto-install-k8s-mast_v0.03.sh 在mast节点上执行  1
# auto-install-k8s-node_v0.03.sh 在node节点上执行  2
# auto-Dashboard-deploy_v0.02.sh 在mast节点上执行  3
# auto-admin-k8s-mast_v0.02.sh   在mast节点上执行 ，这个是管理添加node集群和忘记Token认证密码查看Token的 

#注意 ！
#在执行脚本之前请删除 rm -rf src 或者备份 ，因为脚本中以今配置了*.yaml
#什么地方没有介绍到为的 请各位大佬 多多包涵
