import consumer from "./consumer"

document.addEventListener('turbo:load', () => {
  const element = document.getElementById('messages')
  if (element) {
    const chatRoomId = element.dataset.chatRoomId

    consumer.subscriptions.create({ 
      channel: "ChatChannel", 
      room_id: chatRoomId 
    }, {
      connected() {
        console.log("Connected to ChatChannel for room:", chatRoomId)
      },

      disconnected() {
        console.log("Disconnected from ChatChannel")
      },

      received(data) {
        console.log("Received message:", data)
        const messageContainer = document.createElement('div')
        messageContainer.innerHTML = data.message
        element.appendChild(messageContainer.firstChild)
        element.scrollTop = element.scrollHeight
      }
    })
  }
})