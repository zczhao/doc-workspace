# Git安装

## 一、下载Git源码

https://github.com/git/git

## 二、安装

```shell
# 压缩包解压
[root@localhost ~]# tar -zxvf git-2.23.0.tar.gz
# 安装编译源码所需依赖
[root@localhost ~]# yum -y install curl-devel expat-devel gettext-devel openssl-devel zlib-devel gcc perl-ExtUtils-MakeMaker 
# 进入解压后的文件夹
[root@localhost ~]# cd git-2.23.0
# 执行编译
[root@localhost ~]# make prefix=/usr/local/git all
# 安装Git至/usr/local/git路径
[root@localhost ~]# make prefix=/usr/local/git install
# 打开环境变量配置文件，命令 vim /etc/profile ，在底部加上Git相关配置信息
[root@localhost ~]# vim /etc/profile
PATH=$PATH:/usr/local/git/bin
export PATH
# 刷新环境变量
[root@localhost ~]# source /etc/profile
# 查看安装的git版本
[root@localhost ~]# git --version
```

# CentOS安装nvm

## 1、下载nvm

```shell
[root@localhost ~]# git clone git://github.com/creationix/nvm.git ~/nvm
```

## 2、设置nvm自动运行

```shell
[root@localhost ~]# echo "source ~/nvm/nvm.sh" >> ~/.bashrc
[root@localhost ~]# source ~/.bashrc
```

## 3、nvm命令

```shell
# 通过淘宝镜像加速nvm
# 临时方法
[root@localhost ~]# NVM_NODEJS_ORG_MIRROR=https://npm.taobao.org/mirrors/node
# 永久方法
[root@localhost ~]# vim ~/.bashrc
export NVM_NODEJS_ORG_MIRROR=https://npm.taobao.org/mirrors/node
[root@localhost ~]# source ~/.bashrc
```

```shell
nvm --help                          显示所有信息
nvm --version                       显示当前安装的nvm版本
nvm install [-s] <version>          安装指定的版本，如果不存在.nvmrc,就从指定的资源下载安装
nvm uninstall <version>             卸载指定的版本
nvm use [--silent] <version>        使用已经安装的版本  切换版本
nvm current                         查看当前使用的node版本
nvm ls                              查看已经安装的版本
nvm ls  <version>                   查看指定版本
nvm ls-remote                       显示远程所有可以安装的nodejs版本
nvm ls-remote --lts                 查看长期支持的版本
nvm install-latest-npm              安装最新的npm
nvm reinstall-packages <version>    重新安装指定的版本
nvm cache dir                       显示nvm的cache
nvm cache clear                     清空nvm的cache
nvm list [available]
  - nvm list 查看已经安装的版本
  - nvm list installed 查看已经安装的版本
  - nvm list available 查看网络可以安装的版本
```

## 4、安装node

```shell
[root@localhost ~]# nvm ls-remote 
[root@localhost ~]# nvm install v10.16.3
[root@localhost ~]# nvm use v10.16.3
[root@localhost ~]# node -v
```

## 5、通过淘宝镜像加速npm

```shell
# 打印默认的 registry 地址
[root@localhost nvm]# npm config -g get registry
# 设置淘宝镜像
[root@localhost nvm]# npm config -g set registry https://registry.npm.taobao.org
```

# Node/npm环境变量

## 1、windows环境变量配置

### 1.1、Path配置

```
NODE_HOME
C:\node-v12.3.1

NODE_GLOBAL
C:\workspace\nodejs\node_global

Path
%NODE_HOME%\
%NODE_GLOBAL%\
```

### 1.2、建立node_global、node_cache文件夹

```shell
# 第一种配置方式
vim ~/.npmrc
prefix=C:\workspace\nodejs\node_global
cache=C:\workspace\nodejs\node_cache
# 第二种配置方式
npm config set prefix "C:\workspace\nodejs\node_global"
npm config set cache "C:\workspace\nodejs\node_cache"
npm root -g
```

### 1.3、npm切换阿里源

不安装 cnpm 只用淘宝镜像，设置 npm 的镜像：
```
npm config set registry https://registry.npm.taobao.org/
```

执行下面的命令，确认是否切换成功：
```
npm config get registry
# https://registry.npm.taobao.org 淘宝源
# https://registry.npmjs.org 官方源
```

```
# 列出配置
npm config list
# 列出所有配置(包括默认项)
npm config list -l
```

如查 npm 设置的阿里源，无法使用 npm search，解决办法：

```shell
vim ~/.npmrc
registry=https://registry.npmjs.org/
# 可以使用cnpm代替npm进行install, 而使用npm进行search
npm install -g cnpm --registry=https://registry.npm.taobao.org 
```

## 2、其他系统环境变量配置

2.1、Path配置

```shell
vim ~/.bash_profile
export NODE_HOME=/usr/local/node-v12.13.1
export NODE_PATH=/Users/zczhao/Documents/Data/nodejs/node_globa
export PATH=$PATH:$NODE_HOME/bin:$NODE_PATH/bin
```

### 2.2、建立node_global、node_cache文件夹

```shell
# 第一种配置方式
vim ~/.npmrc
prefix=/Users/zczhao/Documents/Data/nodejs/node_globa
cache=/Users/zczhao/Documents/Data/nodejs/node_cache
# 第二种配置方式
npm config set prefix "/Users/zczhao/Documents/Data/nodejs/node_globa"
npm config set cache "/Users/zczhao/Documents/Data/nodejs/node_cache"
npm root -g
```

### 2.3、cnpm安装

```shell
npm install -g cnpm --registry=https://registry.npm.taobao.org
```

# NPM

## 1、常用命令

### 1.1、基本命令

```shell
# 查看 npm 版本
npm -v

# 查看安装信息
npm list -g

# 装模块
npm install <Module Name>

# 新模块
npm update <Module Name>

# 卸载模块
npm uninstall <Module Name>

# 搜索模块
npm search <Module Name>

# 清空缓存
npm cache clear 

# 创建模块
npm init
```

### 1.2、全局安装与本地安装

- **全局安装**

  1. 将安装包放在 /usr/local 下或者你 node 的安装目录。

  2. 可以直接在命令行里使用。

- **本地安装**

  1. 将安装包放在 ./node_modules 下（运行 npm 命令时所在的目录），如果没有 node_modules 目录，会在当前执行 npm 命令的目录下生成 node_modules 目录。
  2. 可以通过 require() 来引入本地安装的包。

```shell
# 本地安装 
npm install express
# 全局安装
npm install express -g
```



# Bower

## 一、安装

```shell
[root@localhost ~]# npm install -g bower
```

## 二、构建项目

```shell
[root@localhost ~]# bower init --allow-root
? name angular_001
? description first angular project
? main file
? keywords
? authors 赵志成
? license MIT
? homepage
? set currently installed components as dependencies? Yes
? add commonly ignored files to ignore list? Yes
? would you like to mark this package as private which prevents it from being accidentally published to the registry? Yes

{
    "name": "angular_001",  // 项目名字
    "authors": [  // 作者
        "赵志成"
    ],
    "description": "first angular project", // 描述
    "main": "", // 主文件
    "license": "MIT", // 开源协议
    "homepage": "", // 个人主页
    "private": true,
    "ignore": [ // 忽略哪些文件
        "**/.*",
        "node_modules",
        "bower_components",
        "test",
        "tests"
    ]
}

```

## 三、安装其他插件

### 1、安装jQuery

```shell
[root@localhost ~]# bower install jquery --save
```

会自动下载jQuery到bower_components文件夹中

虚拟机可能会遇到的问题：

```shell
bower CERT_NOT_YET_VALID      Request to https://registry.bower.io/packages/search/vue failed: certificate is not yet valid

# 需要同步系统时间
[root@localhost ~]# ntpdate cn.pool.ntp.org
```



### 2、安装jQuery其他版本

```
"dependencies": {
    "jquery": "^1.12.4"
}
```

```Bash
# 安装
$ bower install
```

```bash
# 选择版本安装，并且可以随时继续输入bower install命令安装其他版本，原有版本将自动覆盖。引用路径还是bower_components/jquery/jquery.min.js
$ bower install jquery@3.*.*
```

如安装jquery-ui会自动下载jquery的依赖，bower会下载它的源代码，可以用webpack等打包工具构建自己的jQuery

src：源代码的目录、dist：就是生成的，构建之后的代码

当不需要那么多东西的时候，仅仅需要使用dist文件夹即可。构建工具也会随着bower下载。

如果不喜欢将下载的文件放到bower_components文件夹中，比如放到js/lib文件夹中，此时应该在项目的根目录创建一个文件名为.bowerrc的文件：

```
{
	"directory":"js/lib"
}
```

