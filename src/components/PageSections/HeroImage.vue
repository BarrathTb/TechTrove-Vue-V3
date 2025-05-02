<template>
  <div>
    <!-- Large screens Hero Section -->
    <div
      :class="[
        'container-fluid d-none d-md-block hero-image bg-primary',
        { 'hero-minimize': heroMinimized }
      ]"
    >
      <button class="toggle-rain-btn" @click="rainActive = !rainActive">
        {{ rainActive ? 'Rain Off' : 'Rain On' }}
      </button>
      <div v-if="rainActive" class="rain">
        <div
          v-for="(drop, index) in drops"
          :key="index"
          class="drop"
          :style="{
            left: drop.left + '%',
            bottom: drop.bottom + '%',
            animationDelay: '0.' + drop.delay + 's',
            animationDuration: '0.5' + drop.duration + 's'
          }"
        >
          <div
            class="stem"
            :style="{
              animationDelay: '0.' + drop.delay + 's',
              animationDuration: '0.5' + drop.duration + 's'
            }"
          ></div>
          <div
            class="splat"
            :style="{
              animationDelay: '0.' + drop.delay + 's',
              animationDuration: '0.5' + drop.duration + 's'
            }"
          ></div>
        </div>
      </div>
      <div class="row hero-text pt-5">
        <div class="col-lg-12 text-left text-light mx-auto">
          <div class="row">
            <div class="d-flex align-items-center">
              <h1 :class="{ 'rainbow-text-animate': animateText }" class="display-8 pt-3 mr-auto">
                {{ currentHeroTitle }}
              </h1>
              <div
                id="scrollDownArrow"
                class="arrow"
                @click="scrollToProductCarousel"
                style="cursor: pointer; padding-left: 20px"
              >
                &#8595;
              </div>
            </div>
          </div>
          <p class="lead">Check out our latest collection below.</p>
        </div>
      </div>
    </div>

    <!-- Small screens Hero Section -->
    <div class="container-fluid d-md-none d-sm-flex hero-image-sm bg-primary">
      <div class="row hero-text-sm">
        <div class="col-12 text-light text-center">
          <h4 :class="{ 'rainbow-text-animate-sm': animateText }" class="display-8 pt-3 mr-auto">
            {{ currentHeroTitle }}
          </h4>
          <p class="lead">Check out our latest collection below.</p>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'HeroSection',
  data() {
    return {
      heroTitles: [
        'Build Your Dream Machine',
        'Experience Next-Level Performance',
        'Customize Your Battlestation',
        'Unleash Maximum Potential',
        'Crafted for Gamers, by Gamers',
        'Precision Engineered for Perfection',
        'Empower Your Creativity and Gaming',
        'Innovate, Create, Dominate',
        'Where Power Meets Personalization',
        'Elevate Your Gaming Experience'
      ],
      currentHeroTitle: '',
      heroMinimized: false,
      animateText: false,
      rainActive: false,
      drops: []
    }
  },
  methods: {
    scrollToProductCarousel() {
      const carouselElement = document.getElementById('productCarousel')
      if (carouselElement) {
        carouselElement.scrollIntoView({ behavior: 'smooth', block: 'start' })
      }
    },
    getRandomHeroTitle() {
      const randomIndex = Math.floor(Math.random() * this.heroTitles.length)
      return this.heroTitles[randomIndex]
    },
    makeItRain() {
      let increment = 0
      let newDrops = []

      while (increment < 100) {
        let randoHundo = Math.floor(Math.random() * 98) + 1
        let randoFiver = Math.floor(Math.random() * 4) + 2
        increment += randoFiver

        newDrops.push({
          left: increment,
          bottom: randoFiver + randoFiver - 1 + 100,
          delay: randoHundo,
          duration: randoHundo
        })
      }

      this.drops = newDrops
    }
  },
  mounted() {
    this.currentHeroTitle = this.getRandomHeroTitle()
    setTimeout(() => {
      this.getRandomHeroTitle()
      this.heroMinimized = true
      this.animateText = true
      this.rainActive = true
      this.makeItRain()
    }, 3000)
  }
}
</script>

<style scoped>
.hero-image {
  background-image: linear-gradient(to top, #161616, rgba(0, 128, 128, 0)),
    url('/TechTrove-Vue-V3/images/ek-fluid-gaming-digital-reef-art-1.webp');
  background-size: cover;
  position: relative;
  z-index: 1;
  width: 100vw;
  height: 82vh;
  transition: height 2s;
  overflow: hidden;
}

.hero-text {
  z-index: 3;
}

.rain {
  position: absolute;
  top: 0;
  right: 0;
  bottom: 0;
  left: 0;
  z-index: 2;
}

.arrow {
  font-size: 36px;
  animation: bounce 2s infinite;
  z-index: 3;
}

@keyframes bounce {
  0%,
  20%,
  50%,
  80%,
  100% {
    transform: translateY(0);
  }

  40% {
    transform: translateY(-30px);
  }

  60% {
    transform: translateY(-15px);
  }
}

@keyframes reduceSize {
  to {
    background:
      linear-gradient(to bottom, #161616, rgba(0, 128, 128, 0)),
      url('/images/ek-fluid-gaming-digital-reef-art-1.webp') no-repeat bottom center;
    background-size: cover;
    position: relative;
    width: 100vw;
    height: 20vh;
    animation-duration: 2000ms smooth;
  }
}

/* @keyframes slideGradient {
  0% {
    background-position: 100% center;
  }

  100% {
    background-position: 0% center;
  }
} */

.rainbow-text-animate-sm {
  background: linear-gradient(
    90deg,
    red,
    orange,
    yellow,
    green,
    blue,
    indigo,
    violet,
    indigo,
    blue,
    green,
    yellow,
    orange,
    red
  );
  background-size: 400% auto;
  -webkit-background-clip: text;
  background-clip: text;
  color: transparent;
  animation: slideGradient 15s linear infinite;
  -webkit-text-fill-color: transparent;
  display: inline-block;
}

.rainbow-text-animate {
  background: radial-gradient(
    circle closest-side at center,
    red,
    orange,
    yellow,
    green,
    blue,
    indigo,
    violet
  );
  background-size: 400% 400%;
  -webkit-background-clip: text;
  background-clip: text;
  color: transparent;
  animation: radialGradientExpand 15s infinite linear;
  z-index: 3;
  -webkit-text-fill-color: transparent;
  display: block;
}

@keyframes radialGradientExpand {
  0% {
    background-size: 0% 0%;
  }

  100% {
    background-size: 200% 200%;
  }
}

.hero-minimize {
  animation: reduceSize 3s forwards;
  z-index: 1;
}

.hero-image {
  transition: height 2s;
  z-index: 1;
}

.hero-text h1,
.hero-text-sm h4 {
  transition: color 10s;
  z-index: 3;
}

.drop {
  position: absolute;
  width: 15px;
  height: 120px;
  animation: drop 0.5s linear infinite;
  z-index: 2;
}

@keyframes drop {
  0% {
    transform: translateY(0vh);
  }

  75% {
    transform: translateY(20vh);
  }

  100% {
    transform: translateY(20vh);
  }
}

.stem {
  width: 1px;
  height: 60%;
  margin-left: 7px;
  background: linear-gradient(180deg, #ffff00, green, #0000ff, #4b0082, #ee82ee);
  z-index: 2;
  animation: stem 0.5s linear infinite;
}

@keyframes stem {
  0%,
  65% {
    opacity: 1;
  }

  75%,
  100% {
    opacity: 0;
  }
}

.splat {
  width: 20px;
  height: 15px;
  border-top: 2px dotted white;
  border-radius: 100%;
  background: radial-gradient(
    circle closest-side at center,
    red,
    orange,
    yellow,
    green,
    blue,
    indigo,
    violet
  );
  z-index: 2;
  transform: scale(0);
  animation: splat 0.5s linear infinite;
}

@keyframes splat {
  0%,
  80% {
    opacity: 1;
    transform: scale(0);
  }

  90% {
    opacity: 0.5;
    transform: scale(1);
  }

  100% {
    opacity: 0;
    transform: scale(1.5);
  }
}

.toggle-rain-btn {
  position: absolute;
  top: 14px;
  right: 14px;
  margin-right: 10px;
  padding: 2px 5px;
  background-color: rgba(0, 0, 0, 0.2);
  color: rgb(255, 255, 255, 0.2);
  border: none;
  border-radius: 50px;
  cursor: pointer;
  z-index: 4;
}

/* Modified styles for small screens */

/* Adjust font size for hero text on small screens */
@media (max-width: 767.98px) {
  .hero-text-sm {
    position: relative; /* Change to relative positioning */
    top: 50%; /* Adjust vertical positioning */
    left: 0;
    transform: translateY(-50%); /* Center vertically */
    text-align: center; /* Center text horizontally */
    padding: 0 15px; /* Add some padding */
    word-wrap: break-word; /* Allow text to wrap */
    overflow-wrap: break-word; /* Allow text to wrap */
  }
  .hero-image-sm {
    background: url('/TechTrove-Vue-V3/images/ek-fluid-gaming-digital-reef-art-1.webp') no-repeat
      bottom center;
    background-size: cover;
    position: relative;
    height: 38vh;
    display: flex; /* Use flexbox for centering content */
    align-items: center; /* Center items vertically */
    justify-content: center; /* Center items horizontally */
  }
}
</style>
