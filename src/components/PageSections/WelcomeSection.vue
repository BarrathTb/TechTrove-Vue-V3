<template>
  <div class="bg-primary welcome-vid">
    <div class="bg-primary justify-content-center" id="welcome-section">
      <div class="welcome-banner-wrapper">
        <WelcomeBanner />
      </div>
      <div class="video-container">
        <video
          ref="localVideo"
          src="/videos/TechTroveWelcomeVid.mp4#t=38"
          autoplay
          muted
          playsinline
          preload="auto"
        ></video>
        <div class="video-credit">Art Created By: Roman De Giuli</div>
      </div>
    </div>
    <SearchBar />
  </div>
</template>

<script>
import SearchBar from './SearchBar.vue'
import WelcomeBanner from './WelcomeBanner.vue'

export default {
  components: {
    WelcomeBanner,
    SearchBar
  },
  data() {
    return {
      width: window.innerWidth,
      height: window.innerHeight * 0.8,
      loopStart: 38,
      loopEnd: 151,
      // videoSrc: '/videos/TechTroveWelcomeVid.mp4#t=[38,171]',
      videoElement: null
    }
  },
  mounted() {
    this.videoElement = this.$refs.localVideo
    if (this.videoElement) {
      this.videoElement.addEventListener('loadedmetadata', this.handleLoadedMetadata)
      this.videoElement.addEventListener('timeupdate', this.handleTimeUpdate)
      this.videoElement.addEventListener('ended', this.handleVideoEnded) // Add ended event listener

      // The `autoplay` attribute on the <video> tag should handle initial play.
      // `handleLoadedMetadata` will also attempt to play if needed.
    }
  },
  methods: {
    handleLoadedMetadata() {
      if (this.videoElement) {
        console.log(`loadedmetadata: initial currentTime = ${this.videoElement.currentTime}`)
        // If #t=38 in src worked, currentTime might already be ~38.
        // If not, or if it's 0, set it.
        if (
          this.videoElement.currentTime < this.loopStart ||
          (this.videoElement.currentTime === 0 && this.loopStart > 0)
        ) {
          console.log(`loadedmetadata: Setting currentTime to ${this.loopStart}`)
          this.videoElement.currentTime = this.loopStart
        }

        // If autoplay attribute is present and video is paused, try to play.
        if (
          this.videoElement.paused &&
          (this.videoElement.autoplay || this.videoElement.hasAttribute('autoplay'))
        ) {
          console.log('loadedmetadata: Video is paused, attempting to play.')
          this.videoElement.play().catch((error) => {
            console.warn('Autoplay attempt in loadedmetadata failed:', error)
          })
        }
      }
    },
    handleTimeUpdate() {
      if (this.videoElement) {
        const currentTime = this.videoElement.currentTime
        if (currentTime >= this.loopEnd) {
          console.log(`timeupdate: currentTime ${currentTime} >= loopEnd ${this.loopEnd}. Looping.`)
          this.performLoop()
        }
      }
    },
    handleVideoEnded() {
      // This handles the case where the video reaches its natural end.
      if (this.videoElement) {
        console.log('video ended: Looping via ended event.')
        this.performLoop()
      }
    },
    performLoop() {
      if (this.videoElement) {
        this.videoElement.currentTime = this.loopStart
        const playPromise = this.videoElement.play()
        if (playPromise !== undefined) {
          playPromise
            .then(() => {
              console.log('Loop: Playback restarted successfully.')
            })
            .catch((error) => {
              console.error('Loop: Error restarting playback:', error)
            })
        }
      }
    }
  },
  beforeUnmount() {
    if (this.videoElement) {
      this.videoElement.removeEventListener('loadedmetadata', this.handleLoadedMetadata)
      this.videoElement.removeEventListener('timeupdate', this.handleTimeUpdate)
      this.videoElement.removeEventListener('ended', this.handleVideoEnded) // Remove ended listener
      // Stop the video and release resources
      this.videoElement.pause()
      this.videoElement.removeAttribute('src') // Free up memory
      this.videoElement.load() // Reset video element
    }
  }
}
</script>

<style scoped>
.video-container {
  position: absolute;
  top: 0;
  right: 0;
  bottom: 0;
  left: 0;
  overflow: hidden;
  z-index: -1;
  width: 100%;
}

.video-container video {
  /* Style for the video element itself */
  width: 100%;
  height: 100%;
  object-fit: cover; /* Ensures video covers the container, cropping if needed */
}

.video-credit {
  position: absolute;
  bottom: 10px;
  left: 10px;
  color: #808080; /* Grey text */
  font-size: 0.8em;
  z-index: 1; /* Above video, but below other potential overlays */
  text-shadow: 1px 1px 2px rgba(0, 0, 0, 0.5); /* Optional: for better readability */
}

.welcome-banner-wrapper {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  z-index: 2; /* Ensure banner is above video-container (z-index: -1) */
  display: flex; /* Optional: for centering WelcomeBanner if it's not full-width */
  justify-content: center; /* Optional */
  align-items: flex-start; /* Align banner to the top */
  padding-top: 20px; /* Example padding, adjust as needed */
}

#welcome-section {
  position: relative;
  z-index: 1; /* Stacking context for children */
  height: 60vh;
  top: 20px; /* Corrected unit */
}

@media (max-width: 768px) {
  /* .video-container {
    display: none;
  } */

  #welcome-section {
    position: flex;
    z-index: 1;
    height: 20vh;

    width: 100vw;
    height: 35vh;
    transition: height 2s;
  }
}
</style>
