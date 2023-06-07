package com.goott.spring.controller;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.goott.spring.common.paging.MyReplyPagingCreatorDTO;
import com.goott.spring.common.paging.MyReplyPagingDTO;
import com.goott.spring.domain.MyReplyVO;
import com.goott.spring.service.MyReplyService;

@RequestMapping(value= {"/replies"})
@RestController
public class MyReplyController {

	//생성자 자동 주입
	private MyReplyService myReplyService;
	
	public MyReplyController(MyReplyService myReplyService) {
		this.myReplyService = myReplyService;
	}
	
	
	//게시물에 대한 댓글 목록 조회: GET /replies/pages/{bno}/{page}
	@GetMapping(value="/pages/{bno}/{page}",
				produces= {"application/json; charset=UTF-8","application/xml; charset=UTF-8"})
	public ResponseEntity<MyReplyPagingCreatorDTO> showReplyList(@PathVariable("bno") Long bno,
																	@PathVariable("page")Integer pageNum){
		
		MyReplyPagingDTO myReplyPaging = new MyReplyPagingDTO(bno,pageNum);
		MyReplyPagingCreatorDTO replyPagingCreator = myReplyService.getReplyListByBno(myReplyPaging);
		ResponseEntity<MyReplyPagingCreatorDTO> responseEntity = new ResponseEntity<>(replyPagingCreator,HttpStatus.OK);
		return responseEntity;
	}
	
	
	//게시물에 대한 댓글 등록(rno 반환): POST /replies/{bno}/new
	@PostMapping(value="/{bno}/new",
				consumes= {"application/json; charset=UTF-8"},
				produces = {"text/plain;charset=UTF-8"})
	public ResponseEntity<String> registerReplyForBoard(@PathVariable("bno")Long bno,
														@RequestBody MyReplyVO myReply){
		
		Long registerRno = myReplyService.registerReplyForBoard(myReply);
		
		return registerRno != null ? new ResponseEntity<>("게시물의 댓글 등록 성공",HttpStatus.OK)
							: new ResponseEntity<>("게시물의 댓글 등록 실패",HttpStatus.INTERNAL_SERVER_ERROR);
	}
	
	//게시물에 대한 댓글의 답글 등록(rno 반환): POST /replies/{bno}/{prno}/new
	@PostMapping(value="/{bno}/{prno}/new",
				consumes= {"application/json; charset=UTF-8"},
				produces= {"text/plain; charset=UTF-8"})
	public ResponseEntity<String> registerReplyForReply(@PathVariable("bno")Long bno,
														@PathVariable("prno")Long prno,
														@RequestBody MyReplyVO myReply){
		Long registerRno = myReplyService.registerReplyForReply(myReply);
		
		return registerRno != null
				? new ResponseEntity<>("댓글에 대한 답글 등록 성공",HttpStatus.OK)
				: new ResponseEntity<>("댓글에 대한 답글 등록 실패",HttpStatus.INTERNAL_SERVER_ERROR);		
	}
	
	//게시물에 대한 특정 댓글 조회: GET /replies/{bno}/{rno}
	@GetMapping(value="/{bno}/{rno}",
				produces= {"application/json; charset=UTF-8", "application/xml; charset=UTF-8"})
	public ResponseEntity<MyReplyVO> showReply(@PathVariable("bno")Long bno,
												@PathVariable("rno")Long rno){
		MyReplyVO myReply = myReplyService.getReply(bno, rno);
		
		return new ResponseEntity<>(myReply,HttpStatus.OK);
		
	}
	
	//게시물에 대한 특정 댓글 수정: PUT:PATCH /replies/{bno}/{rno}
	@RequestMapping(value="/{bno}/{rno}",
					method= {RequestMethod.PUT, RequestMethod.PATCH},
					consumes="application/json; charset=UTF-8",
					produces = "text/plain; charset=UTF-8")
	public ResponseEntity<String> modifyReply(@PathVariable("bno")Long bno,
												@PathVariable("rno")Long rno,
												@RequestBody MyReplyVO myReply){
		
		myReply.setBno(bno);
		myReply.setRno(rno);
		
		int modCnt = myReplyService.modifyReply(myReply);
		
		return modCnt == 1
				? new ResponseEntity<>("댓글 수정 성공",HttpStatus.OK)
						: new ResponseEntity<>("댓글 수정 실패",HttpStatus.INTERNAL_SERVER_ERROR);
	}
	
	
	//게시물에 대한 특정 댓글 삭제: DELETE: /replies/{bno}/{rno}
	@DeleteMapping(value="/{bno}/{rno}", produces= {"text/plain; charset=UTF-8"})
	public ResponseEntity<String> removeReply(@PathVariable("bno")Long bno,
												@PathVariable("rno")Long rno){
		int delCnt = myReplyService.removeReply(bno, rno);
		
		return delCnt == 1
				? new ResponseEntity<>("댓글 삭제 성공",HttpStatus.OK)
			    : new ResponseEntity<>("댓글 삭제 실패",HttpStatus.INTERNAL_SERVER_ERROR);
	}	
	
	
}
