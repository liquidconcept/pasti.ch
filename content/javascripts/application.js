(function($, undefined) {

var original_content_height;

var fix_position = function()
{
  var content_height  = $(window).height() - $('#header').outerHeight() - $('#footer').outerHeight();

  if (content_height >= original_content_height)
  {
    $('#content').height(content_height);
    $('#illustration').height(content_height);
  }
  else
  {
    $('#content').height(original_content_height);
    $('#illustration').height(original_content_height);
  }
}

$(document).ready(function() {
  original_content_height = $('#content').height();

  fix_position();
  $(window).resize(fix_position);

  $('#credits a').bind('click', function(e) {
    e.preventDefault();

    window.open(this.href);
  });
});

})(jQuery);
