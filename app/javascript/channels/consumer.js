import { createConsumer } from "@rails/actioncable"

const consumer = createConsumer()

export default consumer

document.addEventListener("turbo:before-cache", () => {
    consumer.disconnect();
});