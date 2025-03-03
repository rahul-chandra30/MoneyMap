import "@hotwired/turbo-rails"
import "controllers"
import "@rails/actioncable"
import "./channels"
import "chartkick"
import "Chart.bundle"
import "./dashboard"

Chartkick.configure({
    language: "en-IN",
    thousands: ",",
    decimal: ".",
    prefix: "₹",
    colors: ["#7EDC97", "#059669", "#10B981"]
})
