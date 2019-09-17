# 一、JDK安装

## 1、下载jdk-8u221-linux-x64.tar.gz，并解压 

```shell
[root@localhost ~]# tar -zxvf jdk-8u221-linux-x64.tar.gz -C /usr/local/
# 完整目录：/usr/local/jdk1.8.0_221
```

## 2、配置环境变量

```shell
[root@localhost ~]# vim /etc/profile
export JAVA_HOME=/usr/local/jdk1.8.0_221
export CLASSPATH=.:$JAVA_HOME/lib/rt.jar:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
export PATH=$PATH:$JAVA_HOME/bin
```

## 3、刷新环境变量

```shell
[root@localhost ~]# source /etc/profile
```

## 4、验证是否安装成功

```shell
[root@localhost ~]# java -version
```

# 二、Tomcat安装

## 1、下载apache-tomcat-8.0.53.tar.gz，并解压

```shell
[root@localhost ~]# tar -zxvf apache-tomcat-8.0.53.tar.gz -C /usr/local/
# 完整目录：/usr/local/apache-tomcat-8.0.53
```

## 2、启动Tomcat

```shell
[root@localhost ~]# cd /usr/local/apache-tomcat-8.0.53/bin
# 启动tomcat
[root@localhost bin]# ./startup.sh
# 关闭tomcat
[root@localhost bin]# ./shutdown.sh
# 查看tomcat进程
[root@localhost bin]# ps -ef | grep tomcat
```

# 三、Maven安装

## 1、下载apache-maven-3.6.2-bin.tar.gz

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



# 四、Jenkins+SVN持续集成环境搭建

## 1、系统结构总述

- 创建虚拟机安装Linux系统
- 版本控制子系统
  1. Subversion服务器
  2. 项目对应版本库
  3. 版本库中钩子程序
- 持续集成子系统
  1. JDK
  2. Tomcat
  3. Maven
  4. Jenkins
     * 主体程序
     * SVN插件
     * Maven插件
     * Deploy to Web Container 插件
- 应用发布子系统
  1. JDK
  2. Tomcat

## 2、版本控制子系统

版本控制根目录：/var/svn/repository/apple

设置访问账号密码(conf/passwd)：

```shell
[users]
# harry = harryssecret
# sally = sallyssecret
#
subman = 123123
```

设置账号权限(conf/authz)：

```shell
[/]
subman=rw
* =
```

conf/svnserve.conf文件中anon-access一定要打开注释并设置为none:

```shell
[root@localhost conf]# sed -n "12,13p"  svnserve.conf
anon-access = none
auth-access = write
```

## 3、应用发布子系统

设置Tomcat服务器的账号密码

配置文件位置：/usr/local/apache-tomcat-8.0.53/conf/tomcat-users.xml

```xml
<role rolename="manager-gui"/>
<role rolename="manager-script"/>
<role rolename="manager-jmx"/>
<role rolename="manager-status"/>
<user username="tomcat_user" password="123456" roles="manager-gui,manager-script,manager-jmxmanager-status"/>
```

## 4、Jenkins主体程序安装配置

### 3.1、把jenkins.war放在Tomcat解压目录/webapps目录下

### 3.2、打开Tomcat解压目录/server.xml修改URL地址的编码解码字符集

```shell
# 在server.xml文件的Connector节点里增加URIEncoding="UTF-8"
[root@localhost ~]# vim /usr/local/apache-tomcat-8.0.53/conf/server.xml
	<Connector port="8080" protocol="HTTP/1.1"
               connectionTimeout="20000"
               redirectPort="8443" URIEncoding="UTF-8" />

```

### 3.3、启动Tomcat并通过浏览器访问

网址示例：http://192.168.156.60:8080/jenkins

### 3.4、解锁Jenkins

<img src="./images/2019-09-14_204305.png" style="zoom:50%;" />

```shell
# admin默认密码保存路径
[root@localhost ~]# cat /root/.jenkins/secrets/initialAdminPassword
6ffdc235ff924db1902e7463d49a7d2b
```

![](./images/2019-09-14_204908.png)

![](./images/2019-09-14_205031.png)

![](./images/2019-09-14_220202.png)

![](./images/2019-09-14_220249.png)

![](./images/2019-09-14_220335.png)

## 5、系统初始化配置

### 5.1、系统管理  ->  全局安全配置

Manage Jenkins -> Configure Global Security

![](./images/2019-09-15_001427.png)

### 5.2、系统管理  ->  全局工具配置

Manage Jenkins -> Global Tool Configure

Maven settings.xml路径配置：

![](./images/2019-09-15_002046.png)

JDK安装路径配置：

![](./images/2019-09-15_002137.png)

Maven安装路径配置：

![](./images/2019-09-15_002227.png)

### 5.3、系统管理 -> 管理插件

Manage Jenkins -> Manage Plugins

安装svn插件：Subversion Plug-in

安装web部署插件：Deploy to Container Plugin

## 6、创建工程

### 6.1、创建工程

![](./images/2019-09-15_002910.png)

### 6.2、指定工程名称和工程类型

![](./images/2019-09-15_003124.png)

### 6.3、源码管理

![](./images/2019-09-15_003407.png)

SVN源码位置和访问用户名密码配置：

![](./images/2019-09-15_003459.png)

### 6.4、配置构建命令

![](./images/2019-09-15_003733.png)

### 6.5、配置构建完成后部署到Tomcat上

![](./images/2019-09-15_003853.png)

### 6.6、手动构建

![](./images/2019-09-15_004703.png)

### 6.7、构建触发器

![](./images/2019-09-15_005111.png)

访问示例地址就会触发构建：http://192.168.156.60:8080/jenkins/job/Apple/build?token=zczhao_token

### 6.8、使用svn勾子程序触发触发器

版本控制根目录：/var/svn/repository/apple

```shell
[root@localhost apple]# cd hooks/

[root@localhost hooks]# ll
-rw-r--r--. 1 root root 1977 9月  11 13:47 post-commit.tmpl
-rw-r--r--. 1 root root 1638 9月  11 13:47 post-lock.tmpl
-rw-r--r--. 1 root root 2289 9月  11 13:47 post-revprop-change.tmpl
-rw-r--r--. 1 root root 1567 9月  11 13:47 post-unlock.tmpl
-rw-r--r--. 1 root root 3426 9月  11 13:47 pre-commit.tmpl
-rw-r--r--. 1 root root 2410 9月  11 13:47 pre-lock.tmpl
-rw-r--r--. 1 root root 2786 9月  11 13:47 pre-revprop-change.tmpl
-rw-r--r--. 1 root root 2100 9月  11 13:47 pre-unlock.tmpl
-rw-r--r--. 1 root root 2780 9月  11 13:47 start-commit.tmpl
# 配置勾子触发器
[root@localhost hooks]# cp post-commit.tmpl post-commit
# 把原来里面的内容都注释
[root@localhost hooks]# vim post-commit
curl -X post -v -u admin:6ffdc235ff924db1902e7463d49a7d2b http://192.168.156.60:8080/jenkins/job/Apple/build?token=zczhao_token
#　设置可执行权限
[root@localhost hooks]# chmod 755 post-commit
```

## 7、获取crumb值

![](./images/2019-09-15_010628.png)

![](./images/2019-09-15_010752.png)

![](./images/2019-09-15_010917.png)

![](./images/2019-09-15_011041.png)

![](./images/2019-09-15_011118.png)

携带Api Token访问下面址：

http://admin:11b82fd8a43ce3d1cc8285068bfb2712e4@192.168.156.60/jenkins/crumbIssuer/api/xml

http://192.168.156.60:8080/jenkins/crumbIssuer/api/xml

http://192.168.156.60:8080/jenkins/crumbIssuer/api/json

![](./images/2019-09-15_012126.png)

则触发Jenkins远程构建时需要携带的请求消息头就是：

Jenkins-Crumb:8a187cad91789fdcb652dd1a7f629ecf

## 8、Linux的curl命令

Linux的curl命令用来发送http请求。

-X 参数：指定请求方式

-v 参数：显示响应结果

-u 参数：携带用户名/密码

-H 参数：携带请求消息头信息

```shell
# curl请求格式：curl -X post -v -u [Jenkins用户名]:[Jenkins用户密码] -H "请求消息头信息" http://[服务器ip]:[服务器端口号]/jekins/job/[Jenkins项目名称]/build?token=[身份验证令牌]
# 例：
[root@localhost ~] curl -X post -v -u admin:6ffdc235ff924db1902e7463d49a7d2b http://192.168.156.60:8080/jenkins/job/Apple/build?token=zczhao_token
```

## 9、测试

在Eclipse中提交修改，在页面上查看显示内容变化

```xml
<project xmlns="http://maven.apache.org/POM/4.0.0"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/maven-v4_0_0.xsd">
	<modelVersion>4.0.0</modelVersion>
	<groupId>zzc.svn.ci</groupId>
	<artifactId>Apple</artifactId>
	<packaging>war</packaging>
	<version>0.0.1-SNAPSHOT</version>
	<name>Apple Maven Webapp</name>
	<url>http://maven.apache.org</url>
	<dependencies>
		<dependency>
			<groupId>junit</groupId>
			<artifactId>junit</artifactId>
			<version>4.12</version>
			<scope>test</scope>
		</dependency>

		<dependency>
			<groupId>javax.servlet</groupId>
			<artifactId>servlet-api</artifactId>
			<version>2.5</version>
			<scope>provided</scope>
		</dependency>

	</dependencies>
	<build>
		<finalName>Apple</finalName>
	</build>
</project>
```

```java
package zzc.svn.ci.entity;

public class Apple {

	private String appName = "Good apple";

	public String getAppName() {
		return appName;
	}

	public void setAppName(String appName) {
		this.appName = appName;
	}
	
}

```

```jsp
<%@ page import="zzc.svn.ci.entity.Apple"%>
<%@ page language="java" contentType="text/html;charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Insert title here</title>
<body>
<%= new Apple().getAppName()%>
<h2>Hello World!</h2>
</body>
</html>
```

修改Apple.java文件，提交svn，触发勾子程序，刷新：http://192.168.156.60:8080/apple/

## 10、补充

如果发生Jenkins服务器从SVN服务器下载代码不是最新版的情况，那么就在SVN服务器的URL地址后面加上@HEAD强制要求下载最新版

![](./images/2019-09-15_013058.png)

# 五、Jenkins+GitHub持续集成环境搭建

## 1、要点

Jenkins与Github配合实现持续集成需要注意以下几点：

1. Jenkins要部署到外网上，因为内网地址Github是无法访问的。这一点可以通过阿里云等平台提供的云服务实现。
2. Jenkins所在的主机上需要安装Git，通过Git程序从GitHub上clone代码
3. 在Jenkins内需要指定Git程序位置，和指定JDK、Maven程序位置非常类似
4. 在Github上使用每个repository的WebHook方式远程触发Jenkins构建
5. 在Jenkins内关闭"防止跨站点请求伪造"

## 2、Linux环境下安装Git

### 2.1、安装编译Git里需要的包

```shell
yum install -y curl-devel expat-devel gettext-devel openssl-devel zlib-devel
yum install -y perl-ExtUtils-MakeMaker
```

### 2.2、删除已有的Git

```shell
yum remove git
```

### 2.3、Git官网下载Git最新版tar包，移动到/url/src目录

```shell
cd /usr/src
tar -zxvf git-2.9.3.tar.gz
```

### 2.4、编译安装

```shell
cd git-2.9.3
make prefix=/usr/local/git all
make prefix=/usr/local/git install
echo "export PATH=$PATH:/usr/local/git/bin" >> /etc/bashrc
source /etc/bashrc
```

### 2.5、检查一下版本号

```shell
git --version
```

## 3、在Jenkins中指定Git程序位置

位置：系统管理  ->  全局工具配置(Manage Jenkins -> Global Tool Configure)

![](./images/20190915230116.png)

![](./images/20190915230028.png)

## 4、Github上添加Webhook

![](./images/20190915230505.png)

## 5、在Jenkins内关闭"防止跨站点请求伪造"

系统管理  ->  全局安全配置(Manage Jenkins -> Configure Global Security)

![](./images/20190915230939.png)

![](./images/20190915231018.png)

