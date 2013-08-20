var weirdy = {};

weirdy.wexceptionsIndex = {
  initialize : function() {
    $("td.occurrences a").click(function(){
      $(this).parents('tr').next('tr.occurrences').toggle(400);
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
  }
};
