import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="email-2fa-alert"
export default class extends Controller {
  static values = {
    url: String,
    dismissUrl: String
  }

  connect() {
    this.fetchContent()
  }

  fetchContent() {
    fetch(this.urlValue)
    .then(response => {
      if (response.ok) {
        response.text().then((text) => this.element.innerHTML = text)
      } else {
        this.element.innerHTML = "An error occurred."
      }
    })
    .catch((_error) => {
      this.element.innerHTML = "An error occurred."
    })
  }

  dismiss() {
    fetch(this.dismissUrlValue)
    .then(response => {
      if (response.ok) {
        console.log("dismissed")
        this.fetchContent()
      } else {
        this.element.innerHTML = "An error occurred."
      }
    })
    .catch((_error) => {
      this.element.innerHTML = "An error occurred."
    })
  }
}
