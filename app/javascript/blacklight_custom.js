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

  let blacklightModal = $('#blacklight-modal');
  let modalObserver = new MutationObserver(function(mutations) {
    mutations.forEach(function(mutation) {
      const newNodes = mutation.addedNodes;
      if (newNodes !== null) {
        let plotConfig = blacklightModal.find('.blrl-plot-config');
        if (plotConfig) {
          plotConfig.data('plot-config', {
            selection: { color: '#46474A' },
            colors: ['#ffffff'],
            series: { lines: { fillColor: 'rgba(112,57,150, 0.8)' }},
            grid: { color: '#677078', tickColor: '#f4f5f6', borderWidth: 1 }
          });
        }
      }
    });
  });
  let observerConfig = {
    childList: true,
    subtree: true
  }
  modalObserver.observe(blacklightModal[0], observerConfig);

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

    console.error('Server error:', this.url, jqXHR.status, errorThrown);
    var contents = '<div class="modal-header">' + '<div class="modal-title">There was a problem with your request.</div>' + '<button type="button" class="blacklight-modal-close btn-close close" data-dismiss="modal" aria-label="Close">' + '  <span aria-hidden="true">&times;</span>' + '</button></div>' + ' <div class="modal-body"><p>Expected a successful response from the server, but got an error</p>' + '<pre>' + this.type + ' ' + this.url + "\n" + jqXHR.status + ': ' + errorThrown + '</pre></div>';
    $(Blacklight.Modal.modalSelector).find('.modal-content').html(contents);
    Blacklight.Modal.show();
  };
});
