import { Controller } from "@hotwired/stimulus"
import debounce from "lodash.debounce"

// Connects to data-controller="form-validator"
export default class extends Controller {
  static targets = [ "form", "required", "alert", "message" ]
  static values = { message: String, dependentMessage: String }

  connect() {
    console.log("dependentMessage", this.dependentMessageValue)
  }

  initialize() {
    this.validate = debounce(this.validate, 500).bind(this)
  }

  validateSubmit(event) {
    event.preventDefault()

    let form = this.formTarget

    let allRequiredFieldsMissing = this.isAllRequiredFieldsMissing()
    let dependentFieldsMissing = this.isDependentFieldsMissing()

    if (allRequiredFieldsMissing || dependentFieldsMissing) {
      this.toggleAllRequiredFieldsInvalid()
    }

    // If required fields are empty, show the alert and prevent submit
    if (allRequiredFieldsMissing) {
      this.showMessage(this.messageValue)
    } else if (dependentFieldsMissing) {
      this.showMessage(this.dependentMessageValue)
    } else {
      this.hideMessage()
      form.submit()
    }
  }

  validate(event) {
    let field = event.target
    let requiredFields = this.requiredTargets

    let dependentFieldsMissing = this.isDependentFieldsMissing()

    if (field.value !== "") {
      requiredFields.forEach(function(field) {
        field.classList.remove("is-invalid")
      })

      if (dependentFieldsMissing) {
        this.toggleAllRequiredFieldsInvalid()
        this.showMessage(this.dependentMessageValue)
      }
    } else {
      let allRequiredFieldsMissing = this.isAllRequiredFieldsMissing()

      if (allRequiredFieldsMissing) {
        this.toggleAllRequiredFieldsInvalid()
        this.showMessage(this.messageValue)
      } else if (dependentFieldsMissing) {
        this.toggleAllRequiredFieldsInvalid()
        this.showMessage(this.dependentMessageValue)
      }
    }
  }

  isAllRequiredFieldsMissing() {
    let requiredFields = this.requiredTargets

    return requiredFields.every(field => field.value === "")
  }

  isDependentFieldsMissing() {
    let dependentElements = []

    let requiredFields = this.requiredTargets
    requiredFields.forEach(function(field) {
      let dependentFields = field.dataset.dependentFields
      if (dependentFields) {
        let dependentFieldsArray = dependentFields.split(",")

        dependentFieldsArray.forEach(function(dependentField) {
          dependentElements.push(document.getElementById(`request_${dependentField}`))
        })
      }
    })

    return dependentElements.length > 0 && dependentElements.every(field => field.value === "")
  }

  showMessage(message) {
    this.alertTarget.classList.remove("d-none")
    this.messageTarget.innerText = message
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
