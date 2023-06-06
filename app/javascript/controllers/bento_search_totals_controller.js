import {Controller} from "@hotwired/stimulus"

// Connects to data-controller="bento-search-totals"
export default class extends Controller {
  static targets = [ "catalogue", "ebsco_eds_keyword", "ebsco_eds_title", "finding_aids" ]

  connect() {
  }

  updateTotals(event) {
    console.log(event);
    const engine = event.detail.engine;
    this[`${engine}Target`].textContent = document.getElementById(
        `${engine}_total`).textContent;
  }
}
