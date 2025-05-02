<template>
  <VaModal v-model="showModal" fullscreen class="rounded news-detail-modal bg-primary">
    <template #content>
      <div class="modal-lg rounded bg-primary p-4" style="border-radius: 10px">
        <div class="modal-header d-flex justify-content-end align-items-center mb-2">
          <button
            class="btn btn-outline-success p-0 m-0"
            style="text-decoration: none; background-color: transparent; border: light"
            @click="closeModal"
          >
            <i class="bi bi-x fs-4"></i>
          </button>
        </div>

        <div class="modal-body d-flex flex-column rounded justify-content-center">
          <div class="card-img-container p-4 d-flex justify-content-center align-items-center">
            <img
              :src="article.image_url"
              class="article-image justify-content-center"
              style="border-radius: 10px; margin-bottom: 20px"
              :alt="article.title"
            />
          </div>
          <h5 class="card-title text-center text-white font-size-md mb-4">{{ article.title }}</h5>

          <div class="text-left">
            <p class="text-white">{{ article.description }}</p>
            <p class="text-white">{{ article.content }}---- Article Content Here:</p>
          </div>
        </div>
      </div>
    </template>
  </VaModal>
</template>

<script>
import { VaModal } from 'vuestic-ui'
export default {
  name: 'ProductDetailModal',
  components: {
    VaModal
  },
  props: {
    article: {
      type: Object,
      required: true
    }
  },

  data() {
    return {
      showModal: false
    }
  },

  methods: {
    closeModal() {
      this.showModal = false
      this.$emit('update:modelValue', false)
    },
    handleReadArticle() {
      this.showDetails = this
      //
    }
  }
}
</script>
<style scoped>
.news-detail-modal {
  position: relative;
  z-index: 1000;
  justify-content: center;
  align-items: center;
}
.news-detail-modal .modal-lg {
  margin: auto;
  /* Center the modal content horizontally and vertically */
}

/* Adjust modal width for larger screens */
@media (min-width: 768px) {
  .news-detail-modal {
    width: 70%; /* Adjust as needed */
    max-width: 1000px; /* Maximum width */
  }
}

.article-image {
  max-width: 100%; /* Ensure image doesn't exceed container width */
  height: auto; /* Maintain aspect ratio */
  display: block; /* Remove extra space below image */
  margin: 0 auto 20px auto; /* Center image and add bottom margin */
}
/* Styling for modal content */
.news-detail-modal .modal-body {
  padding: 20px;
  line-height: 1.6;
  color: #ffffff; /* Ensure text is readable on gradient */
  background: linear-gradient(to bottom, #1a1a1a, #4a0e4a); /* Smooth gradient background */
  overflow-y: auto; /* Add scroll for long content */
  max-width: 1000px;
  justify-content: center;
  align-items: center;
}

.news-detail-modal .card-title {
  font-size: 1.8rem;
  margin-bottom: 15px;
}

.news-detail-modal .text-left {
  margin-bottom: 15px;
}

.news-detail-modal .text-left p {
  margin-bottom: 10px;
}

/* Adjust padding for smaller screens */
@media (max-width: 767.98px) {
  .news-detail-modal .modal-body {
    padding: 15px;
  }

  .news-detail-modal .card-title {
    font-size: 1.5rem;
  }
}
</style>
