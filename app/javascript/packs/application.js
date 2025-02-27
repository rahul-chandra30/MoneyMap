import Rails from "@rails/ujs"
import * as ActiveStorage from "@rails/activestorage"
import "channels"
import "../channels/chatbot_channel" 

Rails.start()
ActiveStorage.start()

console.log('Application.js loaded')