import consumer from "./consumer"

consumer.subscriptions.create({ channel: "GroupChatChannel", room: "users" }, {
  connected() {
    console.log("Connected to the group chat!");
  },

  disconnected() {
    console.log("Disconnected from the group chat.");
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