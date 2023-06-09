package com.goott.spring.common.paging.fileupload;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.nio.file.Files;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.UUID;
import java.util.regex.Pattern;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.multipart.MultipartFile;

import net.coobird.thumbnailator.Thumbnailator;

@Controller
public class FileUploadFormController {
	
	
	//저장경로 
	private String uploadFileRepoDir = "C:\\myupload";
	
	//파일업로드 jsp 호출 
	@GetMapping("/fileUploadForm")
	public String callFileUploadForm() {
		return "sample/fileUploadForm";
	}
	
	//유효성 검사 (1메가바이트 이상 , 확장자 exe|sh|zip|alz|dll|c 막기 )
	private boolean checkUploadFile(String fileName,long fileSize) {
		
		//자바 정규식 
		String pattern = "(?i)(.*)\\.(exe|sh|zip|alz)$";
		boolean result = Pattern.matches(pattern, fileName);
		//1메가바이트 == 1000000 바이트 
		long maxSizeAllowed = 1000000;
		
		if(fileSize>maxSizeAllowed) {
			return false;
		}
		
		if(result) {
			return false;
		}
		
		return true; //아무 조건도 포함 X  
		
	}
	
	//날짜형식 경로 
	private String getDatefmtPathName() {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
		Date date = new Date();
		
		String strDatefmtPathName = sdf.format(date);
		
		return strDatefmtPathName;
	}
	
	//이미지파일은 썸네일도 저장
	private boolean checkIsImageForUploadFile(File uploadFile) {
		
		try {
			String strContentType = Files.probeContentType(uploadFile.toPath());
			return strContentType.startsWith("image");
		
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		return false;
	}
	
	//파일업로드 post
	@PostMapping("/fileUploadFormAction")
	public String fileUploadPost(MultipartFile[] uploadFiles, 
			@ModelAttribute("ename")String ename,
			Model model) {
		
	
		for(MultipartFile myFile : uploadFiles ) {			
			
			//유효성 검사 
			long fileBytes = myFile.getSize();

			if(!checkUploadFile(myFile.getOriginalFilename(),fileBytes)) {
			    System.out.println("파일 업로드 막기");
			    model.addAttribute("msg", "에러");
			   return  "sample/fileUploadFormResult";
			}

			
			
			//날짜 형식 폴더 구조 생성 
			File fileUploadPath = new File(uploadFileRepoDir,getDatefmtPathName());
			
			//경로 존재 X , 날짜형식 폴더구조 생성
			if(!fileUploadPath.exists()) {
				fileUploadPath.mkdirs();
			}
			
			
			//파일 객체 저장할 이름(확장자 포함) 
			String strUploadFileName = myFile.getOriginalFilename();
			strUploadFileName = strUploadFileName.substring(strUploadFileName.lastIndexOf("\\")+1);
			
			//랜덤 문자열 추가 
			UUID uuid = UUID.randomUUID();
			strUploadFileName = uuid.toString()+"_"+strUploadFileName;
			
			
			//File saveUploadFile = new File(uploadFileRepoDir,strUploadFileName);
			
			//날짜 폴더 구조 파일 경로 
			File saveUploadFile = new File(fileUploadPath,strUploadFileName);
			
			try {
				//경로에 파일 저장 
				myFile.transferTo(saveUploadFile);
				
				//이미지 여부 확인
				if(checkIsImageForUploadFile(saveUploadFile)) {
					FileOutputStream outputStreamForThumbnail = 
							new FileOutputStream(new File(fileUploadPath,"s"+strUploadFileName));
					
					
					Thumbnailator.createThumbnail(myFile.getInputStream(),//원본파일 읽고 
												outputStreamForThumbnail, // 이 경로로 썸네일보냄 
												20,20); //px
				
					outputStreamForThumbnail.close();
				}
				
				
			} catch (IllegalStateException | IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} 
			
		} // end - for	
		
	    model.addAttribute("msg", "유효");

		return "sample/fileUploadFormResult";
	}
	

	
	

}
