<template>
  <div class="pt-1 dafade d-flex card-carousel justify-content-center">
    <el-carousel
      :interval="100000"
      :type="carouselType"
      :motion-blur="false"
      indicator-position="none"
      :pause-on-hover="true"
      arrow="hover"
      height="100%"
    >
      <!-- Skeleton Loader before the items are loaded -->
      <div v-if="!items || !items.length" class="skeleton-loader-container">
        <div v-for="index in 3" :key="'skeleton-' + index" class="skeleton-loader"></div>
      </div>
      <!-- Modify this loop to use each product as a carousel item -->
      <el-carousel-item v-else v-for="(item, index) in items" :key="index">
        <!-- This slot now passes an individual item instead of grouping them -->
        <slot name="item" :item="item"></slot>
      </el-carousel-item>
    </el-carousel>
  </div>
</template>

<script>
export default {
  name: 'CardCarousel',
  props: {
    items: {
      type: Array,
      required: false
    }
  },
  data() {
    return {
      screenWidth: window.innerWidth
    }
  },
  computed: {
    carouselType() {
      return this.screenWidth > 768 ? 'card' : undefined
    }
  },
  methods: {
    handleResize() {
      this.screenWidth = window.innerWidth
    }
  },
  mounted() {
    window.addEventListener('resize', this.handleResize)
  },
  beforeUnmount() {
    window.removeEventListener('resize', this.handleResize)
  }
}
</script>

<style>
.dafade {
  background: linear-gradient(180deg, #161616 0%, black 100%);
}
.card-carousel {
  max-width: 100vw;
}

.el-carousel {
  width: 70vw;
  background: linear-gradient(180deg, #161616 0%, black 100%);
  z-index: 1;
  margin-bottom: 1rem;
  margin-top: 1rem;
  /* Wide screen styles */
  min-height: 55vh;
  max-height: 60vh;
}

@media (max-width: 768px) {
  .el-carousel {
    /* Mobile styles */
    min-height: 40vh;
    max-height: 50vh;
    width: 80vw;
    margin: 0 auto;
  }
}

.el-carousel__item {
  background: none;
  max-width: 80vw;
  max-height: 60vh;
}
.el-carousel__container {
  max-width: 80vw;
}
.el-carousel__mask {
  background: none;
}
.skeleton-loader-container {
  display: flex;
  justify-content: space-around;
}

.skeleton-loader {
  width: 200px; /* Adjust width as necessary */
  height: 300px; /* Adjust height as necessary */
  background-color: #ddd;
  border-radius: 4px;
  margin: 10px;
  animation: shimmer 2s infinite;
  background-image: linear-gradient(to right, #eeeeee 8%, #dddddd 18%, #eeeeee 33%);
  background-size: 1000px 104px;
}

@keyframes shimmer {
  0% {
    background-position: -1000px 0;
  }
  100% {
    background-position: 1000px 0;
  }
}
</style>
