package com.goott.spring.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.goott.spring.common.paging.MyReplyPagingDTO;
import com.goott.spring.domain.MyReplyVO;

public interface MyReplyMapper {
	
	//특정 게시물에 대한 댓글 목록 조회
	public List<MyReplyVO> selectMyReplyList(@Param("myReplyPagingDTO")MyReplyPagingDTO myReplyPagingDTO);
	
	
	//댓글의 총수 
	public int selectReplyTotalByBno(@Param("myReplyPagingDTO") MyReplyPagingDTO myReplyPagingDTO);
	
	
	//특정 게시물에 대한 댓글 등록
	public long insertMyReplyForBoard(MyReplyVO myReplyVO);
	
	//댓글에 대한 답글 등록
	public long insertMyReplyForReply(MyReplyVO myReplyVO);
	
	//특정 게시물에 대한 특정 댓글/답글 조회
	public MyReplyVO selectMyReply(@Param("bno") Long bno, @Param("rno") Long rno);
	
	//특정 게시물에 대한 특정 댓글/답글 수정
	public int updateMyReply(MyReplyVO myReply);
	
	//특정 게시물에 대한 특정 댓글/답글 삭제
	public int deleteMyReply(@Param("bno")Long bno, @Param("rno")Long rno);
	
}
