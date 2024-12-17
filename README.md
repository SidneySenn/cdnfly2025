<p>简易安装教程<br />
主控版本：5.2.1<br />
被控版本：5.1.18<br />
请支持正版 本站仅用于学习研究 不可用于商用以及违法用途<br />
现在只需要运行脚本就可以安装!!!<br />
可以直接输入命令进行安装<br />
CentOS7更换镜像源<br />
一键换源：<br />
<pre><code class="hljs">bash <(curl -sSL https://gitee.com/SuperManito/LinuxMirrors/raw/main/ChangeMirrors.sh)</code></pre>
<p>手动换源：<br />
1、先安装wget<br />
<pre><code class="hljs">yum install -y wget</code></pre>

<p>2、下载CentOS 7的对应的repo文件<br />
<pre><code class="hljs">wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo</code></pre>
#或者<br />
<pre><code class="hljs">curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo</code></pre>

<p>3、更新镜像源<br />
<pre><code class="hljs">yum clean all</code></pre>
<pre><code class="hljs">yum makecache</code></pre>
<pre><code class="hljs">yum -y update</code></pre>

<p>执行完上面三行命令就好了</p>

<p>安装cdnfly控制面板<br />
<pre><code class="hljs">curl -fsSL https://www.cdnfly2025.top/httpcdnfly/master.sh -o master.sh && chmod +x master.sh && ./master.sh --es-dir /home/es</code></pre>

<p>主控和被控均不能在 已安装nginx的情况下 执行安装命令，必须确保80 443端口未被占用!!!<br />
主控只支持Cetnos7系列系统<br />
被控只支持Cetnos7系列和ubnutu16.04系统<br />
主控需开放80 88 443 9200端口<br />
节点需要开放 80 443 5000端口<br />
初始化管理员账号：admin<br />
初始化管理员密码：cdnfly</p>

<p>其他操作<br />
节点迁移至新主控 需要将旧节点的旧主控IP替换为新主控的IP<br />
#依次在ssh登录每个节点并执行下面命令即可<br />
#将 your_new_ip 替换为你自己的新主控IP</p>
<pre><code class="hljs">wget -qO change_ip.sh https://www.cdnfly2025.top/cdnfly2025/change_ip.sh && chmod +x change_ip.sh && bash change_ip.sh your_new_ip</code></pre>

<p>或选择手动操作<br />
<pre><code class="hljs">new_master_ip="这里替换为主控IP"<br />
sed -i "s/ES_IP =.*/ES_IP = "$new_master_ip"/" /opt/cdnfly/agent/conf/config.py<br />
sed -i "s/MASTER_IP.*/MASTER_IP = "$new_master_ip"/g" /opt/cdnfly/agent/conf/config.py<br />
sed -i "s/hosts:.*/hosts: ["$new_master_ip:9200"]/" /opt/cdnfly/agent/conf/filebeat.yml<br />
sed -i "s#http://.*:88#http://$new_master_ip:88#" /usr/local/openresty/nginx/conf/listen_80.conf /usr/local/openresty/nginx/conf/listen_other.conf<br />
ps aux | grep [/]usr/local/openresty/nginx/sbin/nginx | awk '{print $2}' | xargs kill -HUP || true<br />
supervisorctl -c /opt/cdnfly/agent/conf/supervisord.conf restart filebeat<br />
supervisorctl -c /opt/cdnfly/agent/conf/supervisord.conf restart agent<br />
supervisorctl -c /opt/cdnfly/agent/conf/supervisord.conf restart task</code></pre>

<p>重启进程<br />
<p>主控重启<br />
<pre><code class="hljs">supervisorctl -c /opt/cdnfly/master/conf/supervisord.conf restart all</code></pre>
<p>节点重启<br />
<pre><code class="hljs">supervisorctl -c /opt/cdnfly/master/conf/supervisord.conf restart all</code></pre>
supervisorctl -c /opt/cdnfly/agent/conf/supervisord.conf restart all

<p>Cdnfly监控设置<br />
尊敬的cdnfly用户:<br />
为防止重启节点，Nginx服务启动不起来，可以在节点Tcp监控设置里面把主IP的监控端口设置为5000<br />
节点管理-点击tcp-更多HTTP设置-端口：5000

<p>官方最新公告<br />
尊敬的cdnfly用户:<br />
目前发现登录安全漏洞，需要及时按照如下方法来临时修复。找一个只有你知道的域名,这个域名用于管理员登录。<br />
路径为:系统管理--->系统设置--->用户相关，限制管理员只能从此域名登录</p>

