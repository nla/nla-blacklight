//= require jquery3
//= require rails-ujs
//
// Required by Blacklight
//= require popper
// Twitter Typeahead for autocomplete
//= require twitter/typeahead
//= require bootstrap
//= require blacklight/blacklight
// For blacklight_range_limit built-in JS, if you don't want it you don't need
// this:
//= require 'blacklight_range_limit'

$(function() {
  $("#jumpbar .nav-link a").click(function() {
    const section = $(this).attr("href");
    $("html, body").animate({
      scrollTop: $(section).offset().top-20
    }, 1200);
  });

  $("#catalogue-record-actions #request-btn").click(function() {
    const section = $(this).attr("href");
    $("html, body").animate({
      scrollTop: $(section).offset().top-20
    }, 1200);
  });
});
