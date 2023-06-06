package com.goott.spring.common.paging;

import lombok.Getter;
import lombok.ToString;

@Getter
@ToString
public class MyBoardPagingCreatorDTO {
	
	 private MyBoardPagingDTO myBoardPagingDTO; //페이지번호와 행 개수 저장 객체
	 private int startPagingNum; //화면에 표시되는 시작 페이징 번호
	 private int endPagingNum; //화면에 표시되는 끝 페이징 번호
	 private boolean prev; //이전 버튼 표시 여부 결정 변수(true: 표시됨, false: 표시 안됨)
	 private boolean next; //다음 버튼 표시 여부 결정 변수(true: 표시됨, false: 표시 안됨)
	 private long rowAmountTotal; //전체 행 개수
	 private int pagingNumCnt; //화면 하단에 표시할 기본 페이지 번호 개수(10)
	 private int lastPageNum; //행 총수를 기준으로 한 실제 마지막 페이지 번호
	 
	 public MyBoardPagingCreatorDTO(long rowAmountTotal, MyBoardPagingDTO myBoardPagingDTO ) {
	 this.myBoardPagingDTO = myBoardPagingDTO ;
	 this.rowAmountTotal = rowAmountTotal;
	 this.pagingNumCnt = 10;
	 
	 //계산된 끝-시작 페이징 번호:
	 this.endPagingNum =
	 (int)( Math.ceil(myBoardPagingDTO.getPageNum() / (this.pagingNumCnt * 1.0) ) ) * this.pagingNumCnt ;
	 this.startPagingNum = this.endPagingNum - (this.pagingNumCnt -1);
	 
	 //행 총수를 기준으로 한 실제 마지막 페이지 번호 저장
	 this.lastPageNum = (int)( Math.ceil( (rowAmountTotal * 1.0) / myBoardPagingDTO.getRowAmountPerPage() ) );
	 
	 //계산된 끝 페이징 번호가 실제 마지막 페이지 번호보다 크면, endPagingNum 값을 lastPageNum 값으로 대체
	 if (lastPageNum < this.endPagingNum) {
	 this.endPagingNum = lastPageNum ;
	 }
	 
	 this.prev = this.startPagingNum > 1 ;
	 this.next = this.endPagingNum < lastPageNum ;		
	 }
}