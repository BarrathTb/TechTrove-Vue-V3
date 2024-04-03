<template>
  <transition name="slide">
    <section v-show="toggleMessageBoard" class="message-board bg-primary mb-2 mt-2">
      <div class="container p-auto">
        <h2 class="mt-4 tube-text-blue text-align-center">Message Zone</h2>
        <!-- Message Form -->
        <MessageForm :products="products" @message-submitted="addMessage" />

        <!-- Title for Message List -->
        <h2 class="mt-2 tube-text-blue text-align-center">Message Board</h2>

        <!-- Message List -->
        <div class="message-list justify-content-center text-align-center m-auto p-auto">
          <MessageCard v-for="(messageData, index) in messages" :key="index" :message-data="messageData" />
        </div>
      </div>
    </section>
  </transition>
</template>

<script>
  import MessageCard from './MessageCard.vue';
import MessageForm from './MessageForm.vue';

  export default {
    components: {
      MessageForm,
      MessageCard
    },
    name: 'MessageBoard',
    props: {
      products: Array // This passes the products prop through from HomePage.vue
    },
    data() {
      return {
        boardVisible: false,
        messages: [],

      };
    },
    methods: {
      addMessage(messageData) {
        this.messages.push(messageData);
        this.saveMessages();
      },
      loadMessages() {
        const storedMessages = localStorage.getItem('messages');
        if (storedMessages) {
          this.messages = JSON.parse(storedMessages);
        }
      },
      saveMessages() {
        localStorage.setItem('messages', JSON.stringify(this.messages));
      },
      toggleMessageBoard() {
        this.boardVisible = !this.boardVisible;
      },
      closeMessageBoard() { 
        this.boardVisible = false;
      },
    }
  };
</script>

<style scoped>

  .slide-enter-active,
  .slide-leave-active {
    transition:
      opacity 0.5s,
      transform 0.5s;
  }

  .slide-enter-from,
  .slide-leave-to {
    opacity: 0;
    transform: translateY(20px);
  }
</style>
