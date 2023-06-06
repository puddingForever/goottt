package com.goott.spring.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.goott.spring.common.paging.MyBoardPagingCreatorDTO;
import com.goott.spring.common.paging.MyBoardPagingDTO;
import com.goott.spring.domain.MyBoardVO;
import com.goott.spring.service.MyBoardService;

import lombok.extern.log4j.Log4j;

@Controller
@Log4j
@RequestMapping("/myboard")
public class MyBoardController {
	
	private MyBoardService myBoardService;
	
	public MyBoardController(MyBoardService myBoardService) {
		this.myBoardService = myBoardService;
	}

	
	//목록 조회 GET /myboard/list -
	@GetMapping("/list")
	public void showBoardList(MyBoardPagingDTO myBoardPagingDTO, Model model) {
		model.addAttribute("boardList", myBoardService.getBoardList(myBoardPagingDTO));
	
		long rowAmountTotal = myBoardService.getRowAmountTotal(myBoardPagingDTO);
		
		MyBoardPagingCreatorDTO myBoardPagingCreatorDTO = 
				new MyBoardPagingCreatorDTO(rowAmountTotal,myBoardPagingDTO);
		
		model.addAttribute("pagingCreator", myBoardPagingCreatorDTO);
	
	}

	
	// 등록 페이지 호출 GET /myboard/register 목록 페이지 
	@GetMapping("/register")
	public void showBoardRegisterPage() {
	}

	//등록 처리 POST /myboard/register 등록 처리(서버 저장) 후  목록페이지로 이동
	@PostMapping("/register")
	public String registerNewBoard(MyBoardVO myBoard, RedirectAttributes redirectAttr) {
		long bno = myBoardService.registerBoard(myBoard);
		redirectAttr.addFlashAttribute("result", bno); //데이터가 post방식으로 전달,한번만사용		
		return "redirect:/myboard/list";
	}
	
	//특정 게시물 조회, 수정페이지  GET /myboard/detail (내용 표시 및 조회수 1 증가)
	@GetMapping("/detail")
	public void showBoardDetail(@RequestParam("bno")long bno,Model model,
								@ModelAttribute("myBoardPagingDTO") MyBoardPagingDTO myBoardPagingDTO) {
		model.addAttribute("board", myBoardService.getBoard(bno));
	}
	
	//게시물 조회페이지 -> 수정페이지 호출 
	@GetMapping("/modify")
	public void showBoardModify(@RequestParam("bno") Long bno,Model model,
			@ModelAttribute("myBoardPagingDTO") MyBoardPagingDTO myBoardPagingDTO) {
		model.addAttribute("board", myBoardService.getBoardDetailModify(bno));
		model.addAttribute("myBoardPagingDTO", myBoardPagingDTO);
	}
	
	//게시물 수정 후 -> 조회페이지 호출 (/detailmod)
	@GetMapping("/detailmod")
	public String showBoardDetailMod(@RequestParam("bno")long bno,Model model,
			@ModelAttribute("myBoardPagingDTO") MyBoardPagingDTO myBoardPagingDTO) {
		model.addAttribute("board", myBoardService.getBoardDetailModify(bno));
		model.addAttribute("myBoardPagingDTO", myBoardPagingDTO);

		return "/myboard/detail";
	}
	
	//특정 게시물 수정처리
	@PostMapping("/modify")
	public String modifyBoard(MyBoardVO myBoard,RedirectAttributes redirectAttr,
			@ModelAttribute("myBoardPagingDTO") MyBoardPagingDTO myBoardPagingDTO) {
		if(myBoardService.modifyBoard(myBoard)) {
			redirectAttr.addFlashAttribute("result", "successModify");
		}	
		 redirectAttr.addAttribute("bno", myBoard.getBno());
		 redirectAttr.addAttribute("pageNum", myBoardPagingDTO.getPageNum());
		 redirectAttr.addAttribute("rowAmountPerPage", myBoardPagingDTO.getRowAmountPerPage());
		 redirectAttr.addAttribute("scope", myBoardPagingDTO.getScope());
		 redirectAttr.addAttribute("keyword", myBoardPagingDTO.getKeyword());
		 return "redirect:/myboard/detailmod";
	}
	
	//특정 게시물 삭제의뢰 POST /myboard/delete 삭제의뢰 처리(서버 저장) 후 목록 페이지 이동
	@PostMapping("/delete")
	public String setBoardDeleted(@RequestParam("bno")long bno,
			RedirectAttributes redirectAttr,
			@ModelAttribute("myBoardPagingDTO") MyBoardPagingDTO myBoardPagingDTO) {
		
		if(myBoardService.setBoardDeleted(bno)) {
			redirectAttr.addFlashAttribute("result", "successRemove");
		}
		redirectAttr.addAttribute("pageNum", myBoardPagingDTO.getPageNum());
		 redirectAttr.addAttribute("rowAmountPerPage", myBoardPagingDTO.getRowAmountPerPage());
		 redirectAttr.addAttribute("scope", myBoardPagingDTO.getScope());
		 redirectAttr.addAttribute("keyword", myBoardPagingDTO.getKeyword());
		 return "redirect:/myboard/list";
	}
	
	//특정 게시물 삭제 POST /myboard/remove 	
	@PostMapping("/remove")
	public String removeBoard(@RequestParam("bno") long bno,RedirectAttributes redirectAttr,
			@ModelAttribute("myBoardPagingDTO") MyBoardPagingDTO myBoardPagingDTO) {
		if(myBoardService.removeBoard(bno)) {
			redirectAttr.addFlashAttribute("result","successRemovec");		
		}
		redirectAttr.addAttribute("pageNum", myBoardPagingDTO.getPageNum());
		 redirectAttr.addAttribute("rowAmountPerPage", myBoardPagingDTO.getRowAmountPerPage());
		 redirectAttr.addAttribute("scope", myBoardPagingDTO.getScope());
		 redirectAttr.addAttribute("keyword", myBoardPagingDTO.getKeyword());
		 
		 return "redirect:/myboard/list";
	}
	
	//게시물 삭제 - 삭제 요청된 모든 게시물 삭제 
	@PostMapping("/removeAll")
	public String removeAllDeletedBoard(Model model,RedirectAttributes redirectAttr,
			@ModelAttribute("myBoardPagingDTO") MyBoardPagingDTO myBoardPagingDTO) {
		model.addAttribute("removeRowCnt", myBoardService.removeAllDeletedBoard());
		redirectAttr.addFlashAttribute("result", "successRemoveAll");
		
		redirectAttr.addAttribute("pageNum", myBoardPagingDTO.getPageNum());
		 redirectAttr.addAttribute("rowAmountPerPage", myBoardPagingDTO.getRowAmountPerPage());
		 redirectAttr.addAttribute("scope", myBoardPagingDTO.getScope());
		 redirectAttr.addAttribute("keyword", myBoardPagingDTO.getKeyword());
		 return "redirect:/myboard/list";
	}
	
}
