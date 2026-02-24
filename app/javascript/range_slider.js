// Range Slider Component
// Syncs dual-handle HTML5 range inputs with number input fields

class RangeSlider {
  constructor(container) {
    this.container = container;
    this.minSlider = container.querySelector('.range-slider-min');
    this.maxSlider = container.querySelector('.range-slider-max');
    this.selectedTrack = container.querySelector('.range-slider-selected');
    
    // Find the associated number inputs in the form
    const form = container.closest('form');
    this.minInput = form.querySelector('.range_begin');
    this.maxInput = form.querySelector('.range_end');
    
    this.min = parseInt(container.dataset.min, 10);
    this.max = parseInt(container.dataset.max, 10);
    
    this.init();
  }
  
  init() {
    // Initialize slider values from number inputs if they have values
    if (this.minInput.value) {
      this.minSlider.value = this.minInput.value;
    }
    if (this.maxInput.value) {
      this.maxSlider.value = this.maxInput.value;
    }
    
    // Update the track highlight
    this.updateTrack();
    
    // Bind slider events
    this.minSlider.addEventListener('input', () => this.onMinSliderChange());
    this.maxSlider.addEventListener('input', () => this.onMaxSliderChange());
    
    // Bind number input events
    this.minInput.addEventListener('input', () => this.onMinInputChange());
    this.maxInput.addEventListener('input', () => this.onMaxInputChange());
  }
  
  onMinSliderChange() {
    let minVal = parseInt(this.minSlider.value, 10);
    let maxVal = parseInt(this.maxSlider.value, 10);
    
    // Prevent min from exceeding max
    if (minVal > maxVal) {
      minVal = maxVal;
      this.minSlider.value = minVal;
    }
    
    this.minInput.value = minVal;
    this.updateTrack();
  }
  
  onMaxSliderChange() {
    let minVal = parseInt(this.minSlider.value, 10);
    let maxVal = parseInt(this.maxSlider.value, 10);
    
    // Prevent max from going below min
    if (maxVal < minVal) {
      maxVal = minVal;
      this.maxSlider.value = maxVal;
    }
    
    this.maxInput.value = maxVal;
    this.updateTrack();
  }
  
  onMinInputChange() {
    let val = parseInt(this.minInput.value, 10);
    if (isNaN(val)) return;
    
    // Clamp to valid range
    val = Math.max(this.min, Math.min(val, this.max));
    
    // Don't exceed max slider
    const maxVal = parseInt(this.maxSlider.value, 10);
    if (val > maxVal) {
      val = maxVal;
    }
    
    this.minSlider.value = val;
    this.updateTrack();
  }
  
  onMaxInputChange() {
    let val = parseInt(this.maxInput.value, 10);
    if (isNaN(val)) return;
    
    // Clamp to valid range
    val = Math.max(this.min, Math.min(val, this.max));
    
    // Don't go below min slider
    const minVal = parseInt(this.minSlider.value, 10);
    if (val < minVal) {
      val = minVal;
    }
    
    this.maxSlider.value = val;
    this.updateTrack();
  }
  
  updateTrack() {
    const minVal = parseInt(this.minSlider.value, 10);
    const maxVal = parseInt(this.maxSlider.value, 10);
    const range = this.max - this.min;
    
    if (range <= 0) return;
    
    const minPercent = ((minVal - this.min) / range) * 100;
    const maxPercent = ((maxVal - this.min) / range) * 100;
    
    this.selectedTrack.style.left = minPercent + '%';
    this.selectedTrack.style.width = (maxPercent - minPercent) + '%';
  }
}

// Initialize all range sliders on the page
function initRangeSliders() {
  document.querySelectorAll('[data-range-slider="true"]').forEach(container => {
    // Check if already initialized
    if (!container.dataset.initialized) {
      new RangeSlider(container);
      container.dataset.initialized = 'true';
    }
  });
}

// Initialize on DOM ready
if (document.readyState === 'loading') {
  document.addEventListener('DOMContentLoaded', initRangeSliders);
} else {
  initRangeSliders();
}

// Re-initialize when Turbo navigates (for Turbo Drive compatibility)
document.addEventListener('turbo:load', initRangeSliders);

// Re-initialize when content is loaded via AJAX (for blacklight modals, etc.)
document.addEventListener('turbo:frame-load', initRangeSliders);

// Also listen for the blacklight range limit's own events
document.addEventListener('blacklight-range-limit:rendered', initRangeSliders);

export { RangeSlider, initRangeSliders };
