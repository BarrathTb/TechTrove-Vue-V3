<template>
  <div class="welcome-container-two bg-primary">
    <VaAccordion v-model="activeIndex" class="bg-primary max-w-md" multiple popout>
      <VaCollapse
        :header="title"
        class="accordion-item bg-primary text-light"
        :key="collapseId"
        @opened="handleOpened"
        @closed="handleClosed"
      >
        <template v-slot:icon="{ expand }">
          <va-icon v-if="expand" name="expand_less" />
          <va-icon v-else name="expand_more" />
        </template>
        <div class="row m-4 g-3">
          <slot></slot>
        </div>
      </VaCollapse>
    </VaAccordion>
  </div>
</template>

<script>
export default {
  name: 'HowItWorksAccordion',
  props: {
    title: String,
    collapseId: String
  },
  data() {
    return {
      activeIndex: [false, false]
    }
  },
  methods: {
    handleOpened() {
      this.$emit('accordion-opened', this.collapseId)
    },
    handleClosed() {
      this.$emit('accordion-closed', this.collapseId)
    }
  }
}
</script>

<style>
:root {
  --primary-color: #0eaa2a;
  --inverted-color: #000;
}
.welcome-container-two {
  width: 80%;
}
.accordion-item {
  width: 100%;
}

.va-collapse__header:focus {
  color: var(--light-color);
}

.va-collapse__header:hover {
  text-shadow: 0 0 0 8px var(--primary-color) 0.5s ease;
}

.va-collapse--expanded .va-collapse__header,
.va-collapse__header.active {
  color: var(--inverted-color);
  box-shadow: inset 0 0 0 1px var(--primary-color);
  background-color: var(--primary-color);
}

.va-collapse__header-title {
  font-size: calc(0.7rem + 1vw);
}

.va-collapse__content-enter-active,
.va-collapse__content-leave-active {
  transition: max-height 1s ease-in-out;
}

.va-collapse__content-enter,
.va-collapse__content-leave-to {
  max-height: 0;
  overflow: hidden;
}
</style>
