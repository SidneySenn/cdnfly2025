简易安装教程
请支持正版 本站仅用于学习研究 不可用于商用以及违法用途

现在只需要运行脚本就可以安装!!!

可以直接输入命令进行安装

CentOS7更换镜像源

一键换源：

bash <(curl -sSL https://gitee.com/SuperManito/LinuxMirrors/raw/main/ChangeMirrors.sh)

手动换源：

1、先安装wget

yum install -y wget

2、下载CentOS 7的对应的repo文件

wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo

#或者

curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo

3、更新镜像源

yum clean all

yum makecache

yum -y update

执行完上面三行命令就好了

安装cdnfly控制面板

curl -fsSL https://www.cdnfly2025.top/httpcdnfly/master.sh -o master.sh && chmod +x master.sh && ./master.sh --es-dir /home/es

主控和被控均不能在 已安装nginx的情况下 执行安装命令，必须确保80 443端口未被占用!!!

系统必须为centos7系列或ubuntu16.04 !!! debian11 ubuntu20 centos8 centos6等系统都不支持

主控需开放80 88 443 9200端口

节点需要开放 80 443 5000端口

初始化管理员账号：admin

初始化管理员密码：cdnfly

其他操作

节点迁移至新主控
需要将旧节点的旧主控IP替换为新主控的IP

#依次在ssh登录每个节点并执行下面命令即可

#将 your_new_ip 替换为你自己的新主控IP

wget -qO change_ip.sh https://www.cdnfly2025.top/cdnfly2025/change_ip.sh && chmod +x change_ip.sh && bash change_ip.sh your_new_ip

或选择手动操作

new_master_ip="这里替换为主控IP"

sed -i "s/ES_IP =.*/ES_IP = \"$new_master_ip\"/" /opt/cdnfly/agent/conf/config.py

sed -i "s/MASTER_IP.*/MASTER_IP = \"$new_master_ip\"/g" /opt/cdnfly/agent/conf/config.py

sed -i "s/hosts:.*/hosts: [\"$new_master_ip:9200\"]/" /opt/cdnfly/agent/conf/filebeat.yml

sed -i "s#http://.*:88#http://$new_master_ip:88#" /usr/local/openresty/nginx/conf/listen_80.conf /usr/local/openresty/nginx/conf/listen_other.conf

ps aux | grep [/]usr/local/openresty/nginx/sbin/nginx | awk '{print $2}' | xargs kill -HUP || true

supervisorctl -c /opt/cdnfly/agent/conf/supervisord.conf restart filebeat

supervisorctl -c /opt/cdnfly/agent/conf/supervisord.conf restart agent

supervisorctl -c /opt/cdnfly/agent/conf/supervisord.conf restart task
