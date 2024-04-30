<template>
  <div class="pt-1 dafade d-flex card-carousel justify-content-center">
    <el-carousel
      :interval="100000"
      type="card"
      :motion-blur="false"
      indicator-position="none"
      :pause-on-hover="true"
      arrow="hover"
      height="480px"
    >
      <!-- Modify this loop to use each product as a carousel item -->
      <el-carousel-item v-for="(item, index) in items" :key="index">
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
  min-height: 40vh;
  max-height: 60vh;
  z-index: 1;
  margin-bottom: 1rem;
  margin-top: 1rem;
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
</style>
