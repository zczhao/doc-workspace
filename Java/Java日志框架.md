# Java常用日志框架介绍

## Java日志概述

对于一个应用程序来说日志记录是必不可少的一部分。线上问题追踪，基于日志的业务逻辑统计分析等都离不日志。java领域存在多种日志框架，目前常用的日志框架包括Log4j 1，Log4j 2，Commons Logging，Slf4j，Logback，Jul。

## Java常用日志框架类别

- **Log4j** Apache Log4j是一个基于Java的日志记录工具。它是由Ceki Gülcü首创的，现在则是Apache软件基金会的一个项目。 Log4j是几种Java日志框架之一。

- **Log4j 2** Apache Log4j 2是apache开发的一款Log4j的升级产品。

- **Commons Logging** Apache基金会所属的项目，是一套Java日志接口，之前叫Jakarta Commons Logging，后更名为Commons Logging。

- **Slf4j** 类似于Commons Logging，是一套简易Java日志门面，本身并无日志的实现。（Simple Logging Facade for Java，缩写Slf4j）。

- **Logback** 一套日志组件的实现(Slf4j阵营)。

- **Jul** (Java Util Logging),自Java1.4以来的官方日志实现。

看了上面的介绍是否会觉得比较混乱，这些日志框架之间有什么异同，都是由谁在维护，在项目中应该如何选择日志框架，应该如何使用? 下文会逐一介绍。

## Java常用日志框架历史

- 1996年早期，欧洲安全电子市场项目组决定编写它自己的程序跟踪API(Tracing API)。经过不断的完善，这个API终于成为一个十分受欢迎的Java日志软件包，即Log4j。后来Log4j成为Apache基金会项目中的一员。

- 期间Log4j近乎成了Java社区的日志标准。据说Apache基金会还曾经建议Sun引入Log4j到java的标准库中，但Sun拒绝了。


- 2002年Java1.4发布，Sun推出了自己的日志库JUL(Java Util Logging),其实现基本模仿了Log4j的实现。在JUL出来以前，Log4j就已经成为一项成熟的技术，使得Log4j在选择上占据了一定的优势。

- 接着，Apache推出了Jakarta Commons Logging，JCL只是定义了一套日志接口(其内部也提供一个Simple Log的简单实现)，支持运行时动态加载日志组件的实现，也就是说，在你应用代码里，只需调用Commons Logging的接口，底层实现可以是Log4j，也可以是Java Util Logging。


- 后来(2006年)，Ceki Gülcü不适应Apache的工作方式，离开了Apache。然后先后创建了Slf4j(日志门面接口，类似于Commons Logging)和Logback(Slf4j的实现)两个项目，并回瑞典创建了QOS公司，QOS官网上是这样描述Logback的：The Generic，Reliable Fast&Flexible Logging Framework(一个通用，可靠，快速且灵活的日志框架)。


- 现今，Java日志领域被划分为两大阵营：Commons Logging阵营和Slf4j阵营。
  Commons Logging在Apache大树的笼罩下，有很大的用户基数。但有证据表明，形式正在发生变化。2013年底有人分析了GitHub上30000个项目，统计出了最流行的100个Libraries，可以看出Slf4j的发展趋势更好：

  ![](imgs/java_populor_jar.png)

  - Apache眼看有被Logback反超的势头，于2012-07重写了Log4j 1.x，成立了新的项目Log4j 2, Log4j 2具有Logback的所有特性。



  ## java常用日志框架关系

  - Log4j 2与Log4j 1发生了很大的变化，Log4j 2不兼容Log4j 1。


  - Commons Logging和Slf4j是日志门面(门面模式是软件工程中常用的一种软件设计模式，也被称为正面模式、外观模式。它为子系统中的一组接口提供一个统一的高层接口，使得子系统更容易使用)。Log4j和Logback则是具体的日志实现方案。可以简单的理解为接口与接口的实现，调用者只需要关注接口而无需关注具体的实现，做到解耦。


  - 比较常用的组合使用方式是Slf4j与Logback组合使用，Commons Logging与Log4j组合使用。


  - Logback必须配合Slf4j使用。由于Logback和Slf4j是同一个作者，其兼容性不言而喻。

## Commons Logging与Slf4j实现机制对比

### Commons Logging实现机制

Commons Logging是通过动态查找机制，在程序运行时，使用自己的ClassLoader寻找和载入本地具体的实现。详细策略可以查看commons-logging-*.jar包中的org.apache.commons.logging.impl.LogFactoryImpl.java文件。由于Osgi不同的插件使用独立的ClassLoader，Osgi的这种机制保证了插件互相独立, 其机制限制了Commons Logging在Osgi中的正常使用。

### Slf4j实现机制

Slf4j在编译期间，静态绑定本地的Log库，因此可以在Osgi中正常使用。它是通过查找类路径下org.slf4j.impl.StaticLoggerBinder，然后在StaticLoggerBinder中进行绑定。

## 项目中选择日志框架选择

如果是在一个新的项目中建议使用Slf4j与Logback组合，这样有如下的几个优点。

- Slf4j实现机制决定Slf4j限制较少，使用范围更广。由于Slf4j在编译期间，静态绑定本地的LOG库使得通用性要比Commons Logging要好。

- Logback拥有更好的性能。Logback声称：某些关键操作，比如判定是否记录一条日志语句的操作，其性能得到了显著的提高。这个操作在Logback中需要3纳秒，而在Log4J中则需要30纳秒。LogBack创建记录器（logger）的速度也更快：13毫秒，而在Log4J中需要23毫秒。更重要的是，它获取已存在的记录器只需94纳秒，而Log4J需要2234纳秒，时间减少到了1/23。跟JUL相比的性能提高也是显著的。
- Commons Logging开销更高

```java
// 在使Commons Logging时为了减少构建日志信息的开销，通常的做法是
if(log.isDebugEnabled()){
  log.debug("User name： " +
    user.getName() + " buy goods id ：" + good.getId());
}

// 在Slf4j阵营，你只需这么做：
log.debug("User name：{} ,buy goods id ：{}", user.getName(),good.getId());

// 也就是说，Slf4j把构建日志的开销放在了它确认需要显示这条日志之后，减少内存和Cup的开销，使用占位符号，代码也更为简洁
```

- Logback文档免费。Logback的所有文档是全面免费提供的，不象Log4J那样只提供部分免费文档而需要用户去购买付费文档。

## Slf4j用法

### Slf4j与其它日志组件的关系说明

- Slf4j的设计思想比较简洁，使用了Facade设计模式，Slf4j本身只提供了一个slf4j-api-version.jar包，这个jar中主要是日志的抽象接口，jar中本身并没有对抽象出来的接口做实现。

- 对于不同的日志实现方案(例如Logback，Log4j...)，封装出不同的桥接组件(例如logback-classic-version.jar，slf4j-log4j12-version.jar)，这样使用过程中可以灵活的选取自己项目里的日志实现。

### Slf4j与其它日志组件调用关系图

![](imgs/slf4j-bind.png)

### Slf4j与其他各种日志组件的桥接说明

| jar包名                                                      | 说明                                                         |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| **slf4j-log4j12-1.7.13.jar**                                 | Log4j1.2版本的桥接器，你需要将Log4j.jar加入Classpath。       |
| **slf4j-jdk14-1.7.13.jar**                                   | java.util.logging的桥接器，Jdk原生日志框架。                 |
| **slf4j-nop-1.7.13.jar**                                     | NOP桥接器，默默丢弃一切日志。                                |
| **slf4j-simple-1.7.13.jar**                                  | 一个简单实现的桥接器，该实现输出所有事件到System.err. 只有Info以及高于该级别的消息被打印，在小型应用中它也许是有用的。 |
| **slf4j-jcl-1.7.13.jar**                                     | Jakarta Commons Logging 的桥接器. 这个桥接器将Slf4j所有日志委派给Jcl。 |
| **logback-classic-1.0.13.jar(requires logback-core-1.0.13.jar)** | Slf4j的原生实现，Logback直接实现了Slf4j的接口，因此使用Slf4j与Logback的结合使用也意味更小的内存与计算开销 |

具体的接入方式参见下图

![](imgs/slf4j-concrete-bindings1.png)

## Slf4j源码分析

[参考](https://www.cnblogs.com/chenhongliang/p/5312517.html)

# log4j

## log4j、slf4j整合

### 1､pom.xml

```xml
<dependency>
    <groupId>log4j</groupId>
    <artifactId>log4j</artifactId>
    <version>1.2.17</version>
</dependency>

<dependency>
    <groupId>org.slf4j</groupId>
    <artifactId>slf4j-log4j12</artifactId>
    <version>1.7.25</version>
</dependency>
```

### 2､log4j.properties

```properties
### 日志输出级别：ALL < DEBUG < INFO < WARN < ERROR < FATAL < OFF  ###
##    1>rootLogger是根目录的Logger,每一个项目的classpath就是根目录
##    2>只要运行到输出日志的位置，并且日志的级别大于debug就会输出
##    3>rootLogger表示的就是执行的做生意一个类只要有大于debug的日志就会输出，会调用stdout这个appender输出
log4j.rootLogger=ALL, stout, fout

### 输出信息到控制台 ###
## 1.首先创建appender
#### 1>创建一个appender名称为Console,使用类型为ConsoleAppender
log4j.appender.stout=org.apache.log4j.ConsoleAppender
## 2.说明展示的布局
#### 1>说明appender使用哪种布局来展示，常用的是PatternLayout来展示
log4j.appender.stout.layout=org.apache.log4j.PatternLayout

## 3.说明以什么样的格式来展示
#### ConversionPattern:
# %m 输出代码中指定的消息
# %p 输出优先级，即DEBUG，INFO，WARN，ERROR，FATAL
# %r 输出自应用启动到输出该log信息耗费的毫秒数
# %c 输出所属的类目，通常就是所在类的全名
# %t 输出产生该日志事件的线程名
# %n 输出一个回车换行符，Windows平台为“rn”，Unix平台为“n”
# %d 输出日志时间点的日期或时间，默认格式为ISO8601，也可以在其后指定格式，比如：%d{yyyy MMM dd HH:mm:ss,SSS}，输出类似：2002年10月18日 ：10：28，921
# %l 输出日志事件的发生位置，包括类目名、发生的线程，以及在代码中的行数。
# %%： 输出一个"%"字符
# %F： 输出日志消息产生时所在的文件名称
# %L： 输出代码中的行号
# %x： 输出和当前线程相关的NDC(嵌套诊断环境)，尤其用到像java servlets这样的多客户多线程的应用中

# 可以在%与模式字符之间加上修饰符来控制其最小宽度，最大宽度，和文本的对齐方式，如：
# 1)%20c:指定输出category的名称，最小的宽度是20，如果category的名称小于20的话，默认的情况下右对齐
# 2)%-20c:指定输出category的名称，最小的宽度是20，如果category的名称小于20的话，"-"号指定左对齐
# 3)%.30c:指定输出category的名称，最小的宽度是30，如果category的名称大于30的话，就会将左边多出的字符截掉，但小于30的话也不会有空格
# 4)%20.30c:指定category的名称小于20就补空格，并且右对齐，如果名称长于30字符，就从左边超出的字符截掉
log4j.appender.stout.layout.ConversionPattern=[%-5p] %-d{yyyy-MM-dd HH:mm:ss} %C.%M() (%F:%L): %m%n

### 输出信息到文件中 ###
#1.使用FileAppender输出到文件中
log4j.appender.fout = org.apache.log4j.FileAppender
#2.输出文件的位置
log4j.appender.fout.File = logs/log4j.log
log4j.appender.fout.layout = org.apache.log4j.PatternLayout
log4j.appender.fout.layout.ConversionPattern =[%-5p] %-d{yyyy-MM-dd HH:mm:ss} %C.%M() (%F:%L): %m%n
```

### 3､TestLog.java

```java
package log;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class TestLog {

	final static Logger log = LoggerFactory.getLogger(TestLog.class);

	public static void main(String[] args) {
		/**
		 * 可以为日志设定不同的级别
		 * debug<info<warn<error<fatal
		 */
		log.trace("trace...");
		log.debug("debug...");
		log.info("info...");
		log.warn("warn...");
		log.error("error...");
		//log.fatal("fatal...");
	}
}

```

## log4j、slf4j区别

- log4j 提供 TRACE, DEBUG, INFO, WARN, ERROR 及 FATAL 六种纪录等级，但是 SLF4J 认为 ERROR 与 FATAL 并没有实质上的差别，所以拿掉了 FATAL 等级，只剩下其他五种。

- log4j间接的在鼓励程序员使用string相加的写法，而slf4j就不会有这个问题 ,你可以使用：

```java
logger.error("{} is+userid", userid);
```

- 使用slf4j可以方便的使用其提供的各种集体的实现的jar。

- 提供字串内容替换的功能，会比较有效率，说明如下：

```java
// 传统的字符串产生方式，如果没有要记录Debug等级的信息，就会浪费时间在产生不必要的信息上 
logger.debug("There are now " + count + " user accounts: " + userAccountList); 

// 为了避免上述问题，我们可以先检查是不是开启了Debug信息记录功能，只是程序的编码会比较复杂 
if (logger.isDebugEnabled()) { 
    logger.debug("There are now " + count + " user accounts: " + userAccountList); 
} 

// 如果Debug等级没有开启，则不会产生不必要的字符串，同时也能保持程序编码的简洁
logger.debug("There are now {} user accounts: {}", count, userAccountList);
```

## 日志信息的优先级

ALL < DEBUG < INFO < WARN < ERROR < FATAL < OFF

## appender输出类型配置

Log4j官方的appender给出了一下几种实现：

- org.apache.log4j.ConsoleAppender（控制台）
- org.apache.log4j.FileAppender（文件）
- org.apache.log4j.DailyRollingFileAppender（每天产生一个日志文件）
- org.apache.log4j.RollingFileAppender（文件大小到达指定尺寸的时候产生一个新的文件）
- org.apache.log4j.WriterAppender（将日志信息以流格式发送到任意指定的地方）

**实际开发中使用使用的1,3,4**

### 按给定的日期格式生成日志文件

```properties
log4j.rootLogger=ALL, stout, fout

log4j.appender.stout=org.apache.log4j.ConsoleAppender
log4j.appender.stout.layout=org.apache.log4j.PatternLayout
log4j.appender.stout.layout.ConversionPattern=[%-5p] %-d{yyyy-MM-dd HH:mm:ss} %C.%M() (%F:%L): %m%n

### 输出信息到文件中 ###
#1.使用FileAppender输出到文件中
log4j.appender.fout = org.apache.log4j.DailyRollingFileAppender
#datePattern格式：
#'.'yyyy-MM --->bar.log.2016-03
#'.'yyyy-ww --->bar.log.2016-03 每周
#'.'yyyy-MM-dd --->bar.log.2016-03-08
#'.'yyyy-MM-dd-a --->bar.log.2016-03-08-AM
#'.'yyyy-MM-dd-HH --->bar.log.2016-03-08-10
#'.'yyyy-MM-dd-HH-mm --->bar.log.2016-03-08-10-22
log4j.appender.fout.datePattern = '.'yyyyMMddHHmm
log4j.appender.fout.file = logs/log4j.log
log4j.appender.fout.layout = org.apache.log4j.PatternLayout
log4j.appender.fout.layout.ConversionPattern =[%-5p] %-d{yyyy-MM-dd HH:mm:ss} %C.%M() (%F:%L): %m%n
# ImmediateFlush=true，一旦有新日志写入，立马将日志写入到磁盘的文件中。当日志很多，这种频繁操作文件显然性能很低下。
log4j.appender.fout.ImmediateFlush=true
```

### 按给定的日志文件大小生成日志文件

```properties
log4j.rootLogger=ALL, stout, fout

log4j.appender.stout=org.apache.log4j.ConsoleAppender
log4j.appender.stout.layout=org.apache.log4j.PatternLayout
log4j.appender.stout.layout.ConversionPattern=[%-5p] %-d{yyyy-MM-dd HH:mm:ss} %C.%M() (%F:%L): %m%n


log4j.appender.fout = org.apache.log4j.RollingFileAppender
log4j.appender.fout.file = logs/log4j.log
# 日志文件的大小
log4j.appender.fout.MaxFileSize=1KB
# 日志文件的个数，假如超过了，则覆盖
log4j.appender.fout.MaxBackupIndex=3
log4j.appender.fout.layout = org.apache.log4j.PatternLayout
log4j.appender.fout.layout.ConversionPattern =[%-5p] %-d{yyyy-MM-dd HH:mm:ss} %C.%M() (%F:%L): %m%n
```

### 输入日志到数据库表中

```sql
CREATE TABLE `system_log` (
      `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
      `create_time` datetime NOT NULL,
      `log` varchar(200) NOT NULL,
      PRIMARY KEY (`id`)
 );
```

```xml
<dependency>
    <groupId>mysql</groupId>
    <artifactId>mysql-connector-java</artifactId>
</dependency>
```

```properties
log4j.rootLogger=ALL, dbout

# 将log4j的日志配置输出到mysql中,dbout
log4j.appender.dbout = org.apache.log4j.jdbc.JDBCAppender
log4j.appender.dbout.driver = com.mysql.jdbc.Driver
log4j.appender.dbout.URL = jdbc:mysql://10.10.10.137:3306/elastic_db?useUnicode=true
log4j.appender.dbout.user = admin
log4j.appender.dbout.password = richard
log4j.appender.dbout.sql = insert into system_log(create_time,log) VALUES ('%d{yyyy-MM-dd hh:mm:ss}', '%c %p %m %n')
log4j.appender.dbout.layout = org.apache.log4j.PatternLayout
```

## 日志输出格式改为json格式

```xml
<dependency>
    <groupId>net.logstash.log4j</groupId>
    <artifactId>jsonevent-layout</artifactId>
    <version>1.7</version>
</dependency>
```

```properties
log4j.rootLogger=ALL, stout, fout

log4j.appender.stout=org.apache.log4j.ConsoleAppender
log4j.appender.stout.layout=net.logstash.log4j.JSONEventLayoutV1
```

## log4j MDC用户操作日志追踪配置

### 1、MDC介绍

MDC（Mapped Diagnostic Context，映射调试上下文）是 log4j 和 logback 提供的一种方便在多线程条件下记录日志的功能。某些应用程序采用多线程的方式来处理多个用户的请求。在一个用户的使用过程中，可能有多个不同的线程来进行处理。典型的例子是 Web 应用服务器。当用户访问某个页面时，应用服务器可能会创建一个新的线程来处理该请求，也可能从线程池中复用已有的线程。在一个用户的会话存续期间，可能有多个线程处理过该用户的请求。这使得比较难以区分不同用户所对应的日志。当需要追踪某个用户在系统中的相关日志记录时，就会变得很麻烦。

一种解决的办法是采用自定义的日志格式，把用户的信息采用某种方式编码在日志记录中。这种方式的问题在于要求在每个使用日志记录器的类中，都可以访问到用户相关的信息。这样才可能在记录日志时使用。这样的条件通常是比较难以满足的。MDC 的作用是解决这个问题。

MDC 可以看成是一个与当前线程绑定的哈希表，可以往其中添加键值对。MDC 中包含的内容可以被同一线程中执行的代码所访问。当前线程的子线程会继承其父线程中的 MDC 的内容。当需要记录日志时，只需要从 MDC 中获取所需的信息即可。MDC 的内容则由程序在适当的时候保存进去。对于一个 Web 应用来说，通常是在请求被处理的最开始保存这些数据。

### 2、MDC使用案例

相对比较大的项目来说，一般会有多个开发人员，如果每个开发人员凭自己的理解打印日志，那么当用户反馈问题时，很难通过日志去快速的定位到出错原因，也会消耗更多的时间。所以针对这种问题，一般会定义好整个项目的日志格式，如果是需要追踪的日志，开发人员调用统一的打印方法，在日志配置文件里面定义好相应的字段，通过MDC功能就能很好的解决问题。

比如我们可以事先把用户的sessionId，登录用户的用户名，访问的城市id，当前访问商户id等信息定义成字段，线程开始时把值放入MDC里面，后续在其他地方就能直接使用，无需再去设置了。

使用MDC来记录日志，一来可以规范多开发下日志格式的一致性，二来可以为后续使用ELK对日志进行分析。

pom.xml

```xml
<project xmlns="http://maven.apache.org/POM/4.0.0"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/maven-v4_0_0.xsd">
	<modelVersion>4.0.0</modelVersion>
	<groupId>com.zzc</groupId>
	<artifactId>maven-log4j</artifactId>
	<packaging>jar</packaging>
	<version>1.0-SNAPSHOT</version>
	<name>maven-log4j</name>
	<url>http://maven.apache.org</url>
	<dependencies>
		<dependency>
			<groupId>junit</groupId>
			<artifactId>junit</artifactId>
			<version>4.12</version>
			<scope>test</scope>
		</dependency>

		<dependency>
			<groupId>log4j</groupId>
			<artifactId>log4j</artifactId>
			<version>1.2.17</version>
		</dependency>

		<dependency>
			<groupId>org.slf4j</groupId>
			<artifactId>slf4j-log4j12</artifactId>
			<version>1.7.25</version>
		</dependency>
	</dependencies>
</project>
```

log4j.properties

```properties
log4j.rootLogger=ALL, stout, fout

log4j.appender.stout=org.apache.log4j.ConsoleAppender
log4j.appender.stout.layout=org.apache.log4j.PatternLayout
log4j.appender.stout.layout.ConversionPattern= transactionId=[%X{transactionId}] [%-5p] %-d{yyyy-MM-dd HH:mm:ss} %C.%M() (%F:%L): %m%n

log4j.appender.fout = org.apache.log4j.FileAppender
log4j.appender.fout.File = logs/log4j.log
log4j.appender.fout.layout = org.apache.log4j.PatternLayout
log4j.appender.fout.layout.ConversionPattern = transactionId=[%X{transactionId}] [%-5p] %-d{yyyy-MM-dd HH:mm:ss} %C.%M() (%F:%L): %m%n
```

TraceLogger.java

```java
package com.zzc.log;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class TraceLogger {

	private static final Logger TRACE_LOGGER = LoggerFactory.getLogger("traceLog");

	private TraceLogger() {

	}

	public static void info(String message) {
		TRACE_LOGGER.info(message);
	}

	public static void info(String format, Object... arguments) {
		TRACE_LOGGER.info(format, arguments);
	}

}

```

TestLog.java

```java
package com.zzc.test;

import org.junit.Test;
import org.slf4j.MDC;

import com.zzc.log.TraceLogger;

public class TestLog {

	@Test
	public void test01() {
		MDC.clear();
		MDC.put("transactionId", "f9e287fad9e84cff8b2c2f2ed92adbe6");
		TraceLogger.info("测试MDC打印一");

		TraceLogger.info("测试MDC打印二");

		TraceLogger.info("测试MDC打印三");
	}

}

```

```
transactionId=[f9e287fad9e84cff8b2c2f2ed92adbe6] [INFO ] 2019-08-15 22:34:19 com.zzc.log.TraceLogger.info() (TraceLogger.java:15): 测试MDC打印一
transactionId=[f9e287fad9e84cff8b2c2f2ed92adbe6] [INFO ] 2019-08-15 22:34:19 com.zzc.log.TraceLogger.info() (TraceLogger.java:15): 测试MDC打印二
transactionId=[f9e287fad9e84cff8b2c2f2ed92adbe6] [INFO ] 2019-08-15 22:34:19 com.zzc.log.TraceLogger.info() (TraceLogger.java:15): 测试MDC打印三
```

# log4j2

## log4j2､slf4j整合

### 1､pom.xml

```xml
<!-- log4j2 -->
<dependency>
    <groupId>org.apache.logging.log4j</groupId>
    <artifactId>log4j-core</artifactId>
    <version>2.11.1</version>
</dependency>

<!--用于slf4j与log4j2保持桥接 -->
<dependency>
    <groupId>org.apache.logging.log4j</groupId>
    <artifactId>log4j-slf4j-impl</artifactId>
    <version>2.11.1</version>
</dependency>

<!-- 用于解决web环境下关闭服务器时可能出现的log4j线程无法及时关闭的warn，web工程需要包含log4j-web，非web工程不需要 -->
<dependency>
    <groupId>org.apache.logging.log4j</groupId>
    <artifactId>log4j-web</artifactId>
    <version>2.11.1</version>
</dependency>

<!--使用log4j2的AsyncLogger时需要包含disruptor -->
<dependency>
    <groupId>com.lmax</groupId>
    <artifactId>disruptor</artifactId>
    <version>3.4.2</version>
</dependency>
```

### 2､log4j.xml

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!-- 级别：TRACE < DEBUG < INFO < WARN < ERROR < FATAL -->
<Configuration status="WARN">
	<!-- 定义常量 -->
	<properties>
		<property name="LOG_HOME">logs</property>
		<property name="FILE_NAME">mylog</property>
	</properties>

	<Appenders>
		<Console name="Console" target="SYSTEM_OUT">
			<PatternLayout
				pattern="[%-5p] %-d{yyyy-MM-dd HH:mm:ss} %C.%M() (%F:%L): %m%n" />
		</Console>

		<File name="MyFile1" fileName="logs/log4j2File.log">
			<PatternLayout
				pattern="%d{HH:mm:ss.SSS} [%t] %-5level %logger{36} - %msg%n" />
		</File>

		<!-- RollingRandomAccessFile的属性： fileName 指定当前日志文件的位置和文件名称 filePattern
			指定当发生Rolling时，文件的转移和重命名规则 SizeBasedTriggeringPolicy 指定当文件体积大于size指定的值时，触发Rolling
			DefaultRolloverStrategy 指定最多保存的文件个数 TimeBasedTriggeringPolicy : 这个配置需要和filePattern结合使用，注意filePattern中配置的文件重命名规则是${FILE_NAME}-%d{yyyy-MM-dd
			HH-mm}-%i， 最小的时间粒度是mm，即分钟，TimeBasedTriggeringPolicy指定的size是1，结合起来就是每1分钟生成一个新文件。如果改成%d{yyyy-MM-dd
			HH}， 最小粒度为小时，则每一个小时生成一个文件 -->
		<RollingRandomAccessFile name="MyFile2"
			fileName="${LOG_HOME}/${FILE_NAME}.log"
			filePattern="${LOG_HOME}/$${date:yyyy-MM}/${FILE_NAME}-%d{yyyy-MM-dd HH-mm}-%i.log">
			<PatternLayout
				pattern="[%-5p] %-d{yyyy-MM-dd HH:mm:ss} %C.%M() (%F:%L): %m%n" />
			<Policies>
				<TimeBasedTriggeringPolicy interval="1" />
				<SizeBasedTriggeringPolicy size="10 MB" />
			</Policies>
			<DefaultRolloverStrategy max="20" />
		</RollingRandomAccessFile>

		<!-- 按日志级别输出文件 配置Filters来实现 start -->
		<RollingRandomAccessFile name="InfoFile"
			fileName="${LOG_HOME}/info.log"
			filePattern="${LOG_HOME}/$${date:yyyy-MM}/info-%d{yyyy-MM-dd}-%i.log">
			<Filters>
				<ThresholdFilter level="warn" onMatch="DENY"
					onMismatch="NEUTRAL" />
				<ThresholdFilter level="trace" onMatch="ACCEPT"
					onMismatch="DENY" />
			</Filters>
			<PatternLayout
				pattern="[%-5p] %-d{yyyy-MM-dd HH:mm:ss} %C.%M() (%F:%L): %m%n" />
			<Policies>
				<TimeBasedTriggeringPolicy />
				<SizeBasedTriggeringPolicy size="10 MB" />
			</Policies>
			<DefaultRolloverStrategy max="20" />
		</RollingRandomAccessFile>

		<RollingRandomAccessFile name="ErrorFile"
			fileName="${LOG_HOME}/error.log"
			filePattern="${LOG_HOME}/$${date:yyyy-MM}/error-%d{yyyy-MM-dd}-%i.log">
			<Filters>
				<ThresholdFilter level="fatal" onMatch="DENY"
					onMismatch="NEUTRAL" />
				<ThresholdFilter level="warn" onMatch="ACCEPT"
					onMismatch="DENY" />
			</Filters>
			<PatternLayout
				pattern="[%-5p] %-d{yyyy-MM-dd HH:mm:ss} %C.%M() (%F:%L): %m%n" />
			<Policies>
				<TimeBasedTriggeringPolicy />
				<SizeBasedTriggeringPolicy size="10 MB" />
			</Policies>
			<DefaultRolloverStrategy max="20" />
		</RollingRandomAccessFile>

		<RollingRandomAccessFile name="FatalFile"
			fileName="${LOG_HOME}/fatal.log"
			filePattern="${LOG_HOME}/$${date:yyyy-MM}/fatal-%d{yyyy-MM-dd}-%i.log">
			<Filters>
				<ThresholdFilter level="fatal" onMatch="ACCEPT"
					onMismatch="DENY" />
			</Filters>
			<PatternLayout
				pattern="[%-5p] %-d{yyyy-MM-dd HH:mm:ss} %C.%M() (%F:%L): %m%n" />
			<Policies>
				<TimeBasedTriggeringPolicy />
				<SizeBasedTriggeringPolicy size="10 MB" />
			</Policies>
			<DefaultRolloverStrategy max="20" />
		</RollingRandomAccessFile>
		<!-- 按日志级别输出文件 end -->

	</Appenders>
	<Loggers>
		<!-- 自定义Logger -->
		<Logger name="mylog" level="ERROR" additivity="false">
			<AppenderRef ref="MyFile2" />
		</Logger>

		<Root level="trace">
			<AppenderRef ref="Console" />
			<!-- 按日志级别输出文件start -->
			<AppenderRef ref="InfoFile" />
			<AppenderRef ref="ErrorFile" />
			<AppenderRef ref="FatalFile" />
			<!-- 按日志级别输出文件 end -->
		</Root>
	</Loggers>
</Configuration>
```

### 3､TestLog.java

```java
package log;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class TestLog {

	final static Logger log = LoggerFactory.getLogger(TestLog.class);

	public static void main(String[] args) {
		/**
		 * 可以为日志设定不同的级别
		 * debug<info<warn<error<fatal
		 */
		log.trace("trace...");
		log.debug("debug...");
		log.info("info...");
		log.warn("warn...");
		log.error("error...");
		// log.fatal("fatal...");
	}
}
```

# logback

## logback､slf4j整合

### 1､pom.xml

```xml
<dependency>
    <groupId>ch.qos.logback</groupId>
    <artifactId>logback-classic</artifactId>
    <version>1.2.3</version>
</dependency>
```

### 2､logback.xml

```xml
<!--  
 scan:
	当此属性设置为true时，配置文件如果发生改变，将会被重新加载，默认值为true
  scanPeriod:
	设置监测配置文件是否有修改的时间间隔，如果没有给出时间单位，默认单位是毫秒。当scan为true时，此属性生效。默认的时间间隔为1分钟
   debug:
	当此属性设置为true时，将打印出logback内部日志信息，实时查看logback运行状态。默认值为false。	
-->
<configuration scan="true" scanPeriod="60 seconds" debug="false">
	<!--  
		设置变量： <property>
	-->
	<property name="APP_NAME" value="log" /> 
	<!--  
		获取时间戳字符串：<timestamp>
			两个属性 key:标识此<timestamp> 的名字；datePattern：设置将当前时间（解析配置文件的时间）转换为字符串的模式，
		遵循Java.txt.SimpleDateFormat的格式
	-->
	<timestamp key="bySecond" datePattern="yyyyMMdd'T'HHmmss"/>     
	<!--
		<contextName>  
		设置上下文名称
			每个logger都关联到logger上下文，默认上下文名称为“default”。但可以使用<contextName>设置成其他名字，用于区分不同应用程序的记录。
		一旦设置，不能修改。
	-->  
    <contextName>${APP_NAME}</contextName>  
    
    <!--  
    	设置loger:<loger>
    	    用来设置某一个包或者具体的某一个类的日志打印级别、以及指定<appender>。<loger>仅有一个name属性，一个可选的level和一个可选的addtivity属性。

		name:
		用来指定受此loger约束的某一个包或者具体的某一个类。
		
		level:
		用来设置打印级别，大小写无关：TRACE, DEBUG, INFO, WARN, ERROR, ALL 和 OFF，还有一个特俗值INHERITED或者同义词NULL，代表强制执行上级的级别。
		如果未设置此属性，那么当前loger将会继承上级的级别。
		
		addtivity:
		是否向上级loger传递打印信息。默认是true。
		<loger>可以包含零个或多个<appender-ref>元素，标识这个appender将会添加到这个loger
    -->  
    <logger name="jdbc.connection" level="ERROR"/>
    <logger name="jdbc.audit" level="ERROR"/>
    <logger name="jdbc.sqlonly" level="ERROR"/>
    <logger name="jdbc.resultset" level="ERROR"/>
    <logger name="log4jdbc.debug" level="ERROR"/>
 
    <!--  
    	ch.qos.logback.core.ConsoleAppender
    	打印到控制台
    	
    	<appender>:
    		<appender>是<configuration>的子节点，是负责写日志的组件
    		<appender>有两个必要属性name和class。name指定appender名称，class指定appender的全限定名。
    	1.ConsoleAppender:
    		把日志添加到控制台，有以下子节点:
    			<encoder>：对日志进行格式化
    			<target>：字符串 System.out 或者 System.err ，默认 System.out;
    -->  
    <appender name="STDOUT" class="ch.qos.logback.core.ConsoleAppender">  
	    <encoder>  
	    	<pattern>[%-5p] %d{yyyy-MM-dd HH:mm:ss} %replace(%replace(%caller{1}){'Caller\+0\s at\s',''}){'\s',''} %n%msg%n</pattern>
	    </encoder>  
    </appender> 
    
    <!--  
    	2.FileAppender
    		把日志添加到文件，有以下子节点：
    			<file>：被写入的文件名，可以是相对目录，也可以是绝对目录，如果上级目录不存在会自动创建，没有默认值
    			<append>：如果是 true，日志被追加到文件结尾，如果是 false，清空现存文件，默认是true。
    			<encoder>：对记录事件进行格式化
    			<prudent>：如果是 true，日志会被安全的写入文件，即使其他的FileAppender也在向此文件做写入操作，效率低，默认是 false
    	3.RollingFileAppender:
    		滚动记录文件，先将日志记录到指定文件，当符合某个条件时，将日志记录到其他文件。有以下子节点：
    		<file>：被写入的文件名，可以是相对目录，也可以是绝对目录，如果上级目录不存在会自动创建，没有默认值
    		<append>：如果是 true，日志被追加到文件结尾，如果是 false，清空现存文件，默认是true。
    		<encoder>：对记录事件进行格式化。
    		<rollingPolicy>:当发生滚动时，决定 RollingFileAppender 的行为，涉及文件移动和重命名。
    			rollingPolicy:
    				TimeBasedRollingPolicy： 最常用的滚动策略，它根据时间来制定滚动策略，既负责滚动也负责出发滚动。有以下子节点
    					<fileNamePattern>:
    						必要节点，包含文件名及“%d”转换符， “%d”可以包含一个Java.text.SimpleDateFormat指定的时间格式，如：%d{yyyy-MM}。如果直接使用 %d，默认格式是 yyyy-MM-dd
    						RollingFileAppender 的file字节点可有可无，通过设置file，可以为活动文件和归档文件指定不同位置，当前日志总是记录到file指定的文件（活动文件），活动文件的名字不会改变；如果没设置file，活动文件的名字会根据fileNamePattern 的值，每隔一段时间改变一次。“/”或者“\”会被当做目录分隔符
    					<maxHistory>:
    						 可选节点，控制保留的归档文件的最大数量，超出数量就删除旧文件。假设设置每个月滚动，且<maxHistory>是6，则只保存最近6个月的文件，删除之前的旧文件。注意，删除旧文件是，那些为了归档而创建的目录也会被删除。
    						 
    				FixedWindowRollingPolicy：根据固定窗口算法重命名文件的滚动策略。有以下子节点：
    					 <minIndex>:窗口索引最小值
						 <maxIndex>:窗口索引最大值，当用户指定的窗口过大时，会自动将窗口设置为12
						 <fileNamePattern >:
						 	必须包含“%i”例如，假设最小值和最大值分别为1和2，命名模式为 mylog%i.log,会产生归档文件mylog1.log和mylog2.log。还可以指定文件压缩选项，例如，mylog%i.log.gz 或者 没有log%i.log.zip
				triggeringPolicy:
					 SizeBasedTriggeringPolicy： 查看当前活动文件的大小，如果超过指定大小会告知RollingFileAppender 触发当前活动文件滚动。只有一个节点:
					 <maxFileSize>:这是活动文件的大小，默认值是10MB		 	
    						 	
    		<triggeringPolicy >: 告知 RollingFileAppender 合适激活滚动。
    		<prudent>：当为true时，不支持FixedWindowRollingPolicy。支持TimeBasedRollingPolicy，但是有两个限制，1不支持也不允许文件压缩，2不能设置file属性，必须留空。		
    -->
    <appender name="FILE" class="ch.qos.logback.core.FileAppender">
    	<file>logs/logFile.log</file>
    	<append>true</append>
    	<!-- 
    		<encoder>:
    			负责两件事，一是把日志信息转换成字节数组，二是把字节数组写入到输出流
    			目前PatternLayoutEncoder 是唯一有用的且默认的encoder ，有一个<pattern>节点，用来设置日志的输入格式。使用“%”加“转换符”方式，如果要输出“%”，则必须用“\”对“\%”进行转义
    	 -->  
	    <encoder>  
	      <pattern>[%-5level] %d{yyyy-MM-dd HH:mm:ss} [%thread] %logger{36} - %msg%n</pattern>  
	    </encoder>  
    </appender> 
    
    <!-- 每天生成一个日志文件，保存30天的日志文件 -->
    <appender name="ROLLINGFILE" class="ch.qos.logback.core.rolling.RollingFileAppender">
    	<rollingPolicy class="ch.qos.logback.core.rolling.TimeBasedRollingPolicy">
    		<fileNamePattern>logs/logFile.%d{yyyy-MM-dd}.log</fileNamePattern>
    		<maxHistory>30</maxHistory>  
    	</rollingPolicy>  
	    <encoder>  
	      <pattern>[%-5level] %d{yyyy-MM-dd HH:mm:ss} [%thread] %logger{36} - %msg%n</pattern>  
	    </encoder>  
    </appender> 
    
    <!--  
    	name="com.logback.LogbackTest"
    		将控制com.logback.LogbackTest包下的所有类的日志的打印,打印级别为“DEBUG”
    	addtivity，默认为true，将此loger的打印信息向上级传递;为false，表示此loger的打印信息不再向上级传递
    	
    	指定了名字为“STDOUT”的appender
    	
    	*如果将additivity="true"日志将会打印两次,因为打印信息向上级传递，logger本身打印一次，root接到后又打印一次
    -->
    <logger name="com.logback.LogbackTest" level="DEBUG" additivity="false">
    	<appender-ref ref="STDOUT" />
    </logger>

	  <root level="INFO">  
	    <appender-ref ref="STDOUT" />  
	  </root>  
    
</configuration>  
```

### 3､TestLog.java

```java
package log;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class TestLog {

	final static Logger log = LoggerFactory.getLogger(TestLog.class);

	public static void main(String[] args) {
		/**
		 * 可以为日志设定不同的级别
		 * debug<info<warn<error<fatal
		 */
		log.trace("trace...");
		log.debug("debug...");
		log.info("info...");
		log.warn("warn...");
		log.error("error...");
		// log.fatal("fatal...");
	}
}

```

# commons-logging

## 简介

Jakarta  Commons-logging（JCL）是apache最早提供的日志的门面接口。提供简单的日志实现以及日志解耦功能。

JCL能够选择使用Log4j（或其他如slf4j等）还是JDK Logging，但是他不依赖Log4j，JDK Logging的API。如果项目的classpath中包含了log4j的类库，就会使用log4j，否则就使用JDK Logging。使用commons-logging能够灵活的选择使用那些日志方式，而且不需要修改源代码。（类似于JDBC的API接口）

## 原理

JCL有两个基本的抽象类： Log( 基本记录器 ) 和 LogFactory( 负责创建 Log 实例 ) 。当 commons-logging.jar 被加入到 CLASSPATH之后，它会合理地猜测你想用的日志工具，然后进行自我设置，用户根本不需要做任何设置。默认的 LogFactory 是按照下列的步骤去发现并决定那个日志工具将被使用的（按照顺序，寻找过程会在找到第一个工具时中止） :

- 首先在classpath下寻找commons-logging.properties文件。如果找到，则使用其中定义的Log实现类；如果找不到，则在查找是否已定义系统环境变量org.apache.commons.logging.Log，找到则使用其定义的Log实现类；

- 查看classpath中是否有Log4j的包，如果发现，则自动使用Log4j作为日志实现类；

- 否则，使用JDK自身的日志实现类（JDK1.4以后才有日志实现类）；

- 否则，使用commons-logging自己提供的一个简单的日志实现类SimpleLog；

**org.apache.commons.logging.Log 的具体实现有如下**：

---org.apache.commons.logging.impl.Jdk14Logger 　使用 JDK1.4 。

---org.apache.commons.logging.impl.Log4JLogger 　使用 Log4J 。

---org.apache.commons.logging.impl.LogKitLogger    使用 avalon-Logkit 。

---org.apache.commons.logging.impl.SimpleLog 　    common-logging 自带日志实现类。

---org.apache.commons.logging.impl.NoOpLog          common-logging 自带日志实现类。它实现了 Log 接口。 其输出日志的方法中不进行任何操作。



## Commons-logging简单日志实现

### 1､pom.xml

````xml
<dependency>
    <groupId>commons-logging</groupId>
    <artifactId>commons-logging</artifactId>
    <version>1.2</version>
</dependency>
````

### 2､commons-logging.properties

```properties
org.apache.commons.logging.Log=org.apache.commons.logging.impl.SimpleLog
```

### 3､TestLog.java

```java
package log;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

public class TestLog {

	final static Log log = LogFactory.getLog(TestLog.class);

	public static void main(String[] args) {
		log.trace("trace...");
		log.debug("debug...");
		log.info("info...");
		log.warn("warn...");
		log.error("error...");
		log.fatal("fatal...");
	}
}

```

## Commons-logging的解耦功能

### 1､pom.xml

```xml
<dependency>
    <groupId>commons-logging</groupId>
    <artifactId>commons-logging</artifactId>
    <version>1.2</version>
</dependency>

<dependency>
    <groupId>log4j</groupId>
    <artifactId>log4j</artifactId>
    <version>1.2.17</version>
</dependency>
```

### 2､commons-logging.properties

```properties
org.apache.commons.logging.Log=org.apache.commons.logging.impl.Log4JLogger
```

### 3､log4j.properties

```properties
log4j.rootLogger=ALL, stout, fout
log4j.appender.stout=org.apache.log4j.ConsoleAppender
log4j.appender.stout.layout=org.apache.log4j.PatternLayout
log4j.appender.stout.layout.ConversionPattern=[%-5p] %-d{yyyy-MM-dd HH:mm:ss} %C.%M() (%F:%L): %m%n

log4j.appender.fout = org.apache.log4j.FileAppender
log4j.appender.fout.File = logs/log4j.log
log4j.appender.fout.layout = org.apache.log4j.PatternLayout
log4j.appender.fout.layout.ConversionPattern =[%-5p] %-d{yyyy-MM-dd HH:mm:ss} %C.%M() (%F:%L): %m%n
```

4､TestLog.java

```java
package log;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

public class TestLog {

	final static Log log = LogFactory.getLog(TestLog.class);

	public static void main(String[] args) {
		log.trace("trace...");
		log.debug("debug...");
		log.info("info...");
		log.warn("warn...");
		log.error("error...");
		log.fatal("fatal...");
	}
}

```

