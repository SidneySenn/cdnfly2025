new_master_ip=$1
sed -i "s/ES_IP =.*/ES_IP = \"$new_master_ip\"/" /opt/cdnfly/agent/conf/config.py
sed -i "s/MASTER_IP.*/MASTER_IP = \"$new_master_ip\"/g" /opt/cdnfly/agent/conf/config.py
sed -i "s/hosts:.*/hosts: [\"$new_master_ip:9200\"]/" /opt/cdnfly/agent/conf/filebeat.yml
sed -i "s#http://.*:88#http://$new_master_ip:88#" /usr/local/openresty/nginx/conf/listen_80.conf /usr/local/openresty/nginx/conf/listen_other.conf 
ps aux | grep [/]usr/local/openresty/nginx/sbin/nginx | awk '{print $2}' | xargs kill -HUP ||  true
supervisorctl -c /opt/cdnfly/agent/conf/supervisord.conf restart filebeat
supervisorctl -c /opt/cdnfly/agent/conf/supervisord.conf restart agent
supervisorctl -c /opt/cdnfly/agent/conf/supervisord.conf restart task