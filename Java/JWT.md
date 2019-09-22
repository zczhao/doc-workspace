# JWT(JSON Web Token)

Jwt是一种==紧凑==且==自包含==的，用于在多传递JSON对象的技术。传递的数据可以使用数字签名增加其安全性。可以使用HMAC加密算法或RSA公钥/私钥加密方式。

紧凑：数据小，可以通过URL，POST参数，请求头发送。且数据小代表传输速度快。

自包含：使用payload数据块记录用户必要且不隐私的数据，可以有效的减少数据库访问次数，提高代码性能。

JWT一般用于处理==用户身份验证==或==数据信息交换==。

用户身份验证：一旦用户登录，每个后续请求都将包含JWT，允许用户访问该令牌允许的路由、服务和资源。单点登录是当今广泛使用JWT的一项功能，因为它的开销很小，并且能够轻松地跨不同的域使用。

数据信息交换：JWT是一种非常方便的多方传递数据的载体，因为其可以使用数据签名来保证数据的有效性和安全性。

## 1、JWT数据结构

JWT的数据结构是：A.B.C。由字符点"."来分隔三部分数据。

A - header 头信息

B - payload (有效荷载)

C - Signature 签名

### 1.1、Header

数据结构：{"alg":"加密算法名称","typ":"JWT"}

alg是加密算法定义内容，如：HMAC SHA256 或 RSA

typ是token类型，这里固定为JWT

### 1.2、payload

在payload 数据块中一般用于记录实体(通常为用户信息)或其他数据的。主要分为三个部分，分别是：已注册信息(registered claims)，公开数据(public claims)，私有数据(private claims)

payload 中常用信息有：iss(发行者)，exp(到期时间)，sub(主题)，aud(受众)等。前面列举的都是已注册信息。

分开数据部分一般都会在JWT注册表中增加定义。避免和已注册信息冲突。

分开数据和私有数据可以由程序员任意定义。

==注意：即使JWT有签名加密机制，但是payload内容都是明文记录，除非记录的是加密数据，否则不排除泄露隐私数据的可能。不推荐在payload中记录任何敏感数据。==

### 1.3、Signature

签名信息。这是一个由开发者提供的信息。是服务器验证的传递的数据是否有效安全的标准。在生成JWT最终数据的之间。先使用header中定义的加密算法，将header和payload进行加密，并使用点进行连接。如：加密后的haed.加密后的payload。再使用相同的加密算法。对加密后的数据和签名信息进行加密。最终得到结果。

## 2、JWT执行流程

![](./images/jwt-diagram.png)

## 3、token保存位置

注意：使用JWT实现单点登录时，f需要注意token时效性。token是保存在客户端的w令牌数据，如果永久有效，则有被f劫持的可能 。token在设计的时候，可以考虑一次性或一段时间内有效。如果设置有效时长，则需要考虑是否需要刷新token有效期间问题

使用JWT技术生成的token，客户端在保存的时候可以考虑cookie或localStorage。cookie保存方式，可以实现跨域传递数据。localStorage是f域私有的本地存储，无法实现跨域。

## 4、webstorage

webstorage可保存的数据容量为==5M==。且只能存储==字符串数据==。

webstorage分为localStorage和sessionStorage

localStorage的==生命周期是永久的==，关闭页面或浏览器之后 localStorage中的数据也不会消失。localStorage除非主动删除数据，否则数据永远不会消失。

sessionStorage是会话相关的本地存储单元，==生命周期是在仅在当前会话下有效==。
sessionStorage引入了一个"浏览器窗口"的概念，sessionStorage是在同源的窗口中始终存在的数据。只要这个浏览器窗口没有关闭，即使刷新页面或进入同源另一个页面，数据依然存在。但是sessionStorage在关闭了浏览器窗口后就会被销毁。同时独立的打开同一个窗口同一个页面，sessionStorage也是不一样的。