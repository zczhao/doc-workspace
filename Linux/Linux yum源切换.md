# CentOS 7.x 使用阿里云的yum Base源

## 1、配置Base源

### 1、备份原来的yum源

```shell
[root@localhost ~]# yum -y install wget
[root@localhost ~]# mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup
```

### 2、下载阿里云的CentOS-Base.repo 到/etc/yum.repos.d/

```shell
[root@localhost ~]# wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
# 或者
[root@localhost ~]# mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup
```

### 3、清理缓存

```shell
[root@localhost ~]# sudo yum clean all
```

### 4、生成新的缓存

```shell
[root@localhost ~]# sudo yum makecache
```

## 2、配置EPEL源

### 1、下载新的epel.repo到/etc/epel.repo/

```shell
[root@localhost ~]# wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo
```

# CentOS 6.x 使用阿里云的yum源

## 1、配置Base源

### 1、备份原来的yum源

```shell
[root@localhost ~]# mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup
```

### 2、下载阿里云的CentOS-Base.repo 到/etc/yum.repos.d/

```shell
[root@localhost ~]# wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-6.repo
```

### 3、清理缓存

```shell
[root@localhost ~]# yum clean all
```

### 4、生成新的缓存

```shell
[root@localhost ~]# sudo yum makecache
```

## 2、配置EPEL源

### 1、下载新的epel.repo到/etc/epel.repo/

```shell
[root@localhost ~]# wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-6.repo
```

### 2、验证是否成功

```shell
[root@localhost ~]# yum repolist 
```

