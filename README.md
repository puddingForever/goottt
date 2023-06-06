# 커넥션풀, JDBC드라이버, 마이바티스 구성

### 용어정리

* JDBC(Java DataBase Connectivity)?<br>
데이터베이스와 연동할 수 있게 도와주는 드라이버 <br>
프로그램 내부의 SQL문을 가지고 데이터베이스의 데이터들을 관리할 수 있음 

* 커넥션풀<br>
DB와 연결할 때마다 connection이라는 인스턴스를 생성해야함 <br>
커넥션풀을 사용하면, connection객체를 pool이라는 곳에 넣어서 사용하고 싶을 때마다 가져와서 쓸 수 있음 

* 마이바티스 <br>
프로그램의 객체를 DB와 연동시킬 수 있도록 도와주는 프레임워크 <br>
마이바티스의 #{}를 사용하면 쿼리문에 ?가 생기며, PreparedStatement를 생성하여 파라메터를 바인딩함<br>
따라서 마이바티스를 사용하면 JDBC를 직접 호출하지 않고, Mybatis가 jdbc preparedstatement를 대신 실행함 <br>
하지만 마이바티스는 JDBC가 더 편하게 쓸 수 있도록 도와주는 도구일뿐이지 JDBC자체는 아니라서 반드시 DB와 알맞은 JDBC를 설치해야함

### 사용방법 

#### 커넥션풀
1. 사용하려는 커넥션풀과 jdbc를 pom.xml에 등록 
2. 커넥션풀을 context파일에 bean으로 등록하여 스프링이 쓸 수 있도록 설정
3. 수업에서는 HikariCP를 사용, 이 안에 Ojdbc8 드라이버(오라클 전용 JDBC 드라이버) 정보를 넣어줌
4. 설정된 bean을 datasource 객체에 생성자를 통해 주입
5. 톰캣이 감지할 수 있도록 web.xml에 경로를 적어줌 

#### 마이바티스 
1. 스프링에서는 마이바티스 의존성을 2개 설치해야함 (mybatis , mybatis-config)
2. 컨텍스트에 SqlSessionFactoryBean를 정의하고 dataSource(jdbc정보 들어있음)을 주입 ( SqlSessionFactoryBean는 SqlSession을 생성함. SqlSession은 마이바티스에 정의된 dml문,트랜젝션관리,DB와 연동을 위한 맵퍼를 생성해줌 )
3. 트랜젝션에 더 용이한 SqlSessionTemplate객체에 생성자를 통해 sqlSessionFactoryBean을 주입하여 sqlSession을 생성  
