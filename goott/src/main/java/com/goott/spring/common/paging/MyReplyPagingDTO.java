package com.goott.spring.common.paging;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class MyReplyPagingDTO {

	private long bno; // 게시물 번호
	private int pageNum; // 현재 페이지 번호 
	private int rowAmountPerPage; //페이지당 출력할 레코드 개수 
	
	
	
	public MyReplyPagingDTO(long bno,Integer pageNum) {
		this.bno = bno;
		
		if(pageNum == null) {
			this.pageNum = 1;
		}else {
			this.pageNum = pageNum;
		}
		
		this.rowAmountPerPage = 10;
	}
}
