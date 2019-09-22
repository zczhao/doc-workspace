# Linux JDK安装配置

## 1、上传安装压缩包 jdk-8u221-linux-x64.tar.gz

## 2、解压压缩包并放到 /usr/local 目录

```shell
[root@localhost ~]# tar -zxvf jdk-8u221-linux-x64.tar.gz -C /usr/local
```

## 3、配置环境变量

```shell
[root@localhost ~]# vim /etc/profile
export JAVA_HOME=/usr/local/jdk1.8.0_221
export PATH=$JAVA_HOME/bin:$PATH
export CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
```

## 4、刷新环境变量

```shell
[root@localhost ~]# source /etc/profile
```

## 5、验证是否安装成功

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

