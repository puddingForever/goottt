package com.goott.spring.common.paging;

import java.util.List;

import com.goott.spring.domain.MyReplyVO;

import lombok.Getter;
import lombok.ToString;

@Getter
@ToString
public class MyReplyPagingCreatorDTO {
	
	private MyReplyPagingDTO myReplyPaging; // 페이지 번호화 행개수 저장객체
	private int startPagingNum; //화면에 표시되는 시작 페이징번호
	private int endPagingNum; //화면에 표시되는 끝 페이징번호
	private boolean prev; // 이전 버튼 표시여부 결정변수 (true 표시됨)
	private boolean next; // 다음 버튼 표시여부 결정변수 
	private long replyTotalByBno; // 전체행개수
	private int pagingNumCnt; // 화면 하단에 표시할 기본 페이지 번호 개수 
	private int lastPageNum; // 마지막 페이지 번호 
	
	private List<MyReplyVO> replyList;
	
	
	public MyReplyPagingCreatorDTO(long replyTotalByBno,
									MyReplyPagingDTO myReplyPaging,
									List<MyReplyVO> replyList) {
		
		this.myReplyPaging = myReplyPaging;
		this.replyTotalByBno = replyTotalByBno;
		this.replyList = replyList;
		this.pagingNumCnt = 10;
		
		this.endPagingNum = (int) (Math.ceil(myReplyPaging.getPageNum()/(this.pagingNumCnt*1.0)))*this.pagingNumCnt;
		
		this.startPagingNum =this.endPagingNum - (this.pagingNumCnt-1);
		
		this.lastPageNum =(int)(Math.ceil((replyTotalByBno*1.0)/myReplyPaging.getRowAmountPerPage()));
		
		
		if(lastPageNum < this.endPagingNum) {
			this.endPagingNum = lastPageNum;
		}
		
		this.prev = this.startPagingNum > 1;
		this.next = this.endPagingNum < lastPageNum;
		
		
		
		
	}
	
	
	
	
	
	
	
	
	

}
