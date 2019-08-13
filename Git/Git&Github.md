# 一、Git结构

## 工作区

写代码

## 暂存区

临时存储

## 本地库

历史版本

工作区 -> git add ->暂存区 -> git commit -> 本地库

# 二、Git和代码托管中心

代码托管中心的任务：维护远程库

## 1、局域网环境下

GitLab服务器

## 2、外网环境下

GitHub

码云

# 三、本地库和远程库

## 1、团队内部协作

本地库 -> push -> 远程库 -> clone -> 本地库 -> push(加入团队) ->远程库

## 2、跨团队协作

A的远程库 -> fork -> B的远程库 -> clone -> 本地库 -> push  -> B的远程库 -> pull request -> A审核 -> A merge -> A的远程库

# 四、Git命令行操作

## 1、本地库操作

### 1.1、本地库初始化

命令：git init

效果：

![](./images/QQ截图20190526211223.png)

注意：.git 目录中存放的是本地库相关的子目录和文件，不要删除，也不要胡乱修改

### 1.2、设置签名

#### 1、形式

用户名：zczhao

Email地址： fhqfndn@gmail.com

#### 2、作用

区分不同开发人员的身份

#### 3、辨析

这里设置的签名和登录远程库(代码托管中心)的账号、密码没有任何关系

#### 4、命令

**项目级别/仓库级别**：仅在当前本地库范围内有效

命令：

​	git config user.name zczhao_pro

​	git config user.email fhqfndn_pro@gmail.com

信息保存位置：./.git/config 文件

![](./images/QQ截图20190526215643.png)

**系统用户级别：**登录当前操作系统的用户范围

命令：

​	git config --global user.name zczhao_glb

​	git config --global user.email fhqfndn_glb@gmail.com

信息保存位置：~/.gitconfig 文件

![](./images/QQ截图20190526220108.png)

**级别优先级：**

​	就近原则：项目级别优先于系统用户级别，二者都有时采用项目级别的签名

​	如果只有系统用户级别的签名，就以系统用户级别的签名为准

​	二者都没有不允许

### 1.3、基本操作

#### 1、状态查看操作

​	git status

​	查看工作区、暂存区状态

#### 2、添加操作

​	git add [filename]

​	将工作区的"新建/修改"添加到暂存区

#### 3、提交操作

​	git commit -m "commit message" [filename]

​	将暂存区的内容提交到本地库

#### 4、查看历史记录

​	git log

​		显示所有历史版本

![](./images/TIM截图20190527235722.png)

​		多屏显示控制方式： 1、空格向上翻页 2、b向上翻页 3、q退出

​	git log --pretty=oneline

​		显示所有历史版本

![](./images/TIM截图20190527235957.png)

​	git reflog 

​		只显示当前之前的历史版本

![](./images/TIM截图20190528000054.png)

​		HEAD@{移动到当前版本需要多少步}

#### 5、前进后通

**基于索引值操作(推荐使用)**

​	git reset --hard [局部索引值]

![](./images/TIM截图20190528002147.png)

**使用^符号**(只能后退)

​	git reset --hard HEAD^

​	注：一个^表示后一步，n个表示后退n步

![](./images/TIM截图20190528003331.png)

**使用~符号**(只能后退)

​	git reset --hard HEAD~[n]

​	注：n代表数字，n是多少就表示后退多少步

#### 6、reset 命令的三个参数对比

--soft 参数

​	仅仅在本地库移动HEAD指针

![](./images/TIM截图20190528005732.png)

--mixed 参数

​	在本地库移动HEAD指针

​	重置暂存区

![](./images/TIM截图20190528005651.png)

--hard 参数

​	在本地库移动HEAD指针

​	重置暂存区

​	重置工作区

![](./images/TIM截图20190528005832.png)

#### 7、删除文件并找回

前提：删除前，文件存在时的状态提交到了本地库

操作：git reset --hard [指针位置]

​	删除操作已经提交到本地库：指针位置指向历史记录

​	删除操作尚未提交到本地库：指针位置使用 HEAD

#### 8、比较文件差异

![](./images/TIM截图20190528222327.png)

​	git diff [文件名]

​		将工作区中的文件和暂存区进行比较

![](./images/TIM截图20190528222510.png)

​	git diff [本地库中历史版本] [文件名]

​		将工作区中的文件和本地库历史记录比较

![](./images/TIM截图20190528222710.png)

​	不带文件名比较多个文件

![](./images/TIM截图20190528222853.png)

### 1.4、分支管理

#### 1、创建分支

​	git branch [分支名]

#### 2、查看分支

​	git branch -v

#### 3、切换分支

​	git checkout [分支名]

![](./images/TIM截图20190528224138.png)

#### 4、合并分支

1. 切换到接受修改的分支(被全并，增加新内容)上

   git checkout [被合并分支名]

2. 执行 merge 命令

   git merge [有新内容分支名]

![](./images/TIM截图20190528224408.png)

#### 5、解决冲突

​	冲突的表现

![](./images/TIM截图20190528225657.png)

​	冲突的解决

1. 编辑文件，删除特殊符号

2. 把文件修改到满意的程度，保存退出

3. git add [文件名]

4. git commit -m "日志信息"

   注意：此时commit一定不能带具体文件名

![](./images/TIM截图20190528230441.png)

![](./images/TIM截图20190528230902.png)

![](./images/TIM截图20190528230709.png)

# 五、Git基本原理

## 1、哈希

哈希是一个系列的加密算法，各个不同的哈希算法虽然加密强度不同，但是有以下几个共同点：

1. 不管输入数据的数据量有多大，输入同一个哈希算法，得到的加密结果长度固定
2. 哈希算法确定，输入数据确定，输出数据能够保证不变
3. 哈希算法确定，输入数据变化 ，输出数据一定有变化，而且通常变化很大
4. 哈希算法不可逆

Git底层采用的是SHA-1算法。

哈希算法可以被用来验证文件。原理如下图所示：

![](./images/TIM截图20190528232350.png)

Git就靠这种机制来从根本上保证数据完整性的。

## 2、Git保证版本的机制

### 2.1、集中式版本控制工具的文件管理机制

以文件变更列表的方式存储信息。这类系统将它们保存的信息看作是一组基本文件和每个文件随时间逐步累积的差异

![](./images/TIM截图20190529211654.png)

### 2.2、Git的文件管理机制

Git把数据看作是小型文件系统的一组快照。每次提交更新时Git都会对当前的全部文件制作一个快照并保存这个快照的索引。为了高效，如果文件没有修改，Git不再重新存储该文件，而是只保留一个链接指向之前存储的文件。所以Git的工作方式可以称之为快照流。

![](./images/TIM截图20190529212115.png)

### 2.3、Git文件管理机制细节

Git的"提交对象"

![](./images/TIM截图20190529212431.png)

提交对象及其父对象形成的链条

![](./images/TIM截图20190529212715.png)

## 3、Git分支管理机制

### 3.1、分支的创建

![](./images/TIM截图20190529212911.png)

### 3.2、分支的切换

![](./images/TIM截图20190529213438.png)

![](./images/TIM截图20190529221454.png)

![](./images/TIM截图20190529221546.png)

![](./images/TIM截图20190529221749.png)

# 六、GitHub

## 1、账号信息

GitHub首页就是注册页面：[https://github.com](https://github.com/)

## 2、创建远程库

![](./images/TIM截图20190529225052.png)

![](./images/TIM截图20190529225134.png)

## 3、创建远程库地址别名

git remote -v 查看当前所有远程地址别名

git remote add [别名] [远程地址]

![](./images/TIM截图20190529225406.png)

## 4、推送

git push [别名] [分支名]

![](./images/TIM截图20190529225527.png)

## 5、克隆

git clone [远程地址]
![](./images/TIM截图20190529225757.png)

命令效果：

1. 完整的把远程库下载到本地
2. 创建origin远程地址别名
3. 初始化本地库

## 6、邀请加入团队成员

![](./images/TIM截图20190529232651.png)

![](./images/TIM截图20190529233041.png)

![](./images/TIM截图20190529233126.png)

![](./images/TIM截图20190529233320.png)

![](./images/TIM截图20190529233545.png)

![](./images/TIM截图20190529234201.png)

## 7、拉取

pull=fetch+merge

git fetch [远程库地址别名] [远程分支名]
![](./images/TIM截图20190529235508.png)

git merge [远程库地址别名/远程分支名] 

![](./images/TIM截图20190529235620.png)

git pull  [远程库地址别名] [远程分支名]

![](./images/TIM截图20190529235949.png)

## 8、解决冲突

要点：

1. 如果不基于GitHub远程库的最新版所做的修改，不能推送，必须先拉取
2. 拉取下来如果进入冲突状态，则按照"分支冲突解决"操作即可。

类比：

​	债权人：老王

​	债务人：小刘

​	老王说：10天后归还。小刘接受，双方达成一致。

​	老王媳妇说：5天后归还。小刘不能接受，老王媳妇需要找老王确认后再执行。

![](./images/TIM截图20190530000203.png)

![](./images/TIM截图20190530001216.png)

![](./images/TIM截图20190530002147.png)

![](./images/TIM截图20190530002259.png)

![](./images/TIM截图20190530002326.png)

## 9、跨团队协作

- Fork

![](./images/TIM截图20190611213556.png)

![](./images/TIM截图20190611213717.png)

- 本地修改，然后推送到远程

![](./images/TIM截图20190611214848.png)

![](./images/TIM截图20190611215000.png)

- Pull requests

![](./images//TIM截图20190611215250.png)

![](./images/TIM截图20190611215340.png)

![](./images/TIM截图20190611215452.png)

![](./images/TIM截图20190611215723.png)

- 登录fhqfndn@gmail.com


![](./images/TIM截图20190611220513.png)

- 对话

![](./images/TIM截图20190611220831.png)

![](./images/TIM截图20190611221128.png)

![](./images/TIM截图20190611221707.png)

- 审核代码

![](./images/TIM截图20190611221931.png)

- 合并代码

![](./images/TIM截图20190611222343.png)

![](./images/TIM截图20190611223942.png)

- 将远程库修改拉取到本地

![](./images/TIM截图20190611224435.png)

## 10、SSH登录

- 进入当前用户的家目录

$ cd ~ 

- 删除.ssh目录

$ rm -rf .ssh

- 运行命令生成.ssh密钥目录

$ ssh-keygen -t rsa -C fhqfndn@gmail.com

- 进入.ssh目录查看文件列表

$ cd .ssh
$ ls -lF

- 查看id_rsa.pub文件内容

$ cat id_rsa.pub

- 复制id_rsa.pub文件内容，登录GitHub。点击用户头像->Settings->SSH and GPG Kys

- New SSH Key

- 输入复制的密钥信息

- 回到GitHub创建远程地址别名

git remote add origin_ssh git@github.com:zczhao/huashan.git

- 推送文件进行测试

![](./images/TIM截图20190611234425.png)

![](./images/TIM截图20190611234456.png)

![](./images/TIM截图20190611234523.png)

![](./images/TIM截图20190611234641.png)

![](./images/TIM截图20190611235044.png)

# 七、Eclipse操作

## 1、将工程初始化为本地库

工程 -> 右键 -> Team -> Share Project -> Git

![](./images/2019-06-16_094406.png)

![](./images/2019-06-16_094515.png)

![](./images/2019-06-16_094608.png)

Create Repository

![](./images/2019-06-16_094745.png)

![](./images/2019-06-16_095258.png)

![](./images/2019-06-16_095609.png)

## 2、设置本地库范围签名

![](./images/2019-06-16_100110.png)

 ![](./images/2019-06-16_100324.png)

## 3、Eclipse中忽略文件

### 3.1、Eclipse特定文件

这些都是Eclipse为了管理我们创建的工程而维护的文件，和开发的代码没有直接关系。最好不要在Git中进行追踪，也就是把他们忽略。
.classpath 文件
.project 文件
.settings 目录下所有文件

### 3.2、为什么要忽略Eclipse特定文件

同一个团队中很难保证大家使用相同的IDE工具，而IDE工具不同时，相关的工程特定文件就有可能不同。如果这些文件加入版本控制，那么开发时很可能需要为了这些文件去解决宣冲突。

### 3.3、GitHub管网样例文件

<https://github.com/github/gitignore>

<https://github.com/github/gitignore/blob/master/Java.gitignore>

### 3.4、编辑本地忽略配置文件，文件名任意

Java.gitignore

```
# Compiled class file
*.class

# Log file
*.log

# BlueJ files
*.ctxt

# Mobile Tools for Java (J2ME)
.mtj.tmp/

# Package Files #
*.jar
*.war
*.nar
*.ear
*.zip
*.tar.gz
*.rar

# virtual machine crash logs, see http://www.java.com/en/download/help/error_hotspot.xml
hs_err_pid*
```

### 3.5、在~/.gitconfig文件中引入上述文件

```
[core]
	excludesfile = C:/Users/Administrator/Java.gitignore
```

**注意：这里路径中一定使用"/"，不能使用"\"**

**在项目中忽略配置文件**

![](./images/2019-06-16_110448.png)

## 4、Eclipse中本地库基本操作

### 4.1、添加到暂存区

![](./images/2019-06-16_110903.png)

![](./images/2019-06-16_111439.png)

**Ctrl+#/Ctrl+Shift+3快捷键**

### 4.2、提交到本地库

![](./images/2019-06-16_111257.png)

## 5、将本地工程推送到远程库

### 5.1、登录GitHub

### 5.2、创建仓库

![](./images/2019-06-16_112450.png)

![](./images/2019-06-16_112556.png)

### 5.3、复制仓库地址

![](./images/2019-06-16_112715.png)

### 5.4、关联远程库

![](./images/2019-06-16_113007.png)

![](./images/2019-06-16_113246.png)

![](./images/2019-06-16_113402.png)

![](./images/2019-06-16_113537.png)

![](./images/2019-06-16_113722.png)

![](./images/2019-06-16_113911.png)

![](./images/2019-06-16_114108.png)

## 6、将远程库的工程克隆到本地

### 6.1、File -> Import... 导入工程

![](./images/2019-06-16_114835.png)

![](./images/2019-06-16_114916.png)

![](./images/2019-06-16_115318.png)

![](./images/2019-06-16_115446.png)

![](./images/2019-06-16_115623.png)

![](./images/2019-06-16_115810.png)

![](./images/2019-06-16_120037.png)

![](./images/2019-06-16_120503.png)

![](./images/2019-06-16_120815.png)

![](./images/2019-06-16_120944.png)

## 7、Eclipse中解决冲突

### 7.1、推送到远程库

![](./images/2019-06-16_122125.png)

![](./images/2019-06-16_122254.png)

![](./images/2019-06-16_122329.png)

![](./images/2019-06-16_122414.png)

![](./images/2019-06-16_122456.png)

### 7.2、推送另一个工程的文件

![](./images/2019-06-16_122754.png)

![](./images/2019-06-16_122853.png)

**推送失败，需要重新拉取**

![](./images/2019-06-16_122936.png)

拉取最新的文件

![](./images/2019-06-16_131210.png)

冲突的文件

![](./images/2019-06-16_131338.png)

![](./images/2019-06-16_131535.png)

![](./images/2019-06-16_131750.png)

手动处理冲突的内容

![](./images/2019-06-16_131950.png)

提交到本地库

![](./images/2019-06-16_132152.png)

再的推送到远程库

![](./images/2019-06-16_132608.png)

# 八、Git工作流

## 1、概念

在项目开发过程中使用Git的方式

## 2、分类

### 2.1、集中式工作流

像SVN一样，集中式工作流以中央仓库作为项目所有修改的单点实体。所有修改都提交到Master这个分支上。

这种方式与SVN的方式区别就是开发人员有本地库。Git很多特性并没有用到。

![](./images/2019-06-16_133423.png)

### 2.2、GitFlow工作流

GitFlow工作流通过为功能开发，发布准备和维护设立了独立的分支，让发布迭代过程更流畅。严格的分支模型也为大型项目提供了一些非常必要的结构。

![](./images/2019-06-16_133126.png)

### 2.3、Forking工作流

Forking工作流是在GitFlow基础上，充分利用Git的Fork和pull request的功能以达到代码审核的目的。更适合安全可靠地管理大团队的开发者。而且能接受不信任贡献者的提交。

![](./images/2019-06-16_133603.png)

## 3、GitFlow工作流详解

### 3.1、分支各类

- 主干分支master

主要负责管理正在运行的生产环境的代码。永远保持与正在运行的生产环境完全一致。

- 开发分支 develop

主要负责管理正在开发过程中的代码。一般情况下应该是最新的代码。

- bug修理分支 hotfix

主要负责管理生产环境下出现的紧急修复的代码。从主干分支分出，修理完毕并测试上结后，并回主干分支。并回后，视情况可以删除该分支。

- 准生产分支(预发布分支) release

较大的版本上线前，会从开发分支中分现准生产分支，进行最后阶段的集成测试。该版本上线后，会合并到主干分支。生产环境运行一段阶段稳定后可以视情况删除。

- 功能分支 feature

为了不影响较短周期的开发工作，一般把中长期开发模块，会从开发分支中独立出来。开发完成后合并到开发分支。

### 3.2、GitFlow工作流举例

![](./images/2019-06-16_140725.png)

### 3.3、GitFlow实战

- 创建分支

![](./images/2019-06-16_141208.png)

![](./images/2019-06-16_141334.png)

![](./images/2019-06-16_142016.png)

![](./images/2019-06-16_142131.png)

![](./images/2019-06-16_142214.png)

![](./images/2019-06-16_142254.png)

![](./images/2019-06-16_142334.png)

其他团队成员拉取分支，先执行pull 

**切换分支**

![](./images/2019-06-16_142624.png)

![](./images/2019-06-16_142847.png)

![](./images/2019-06-16_143019.png)

![](./images/2019-06-16_143140.png)

**切换回 master**

![](./images/2019-06-16_143343.png)

**合并分支**

![](./images/2019-06-16_143444.png)

![](./images/2019-06-16_143544.png)

![](./images/2019-06-16_143750.png)

**合并完后，推送master到远程仓库**

![](./images/2019-06-16_143946.png)