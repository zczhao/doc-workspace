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
[root@localhost ~]# cd /usr/local/apache-tomcat-8.0.53
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
tar -zxvf git-v2.23.0.tar.gz
cd git-2.23.0/
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

