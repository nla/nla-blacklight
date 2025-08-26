class AutocompleteDropdown {
  constructor() {
    this.initialized = false;
  }

  init() {
    if (this.initialized) return;

    customElements.whenDefined('auto-complete').then(() => {
      this.attachEventListeners();
      this.setupMutationObserver();
      this.initialized = true;
    });
  }

  attachEventListeners() {
    document.addEventListener('mousedown', (event) => {
      this.handleMouseDown(event);
    });

    document.addEventListener('focusout', (event) => {
      this.handleFocusOut(event);
    });
  }

  handleMouseDown(event) {
    const autoComplete = document.querySelector('auto-complete[open]');
    const searchInput = document.querySelector('.search-q');
    const dropdown = document.querySelector('#autocomplete-popup');

    if (autoComplete && dropdown) {
      const clickedOutside = !autoComplete.contains(event.target);

      if (clickedOutside) {
        this.hideDropdown(autoComplete, searchInput);
      }
    }
  }

  handleFocusOut(event) {
    if (event.target.classList.contains('search-q')) {

      setTimeout(() => {
        const autoComplete = document.querySelector('auto-complete[open]');
        const searchInput = document.querySelector('.search-q');

        if (autoComplete) {
          this.hideDropdown(autoComplete, searchInput);
        }
      }, 200);
    }
  }

  hideDropdown(autoComplete, searchInput) {
    autoComplete.removeAttribute('open');
    if (searchInput) {
      searchInput.setAttribute('aria-expanded', 'false');
    }
  }

  setupMutationObserver() {
    observer.observe(document.body, {
      subtree: true,
      attributes: true,
      attributeFilter: ['open', 'aria-expanded']
    });
  }
}

if (document.readyState === 'loading') {
  document.addEventListener('DOMContentLoaded', () => {
    const dropdown = new AutocompleteDropdown();
    dropdown.init();
  });
} else {
  const dropdown = new AutocompleteDropdown();
  dropdown.init();
}
