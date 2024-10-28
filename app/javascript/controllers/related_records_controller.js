import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="related-records"
export default class extends Controller {
  static targets = [ "link", "icon" ]
  static values = {
    icon: String,
  }

  HOVER_COLOUR = "#dc764c"
  BASE_COLOUR = "#FFFFFF"

  connect() {
    this.registerEventListeners()
  }

  registerEventListeners() {
    if (this.iconValue === "three-level-child") {
      this.registerThreeLevelHandlers();
    } else if(this.iconValue === "two-level-parent") {
      this.registerTwoLevelParentHandlers()
    } else if(this.iconValue === "two-level-child") {
      this.registerTwoLevelChildHandlers()
    }
  }

  setMouseenterFill(indices, link) {
    let rects = this.iconTarget.querySelectorAll("rect")

    link.addEventListener("mouseenter", () => {
      indices.forEach((index) => {
        rects[index].setAttribute("fill", this.HOVER_COLOUR)
      })
    })
  }

  setMouseleaveFill(indices, link) {
    let rects = this.iconTarget.querySelectorAll("rect")

    link.addEventListener("mouseleave", () => {
      indices.forEach((index) => {
        rects[index].setAttribute("fill", this.BASE_COLOUR)
      })
    })
  }

  registerThreeLevelHandlers() {
    this.linkTargets.forEach((link) => {
      if (link.className === "parent") {
        this.setMouseenterFill([0], link)
        this.setMouseleaveFill([0], link)
      }

      if (link.className === "sibling") {
        this.setMouseenterFill([1, 2], link)
        this.setMouseleaveFill([1, 2], link)
      }

      if (link.className === "child") {
        this.setMouseenterFill([4, 5, 6], link)
        this.setMouseleaveFill([4, 5, 6], link)
      }
    })
  }

  registerTwoLevelParentHandlers() {
    this.linkTargets.forEach((link) => {
      if (link.className === "child") {
        this.setMouseenterFill([1, 2, 3], link)
        this.setMouseleaveFill([1, 2, 3], link)
      }
    })
  }

  registerTwoLevelChildHandlers() {
    this.linkTargets.forEach((link) => {
      if (link.className === "parent") {
        this.setMouseenterFill([0], link)
        this.setMouseleaveFill([0], link)
      }

      if (link.className === "child") {
        this.setMouseenterFill([1, 2], link)
        this.setMouseleaveFill([1, 2], link)
      }
    })
  }
}
