# 一、Vue环境准备

## 1、安装node.js

# 二、helloworld

## 1、使用bower安装vue

```shell
[root@localhost ~]# npm install -g bower
[root@localhost ~]# mkdir vue-workspace
[root@localhost ~]# cd vue-workspace/
[root@localhost vue-workspace]# mkdir vue-001-helloworld
[root@localhost vue-workspace]# cd vue-001-helloworld/
[root@localhost vue-001-helloworld]# bower init --allow-root
[root@localhost vue-001-helloworld]# bower install vue --save --allow-root
```

## 2、引入vue.js文件实现helloworld

```html
<!doctype html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<title>vue-001-helloworld</title>
</head>
<body>
	<div id="app">
		<input type="text" v-model="message">
		<p>{{message}}</p>
	</div>
	<script type="text/javascript" src="./bower_components/vue/dist/vue.min.js"></script>
	<script type="text/javascript">
		new Vue({
			el: "#app",
			data: {
				message: "hello vue.js"
			}
		});
	</script>
</body>
</html>
```

## 3、linux启动服务访问

```shell
[root@localhost vue-workspace]# npm install -g anywhere
[root@localhost vue-workspace]# anywhere
Running at http://192.168.156.60:8000/
Also running at https://192.168.156.60:8001/
```

# 三、vue调式工具vue devtools谷歌插件

```shell
[root@localhost ~]# git clone https://github.com/vuejs/vue-devtools
[root@localhost ~]# cd vue-devtools/
[root@localhost vue-devtools]# npm install
[root@localhost vue-devtools]# cd shells/chrome/
# 把persisten改为true
[root@localhost chrome]# vim manifest.json
[root@localhost chrome]# npm run build
[root@localhost chrome]# cd ..
[root@localhost shells]# tar -czvf chrome.tar.gz chrom/*
```

把 chrome.tar.gz下载到本机 -> Chrome浏览器 -> 更多程序 ->拓展程序 -> 加载已解压的扩展程序

注意：引入的是vue.min.js压缩版的js，不能打开vue-devtools