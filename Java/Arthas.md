# Arthas

## 1、安装

```shell
[root@localhost ~]# wget https://alibaba.github.io/arthas/arthas-boot.jar
# 如果下载速度比较慢，可以使用aliyun的镜像
[root@localhost ~]# java -jar arthas-boot.jar --repo-mirror aliyun --use-http
# 如果从github下载有问题，可以使用gitee镜像
[root@localhost ~]# wget https://arthas.gitee.io/arthas-boot.jar
```

## 2、启动

```shell
[root@localhost ~]# java -jar arthas-boot.jar [进程id]
[root@localhost ~]# java -jar arthas-boot.jar --target-ip 0.0.0.0
```

## 3、jad/mc/redefine热更新

```shell
# jad反编译代码
# 反编译UserController，保存到 /tmp/UserController.java文件里。
$jad --source-only com.example.demo.arthas.user.UserController > /tmp/UserController.java
```

修改编译出来的代码

```shell
# sc查找加载UserController的ClassLoader
$ sc -d *UserController | grep classLoaderHash
 classLoaderHash   1be6f5c3
```

mc内存编绎代码

```shell
# 保存好/tmp/UserController.java之后，使用mc(Memory Compiler)命令来编译，并且通过-c参数指定ClassLoader
$ mc -c 1be6f5c3 /tmp/UserController.java -d /tmp
Memory compiler output:
/tmp/com/example/demo/arthas/user/UserController.class
Affect(row-cnt:1) cost in 346 ms
```

redefine热更新代码

```shell
# 再使用redefine命令重新加载新编译好的UserController.class
$ redefine /tmp/com/example/demo/arthas/user/UserController.class
redefine success, size: 1
```

## 4、sc

查找JVM里加载的类：

```shell
[arthas@30]$ sc -d *MathGame
 class-info        demo.MathGame
 code-source       /home/scrapbook/tutorial/arthas-demo.jar
 name              demo.MathGame
 isInterface       false
 isAnnotation      false
 isEnum            false
 isAnonymousClass  false
 isArray           false
 isLocalClass      false
 isMemberClass     false
 isPrimitive       false
 isSynthetic       false
 simple-name       MathGame
 modifier          public
 annotation
 interfaces
 super-class       +-java.lang.Object
 class-loader      +-sun.misc.Launcher$AppClassLoader@70dea4e
                     +-sun.misc.Launcher$ExtClassLoader@7a3eb348
 classLoaderHash   70dea4e

Affect(row-cnt:1) cost in 18 ms.
```

## 5、jad

反编译代码

```shell
[arthas@187]$ jad demo.MathGame
```

## 6、watch

查看函数的参数/返回值/异常信息

```shell
[arthas@187]$ watch demo.MathGame primeFactors returnObj
```

## 7、JVM相关

getstatic 查看类的静态属性