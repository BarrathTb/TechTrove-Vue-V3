<template>
  <VaModal v-model="showModal" fullscreen class="rounded news-detail-modal">
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
          <div class="row px-4">
            <h5 class="card-title text-center text-white font-size-md mb-4">{{ article.title }}</h5>

            <div class="col-8 text-left">
              <p class="text-white">{{ article.description }}</p>
              <p class="text-white">{{ article.content }}---- Article Content Here:</p>
            </div>
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
  width: 50vw;
  height: 60vh;
}
.article-image {
  max-width: 70vw;
}
</style>
