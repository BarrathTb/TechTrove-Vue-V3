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
          Search
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

.da-fade {
  background: linear-gradient(180deg, black 0%, #161616 20%, #161616 60%, #0ee636 100%);
  height: calc(15vh * 0.75);
}
</style>
