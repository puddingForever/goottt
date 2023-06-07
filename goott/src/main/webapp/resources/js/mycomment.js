/**
 * mycomment.js: 댓글/답글 데이터 처리용 Ajax Closure Module */
 
var myCommentClsr =(function(){
    
    //댓글 목록(페이징)
    
    function getCmtList(pagingParams,callback,error){
        
        var bno = pagingParams.bno;
        var page = pagingParams.page || 1;
        
        console.log("getCmtList()가 전달받은 bno" + bno);
        console.log("getCmtList()가 전달받은 page" + page);

        //댓글 목록 조회 컨트롤러의 매핑 URL: GET /replies/pages/{bno}/{page}
        $.ajax({ type:'get',
                 url: "/spring/replies/pages/"+bno+"/"+page,
                 dataType : 'json',
                 success:function(replyPagingCreator,status,xhr){
                     if(callback){
                         callback(replyPagingCreator);
                     }
                     
                 },
                 error:function(xhr,status,er){
                     if(error){
                         error(er);
                     }
                     
                 }
            
            
        });//ajax-end
        
    }//getCmtList-end
    //댓글 등록
    function registerCmt(comment,callback,error){
        var bno = comment.bno;
        console.log("bno: " + bno);
       
       
        //댓글 등록 컨트롤러의 매핑 URL: GET /replies/{bno}/new
       $.ajax({ type:"post",
                url:"/spring/replies/" + bno + "/new",
                data : JSON.stringify(comment),
                contentType : "application/json; charset=utf-8",
                success: function(result,status,xhr){
                        if(callback){
                            callback(result);
                        }  
                },
                error : function(xhr,status,er){
                    if(error){
                        error(er);
                    }
                    
                }
       }) //ajax-end
    }//registerCmt-end
    
    //답글 등록
    function registerReply(reply,callback,error){
        var bno = reply.bno;
        var prno = reply.prno;
        
        console.log("bno: " + bno);
        console.log("prno: " + prno);
        
        //답글 등록 컨트롤러의 매핑 URL: GET /replies/{bno}/{prno}/new
        $.ajax({ type:"post",
                 url : "/spring/replies/" + bno + "/" + prno + "/new",
                 data : JSON.stringfy(reply),
                 contentType:"application/json; charset=utf-8",
                 dataType: 'text',
                 success:function(result,status,xhr){
                    if(callback){
                        callback(result);
                    }  
                     
                 },
                 error : function(xhr,status,er){
                     if(error){
                         error(er);
                     }
                     
                 }
            
            
        })//end-ajax
    }//end-registerReply
    
    
    //특정 게시물의 댓글 가져오기 
    function getCmtReply(bnoAndRno,callback,error){
        var bno = bnoAndRno.bno;
        var rno = bnoAndRno.rno;
        
        console.log("bno: " + bno);
        console.log("rno: " + rno);
        
        //댓글 조회 컨트롤러의 매핑 URL: GET /replies/{bno}/{rno}
        
        $.get("/spring/replies/"+bno+"/"+rno+".json",
                function(result){
                    if(callback){
                        callback(result);
                    }
                }).fail(function(xhr,status,err){
                    if(error){
                        error();
                    }
                })//fail-end
        
    }//getCmtReply-end
    
    //댓글 수정 : 수정된 특정 댓글을 서버로 전송
    function modifyCmtReply(comment,callback,error){
        var bno = comment.bno;
        var rno = comment.rno;
        
        $.ajax({
            type:"put",
            url:"/spring/replies/"+bno+"/"+rno,
            data:JSON.stringify(comment),
            contentType:"application/json; charset=utf-8",
            dataType:"text",
            success:function(modifyResult,status,xhr){
                if(callback){
                    callback(modifyResult);
                }  
                
            },
            error:function(xhr,status,er){
                if(error){
                    error(er);
                }
                
            }
            
        })//end-ajax        

    }//modifyCmtReply-end
     
    //댓글 삭제(실제 삭제)
	 function removeCmtReply(comment, callback, error) {
	 var bno = comment.bno;
	 var rno = comment.rno;
	 var rwriter = comment.rwriter
	 console.log("removeCmtReply() 전달받은 bno: " + bno);
	 console.log("removeCmtReply() 전달받은 rno: " + rno);
	 console.log("removeCmtReply() 전달받은 rwrier: " + rwriter);
	 console.log("removeCmtReply() 함수의 댓글 삭제 ajax 처리 시작.......");
	 //댓글 삭제 컨트롤러의 매핑 URL: DELETE /replies/{bno}/{rno}
	 $.ajax( { type: "delete",
	 url : "/mypro00/replies/" + bno + "/" + rno,
	 data : JSON.stringify({bno: bno, rno: rno, rwriter: rwriter}),
	 contentType : "application/json; charset=utf-8", 
	 success : function(removeResult, status, xhr) {
			 if (callback) {
			 callback(removeResult);
			 }
	 },
	 error: function(xhr, status, er) {
			 if (error) {
			 error(er);
			 }
	 }
	 }); //ajax END
}//removeCmtReply 함수 END
    
    return {
      getCmtList : getCmtList,  
      registerCmt : registerCmt ,
      registerReply :registerReply,
      getCmtReply : getCmtReply,
      modifyCmtReply : modifyCmtReply,
      removeCmtReply : removeCmtReply
    };
    
})();