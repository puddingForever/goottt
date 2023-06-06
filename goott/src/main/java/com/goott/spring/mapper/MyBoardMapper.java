package com.goott.spring.mapper;

import java.util.List;

import com.goott.spring.common.paging.MyBoardPagingDTO;
import com.goott.spring.domain.MyBoardVO;

public interface MyBoardMapper {

	//게시물 조회
	public List<MyBoardVO> selectMyBoardList(MyBoardPagingDTO myBoardPagingDTO);
	
	//총 게시글 
	public long selectRowAmountTotal(MyBoardPagingDTO myBoardPagingDTO);

	
	//게시물 등록 (selectkey이용)
	public Integer insertMyBoardSelectKey(MyBoardVO myBoard);
	
	//특정 게시글 조회
	public MyBoardVO selectMyBoard(Long bno);
	
	//특정 게시글 삭제 요청- bdelflag = 1
	public int updateBdelFlag(Long bno);
	
	//특정 게시글 삭제 (실제 삭제)
	public int deleteMyBoard(Long bno);
	
	//게시물 삭제(관리자) - bdelflag=1 전체삭제
	public int deleteAllBoardSetDeleted();
	
	//특정 게시물 수정
	public int updateMyBoard(MyBoardVO myBoard);
	
	//특정 게시물 조회수 증가
	public void updateBviewsCnt(Long bno);
	
}
