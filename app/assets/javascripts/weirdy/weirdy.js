var weirdy = {};

weirdy.wexceptionsIndex = {
  initialize : function() {
    $("td.occurrences a").click(function(){
      $(this).parents('tr').next('tr.occurrences').toggle(200);
      return false;
    });
    
    $(".occurrences .actions a.hide").click(function(){
      $(this).parents('tr.occurrences').toggle(200);
      return false;
    });
    
    $("a.prev").click(function(){
      var $current = $(this).parents(".actions").next().find(".occurrence:not(.hidden)")
      var $prev = $current.prev();
      if ($prev.length > 0) {
        $current.addClass("hidden");
        $prev.removeClass("hidden");
      }
      return false;
    });
    
    $("a.next").click(function(){
      var $current = $(this).parents(".actions").next().find(".occurrence:not(.hidden)")
      var $next = $current.next();
      if ($next.length > 0) {
        $current.addClass("hidden");
        $next.removeClass("hidden");
      }
      return false;
    });
    
    $(".backtrace .see-more a").click(function(){
      var $more = $(this).parents('.backtrace').find('.more');
      if ($more.hasClass("hidden")){
        $more.removeClass("hidden");
        $(this).html("Shorten Stack...");
      }else{
        $more.addClass("hidden");
        $(this).html("See Complete Stack...");
        var occurrence_position = $(this).parents('tr').prev().offset().top;
        $("body").scrollTop(occurrence_position);
      }
      return false;
    });
    
  }
};
