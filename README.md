# 파일업로드 결과 화면 처리, 다운로드 구현 

### 요점정리 

* ajax 화면처리 하는 법
1. 뷰에 ajax로 받아올 데이터의 공간을 만든다.
```
<div class="fileUploadResult">
  <ul>
  <!-- 업로드 후 처리결과가 표시되는 영역 -->
  </ul>
</div>
```
2. 업로드 처리결과 div를 꾸며줄 함수를 만든다.
```
//업로드 결과 표시함수 
function showUploadFiles(uploadResult){
  var fileUploadResult = $(".fileUploadResult ul"); // ul태그 변수화
  var str = "";
  
  //전달받은 데이터(배열) 표시
  
  $(uploadResult).each(function(i,obj)){
    str += "<li>" + obj.fileName +"</li>";
  }
  //태그에 str값 추가
  fileUploadResult.append(str);
}

```
3. ajax의 success에  처리결과 함수를 넣는다.
```
  $("#btnFileUpload).on("click",function(e){
  
      ...(생략)...
      $.ajax({
        type:"post",
        url:"${contextPath}/fileUploadAjaxAction",
        processData:false,
        contentType : false,
        data : formData,
        dataType:'json',
        success : function(uploadResult,status){
              
                showUploadFiles(uploadResult); 
        }
      
      })//end-ajax
      
  
  })


```


* 썸네일 파일 표시하는 방법

1. 썸네일의 파일의 경로가 포함된 fileName 문자열을 파라메터로 받은 후 , 스프링의 FileCopyUtils.copyToByteArray() 메소드를 이용하여 이미지 파일의 복사본에 대한 byte[]를 전송
2. byte[]로 이미지 파일의 데이터를 전송할 떄 , 파일의 종류에 따라 MIME타입이 변하지 않도록 , probeContentType()을 이용하여 파일에 대한 MIME타입값을 Http헤더 메시지에 포함하여 ResponseEntity 객체를 통해 전달
3. 브라우저의 업로드 요청페이지에서 컨트롤러 메소드를 호출하여 썸네일 파일이 표시될 수 있도록 showUploadFiles()에 구현 , 
4. Get방식으로 썸네일 파일을 요청하여 받을 때 파일 이름에 포함된 공백 문자나 한글 이름등이 포함된 경우를 고려해서 
파일이름이 포함된 URI에 대하여 encodeURIComponent()를 이용해서 URI 호출에 적합한 문자열로 인코딩함

* 이미지 파일이름을 받아서 썸네일 이미지 파일 데이터를 GET방식으로 전송하는 메소드 
```

@GetMapping("/displayThumbnailFile")
@ResponseBody
public ResponseEntity<byte[]> sendThumbNailFile(String fileName){

  File file = new File(fileName);
  
  ResponseEntity<byte[]> result = null;
  
  
  try{
    HttpHeaders header = new HttpHeaders();
    
    //HttepHeader객체에 썸네일이미지 파일의 content-type 추가 
    header.add("Content-Type",Files.probeContentType(file.toPath()));
    
    //복사된 썸네일 파일을 HttpHeader에 추가된 Content-Type 과 상태값을 가지고 ResponseEntity<byte> 객체 생성
    result = new ResponseEntity<byte[]>(fileCopyUtils.copyToByteArray(file),header,HttpStatus.OK);
    
  
  }catch(IOException e){
    e.printStackTrace();
  }
  return result; // ResponseEntity<byte[]> 객체 반환
}


```

5. 썸네일 이미지 표시하는 jsp 설정<br>
업로드 결과 표시 함수 : 이미지 파일은 썸네일과 원본 파일이름 표시 !

```
  function showUploadedFiles(uploadResult){
    
    //ul태그 변수화
    var fileUploadResult = $(".fileUploadResult ul");
    var str = "";
    
    //전달받은 배열형식
    
    $(uploadResult).each(function(i,obj)){
    
      if(obj.fileType=="F"){ // 이미지 아닌 경우 , 아이콘 이미지 + 원본 파일이름 
          (생략)....
      
      } else if(obj.fileType=="I"){ // 이미지 파일인 경우 , 썸네일 및 원본 파일이름 표시
          var thumbnailFilePath = 
              encodeURIComponent(obj.repoPath+"/"+obj.uploadPath+"/s_"+obj.uuid+"_"+obj.fileName);
             
             str += "<li>"
                  + "  <img src='${contextPath}/displayThumnailFile?fileName='+thumbnailFilePath +"'"
                  + "        alt='No Icon' style='height: 18px; width: 18px;'>"
                  +       obj.fileName
                  + "</li>";
      }
    
    }
  
    fileUploadResult.html(str); //fileUploadResult 클래스가 div에 있는 ul에 결과를 html로 추가 
  
  }

```


* 브라우저에서 보이는 첨부파일은 이미지파일과 일반파일로 구분됨
* 실습에서는 썸네일 클릭시 원본 이미지를 보여주고 , 일반파일 클릭시 다운로드되도록 구현함 

*일반파일(이미지 X)의 경우 서버에서 파일의 MIME타입을 다운로드 타입으로 지정하고 , 헤더 메시지를 통해서 다운로드 이름이 지정되도록 처리함 

<strong>Content-Disposition Header</strong> <br>

1. Response-Body의 데이터(파일)을 브라우저가 어떻게 처리할지를 설정하는 Header
2. Content-Disposition: inline (파일을 보여줌)
3. Content-Disposition : attachment; filename='파일이름.확장자' (데이터(파일)을 다운로드 할 수 있도록함)


<strong>application/octet-stream MIME 타입</strong> <br>
특별히 표현할 수 있는 프로그램이 존재하지 않는 이진 파일 데이터의 경우 , 기본값으로 octet-stream을 사용함 
<br>
보통 Content-Disposition 헤더를 attachment로 지정하고 , 해당 데이터를 수신받은 브라우저가 파일을 저장 또는 다른 이름으로 저장여부를 결정하도록 함<br>


* 다운로드 구현
1. 다운로드 요청을 처리하는 컨트롤러의 생성
2. 업로드 결과 페이지에서 다운로드 요청 구현 


* 1번의 다운로드 요청처리 컨트롤러 생성시 고려사항
1. 서버에서 확인된 파일은  ResponseEntity<>를 이용하여 다운로드되도록 처리함 . 이때 ResponseEntity<>의 타입으로 byte[]보다 
org.springframework.core.io.Resource 타입을 이용하면 다운로드를 간단히 처리할 수 있음 
2. 서버에서 브라우저로 보내는 첨부파일에 대한 MIME 타입은 이진파일을 다운로드 할 수 있도록 "application/octet-stream"으로 지정
3. 다운로드시 저장되는 파일이름은 'Content-Disposition' Http-해더를 이용해서 전달하여 지정<br>
이때, 파일이름에 한글이 포함되는 경우를 대비하여 파일이름-문자열을 UTF-8로 인코딩하고 , 다시 HTtp기본 인코딩 설정으로 디코딩될 수 있도록 처리함 
4. 다운로드 시에는 uuid를 제거함 
5. 브라우저마다 인코딩 방식이 다름. 헤더의 user-agent를 이용하여 브라우저를 확인하고 인코딩을 처리  

```

@Controller
public class FileDownloadAjaxController{

//서버에서 보내는 파일에 대한 MIME 타입
@GetMapping(value="/fileDownloadAjax", produces={"application/octet-stream"}
@ResponseBody
public ResponseEntity<Resource> fileDownloadActionAjax(@RequestHeader("User-Agent") String userAgent,String fileName){
    //파일 엑세스 가능한 resource 객체 
    Resource resource = new FileSystemResource(fileName);
    
    //파일이 존재하지 않는 경우 
    if(resource.exists() == false){
      return new ResponseEntity<Resource>(HttpStatus.NOT_FOUND);
    }
    //파일이 존재하는 경우
    String resourceFileName = resource.getFilename(); // uuid 제거 되기 전의 파일이 나옴
    //uuid 제거 
    resourceFileName = resourceFileName.substring(resourceFileName.indexOf("_") + 1);
    
    //스프링의 HttpHeaders 객체 생성
    HttpHeaders httpHeaders = new HttpHeaders();
    
    try{
        String downloadName = null;
        //웹 브라우저마다 전달되는 파일이름을 인코딩해주는 방식
        //IE, 엣지 브라우저 
        if(userAgent.contains("Trident") || userAgent.contains("MSIE")||
            userAgent.contains("Edge") || userAgent.contains("Edg"){
              downloadName = URLEncoder.encode(resourceFileName, "UTF8")
            }else{
            //크롬
            
            downloadName = new String(resourceFileName.getBytes("UTF-8"), "ISO-8859-1");
            
            }
            // httpheaders 객체에 다운로드 받을 수 있도록 content-disposition 해더 설정
            HttpHeaders.add("Content-Disposition","attachment; filename=" + downloadName);
        
    }catch(exception e){
      e.printstacktrace();
    }
    // 파일리소스, httpheaders 객체 , 상태 
    return new ResponseEntity<Resource>(resource,httpHeaders,HttpStatus.OK);

  }


}

```

<hr>


## 인코딩과 디코딩 
  인코딩은 String을 바이트로 바꿔줌 (서버가 알아들음) <br>
  디코딩은 바이트를 String으로 바꿔줌 (클라이언트가 알아들음) <br>
  <br>
  <br>
  
  직접 브라우저의 url에 한글을 입력하면, 브라우저가 자동으로 한글을 인코딩해주기 때문에 정상적으로
  한글이 잘보인다 <br>
  
  하지만 컨트롤러에서 url을 직접만들고 한글을 추가했을 경우, 브라우저가 인코딩을 해줄 수 없기 때문에
  이때 URLEncoder.encode()메소드를 사용한다. 
 <br>
  
  ```
  if(userAgent.contains("Trident") || userAgent.contains("MSIE")||
            userAgent.contains("Edge") || userAgent.contains("Edg")
    {
          downloadName = URLEncoder.encode(resourceFileName, "UTF8"); //uuid가 제거된 파일 이름
    }else{
    downloadName = new String(resourceFileName.getBytes("UTF-8"), "ISO-8859-1");

    }
  
  ```
  * 브라우저마다 다운로드 가능하도록 downloadName 보여주는데, 서버에서의 이름을 내보내기 때문에 URLEncoder를 이용하여
  인코딩해준 이름으로 보내주는 것이다. 
  * 크롬의 경우 브라우저 인코딩방식이 ISO-8859-1 방식이기 때문에 그에 맞게 인코딩을 해준 downloadName을 보내주는 것임

  
  
  
  
  
  
  

