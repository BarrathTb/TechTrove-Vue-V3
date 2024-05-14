<!-- @format -->

<template>
  <div class="row align-items-center mb-4 bg-primary p-4 justify-content-center">
    <div class="col-lg-6 col-md-10 col-sm-12">
      <div class="card h-100 bg-primary d-flex flex-column border-none">
        <a href="#" class="product-detail mt-2 me-2 ms-auto product-detail-icon"> </a>
        <img
          src="@/assets/images/tech-entry-7.png"
          class="card-img-top img-fluid"
          alt="display tech image"
        />
        <div
          class="card-body text-light flex-grow-1 d-flex flex-column justify-content-between pb-1"
        >
          <h5 class="card-title text-center font-size-md">Shop with ease!</h5>
          <p class="card-text text-center font-size-sm ms-4">
            Get the best computer parts for any situation. Find the best deals and quality products.
            Download our app below.
          </p>
          <button type="submit" class="btn btn-success g-2 mt-3">Download the App</button>
        </div>
      </div>
    </div>
  </div>
</template>
<script>
export default {
  name: 'PromotionalCard'
}
</script>

<style scoped></style>
