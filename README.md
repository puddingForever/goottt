# 파일업로드 구현 

### 핵심 

* 파일업로드 설정 및 기본 흐름 <br>
Form으로도 파일 업로드를 해보고, Ajax로도 해봤지만 패턴은 똑같음  
1. 보통 데이터를 전달받을 떄 String을 전달받음. 하지만 파일의 경우는 여러 종류의 타입이 오기 때문에 톰캣과 스프링이 이런 타입들을 어떻게 받아들여야 하는지 명시를 해줘야 함 ! 
2. web.xml(톰캣컨테이너)에 multipart데이터를 어떻게 받을 건지 명시하고, 스프링의 빈을 정의하는 servlet-context.xml에 multipart 업로드 구성을 위한 multipartResolver 빈을 설정해줌 !
3. form으로 파일업로드 하는 경우 , enctype="multipart/form-data"를 명시, ajax로 파일업로드 하는 경우 formData.append(바인딩하려는 이름 , 업로드하려는 파일)로 전달 
4. Controller에서는 파라메터값으로 MultipartFile[]이나(여러개의 파일인경우) , MultipartFile을 설정함 
5. 받아온 multipart객체를 이용하여 확장자를 포함한 원본 파일 이름(getOriginalFilename()을 뺴내고 , 저장경로와 함께 File객체에 저장함
6. transferTo메소드를 이용하여 서버에 파일객체를 이용해 업로드파일을 저장함 

### 새로 알개된 점 

* Ajax로 Form 데이터만을 제출하고 싶을 떄 FormData사용 
form요소는 url을 통해 처리 후 , jsp페이지 호출에 의한 페이지 전환이 발생함. 하지만 Ajax를 사용하면 하나의 url에서 데이터의 처리가 이루어지기 때문에 FormData를 사용함
<br>
페이지의 전환없이 데이터만을 제출하고 싶을 떄 form대신 사용됨 <br>

```
 var formData = new FormData(); //formdata 생성
 
    // inputFIle의 file속성을 전달. name은 uploadFIles로 전달하여 
    //Rest 컨트롤러에서 uploadFiles라는 이름으로 데이터를 받을 수 있도록 하였음 
  formData.append("uploadFiles",inputFiles[0].files)
  
  $.ajax({
    type:"post",
    url:"${contextPath}/fileUploadAjaxAction",
    data:formData,//formdata전달
    processData:false,
    contentType:false,
    success:function(uploadResult){
        alert("upload success");
      }
  })
  
```
 <strong> processData키와 contentType 키는 반드시 false로 지정! 전송방식은 반드시 Post</strong>
  
* MultipartFile 클래스 주요 메소드 
1. String getName() : 파라메터의 이름(input 태그의 이름) 반환
2. String getOriginalFileName() : 업로드되는 파일의 이름(확장자 포함)
3. long getSize() : 업로드되는 파일의 크기 
4. transferTo(File file) : 파일 저장
 
  
  
  
  
  
  
  
  
  
  
  
  
