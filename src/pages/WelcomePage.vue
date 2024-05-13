<template>
  <WelcomeHeader :session="session" @toggle-login-modal="toggleLoginModal" />
  <WelcomeSection />
  <HowItWorksAccordion
    v-model="activePanels"
    @accordion-opened="handleAccordionOpened"
    class="accordion-body accord-one row g-3 align-items-center p-auto m-auto bg-primary justify-content-between"
    title="How It Works"
    :heading-id="headingOne"
    :collapse-id="collapseOne"
  >
    <info-card
      class="flex-grow-1"
      title="Step 1"
      image-src="/TechTrove-Web-Vue-V3/images/tech-entry-3.png"
      description="Search for the computer parts you need. Find the best deals and quality products."
    ></info-card>

    <info-card
      class="flex-grow-1"
      title="Step 2"
      image-src="/TechTrove-Web-Vue-V3/images/tech-entry-4.png"
      description="Click on a product card for more details. Add products to your cart, and customize your order."
    ></info-card>

    <info-card
      class="flex-grow-1"
      title="Step 3"
      image-src="/TechTrove-Web-Vue-V3/images/tech-entry-5.png"
      description="Review your cart and make any changes, proceed to checkout when ready. Don't forget to try the pc builder to make your dream pc come to life."
    ></info-card>
  </HowItWorksAccordion>
  <HowItWorksAccordion
    @accordion-opened="handleAccordionOpened"
    class="accordion-body accord-two row g-3 align-items-center p-auto m-auto bg-primary justify-content-between"
    title="Join the TechTrove Team"
    :heading-id="headingTwo"
    :collapse-id="collapseTwo"
  >
    <info-card
      class="flex-grow"
      title="As a Customer"
      image-src="/TechTrove-Web-Vue-V3/images/tech-entry-6.png"
      description="Provide assistance to other customers with product review and recommendations. Earn rewards for your contributions to the community. Contribute to the blogs for add ons to the tech community."
    ></info-card>

    <info-card
      class="flex-grow"
      title="As a Supplier"
      image-src="/TechTrove-Web-Vue-V3/images/tech-entry-7.png"
      description="TechTrove is a community-driven platform that helps you find the best deals and quality products for every build. As a supplier, you can create a vendor profile to showcase your products and services. Reach out to customers directly and gain new business opportunities."
    ></info-card>
    <info-card
      class="flex-grow"
      title="As a Colleague"
      image-src="/TechTrove-Web-Vue-V3/images/tech-entry-7.png"
      description="Join a team of experts dedicated to providing the best parts and service."
    ></info-card>
  </HowItWorksAccordion>
  <PromotionalCard class="bg-primary" />
  <LoginModal :session="session" v-model="loginVisible" />

  <AppFooter />
</template>

<script>
import AppFooter from '@/components/PageSections/AppFooter.vue'
import HowItWorksAccordion from '@/components/PageSections/HowItWorksAccordion.vue'
import InfoCard from '@/components/PageSections/InfoCard.vue'
import PromotionalCard from '@/components/PageSections/PromotionalCard.vue'
import WelcomeSection from '@/components/PageSections/WelcomeSection.vue'
import LoginModal from '@/components/modals/LoginModal.vue'
import WelcomeHeader from '@/components/siteNavs/WelcomeHeader.vue'

export default {
  components: {
    WelcomeHeader,
    HowItWorksAccordion,
    PromotionalCard,
    AppFooter,
    InfoCard,
    LoginModal,
    WelcomeSection
  },

  props: {
    session: {
      type: Object,
      default: () => ({}),
      required: false
    }
  },
  computed: {
    user() {
      return this.session?.user || null
    }
  },
  data() {
    return {
      loginVisible: false,
      headingOne: 'headingOne',
      collapseOne: 'collapseOne',
      headingTwo: 'headingTwo',
      collapseTwo: 'collapseTwo',
      activePanels: {
        type: Array,
        default: () => []
      }
    }
  },

  methods: {
    toggleLoginModal() {
      this.loginVisible = !this.loginVisible
    },
    handleAccordionOpened(collapseId) {
      setTimeout(() => {
        const element = document.getElementById(collapseId)
        if (element) {
          const elementRect = element
          const absoluteElementTop = elementRect.top + window.scrollY
          const fixedOffset = 50
          window.scrollTo({
            top: absoluteElementTop - fixedOffset,
            behavior: 'smooth'
          })
        }
      }, 1100)
    }
  }
}
</script>
