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

    // Find the range_limit container for later chart lookups
    this.rangeLimitContainer = this.element.closest(".range_limit")

    // Initialize slider positions from input values or defaults
    this.initializeSliders()

    // Listen for changes to text inputs
    this.minInput.addEventListener("change", () => this.syncFromInputs())
    this.maxInput.addEventListener("change", () => this.syncFromInputs())

    // Watch for chart creation and update selection when ready
    this.waitForChartAndUpdateSelection()
  }

  disconnect() {
    // Clean up observer when controller disconnects
    if (this._chartObserver) {
      this._chartObserver.disconnect()
      this._chartObserver = null
    }
  }

  getChartCanvas() {
    // Always re-query for the canvas as it may be created dynamically
    if (this.rangeLimitContainer) {
      this._chartCanvas = this.rangeLimitContainer.querySelector(".blacklight-range-limit-chart")
    }
    return this._chartCanvas
  }

  // Wait for the Chart.js chart to be created and then update the selection overlay
  waitForChartAndUpdateSelection() {
    const canvas = this.getChartCanvas()
    
    // If canvas exists and has a chart, update immediately
    if (canvas && typeof Chart !== 'undefined' && Chart.getChart(canvas)) {
      this.updateChartSelectionFromCurrentValues()
      return
    }

    // Otherwise, watch for the canvas to be added to the DOM
    if (this.rangeLimitContainer) {
      this._chartObserver = new MutationObserver((mutations) => {
        const canvas = this.getChartCanvas()
        if (canvas) {
          // Canvas found, now wait for Chart.js to initialize it
          this.pollForChartReady(canvas)
          this._chartObserver.disconnect()
          this._chartObserver = null
        }
      })

      this._chartObserver.observe(this.rangeLimitContainer, {
        childList: true,
        subtree: true
      })
    }
  }

  // Poll for the Chart.js instance to be ready on the canvas
  pollForChartReady(canvas, attempts = 0) {
    const maxAttempts = 20 // Try for up to 2 seconds
    const interval = 100 // Check every 100ms

    if (typeof Chart !== 'undefined' && Chart.getChart(canvas)) {
      this.updateChartSelectionFromCurrentValues()
      return
    }

    if (attempts < maxAttempts) {
      setTimeout(() => this.pollForChartReady(canvas, attempts + 1), interval)
    }
  }

  // Update chart selection based on current slider/input values
  updateChartSelectionFromCurrentValues() {
    const minVal = parseInt(this.minSliderTarget.value)
    const maxVal = parseInt(this.maxSliderTarget.value)
    this.updateChartSelection(minVal, maxVal)
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

    // Update the range highlight on the slider
    this.rangeTarget.style.left = `${minPercent}%`
    this.rangeTarget.style.width = `${maxPercent - minPercent}%`

    // Update the chart selection annotation if chart exists
    this.updateChartSelection(minVal, maxVal)
  }

  updateChartSelection(minVal, maxVal) {
    const canvas = this.getChartCanvas()
    // Use the global function exposed by range_limit.js
    if (canvas && typeof window.updateRangeLimitChartSelection === 'function') {
      window.updateRangeLimitChartSelection(canvas, minVal, maxVal)
    }
  }
}
