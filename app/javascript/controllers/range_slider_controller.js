import { Controller } from "@hotwired/stimulus"

// Dual-handle range slider for blacklight_range_limit
// Connects the slider to the existing min/max text inputs
export default class extends Controller {
  static targets = ["minSlider", "maxSlider", "track", "range"]
  static values = {
    min: Number,
    max: Number
  }

  connect() {
    // Find the associated form inputs
    this.form = this.element.closest("form")
    if (!this.form) return

    this.minInput = this.form.querySelector("input.range_begin")
    this.maxInput = this.form.querySelector("input.range_end")

    if (!this.minInput || !this.maxInput) return

    // Initialize slider positions from input values or defaults
    this.initializeSliders()

    // Listen for changes to text inputs
    this.minInput.addEventListener("change", () => this.syncFromInputs())
    this.maxInput.addEventListener("change", () => this.syncFromInputs())
  }

  initializeSliders() {
    const minVal = parseInt(this.minInput.value) || this.minValue
    const maxVal = parseInt(this.maxInput.value) || this.maxValue

    this.minSliderTarget.value = minVal
    this.maxSliderTarget.value = maxVal

    this.updateRange()
  }

  syncFromInputs() {
    let minVal = parseInt(this.minInput.value) || this.minValue
    let maxVal = parseInt(this.maxInput.value) || this.maxValue

    // Ensure values are within bounds
    minVal = Math.max(this.minValue, Math.min(minVal, this.maxValue))
    maxVal = Math.max(this.minValue, Math.min(maxVal, this.maxValue))

    // Ensure min <= max
    if (minVal > maxVal) {
      minVal = maxVal
    }

    this.minSliderTarget.value = minVal
    this.maxSliderTarget.value = maxVal
    this.updateRange()
  }

  updateMin(event) {
    let minVal = parseInt(this.minSliderTarget.value)
    let maxVal = parseInt(this.maxSliderTarget.value)

    // Prevent min from exceeding max
    if (minVal > maxVal) {
      minVal = maxVal
      this.minSliderTarget.value = minVal
    }

    this.minInput.value = minVal
    this.updateRange()
  }

  updateMax(event) {
    let minVal = parseInt(this.minSliderTarget.value)
    let maxVal = parseInt(this.maxSliderTarget.value)

    // Prevent max from going below min
    if (maxVal < minVal) {
      maxVal = minVal
      this.maxSliderTarget.value = maxVal
    }

    this.maxInput.value = maxVal
    this.updateRange()
  }

  updateRange() {
    const min = this.minValue
    const max = this.maxValue
    const minVal = parseInt(this.minSliderTarget.value)
    const maxVal = parseInt(this.maxSliderTarget.value)

    // Calculate percentages for the highlighted range
    const minPercent = ((minVal - min) / (max - min)) * 100
    const maxPercent = ((maxVal - min) / (max - min)) * 100

    // Update the range highlight
    this.rangeTarget.style.left = `${minPercent}%`
    this.rangeTarget.style.width = `${maxPercent - minPercent}%`
  }
}
