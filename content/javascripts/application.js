var showcase_slide_timeout;

(function($, undefined) {

var original_content_height;

var showcase_slide_timer;
var showcase_slide_on = false;
var slide_width;
var slide_prev = $('<a class="prev">prev</a>');
var slide_next = $('<a class="next">next</a>');

var fix_position = function()
{
  var content_height;
  if ($('#header').is(':hidden'))
  {
    content_height = $(window).height() - $('#footer').outerHeight();
  }
  else
  {
    content_height = $(window).height() - $('#header').outerHeight() - $('#footer').outerHeight();
  }

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

showcase_slide_timeout = function(enable, direction, time)
{
  if (time === undefined && showcase_slide_on)
  {
    time = 10000;
  }
  else if (time === undefined && !showcase_slide_on)
  {
    time = 25000;
  }

  if (enable)
  {
    showcase_slide_timer = setTimeout(function() { showcase_slide(direction) }, time);
    showcase_slide_on = true;
  }
  else
  {
    clearTimeout(showcase_slide_timer);
    showcase_slide_on = false;
  }
}

var showcase_slide = function(direction)
{
  if($('#slideshow .wrapper').queue().length > 0)
  {
    setTimeout(showcase_slider, 100, direction);
    return;
  }

  if (direction === 'prev')
  {
    if ($('#slideshow .wrapper').position().left === 0)
    {
      $('#slideshow .wrapper').prepend($('#slideshow .wrapper .slide:last-child').detach()).css('left', -slide_width);
    }

    showcase_slide_timeout(true, 'prev');
    $('#slideshow .wrapper').animate({left: '+=' + slide_width}, 1200);
    sublimevideo.stop();
  }
  else if (direction === 'next')
  {
    if ($('#slideshow .wrapper').position().left === -($('#slideshow .wrapper').width() - slide_width))
    {
      var wrapper_position = $('#slideshow .wrapper').position().left + slide_width;
      $('#slideshow .wrapper').append($('#slideshow .wrapper .slide:first-child').detach()).css('left', wrapper_position);
    }

    showcase_slide_timeout(true, 'next');
    $('#slideshow .wrapper').animate({left: '-=' + slide_width}, 1200);
    sublimevideo.stop();
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

  $('#showcase').append(slide_prev);
  $('#showcase').append(slide_next);

  slide_width = $('#slideshow').outerWidth();

  $('#slideshow .slide').css('width', slide_width);
  $('#slideshow .slide').wrapAll('<div class="wrapper"></div>');
  $('#slideshow .wrapper').css('width', $('#slideshow .slide').length * slide_width);

  sublimevideo.ready(function() {
    sublimevideo.onStart(function() {
      showcase_slide_timeout(false);
    });

    sublimevideo.onEnd(function() {
      showcase_slide_timeout(true, 'next');
    });

    sublimevideo.prepare($('video'));
  });

  $('#showcase .next').bind('click', function() { showcase_slide_timeout(false); showcase_slide('next'); });
  $('#showcase .prev').bind('click', function() { showcase_slide_timeout(false); showcase_slide('prev'); });
});

})(jQuery);
