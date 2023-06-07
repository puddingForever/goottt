package com.goott.spring.service;

import org.springframework.stereotype.Service;

import com.goott.spring.common.paging.MyReplyPagingCreatorDTO;
import com.goott.spring.common.paging.MyReplyPagingDTO;
import com.goott.spring.domain.MyReplyVO;
import com.goott.spring.mapper.MyReplyMapper;

@Service
public class MyReplyServiceImpl implements MyReplyService {

	private MyReplyMapper myReplyMapper;
	
	public MyReplyServiceImpl(MyReplyMapper myReplyMapper) {
		this.myReplyMapper = myReplyMapper;
	}
	
	
	//특정 게시물에 대한 댓글 목록 조회
	@Override
	public MyReplyPagingCreatorDTO getReplyListByBno(MyReplyPagingDTO myReplyPaging) {
		
		MyReplyPagingCreatorDTO myReplyPagingCreator = 
				new MyReplyPagingCreatorDTO(
						myReplyMapper.selectReplyTotalByBno(myReplyPaging),
						myReplyPaging,
						myReplyMapper.selectMyReplyList(myReplyPaging)
						);
		
		return myReplyPagingCreator;
		
	}
	
	//특정 게시물의 댓글 총 개수확인 
	@Override
	public long getReplyTotalByBno(MyReplyPagingDTO myReplyPaging) {
		return myReplyMapper.selectReplyTotalByBno(myReplyPaging);
	}
	
	//특정 게시물에 대한 댓글 등록 : rno 반환 
	@Override
	public long registerReplyForBoard(MyReplyVO myReply) {
		myReplyMapper.insertMyReplyForBoard(myReply);
		return myReply.getRno();
	}

	
	//댓글의 답글 등록 : rno 반환
	@Override
	public long registerReplyForReply(MyReplyVO myReply) {
		myReplyMapper.insertMyReplyForReply(myReply);
		return myReply.getRno();
	}
	
	//특정 댓글 조회 
	@Override
	public MyReplyVO getReply(long bno, long rno) {
		MyReplyVO myReply = myReplyMapper.selectMyReply(bno, rno);
		return myReply;
	}

	//특정 댓글 수정 
	@Override
	public int modifyReply(MyReplyVO myReply) {
		Integer modCnt = myReplyMapper.updateMyReply(myReply);
		return modCnt;
	}
	//특정 댓글 삭제 
	@Override
	public int removeReply(long bno, long rno) {
		Integer delCnt = myReplyMapper.deleteMyReply(bno, rno);
		return delCnt;
	}

}
