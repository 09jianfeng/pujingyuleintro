jQuery(document).ready(function($) {
  $('#full-width-slider').royalSlider({
    arrowsNav: true,
    loop: false,
    keyboardNavEnabled: true,
    controlsInside: false,
    imageScaleMode: 'fill',
    arrowsNavAutoHide: false,
    autoScaleSlider: true, 
    autoScaleSliderWidth: 940,     
    autoScaleSliderHeight: 350,
    controlNavigation: 'bullets',
    thumbsFitInViewport: false,
    navigateByClick: true,
    startSlideId: 0,
    autoPlay: false,
    transitionType:'move',
    globalCaption: true,
    deeplinking: {
      enabled: true,
      change: false
    },
    imgWidth: 940,
    imgHeight: 350
  });
});




$(document).ready(function(){

  $(".navmore").click(function(){
    $(".navmore_block").fadeToggle(500);
  
  });
});
    $('#phone').bind('focus',function(){  
                $('.pl_kuang').css('position','static');  
            }).bind('blur',function(){  
                $('.pl_kuang').css({'position':'fixed','bottom':'0'});  
            });  




$(function () {
        $('.cons:gt(4)').hide();
        $('.zzc').html('加载更多');
if($('.loading').length>0){
        var loadingHeight = $('.loading').height(),
                loadingTop = $('.loading').offset().top,
                screenHeight = $(window).height(),
                i = 1,
                count = 0,
                listLength = $('.cons').length;
        //滚动触发事件
        window.onscroll = scrollFun;
        function scrollFun() {
            var thisTop = $(document).scrollTop();
            if (thisTop >= loadingTop - screenHeight) {
                if (5 * i < listLength) {
                    window.onscroll = null;
                    i++;
                    count = 5 * i;
                    $('.zzc').html('<img src="/ych5/images/indicator.gif" alt="circle" />' + '正在加载');
                    setTimeout(function () {
                        $('.cons:lt(' + count + ')').show();
                        loadingTop = $('.loading').offset().top;
                        window.onscroll = scrollFun;
                        $('.zzc').html('没有更多了');
                    }, 1000);
                } else {
                    $('.zzc').html('没有更多了');
                    return false;
                }

            }
        }
}
    });
$(document).ready(function() {
    $("nav li").click(function(){
		$(this).addClass("cur").siblings().removeClass("cur");
		})
});
$(document).ready(function() {
    $(".shouqi").click(function(){
	$(".navmore_block").hide()
		});
});
