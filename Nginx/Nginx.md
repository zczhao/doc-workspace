# Linux Centos6.x安装nginx

## 1、下载压缩包并nginx-1.17.3.tar.gz解压

```shell
[root@localhost ~]# tar -zxvf nginx-1.17.3.tar.gz -C /usr/local/
```

## 2、安装nginx所需依赖

```shell
[root@localhost ~]# yum -y install gcc zlib zlib-devel pcre-devel openssl openssl-devel
```

## 3、 进入解压目录

```shell
[root@localhost ~]# cd /usr/local/nginx-1.17.3/
[root@localhost nginx-1.17.3]# ./configure
```

## 4、编译

```shell
[root@localhost nginx-1.17.3]# make
```

## 5、编译

```shell
[root@localhost nginx-1.17.3]# make install
```

## 6、启动nginx

```shell
[root@localhost nginx-1.17.3]# whereis nginx
nginx: /usr/local/nginx
[root@localhost nginx-1.17.3]# cd /usr/local/nginx/sbin
# 启动
[root@localhost sbin]# ./nginx
# 重启
[root@localhost sbin]# ./nginx -s reload
```

## 7、防火墙开放80端口，在浏览器能过IP地址验证是否能打开nginx页面

```shell
# 查看80端口是否启动
[root@localhost ~]# netstat -nultp | grep :80
tcp        0      0 0.0.0.0:80                  0.0.0.0:*                   LISTEN      44844/nginx
[root@localhost ~]# vim /etc/sysconfig/iptables
```

