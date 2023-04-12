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
  console.log("document ready");
  $("#jumpbar .nav-link a").click(function() {
    console.log("jumpbar clicked", $(this).attr("href"));
    const section = $(this).attr("href");
    console.log(section);
    $("html, body").animate({
      scrollTop: $(section).offset().top-20
    }, 1200);
  });
});
