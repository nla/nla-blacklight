import { Controller } from "@hotwired/stimulus"
import debounce from "lodash.debounce"

// Connects to data-controller="form-validator"
export default class extends Controller {
  static targets = [ "form", "required", "checkbox", "alert", "message" ]
  static values = { message: String, dependentMessage: String }

  connect() {
  }

  initialize() {
    this.validate = debounce(this.validate, 500).bind(this)
  }

  validateSubmit(event) {
    event.preventDefault()

    let form = this.formTarget

    let allRequiredFieldsMissing = this.isAllRequiredFieldsMissing()
    let dependentFieldsMissing = this.isDependentFieldsMissing()
    let checkboxUnchecked = this.hasCheckboxTarget && !this.checkboxTarget.checked

    if (allRequiredFieldsMissing || dependentFieldsMissing) {
      this.toggleAllRequiredFieldsInvalid()
    }

    if (checkboxUnchecked) {
      this.checkboxTarget.classList.add("is-invalid")
      this.checkboxTarget.setAttribute("aria-invalid", "true")
    }

    // If required fields are empty, show the alert and prevent submit
    if (allRequiredFieldsMissing) {
      this.showMessage(this.messageValue)
    } else if (dependentFieldsMissing) {
      this.showMessage(this.dependentMessageValue)
    } else if (checkboxUnchecked) {
      this.showMessage(this.messageValue)
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
        field.removeAttribute("aria-invalid")
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

  validateCheckbox(event) {
    let checkbox = event.target
    if (checkbox.checked) {
      checkbox.classList.remove("is-invalid")
      checkbox.removeAttribute("aria-invalid")
      if (this.isAllRequiredFieldsMissing() === false && !this.isDependentFieldsMissing()) {
        this.hideMessage()
      }
    } else {
      checkbox.classList.add("is-invalid")
      checkbox.setAttribute("aria-invalid", "true")
      this.showMessage(this.messageValue)
    }
  }

  isAllRequiredFieldsMissing() {
    let requiredFields = this.requiredTargets

    return requiredFields.length > 0 && requiredFields.every(field => field.value === "")
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
        field.setAttribute("aria-invalid","true")
      } else {
        field.classList.remove("is-invalid")
        field.removeAttribute("aria-invalid")
      }
    })
  }
}
