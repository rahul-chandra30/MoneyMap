import consumer from "./consumer"

// Add this at the top level
console.log('Chat channel initialized');
console.log('ActionCable consumer status:', consumer.connection.monitor.status);

document.addEventListener("DOMContentLoaded", () => {
    console.log('Checking ActionCable connection:', {
        connection: consumer.connection,
        connectionState: consumer.connection.monitor.state,
        subscriptions: consumer.subscriptions.subscriptions
    });

    const modals = document.querySelectorAll('.modal')

    modals.forEach(modal => {
        const chatRoomId = modal.dataset.chatRoomId
        if (!chatRoomId) return

        const messagesContainer = modal.querySelector('.messages-container')
        const messageForm = modal.querySelector('.message-form')
        const messageInput = modal.querySelector('.message-input')
        const statusIndicator = modal.querySelector('.connection-status')

        let subscription

        function connectToChat() {
            subscription = consumer.subscriptions.create(
                {
                    channel: "ChatChannel",
                    room_id: chatRoomId
                },
                {
                    connected() {
                        console.log("Connected to ChatChannel", chatRoomId)
                        statusIndicator.textContent = "Connected"
                        statusIndicator.classList.remove('disconnected')
                        statusIndicator.classList.add('connected')
                    },

                    disconnected() {
                        console.log("Disconnected from ChatChannel")
                        statusIndicator.textContent = "Disconnected"
                        statusIndicator.classList.remove('connected')
                        statusIndicator.classList.add('disconnected')

                        // Try to reconnect after 3 seconds
                        setTimeout(connectToChat, 3000)
                    },

                    received(data) {
                        if (data.error) {
                            logError(data.error, 'process message')
                            return
                        }
                        messagesContainer.insertAdjacentHTML('beforeend', data.message)
                    }
                }
            )
        }

        function logError(error, context) {
            console.error(`Chat Error [${context}]:`, error)
            const errorMessage = `Failed to ${context}. Please try again.`
            const errorDiv = document.createElement('div')
            errorDiv.className = 'chat-error'
            errorDiv.textContent = errorMessage
            messagesContainer.appendChild(errorDiv)
            setTimeout(() => errorDiv.remove(), 5000)
        }

        connectToChat()

        messageForm?.addEventListener("submit", async (e) => {
            e.preventDefault()
            const sendButton = messageForm.querySelector('input[type="submit"]')
            const content = messageInput.value.trim()

            if (content) {
                try {
                    sendButton.disabled = true
                    subscription.send({ content: content })
                    messageInput.value = ''
                    messageInput.focus()
                } catch (error) {
                    console.error('Error sending message:', error)
                    alert('Failed to send message. Please try again.')
                } finally {
                    sendButton.disabled = false
                }
            }
        })
    })
})