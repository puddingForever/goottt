package com.goott.spring.service;

import java.util.List;

import com.goott.spring.domain.MyBoardVO;

public interface MyBoardService {
	

	//게시물 목록 조회
	public List<MyBoardVO> getBoardList();
	
	//게시물 등록 (selectkey이용)
	public long registerBoard(MyBoardVO myBoard);
	
	//특정 게시글 조회
	public MyBoardVO getBoard(long bno);
	
	//게시물 조회: 게시물 수정 후 -> 조회수 증가 변화 X
	public MyBoardVO getBoardDetailModify(long bno);
	
	//특정 게시물 수정
	public boolean modifyBoard(MyBoardVO myBoard);
		
	//특정 게시글 삭제 요청- bdelflag = 1
	public boolean setBoardDeleted(Long bno);
	
	//특정 게시글 삭제 (실제 삭제)
	public boolean removeBoard(long bno);
			
	//게시물 삭제(관리자) - bdelflag=1 전체삭제
	public int removeAllDeletedBoard();
	

}