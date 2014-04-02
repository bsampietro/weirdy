var weirdy = {};

weirdy.wexceptionsIndex = {
  initialize : function() {
    $(".info2 .occurrences a").click(function() {
      if ($(this).attr("data-clicked")){
        $(this).parents('tr').next('tr.occurrences').toggle(200);
      }
      else{
        $(this).attr("data-clicked", "true");
        $.ajax({
          url: $(this).attr("href"),
          complete: function() { 
            weirdy.wexceptionsIndex.fix_backtrace_size();
          }
        });
      }
      return false;
    });
    
    $(document).on('click', ".occurrences .actions a.hide", function() {
      $(this).parents('tr.occurrences').toggle(200);
      return false;
    });
    
    $(document).on('click', "a.prev", function() {
      var $current = $(this).parents(".actions").next().find(".occurrence:not(.hidden)")
      var $prev = $current.prev();
      if ($prev.length > 0) {
        $current.addClass("hidden");
        $prev.removeClass("hidden");
      }
      return false;
    });
    
    $(document).on('click', "a.next", function() {
      var $current = $(this).parents(".actions").next().find(".occurrence:not(.hidden)")
      var $next = $current.next();
      if ($next.length > 0) {
        $current.addClass("hidden");
        $next.removeClass("hidden");
      }
      return false;
    });
    
    $(document).on('click', ".backtrace .see-more a", function() {
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

    $(window).resize(function() {
      weirdy.wexceptionsIndex.table_size = $("table").width();
      weirdy.wexceptionsIndex.fix_backtrace_size();
    });
  },

  fix_backtrace_size: function() {
    $(".backtrace").width(this.table_size - 40);
  },

  table_size: $("table").width()
};
