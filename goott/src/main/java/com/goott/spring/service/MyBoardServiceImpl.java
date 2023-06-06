package com.goott.spring.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.goott.spring.common.paging.MyBoardPagingDTO;
import com.goott.spring.domain.MyBoardVO;
import com.goott.spring.mapper.MyBoardMapper;

@Service
public class MyBoardServiceImpl implements MyBoardService{
	
	private MyBoardMapper myBoardMapper;
	public MyBoardServiceImpl(MyBoardMapper myBoardMapper) {
		this.myBoardMapper = myBoardMapper;
	}

	
	
	
	//게시물 목록 조회 
	@Override
	public List<MyBoardVO> getBoardList(MyBoardPagingDTO myBoardPagingDTO) {
		
		return myBoardMapper.selectMyBoardList(myBoardPagingDTO);
	}

	//게시물 총 개수 
	@Override
	public long getRowAmountTotal(MyBoardPagingDTO myBoardPagingDTO) {
		return myBoardMapper.selectRowAmountTotal(myBoardPagingDTO);
	}

	
	//게시물 등록
	@Override
	public long registerBoard(MyBoardVO myBoard) {
		myBoardMapper.insertMyBoardSelectKey(myBoard);		
		return myBoard.getBno();
	}

	//게시물 조회
	@Override
	public MyBoardVO getBoard(long bno) {
		myBoardMapper.updateBviewsCnt(bno);
		return myBoardMapper.selectMyBoard(bno);
	}
	
	//수정후 게시물 조회 -> 조회수 증가 X 
	@Override
	public MyBoardVO getBoardDetailModify(long bno) {
		return myBoardMapper.selectMyBoard(bno);
	}
	
	//게시물 수정
	@Override
	public boolean modifyBoard(MyBoardVO myBoard) {
		
		return myBoardMapper.updateMyBoard(myBoard)==1;
	}

	//게시물 삭제요청 (bdelflag = 1)
	@Override
	public boolean setBoardDeleted(Long bno) {
		return myBoardMapper.updateBdelFlag(bno)==1;
	}
	
	//게시물 실제 삭제 
	@Override
	public boolean removeBoard(long bno) {
		return myBoardMapper.deleteMyBoard(bno)==1;
	}
	
	//게시물 삭제(관리자) 
	@Override
	public int removeAllDeletedBoard() {
		return myBoardMapper.deleteAllBoardSetDeleted();
	}

}
