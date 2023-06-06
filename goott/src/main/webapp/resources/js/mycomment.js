/**
 * mycomment.js: 댓글/답글 데이터 처리용 Ajax Closure Module */
 
//alert("댓글처리 클로저 모듈 실행됨=======");

var myCommentClsr = ( function() {
	
	function getCmtList(param, callback, error) {
		var bno = param.bno ;
		
		$.ajax({
			type: "get" ,
			url: "/mypro00/replies/" + bno ,
			dataType: "json" ,
			success: function(replyList, status, xhr){
				if(callback) {
					callback(replyList) ;
				}
			} ,
			error: function(xhr, status, er) {
				if(error){
					error(er) ;
				}
			}
		
		}); //ajax-end
	} //getCmtList-end
	
	function registerCmt(comment, callback, error){
		var bno = comment.bno ;
		
		$.ajax({
			type: "post" ,
			url: "/mypro00/replies/" + bno + "/new" ,
			data: JSON.stringify(comment) ,
			contentType: "application/json; charset=utf-8" ,
			success: function(result, status, xhr){
				if(callback){
					callback(result) ;
				}
			},
			
			error: function(xhr, status, err){
				if(error){
					error(err) ;
				}
			}
		}); //ajax-end
	
	}//registerCmt-end
	
	
	function registerReply(reply, callback, error){
		var bno = reply.bno ;
		var prno = reply.prno ;
		
		$.ajax({
			type: "post" ,
			url: "/mypro00/replies/" + bno + "/" + prno + "/new" ,
			data: JSON.stringify(reply) ,
			contentType: "application/json; charset=utf-8" ,
			success: function(result, status, xhr){
				if(callback){
					callback(result) ;
				}
			},
			
			error: function(xhr, status, err){
				if(error){
					error(err) ;
				}
			}
		}); //ajax-end
	
	}//registerReply-end
	
	function getCmtReply (bnoAndRno, callback, error) {
		var bno = bnoAndRno.bno ;
		var rno = bnoAndRno.rno ;
		
		$.ajax({
			type: "get" ,
			url: "/mypro00/replies/" + bno + "/" + rno ,
			dataType: "json" ,
			success: function(data, status, xhr){  
				if(callback){
					callback(data) ;
				}
			},
			
			error: function(xhr, status, err){
				if(error){
					error(err) ;
				}
			}
		
		});//ajax-end
		
	}
	
	function modifyCmtReply(cmtReply, callback, error) {
	
		var bno = cmtReply.bno ;
		var rno = cmtReply.rno ;
		
		$.ajax({
			type: "put" ,
			url: "/mypro00/replies/" + bno + "/" + rno ,
			data: JSON.stringify(cmtReply) ,
			contentType: "application/json; charset=utf-8" ,
			dataType: "text" ,
			success: function(result, status, xhr){  
				if(callback){
					callback(result) ;
				}
			},
			
			error: function(xhr, status, err){
				if(error){
					error(err) ;
				}
			}

		}); //ajax-end
	
	
	}//modifyCmtReply-end
	
	
	function removeCmtReply(cmtReply, callback, error) {
		var bno = cmtReply.bno ;
		var rno = cmtReply.rno ;
		
		$.ajax({
			type: "delete" ,
			url: "/mypro00/replies/" + bno + "/" + rno ,
			dataType: "text" ,
			success: function(result, status, xhr){  
				if(callback){
					callback(result) ;
				}
			},
			
			error: function(xhr, status, err){
				if(error){
					error(err) ;
				}
			}
			
		
		
		}); //ajax-end
		
		
		
		
	}  //removeCmtReply-end
	
	
	
	
	function modifyRdelFlag(cmtReply, callback, error) {
	
		var bno = cmtReply.bno ;
		var rno = cmtReply.rno ;
		
		$.ajax({
			type: "patch" ,
			url: "/mypro00/replies/" + bno + "/" + rno ,
			dataType: "text" ,
			success: function(result, status, xhr){  
				if(callback){
					callback(result) ;
				}
			},
			
			error: function(xhr, status, err){
				if(error){
					error(err) ;
				}
			}

		}); //ajax-end
	
	
	}//modifyCmtReply-end

    //날짜시간 표시형식 설정 (서버와 상관없음)
    //JSON 날짜시간을 그대로 표시하면 1594169682000 이렇게 표시됩니다.
    //일반적인 날짜 시간 표시 형식으로 표시,
	function showDatetime(datetimeValue) {

        var dateObj = new Date(datetimeValue) ;
        console.log("dateObj: " + dateObj.toString())
        var str = "";

        var yyyy = dateObj.getFullYear() ;
        var mm = dateObj.getMonth() + 1 ; //1~12,  getMonth() is zero-based
        var dd = dateObj.getDate() ;      //1 ~31
        var hh = dateObj.getHours() ;
        var mi = dateObj.getMinutes() ;
        var ss = dateObj.getSeconds() ;

        str = [yyyy, "/", 
               (mm > 9 ? '' : "0") + mm  , "/", 
               (dd > 9 ? '' : "0") + dd, " ", 
               (hh > 9 ? '' : "0") + hh, ":", 
               (mi > 9 ? '' : "0") + mi, ":", 
               (ss > 9 ? '' : "0") + ss].join('');
        //2023/06/02 19:49:33
        return str ;
    }


	//myCommentClsr
	return {
		getCmtList: getCmtList ,        //목록
		registerCmt: registerCmt ,      //댓글등록
		registerReply: registerReply ,  //답글등록
		getCmtReply: getCmtReply ,      //특정 댓글/답글 조회 
		modifyCmtReply: modifyCmtReply ,//특정 댓글/답글 수정
		removeCmtReply: removeCmtReply ,//특정 댓글/답글 삭제
		modifyRdelFlag: modifyRdelFlag ,//특정 댓글/답글 삭제 요청(*)
        showDatetime: showDatetime
	}

})(); 