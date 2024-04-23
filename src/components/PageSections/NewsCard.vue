<template>
  <div class="news-card card product-card h-100 bg-secondary d-flex flex-column py-auto my-auto">
    <!-- Image container with a fixed aspect ratio -->
    <div class="card-img-container card p-4 d-flex justify-content-center align-items-center">
      <img
        :src="
          article.image_url || article.video_url || article.source_icon || getRandomDefaultImage()
        "
        @error="handleImageError"
        class="news-img-top"
        :alt="article.title"
      />
    </div>
    <div class="card-body text-light d-flex flex-column justify-content-between my-auto py-auto">
      <!-- Article title -->
      <h5 class="card-title text-center font-size-md">{{ article.title }}</h5>
      <a :href="article.source_url" class="tube-text text-center font-size-sm">{{
        article.source_url
      }}</a>

      <!-- Read article button -->
      <button type="button" class="btn btn-success-2 mt-3 my-auto" @click="handleReadArticle">
        Read Article
      </button>
    </div>
  </div>
</template>

<script>
export default {
  name: 'NewsCard',
  props: {
    article: {
      type: Object,
      required: true
    }
  },
  data() {
    return {
      defaultImages: [
        './images/tech-entry-8.png',
        './images/tech-entry-2.png',
        './images/tech-entry-3.png',
        './images/tech-entry-4.png',
        './images/tech-entry-5.png',
        './images/tech-entry-6.png',
        './images/tech-entry-7.png'
      ]
    }
  },
  methods: {
    handleReadArticle() {
      this.$emit('view-details', this.article)
    },
    getRandomDefaultImage() {
      const randomIndex = Math.floor(Math.random() * this.defaultImages.length)
      return this.defaultImages[randomIndex]
    },
    handleImageError(event) {
      event.target.src = this.getRandomDefaultImage()
    }
  }
}
</script>

<style scoped>
/* Styles specific to the news card */
.news-card {
  padding: 1rem;
  width: 100%;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: space-between;
  border-radius: 0.25rem;
}

.card-img-container {
  width: 95%; /* Width is 100% of the card */
  max-height: 250px;
  min-height: 100px; /* Maximum height for your image */
  display: flex;
  justify-content: center;
  align-items: center;
  overflow: hidden;
}

.news-img-top {
  max-width: 100%; /* The image can be as wide as its container */
  max-height: 90%; /* The image can be as tall as its container */

  border-radius: 0.25rem; /* Ensures image maintains aspect ratio but fits within the space */
}

.product-card .card-body {
  flex-grow: 1;
  display: flex;
  flex-direction: column;
  justify-content: space-between;
}

.product-card .card-title {
  text-align: center;
  margin-top: 1rem; /* Add spacing above title if needed */
}

.product-card .btn-success-2 {
  align-self: center; /* Center button horizontally */
  margin-top: auto; /* Pushes the button to the bottom */
}
</style>
