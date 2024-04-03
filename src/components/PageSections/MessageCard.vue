<template>
  <div class="message-card card text-light bg-secondary mb-4">
    <div class="card-body">
      <h5>User Name: {{ messageData.userName }}</h5>
      <p>Date: {{ messageData.date }}</p>
      <p>Product: {{ messageData.productName }}</p>
      <p>Message: {{ messageData.body }}</p>
    </div>
  </div>
</template>

<script>
  export default {
    name: 'MessageCard',
    props: {
      messageData: Object,
    },
  };
</script>


