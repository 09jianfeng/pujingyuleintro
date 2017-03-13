$(function(){
    var hwlist=[];
    var nums=[];
    $('a.hotwordproduct').each(function(i,e){
        hwlist.push($(e).html());
    })
    function unq(hwlist){
        var h={};
        var newhwlist={};
        for(var i=0;i<hwlist.length;i++){
            if(!h[hwlist[i]]){
                h[hwlist[i]]=1;
                newhwlist[i]=hwlist[i];
            }else{
                nums.push(i);
            }
        }
        return newhwlist;
    }
    var newhwlist=unq(hwlist);
    for(var i in newhwlist){
        $('a.hotwordproduct').eq(i).removeAttr('href');
    }
    for(var i=0;i<nums.length;i++){
        $('a.hotwordproduct').eq(nums[i]).attr('href','javascript:void(0);').css({textDecoration:'none',color:'#545454'}).removeAttr('href');
        $('a.hotwordproduct').eq(nums[i]).hover(
            function(){
                $(this).css({cursor:'text',color:'#545454'}).removeAttr('href');
            }
        );
    }
})
