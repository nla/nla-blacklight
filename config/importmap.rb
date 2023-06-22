# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin_all_from "app/javascript/controllers", under: "controllers"
pin "stimulus-clipboard", to: "https://ga.jspm.io/npm:stimulus-clipboard@4.0.0/dist/stimulus-clipboard.mjs"
pin "stimulus-scroll-reveal", to: "https://ga.jspm.io/npm:stimulus-scroll-reveal@3.2.0/dist/stimulus-scroll-reveal.mjs"
