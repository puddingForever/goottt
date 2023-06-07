package com.goott.spring.service;

import static org.junit.Assert.assertNotNull;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import lombok.Setter;
import lombok.extern.log4j.Log4j;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration({"file:src/main/webapp/WEB-INF/spring/mybatis-context.xml",
	"file:src/main/webapp/WEB-INF/spring/appServlet/servlet-context.xml"})
@Log4j
public class MyReplyMapperTests {

	@Setter(onMethod_ = @Autowired)
	 private MyReplyService myReplyService;
	
	
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
	
	@Test
	public void testMyReplyServiceExist() {
		log.info(myReplyService);
		assertNotNull(myReplyService);
		
	}
	
	
}
