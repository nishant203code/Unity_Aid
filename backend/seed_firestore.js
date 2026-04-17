/**
 * Seed script for UnityAid Firestore Emulator.
 * Populates the emulator with sample posts, NGOs, and donation cases.
 *
 * Usage:
 *   1. Start the emulator:  firebase emulators:start
 *   2. Run this script:     node seed_firestore.js
 */

const { initializeApp } = require("firebase-admin/app");
const { getFirestore } = require("firebase-admin/firestore");

// Connect to the Firestore emulator
process.env.FIRESTORE_EMULATOR_HOST = "127.0.0.1:8080";

const app = initializeApp({ projectId: "unity-aid-e8db3" });
const db = getFirestore(app);

// ─── Sample Posts ───
const samplePosts = [
  {
    userName: "Rahul Sharma",
    creatorName: "Rahul Sharma",
    profilePic: "https://i.pravatar.cc/150?img=5",
    location: "Delhi",
    mediaUrls: [
      "https://images.unsplash.com/photo-1627398242454-45a1465c2479",
      "https://images.unsplash.com/photo-1593113598332-cd288d649433",
    ],
    title: "Car Accident Emergency",
    caseId: "UA10234",
    description:
      "Met with a severe accident last night. Need urgent financial help for surgeries. Family is in distress and medical bills are mounting rapidly.",
    raised: 25000,
    fundGoal: 50000,
    status: "active",
    createdBy: "seed_user_1",
    creatorEmail: "rahul@example.com",
    issueType: "personal",
    victimName: "Rahul Sharma",
    createdAt: new Date(),
  },
  {
    userName: "Anita Verma",
    creatorName: "Anita Verma",
    profilePic: "https://i.pravatar.cc/150?img=8",
    location: "Mumbai",
    mediaUrls: [
      "https://images.unsplash.com/photo-1593113598332-cd288d649433",
    ],
    title: "House Fire Relief",
    caseId: "UA10290",
    description:
      "Lost our home in a fire accident. Any support would mean the world to us. Our family of five is now homeless and needs immediate help.",
    raised: 40000,
    fundGoal: 80000,
    status: "rejected",
    createdBy: "seed_user_2",
    creatorEmail: "anita@example.com",
    issueType: "personal",
    victimName: "Anita Verma",
    createdAt: new Date(Date.now() - 86400000), // 1 day ago
  },
  {
    userName: "Suresh Patel",
    creatorName: "Suresh Patel",
    profilePic: "https://i.pravatar.cc/150?img=12",
    location: "Ahmedabad",
    mediaUrls: [
      "https://images.unsplash.com/photo-1579684385127-1ef15d508118",
    ],
    title: "Cancer Treatment Support",
    caseId: "UA10301",
    description:
      "Fighting stage 3 cancer and need help covering treatment costs. Every contribution matters. Treatment is ongoing at a top hospital.",
    raised: 73000,
    fundGoal: 150000,
    status: "active",
    createdBy: "seed_user_3",
    creatorEmail: "suresh@example.com",
    issueType: "personal",
    victimName: "Suresh Patel",
    createdAt: new Date(Date.now() - 172800000), // 2 days ago
  },
  {
    userName: "Priya Mehta",
    creatorName: "Priya Mehta",
    profilePic: "https://i.pravatar.cc/150?img=15",
    location: "Bangalore",
    mediaUrls: [
      "https://images.unsplash.com/photo-1594708767771-a7502209ff7e",
    ],
    title: "Flood Relief Campaign",
    caseId: "UA10315",
    description:
      "Massive floods have displaced thousands in rural Karnataka. We are collecting funds to provide food, shelter, and medical supplies to affected families.",
    raised: 120000,
    fundGoal: 500000,
    status: "active",
    createdBy: "seed_user_4",
    creatorEmail: "priya@example.com",
    issueType: "social",
    contactPerson: "Priya Mehta",
    createdAt: new Date(Date.now() - 43200000), // 12 hours ago
  },
];

// ─── Sample NGOs ───
const sampleNGOs = [
  {
    name: "Care Foundation",
    description: "Providing disaster relief and emergency aid across India since 2005. We focus on rapid response and rehabilitation.",
    location: "Delhi",
    latitude: 28.6139,
    longitude: 77.209,
    logoUrl: "https://i.pravatar.cc/150?img=10",
    members: 120,
    followers: 5400,
    ownerName: "Dr. Amit Kapoor",
    mission: "To provide immediate relief to disaster-affected communities",
    website: "https://carefoundation.org",
    email: "contact@carefoundation.org",
    phone: "+91-11-23456789",
    rating: 4.5,
  },
  {
    name: "HopeWorks",
    description: "Helping underprivileged communities thrive through education, healthcare, and livelihood programs.",
    location: "Mumbai",
    latitude: 19.076,
    longitude: 72.8777,
    logoUrl: "https://i.pravatar.cc/150?img=11",
    members: 80,
    followers: 3200,
    ownerName: "Sunita Rao",
    mission: "Empowering communities through sustainable development",
    website: "https://hopeworks.in",
    email: "hello@hopeworks.in",
    phone: "+91-22-34567890",
    rating: 4.2,
  },
  {
    name: "Green Earth Alliance",
    description: "Environmental conservation and sustainable living advocacy. Working on reforestation and clean water projects.",
    location: "Bangalore",
    latitude: 12.9716,
    longitude: 77.5946,
    logoUrl: "https://i.pravatar.cc/150?img=13",
    members: 200,
    followers: 8100,
    ownerName: "Rajesh Kumar",
    mission: "Building a sustainable future for all",
    website: "https://greenearthalliance.org",
    email: "info@greenearthalliance.org",
    phone: "+91-80-45678901",
    rating: 4.7,
  },
  {
    name: "Children First Foundation",
    description: "Dedicated to child welfare, education, and protection. Running schools and shelters in 12 states.",
    location: "Chennai",
    latitude: 13.0827,
    longitude: 80.2707,
    logoUrl: "https://i.pravatar.cc/150?img=14",
    members: 150,
    followers: 6300,
    ownerName: "Lakshmi Narayanan",
    mission: "Every child deserves a bright future",
    email: "support@childrenfirst.org",
    rating: 4.8,
  },
];

// ─── Sample Donation Cases ───
const sampleDonationCases = [
  {
    title: "Emergency Heart Surgery for Ram",
    shortDescription: "8-year-old Ram needs urgent heart surgery",
    fullDescription:
      "Ram, an 8-year-old from rural Bihar, was diagnosed with a congenital heart defect. His family cannot afford the surgery. We need your help to save his life.",
    category: "Medical Emergency",
    location: "Patna, Bihar",
    imageUrl: "https://images.unsplash.com/photo-1579684385127-1ef15d508118",
    targetAmount: 500000,
    raisedAmount: 175000,
    deadline: new Date(Date.now() + 30 * 86400000),
    urgencyLevel: "Critical",
    beneficiaryName: "Ram Kumar",
    beneficiaryAge: 8,
    beneficiaryGender: "Male",
    caseStory:
      "Ram was born with a hole in his heart. His parents are daily wage laborers who earn barely enough to feed the family.",
    requirements: ["Surgery cost", "Post-op medications", "Hospital stay"],
    currentStatus: "Active",
    handlingNGO: "Care Foundation",
    isVerified: true,
    supportersCount: 45,
    createdDate: new Date(Date.now() - 5 * 86400000),
  },
  {
    title: "School for Tribal Children",
    shortDescription: "Building a school for 200 tribal children in Jharkhand",
    fullDescription:
      "200 children in a remote tribal village in Jharkhand have no access to education. We aim to build a primary school with proper facilities.",
    category: "Education",
    location: "Ranchi, Jharkhand",
    imageUrl: "https://images.unsplash.com/photo-1594708767771-a7502209ff7e",
    targetAmount: 800000,
    raisedAmount: 320000,
    deadline: new Date(Date.now() + 60 * 86400000),
    urgencyLevel: "High",
    beneficiaryName: "Tribal Community",
    caseStory:
      "The nearest school is 15 km away. Children walk hours daily or simply don't attend school.",
    requirements: [
      "Land acquisition",
      "Construction materials",
      "Teachers' salary",
      "Books and supplies",
    ],
    currentStatus: "Active",
    handlingNGO: "Children First Foundation",
    isVerified: true,
    supportersCount: 120,
    createdDate: new Date(Date.now() - 10 * 86400000),
  },
  {
    title: "Flood Relief in Karnataka",
    shortDescription: "Emergency relief for flood-affected families",
    fullDescription:
      "Severe floods have displaced over 5,000 families in North Karnataka. Immediate relief in the form of food, water, and temporary shelters is needed.",
    category: "Disaster Relief",
    location: "Belagavi, Karnataka",
    imageUrl: "https://images.unsplash.com/photo-1593113598332-cd288d649433",
    targetAmount: 1000000,
    raisedAmount: 650000,
    deadline: new Date(Date.now() + 15 * 86400000),
    urgencyLevel: "Critical",
    beneficiaryName: "Flood-affected Communities",
    caseStory:
      "The worst floods in 50 years have destroyed homes, crops, and livelihoods. Families are in makeshift camps with limited food and clean water.",
    requirements: [
      "Food packets",
      "Clean drinking water",
      "Temporary shelters",
      "Medical supplies",
    ],
    currentStatus: "Active",
    handlingNGO: "Care Foundation",
    isVerified: true,
    supportersCount: 230,
    createdDate: new Date(Date.now() - 3 * 86400000),
  },
  {
    title: "Cancer Treatment for Meera",
    shortDescription: "Single mother fighting breast cancer needs help",
    fullDescription:
      "Meera, a 35-year-old single mother of two, has been diagnosed with stage 2 breast cancer. She needs chemotherapy and surgery.",
    category: "Medical Aid",
    location: "Jaipur, Rajasthan",
    imageUrl: "https://images.unsplash.com/photo-1559757175-7cb057fba93c",
    targetAmount: 400000,
    raisedAmount: 90000,
    deadline: new Date(Date.now() + 45 * 86400000),
    urgencyLevel: "High",
    beneficiaryName: "Meera Devi",
    beneficiaryAge: 35,
    beneficiaryGender: "Female",
    caseStory:
      "Meera lost her husband two years ago and has been raising her children alone. Now she faces a cancer diagnosis with no family support.",
    requirements: [
      "Chemotherapy sessions",
      "Surgery costs",
      "Childcare during treatment",
    ],
    currentStatus: "Active",
    handlingNGO: "HopeWorks",
    isVerified: true,
    supportersCount: 67,
    createdDate: new Date(Date.now() - 7 * 86400000),
  },
  {
    title: "Community Water Purification System",
    shortDescription: "Clean drinking water for 3 villages",
    fullDescription:
      "Three villages in rural MP have been drinking contaminated water for years, leading to widespread waterborne diseases. A purification system will serve 2,000+ people.",
    category: "Community Development",
    location: "Bhopal, Madhya Pradesh",
    imageUrl: "https://images.unsplash.com/photo-1594708767771-a7502209ff7e",
    targetAmount: 300000,
    raisedAmount: 180000,
    deadline: new Date(Date.now() + 40 * 86400000),
    urgencyLevel: "Medium",
    beneficiaryName: "Rural Communities",
    caseStory:
      "Water-borne diseases account for 60% of health issues in these villages. A proper purification system will transform lives.",
    requirements: [
      "Water purification unit",
      "Pipeline installation",
      "Maintenance training",
    ],
    currentStatus: "Active",
    handlingNGO: "Green Earth Alliance",
    isVerified: true,
    supportersCount: 89,
    createdDate: new Date(Date.now() - 14 * 86400000),
  },
];

// ═══════════════════════════════════════════════
//  SEED FUNCTION
// ═══════════════════════════════════════════════

async function seed() {
  console.log("🌱 Seeding Firestore emulator...\n");

  // ── Posts ──
  console.log(`  📝 Seeding ${samplePosts.length} posts...`);
  for (const post of samplePosts) {
    await db.collection("posts").add(post);
  }
  console.log("     ✅ Posts seeded\n");

  // ── NGOs ──
  console.log(`  🏢 Seeding ${sampleNGOs.length} NGOs...`);
  for (const ngo of sampleNGOs) {
    await db.collection("ngos").add(ngo);
  }
  console.log("     ✅ NGOs seeded\n");

  // ── Donation Cases ──
  console.log(`  💰 Seeding ${sampleDonationCases.length} donation cases...`);
  for (const donationCase of sampleDonationCases) {
    await db.collection("donation_cases").add(donationCase);
  }
  console.log("     ✅ Donation cases seeded\n");

  console.log("🎉 Seeding complete! Data is ready in the emulator.");
  process.exit(0);
}

seed().catch((err) => {
  console.error("❌ Seeding failed:", err);
  process.exit(1);
});
