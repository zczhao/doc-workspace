# Linux JDK安装配置

## 1、上传安装压缩包 jdk-8u231-linux-x64.tar.gz，并解至 /usr/local 目录

```shell
[root@localhost ~]# tar -zxvf jdk-8u231-linux-x64.tar.gz -C /usr/local
```

## 2、配置环境变量

```shell
[root@localhost ~]# vim /etc/profile
export JAVA_HOME=/usr/local/jdk1.8.0_231
export PATH=$JAVA_HOME/bin:$PATH
export CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
```

## 3、刷新环境变量

```shell
[root@localhost ~]# source /etc/profile
```

## 4、验证是否安装成功

```shell
[root@localhost ~]# java -version
java version "1.8.0_221"
Java(TM) SE Runtime Environment (build 1.8.0_221-b11)
Java HotSpot(TM) 64-Bit Server VM (build 25.221-b11, mixed mode)
```

# Linux Tomcat安装配置

## 1、上传安装压缩包apache-tomcat-8.0.53.tar.gz

## 2、解压压缩包并放到 /usr/local 目录

```shell
[root@localhost ~]# tar -zxvf apache-tomcat-8.0.53.tar.gz -C /usr/local/
```

## 3、配置环境变量

```shell
[root@localhost ~]# vim /etc/profile
export TOMCAT_HOME=/usr/local/apache-tomcat-8.0.53
export CATALINA_HOME=/usr/local/apache-tomcat-8.0.53
```

## 4、刷新环境变量

```shell
[root@localhost ~]# source /etc/profile
```

## 5、启动服务

```shell
[root@localhost ~]# cd /usr/local/apache-tomcat-8.0.53/bin
[root@localhost bin]# ./startup.sh && tailf ../logs/catalina.out
```

## 6、开放端口访问

```shell
[root@localhost ~]# vim /etc/sysconfig/iptables
-A INPUT -m state --state NEW -m tcp -p tcp --dport 22 -j ACCEPT
# 8080:9000 从8080到9000端口全放行
-A INPUT -m state --state NEW -m tcp -p tcp --dport 8080 -j ACCEPT
#　防火墙 start(启动) stop(停止) restart(重启)
[root@localhost ~]# service iptables restart
```

## 7、验证是否安装成功

```
http://192.168.156.60:8080
```

# Tomcat 单机多实例配置

## 1、上传下载的安装压缩包apache-tomcat-8.5.47.tar.gz

## 2、解压压缩包并放到 /usr/local 目录

```shell
[root@localhost ~]# tar -zxvf apache-tomcat-8.5.47.tar.gz -C /usr/local/
```

## 3、配置多实例模板

```shell
# 进入解压目录
[root@localhost ~]# cd /usr/local/apache-tomcat-8.5.47/
# 默认的Tomcat目录结构如下
[root@localhost apache-tomcat-8.5.47]# tree -dL 2
.
├── bin
├── conf
├── lib
├── logs
├── temp
├── webapps
│   ├── docs
│   ├── examples
│   ├── host-manager
│   ├── manager
│   └── ROOT
└── work

# 删除无用文件
[root@localhost apache-tomcat-8.5.47]# rm -rf LICENSE
[root@localhost apache-tomcat-8.5.47]# rm -rf NOTICE
[root@localhost apache-tomcat-8.5.47]# rm -rf RELEASE-NOTES
[root@localhost apache-tomcat-8.5.47]# rm -rf RUNNING.txt
# 创建web实例模板文件夹，以后部署新实例只需要拷贝一份
[root@localhost apache-tomcat-8.5.47]# mkdir web-template
# 移动实例必需要的文件到实例模板文件夹
[root@localhost apache-tomcat-8.5.47]# mv conf/ ./web-template/
[root@localhost apache-tomcat-8.5.47]# mv logs/ ./web-template/
[root@localhost apache-tomcat-8.5.47]# mv temp/ ./web-template/
[root@localhost apache-tomcat-8.5.47]# mv webapps/ ./web-template/
[root@localhost apache-tomcat-8.5.47]# mv work/ ./web-template/
```

## 4、在模板文件夹下编写启动停止Tomcat的shell脚本

```shell
[root@localhost apache-tomcat-8.5.47]# cd web-template/
[root@localhost web-template]# vi tomcat.sh
```

tomcat.sh

```shell
ETVAL=$?
# tomcat实例目录
export CATALINA_BASE="$PWD"
# tomcat安装目录，当前目录的上级目录
export CATALINA_HOME=$(dirname "$PWD")
# 可选
export JVM_OPTIONS="-Xms128m -Xmx1024m -XX:PermSize=128m -XX:MaxPermSize=512m"
case "$1" in
    start)
      if [ -f $CATALINA_HOME/bin/startup.sh ];then
        echo $"Start Tomcat"
        $CATALINA_HOME/bin/startup.sh
      fi
    ;;
    stop)
      if [ -f $CATALINA_HOME/bin/shutdown.sh ];then
        echo $"Stop Tomcat"
        $CATALINA_HOME/bin/shutdown.sh
      fi
    ;;
    *)
      echo $"Usage:$0 {start|stop}"
      exit 1
    ;;
esac
exit $RETVAL

```

## 5、赋予执行权限

```shell
[root@localhost web-template]# chmod +x tomcat.sh
```

## 6、单实例测试

```shell
# 经过上面的配置后，现在的Tomcat目录结构如下
[root@localhost apache-tomcat-8.5.47]# tree -dL 2
.
├── bin
├── lib
└── web-template
    ├── conf
    ├── logs
    ├── temp
    ├── webapps
    └── work
[root@localhost apache-tomcat-8.5.47] cd web-template
# 启动实例
[root@localhost web-template] sh tomcat.sh start
# 停止实例
[root@localhost web-template] sh tomcat.sh stop
```

## 7、增加实例测试

```shell
[root@localhost apache-tomcat-8.5.47]# tree -dL 2
.
├── bin
├── lib
└── web-template
    ├── conf
    ├── logs
    ├── temp
    ├── webapps
    └── work
# 增加一个实例，只拷贝一份模板实例。然后修改端口号即可。不然会因为端口占用而无法启动。    
# 拷贝一份实例
[root@localhost apache-tomcat-8.5.47]# cp -r web-template/ 8081
# 拷贝一份实例后的的Tomcat目录结构
[root@localhost apache-tomcat-8.5.47]# tree -dL 2
.
├── 8081
│   ├── conf
│   ├── logs
│   ├── temp
│   ├── webapps
│   └── work
├── bin
├── lib
└── web-template
    ├── conf
    ├── logs
    ├── temp
    ├── webapps
    └── work
[root@localhost apache-tomcat-8.5.47]# cd 8081
[root@localhost 8081]# vi /conf/server.xml
# 修改SHUTDOWN端口号从8005变为8001，第22行左右
<Server port="8001" shutdown="SHUTDOWN">
# 修改HTTP端口号从8080变为9090，第69行左右
<Connector port="8081" protocol="HTTP/1.1"
[root@localhost 8081]# sh tomcat.sh start
```

# Linux Tomcat热部署

## 1、配置Tomcat热部署用户和角色

```shell
[root@localhost conf]# pwd
/usr/local/apache-tomcat-8.0.53/conf
[root@localhost conf]# vim tomcat-users.xml
<role rolename="manager-gui"/>
<role rolename="manager-script"/>
<user username="tomcat" password="tomcat" roles="manager-gui,manager-script"/>
```

## 2、配置项目Tomcat插件

```xml
<plugins>
    <plugin>
        <groupId>org.apache.tomcat.maven</groupId>
        <artifactId>tomcat7-maven-plugin</artifactId>
        <version>2.2</version>
        <configuration>	
            <!-- 项目发布到tomcat后的名称 -->
            <path>/apple</path>
            <username>tomcat</username>
            <password>tomcat</password>
            <!-- 热部署目录 -->
            <url>http://192.168.156.60:8080/manager/text</url>
        </configuration>
    </plugin>
```

## 3、执行命令发布到Linux Tomcat

```
mvn tomcat7:redeploy
```

# Linux Maven安装配置

## 1、上传安装压缩包 apache-maven-3.6.2-bin.tar.gz，并解至 /usr/local 目录

```shell
[root@localhost ~]# tar -zxvf apache-maven-3.6.2-bin.tar.gz -C /usr/local/
# 完整目录：/usr/local/apache-maven-3.6.2
```

## 2、设置环境变量

```shell
[root@localhost ~]# vim /etc/profile
export MAVEN_HOME=/usr/local/apache-maven-3.6.2
export PATH=$PATH:$MAVEN_HOME/bin
```

## 3、刷新环境变量

```shell
[root@localhost ~]# source /etc/profile
```

## 4、验证是否安装成功

```shell
[root@localhost local]# mvn -v
```

## 5、设置仓库位置和阿里镜像

```shell
[root@localhost ~]# vim /usr/local/apache-maven-3.6.2/conf/settings.xml
 <localRepository>/usr/local/apache-maven-3.6.2/repo</localRepository>
 
 <mirrors>
    <mirror>
      <id>nexus-aliyun</id>
      <mirrorOf>*</mirrorOf>
      <name>Nexus aliyun</name>
      <url>http://maven.aliyun.com/nexus/content/groups/public</url>
    </mirror>
  </mirrors>
```

# CentOS 6.x Git安装

## 1、安装编译Git里需要的包

```shell
yum install -y curl-devel expat-devel gettext-devel openssl-devel zlib-devel
yum install -y perl-ExtUtils-MakeMaker
```

## 2、删除已有的Git

```shell
yum remove git
```

## 3、Git官网下载Git最新版tar包，移动到/url/src目录

```shell
cd /usr/src
tar -zxvf git-2.9.3.tar.gz
```

## 4、编译安装

```shell
cd git-2.9.3
make prefix=/usr/local/git all
make prefix=/usr/local/git install
echo "export PATH=$PATH:/usr/local/git/bin" >> /etc/bashrc
source /etc/bashrc
```

## 5、检查一下版本号

```shell
git --version
```

# CentOS 7.x Git安装

## 1、安装编译Git里需要的包

```shell
yum -y install autoconf automake libtool
yum -y install curl-devel expat-devel openssl-devel zlib-devel
```

## 2、Git官网下载Git最新版tar包，解压并安装

```shell
tar -zxvf git-v2.24.0.tar.gz
cd git-2.24.0/
make configure
./configure --prefix=/usr/local/git
make
make install
ln -s /usr/local/git/bin/git /usr/bin/git
```

## 3、检查一下版本号

```shell
git --version
```

# CentOS 6.x Docker安装

# CentOS 7.x Docker安装

在centos7上安装docker，官网有比较详细的说明：

```shell
https://docs.docker.com/install/linux/docker-ce/centos/
```

## 1、docker要求Centos系统的内核版本高于3.10，检查操作系统版本

```shell
[root@localhost ~]# uname -r
3.10.0-1062.el7.x86_64
```

## 2、下载docker的rpm包

```
https://download.docker.com/linux/centos/7/x86_64/stable/Packages/
# 本次下载的包为：docker-ce-19.03.4-3.el7.x86_64.rpm
```

## 3、删除老版本docker

```shell
yum remove docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-selinux \
                  docker-engine-selinux \
                  docker-engine
```

## 4、添加yum源

 在 Centos7 中使用阿里云的yum源 

```shell
# 1、备份原来的yum源
[root@localhost ~]# mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup

# 2、下载阿里云的CentOS-Base.repo 到/etc/yum.repos.d/
[root@localhost ~]# wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
# 或者
[root@localhost ~]# mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup

# 3、清理缓存
[root@localhost ~]# sudo yum clean all

# 4、生成新的缓存
[root@localhost ~]# sudo yum makecache
```

添加docker源

```shell
[root@localhost ~]# yum update
[root@localhost ~]# yum -y install yum-utils 
[root@localhost ~]# yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
```

## 5、安装

```shell
# docker安装包名为：docker-ce-19.03.4-3.el7.x86_64.rpm
# 安装包的存储目录为： /root
[root@localhost ~]# yum install -y /root/docker-ce-19.03.4-3.el7.x86_64.rpm
```

## 6、检查是否安装成功

```shell
[root@localhost ~]# docker version
```

## 7、配置镜像加速器

```shell
sudo mkdir -p /etc/docker
sudo tee /etc/docker/daemon.json <<-'EOF'
{
  "registry-mirrors": ["https://awclrbku.mirror.aliyuncs.com"]
}
EOF
sudo systemctl daemon-reload
sudo systemctl restart docker
```

# CentOS 7.x Jenkins安装

## 1、[Jenkins官网](https://jenkins.io/zh/download/)下载jenkins-2.190.2-1.1.noarch.rpm

## 2、安装Jenkins

```shell
[root@localhost ~]# rpm -ivh jenkins-2.190.2-1.1.noarch.rpm
```

## 3、配置Jenkins，修改用户和端口

```shell
[root@localhost ~]# vi /etc/sysconfig/jenkins
# Jenkins JDK默认位置是/usr/bin/java，如果不需要需要手动指定
JENKINS_JAVA_CMD="/usr/local/jdk1.8.0_231/bin/java"
JENKINS_USER="root"
JENKINS_PORT="8888"
```

## 4、启动服务

```shell
[root@localhost ~]# systemctl start jenkins
```

## 5、验证是否安装成功

```shell
http://192.168.156.61:8888/login?from=%2F
```

## 6、默认密码获取

```shell
[root@localhost ~]# cat /var/lib/jenkins/secrets/initialAdminPassword
```

# CentOS 6.x Nginx安装

## 1、[下载](http://nginx.org/)压缩包并nginx-1.17.3.tar.gz解压

```shell
[root@localhost ~]# tar -zxvf nginx-1.17.3.tar.gz
```

## 2、安装nginx所需依赖

```shell
[root@localhost ~]# yum -y install gcc zlib zlib-devel pcre-devel openssl openssl-devel
```

## 3、 进入解压目录

```shell
[root@localhost ~]# cd nginx-1.17.3
[root@localhost nginx-1.17.3]# ./configure
```

## 4、编译

```shell
[root@localhost nginx-1.17.3]# make
```

## 5、安装

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

# CentOS 7.x Nginx安装

## 1、[下载](http://nginx.org/)压缩包并nginx-1.17.5.tar.gz解压

```shell
[root@localhost ~]# tar -zxvf nginx-1.17.5.tar.gz
```

## 2、安装nginx所需依赖

```shell
# gcc gcc-c++ nginx 编译时依赖 gcc 环境
# pcre pcre-devel 让 nginx 支持重写功能
# zlib zlib-devel 提供了很多压缩和解压缩的方式，nginx 使用 zlib 对 http 包内容进行 gzip 压缩
# openssl openssl-devel 安全套接字层密码库，用于通信加密
[root@localhost ~]# yum -y install gcc gcc-c++ pcre pcre-devel zlib zlib-devel openssl openssl-devel
```

## 3、 进入解压目录

```shell
[root@localhost ~]# cd nginx-1.17.5
# 检查平台安装环境
# --prefix=/usr/local/nginx  是 nginx 编译安装的目录（推荐），安装完后会在此目录下生成相关文件
[root@localhost nginx-1.17.5]# ./configure --prefix=/usr/local/nginx
```

## 4、编译

```shell
[root@localhost nginx-1.17.5]# make
```

## 5、安装

```shell
[root@localhost nginx-1.17.5]# make install
```

## 6、启动nginx

```shell
# 启动服务
[root@localhost ~]# /usr/local/nginx/sbin/nginx
# 重新加载服务
[root@localhost ~]# /usr/local/nginx/sbin/nginx -s reload
# 停止服务
[root@localhost ~]# /usr/local/nginx/sbin/nginx -s stop
```

## 7、防火墙开放80端口，在浏览器能过IP地址验证是否能打开nginx页面

```shell
[root@localhost ~]# systemctl stop firewalld
[root@localhost ~]# yum -y install net-tools
[root@localhost ~]# netstat -nultp | grep :80
tcp        0      0 0.0.0.0:80              0.0.0.0:*               LISTEN      5368/nginx: master
```

# CentOS 7.x  Keepalived安装

## 1、[下载](https://www.keepalived.org/download.html)压缩包并keepalived-2.0.19.tar.gz解压

```shell
[root@localhost ~]# tar -zxvf keepalived-2.0.19.tar.gz
```

## 2、安装keepalived所需依赖

```shell
[root@localhost ~]# yum -y install libnl libnl-devel libnfnetlink-devel
```

## 3、 进入解压目录

```shell
[root@localhost ~]# cd keepalived-2.0.19
[root@localhost keepalived-2.0.19]# ./configure --prefix=/usr/local/keepalived
```

## 4、编译

```shell
[root@localhost keepalived-2.0.19]# make
```

## 5、安装

```shell
[root@localhost keepalived-2.0.19]# make install
```

## 6、配置开机启动服务

```shell
[root@localhost ~]# mkdir -p /etc/keepalived
[root@localhost ~]# cp /usr/local/keepalived/etc/keepalived/keepalived.conf /etc/keepalived/keepalived.conf
[root@localhost ~]# cp /root/keepalived-2.0.19/keepalived/etc/init.d/keepalived /etc/rc.d/init.d/keepalived
[root@localhost ~]# cp /usr/local/keepalived/etc/sysconfig/keepalived /etc/sysconfig/keepalived

```

## 7、启动/关闭服务

```shell
# 启动
[root@localhost ~]# systemctl start keepalived
# 开机启动
[root@localhost ~]# systemctl enable keepalived.service
# 查看是否开机启动
[root@localhost ~]# systemctl is-enabled keepalived.service
```

# CentOS 7.x Nexus安装

## 1、[官网下载unix版本](https://www.sonatype.com/download-oss-sonatype)latest-unix.tar.gz

```shell
[root@localhost ~]# tar -zxvf latest-unix.tar.gz -C /usr/local
```

## 2、启动nexus

```shell
# 第一次启动使用 第一次启动比较慢
[root@localhost ~]# cd /usr/local/nexus-3.18.1-01/bin/
# 启动访问web页面
[root@localhost bin]# ./nexus run &
# 启动nexus
[root@localhost bin]# ./nexus start
# 查看nexus运行状态
[root@localhost bin]# ./nexus status
```

## 3、开启远程访问端口

```shell
[root@localhost ~]# firewall-cmd --zone=public --add-port=8081/tcp --permanent
[root@localhost ~]# firewall-cmd --reload
```

## 4、打开网页测试是否成功

访问地址：http://192.168.156.61:8081

```shell
[root@localhost etc]# pwd
/usr/local/nexus-3.18.1-01/etc
# 修改默认端口
[root@localhost etc]# vi nexus-default.properties
application-port=8081

# 用户名为：admin，默认密码路径
[root@localhost ~]# cat /usr/local/sonatype-work/nexus3/admin.password
```

# CentOS7.x ShowDoc安装

## 1、从官网下载

```shell
https://github.com/star7th/showdoc
```

## 2、上传到CentOS服务器

```shell
[root@localhost ~]# tar -zxvf showdoc-2.6.3.tar.gz
```

## 3、开始安装

```shell
# 前提先安装好Docker
[root@localhost ~]# cd showdoc
[root@localhost ~]# docker build -t showdoc ./
# 果想在不同端口启动，请修改4999为其它端口
[root@localhost ~]# docker run -d --name showdoc -p 4999:80 showdoc 
```

## 4、访问ShowDoc

```shell
# 在浏览器输入下面地址，注意ip
http://192.168.132.132:4999/install/
```

# CentOS7.x MySql安装

## 1、官网下载linux版本

```shell
https://cdn.mysql.com//Downloads/MySQL-5.7/mysql-5.7.29-linux-glibc2.12-x86_64.tar.gz
```

## 2、上传到服务并解压

```shell
[root@localhost ~]# tar -zxvf mysql-5.7.29-linux-glibc2.12-x86_64.tar.gz
```

## 3、安装 

```shell
# 安装依赖
[root@localhost ~]# yum install -y libaio

[root@localhost ~]# mv mysql-5.7.29-linux-glibc2.12-x86_64 /usr/local/mysql
[root@localhost ~]# ll /usr/local/mysql/
总用量 288
drwxr-xr-x.  2 root root    4096 2月  28 18:06 bin
drwxr-xr-x.  2 root root      55 2月  28 18:06 docs
drwxr-xr-x.  3 root root    4096 2月  28 18:06 include
drwxr-xr-x.  5 root root     230 2月  28 18:06 lib
-rw-r--r--.  1 7161 31415 276202 12月 18 20:59 LICENSE
drwxr-xr-x.  4 root root      30 2月  28 18:06 man
-rw-r--r--.  1 7161 31415    587 12月 18 20:59 README
drwxr-xr-x. 28 root root    4096 2月  28 18:06 share
drwxr-xr-x.  2 root root      90 2月  28 18:06 support-files

[root@localhost ~]# cd /usr/local/mysql/
# 创建数据仓库目录
[root@localhost mysql]# mkdir -p data/mysql

# 新建mysql用户、组及目录
[root@localhost mysql]# groupadd mysql
[root@localhost mysql]# useradd -r -s /sbin/nologin -g mysql mysql -d /usr/local/mysql/

# 改变目录属有者
[root@localhost mysql]# chown -R mysql .
[root@localhost mysql]# chgrp -R mysql .

# 配置参数
[root@localhost mysql]#  bin/mysqld --initialize --user=mysql --basedir=/usr/local/mysql/ --datadir=/usr/local/mysql/data/mysql/
# 此处需要注意记录生成的临时密码

# 使用脚本工具生成密钥文件
[root@localhost mysql]# bin/mysql_ssl_rsa_setup  --datadir=/usr/local/mysql/data/mysql/

# 修改系统配置文件
[root@localhost mysql]# cd support-files/
[root@localhost support-files]# ls
magic  mysqld_multi.server  mysql-log-rotate  mysql.server
[root@localhost support-files]# cp mysql.server /etc/init.d/mysql

# 修改以下内容
[root@localhost mysql]# vi /etc/my.cnf
[mysqld]
init_connect='SET collation_connection = utf8_unicode_ci'
init_connect='SET NAMES utf8'
character-set-server=utf8
port=3306
datadir=/usr/local/mysql/data/mysql
skip-grant-tables

[root@localhost mysql]# /etc/init.d/mysql start
Starting MySQL.Logging to '/usr/local/mysql/data/mysql/localhost.localdomain.err'.
 SUCCESS!
```

## 4、启动

```shell
[root@localhost mysql]# ln -s /usr/local/mysql/bin/mysql /usr/bin
[root@localhost mysql]# service mysql stop
[root@localhost mysql]# service mysql start
[root@localhost mysql]# mysql -hlocalhost -uroot -p
Enter password: 临时密码
# 刷新权限
> flush privileges;
# 修改密码
> set password for root@localhost=password('123456');
# 设置root账户的host地址（修改可以远程连接）
> grant all privileges on *.* to 'root'@'%' identified by 'root';
# 刷新权限
> flush privileges;

# 开放3306端口
[root@localhost ~]# firewall-cmd --zone=public --add-port=3306/tcp --permanent
[root@localhost ~]# firewall-cmd --reload
```

