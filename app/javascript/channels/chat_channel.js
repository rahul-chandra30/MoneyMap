import consumer from "./consumer"

consumer.subscriptions.create({ channel: "ChatChannel", room: document.getElementById("messages").dataset.chatRoomId }, {

  
  connected() {
    console.log("Connected to the chat room!");
  },

  disconnected() {
    console.log("Disconnected from the chat room.");
  },

  received(data) {
    const messages = document.getElementById("messages");
    const messageElement = document.createElement("div");
    messageElement.classList.add("message");
    messageElement.innerHTML = `
      <strong>${data.sender}:</strong>
      <span>${data.content}</span>
      <small>${data.timestamp}</small>
    `;
    messages.appendChild(messageElement);
    messages.scrollTop = messages.scrollHeight;
  }
});