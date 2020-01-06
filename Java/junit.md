# Junit4

## 1、依赖

```xml
<dependency>
    <groupId>junit</groupId>
    <artifactId>junit</artifactId>
    <version>4.13</version>
    <scope>test</scope>
</dependency>
```

## 2、测试

```java
public class TestApplication {
	@Test
	public void myFirstTest() {
		System.out.println("myFirstTest...");
	}
}
```



# Junit 5

## 1、依赖

```xml
	<properties>
		<junit.jupiter.version>5.5.2</junit.jupiter.version>
		<junit.platform.version>1.5.2</junit.platform.version>
	</properties>
	<dependencies>
		<dependency>
			<groupId>org.junit.jupiter</groupId>
			<artifactId>junit-jupiter-engine</artifactId>
			<version>${junit.jupiter.version}</version>
			<scope>test</scope>
		</dependency>
		<dependency>
			<groupId>org.junit.platform</groupId>
			<artifactId>junit-platform-runner</artifactId>
			<version>${junit.platform.version}</version>
			<scope>test</scope>
		</dependency>
	</dependencies>
```

## 2、测试

```java
@RunWith(JUnitPlatform.class)
public class TestApplication {
  
	/**
	 * JUnit 5不再需要手动将测试类与测试方法为public，包可见的访问级别就足够了。
	 */
    @Test
    @DisplayName("My First Test")
    void myFirstTest() {
      	System.out.println("myFirstTest...");
    }
}
```

