import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="form-validator"
export default class extends Controller {
  static targets = [ "form", "required", "alert", "message" ]
  static values = { message: String }

  connect() {
    console.log("FormValidationController connected", this.element)
    console.log(this.messageValue)
  }

  validateSubmit(event) {
    event.preventDefault()

    let form = this.formTarget

    let allRequiredFieldsMissing = this.isAllRequiredFieldsMissing()

    if (allRequiredFieldsMissing) {
      this.toggleAllRequiredFieldsInvalid()
    }

    // If all of the required fields are empty, show the alert and prevent submit
    if (allRequiredFieldsMissing) {
      this.showMessage()
    } else {
      this.hideMessage()
      form.submit()
    }
  }

  validate(event) {
    let field = event.target
    let requiredFields = this.requiredTargets
    let requiredMessage = this.messageValue

    if (field.value !== "") {
      requiredFields.forEach(function(field) {
        field.classList.remove("is-invalid")
      })

      this.hideMessage()
    } else {
      let allRequiredFieldsMissing = this.isAllRequiredFieldsMissing()

      if (allRequiredFieldsMissing) {
        this.toggleAllRequiredFieldsInvalid()
        this.showMessage()
      }
    }
  }

  isAllRequiredFieldsMissing() {
    let requiredFields = this.requiredTargets

    return requiredFields.every(field => field.value === "")
  }

  showMessage() {
    let requiredMessage = this.messageValue
    this.alertTarget.classList.remove("d-none")
    this.messageTarget.innerText = requiredMessage
  }

  hideMessage() {
    let requiredMessage = this.messageValue
    this.alertTarget.classList.add("d-none")
    this.messageTarget.innerText = ""
  }

  toggleAllRequiredFieldsInvalid() {
    let requiredFields = this.requiredTargets
    requiredFields.forEach(function(field) {
      if (field.value === "") {
        field.classList.add("is-invalid")
      } else {
        field.classList.remove("is-invalid")
      }
    })
  }
}
