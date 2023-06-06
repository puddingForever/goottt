package com.goott.spring.common.paging;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class MyBoardPagingDTO {

	private int pageNum; // 현재 페이지 번호 
	private int rowAmountPerPage; //페이지당 출력할 레코드 개수 
	private String scope;//검색범위
	private String keyword;//검색어
	
	public String[] getScopeArray() {
		return scope==null? new String[] {}:scope.split("");
	}
	
	public MyBoardPagingDTO() {
		this.pageNum = 1;
		this.rowAmountPerPage = 10;
	}
	
	public MyBoardPagingDTO(int pageNum) {
		if(pageNum<=0) {
			this.pageNum = 1;
		}else {
			this.pageNum = pageNum;
		}
		this.rowAmountPerPage = 10;
	}
	
	public MyBoardPagingDTO(int pageNum,int rowAmountPerPage) {
		if(pageNum <=0) {
			this.pageNum = 1;
		}else {
			this.pageNum = pageNum;
		}
		
		if(rowAmountPerPage<=0) {
			this.rowAmountPerPage = 10;
		}else {
			this.rowAmountPerPage = rowAmountPerPage;
		}
	}
}
