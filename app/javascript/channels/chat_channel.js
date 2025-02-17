import consumer from "./consumer"

document.addEventListener("DOMContentLoaded", () => {
  const messages = document.getElementById("messages")
  if (messages) {
    const chatRoomId = messages.dataset.chatRoomId

    consumer.subscriptions.create(
      {
        channel: "ChatChannel",
        room: chatRoomId
      },
      {
        connected() {
          console.log("Connected to ChatChannel!")
        },

        disconnected() {
          console.log("Disconnected from ChatChannel")
        },

        received(data) {
          const messageContainer = document.createElement("div")
          messageContainer.classList.add("message")
          messageContainer.innerHTML = `
            <strong>${data.sender}:</strong>
            <span>${data.content}</span>
            <small>${data.timestamp}</small>
          `
          messages.appendChild(messageContainer)
          messages.scrollTop = messages.scrollHeight
        }
      }
    )
  }
})