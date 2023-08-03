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
  $("#jumpbar .nav-link a").click(function(event) {
    event.preventDefault();
    const section = $(this).attr("href");
    $("html, body").animate({
      scrollTop: $(section).offset().top-20
    }, 1200);
  });

  $("#catalogue-record-actions #request-btn").click(function(event) {
    event.preventDefault();
    const section = $(this).attr("href");
    $("html, body").animate({
      scrollTop: $(section).offset().top-20
    }, 1200);
  });
  
  $('.blrl-plot-config').data('plot-config', {
    selection: { color: '#46474A' },
    colors: ['#ffffff'],
    series: { lines: { fillColor: 'rgba(112,57,150, 0.8)' }},
    grid: { color: '#677078', tickColor: '#f4f5f6', borderWidth: 1 }
  });
});
