# Controller,Service,Mapper,View 구성 

### 용어정리 

* Controller <br>
화면(view)와 비지니스로직(service)를 연결시켜주는 다리역할을 함<br>
Dispatcher Servlet으로 부터 Request를 전달받으면, 용도에 따라 코드의 흐름을 처리해줌 <br>
@Controller 어노테이션을 명시하고 Servlet-context에 패키지를 명시해야 Dispatcher Servlet이 컨트롤러를 찾을 수 있음 

* Service <br>
비지니스 로직이 실행되는 곳. @Service어노테이션을 명시하고, Servlet-context에도 패키지를 명시해야함 

* Mapper <br>
마이바티스를 사용하기 떄문에 Sql문을 구현할 Mapper인터페이스, xml에는 sql문을 작성함 <br> 

### 새로 알게된 점 
* 시퀀스를 늘리는 sql문은 selectKey를 사용
selectKey를 사용하면 vo객체에 값을 넣은 후 insert문에 값을 줄 수 있음 <br>
```xml
 <select id="insertMyBoardSelectKey">
   <selectKey keyProperty="bno" order="BEFORE" resultType="long">
       SELECT book_ex.seq_myboard.nextval FROM dual
    </selectKey>
    INSERT INTO book_ex.tbl_myboard
    VALUES (#{bno},#{btitle},#{bcontent},#{bwriter},
   default,default,default,default,default)
</select>
```
* RedirectAttributes의 addFlashAttribute는 Post방식으로 값을 전달함. 한번만 쓸 수 있음 
<pre>
@PostMapping("/remove")
public String removeBoard(@RequestParam("bno") long bno,RedirectAttributes redirectAttr){
  if(myBoardServie.removeBoard(bno)){
    redirectAttr.addFlashAttribute("result","successRemove"); 
  }
  return "redirect:/myboard/list"; // 모델을 통헤 result가 list컨트롤러로 전달됨 
}
</pre>
* 게시글을 롹인하는 경우, 조회수가 1씩 증가하게 설계함. 하지만 글쓴이가 수정한 후 다시 게시글을 확인했을 때는 조회수가 늘어나면 안되기 떄문에 게시글 보는 메소드(조회수고려) 이외에도 수정페이지에 다녀온 후 게시글을 보는 메소드(조회수 고려 X) 를 따로 만들어야함 
* 게시글 등록 후 , 게시글 목록페이지로 가도록 설정함 <br>
사용자가 뒤로가리를 눌렀다면 다시 등록페이지가 보이게되고 등록페이지는 bno값으로 BoardVO의 값을 가지고 있기 때문에 이전에 등록했던 값들이 보이게됨<br>
사용자가 등록을 다시 한다면 PK값인 bno가 중복으로 들어가기 때문에 에러가 남 <br>
이를 방지하기 위해 제이쿼리를 이용하여 뒤로가기가 실행되지 않도록 설정<br>
<pre>
  $(document).ready(function(){
   checkModal(result); // 모달값 확인 후 뒤로가기 설정 막음
   window.addEventListener('popstate',function(event){ // popstate는 뒤로가기버튼 이벤트
      history.pushState(null,null,location.href); //뒤로가기 막음
   })
   history.pushState(null,null,location.href); //현재 페이지의 URL을 강제로 최근 URL로서 히스토리 객체에 추가 
  )}
</pre>


