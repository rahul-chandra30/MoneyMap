# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin_all_from "app/javascript/controllers", under: "controllers"
pin "actioncable", to: "actioncable.esm.js"
pin "channels/consumer", to: "channels/consumer.js"
pin_all_from "app/javascript/channels", under: "channels"
pin_all_from "app/javascript/custom", under: "custom"
pin "@rails/actioncable", to: "https://ga.jspm.io/npm:@rails/actioncable@7.1.3/app/assets/javascripts/actioncable.esm.js"
pin "../channels/consumer", to: "channels/consumer.js"