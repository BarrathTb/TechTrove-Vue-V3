<!-- @format -->

<template>
  <div class="bg-primary welcome-vid">
    <div class="bg-primary justify-content-center" id="welcome-section">
      <WelcomeBanner />
      <div class="video-container">
        <div id="player"></div>
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
      player: null,
      loopStart: 6,
      loopEnd: 11
    }
  },
  mounted() {
    this.loadYouTubeAPI()
  },
  methods: {
    loadYouTubeAPI() {
      const tag = document.createElement('script')
      tag.src = 'https://www.youtube.com/iframe_api'
      const firstScriptTag = document.getElementsByTagName('script')[0]
      firstScriptTag.parentNode.insertBefore(tag, firstScriptTag)

      // Save the global callback
      window.onYouTubeIframeAPIReady = this.onYouTubeIframeAPIReady
    },
    // This function creates an <iframe> (and YouTube player) after the API code downloads.
    onYouTubeIframeAPIReady() {
      this.player = new YT.Player('player', {
        height: '100%',
        width: '100%',
        videoId: 'o6HJVBg1lNg',
        playerVars: {
          autoplay: 1,
          mute: 1,
          enablejsapi: 1,
          rel: 0,
          controls: 0,
          showinfo: 0,
          modestbranding: 0,
          start: this.loopStart,
          loop: 1, // Enable looping
          playlist: 'o6HJVBg1lNg'
        },
        events: {
          onReady: this.onPlayerReady,
          onStateChange: this.onPlayerStateChange
        }
      })
    },
    onPlayerReady(event) {
      event.target.playVideo()
      clearInterval(this.checkTimeInterval)
      this.checkTimeInterval = setInterval(() => {
        const currentTime = this.player.getCurrentTime()
        if (currentTime >= this.loopEnd) {
          this.player.seekTo(this.loopStart)
        }
      }, 1000)
    },

    onPlayerStateChange(event) {
      if (event.data === YT.PlayerState.PLAYING) {
        const currentTime = event.target.getCurrentTime()
        if (currentTime >= this.loopEnd) {
          this.player.seekTo(this.loopStart)
        }
      }
    }
  },
  beforeUnmount() {
    if (this.player && this.player.destroy) {
      this.player.destroy()
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

.video-container iframe {
  width: 100vw;
  height: 100vh;
  min-width: 100%;
  min-height: 100%;
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  z-index: -1;
}

#welcome-section {
  position: relative;
  z-index: 1;
  height: 60vh;
  top: 20;
}

@media (max-width: 768px) {
  .video-container {
    display: none;
  }

  #welcome-section {
    position: flex;
    z-index: 1;
    height: 20vh;
    background-image: linear-gradient(to bottom, #161616, rgba(0, 128, 128, 0)),
      url('/TechTrove-Web-Vue-V3/images/colorsplash.png');
    background-size: cover;
    position: relative;

    width: 100vw;
    height: 20vh;
    transition: height 2s;
  }
}
</style>
