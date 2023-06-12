package com.goott.spring.common.paging.fileupload;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.nio.file.Files;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.UUID;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import net.coobird.thumbnailator.Thumbnailator;

@Controller
public class FileUploadAjaxController {
	
	private String uploadFileRepoDir = "C:\\myupload";
	
	//파일업로드 요청 jsp 
	@GetMapping("/fileUploadAjax")
	public String callFileUploadAjax() {
		return "sample/fileUploadAjax";
	}
	
	
	//이미지파일은 썸네일도 저장하기 
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
	
	//날짜 형식 경로 문자열 생성 메소드 
	private String getDatefmtPathName() {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
		Date date = new Date();
		//(yyyy/mm/dd)
		String strDatefmtPathName = sdf.format(date);
		
	//	return strDatefmtPathName.replace("/", File.separator); ==> 운영체제에 맞게 경로를 만들어줌 
		
		return strDatefmtPathName;
	}
	
	
	
	//업로드 요청 (파일 저장 및 결과 메시지 전송)
	@PostMapping(value="/fileUploadAjaxAction",produces= {"application/json; charset=UTF-8"})
	@ResponseBody
	public ResponseEntity<List<AttachFileDTO>> fileUploadActionPost(MultipartFile[] uploadFiles) { //formData.append("uploadFiles",myFiles[j]);
		
	
		//업로드 파일 각각에 대한 피드백 정보를 담을 리스트 객체 
		List<AttachFileDTO> listAttachInfo = new ArrayList<AttachFileDTO>();
		
		String strDatefmtPathName = getDatefmtPathName();
		//날짜형식 폴더구조 생성(yyyy/MM/dd)
		File fileUploadPath = new File(uploadFileRepoDir,strDatefmtPathName);
		
		//경로 존재 X , 폴더구조 생성 
		if(!fileUploadPath.exists()) {
			fileUploadPath.mkdirs();
		}
		
		for(MultipartFile multipartUploadFile : uploadFiles) {
			
			AttachFileDTO attachInfo = new AttachFileDTO();
			
			attachInfo.setRepoPath(uploadFileRepoDir.toString());
			
			attachInfo.setUploadPath(strDatefmtPathName.toString());
			
			
			//업로드 파일이름 원본 문자열
			String strUploadFileName = multipartUploadFile.getOriginalFilename();
			
			strUploadFileName = strUploadFileName.substring(strUploadFileName.lastIndexOf("\\")+1);
			
			attachInfo.setFileName(strUploadFileName);
			
			
			
			//랜덤파일이름 생성
			UUID uuid = UUID.randomUUID();
			attachInfo.setUuid(uuid.toString());
			
			//파일 확장자땜 uuid 앞에 추가 
			strUploadFileName = uuid.toString() + "_" + strUploadFileName;
		
		
			//날짜 폴더 구조 , 파일이름 
			File saveUploadFile = new File(fileUploadPath,strUploadFileName);
			
			try {
				
				
				//서버에 파일객체를 이용하여 업로드 파일 저장 
				multipartUploadFile.transferTo(saveUploadFile);
			
				//이미지파일여부 확인 
				if(checkIsImageForUploadFile(saveUploadFile)) {
					
					attachInfo.setFileType("I");
					
					FileOutputStream outputStreamForThumbnail = 
							new FileOutputStream(new File(fileUploadPath,"s_"+strUploadFileName));
					
					
					Thumbnailator.createThumbnail(multipartUploadFile.getInputStream(),//원본파일 읽고 
												outputStreamForThumbnail, // 이 경로로 썸네일보냄 
												20,20); //px
				
					outputStreamForThumbnail.close();
				}else {
					attachInfo.setFileType("F");
					
				}
				
				
			} catch (IllegalStateException |IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			
			
		}
			return new ResponseEntity<List<AttachFileDTO>>(listAttachInfo,HttpStatus.OK);
	}
	
}
