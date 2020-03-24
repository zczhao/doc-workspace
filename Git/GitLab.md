# GitLab yum安装

## 1、yum安装GitLab

```shell
[root@localhost ~]# vi /etc/yum.repos.d/gitlab-ce.repo
# 添加如下内容
[gitlab-ce]
name=gitlab-ce
baseurl=http://mirrors.tuna.tsinghua.edu.cn/gitlab-ce/yum/el6
repo_gpgcheck=0
gpgcheck=0
enabled=1
gpgkey=https://packages.gitlab.com/gpg.key
```

```shell
[root@localhost ~]# yum makecache
[root@localhost ~]# yum install gitlab-ce -y
```

## 2、安装成功后修改配置文件，修改访问ur

```shell
[root@localhost ~]# vim /etc/gitlab/gitlab.rb
external_url "http://192.168.156.60:8081/gitlab"

[root@localhost ~]# gitlab-ctl reconfigure
[root@localhost ~]# gitlab-ctl restart
```

## 3、访问GitLab

看是否正常运行，初次运行里需要重置root用户密码

示例地址：http://192.168.156.60:8081/gitlab

