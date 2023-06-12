package com.goott.spring.common.paging.fileupload;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
@NoArgsConstructor
public class AttachFileDTO {
	
	private String fileName;
	private String uploadPath;
	private String uuid;
	private String fileType;
	private String repoPath = "C:/myupload";

}
