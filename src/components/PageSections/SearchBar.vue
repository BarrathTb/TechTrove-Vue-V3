<!-- @format -->

<template>
  <div class="row align-items-center justify-content-center da-fade px-4 py-4">
    <div class="col-sm-12 col-md-8 col-lg-6">
      <div class="d-flex ms-2 mb-2 flex-grow-1">
        <input
          v-model="searchTerm"
          class="form-control search-input"
          type="search"
          placeholder="Search for computer parts, brands, and accessories"
          aria-label="Search"
        />
        <button class="btn btn-success ms-2" @click.prevent="performSearch($event)" type="submit">
          <span class="text-banner-button">Search</span>
        </button>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'SearchBar',
  data() {
    return {
      searchTerm: ''
    }
  },
  methods: {
    performSearch(event) {
      event.preventDefault()
      this.$emit('search', this.searchTerm)
    }
  }
}
</script>

<style scoped>
/* .search-input {
    width: calc(12vw * 0.75);
    height: calc(12vh * 0.75);
    margin: 0.2rem;
  } */
.text-banner-button {
  font-size: calc(2vw * 0.8);
  font-weight: 600;
  color: #fff;
  text-shadow:
    5px 0px 20px rgba(0, 0, 0, 0.8),
    -1px -1px 0 #000,
    /* Black border on top and left */ 1px 1px 0 #000; /* Black border on bottom and right for 3D effect */
}

@media (max-width: 576px) {
  .text-banner-button {
    font-size: calc(4vw * 0.8);
    font-weight: 600;
    color: #fff;
    text-shadow:
      5px 0px 20px rgba(0, 0, 0, 0.8),
      -1px -1px 0 #000,
      /* Black border on top and left */ 1px 1px 0 #000; /* Black border on bottom and right for 3D effect */
  }
}
.da-fade {
  background: linear-gradient(180deg, black 0%, #161616 20%, #161616 60%, #0ee636 100%);
  height: calc(15vh * 0.75);
}
</style>
