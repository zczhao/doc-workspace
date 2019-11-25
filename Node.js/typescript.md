# 一、Typescript安装&编译

## 1、环境安装&手动命令编译

```shell
# 安装
npm install -g typescript

# 编译
tsc index.ts
```

## 2、Typescript 开发工具 vscode 自动编译 .ts 文件

### 2.1、创建 tsconfig.json 文件

```shell
# 生成配置文件
tsc --init
```

### 2.2、点击菜单 Terminal -> Run Task... -> tsc: watch - tsconfig.json

解决vscode "因为在此系统上禁止运行脚本"报错，解决办法：

```
以管理员身份运行vscode
执行：get-ExecutionPolicy，显示Restricted，表示状态是禁止的
执行：set-ExecutionPolicy RemoteSigned
这时再执行get-ExecutionPolicy，就显示RemoteSigned
```

vscode 在任务栏图标显示异常问题，解决办法：

```
在任务栏右键，点击 Visual Studio Code，然后找到vscode安装目录下Code.exe即可。
```

tsconfig.json

```json
// 设置输出目录
"outDir": "./js"
```

# 二、Typescript中的数据类型

typescrip 中为了使编译的代码更规范，更有利于维护，增加了类型校验，在 typescript 中主要提供了以下数据类型

```
布尔类型 boolean
数字类型 number
字符串类型 string
数组类型 array
元组类型 tuple
枚举类型 enum
任意类型 any
null 和 undefined
void 类型
never 类型
```

# 三、Typescript中的函数

# 四、Typescript中的类