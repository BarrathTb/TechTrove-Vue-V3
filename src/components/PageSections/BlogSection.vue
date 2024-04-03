<template>
  <transition name="slide">
    <section v-show="toggleBlogVisibility" class="bg-primary py-5" id="blog-section">
      <div class="container">
        <div
          class="card border-0 blog-background rounded-3 p-3 text-light mx-auto"
          style="max-width: 1000px"
        >
          <h2 class="text-center tube-text-pink mb-4">Blog Zone</h2>
          <!-- Blog Article -->
          <div
            v-for="(article, index) in articles"
            :key="index"
            class="card bg-secondary rounded-3 text-light p-3 mx-auto mb-4"
            style="max-width: 900px"
          >
            <h3 class="text-center my-2">{{ article.title }}</h3>
            <img
              class="card-img-top rounded-3 my-4"
              :src="article.imageSrc"
              :alt="article.imageAlt"
            />
            <p class="mx-2 my-2">{{ article.introduction }}</p>
            <p class="mx-2 my-2">{{ article.contents }}</p>
            <ul class="mx-2 my-2">
              <li v-for="(point, i) in article.points" :key="i">{{ point }}</li>
            </ul>
            <p class="mx-2 my-2">{{ article.conclusion }}</p>
          </div>
        </div>
      </div>
    </section>
  </transition>
</template>

<script>
export default {
  name: 'BlogSection',
  data() {
    return {
      articles: [
        {
          title: 'Unleashing the Power: A Deep Dive into the Latest Graphics Cards',
          imageSrc: '/TechTrove-Web-Vue-V3/images/asus-rog-strix-4090-btf.png',
          imageAlt: 'Latest Graphics Cards',
          introduction:
            'Discover how the new generation of graphics cards elevates gaming and professional graphics work to a whole new level.',
          contents: `
              Leveraging breakthrough technologies like ray tracing and AI-driven enhancements, these cards redefine performance benchmarks.
              
              Ray Tracing: Experience the pinnacle of photo-realistic graphics with advanced ray tracing technology that mimics the complex interactions between light and materials.\n

              AI-Driven Enhancements: AI algorithms transform the graphical landscape through intelligent upscaling, dynamic performance tweaks, and efficient noise reduction techniques for pristine image quality.\n

              Redefining Performance Benchmarks: The integration of these cutting-edge technologies results in unprecedented leaps in performance, enabling new standards that push the boundaries of realism in digital content.
          `,
          points: [
            'Comprehensive reviews and benchmarks',
            'Insights into real-time ray tracing capabilities',
            'Comparison across brands and models',
            'Future-proofing your machine with the right card'
          ],
          conclusion:
            'Whether youre a dedicated gamer or a creative professional, find out which card suits your needs best.'
        },
        {
          title: 'The Heart of Your Machine: Choosing the Right CPU for Your Build',
          imageSrc: '/TechTrove-Web-Vue-V3/images/AMD Ryzen Threadripper 3960X.webp',
          imageAlt: 'Choosing the Right CPU',
          introduction:
            "Any PC builder knows the central role a processor plays in a system's performance. We discuss how to choose the best one for you.",
          contents:
            "The CPU is at the core of any build, dictating the performance and capabilities of your machine. Making the right choice involves understanding key factors:\n\nCore Counts: The number of cores in a CPU determines how it can handle multiple tasks. More cores mean better multitasking and improved performance in threaded applications.\n\nClock Speeds: A CPU's clock speed measures its processing frequency; higher speeds translate to quicker execution of tasks.\n\nCompatibility with Motherboards: Ensuring that your CPU fits the socket on your motherboard is crucial, alongside verifying chipset compatibility for optimal performance.\n\nFuture-proofing: With technology advancing rapidly, consider the upgrade path and longevity of the CPU in context of upcoming advancements.",
          points: [
            'Finding the balance between price and power',
            'Analyzing the impact of cores and threads on multitasking',
            'Understanding compatibility with motherboards',
            "The future of computing: What's on the horizon for CPUs?"
          ],
          conclusion:
            "Explore our guide to making an informed decision that will drive your computer's performance for years."
        },
        {
          title: 'Speed Up Your Load Times: SSDs are the Game Changer',
          imageSrc: '/TechTrove-Web-Vue-V3/images/Samsung 980 PRO.webp',
          imageAlt: 'Solid State Drives',
          introduction:
            'Gone are the days of lengthy load times. Solid-state drives (SSDs) have revolutionized data access speeds. We examine the technology behind SSDs and why they offer such a significant speed improvement over traditional hard drives.',
          contents:
            "SSD vs HDD: Understanding the Technology\n\nExplore the fundamental differences between solid-state drives (SSDs) and hard disk drives (HDDs). Learn how SSDs' lack of moving parts reduces wear and tear while allowing for faster data access.\n\nBenchmarking Load Times: Real-World Applications\n\nDiscover how SSDs significantly reduce load times through various benchmarks and real-world scenarios. See side-by-side comparisons that illustrate the time saved in everyday computing tasks.\n\nHow SSDs Can Extend the Life of Your Laptop\n\nUnderstand how upgrading to an SSD can rejuvenate aging laptops, offering better battery life and improved performance. Consider how the durability and efficiency of SSDs contribute to a longer lifespan for your portable devices.\n\nInstallation Tips and Best Practices for Maintenance\n\nGet practical advice on how to properly install an SSD in your system without complications. Learn about maintaining your SSD to ensure peak performance and longevity through best practices.",
          points: [
            'SSD vs HDD: Understanding the technology',
            'Benchmarking load times: Real-world applications',
            'How SSDs can extend the life of your laptop',
            'Installation tips and best practices for maintenance'
          ],
          conclusion:
            'Upgrade to an SSD and feel the difference in every task from booting up to shutting down.'
        }
      ]
    }
  },
  methods: {
    toggleBlogVisibility() {
      this.isBlogVisible = !this.isBlogVisible
    }
  }
}
</script>

<style scoped>
.slide-enter-active,
.slide-leave-active {
  transition:
    opacity 0.5s,
    transform 0.5s;
}

.slide-enter-from,
.slide-leave-to {
  opacity: 0;
  transform: translateY(20px);
}

.card h3 {
  font-size: 1.5em;
}

.card p {
  font-size: 1.25em;
}

.card li {
  font-size: 1.25em;
}

.blog-background {
  background: linear-gradient(
    180deg,
    #161616 0%,
    #161616 10%,
    #ee82ee 50%,
    #161616 90%,
    #161616 100%
  );
}
</style>
