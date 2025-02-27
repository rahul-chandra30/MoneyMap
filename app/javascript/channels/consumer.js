import { createConsumer } from "@rails/actioncable"

const consumer = createConsumer()


document.addEventListener("turbo:before-cache", () => {
    consumer.disconnect();
});
    export default createConsumer();