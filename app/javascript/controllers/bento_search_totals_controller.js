import {Controller} from "@hotwired/stimulus"

// Connects to data-controller="bento-search-totals"
export default class extends Controller {
  static targets = [ "catalogue", "ebsco_eds_keyword", "ebsco_eds_title", "finding_aids" ]

  connect() {
  }

  updateTotals(event) {
    const engine = event.detail.engine;
    const no_results_el = document.querySelector(`#${engine} p.bento_search_no_results`);
    const totals_el = document.getElementById(`${engine}_total`);

    // The "no results" message element is displayed, so we can assume that there are no results.
    if (no_results_el !== null) {
      this[`${engine}Target`].textContent = "0";
    }
    // The button with the total is not displayed, but the no results message is also not displayed
    // so we can assume that there is only 1 result.
    else if (totals_el === null) {
      this[`${engine}Target`].textContent = "1";
    }
    // The "no results" is not displayed, but the totals button is displayed,
    else {
      this[`${engine}Target`].textContent = totals_el.textContent;
    }
  }
}
