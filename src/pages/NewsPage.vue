<template>
  <div class="news-page">
    <NewsHeader />
    <SearchBar @search="performSearch" />
    <h1 class="builder-zone-title my-4 text-center tube-text">PC Tech News</h1>

    <CardCarousel :items="filteredArticles">
      <template v-slot:item="{ item }">
        <NewsCard :key="item.article_id" :article="item" @view-details="handleViewDetails" />
      </template>
    </CardCarousel>
    <NewsDetailModal ref="modal" v-model="showDetails" :article="selectedArticle" />
    <AppFooter />
  </div>
</template>

<script>
import AppFooter from '@/components/PageSections/AppFooter.vue'
import NewsHeader from '@/components/siteNavs/NewsHeader.vue'
import SearchBar from '@/components/PageSections/SearchBar.vue'
import CardCarousel from '@/components/PageSections/CardCarousel.vue'
import NewsDetailModal from '@/components/modals/NewsDetailModal.vue'
import NewsCard from '@/components/PageSections/NewsCard.vue'
import axios from 'axios'

export default {
  name: 'NewsPage',
  components: {
    NewsHeader,
    SearchBar,
    CardCarousel,
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
/* Additional styles for the news page */
</style>
