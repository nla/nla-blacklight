import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="bento-search-results"
export default class extends Controller {
  static targets = [ "output" ]
  static values = { url: String, engine: String }

  connect() {
    this.request = new Request(this.urlValue)
    this.fetchContent(this.request)
  }

  fetchContent(request) {
    fetch(request)
      .then(response => {
        if (response.ok) {
          response.text().then((text) => this.renderContent(text))
        } else {
          this.renderContent("An error occurred.")
        }
      })
      .catch((_error) => {
        this.renderContent("An error occurred.")
      })
  }

  renderContent(content) {
    // this.outputTarget.innerHTML = content;
    this.dispatchEvent();
  }

  dispatchEvent() {
    const event = new CustomEvent("bento-search-results", { detail: { engine: this.engineValue } });
    document.dispatchEvent(event)
  }
}
