var FEB = {
    loadTypeForRepublish:'0',		//0:first load     1:load more
	
    loadTypeForComment:'0',			//0:first load     1:load more
    
    isDataForRepublish:true,        //true:republish    false:comment
    
    fontSizeSmall:function(){
        var $target = $("#main_div #content_div p,a,span");
        $target.css("font-size", 16);
    },
    
    fontSizeMiddle:function(){
        var $target = $("#main_div #content_div p,a,span");
        $target.css("font-size", 18);
    },
    
    fontSizeLarge:function(){
        var $target = $("#main_div #content_div p,a,span");
        $target.css("font-size", 20);
    },
    
    changeToNightMode:function(){
        $("#main_div").css("background-color","#000");
        $("#main_div").css("color","#fff");
    },
    
    changeToWhiteDayMode:function(){
        $("#main_div").css("background-color","#fff");
        $("#main_div").css("color","#000");
    },
    
    changeFontFamily:function(familyName){
        $("body").css("font-family",familyName);
    },
	
	sendCommand: function (cmd,param){
		var url="FEB:"+cmd+":"+param;
        //alert(url);
		document.location = url;
	}

};

FEB.loadRepublishList=function(republishList){
    $('#isLoading_p').hide();
    $('#loadMore_p').hide();
	var container = $('#rAndc_list_div');
    container.html('');         //clear
    
    var dataList=republishList.dataList;
    if(typeof(dataList)=='undefined'){
        $('#isLoading_p').show().text('还没有人转发,快来抢沙发吧!');
        return;
    }
	
	var templateStr="<% _.each(dataList,function(dataObj,index){ %><div class=\"rAndc_item_div\"><img class=\"rAndc_head_img\" src=\"<%=dataObj.headImgUrl %>\" alt=\"\"/><div class=\"rAndc_right_div\"><input type=\"hidden\" value=\"<%=index %>\" /><a href=\"\"><%=dataObj.name %></a><p class=\"text_p\"><%=dataObj.text %></p><p class=\"pubDate_p\"><span><%=dataObj.pubDate %></span></p></div><div class=\"separator\"></div></div><%}) %>";
	
	try {
        var generatedHtml=_.template(templateStr,republishList);
        if(FEB.loadTypeForRepublish=="0"){			//first load
			if(generatedHtml==""){
				$('#isLoading_p').show().text('还没有人转发,快来抢沙发吧!');
			}else{									//set
				container.html(generatedHtml);
				$('#loadMore_p').show();
			}
		}else{
			if(generatedHtml==""){
				$('#loadMore_p').hide();
			}else{
                container.html(generatedHtml);
                $('#loadMore_p').show();
            }
			
		}
    } catch (e) {
        alert("Error in template: " + e.name + "; " + e.message);
    }
	
	container.find('#republishAndcomment_div .rAndc_right_div').unbind('click');
	container.find('#republishAndcomment_div .rAndc_right_div').each(function(){
        $(this).click(function(){
            var itemIndex=$(this).find("input[type='hidden']").get(0).value;
            FEB.sendCommand('popActiveSheet_republish',itemIndex);
        });
    });
	
}

FEB.loadCommentList=function(commentList){
    $('#isLoading_p').hide();
    $('#loadMore_p').hide();
    var container = $('#rAndc_list_div');
    container.html('');         //clear
    
    var dataList=commentList.dataList;
    if(typeof(dataList)=='undefined'){
        $('#isLoading_p').show().text('还没有人评论,快来抢沙发吧!');
        return;
    }
	
	var templateStr="<% _.each(dataList,function(dataObj,index){ %><div class=\"rAndc_item_div\"><img class=\"rAndc_head_img\" src=\"<%=dataObj.headImgUrl %>\" alt=\"\"/><div class=\"rAndc_right_div\"><input type=\"hidden\" value=\"<%=index %>\" /><a href=\"\"><%=dataObj.name %></a><p class=\"text_p\"><%=dataObj.text %></p><p class=\"pubDate_p\"><span><%=dataObj.pubDate %></span></p></div><div class=\"separator\"></div></div><%}) %>";
	
	try {
        var generatedHtml=_.template(templateStr,commentList);
        if(FEB.loadTypeForComment=="0"){			//first load
			if(generatedHtml==""){
				$('#isLoading_p').show().text('还没有人评论,快来抢沙发吧!');
			}else{									//set
				container.html(generatedHtml);
				$('#loadMore_p').show();
			}
		}else{
			if(generatedHtml==""){
				$('#loadMore_p').hide();
			}else{
                container.html(generatedHtml);
                $('#loadMore_p').show();
            }
			
		}
    } catch (e) {
        alert("Error in template: " + e.name + "; " + e.message);
    }
	
	container.find('#republishAndcomment_div .rAndc_right_div').unbind('click');
	container.find('#republishAndcomment_div .rAndc_right_div').each(function(){
            $(this).click(function(){
                  var itemIndex=$(this).find("input[type='hidden']").get(0).value;
                  FEB.sendCommand('popActiveSheet_comment',itemIndex);
            });
    });
	
}

FEB.reloadRAndCNum=function(n1,n2){
    FEB.reloadRepublishNum(n1);
    FEB.reloadCommentNum(n2);
}

FEB.reloadRepublishNum=function(num){
    var $republishSpan=$('.discuss_bottom .repeat_span');
    $republishSpan.text('转发 '+num);
}

FEB.reloadCommentNum=function(num){
    var $commentSpan=$('.discuss_bottom .discuss_span');
    $commentSpan.text('评论 '+num);
}

// Local Variables:
// indent-tabs-mode: nil
// End:
