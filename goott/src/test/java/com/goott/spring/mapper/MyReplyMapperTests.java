package com.goott.spring.mapper;

import java.util.List;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.goott.spring.domain.MyReplyVO;

import lombok.Setter;
import lombok.extern.log4j.Log4j;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration("file:src/main/webapp/WEB-INF/spring/mybatis-context.xml")
@Log4j
public class MyReplyMapperTests {

	@Setter(onMethod_ = @Autowired)
	 private MyReplyMapper myReplyMapper;
	
	
//	@Test
//	public void testMapper() {
//		log.info(myReplyMapper);
//	}
	
	//733196
//	
//	@Test
//	public void testSelectMyReplyList() {
//		Long targetBno = 733196L;
//		List<MyReplyVO> myReplies = myReplyMapper.selectMyReplyList(targetBno);
//		myReplies.forEach(myReply->System.out.println(myReply));
//		
//	}
	
	
	
}
