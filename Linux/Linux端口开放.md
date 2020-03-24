# CentOS 6.x开放端口

## 1、指定端口开放

```shell
[root@localhost ~]# vim /etc/sysconfig/iptables
-A INPUT -m state --state NEW -m tcp -p tcp --dport 22 -j ACCEPT
# 开放8080端口
-A INPUT -m state --state NEW -m tcp -p tcp --dport 8080 -j ACCEPT
[root@localhost ~]# service iptables restart
```

## 2、指定端口段开放

```shell
[root@localhost ~]# vim /etc/sysconfig/iptables
[root@localhost ~]# vim /etc/sysconfig/iptables
-A INPUT -m state --state NEW -m tcp -p tcp --dport 22 -j ACCEPT
# 从8080到9000端口全放行
-A INPUT -m state --state NEW -m tcp -p tcp --dport 8080:9000 -j ACCEPT
[root@localhost ~]# service iptables restart
```

## 3、全放行

```shell
[root@localhost ~]# service iptables stop
```

## 4、iptables命令

```shell
# 修改过iptables文件都需要执行下列命名刷新
# 启动
[root@localhost ~]# service iptables start
# 关闭(开放所有端口对外访问)
[root@localhost ~]# service iptables stop
# 重启
[root@localhost ~]# service iptables restart
```



# CentOS 7.x开放端口

## 1、指定端口开放

```shell
# 开放8080端口
[root@localhost ~]# firewall-cmd --zone=public --add-port=8080/tcp --permanent
[root@localhost ~]# firewall-cmd --reload
```

## 2、指定端口段开放

```shell
# 从8080到9000端口全放行
[root@localhost ~]# firewall-cmd --permanent --zone=public --add-port=8080-9000/tcp
[root@localhost ~]# firewall-cmd --reload
```

## 3、全放行

```shell
[root@localhost ~]# systemctl stop firewalld
```

## 4、firewall命令

```shell
# 重启
[root@localhost ~]# systemctl restart firewalld.service
# 禁止开机启动
[root@localhost ~]# systemctl disable firewalld.service 
# 启动
[root@localhost ~]# systemctl start firewalld
# 查看状态
[root@localhost ~]# systemctl status firewalld 
[root@localhost ~]# firewall-cmd --state
# 开机是否启动
[root@localhost ~]# systemctl disable
[root@localhost ~]# enable firewalld
# 禁用
[root@localhost ~]# systemctl stop firewalld
# 更新防火墙规则，以下两个命令区别：第一个无需断开连接，就是firewalld特性之一动态添加规则，第二个需要断开连接，类似重启服务
[root@localhost ~]# firewall-cmd --reload
[root@localhost ~]# firewall-cmd --complete-reload
# 查看所有打开的端口
[root@localhost ~]# firewall-cmd --zone=dmz --list-ports
```





