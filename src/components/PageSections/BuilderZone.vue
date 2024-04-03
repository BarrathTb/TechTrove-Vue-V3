<template>
  <section class="builder-zone bg-primary mb-2">
    <div class="container bg-primary">
      <div class="card border-0 bg-primary mx-auto" style="max-width: 800px;">
        <!-- Title -->
        <h1 class="builder-zone-title mt-2 tube-text-aqua">Custom PC Builds</h1>

        <!-- Loop through an array of builds and create a BuilderCard for each -->
        <BuilderCard v-for="(build, index) in builds" :key="index" :videoSrc="build.videoSrc"
          :powerTitle="build.powerTitle" :powerDescription="build.powerDescription" :partsTitle="build.partsTitle"
          :partsList="build.partsList" :priceTitle="build.priceTitle" :priceDescription="build.priceDescription" />

      </div>
    </div>
  </section>
</template>

<script>
  import BuilderCard from './BuilderCard.vue';

  export default {
    components: {
      BuilderCard
    },
    name: 'BuilderZone',
    data() {
      return {
      
        builds: [
          {
            videoSrc: "https://www.youtube.com/embed/eMlyRrzvUaI?si=T845E6JhBIcE1nyt",
            powerTitle: "Power Capabilities",
            powerDescription: "The custom PC build features an AMD Ryzen 7 5800X3D CPU known for its efficient performance in gaming due to the innovative 3D V-Cache technology. Paired with the Nvidia GeForce RTX 4090 GPU from ASUS, this setup is capable of handling the most demanding games and creative tasks with ease. The ASUS® ROG CROSSHAIR VIII EXTREME motherboard offers robust power delivery systems suitable for stable overclocking. G.SKILL Trident Z RGB RAM provides high-speed memory access and enhanced multitasking capabilities. The entire system is powered cleanly and efficiently, ensuring maximum performance under load while maintaining stable operation.",
            partsTitle: "Parts",
            partsList: [
              "CPU: AMD Ryzen 7 5800X3D",
              "GPU: Nvidia GeForce RTX 4090 (ASUS)",
              "Motherboard: ASUS® ROG CROSSHAIR VIII EXTREME",
              "RAM: G.SKILL Trident Z RGB",
              "PC Case: ASUS® ROG Hyperion GR701",
              "Riser: EK-Loop Vertical GPU Holder EVO - Gen4 Riser",
              "Cables: CableMod"
            ],
            priceTitle: "Estimated Price",
            priceDescription: "The estimated price of a custom build starts at $4,798.78"
          },
          {
            "videoSrc": "https://www.youtube.com/embed/oKtvvt5RNCA?si=Jlgc3BvDcQnQ-VfB",
            "powerTitle": "Power Unleashed",
            "powerDescription": "Harness the Herculean strength of the AMD 5950x CPU, paired with the titanic GeForce RTX 3090 FE GPU. This beastly combination is cooled by the might of an Aorus motherboard and backed by an army of Corsair Dominator RAM & a fortress-like Lian Li case. With the blood of the gods coursing through its cooling veins, from the towering Ek Coolstream radiators to the vigilant Noctua rear guards, every element works in perfect harmony to unleash unparalleled performance. Feel the raw power at your fingertips; this build doesn't just set the bar—it obliterates it.",
            "partsTitle": "Parts",
            "partsList": [
              "CPU: AMD 5950x",
              "GPU: 3090 FE (Note: Consider upgrading to the 40 series)",
              "Motherboard: x570 Aorus xtreme",
              "RAM: Corsair Dominator 64GB 4x16 CL16",
              "PSU: Corsair AX1600i",
              "Case: Lian Li o11d XL",
              "Top Radiator: Ek Coolstream PE 360",
              "Bottom Radiator (GPU horizontal): EK XE 360",
              "Bottom Radiator (GPU vertical): Black Ice Nemesis 360GTS",
              "Rear Radiator: EK Coolstream SE 360",
              "Fans: EK Vardar RGB x3m",
              "Rear Fans: Noctua NF-A12x15",
              "CPU Waterblock: EK Quantum Magnitude",
              "Distro Plate: EK Reflection Front Distro Plate",
              "GPU Water Block: EK-Quantum Vector FE RTX 3090"
            ],
            "priceTitle": "Estimated Price",
            "priceDescription": "The estimated price of a custom build starts at $5,368.32"
          },
          {
            "videoSrc": "https://www.youtube.com/embed/Au6r3oTLiqs?si=3QHo7097Jjssy9mw",
            "powerTitle": "Zenith of Zen",
            "powerDescription": "Embrace the zenith performance with the AMD Ryzen 9 7950X3D CPU - a colossus of computation standing tall in the realm of gaming and creative might. Ascend to new heights of graphical fidelity with the Sapphire RX 7900 XTX PULSE GPU, enhanced by the cutting-edge vBIOS for energy unto like any other. The ASUS CROSSHAIR X670E HERO motherboard lays a foundation so strong that even the mightiest tasks crumble before you. Navigate through digital worlds with lightning-fast G.Skill RAM, while your data rests comfortable within the cavernous storage options. This build is not merely configured; it's sculpted within the spacious Lian Li O11 Dynamic EVO XL, all powered by Seasonic's fearless VERTEX PSU. Command your digital odyssey with Logitech precision and feast your eyes upon the smooth realms displayed by the Samsung G7 monitor.",
            "partsTitle": "Parts",
            "partsList": [
              "CPU: AMD Ryzen 9 7950X3D",
              "Motherboard: ASUS CROSSHAIR X670E HERO",
              "RAM: G.Skill F5-6000J3038F16GX2-TZ5NR",
              "GPU: Sapphire RX 7900 XTX PULSE (with Asrock RX 7900 XTX Aqua Extreme OC vBIOS) 550W",
              "M.2 NVME: Samsung 980 Pro 1TB M.2",
              "HDD: WD 2TB SATA-II 64MB Caviar Green",
              "HDD: Western Digital - WD Blue 4TB",
              "CASE: Lian Li O11 Dynamic EVO XL",
              "PSU: Seasonic VERTEX GX, 80+ Gold, 1200W",
              "CPU Block: 1 x EK-Quantum Velocity² D-RGB - AM5 Nickel + Plexi",
              "GPU Block: 1 x Alphacool Eisblock Aurora Acrylic RX 7900XTX/XT Nitro with backplate",
              "Distribution Plate: 1 x EK-Quantum Reflection² PC-O11D EVO XL D5 PWM D-RGB - Plexi",
              "Radiators: 2 x EK-Quantum Surface P420M - Black",
              "Radiator: 1 x EK-Quantum Surface S420 - Black"
            ],
            "priceTitle": "Estimated Price",
            "priceDescription": "The estimated price of a custom build starts at $3,916.92"
          }
        ]
      };
    }
  }
</script>

<style scoped>
  .builder-zone-title {
    text-align: center;
    margin-bottom: 20px;
  }

  .builder-zone-video {
    margin-bottom: 20px;
    justify-content: center;
    width: 100%;
  }
</style>
