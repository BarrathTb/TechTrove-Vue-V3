import Product from './models/Product'

export const products = [
  {
    name: 'Asus Rog Crosshairs',
    brand: 'ASUS',
    category: 'Motherboards',
    price: 859.99,
    image:
      'https://uyslfbwpmqbnobsnxsdl.supabase.co/storage/v1/object/public/tech-trove-data/product-images/asus-rog-crosshairs.jpg',
    description: 'High-performance gaming motherboard with RGB lighting and advanced cooling.',
    stock: 25,
    ratings: {
      average: 4.5,
      totalReviews: 123
    },
    features: [
      'Supports AMD Ryzen processors',
      'PCIe 4.0 ready',
      'Onboard WiFi and Ethernet',
      'SupremeFX audio technology'
    ],
    dimensions: {
      width: '30.5 cm',
      length: '24.4 cm',
      height: '5 cm'
    },
    weight: '1.35 kg',
    warranty: '3 years'
  },
  {
    name: 'Asus Rog Matrix',
    brand: 'ASUS',
    category: 'Motherboards',
    price: 999.99,
    image:
      'https://uyslfbwpmqbnobsnxsdl.supabase.co/storage/v1/object/public/tech-trove-data/product-images/asus-rog-matrix-cooling.jpg',
    description: 'The ultimate overclocking motherboard with water-cooling readiness.',
    stock: 15,
    ratings: {
      average: 4.8,
      totalReviews: 80
    },
    features: [
      'Optimized for Intel processors',
      'Enhanced power solution',
      'Multiple GPU support',
      'Comprehensive cooling controls'
    ],
    dimensions: {
      width: '30.5 cm',
      length: '27.7 cm',
      height: '5 cm'
    },
    weight: '1.4 kg',
    warranty: '3 years'
  },
  {
    name: 'Asus Rog Rampage',
    brand: 'ASUS',
    category: 'Motherboards',
    price: 1249.99,
    image:
      'https://uyslfbwpmqbnobsnxsdl.supabase.co/storage/v1/object/public/tech-trove-data/product-images/asus-rog-rampage-mother.webp',
    description: 'A flagship motherboard built for extreme performance and gaming.',
    stock: 10,
    ratings: {
      average: 4.7,
      totalReviews: 60
    },
    features: [
      'Supports latest generation Intel CPUs',
      'Quad-channel memory',
      'High-speed networking options',
      'AI Overclocking'
    ],
    dimensions: {
      width: '30.5 cm',
      length: '27.7 cm',
      height: '5.1 cm'
    },
    weight: '1.5 kg',
    warranty: '4 years'
  },
  {
    name: 'EK Rog Maximus',
    brand: 'ASUS',
    category: 'Motherboards',
    price: 729.99,
    image:
      'https://uyslfbwpmqbnobsnxsdl.supabase.co/storage/v1/object/public/tech-trove-data/product-images/ek-rog-maximus-xiv-extreme-glacial-landing-page-product-2x-999x1030.png',
    description: 'Custom-designed motherboard with premium liquid cooling capabilities.',
    stock: 20,
    ratings: {
      average: 4.6,
      totalReviews: 45
    },
    features: [
      'Designed for liquid cooling enthusiasts',
      'Integrated I/O shield',
      'Aura Sync RGB lighting',
      'Premium components for maximum durability'
    ],
    dimensions: {
      width: '24 cm',
      length: '24 cm',
      height: '5 cm'
    },
    weight: '1.25 kg',
    warranty: '3 years'
  },
  {
    name: 'Asus Rog Strix Z590-E',
    brand: 'ASUS',
    category: 'Motherboards',
    price: 379.99,
    image:
      'https://uyslfbwpmqbnobsnxsdl.supabase.co/storage/v1/object/public/tech-trove-data/product-images/asus-rog-strix-z590-e.webp',
    description: 'Gaming motherboard with advanced power delivery and optimized cooling.',
    stock: 30,
    ratings: {
      average: 4.4,
      totalReviews: 150
    },
    features: [
      'AI Overclocking and cooling',
      'WiFi 6E onboard',
      'Dual PCIe 4.0 M.2 slots',
      'USB 3.2 Gen 2x2 Type-C'
    ],
    dimensions: {
      width: '30.5 cm',
      length: '24.4 cm',
      height: '5 cm'
    },
    weight: '1.3 kg',
    warranty: '3 years'
  },
  {
    name: 'MSI MEG X590 Godlike',
    brand: 'MSI',
    category: 'Motherboards',
    price: 699.99,
    image:
      'https://uyslfbwpmqbnobsnxsdl.supabase.co/storage/v1/object/public/tech-trove-data/product-images/msi-meg-x590-godlike.webp',
    description: 'A masterclass in motherboard engineering with unrivaled performance.',
    stock: 5,
    ratings: {
      average: 4.9,
      totalReviews: 30
    },
    features: [
      'Extended Heat-pipe design',
      'Frozr Heatsink',
      'Triple Lightning Gen 4 M.2 slots',
      'Dynamic OLED screen'
    ],
    dimensions: {
      width: '27 cm',
      length: '30 cm',
      height: '5.5 cm'
    },
    weight: '1.6 kg',
    warranty: '5 years'
  },
  {
    name: 'Gigabyte Z690 Aorus Master',
    brand: 'Gigabyte',
    category: 'Motherboards',
    price: 459.99,
    image:
      'https://uyslfbwpmqbnobsnxsdl.supabase.co/storage/v1/object/public/tech-trove-data/product-images/gigabyte-z690-aorus-master.webp',
    description: 'Top-tier Z690 motherboard with advanced thermal design for enthusiasts.',
    stock: 12,
    ratings: {
      average: 4.5,
      totalReviews: 25
    },
    features: [
      'Supports 12th Gen Intel Core Processors',
      'DDR5 memory support',
      'Thermal Reactive Armor',
      'E-ATX form factor'
    ],
    dimensions: {
      width: '30.5 cm',
      length: '27 cm',
      height: '5 cm'
    },
    weight: '1.7 kg',
    warranty: '3 years'
  },
  {
    name: 'MSI MPG B550 Gaming Edge WiFi',
    brand: 'MSI',
    category: 'Motherboards',
    price: 209.99,
    image:
      'https://uyslfbwpmqbnobsnxsdl.supabase.co/storage/v1/object/public/tech-trove-data/product-images/msi-mpg-b550-gaming-edge-wifi.webp',
    description: 'Performance gaming motherboard with WiFi 6 and ample connectivity options.',
    stock: 18,
    ratings: {
      average: 4.2,
      totalReviews: 75
    },
    features: [
      'Supports AMD Ryzen 5000 Series processors',
      'Extended Heatsink Design',
      'Pre-installed I/O Shielding',
      'Mystic Light RGB'
    ],
    dimensions: {
      width: '30.5 cm',
      length: '24.4 cm',
      height: '5 cm'
    },
    weight: '1.2 kg',
    warranty: '3 years'
  },
  {
    name: 'Asus TUF Gaming X570-Plus (Wi-Fi)',
    brand: 'ASUS',
    category: 'Motherboards',
    price: 189.99,
    image:
      'https://uyslfbwpmqbnobsnxsdl.supabase.co/storage/v1/object/public/tech-trove-data/product-images/asus-tuf-gaming-x570-plus-wi-fi.webp',
    description: 'Durable motherboard with military-grade components and integrated Wi-Fi.',
    stock: 25,
    ratings: {
      average: 4.3,
      totalReviews: 90
    },
    features: [
      'AMD AM4 Socket for 3rd and 2nd Gen AMD Ryzen',
      'Dual PCIe 4.0 M.2 slots',
      'Exclusive DTS Custom audio',
      'TUF Protection'
    ],
    dimensions: {
      width: '30.5 cm',
      length: '24.4 cm',
      height: '5 cm'
    },
    weight: '1.3 kg',
    warranty: '3 years'
  },
  {
    name: 'EVGA Z490 Dark',
    brand: 'EVGA',
    category: 'Motherboards',
    price: 499.99,
    image:
      'https://uyslfbwpmqbnobsnxsdl.supabase.co/storage/v1/object/public/tech-trove-data/product-images/evga-z390-dark.webp',
    description: 'An elite motherboard designed for record-breaking performance.',
    stock: 8,
    ratings: {
      average: 4.8,
      totalReviews: 10
    },
    features: [
      'Designed for Intel 9th Gen processors',
      'Highly-efficient 17 Phase Digital VRM',
      'Creative Sound Core3D Audio',
      'Triple BIOS Support'
    ],
    dimensions: {
      width: '27 cm',
      length: '30.5 cm',
      height: '5 cm'
    },
    weight: '1.45 kg',
    warranty: '3 years'
  },
  {
    name: 'Biostar Racing TZ590-BTC',
    brand: 'Biostar',
    category: 'Motherboards',
    price: 159.99,
    image:
      'https://uyslfbwpmqbnobsnxsdl.supabase.co/storage/v1/object/public/tech-trove-data/product-images/biostar-racing-z490gtn.webp',
    description: 'Mini-ITX motherboard perfect for building a compact yet powerful system.',
    stock: 20,
    ratings: {
      average: 4.0,
      totalReviews: 40
    },
    features: [
      'Supports 10th Generation Intel Core Processor',
      'Dual Channel DDR4, 2 DIMMs',
      'Direct 6 Phase power design',
      'PCIe M.2 32Gb/s'
    ],
    dimensions: {
      width: '17 cm',
      length: '17 cm',
      height: '5 cm'
    },
    weight: '0.85 kg',
    warranty: '2 years'
  },

  {
    name: 'NVIDIA GeForce RTX 3080',
    brand: 'NVIDIA',
    category: 'Graphics Cards',
    price: 699.99,
    image:
      'https://uyslfbwpmqbnobsnxsdl.supabase.co/storage/v1/object/public/tech-trove-data/product-images/rtx-3080.webp',
    description:
      "The GeForce RTX™ 3080 delivers the ultra performance that gamers crave, powered by Ampere—NVIDIA's 2nd gen RTX architecture.",
    stock: 10,
    ratings: {
      average: 4.8,
      totalReviews: 120
    },
    features: [
      '10GB GDDR6X',
      'PCI Express 4.0',
      'HDMI 2.1, 3x DisplayPort 1.4a',
      'Ray Tracing Cores, Tensor Cores'
    ],
    dimensions: {
      length: '285 mm',
      height: '112 mm',
      width: '40 mm'
    },
    weight: '1.35 kg',
    warranty: '3 years'
  },
  {
    name: 'AMD Radeon RX 6800 XT',
    brand: 'AMD',
    category: 'Graphics Cards',
    price: 649.99,
    image:
      'https://uyslfbwpmqbnobsnxsdl.supabase.co/storage/v1/object/public/tech-trove-data/product-images/rx-6800-xt.jpg',
    description:
      'The AMD Radeon RX 6800 XT graphics card, powered by AMD RDNA 2 architecture, featuring 72 powerful enhanced Compute Units, and 16GB of GDDR6 memory.',
    stock: 8,
    ratings: {
      average: 4.7,
      totalReviews: 80
    },
    features: [
      '16GB GDDR6',
      'PCI Express 4.0',
      'HDMI 2.1, 2x DisplayPort 1.4',
      'Ray Accelerators, FidelityFX'
    ],
    dimensions: {
      length: '267 mm',
      height: '120 mm',
      width: '50 mm'
    },
    weight: '1.5 kg',
    warranty: '3 years'
  },
  {
    name: 'ASUS ROG Strix NVIDIA GeForce RTX 3070',
    brand: 'ASUS',
    category: 'Graphics Cards',
    price: 599.99,
    image:
      'https://uyslfbwpmqbnobsnxsdl.supabase.co/storage/v1/object/public/tech-trove-data/product-images/rtx-3070-rog.jpg',
    description:
      "Built with the breakthrough graphics performance of the award-winning NVIDIA Turing architecture, this is your blazing-fast supercharger for today's most popular games.",
    stock: 15,
    ratings: {
      average: 4.6,
      totalReviews: 60
    },
    features: ['8GB GDDR6', 'OC Edition', 'ROG-STRIX-RTX3070-O8G-GAMING', 'Axial-tech fan design'],
    dimensions: {
      length: '299 mm',
      height: '126 mm',
      width: '52 mm'
    },
    weight: '1.47 kg',
    warranty: '3 years'
  },
  {
    name: 'MSI Gaming GeForce GTX 1660 Super',
    brand: 'MSI',
    category: 'Graphics Cards',
    price: 249.99,
    image:
      'https://uyslfbwpmqbnobsnxsdl.supabase.co/storage/v1/object/public/tech-trove-data/product-images/gtx-1660-super-msi.webp',
    description:
      'A strong backplate reinforces the graphics card while providing passive cooling by applying thermal pads.',
    stock: 20,
    ratings: {
      average: 4.5,
      totalReviews: 150
    },
    features: [
      '6GB GDDR6',
      'TWIN FROZR 7 Thermal Design',
      'TORX Fan 3.0',
      'Afterburner Overclocking Utility'
    ],
    dimensions: {
      length: '247 mm',
      height: '127 mm',
      width: '46 mm'
    },
    weight: '0.86 kg',
    warranty: '3 years'
  },
  {
    name: 'Gigabyte AORUS GeForce RTX 2060 Super',
    brand: 'Gigabyte',
    category: 'Graphics Cards',
    price: 399.99,
    image:
      'https://uyslfbwpmqbnobsnxsdl.supabase.co/storage/v1/object/public/tech-trove-data/product-images/rtx-2060-super-aorus.webp',
    description:
      'The AORUS GeForce RTX 2060 Super comes with an all-around cooling solution that keeps the GPU cool from every angle.',
    stock: 13,
    ratings: {
      average: 4.3,
      totalReviews: 45
    },
    features: [
      '8GB GDDR6',
      'WINDFORCE Stack 3x 100mm Fan Cooling System',
      'RGB light reinvented',
      '7 Video Outputs'
    ],
    dimensions: {
      length: '290 mm',
      height: '134 mm',
      width: '59 mm'
    },
    weight: '1.29 kg',
    warranty: '4 years'
  },
  {
    name: 'EVGA GeForce RTX 3090 FTW3 Ultra Gaming',
    brand: 'EVGA',
    category: 'Graphics Cards',
    price: 1499.99,
    image:
      'https://uyslfbwpmqbnobsnxsdl.supabase.co/storage/v1/object/public/tech-trove-data/product-images/evga-3090-ftw.webp',
    description:
      'The EVGA GeForce RTX 3090 is colossally powerful in every way imaginable, giving you a whole new tier of performance at 8K resolution.',
    stock: 5,
    ratings: {
      average: 4.9,
      totalReviews: 40
    },
    features: ['24GB GDDR6X', 'iCX3 Technology', 'ARGB LED', 'Ray Tracing Cores, Tensor Cores'],
    dimensions: {
      length: '300 mm',
      height: '137 mm',
      width: '56 mm'
    },
    weight: '1.77 kg',
    warranty: '3 years'
  },
  {
    name: 'EVGA GeForce RTX 3080 XC3 Ultra Gaming',
    brand: 'EVGA',
    category: 'Graphics Cards',
    price: 729.99,
    image:
      'https://uyslfbwpmqbnobsnxsdl.supabase.co/storage/v1/object/public/tech-trove-data/product-images/evga-3080-ftw.jpg',
    description:
      "Experience the best gaming experience with the new EVGA GeForce RTX 3080's enhanced Ray Tracing Cores and Tensor Cores, new streaming multiprocessors, and high-speed GDDR6X memory.",
    stock: 7,
    ratings: {
      average: 4.8,
      totalReviews: 90
    },
    features: ['10GB GDDR6X', 'iCX3 Cooling', 'Adjustable ARGB LED', 'Built for EVGA Precision X1'],
    dimensions: {
      length: '285 mm',
      height: '112 mm',
      width: '44 mm'
    },
    weight: '1.35 kg',
    warranty: '3 years'
  },
  {
    name: 'EVGA GeForce RTX 3070 XC3 Black Gaming',
    brand: 'EVGA',
    category: 'Graphics Cards',
    price: 549.99,
    image:
      'https://uyslfbwpmqbnobsnxsdl.supabase.co/storage/v1/object/public/tech-trove-data/product-images/evga-3080-ftw.jpg',
    description:
      'With the EVGA GeForce RTX 3070, you can count on incredible performance for ray tracing and AI-powered DLSS to deliver the ultimate PC gaming experience.',
    stock: 12,
    ratings: {
      average: 4.7,
      totalReviews: 70
    },
    features: ['8GB GDDR6', 'iCX3 Cooling', 'Ray Tracing Cores, Tensor Cores', 'EVGA Precision X1'],
    dimensions: {
      length: '280 mm',
      height: '111 mm',
      width: '40 mm'
    },
    weight: '1.23 kg',
    warranty: '3 years'
  },
  {
    name: 'ASUS ROG Strix GeForce RTX 4090 OC Edition',
    brand: 'ASUS',
    category: 'Graphics Cards',
    price: 1999.99,
    image:
      'https://uyslfbwpmqbnobsnxsdl.supabase.co/storage/v1/object/public/tech-trove-data/product-images/asus-rog-strix-4090-btf.png',
    description:
      'The ASUS ROG Strix GeForce RTX 4090 OC edition is built with enhanced RT Cores and Tensor Cores, new streaming multiprocessors, and superfast GDDR6X memory for an amazing gaming experience.',
    stock: 3,
    ratings: {
      average: 5.0,
      totalReviews: 25
    },
    features: ['24GB GDDR6X', 'OC Edition', 'Axial-tech Fan Design', 'Super Alloy Power II'],
    dimensions: {
      length: '357 mm',
      height: '149 mm',
      width: '71 mm'
    },
    weight: '2.1 kg',
    warranty: '4 years'
  },
  {
    name: 'ASUS ROG Strix GeForce RTX 4080',
    brand: 'ASUS',
    category: 'Graphics Cards',
    price: 1199.99,
    image:
      'https://uyslfbwpmqbnobsnxsdl.supabase.co/storage/v1/object/public/tech-trove-data/product-images/asus-rog-strix-4080-super.png',
    description:
      'The ASUS ROG Strix GeForce RTX 4080 has been redesigned to harness the incredible power of the new Ada Lovelace architecture and provides gamers with an unrivaled experience.',
    stock: 4,
    ratings: {
      average: 4.9,
      totalReviews: 30
    },
    features: ['16GB GDDR6X', 'OC Edition', 'Axial-tech Fan Design', 'GPU Tweak III'],
    dimensions: {
      length: '348 mm',
      height: '140 mm',
      width: '68 mm'
    },
    weight: '1.98 kg',
    warranty: '4 years'
  },
  {
    name: 'Gigabyte GeForce RTX 4080 Ti',
    brand: 'Gigabyte',
    category: 'Graphics Cards',
    price: 1399.99,
    image:
      'https://uyslfbwpmqbnobsnxsdl.supabase.co/storage/v1/object/public/tech-trove-data/product-images/gigabyte-rtx-3080-ti-aorus-master.webp',
    description:
      'The Gigabyte GeForce RTX 4080 Ti boasts cutting-edge performance with its next-gen RT Cores, Tensor Cores, and fast GDDR6X memory, making it ideal for the most demanding gamers and creators.',
    stock: 6,
    ratings: {
      average: 4.8,
      totalReviews: 52
    },
    features: [
      '20GB GDDR6X',
      'Next-gen Ray Tracing Cores',
      'Tensor Cores for AI Acceleration',
      'High-speed Memory Interface'
    ],
    dimensions: {
      length: '320 mm',
      height: '130 mm',
      width: '55 mm'
    },
    weight: '1.55 kg',
    warranty: '3 years'
  },
  {
    name: 'Gigabyte AORUS GeForce RTX 3090 Xtreme',
    brand: 'Gigabyte',
    category: 'Graphics Cards',
    price: 1599.99,
    image:
      'https://uyslfbwpmqbnobsnxsdl.supabase.co/storage/v1/object/public/tech-trove-data/product-images/gigabyte-aorus-rtx-3090-xtreme.jpg',
    description:
      'The Gigabyte AORUS GeForce RTX 3090 Xtreme is engineered with the highest-grade chokes and capacitors, this graphic card delivers outstanding performance and durable system lifespan.',
    stock: 4,
    ratings: {
      average: 4.8,
      totalReviews: 35
    },
    features: [
      '24GB GDDR6X',
      'Max-Covered Cooling',
      'LCD Edge View',
      'NVIDIA Ampere Streaming Multiprocessors'
    ],
    dimensions: {
      length: '319 mm',
      height: '140 mm',
      width: '70 mm'
    },
    weight: '1.89 kg',
    warranty: '4 years'
  },
  {
    name: 'Gigabyte GeForce RTX 3080 Ti AORUS MASTER',
    brand: 'Gigabyte',
    category: 'Graphics Cards',
    price: 1199.99,
    image:
      'https://uyslfbwpmqbnobsnxsdl.supabase.co/storage/v1/object/public/tech-trove-data/product-images/gigabyte-rtx-3080-ti-aorus-master.webp',
    description:
      "Powered by NVIDIA's new Ampere architecture, the Gigabyte GeForce RTX 3080 Ti AORUS MASTER delivers an incredible leap in performance and fidelity with acclaimed features such as ray tracing, tensor cores for AI acceleration, and much more.",
    stock: 3,
    ratings: {
      average: 4.9,
      totalReviews: 45
    },
    features: [
      '12GB GDDR6X',
      'WINDFORCE Stack 3X Cooling System',
      'RGB Fusion 2.0',
      'Protection Metal Back Plate'
    ],
    dimensions: {
      length: '324 mm',
      height: '142 mm',
      width: '75 mm'
    },
    weight: '1.82 kg',
    warranty: '4 years'
  },
  {
    name: 'Gigabyte AORUS GeForce RTX 4080 MASTER',
    brand: 'Gigabyte',
    category: 'Graphics Cards',
    price: 1299.99,
    image:
      'https://uyslfbwpmqbnobsnxsdl.supabase.co/storage/v1/object/public/tech-trove-data/product-images/gigabyte-aorus-rtx-4080-master.jpg',
    description:
      "Experience gaming excellence with Gigabyte's AORUS GeForce RTX 4080 MASTER. This formidable card is packed with all-new Ampere SM units delivering 2x the FP32 throughput and improved power efficiency.",
    stock: 2,
    ratings: {
      average: 5.0,
      totalReviews: 20
    },
    features: [
      '16GB GDDR6X',
      'Advanced Copper Back Plate Cooling',
      'RGB Fusion 2.0 – synchronize with other AORUS devices',
      'Dual BIOS & Anti-Sag Bracket'
    ],
    dimensions: {
      length: '336 mm',
      height: '149 mm',
      width: '71 mm'
    },
    weight: '1.96 kg',
    warranty: '4 years'
  },

  {
    name: 'Intel Core i9-12900K',
    brand: 'Intel',
    category: 'Processors',
    price: 589.99,
    image:
      'https://uyslfbwpmqbnobsnxsdl.supabase.co/storage/v1/object/public/tech-trove-data/product-images/intel-core-i9-12900k.webp',
    description:
      '12th Gen Intel Core i9 processor offers peak performance with up to 5.2 GHz and advanced overclocking capabilities for gaming and heavy workloads.',
    stock: 10,
    ratings: {
      average: 4.8,
      totalReviews: 250
    },
    features: [
      '16 cores (8 Performance-cores, 8 Efficient-cores)',
      '24 threads',
      'Up to 5.2 GHz with Intel Turbo Boost Max Technology 3.0',
      'Supports PCIe Gen 5.0 & DDR5 memory'
    ]
  },
  {
    name: 'AMD Ryzen 9 5950X',
    brand: 'AMD',
    category: 'Processors',
    price: 799.99,
    image:
      'https://uyslfbwpmqbnobsnxsdl.supabase.co/storage/v1/object/public/tech-trove-data/product-images/amd-ryzen-9-5950x.webp',
    description:
      'The AMD Ryzen 9 5950X boasts high core and thread counts for demanding applications and can push performance with aggressive boost clocks.',
    stock: 8,
    ratings: {
      average: 4.9,
      totalReviews: 200
    },
    features: [
      '16 cores & 32 threads',
      'Boost clock up to 4.9 GHz',
      '72 MB of combined cache',
      'Compatible with AMD AM4 socket motherboards'
    ]
  },
  {
    name: 'Intel Core i7-12700K',
    brand: 'Intel',
    category: 'Processors',
    price: 409.99,
    image:
      'https://uyslfbwpmqbnobsnxsdl.supabase.co/storage/v1/object/public/tech-trove-data/product-images/intel-core-i7-12700k.webp',
    description:
      'The Intel Core i7-12700K features hybrid architecture that combines performance cores with efficient cores to deliver a new level of gaming and multitasking performance.',
    stock: 15,
    ratings: {
      average: 4.7,
      totalReviews: 180
    },
    features: [
      '12 cores (8 Performance-cores, 4 Efficient-cores)',
      '20 threads',
      'Up to 5.0 GHz with Intel Turbo Boost Max Technology 3.0',
      'Compatible with Intel 600 series chipset based motherboards'
    ]
  },
  {
    name: 'AMD Ryzen 7 5800X',
    brand: 'AMD',
    category: 'Processors',
    price: 449.0,
    image:
      'https://uyslfbwpmqbnobsnxsdl.supabase.co/storage/v1/object/public/tech-trove-data/product-images/amd-ryzen-7-5800x.jpg',
    description:
      'With the AMD Ryzen 7 5800X, experience elite gaming with 8 cores optimized for high-FPS gaming rigs, and handle demanding tasks like content creation with ease.',
    stock: 12,
    ratings: {
      average: 4.6,
      totalReviews: 220
    },
    features: [
      '8 cores & 16 threads',
      'Boost clock up to 4.7 GHz',
      '36 MB of total cache',
      'Compatible with AMD AM4 socket motherboards'
    ]
  },
  {
    name: 'Intel Core i5-12600K',
    brand: 'Intel',
    category: 'Processors',
    price: 299.99,
    image:
      'https://uyslfbwpmqbnobsnxsdl.supabase.co/storage/v1/object/public/tech-trove-data/product-images/intel-core-i5-12600k.jpg',
    description:
      'The Intel Core i5-12600K offers excellent mid-range performance with its new hybrid architecture optimized for gaming and productivity.',
    stock: 20,
    ratings: {
      average: 4.7,
      totalReviews: 100
    },
    features: [
      '10 cores (6 Performance-cores, 4 Efficient-cores)',
      '16 threads',
      'Up to 4.9 GHz with Intel Turbo Boost Technology',
      'Compatible with Intel 600 series chipset based motherboards'
    ]
  },
  {
    name: 'AMD Ryzen 5 5600X',
    brand: 'AMD',
    category: 'Processors',
    price: 309.99,
    image:
      'https://uyslfbwpmqbnobsnxsdl.supabase.co/storage/v1/object/public/tech-trove-data/product-images/amd-ryzen-5-5600x.webp',
    description:
      'The AMD Ryzen 5 5600X is a powerful six-core processor that excels in gaming and productivity tasks with its high boost clocks.',
    stock: 25,
    ratings: {
      average: 4.8,
      totalReviews: 150
    },
    features: [
      '6 cores & 12 threads',
      'Boost clock up to 4.6 GHz',
      '35 MB of total cache',
      'Compatible with AMD AM4 socket motherboards'
    ]
  },

  {
    name: 'Intel Core i7-11700K',
    brand: 'Intel',
    category: 'Processors',
    price: 374.99,
    image:
      'https://uyslfbwpmqbnobsnxsdl.supabase.co/storage/v1/object/public/tech-trove-data/product-images/intel-core-i7-11700k.webp',
    description:
      'Unlocked 11th Gen Intel Core i7-11700K desktop processor, designed for gamers and creative professionals who want to push their experience to higher levels.',
    stock: 20,
    ratings: {
      average: 4.5,
      totalReviews: 140
    },
    features: [
      '8 cores & 16 threads',
      '3.6 GHz base clock, up to 5.0 GHz with Intel Turbo Boost Max Technology 3.0',
      '16 MB Intel Smart Cache',
      'Compatible with Intel 500 series & select 400 series chipset based motherboards'
    ]
  },

  {
    name: 'AMD Ryzen Threadripper 3960X',
    brand: 'AMD',
    category: 'Processors',
    price: 1399.99,
    image:
      'https://uyslfbwpmqbnobsnxsdl.supabase.co/storage/v1/object/public/tech-trove-data/product-images/amd-ryzen-threadripper-3960x.webp',
    description:
      'The AMD Ryzen Threadripper 3960X is a powerhouse for creators and enthusiasts, featuring 24 cores and 48 threads to handle complex workloads with ease.',
    stock: 5,
    ratings: {
      average: 4.9,
      totalReviews: 85
    },
    features: [
      '24 cores & 48 threads',
      'Base clock of 3.8 GHz, Boost clock of up to 4.5 GHz',
      '140 MB of combined cache',
      'sTRX4 Socket, compatible with AMD TRX40 chipset motherboards'
    ]
  },
  {
    name: 'Intel Core i3-10100',
    brand: 'Intel',
    category: 'Processors',
    price: 122.99,
    image:
      'https://uyslfbwpmqbnobsnxsdl.supabase.co/storage/v1/object/public/tech-trove-data/product-images/intel-core-i3-10100.jpg',
    description:
      'Intel Core i3-10100 provides solid performance for everyday computing, with a quad-core design and Intel Hyper-Threading Technology.',
    stock: 30,
    ratings: {
      average: 4.5,
      totalReviews: 80
    },
    features: [
      '4 cores & 8 threads',
      '3.6 GHz base clock, up to 4.3 GHz with Turbo Boost',
      '6 MB cache',
      'Compatible with Intel 400 series chipset based motherboards'
    ]
  },

  {
    name: 'AMD Ryzen 3 3300X',
    brand: 'AMD',
    category: 'Processors',
    price: 129.99,
    image:
      'https://uyslfbwpmqbnobsnxsdl.supabase.co/storage/v1/object/public/tech-trove-data/product-images/amd-ryzen-3-3300x.webp',
    description:
      'AMD Ryzen 3 3300X offers great entry-level gaming and multitasking with impressive single-threaded performance and unlocked overclocking potential.',
    stock: 18,
    ratings: {
      average: 4.4,
      totalReviews: 60
    },
    features: [
      '4 cores & 8 threads',
      'Boost clock up to 4.3 GHz',
      '18 MB of total cache',
      'Compatible with AMD AM4 socket motherboards'
    ]
  },

  {
    name: 'Intel Core i5-10400F',
    brand: 'Intel',
    category: 'Processors',
    price: 157.99,
    image:
      'https://uyslfbwpmqbnobsnxsdl.supabase.co/storage/v1/object/public/tech-trove-data/product-images/intel-core-i5-12600k.jpg',
    description:
      'A fantastic choice for budget gaming rigs, the Intel Core i5-10400F offers six cores of processing power without integrated graphics.',
    stock: 22,
    ratings: {
      average: 4.6,
      totalReviews: 90
    },
    features: [
      '6 cores & 12 threads',
      '2.9 GHz base clock, up to 4.3 GHz with Turbo Boost',
      '12 MB cache',
      'Compatible with Intel 400 series chipset based motherboards'
    ]
  },

  {
    name: 'AMD Ryzen 7 PRO 4750G',
    brand: 'AMD',
    category: 'Processors',
    price: 359.99,
    image:
      'https://uyslfbwpmqbnobsnxsdl.supabase.co/storage/v1/object/public/tech-trove-data/product-images/amd-ryzen-7-pro-4750g.webp',
    description:
      'Designed for professional use in mind, the AMD Ryzen 7 PRO 4750G includes Radeon graphics and robust security features catering to business environments.',
    stock: 14,
    ratings: {
      average: 4.5,
      totalReviews: 40
    },
    features: [
      '8 cores & 16 threads',
      'Boost clock up to 4.4 GHz',
      '12 MB of total cache',
      'Radeon Graphics',
      'Compatible with AMD AM4 socket motherboards'
    ]
  },

  {
    name: 'Corsair Dominator Platinum RGB 32GB (2x16GB) DDR4 3200MHz',
    brand: 'Corsair',
    category: 'Memory',
    price: 229.99,
    image:
      'https://uyslfbwpmqbnobsnxsdl.supabase.co/storage/v1/object/public/tech-trove-data/product-images/corsair-dominator-platinum.webp',
    description:
      'The Corsair Dominator Platinum RGB is the perfect blend of performance and aesthetics, featuring iconic design, patented DHX cooling technology, and a wide range of customization options with iCUE software.',
    stock: 35,
    ratings: {
      average: 4.8,
      totalReviews: 215
    },
    features: [
      '32GB (2 x 16GB) DDR4 DRAM 3200MHz C16',
      'Patented DHX cooling technology',
      'Dynamic multi-zone RGB lighting',
      'Custom performance PCB for high signal quality and stability'
    ]
  },

  {
    name: 'G.SKILL Trident Z Royal Series 16GB (2x8GB) DDR4 4000MHz',
    brand: 'G.SKILL',
    category: 'Memory',
    price: 199.99,
    image:
      'https://uyslfbwpmqbnobsnxsdl.supabase.co/storage/v1/object/public/tech-trove-data/product-images/g-skill-trident-z-royal.jpg',
    description:
      'Trident Z Royal series represents one of the highest echelons in performance memory, designed with a crown jewel-like design, crystalline light bars, and luxury aluminum heatsinks.',
    stock: 18,
    ratings: {
      average: 4.9,
      totalReviews: 152
    },
    features: [
      '16GB (2 x 8GB) DDR4 DRAM 4000MHz C17',
      'Luxury aluminum heat spreaders with crystalline light bar',
      'Extreme overclocking performance',
      'Intel XMP 2.0 profile support for easy overclocking'
    ]
  },
  {
    name: 'Teamgroup T-Force Xtreem ARGB 16GB (2x8GB) DDR4 3600MHz',
    brand: 'Teamgroup',
    category: 'Memory',
    price: 159.99,
    image:
      'https://uyslfbwpmqbnobsnxsdl.supabase.co/storage/v1/object/public/tech-trove-data/product-images/teamgroup-t-force-xtreem-argb.webp',
    description:
      'The T-Force Xtreem ARGB features mesmerizing RGB lighting with mirror reflection design, offering both striking visuals and outstanding performance.',
    stock: 25,
    ratings: {
      average: 4.7,
      totalReviews: 89
    },
    features: [
      '16GB (2 x 8GB) DDR4 DRAM 3600MHz C14',
      'Full mirror reflection design with ARGB lighting',
      'High-efficiency aluminum heat spreader',
      'Supports Intel & AMD motherboards',
      'XMP 2.0 support for overclocking'
    ]
  },

  {
    name: 'Crucial Ballistix MAX 32GB (2x16GB) DDR4 4400MHz',
    brand: 'Crucial',
    category: 'Memory',
    price: 349.99,
    image:
      'https://uyslfbwpmqbnobsnxsdl.supabase.co/storage/v1/object/public/tech-trove-data/product-images/crucial-ballistix-max.jpg',
    description:
      'Crucial Ballistix MAX offers maximum speeds and responsiveness for gaming enthusiasts and extreme overclockers with its meticulously engineered design and XMP profiles.',
    stock: 10,
    ratings: {
      average: 4.9,
      totalReviews: 47
    },
    features: [
      '32GB (2 x 16GB) DDR4 DRAM 4400MHz C19',
      'Precision temperature sensor integrated',
      'Aluminum heat spreader for efficient thermal management',
      'Included Ballistix M.O.D. Utility software for real-time temperature monitoring',
      'Designed for extreme overclocking enthusiasts'
    ]
  },
  {
    name: 'G.SKILL Trident Z Royal Series 32GB (2x16GB) DDR4 3200MHz',
    brand: 'G.SKILL',
    category: 'Memory',
    price: 219.99,
    image:
      'https://uyslfbwpmqbnobsnxsdl.supabase.co/storage/v1/object/public/tech-trove-data/product-images/g-skill-trident-z-royal-series.jpg',
    description:
      'Experience luxury and performance with the Trident Z Royal Series, featuring a polished aluminum heat spreader in magnificent gold or silver and crystalline light bar.',
    stock: 15,
    ratings: {
      average: 4.8,
      totalReviews: 115
    },
    features: [
      '32GB (2 x 16GB) DDR4 DRAM 3200MHz C16',
      'Polished aluminum heat spreaders in gold or silver',
      'Brilliant RGB lighting with software control',
      'Highly screened ICs for peak performance potential',
      'Supports Intel & AMD motherboards'
    ]
  },

  {
    name: 'Corsair Dominator Platinum RGB 64GB (4x16GB) DDR4 3600MHz',
    brand: 'Corsair',
    category: 'Memory',
    price: 549.99,
    image:
      'https://uyslfbwpmqbnobsnxsdl.supabase.co/storage/v1/object/public/tech-trove-data/product-images/corsair-dominator-platinum-rgb.jpg',
    description:
      'The Corsair Dominator Platinum RGB is the pinnacle of premium craftsmanship, intelligent design, and stunning RGB lighting powered by Corsair iCUE software.',
    stock: 8,
    ratings: {
      average: 4.9,
      totalReviews: 76
    },
    features: [
      '64GB (4 x 16GB) DDR4 DRAM 3600MHz C18',
      'Patented DHX cooling technology',
      'Iconic design with a precision forged die-cast zinc alloy top cap',
      '12 ultra-bright, individually addressable CAPELLIX RGB LEDs per module',
      'Custom high-performance PCB for superior overclocking capability'
    ]
  },
  {
    name: 'G.SKILL Trident Z Neo Series 32GB (2x16GB) DDR4 3200MHz',
    brand: 'G.SKILL',
    category: 'Memory',
    price: 299.99,
    image:
      'https://uyslfbwpmqbnobsnxsdl.supabase.co/storage/v1/object/public/tech-trove-data/product-images/g-skill-trident-z-neo.webp',
    description:
      "Designed for gaming and PC enthusiasts, the Trident Z Neo DDR4 memory series brings performance and style with sleek exterior design and dazzling RGB lighting effects using G.SKILL's Trident Z Lighting Control software.",
    stock: 15,
    ratings: {
      average: 4.8,
      totalReviews: 45
    },
    features: [
      '32GB (2 x 16GB) DDR4 DRAM 3200MHz C16',
      'Optimized for AMD Ryzen platforms',
      'Neo Design Elements',
      'Trident Z RGB heatspreader for improved heat dissipation',
      'Custom engineered ten-layer PCB for better signal stability'
    ]
  },
  {
    name: 'Crucial Ballistix MAX 32GB (2x16GB) DDR4 4400MHz',
    brand: 'Crucial',
    category: 'Memory',
    price: 349.99,
    image:
      'https://uyslfbwpmqbnobsnxsdl.supabase.co/storage/v1/object/public/tech-trove-data/product-images/crucial-ballistix-max-4400.jpg',
    description:
      'The Crucial Ballistix MAX DDR4 memory is engineered for the latest AMD and Intel platforms with XMP 2.0 support for automatic overclocking. Tuned for high performance and designed for gamers and modders seeking a cutting-edge advantage.',
    stock: 10,
    ratings: {
      average: 4.7,
      totalReviews: 32
    },
    features: [
      '32GB (2 x 16GB) DDR4 DRAM 4400MHz C19',
      'Aluminum heat spreader included for thermal management',
      'XMP 2.0 support for easy installation and setup',
      'Precision-crafted for high-speed performance',
      'Customizable RGB LED color to match your system'
    ]
  },

  {
    name: 'Teamgroup T-Force Vulcan Z 16GB (2x8GB) DDR4 3000MHz',
    brand: 'Teamgroup',
    category: 'Memory',
    price: 79.99,
    image:
      'https://uyslfbwpmqbnobsnxsdl.supabase.co/storage/v1/object/public/tech-trove-data/product-images/teamgroup-vulcan-z.webp',
    description:
      'The Teamgroup T-Force Vulcan Z is designed for complete protection and enhanced heat dissipation. The heat spreader is made of a punch press process with a 0.8mm thick, one-piece alloy aluminum to reinforce the body structure.',
    stock: 25,
    ratings: {
      average: 4.6,
      totalReviews: 104
    },
    features: [
      '16GB (2 x 8GB) DDR4 DRAM 3000MHz C16',
      'Simple design to fit into mainstream gaming systems',
      'High thermal conductive adhesive',
      'Supports Intel & AMD motherboards',
      'Selected high-quality IC chips'
    ]
  },

  {
    name: 'Samsung 980 PRO PCIe 4.0 NVMe M.2',
    brand: 'Samsung',
    category: 'SSD',
    price: 229.99,
    image:
      'https://uyslfbwpmqbnobsnxsdl.supabase.co/storage/v1/object/public/tech-trove-data/product-images/samsung-980-pro.webp',
    description:
      'The Samsung 980 PRO offers exceptional speed and reliability with PCIe 4.0 connectivity and up to 7000 MB/s read speeds.',
    stock: 50,
    ratings: {
      average: 4.9,
      totalReviews: 2150
    },
    features: [
      'PCIe 4.0 NVMe M.2 Interface',
      'Read speeds up to 7000 MB/s',
      'Capacity options up to 2TB'
    ]
  },
  {
    name: 'Western Digital WD Black SN850 NVMe M.2',
    brand: 'Western Digital',
    category: 'SSD',
    price: 199.99,
    image:
      'https://uyslfbwpmqbnobsnxsdl.supabase.co/storage/v1/object/public/tech-trove-data/product-images/wd-black-sn850.webp',
    description:
      'High-performance gaming SSD with PCIe 4.0 technology for blazing fast read and write speeds.',
    stock: 40,
    ratings: {
      average: 4.8,
      totalReviews: 1875
    },
    features: [
      'PCIe 4.0 NVMe M.2 Interface',
      'Read speeds up to 7000 MB/s',
      'Capacity options up to 2TB'
    ]
  },
  {
    name: 'Crucial P5 1TB 3D NAND NVMe M.2 SSD',
    brand: 'Crucial',
    category: 'SSD',
    price: 109.99,
    image:
      'https://uyslfbwpmqbnobsnxsdl.supabase.co/storage/v1/object/public/tech-trove-data/product-images/crucial-p5.webp',
    description:
      "The Crucial P5 redefines what's possible with innovations that transform the speed of storage.",
    stock: 35,
    ratings: {
      average: 4.7,
      totalReviews: 680
    },
    features: [
      'NVMe M.2 Interface',
      'Read speeds up to 3400 MB/s',
      'Dynamic Write Acceleration technology',
      'Available in capacities up to 2TB'
    ]
  },
  {
    name: 'SK hynix Gold P31 PCIe NVMe M.2',
    brand: 'SK hynix',
    category: 'SSD',
    price: 134.99,
    image:
      'https://uyslfbwpmqbnobsnxsdl.supabase.co/storage/v1/object/public/tech-trove-data/product-images/sk-hynix-gold-p31.webp',
    description:
      "One of the world's first 128-layer NAND flash-based consumer SSDs, delivering unparalleled speed and efficiency.",
    stock: 30,
    ratings: {
      average: 4.7,
      totalReviews: 965
    },
    features: [
      'PCIe 3.0 NVMe M.2 Interface',
      'Read speeds up to 3500 MB/s',
      'Power-efficient performance',
      'Capacity up to 1TB'
    ]
  },
  {
    name: 'ADATA XPG SX8200 Pro 1TB',
    brand: 'ADATA',
    category: 'SSD',
    price: 129.99,
    image:
      'https://uyslfbwpmqbnobsnxsdl.supabase.co/storage/v1/object/public/tech-trove-data/product-images/adata-xpg-sx8200-pro.jpg',
    description:
      'Utilizing PCIe Gen3x4 interface and featuring NVMe 1.3 support, the XPG SX8200 Pro delivers fast read/write speeds for accelerated performance.',
    stock: 25,
    ratings: {
      average: 4.6,
      totalReviews: 312
    },
    features: [
      'PCIe Gen3x4 NVMe 1.3 Interface',
      'Read/Write speeds up to 3500/3000 MB/s',
      'Advanced 3D NAND Technology',
      'Capacity options ranging from 256GB to 1TB'
    ]
  },
  {
    name: 'Corsair Force Series MP600 2TB',
    brand: 'Corsair',
    category: 'SSD',
    price: 369.99,
    image:
      'https://uyslfbwpmqbnobsnxsdl.supabase.co/storage/v1/object/public/tech-trove-data/product-images/corsair-force-mp600.webp',
    description:
      'The Corsair Force Series MP600 uses Gen4 PCIe technology with blazing fast sequential read speeds of up to 4950MB/s for top-tier performance.',
    stock: 20,
    ratings: {
      average: 4.5,
      totalReviews: 789
    },
    features: [
      'Gen4 PCIe x4 NVMe 1.3 M.2 Interface',
      'Sequential read speeds up to 4950 MB/s',
      'High-density 3D TLC NAND',
      'Integrated aluminum heat spreader',
      'Capacities up to 2TB'
    ]
  },
  {
    name: 'Seagate FireCuda 520 1TB NVMe',
    brand: 'Seagate',
    category: 'SSD',
    price: 219.99,
    image:
      'https://uyslfbwpmqbnobsnxsdl.supabase.co/storage/v1/object/public/tech-trove-data/product-images/seagate-firecuda-520.webp',
    description:
      'The Seagate FireCuda 520 SSD offers enthusiasts and pro-level gamers the fastest data transfer rates available in a solid state drive.',
    stock: 15,
    ratings: {
      average: 4.7,
      totalReviews: 528
    },
    features: [
      'PCIe Gen4 ×4 NVMe 1.3 Interface',
      'Zoned Performance for Gaming',
      'Sequential read/write speeds of up to 5000/4400 MB/s',
      'Capacities up to 2TB'
    ]
  },
  {
    name: 'Samsung 970 EVO Plus 1TB',
    brand: 'Samsung',
    category: 'SSD',
    price: 199.99,
    image:
      'https://uyslfbwpmqbnobsnxsdl.supabase.co/storage/v1/object/public/tech-trove-data/product-images/samsung-970-evo-plus.webp',
    description:
      'The Samsung 970 EVO Plus delivers breakthrough speeds and best-in-class reliability.',
    stock: 30,
    ratings: {
      average: 4.8,
      totalReviews: 850
    },
    features: [
      'NVMe M.2 Interface',
      'Read speeds up to 3,500 MB/s',
      'Write speeds up to 3,300 MB/s',
      'Samsung V-NAND Technology'
    ]
  },
  {
    name: 'Crucial MX500 1TB',
    brand: 'Crucial',
    category: 'SSD',
    price: 114.99,
    image:
      'https://uyslfbwpmqbnobsnxsdl.supabase.co/storage/v1/object/public/tech-trove-data/product-images/crucial-mx500.webp',
    description:
      'The Crucial MX500 offers solid performance and reliability with dynamic write acceleration technology.',
    stock: 40,
    ratings: {
      average: 4.7,
      totalReviews: 920
    },
    features: [
      'SATA Interface for easy upgrade',
      'Read speeds up to 560 MB/s',
      'Write speeds up to 510 MB/s',
      'Integrated Power Loss Immunity'
    ]
  },
  {
    name: 'Western Digital Blue SN550 1TB',
    brand: 'Western Digital',
    category: 'SSD',
    price: 109.99,
    image:
      'https://uyslfbwpmqbnobsnxsdl.supabase.co/storage/v1/object/public/tech-trove-data/product-images/wd-blue-sn550.jpg',
    description:
      'The WD Blue SN550 NVMe SSD can deliver over 4 times the speed of our best SATA SSDs.',
    stock: 35,
    ratings: {
      average: 4.6,
      totalReviews: 780
    },
    features: [
      'NVMe drive not compatible with SATA interface',
      'Read speeds up to 2,400 MB/s',
      'Uses Western Digital-designed controller and firmware for optimized performance',
      'Low power efficiency'
    ]
  },
  {
    name: 'ADATA XPG SX8200 Pro 1TB',
    brand: 'ADATA',
    category: 'SSD',
    price: 129.99,
    image:
      'https://uyslfbwpmqbnobsnxsdl.supabase.co/storage/v1/object/public/tech-trove-data/product-images/adata-xpg-sx8200-pro.jpg',
    description:
      'The ADATA XPG SX8200 Pro is designed for hardcore gamers, PC enthusiasts, overclockers, and video content producers.',
    stock: 25,
    ratings: {
      average: 4.7,
      totalReviews: 640
    },
    features: [
      'NVMe 1.3 Support',
      'Read speeds up to 3,500 MB/s',
      'Write speeds up to 3,000 MB/s',
      '5-year limited warranty'
    ]
  },
  {
    name: 'Corsair Force Series MP600 2TB',
    brand: 'Corsair',
    category: 'SSD',
    price: 399.99,
    image:
      'https://uyslfbwpmqbnobsnxsdl.supabase.co/storage/v1/object/public/tech-trove-data/product-images/corsair-force-mp600.webp',
    description:
      'The Corsair Force Series MP600 Gen4 PCIe x4 NVMe M.2 SSD provides extreme storage performance with up to 4,950MB/sec sequential read, and up to 4,250MB/sec sequential write speeds.',
    stock: 15,
    ratings: {
      average: 4.8,
      totalReviews: 480
    },
    features: [
      'PCIe Gen4 x4 NVMe Interface',
      'High-density 3D TLC NAND',
      'Outstanding endurance',
      'M.2 2280 form factor'
    ]
  },

  {
    name: 'Corsair RM750x',
    brand: 'Corsair',
    category: 'Power Supply',
    price: 129.99,
    image:
      'https://uyslfbwpmqbnobsnxsdl.supabase.co/storage/v1/object/public/tech-trove-data/product-images/corsair-rm750x.webp',
    description:
      'The Corsair RM750x is a high-performance power supply boasting full modular cables and 80+ Gold efficiency for quiet operation and less heat generation.',
    stock: 25,
    ratings: {
      average: 4.9,
      totalReviews: 3200
    },
    features: [
      '750W continuous power output',
      '80 PLUS Gold certified',
      'Zero RPM fan mode',
      'Fully modular cables',
      '10-year warranty'
    ]
  },
  {
    name: 'EVGA SuperNOVA 850 G3',
    brand: 'EVGA',
    category: 'Power Supply',
    price: 159.99,
    image:
      'https://uyslfbwpmqbnobsnxsdl.supabase.co/storage/v1/object/public/tech-trove-data/product-images/evga-supernova-850-g3.jpg',
    description:
      'The EVGA SuperNOVA 850 G3 provides reliable power with 80+ Gold efficiency, fully modular design, and Eco Mode for ultra-quiet performance.',
    stock: 20,
    ratings: {
      average: 4.7,
      totalReviews: 2500
    },
    features: [
      '850W output capacity',
      '80 PLUS Gold efficiency',
      'Fully modular to reduce clutter',
      'ECO Mode for silent operation',
      '7-year warranty'
    ]
  },
  {
    name: 'Seasonic FOCUS Plus 650 Gold',
    brand: 'Seasonic',
    category: 'Power Supply',
    price: 99.9,
    image:
      'https://uyslfbwpmqbnobsnxsdl.supabase.co/storage/v1/object/public/tech-trove-data/product-images/seasonic-focus-plus-650-gold.webp',
    description:
      'The Seasonic FOCUS Plus 650 Gold is a compact, highly reliable power supply with 80+ Gold certification and fully modular cables for easy installation.',
    stock: 25,
    ratings: {
      average: 4.6,
      totalReviews: 75
    },
    features: [
      '650 watts of output',
      '80 PLUS Gold efficiency',
      'Fully modular cabling',
      'Compact size fits in standard cases',
      "10-year manufacturer's warranty"
    ]
  },
  {
    name: 'ASUS ROG Thor 850',
    brand: 'ASUS',
    category: 'Power Supply',
    price: 219.99,
    image:
      'https://uyslfbwpmqbnobsnxsdl.supabase.co/storage/v1/object/public/tech-trove-data/product-images/asus-rog-thor-850.webp',
    description:
      'The ASUS ROG Thor 850 is the choice for gamers, featuring 80+ Platinum efficiency, customizable Aura Sync RGB lighting, and an OLED power display.',
    stock: 5,
    ratings: {
      average: 4.6,
      totalReviews: 12
    },
    features: [
      '850 watts of stable power',
      '80 PLUS Platinum certification',
      'Customizable RGB lighting with Aura Sync',
      'Integrated OLED power display',
      'Fully modular cable design'
    ]
  },
  {
    name: 'Cooler Master V750',
    brand: 'Cooler Master',
    category: 'Power Supply',
    price: 119.99,
    image:
      'https://uyslfbwpmqbnobsnxsdl.supabase.co/storage/v1/object/public/tech-trove-data/product-images/cooler-master-v750.webp',
    description:
      'Cooler Master V750 offers high efficiency and stability with its 80+ Gold certification and fully modular design, ideal for a variety of PC builds.',
    stock: 15,
    ratings: {
      average: 4.6,
      totalReviews: 32
    },
    features: [
      '750W continuous power output',
      '80 PLUS Gold certified for high efficiency',
      'Silent 135mm fan with semi-fanless operation',
      'Fully modular cables for a clean build',
      '5-year warranty'
    ]
  },
  {
    name: 'Thermaltake Toughpower 1050W',
    brand: 'Thermaltake',
    category: 'Power Supply',
    price: 209.99,
    image:
      'https://uyslfbwpmqbnobsnxsdl.supabase.co/storage/v1/object/public/tech-trove-data/product-images/thermaltake-toughpower-grand-rgb-1050w.jpg',
    description:
      'With 1050W of power, 80+ Platinum certification, and a patented 256-color RGB fan, the Toughpower Grand RGB is a premium PSU for performance PCs.',
    stock: 4,
    ratings: {
      average: 4.2,
      totalReviews: 12
    },
    features: [
      '1050 watts for high-demand systems',
      '80 PLUS Platinum efficiency for optimal energy use',
      'RGB LED fan for aesthetic customizations',
      'Smart zero fan for near silent operation',
      'Fully modular cable management'
    ]
  },
  {
    name: 'NZXT C650',
    brand: 'NZXT',
    category: 'Power Supply',
    price: 109.99,
    image:
      'https://uyslfbwpmqbnobsnxsdl.supabase.co/storage/v1/object/public/tech-trove-data/product-images/nzxt-c650.webp',
    description:
      'The NZXT C650 PSU delivers clean, stable power with 80+ Gold efficiency and a silent operation, perfect for your gaming rig.',
    stock: 35,
    ratings: {
      average: 4.5,
      totalReviews: 67
    },
    features: [
      '650 watts of reliable power',
      '80 PLUS Gold certified',
      'Fully modular design simplifies cable management',
      "NZXT's E-Series offers real-time power monitoring",
      '10-year warranty'
    ]
  },
  {
    name: 'Be Quiet! Straight Power 11 650W',
    brand: 'Be Quiet!',
    category: 'Power Supply',
    price: 129.9,
    image:
      'https://uyslfbwpmqbnobsnxsdl.supabase.co/storage/v1/object/public/tech-trove-data/product-images/be-quiet-straight-power-11-650w.jpg',
    description:
      'Designed for computer enthusiasts seeking quiet operation, the Be Quiet! Straight Power 11 650W offers exceptional reliability and performance.',
    stock: 21,
    ratings: {
      average: 4.7,
      totalReviews: 39
    },
    features: [
      '650W output to support demanding systems',
      '80 PLUS Gold certified for high energy efficiency',
      'Virtually inaudible Silent Wings 3 fan',
      'Fully modular cable setup for a neat build',
      "5-year manufacturer's warranty"
    ]
  },
  {
    name: 'Fractal Design Ion+ 760P',
    brand: 'Fractal Design',
    category: 'Power Supply',
    price: 139.99,
    image:
      'https://uyslfbwpmqbnobsnxsdl.supabase.co/storage/v1/object/public/tech-trove-data/product-images/fractal-design-ion-760p.jpg',
    description:
      "Fractal Design's Ion+ 760P is a premium power supply unit with stellar performance, ultra-flexible cables, and 80+ Platinum efficiency.",
    stock: 18,
    ratings: {
      average: 4.8,
      totalReviews: 58
    },
    features: [
      '760 watts for high-performance PCs',
      '80 PLUS Platinum rating ensures top-notch efficiency',
      'Fully modular design and premium UltraFlex cables',
      'Quiet operation with dynamic bearing fan',
      '10-year warranty'
    ]
  },
  {
    name: 'XPG Core Reactor 650W',
    brand: 'XPG',
    category: 'Power Supply',
    price: 109.99,
    image:
      'https://uyslfbwpmqbnobsnxsdl.supabase.co/storage/v1/object/public/tech-trove-data/product-images/xpg-core-reactor.webp',
    description:
      'The XPG Core Reactor 650W is a compact, powerful PSU with 80+ Gold efficiency, suited for gamers and enthusiasts looking for top performance.',
    stock: 24,
    ratings: {
      average: 4.6,
      totalReviews: 48
    },
    features: [
      '650 watts of continuous power',
      '80 PLUS Gold certification for efficient power usage',
      'Fully modular cables for an easy and clean build',
      '120mm fluid dynamic bearing fan for near-silent operation',
      "10-year manufacturer's warranty"
    ]
  },

  {
    name: 'Apple MacBook Pro 16-inch',
    brand: 'Apple',
    category: 'Laptop',
    price: 2399.99,
    image:
      'https://uyslfbwpmqbnobsnxsdl.supabase.co/storage/v1/object/public/tech-trove-data/product-images/mac-book.jpg',
    description:
      'Designed for professionals, the MacBook Pro features a stunning 16-inch Retina display, powerful processors and graphics, and up to 20 hours of battery life.',
    stock: 15,
    ratings: {
      average: 4.7,
      totalReviews: 532
    },
    features: [
      '16-inch Retina display with True Tone technology',
      'Latest-generation Intel Core processors or M1 Pro/Max chips',
      'Up to 64GB RAM and 8TB of superfast SSD storage',
      'Incredible battery life',
      'Touch Bar and Touch ID'
    ]
  },
  {
    name: 'Dell XPS 15',
    brand: 'Dell',
    category: 'Laptop',
    price: 1850.0,
    image:
      'https://uyslfbwpmqbnobsnxsdl.supabase.co/storage/v1/object/public/tech-trove-data/product-images/dell-xps-15.jpg',
    description:
      "With its stunning 4K UHD display, powerful performance from Intel's latest CPUs, and premium construction, the Dell XPS 15 is an ideal choice for power users.",
    stock: 20,
    ratings: {
      average: 4.5,
      totalReviews: 215
    },
    features: [
      '15.6-inch 4K UHD InfinityEdge touchscreen display',
      '10th Gen Intel Core i7 or i9 processors',
      'NVIDIA GeForce GTX 1650 Ti GPU',
      'Up to 32GB DDR4 RAM and 1TB PCIe SSD',
      'CNC machined aluminum and carbon fiber build'
    ]
  },
  {
    name: 'Lenovo ThinkPad X1 Carbon Gen 9',
    brand: 'Lenovo',
    category: 'Laptop',
    price: 1429.99,
    image:
      'https://uyslfbwpmqbnobsnxsdl.supabase.co/storage/v1/object/public/tech-trove-data/product-images/asus-tuf-gaming-laptop.webp',
    description:
      'The Lenovo ThinkPad X1 Carbon offers robust security, durability, and performance in an ultralight and thin package, perfect for business professionals.',
    stock: 25,
    ratings: {
      average: 4.6,
      totalReviews: 98
    },
    features: [
      '14-inch FHD+ (1920 x 1200) IPS anti-glare display',
      '11th Gen Intel Core processors',
      'Intel Iris Xe Graphics',
      'Up to 32GB LPDDR4x RAM and 1TB PCIe SSD',
      'Mil-spec tested for durability'
    ]
  },
  {
    name: 'ASUS ROG Zephyrus G15',
    brand: 'ASUS',
    category: 'Laptop',
    price: 1799.99,
    image:
      'https://uyslfbwpmqbnobsnxsdl.supabase.co/storage/v1/object/public/tech-trove-data/product-images/rog-strix-17-gaming.jpg',
    description:
      'The ASUS ROG Zephyrus G15 balances exceptional portability with potent performance, including a high-refresh-rate display and strong gaming capabilities.',
    stock: 18,
    ratings: {
      average: 4.8,
      totalReviews: 123
    },
    features: [
      '15.6-inch QHD display with a 165Hz refresh rate',
      'AMD Ryzen 9 processor',
      'NVIDIA GeForce RTX 3080 Graphics',
      'Up to 32GB DDR4 RAM and 1TB NVMe PCIe SSD',
      'Ergonomic backlit keyboard and multiple I/O ports'
    ]
  },
  {
    name: 'ASUS ROG Zephyrus Duo 15',
    brand: 'ASUS',
    category: 'Laptop',
    price: 2899.99,
    image:
      'https://uyslfbwpmqbnobsnxsdl.supabase.co/storage/v1/object/public/tech-trove-data/product-images/asus-rog-zephyrus-duo-15.jpg',
    description:
      'The ASUS ROG Zephyrus Duo 15 features an innovative dual-screen design, high-end performance hardware, and exceptional cooling for a top-tier gaming experience.',
    stock: 10,
    ratings: {
      average: 4.8,
      totalReviews: 75
    },
    features: [
      '15.6-inch primary display with secondary touchscreen panel',
      'Intel Core i9 processor',
      'NVIDIA GeForce RTX 3080 GPU',
      'Up to 32GB RAM and 2TB RAID 0 SSD storage',
      'ROG ScreenPad Plus for multitasking'
    ]
  },
  {
    name: 'Alienware Area-51m R2',
    brand: 'Dell Alienware',
    category: 'Laptop',
    price: 2229.99,
    image:
      'https://uyslfbwpmqbnobsnxsdl.supabase.co/storage/v1/object/public/tech-trove-data/product-images/alienware-area-51m.webp',
    description:
      'The Alienware Area-51m R2 is designed for gamers seeking desktop-level power in a laptop form-factor, featuring upgradable components and a bold design.',
    stock: 12,
    ratings: {
      average: 4.6,
      totalReviews: 89
    },
    features: [
      '17.3-inch FHD (1920 x 1080) 144Hz display',
      '10th Gen Intel Core i7/i9 processors',
      'NVIDIA GeForce GTX or RTX series GPUs',
      'Up to 64GB DDR4 RAM and multiple SSD + HDD options',
      'Advanced Cryo-Tech cooling technology'
    ]
  },
  {
    name: 'MSI GE66 Raider',
    brand: 'MSI',
    category: 'Laptop',
    price: 1999.99,
    image:
      'https://uyslfbwpmqbnobsnxsdl.supabase.co/storage/v1/object/public/tech-trove-data/product-images/msi-ge66-raider.webp',
    description:
      'The MSI GE66 Raider delivers a powerful punch with its high performance components and custom RGB lighting, making it a hit among gamers.',
    stock: 14,
    ratings: {
      average: 4.7,
      totalReviews: 110
    },
    features: [
      '15.6-inch FHD 240Hz display',
      'Latest-gen Intel Core i7/i9 processors',
      'NVIDIA GeForce RTX 3070/3080 GPU',
      'Up to 32GB RAM and 1TB NVMe SSD',
      'Panoramic Aurora lighting'
    ]
  },
  {
    name: 'Razer Blade Pro 17',
    brand: 'Razer',
    category: 'Laptop',
    price: 2599.99,
    image:
      'https://uyslfbwpmqbnobsnxsdl.supabase.co/storage/v1/object/public/tech-trove-data/product-images/razer-blade-pro-17.jpg',
    description:
      'The Razer Blade Pro 17 is a premium gaming laptop that offers a blend of portability, sleek design, and high-end performance for demanding users.',
    stock: 8,
    ratings: {
      average: 4.5,
      totalReviews: 45
    },
    features: [
      '17.3-inch FHD 360Hz or 4K Touch display',
      '8-Core 10th Gen Intel Core i7-10875H processor',
      'NVIDIA GeForce RTX 30 Series GPUs',
      'Up to 32GB DDR4 RAM and up to 1TB PCIe NVMe SSD',
      'Vapor Chamber Cooling System'
    ]
  },
  {
    name: 'HP Omen 15',
    brand: 'HP',
    category: 'Laptop',
    price: 1599.99,
    image:
      'https://uyslfbwpmqbnobsnxsdl.supabase.co/storage/v1/object/public/tech-trove-data/product-images/hp-omen-15.webp',
    description:
      'The HP Omen 15 is a well-rounded gaming laptop offering powerful specs, a sleek design, and a high refresh rate display for a smoother gaming experience.',
    stock: 16,
    ratings: {
      average: 4.5,
      totalReviews: 68
    },
    features: [
      '15.6-inch FHD (1920 x 1080) 300Hz IPS display',
      'AMD Ryzen 7 or Intel Core i7 processor options',
      'NVIDIA GeForce RTX 3070 GPU',
      'Up to 32GB DDR4 RAM and 1TB PCIe NVMe M.2 SSD',
      'OMEN Tempest Cooling Technology'
    ]
  },
  {
    name: 'Acer Predator Helios 300',
    brand: 'Acer',
    category: 'Laptop',
    price: 1299.99,
    image:
      'https://uyslfbwpmqbnobsnxsdl.supabase.co/storage/v1/object/public/tech-trove-data/product-images/acer-predator-helios-300.jpg',
    description:
      'The Acer Predator Helios 300 is a popular choice among gamers for its performance at a competitive price point, featuring customizable RGB lighting.',
    stock: 20,
    ratings: {
      average: 4.6,
      totalReviews: 95
    },
    features: [
      '15.6-inch FHD 240Hz 3ms display',
      '10th Gen Intel Core i7 processor',
      'NVIDIA GeForce RTX 2070 with Max-Q Design',
      '16GB DDR4 RAM and 512GB NVMe SSD',
      '4-Zone RGB Backlit Keyboard'
    ]
  },
  {
    name: 'Lenovo Legion 5 Pro',
    brand: 'Lenovo',
    category: 'Laptop',
    price: 1799.99,
    image:
      'https://uyslfbwpmqbnobsnxsdl.supabase.co/storage/v1/object/public/tech-trove-data/product-images/lenovo-legion-5-pro.webp',
    description:
      'The Lenovo Legion 5 Pro offers a superb balance between work and play, equipped with top-tier hardware and an impressive display with high resolution and refresh rate.',
    stock: 10,
    ratings: {
      average: 4.7,
      totalReviews: 78
    },
    features: [
      '16-inch QHD (2560 x 1600) 165Hz display',
      'AMD Ryzen 7 processors',
      'NVIDIA GeForce RTX 3060/3070 GPUs',
      'Up to 32 GB DDR4 RAM and up to 2 TB PCIe SSD',
      'Coldfront 3.0 cooling technology'
    ]
  },
  {
    name: 'Gigabyte AORUS 17G',
    brand: 'Gigabyte',
    category: 'Laptop',
    price: 2199.99,
    image:
      'https://uyslfbwpmqbnobsnxsdl.supabase.co/storage/v1/object/public/tech-trove-data/product-images/gigabyte-aorus-17g.webp',
    description:
      'The Gigabyte AORUS 17G stands out with its mechanical keyboard in a portable form factor, along with impressive specs designed for intense gaming sessions.',
    stock: 6,
    ratings: {
      average: 4.4,
      totalReviews: 52
    },
    features: [
      '17.3-inch FHD 300Hz display',
      '10th Gen Intel Core i7/i9 processors',
      'NVIDIA GeForce RTX 3080 GPU',
      '32GB RAM and 512GB PCIe SSD',
      'OMRON mechanical key switches'
    ]
  }
].map((productData) => new Product(productData))
