// app/javascript/channels/notification_channel.js

import consumer from "./consumer";

const notificationsChannel = consumer.subscriptions.create("NotificationsChannel", {
    connected() {
        console.log("Connected to NotificationsChannel");
    },

    disconnected() {
        console.log("Disconnected from NotificationsChannel");
    },

    received(data) {
        console.log("Notification received:", data);
        this.addNotification(data);
    },

    addNotification(data) {
        const list = document.getElementById('notification-list');
        if (!list) {
            console.error("Notification list not found!");
            return;
        }

        // Clear "No notifications" if present
        const emptyNotice = list.querySelector('.notification-empty');
        if (emptyNotice) {
            emptyNotice.remove();
        }

        // Add new notification
        const notification = document.createElement('li');
        notification.className = 'notification-item';
        notification.innerHTML = `
      <strong>${data.title}</strong>
      <p>${data.message}</p>
      <small>${data.time || 'Just now'}</small>
    `;
        list.insertBefore(notification, list.firstChild); // Add to top

        // Update count
        const countElement = document.getElementById('notification-count');
        if (countElement) {
            const currentCount = parseInt(countElement.textContent || '0') + 1;
            countElement.textContent = currentCount;
            countElement.style.display = 'block';
            console.log("Updated notification count to:", currentCount);
        }
    }
});

// Dropdown toggle
document.addEventListener('DOMContentLoaded', () => {
    const notificationBtn = document.getElementById('notification-btn');
    const dropdown = document.getElementById('notification-dropdown');

    if (!notificationBtn || !dropdown) {
        console.warn("Notification button or dropdown not found");
        return;
    }

    notificationBtn.addEventListener('click', (e) => {
        e.stopPropagation();
        console.log('Toggling notification dropdown');
        dropdown.style.display = dropdown.style.display === 'block' ? 'none' : 'block';
    });

    document.addEventListener('click', (e) => {
        if (!dropdown.contains(e.target) && e.target !== notificationBtn) {
            console.log('Closing dropdown - clicked outside');
            dropdown.style.display = 'none';
        }
    });
});

export default notificationsChannel;