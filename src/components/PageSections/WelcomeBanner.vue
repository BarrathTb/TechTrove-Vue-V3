<!-- @format -->

<template>
  <div class="row rounded px-4">
    <div class="col-sm-12 col-md-8 col-lg-4 banner-text banner-card">
      <h1 class="ms-3 text-light banner-text">High Performance Parts</h1>

      <h1 class="ms-3 text-light banner-text">at Tech Trove!</h1>
      <div class="tubes">
        <h4 class="ms-3 tube-text">Customize Everything.</h4>
      </div>

      <button @click="toStore" class="ms-3 btn btn-success banner-button">
        <span class="text-banner-button">Let's Shop ></span>
      </button>
    </div>
  </div>
</template>

<script>
export default {
  name: 'WelcomeBanner',
  methods: {
    toStore() {
      this.$router.push('/Home')
    }
  }
}
</script>

<style scoped>
/* .entry-image {
    width: calc(12vw * 0.75);
    height: calc(12vw * 0.75);
    margin: 0.1rem;
  } */
.banner-button {
  font-weight: 600;
  color: #fff;
  text-shadow:
    5px 0px 20px rgba(0, 0, 0, 0.8),
    -1px -1px 0 #000;
  z-index: 200;
  cursor: pointer;
}
.banner-text {
  font-size: calc(3vw * 0.8);
  font-weight: 600;
  color: #fff;
  text-shadow: 0px 0px 20px rgba(0, 0, 0, 0.8);
}
.text-banner-button {
  font-size: calc(2vw * 0.8);
  font-weight: 600;
  color: #fff;
  text-shadow:
    5px 0px 20px rgba(0, 0, 0, 0.8),
    -1px -1px 0 #000,
    /* Black border on top and left */ 1px 1px 0 #000; /* Black border on bottom and right for 3D effect */
}
.banner-card {
  background: linear-gradient(
    180deg,
    rgba(22, 22, 22, 0.5) 0%,
    rgba(19, 19, 19, 0.5) 25%,
    rgba(17, 17, 17, 0.5) 50%,
    rgba(15, 15, 15, 0.5) 75%,
    rgba(0, 0, 0, 0.5) 100%
  );

  box-shadow: 0px 0px 20px rgba(0, 0, 0, 0.5);
  backdrop-filter: blur(10px);
  -webkit-backdrop-filter: blur(10px);
  border: 1px solid rgba(255, 255, 255, 0.18);

  padding: 1rem;
  border-radius: 1rem;
  /* display: flex;
  flex-direction: row;
  justify-self: start; */
  /* position: absolute; */
  left: 0;
}

.tube-text {
  font-size: calc(2vw * 0.8);
  font-weight: 100;
  color: #d4eaff;
  text-shadow:
    0 0 0 transparent,
    0 0 10px #0ee636,
    0 0 20px rgba(38, 149, 255, 0.5),
    0 0 40px #0ee636,
    0 0 100px #0ee636,
    0 0 200px #0ee636,
    0 0 300px #0ee636,
    0 0 500px #0ee636;
  animation: blink 4s infinite alternate;
}

@media screen and (max-width: 568px) {
  .banner-card {
    background: linear-gradient(
      180deg,
      rgba(22, 22, 22, 0.5) 0%,
      rgba(19, 19, 19, 0.5) 25%,
      rgba(17, 17, 17, 0.5) 50%,
      rgba(15, 15, 15, 0.5) 75%,
      rgba(0, 0, 0, 0.5) 100%
    );

    box-shadow: 0px 0px 20px rgba(0, 0, 0, 0.5);
    backdrop-filter: blur(10px);
    -webkit-backdrop-filter: blur(10px);
    border: 1px solid rgba(255, 255, 255, 0.18);
    margin-bottom: 2rem;
    padding: 1rem;
    border-radius: 1rem;
    /* display: flex;
  flex-direction: row;
  justify-self: start; */
    /* position: absolute; */
    left: 0;
    top: 0;
  }
  .banner-text {
    font-size: calc(6vw * 0.8);
    font-weight: 600;
    color: #fff;
  }

  .tube-text {
    font-size: calc(6vw * 0.8);
    font-weight: 600;
  }

  .banner-button {
    font-size: calc(2vw * 0.7);
    font-weight: 600;
    color: #fff;
  }
  .tube-text {
    font-size: calc(6vw * 0.8);
    font-weight: 100;
    color: #d4eaff;
    text-shadow:
      0 0 0 transparent,
      0 0 10px #0ee636,
      0 0 20px rgba(38, 149, 255, 0.5),
      0 0 40px #0ee636,
      0 0 100px #0ee636,
      0 0 200px #0ee636,
      0 0 300px #0ee636,
      0 0 500px #0ee636;
    animation: blink 4s infinite alternate;
  }
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

@keyframes blink {
  50% {
    opacity: 1;
  }

  52% {
    opacity: 0.8;
  }

  53% {
    opacity: 1;
  }

  55% {
    opacity: 0.2;
  }

  56% {
    opacity: 1;
  }
}

.da-fade {
  background: linear-gradient(
    180deg,
    #161616 0%,
    #131313 25%,
    #111111 50%,
    #0f0f0f 75%,
    black 100%
  );
}
</style>
