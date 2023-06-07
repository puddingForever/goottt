# 페이지네이션

### 핵심정리

* 페이징기능을 사용할 시 두가지를 명시해야함 
1. 서버에서 화면에 표시되는 데이터를 가져오기 위한 페이징 처리
2. 화면에서의 페이징 처리 
* 1번의 기능 구현을 위한 데이터 
1. 페이지 번호, 페이지당 표시되는 항목의 개수 
* 2번의 기능 구현을 위한 데이터 
1. 페이지 번호, 페이지당 표시되는 항목의 개수 
2. 한 화면에 표시되는 시작 페이징 번호와 끝 페이징 번호 
3. 한 화면에 표시되는 페이징 번호의 개수
4. 이전/다음 표시 여부 지정값 
5. 마지막 페이지에 표시되는 마지막 페이징 번호 
6. 마지막 페이징 번호를 구하기 위해선 데이터베이스로부터 게시물의 총 수를 구해와야함
* 페이징기능은 비지니스 처리와는 관련이 없고, 화면에서의 표시기능만 구현한 것이기 때문에 DTO로 만들어줌 
* 페이징 기본값과 화면에서 페이지 구현시에 필요한 모든 값들을 서버에서 브라우저로 전송해서 화면에서 이를 이용하여 표시 구현함 


### 새로 알게된 점 
* 데이터 검색 속도를 향상시키기 인덱스 사용 <br>
<strong>[예시]</strong>
```xml
<select id="selectMyBoardList" resultType="com.goott.spring.domain.MyBoardVO">
<![CDATA[
    SELECT bno, btitle, bcontent, bwriter, bmodDate, bviewsCnt,bregCnt,bdelFlag
    FROM ( SELECT /*+ INDEX_DESC (a pk_myboard) */ ROWNUM rn, a.*
            FROM book_ex.tbl_myboard a
            WHERE ROWNUM <= (#{pageNum} * #{rowAmountPerPage})
          )
    WHERE rn >= ((#{pageNum}*#{rowAmountPerPage})-(#{rowAmountPerPage}-1))
]]>  
```
/*+  */ : 인덱스 사용명시 <br>
INDEX_DESC : 인덱스 힌트 (INDEX나 INDEX_ASC 로 적으면 오름차순!) <br>
a : 테이블 별칭 <br>
pk_myboard : 사용하는 인덱스명 <br>
인덱스를 사용해서 rownum 값을 주는 sql문이다. 이때 from 절에 rownum 최대값을 명시하고 밖의 where절에 최소값을 명시해야한다


* 맨 마지막 페이지번호는 실제 게시물의 총수를 기준으로 구해진 마지막 페이지를 사용해야함 <br>
끝 페이징번호 (시작페이징번호를 위해서 만듬) : (int) (Math.ceil(선택된 페이지번호/ ((double)페이징번호 개수 ))) * 페이징번호개수 <br>
시작 페이징번호 : 끝 페이징 번호 - (페이징번호 개수 -1) <br>
실제 마지막 페이징 번호 : (int) (Math.ceil(전체 게시물 총수 / ((double)페이지당 표시되는 행수))) <br>
실제 마지막 페이징 번호를 구하기 위하여 전체 게시물의 수를 구하는 sql문을 작성 <br>
<strong>[예시]</strong> <br>
```xml
<select id="selectRowAmountTotal" resultType="long">
  <![CDATA[
      SELECT count(*) totalCnt FROM book_ex.tbl_myboard
    ]]>
</select>
```

* 페이징 화면이동 제이쿼리 활용 <br>
<strong>[예시]</strong> <br>
```
$(".paginate_button a").on("click",function(e){
  e.preventDefault();
  frmSendValue.find("input[name='pageNum']").val($(this).attr("href"));
  frmSendValue.attr("action","${contextPath}/myboard/list");
  frmSendValue.attr("method","get");
  frmSendValue.submit();
})

```
$(".paginate_button a") : 클라스이름이 paginate_button인 모든 a 요소 선택 <br>
frmSendValue.attr() : 속성값을 줌 , action,method 

* 화면이동 후 다시 게시판 목록 페이지로 왔을 때 이전 페이징의 값들이 저장되어있어야하므로, 컨트롤러에 @ModelAttribute로 MyBoardPagingDTO 값들을 전달받을 수 있도록 설정
* 화면 이동시 form을 만들어서 hidden 속성으로 MyBoardPagingDTO의 pageNum과 rowAmountPerPage를 받을 수 있도록 설정함 
* Redirect방식으로는 Model이나 @ModelAttribute를 사용해서 JSP페이지로 페이징 데이터를 전달할 수   RedirectAttributes를 이용하여 값을 전달할 수 있도록 함  <br>
<strong>[예시]</strong> <br>
```
@PostMapping("/modify")
public String modifyBoard(MyBoardVO myBoard,
                          RedirectAttributes redirectAttr, //전달할 페이징 값을 저장
                          MyBoardPagingDTO myBoardPagingDTO) // 전달된 페이징 값들을 저장
{
      if(myBoardService.modifyBoard(myBoard)){
            redirectAttr.addFlashAttribute("result","successModify");
      }

  redirectAttr.addAttribute("bno", myBoard.getBno());
  redirectAttr.addAttribute("pageNum",myBoardPagingDTO.getPageNum());
  redirectAttr.addAttribute("rowAmountPerPage",myBoardPagingDTO.getRowAmountPerPage());
  
  return "redirect:/myboard/detailmod";
}                          

```


* 제이쿼리의 data() 메소드는 data-xxx 속성에 설정된 값을 저장함 <br>

<strong>[예시]</strong>

modify.jsp
```
<button type="button" class="btn btn-default" id="btnModify" data-oper="modify">수정</button>
	<button type="button" class="btn btn-danger" id="btnRemove" data-oper="remove">삭제</button>
	<button type="button" class="btn btn-info" id="btnList" data-oper="list">취소</button>
  
```

<strong>[예시]</strong> <br>
modify.jsp script <br>
```
  var frmModify = $("#frmModify");
  $('button').on("click",function(e){
    var operation = $(this).data("oper"); // data-xxx 속성에 설정된 값을 저장  
    if(operation == "modify"){
      frmModify.attr("action","${contextPath}/myboard/modify");
    }else if(operation=="remove"){
      frmModify.attr("action","${contextPath}/myboard/delete");
    }else if(operation=="list"){
      var pageNumInput = $("input[name='pageNum']").clone(); 
      var rowAmountInput = $("input[name='rowAmountPerPage']").clone();
      
      frmModify.empty();
      
      frmModify.attr("action","${contextPath}/myboard/list").attr("method","get");
      
      frmModify.append(pageNumInput);
      frmModify.append(rowAmountInput); 
    }
    frmModify.submit();
  }
```

<hr>

# 검색기능



### 핵심정리

검색범위와 키워드를 사용자가 입력할 수 있는 기능 <br>
검색 범위의 특정 옵션 선택시 "T", "C" , "W" ,"TC","TW","TCW" 중 하나의 문자열이 서버로 전달되도록 구현 <br>
예를 들어, "TCW"문자열이 서버로 전달되면, ["T","C","W"] 배열로 변환시킨 후 , 변환된 배열을 MyBatis가 사용하여 select문의 조건식을 완성함 <br>


### 새로 알게된 점 

*  MyBoardPagingDTO에 scope와 keyword 필드값을 설정. 이때 사용자가 선택한 검색범위는 배열로 받을 수 있도록 설정 !! <br>
<strong>[예시]</strong> <br>
MyBoardPagingDTO <br>

```
 @Getter
 @Setter
 @ToString
 public class MyBoardPagingDTO{
    private int pageNum; 
    private int rowAmountPerPage;
    private String scope; // 검색범위(scope- T:btitle,C:bcontent, W:bwriter)
    private String keyword // 검색어
    
    //검색범위 값 처리를 위한 메소드 : 화면에서 선택된 TCW 값을 ["T","C","W"] 배열로 변환
    public String[] getScopeArray(){
        return scope == null? new String[]{} : scope.split("");
    }
    //생략...
 }
 
```

* 배열로 받은 검색범위에 따라 select문의 조건절이 완성되어 처리될 수 있도록 , Mybatis동적태그 활용

<strong>[예시]</strong> <br>
MyBoardMapper<br>

```xml
<select id="selectMyBoardList" resultType="com.goott.spring.domain.MyBoardVO">
<![CDATA[
    SELECT bno,btitle,bcontent,bwriter,bregdate,bmoddate,bviewsCnt,breplyCnt,bdelFlag
      FROM (SELECT /*+ INDEX_DESC (a pk_myboard) */ ROWNUM rn, a.*
            FROM book_ex.tbl_myboard a 
            WHERE
]]> 
 <trim prefix="(" suffix=") AND" prefixOverrides="OR" >
   <foreach item='scope' collection="scopeArray">
     <trim prefix="OR">
       <choose>
         <when test="scope == 'T'.toString()">btitle LIKE '%'||#{keyword}||'%'</when>
          <when test="scope == 'C'.toString()">bcontent LIKE '%'||#{keyword}||'%'</when>
         <when test="scope == 'W'.toString()">bwriter LIKE '%'||#{keyword}||'%'</when>
       </choose>
     </trim>
   </foreach>
 </trim>
  <![CDATA[
      ROWNUM <= (#{pageNum}*#{rowAmountPerPage})
      )
    WHERE rn >= ((#{pageNum}*#{rowAmountPerPage})-(#{rowAmountPerPage}-1))
  
]]>
</select>
```
마이바티스의 trim은 if문과 비슷한 것 ! 조건절을 설정하는 것이다. myBoardPagingDTO에 설정해둔 scopeArray의 배열의 값에 따라 찾는 범위를 각각 설정함 <br>
즉 myBoardPagingDTO에 배열값으로 받은 검색범위(T,C,W)를 하나하나 뺴서 , choose절에서 조건을 검색함<br>
T인 경우 , btitle,, C인 경우 bcontent, W인 경우 bwriter로 #{keyword}의 값이 들어있는 검색 조건을 찾음 <br>
```
<trim prefix="OR">
```  
 prefix 로 OR를 사용했기 때문에 검색범위 중 하나만 만족해도 값을 찾음 ! <br>
 







