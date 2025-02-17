$(function() {
  $("#jumpbar .nav-link a").click(function(event) {
    event.preventDefault();
    const section = $(this).attr("href");
    $("html, body").animate({
      scrollTop: $(section).offset().top-20
    }, 1200, function() {
      $(section).focus()
    });
  });

  $("#catalogue-record-actions #request-btn").click(function(event) {
    event.preventDefault();
    const section = $(this).attr("href");
    $("html, body").animate({
      scrollTop: $(section).offset().top-110
    }, 1200);
  });

  // Override Blacklight modal link handler logic
  Blacklight.Modal.modalAjaxLinkClick = function(e) {
    e.preventDefault();
    const href = e.target.closest(`${Blacklight.Modal.triggerLinkSelector}, ${Blacklight.Modal.preserveLinkSelector}`).getAttribute('href')
    fetch(href)
    .then(response => {
      if (!response.ok) {
        throw new TypeError("Request failed");
      }
      return response.text();
    })
    .then(data => Blacklight.Modal.receiveAjax(data))
    .catch(error => Blacklight.Modal.onFailure(error))
  };

  // Override Blacklight modal failure logic
  Blacklight.Modal.onFailure = function (jqXHR, textStatus, errorThrown) {
    if (jqXHR.status === 401) {
      // Unauthorized, redirect to login page
      window.location.href = document.getElementsByTagName('body')[0].dataset.loginUrl;
      return;
    }

    var contents = '<div class="modal-header">' + '<div class="modal-title">There was a problem with your request.</div>' + '<button type="button" class="blacklight-modal-close btn-close close" data-dismiss="modal" aria-label="Close">' + '  <span aria-hidden="true">&times;</span>' + '</button></div>' + ' <div class="modal-body"><p>Expected a successful response from the server, but got an error</p>' + '<pre>' + this.type + ' ' + this.url + "\n" + jqXHR.status + ': ' + errorThrown + '</pre></div>';
    $(Blacklight.Modal.modalSelector).find('.modal-content').html(contents);
    Blacklight.Modal.show();
  };

  BlacklightRangeLimit.turnIntoPlot = function turnIntoPlot(container, wait_for_visible) {
    // flot can only render in a a div with a defined width.
    // for instance, a hidden div can't generally be rendered in (although if you set
    // an explicit width on it, it might work)
    //
    // We'll count on later code that catch bootstrap collapse open to render
    // on show, for currently hidden divs.

    // for some reason width sometimes return negative, not sure
    // why but it's some kind of hidden.
    if (container.width() > 0) {
      var height = container.width() * BlacklightRangeLimit.display_ratio;

      // Need an explicit height to make flot happy.
      container.height( height )

      $('.blrl-plot-config').each(function() {
        $(this).data('plot-config', {
          selection: { color: '#685E57' },
          colors: ['#ffffff'],
          series: { lines: { fillColor: '#a1d6ca' }},
          grid: { color: '#677078', tickColor: '#f4f5f6', borderWidth: 1 }
        });
      });

      BlacklightRangeLimit.areaChart($(container));

      $(container).trigger(BlacklightRangeLimit.redrawnEvent);
    }
    else if (wait_for_visible > 0) {
      setTimeout(function() {
        BlacklightRangeLimit.turnIntoPlot(container, wait_for_visible - 50);
      }, 50);
    }
  }
});
