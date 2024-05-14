<template>
  <div class="bg-primary welcome-vid">
    <div class="bg-primary justify-content-center" id="welcome-section">
      <WelcomeBanner />
      <div class="video-container">
        <!-- Using vue3-youtube component -->
        <YouTube
          width="100%"
          :height="height"
          :src="videoId"
          ref="youtube"
          :vars="playerVars"
          @ready="onPlayerReady"
          @state-change="onPlayerStateChange"
        ></YouTube>
      </div>
    </div>
    <SearchBar />
  </div>
</template>

<script>
import SearchBar from './SearchBar.vue'
import WelcomeBanner from './WelcomeBanner.vue'
import YouTube from 'vue3-youtube'

export default {
  components: {
    WelcomeBanner,
    SearchBar,
    YouTube // Register the Youtube component
  },
  data() {
    return {
      width: window.innerWidth,
      height: window.innerHeight * 0.8,
      videoId: 'o6HJVBg1lNg',
      loopStart: 6,
      loopEnd: 11,
      playerVars: {
        autoplay: 1,
        mute: 1,
        enablejsapi: 1,
        rel: 0,
        controls: 0,
        showinfo: 0,
        modestbranding: 0,
        start: 6,
        loop: 1,
        playlist: 'o6HJVBg1lNg'
      },
      checkTimeInterval: null
    }
  },
  methods: {
    onPlayerReady(event) {
      const player = event.target
      if (player && typeof player.playVideo === 'function') {
        player.playVideo()
      }
      clearInterval(this.checkTimeInterval)
      this.checkTimeInterval = setInterval(() => {
        if (player && typeof player.getCurrentTime === 'function') {
          const currentTime = player.getCurrentTime()
          if (currentTime >= this.loopEnd) {
            player.seekTo(this.loopStart)
          }
        }
      }, 1000)
    },

    onPlayerStateChange(event) {
      if (event.data === YT.PlayerState.PLAYING) {
        const player = event.target
        if (player && typeof player.getCurrentTime === 'function') {
          const currentTime = player.getCurrentTime()
          if (currentTime >= this.loopEnd) {
            player.seekTo(this.loopStart)
          }
        }
      }
    }
  },
  beforeUnmount() {
    clearInterval(this.checkTimeInterval) // Clear the interval when the component unmounts
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
      url('/TechTrove-Vue-V3/images/colorsplash.png');
    background-size: cover;
    position: relative;

    width: 100vw;
    height: 20vh;
    transition: height 2s;
  }
}
</style>
