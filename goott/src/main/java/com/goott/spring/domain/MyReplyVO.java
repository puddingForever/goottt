package com.goott.spring.domain;

import java.sql.Timestamp;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class MyReplyVO {
	
	private long bno;
	private long rno;
	private String rcontent;
	private String rwriter;
	private Timestamp rregDate;
	private Timestamp rmodDate;
	private long prno;
	private int lvl; //계층쿼리의 level을 저장할 필드 

}
