# Ajax 댓글 구현  

### 새로운 용어정리 

* REST ?<br>
'Representational State Transfer'의 약어로, 하나의 URI는 하나의 고유한 리소스를 대표하도록 설계된다는 개념과 전송방식을 결합해서, 원하는 작업을 지정하는 표현 방법 <br>
<strong>[예시]</strong>
```
myboard/detail?bno=123
```
myboard/detail경로의 게시글번호 123이라는 고유한 의미를 가지도록 설계하고 , 이에대한 처리는 GET,POST방식과 같이 추가적인 정보를 통해서 결정함 <br>

POST : 생성 (CREATE) <br>
GET : 조회 (READ) <br>
PUT 또는 PATCH : 수정(UPDATE) <br>
DELETE : 삭제(DELETE) <br>


<strong>REST 방식의 데이터 전송처리 어노테이션 사용시 주의점</strong>

* <strong>@RequestBody</strong>는 전달된 브라우저 요청(request)의 내용(body)을 이용해서 해당 파라미터의 타입으로 반환을 요구함. 대부분 웹 브라우저에서 전송된 JSON데이터를 원하는 타입의 객체로 변환해야하는 경우에 사용<br>
<strong>@RequestBody는 GET방식의 메소드에서는 사용할 수 없음</strong> POST,DELETE,PUT만 가능
* <strong>@PathVariable</strong>은 URL경로에 있는 값을 파라미터로 추출할 떄 사용. <strong>일반 컨트롤러에서도 사용이 가능함 ! </strong> <br>
<strong>값을 파라미터로 정의할 때 파라미터의 유형은 int,double과 같은 기본 자료형은 사용할 수 없음 int->Integer(하지만 int 되긴함.. 내부적으로 캐스팅됨)</strong>



### 새로 알게된 점 

* 데이터베이스의 설계시 고려사항
1. 기본키를 bno와 rno 컬럼을 가진 복합인덱스를 사용함 <br>
<strong>복합인덱스?</strong> <br>
인덱스를 생성하면 데이터의 ROWID와 인덱스로 지정된 컬럼이 정렬되어서 별도의 공간에 저장된다.<br>
인덱스 영역은 데이터가 이미 정렬되어 있어서 아주 빠르게 검색이 가능하며, 인덱스의 ROWID와 테이블의 ROWID를 연결하여 데이터를 가져온다.<br>
1개의 컬럼으로 인덱스를 구성하는 경우도 있지만 , 실습에서는 2개의 컬럼으로 인덱스를 구성함. 이를 복합인덱스라고 함 !<br>

```
-- 기본키 제약조건이 사용할 복합 인덱스 생성
CREATE INDEX book_ex.idx_myreply_bno_rno ON book_ex.tbl_myReply(bno,rno);

--기본키 제약조건
ALTER TABLE book_ex.tbl_myReply
ADD CONSTRAINT pk_myreply PRIMARY KEY(bno,rno)
USING INDEX book_ex.idx_myreply_bno_rno;
```
2. 댓글 테이블의 bno는 myboard.bno를 참조함 ! (bno ---> myboard.bno, 게시물 삭제시 관련댓글 모두 삭제) 

```
ALTER TABLE book_ex.tbl_myreply
ADD CONSTRAINT fk_bno_reply_board FOREIGN KEY (bno)
     REFERENCES book_ex.tbl_myBoard(bno) ON DELETE CASCADE;
```

3. prno ===> myreply.rno 참조 (댓글의 답글 관계! 답글이 달리면 , prno가 생김(부모키)<br>
참조하는 기본키가 bno,rno로 구성되있으므로, 동일하게 bno,prno로 지정해야함 <br>
부모 댓글 삭제 시 자식 댓글 모두 삭제(ON DELETE CASCADE)
```
 ALTER TABLE book_ex.tbl_myreply
 ADD CONSTRAINT fk_bno_prno_myreply FOREIGN KEY (bno,prno)
      REFERENCES book_ex.tbl_myreply(bno,rno) on DELETE CASCADE;
```

* 댓글의 답글을 편하게 보기위해 계층쿼리를 이용

MyReplyVO<br>
```
@Data
public class MyReplyVO{
  private long bno;
  private long rno;
  private String rcontent;
  private String rwriter;
  private Timestamp rregDate;
  private Timestamp rmodDate;
  private long prno;
  private int lvl; // 계층쿼리의 level값을 저장할 필드 
}
```

MyReplyMapper.xml

```xml
<select id="selectMyReplyList" resultType="MyReplyVO">
  <![CDATA[
    SELECT bno,rno,rcontent,rwriter,rregDate,rmodDate,prno,LEVEL AS lvl
    FROM (SELECT /*+ INDEX_ASC (a IDX_MYREPLY_BNO_RNO) */) *
          FROM book_ex.tbl_myreply
          WHERE bno = #{bno} ) a
     START WITH prno IS NULL
     CONNECT BY PRIOR rno = prno
  ]]>
  
</selct>
```

오라클 계층쿼리? <br>
한테이블에 레코드들이 계층관계(상위,하위)를 이루며 존재할 때, 이 관계에 따라 레코드를 계층관계(상위,하위) 한 구조로 데이터를 나열한 것을 말함!<br>

![image](https://github.com/puddingForever/goottt/assets/126591306/47f6b762-b691-46ed-bf96-95e271033831) <br>
트리모델<br>
![image](https://github.com/puddingForever/goottt/assets/126591306/764bf76b-2988-4b92-b7b7-0099b7ea45f9)
<br>
사진을 보면 King은 그 어느 곳에도 소속되어있지 않음 !  level 1 가장 상위권 ! <br>
Jones와 Blake, Clark 은 King에 종속되있음 ! level 2 <br>
Scott,Ford는 Jones에 종속되있고 , Miller는 Clark에 종속되있음 ! level 3 <br>
이런식으로 계층관계를 형성한 것을 보여주는 컬럼을 level이라고 함 ! 

사진출처 : https://o7planning.org/11049/oracle-hierarchical-query <br>

댓글 계층쿼리 분석 <br>
![image](https://github.com/puddingForever/goottt/assets/126591306/20fe5ed2-bc49-4d83-9dfb-b4c37b15f10e)

![image](https://github.com/puddingForever/goottt/assets/126591306/512a22bc-a293-4720-b491-40a28bb7d1ef)



START WITH : 트리 구조의 최상위 행! 여기서는 prno 가 null인것부터 시작 <br>
CONNECT BY : 연결고리를 만듬 , PRIOR 연산자로 계층구조를 표현할 수 있음<br>
START WITH를 통해 prno 값이 null인 행이 최상위 행으로 선정되었음<br>
CONNECT BY PRIOR rno = prno :  prno 의 값이 null 인 것을 먼저 찾고 (start with) 그 다움부터는 rno를 기준으로 찾음 !<br>
따라서 prno null값인 rno 1번을 찾은 후 , rno를 참조하는 prno의 값을 찾음 <br>
이런식으로 rno의 값을 참조하는 prno의 값의 순서대로 계층쿼리의 데이터가 완성됨 <br>
<br>
<br>

* 댓글 ajax사용시 자바스크립트의 클로저이용 <br>
<strong>클로저?</strong> <br>
간단히 말하면 함수 내부에 있는 값들이, 함수가 종료된 후에도 유지되는 함수를 클로저라고 함
<strong>[예시]</strong>
```
var counter = 
  ( function(){
      var privateCounter = 0; // private , 외부접근 불가 
      function changeCounter(val){ //private 함수 (외부접근 불가)
      privateCounter += val}
      }
      return { // public 함수를 가지는 객체를 반환 (클로저!) 
          inc : function(){
                changeCounter(1);
            },
          dec : function(){
            changeCounter(-1);
          },
          val:function(){
            return privateCounter;
          };//반환되는 객체 
    })();
    
   counter.inc(); // privateCounter== 1 
   counter.inc(); // privateCounter== 2
   counter.dec();// privateCounter== 1 
   
```
지역변수인 privateCounter를 counter.inc()나 counter.dec() 를 이용하여 값에 접근할 수 있으며, 함수가 종료된 후에도 값이 유지됨  <br>
클로저 함수를 여러개 보낼 때 익명함수 객체 안에 넣어서 보낼 수 있음 <br>
counter() 뒤에 ()<--- 이게 하나 더 있는데 이는 <strong>즉시호출 함수 패턴</strong>을 말하며 , 정의 동시에 한번만 즉시 실행됨 ,인자를 통해 값을 보낼 수도 있음 <br>
댓글 ajax도 클로저를 이용 <br>
mycomment.js<br>
```

var myCommentClsr = ( function(){
  function getCmtList(pagingParams,callback,error){ //callback : 서버 처리 성공시 실행함수 
    var bno = pagingParams.bno;
    var page = pagingParams.page || 1;
    
    $.ajax({
          type:'get',
          url:'spring/replies/pages/'+bno+"/"+page,
          dataType:'json', // 서버로부터 받는 데이터
          success:function(replyPagingCreator,status,xhr){
              if(callback){ //callback함수가 매개변수에 있으면 참 
                  callback(replyPagingCreator);
              }
          },
          error: function(xhr,status,er){
                if(error){
                    error(er);
                }
          }
    }) // end-ajax
   
  } // end-getCmtList
    return {
      getCmtList : getCmtList
    };
})();
```
rest 요청 ajax함수를 호출하는 함수를 만들어서 추가해주면 됨 ! 




