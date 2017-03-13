$(function(){
  //console.log(1);
  
  var isAddc=false;//评论是否已加载
  var id=$('#cid').val();
  //后退按钮
  $('.return').on('click',function(e){
    //e.preventDefault;
    //history.go(-1);
    location.href= document.referrer
  })
   //浏览量
  function viewcount(){
    jQuery.ajax({
          url:'http://cms39.diyicai.com/play_num.php?id='+id+'&type=update',
          dataType : "jsonp",
          success:function(data){
            if(data.status==1){
              
            }
            //debugger;
          },
          error:function(e){
            //debugger;
          }
        }
      )
  }
  //viewcount();
//点击发布按钮提交评论
$('.fabu').on('click',function(e){

      //var id=$('#cid').val();
      var content=$('.pl_input input').val();
      if(!$.trim(content)){return false;}
      jQuery.ajax({
          url:'http://cms39.diyicai.com/Service/comment.php',
          data:{id:id,content:content},
          dataType : "jsonp",
          type:'post',
          success:function(data){
            if(data.status==1){
              //成功
              getcomment();
              alert('评论成功');
              $('.pl_input input').val('');
            }else{//有敏感词
              alert('评论成功');
              $('.pl_input input').val('');
            }
            //debugger;
          },
          error:function(e){
            //debugger;
          }
        }
      )
    
  })
  //提交点赞
  $('#upvote').on('click',function(){
    var title=$('.news_bt').html();
    jQuery.ajax({
          url:'http://cms39.diyicai.com/Service/zan.php',
          data:{id:id,title:title},
          dataType : "jsonp",
          type:'post',
          success:function(data){
            if(data.status==1){
              //成功
              $('#zcount').html(parseInt( $('#zcount').html() )+1 );
              var em=$('<em class="upvote" style="color:#fff;margin-right:-0.5rem;position: absolute;margin-left: -1.82em;z-index: 1;">1</em>')
              $('#upvote').after(em);
              setTimeout(function(){
                em.css({transition:'1s',transform:'translateY(-20px)',opacity:'0'});
              },100)
              //em.css({transition:'3s',transform:'translateY(-20px)'});
              //$('.droplet').css({transition:'2s',transform:'translateY(100px)'});
            }
            //debugger;
          },
          error:function(e){
            //debugger;
          }
        }
      )
  })

  //查询点赞
  function queryzan(){
    jQuery.ajax({
          url:'http://cms39.diyicai.com/Service/zan.php',
          data:{id:id,type:'search'},
          dataType : "jsonp",
          type:'post',
          success:function(data){
            if(data.status==1){
              //成功
              $('#zcount').html(data.number);
            }else{
              $('#zcount').html(0);
            }
            //debugger;
          },
          error:function(e){
            //debugger;
          }
        }
      )
  }
  queryzan();
  //提交评论
  $('.pl_input input').on('keyup',function(e){
    if(e.keyCode==13){
      //var id=$('#cid').val();
      var content=$(this).val();
      if(!$.trim(content)){
        return false;
      }
      jQuery.ajax({
          url:'http://cms39.diyicai.com/Service/comment.php',
          data:{id:id,content:content},
          dataType : "jsonp",
          type:'post',
          success:function(data){
            if(data.status==1){
              //成功
              getcomment();

              alert('评论成功');
              $('.pl_input input').val('');
            }else{//有敏感词
              alert('评论成功');
              $('.pl_input input').val('');
            }
            //debugger;
          },
          error:function(e){
            //debugger;
          }
        }
      )
    }
  })
  /*------edit by dingming 0829--------*/
  //点击评论焦点移动到评论输入框
  $('.plico').click(function(){
    $(document).scrollTop($('.pl_block').offset().top-$(window).height()/2);
    $('.pl_input input').focus();
  })
  //渲染评论
  function getcomment(){
      jQuery.ajax({
          url:'http://cms39.diyicai.com/Service/comment.php',
          data:{id:id,type:'search'},
          dataType : "jsonp",
          type:'post',
          success:function(data){
            if(data.status==1){
              //成功
              var re=data.result;
              var html='';
              $('.plico').html('评论 '+re.length);
              $('.pl_num').html(re.length);
              for (var d in re){
                d=re[d];
                html+='<li style="display:none"><div class="xgpl_left"><img src="/ych5/images/plimg.jpg"></div><div class="xgpl_cont"><b class="name">'+d.username+'</b><p class="time">'+d.date+'</p><p class="msg">'+d.content+'</p></div></li>';
              }
              $('.xgpl_block ul').html(html);
              $('.xgpl_block li:lt(5)').show();
              isAddc=true;
if(re.length<6){
    $('.pl_more').hide();
}else{
    $('.pl_more').show();
}
            }else if(data.message="暂无数据"){
    $('.pl_more').hide();
}
            //debugger;
          },
          error:function(e){
            //debugger;
          }
        }
      )
  }
  getcomment();

  //加载更多
  var intval = setInterval(addfnjiazai,1000)
  function addfnjiazai(){
    if(isAddc){
      var count=$('.xgpl_block li').size();
      $('.pl_more a').on('click',function(e){
        e.preventDefault;
        if($('.xgpl_block li:hidden').size()){
          var c1= count-$('.xgpl_block li:hidden').size();
          $('.xgpl_block li:lt('+(c1+5)+')').show();
        }else{
          //alert(1);
          $(this).css({background:'#aaa'}).html('没有更多');
          //$(this).off();
        }
        return false;
      })
      clearInterval(intval);
      intval=null;
    }
  }


  //添加时间评论数
  function getTimeAndCount(){
    var cid=$('#cid').val();
    jQuery.ajax({
          url:'http://cms39.diyicai.com/Service/select_pv_date.php?page=1&per_number=1000&channelid='+cid,
          dataType : "jsonp",
          success:function(data){
            if(data.status==1){
              //成功
              var d=data.result;
              $('.newslist .news1_time').each(function(i,v){
                 $(v).find('em').eq(1).html('阅读('+d[i]['play_num']+')');
                 $(v).find('em').eq(0).html(d[i].date);
              })
            }
            //debugger;
          },
          error:function(e){
            //debugger;
          }
        }
      )
  }
  getTimeAndCount();




})
