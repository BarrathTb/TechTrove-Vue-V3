<template>
  <div class="news-page">
    <NewsHeader />
    <SearchBar @search="performSearch" />
    <h1 class="builder-zone-title my-4 text-center tube-text">PC Tech News</h1>
    <div
      v-infinite-scroll="performSearch"
      :infinite-scroll-disabled="loading || !hasMore"
      :infinite-scroll-distance="100"
      :infinite-scroll-immediate="true"
      class="container my-4"
      style="overflow: auto"
    >
      <div class="row">
        <div
          v-for="article in filteredArticles"
          :key="article.article_id"
          class="col-12 col-md-6 col-lg-4 mb-4"
        >
          <NewsCard :article="article" @view-details="handleViewDetails" />
        </div>
      </div>
    </div>
    <NewsDetailModal ref="modal" v-model="showDetails" :article="selectedArticle" />
    <AppFooter />
  </div>
</template>

<script>
import NewsDetailModal from '@/components/modals/NewsDetailModal.vue'
import AppFooter from '@/components/PageSections/AppFooter.vue'
import NewsCard from '@/components/PageSections/NewsCard.vue'
import SearchBar from '@/components/PageSections/SearchBar.vue'
import NewsHeader from '@/components/siteNavs/NewsHeader.vue'
import axios from 'axios'

export default {
  name: 'NewsPage',
  components: {
    NewsHeader,
    SearchBar,

    NewsDetailModal,
    NewsCard,
    AppFooter
  },
  data() {
    return {
      showDetails: false,
      searchTerm: 'cpu',
      article: {
        title: '',
        description: '',
        content: '',
        imageUrl: '',
        link: ''
      },
      selectedArticle: null,
      articles: [], // This will contain the full response for each article
      filteredArticles: [], // You need to clarify how you're using this, as it's not shown in the current context
      apiKey: 'pub_42432940101d255dce87aa371124e98f7a350'
    }
  },
  created() {
    this.performSearch(this.searchTerm) // Perform the search when the component is created
  },
  methods: {
    async performSearch(searchTerm) {
      try {
        const response = await axios.get(
          `https://newsdata.io/api/1/news?apikey=${this.apiKey}&q=${encodeURIComponent(searchTerm)}&language=en&category=technology&category=computers`
        )
        // You should assign the results directly to filteredNews
        this.filteredArticles = response.data.results
        console.log(response.data.results)
      } catch (error) {
        console.error(error)
        if (error.response) {
          // Handle the response error here
          console.log(error.response.data)
        }
        this.$toast.error('Error performing search') // Use your preferred method of error notification
      }
    },
    handleViewDetails(article) {
      // Implement the logic to handle viewing details of each article
      console.log(article)
      this.selectedArticle = article
      this.showDetails = !this.showDetails
    }
  }
}
</script>

<style scoped>
.news-page {
  position: relative;
  min-height: 100vh;
  background-color: #1c1c1c;
}
</style>
<!-- <template>
  <div class="news-page">
    <NewsHeader />
    <SearchBar @search="performSearch" />
    <h1 class="builder-zone-title my-4 text-center tube-text">PC Tech News</h1>

    <div
      v-infinite-scroll="performSearch"
      :infinite-scroll-disabled="loading || !hasMore"
      :infinite-scroll-distance="100"
      :infinite-scroll-immediate="true"
      class="container my-4"
      style="overflow: auto"
    >
      
    </div>
    <div v-if="loading" class="text-center my-4 text-white">Loading more articles...</div>
    <NewsDetailModal ref="modal" v-model="showDetails" :article="selectedArticle" />
    <AppFooter />
  </div>
</template>

<script>
import NewsDetailModal from '@/components/modals/NewsDetailModal.vue'
import AppFooter from '@/components/PageSections/AppFooter.vue'
import NewsCard from '@/components/PageSections/NewsCard.vue'
import SearchBar from '@/components/PageSections/SearchBar.vue'
import NewsHeader from '@/components/siteNavs/NewsHeader.vue'
import axios from 'axios'

export default {
  name: 'NewsPage',
  components: {
    NewsHeader,
    SearchBar,
    NewsDetailModal,
    NewsCard,
    AppFooter
  },
  data() {
    return {
      showDetails: false,
      searchTerm: 'cpu',
      article: {
        title: '',
        description: '',
        content: '',
        imageUrl: '',
        link: ''
      },
      selectedArticle: null,
      articles: [], // This will contain the full response for each article
      filteredArticles: [], // You need to clarify how you're using this, as it's not shown in the current context
      apiKey: 'pub_42432940101d255dce87aa371124e98f7a350',
      currentPage: 1,
      loading: false,
      hasMore: true,
      nextPage: null
    }
  },
  methods: {
    // Moved methods before lifecycle hooks
    async performSearch(searchTerm, nextPageUrl = null) {
      if (this.loading || (!this.hasMore && nextPageUrl !== null)) return // Prevent multiple loads or loading when no more data

      this.loading = true
      this.searchTerm = searchTerm // Update searchTerm when a new search is performed

      try {
        const url = nextPageUrl
          ? `https://newsdata.io/api/1/news?apikey=${this.apiKey}&q=${encodeURIComponent(this.searchTerm)}&language=en&category=technology&category=computers&page=${nextPageUrl}`
          : `https://newsdata.io/api/1/news?apikey=${this.apiKey}&q=${encodeURIComponent(this.searchTerm)}&language=en&category=technology&category=computers`

        const response = await axios.get(url)

        if (nextPageUrl === null) {
          this.filteredArticles = response.data.results || []
        } else {
          this.filteredArticles = [...this.filteredArticles, ...(response.data.results || [])]
        }

        this.nextPage = response.data.nextPage
        this.hasMore = !!this.nextPage // hasMore is true if nextPage is not null

        console.log('API Response:', response.data)
        console.log('Filtered Articles:', this.filteredArticles)
      } catch (error) {
        console.error('Error performing search:', error)
        if (error.response) {
          console.log('Error response data:', error.response.data)
        }
        // Use your preferred method of error notification
        // this.$toast.error('Error performing search');
      } finally {
        this.loading = false
      }
    },
    handleViewDetails(article) {
      // Implement the logic to handle viewing details of each article
      console.log(article)
      this.selectedArticle = article
      this.showDetails = !this.showDetails
    }
  },
  created() {
    this.performSearch(this.searchTerm) // Perform the search when the component is created
  },
  mounted() {
    // Initial search is handled by created hook and infinite scroll immediate loading
  },
  beforeUnmount() {
    // Scroll listener removed as infinite scroll directive is used
  }
}
</script> -->
