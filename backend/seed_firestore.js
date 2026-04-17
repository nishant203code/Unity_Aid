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
    description:
      "Providing disaster relief and emergency aid across India since 2005. We focus on rapid response, rehabilitation, and long-term community resilience building in disaster-prone regions.",
    location: "Delhi",
    latitude: 28.6139,
    longitude: 77.209,
    logoUrl: "https://i.pravatar.cc/150?img=10",
    members: 320,
    followers: 12400,
    ownerName: "Dr. Amit Kapoor",
    mission:
      "To provide immediate relief to disaster-affected communities and build long-term resilience through preparedness programs.",
    vision:
      "A world where every community is prepared for and resilient against natural disasters.",
    website: "https://carefoundation.org",
    email: "contact@carefoundation.org",
    phone: "+91-11-23456789",
    address: "45, Safdarjung Enclave, New Delhi - 110029",
    rating: 4.5,
    registrationNumber: "DL/2005/0045678",
    darpanNumber: "DL/2005/0045678",
    legalStatus: "Section 8 Company",
    panNumber: "AABCC1234D",
    tanNumber: "DELC12345E",
    bankName: "HDFC Bank",
    bankAccountNumber: "50100123456789",
    ifscCode: "HDFC0001234",
    certificates: [
      "80G Certificate",
      "12A Registration",
      "FCRA Certificate",
      "CSR-1 Registration",
    ],
    targetCommunities: [
      "Flood-affected regions",
      "Earthquake-prone areas",
      "Coastal communities",
    ],
    projectTypes: [
      "Disaster Relief",
      "Emergency Response",
      "Community Resilience",
      "Rehabilitation",
    ],
    socialMedia: {
      facebook: "https://facebook.com/carefoundation",
      twitter: "https://twitter.com/carefoundation",
      instagram: "https://instagram.com/carefoundation",
    },
    impactMetrics: {
      beneficiariesReached: 250000,
      projectsCompleted: 85,
      communitiesServed: 340,
    },
    expenseBreakdown: {
      programCosts: 18500000,
      adminCosts: 2800000,
      fundraisingCosts: 1200000,
    },
  },
  {
    name: "HopeWorks",
    description:
      "Helping underprivileged communities thrive through education, healthcare, and livelihood programs across Western India.",
    location: "Mumbai",
    latitude: 19.076,
    longitude: 72.8777,
    logoUrl: "https://i.pravatar.cc/150?img=11",
    members: 180,
    followers: 7200,
    ownerName: "Sunita Rao",
    mission:
      "Empowering communities through sustainable development, quality education, and accessible healthcare.",
    vision:
      "An India where no community is left behind in the march towards progress.",
    website: "https://hopeworks.in",
    email: "hello@hopeworks.in",
    phone: "+91-22-34567890",
    address: "12, Bandra West, Linking Road, Mumbai - 400050",
    rating: 4.2,
    registrationNumber: "MH/2012/0098765",
    darpanNumber: "MH/2012/0098765",
    legalStatus: "Trust",
    panNumber: "AABTH5678F",
    bankName: "ICICI Bank",
    bankAccountNumber: "123456789012",
    ifscCode: "ICIC0001234",
    certificates: ["80G Certificate", "12A Registration"],
    targetCommunities: [
      "Urban Slums",
      "Migrant Workers",
      "Women-headed households",
    ],
    projectTypes: [
      "Education",
      "Healthcare",
      "Livelihood",
      "Women Empowerment",
    ],
    socialMedia: {
      facebook: "https://facebook.com/hopeworks",
      instagram: "https://instagram.com/hopeworks",
    },
    impactMetrics: {
      beneficiariesReached: 85000,
      projectsCompleted: 42,
      communitiesServed: 120,
    },
    expenseBreakdown: {
      programCosts: 9500000,
      adminCosts: 1500000,
      fundraisingCosts: 800000,
    },
  },
  {
    name: "Green Earth Alliance",
    description:
      "Environmental conservation and sustainable living advocacy. Working on reforestation, clean water projects, and urban green spaces across South India.",
    location: "Bangalore",
    latitude: 12.9716,
    longitude: 77.5946,
    logoUrl: "https://i.pravatar.cc/150?img=13",
    members: 250,
    followers: 15100,
    ownerName: "Rajesh Kumar",
    mission:
      "Building a sustainable future for all through environmental conservation, community action, and policy advocacy.",
    vision:
      "A planet where humans and nature coexist in harmony for generations to come.",
    website: "https://greenearthalliance.org",
    email: "info@greenearthalliance.org",
    phone: "+91-80-45678901",
    address: "78, Koramangala 4th Block, Bangalore - 560034",
    rating: 4.7,
    registrationNumber: "KA/2010/0567890",
    fcraNumber: "FCRA/091234567",
    darpanNumber: "KA/2010/0567890",
    legalStatus: "Society",
    panNumber: "AAACG9012H",
    tanNumber: "BLRG56789D",
    bankName: "State Bank of India",
    bankAccountNumber: "30987654321",
    ifscCode: "SBIN0005678",
    certificates: [
      "80G Certificate",
      "12A Registration",
      "FCRA Certificate",
      "ISO 14001 Environmental Management",
    ],
    targetCommunities: [
      "Rural Farmers",
      "Urban Communities",
      "Tribal Regions",
      "Coastal Ecosystems",
    ],
    projectTypes: [
      "Reforestation",
      "Clean Water",
      "Waste Management",
      "Solar Energy",
      "Environmental Education",
    ],
    socialMedia: {
      facebook: "https://facebook.com/greenearthalliance",
      twitter: "https://twitter.com/greenearthalliance",
      instagram: "https://instagram.com/greenearthalliance",
      linkedin: "https://linkedin.com/company/greenearthalliance",
    },
    impactMetrics: {
      beneficiariesReached: 180000,
      projectsCompleted: 68,
      communitiesServed: 200,
    },
    expenseBreakdown: {
      programCosts: 14000000,
      adminCosts: 2000000,
      fundraisingCosts: 1000000,
    },
  },
  {
    name: "Children First Foundation",
    description:
      "Dedicated to child welfare, education, and protection. Running schools and shelters in 12 states across India, providing safe spaces for over 5,000 children.",
    location: "Chennai",
    latitude: 13.0827,
    longitude: 80.2707,
    logoUrl: "https://i.pravatar.cc/150?img=14",
    members: 210,
    followers: 9800,
    ownerName: "Lakshmi Narayanan",
    mission:
      "Every child deserves a bright future — we provide education, shelter, and care to India's most vulnerable children.",
    vision:
      "A society where every child grows up safe, educated, and empowered to reach their full potential.",
    website: "https://childrenfirst.org",
    email: "support@childrenfirst.org",
    phone: "+91-44-56789012",
    address: "23, Anna Nagar, Chennai - 600040",
    rating: 4.8,
    registrationNumber: "TN/2008/0345678",
    darpanNumber: "TN/2008/0345678",
    legalStatus: "Trust",
    panNumber: "AABCC4567G",
    bankName: "Axis Bank",
    bankAccountNumber: "920010012345678",
    ifscCode: "UTIB0002345",
    certificates: [
      "80G Certificate",
      "12A Registration",
      "CARA Accreditation",
      "Child Welfare Committee Recognition",
    ],
    targetCommunities: [
      "Street Children",
      "Child Laborers",
      "Orphaned Children",
      "Children with Disabilities",
    ],
    projectTypes: [
      "Child Education",
      "Child Protection",
      "Shelter Homes",
      "Nutrition Programs",
      "Adoption Services",
    ],
    socialMedia: {
      facebook: "https://facebook.com/childrenfirst",
      twitter: "https://twitter.com/childrenfirst",
      instagram: "https://instagram.com/childrenfirst",
    },
    impactMetrics: {
      beneficiariesReached: 52000,
      projectsCompleted: 35,
      communitiesServed: 95,
    },
    expenseBreakdown: {
      programCosts: 12000000,
      adminCosts: 1800000,
      fundraisingCosts: 900000,
    },
  },
  {
    name: "Shakti Women's Collective",
    description:
      "Empowering women across rural India through skill development, microfinance, legal aid, and leadership training programs.",
    location: "Jaipur",
    latitude: 26.9124,
    longitude: 75.7873,
    logoUrl: "https://i.pravatar.cc/150?img=16",
    members: 140,
    followers: 6100,
    ownerName: "Rekha Sharma",
    mission:
      "To empower every woman with the skills, resources, and confidence to lead an independent and dignified life.",
    vision:
      "An India where women are equal partners in every sphere of life — economic, social, and political.",
    website: "https://shaktiwomen.org",
    email: "info@shaktiwomen.org",
    phone: "+91-141-2345678",
    address: "56, Vaishali Nagar, Jaipur - 302021",
    rating: 4.6,
    registrationNumber: "RJ/2014/0234567",
    darpanNumber: "RJ/2014/0234567",
    legalStatus: "Society",
    panNumber: "AAWCS6789J",
    bankName: "Bank of Baroda",
    bankAccountNumber: "45678901234",
    ifscCode: "BARB0JAIPUR",
    certificates: ["80G Certificate", "12A Registration", "NITI Aayog Listed"],
    targetCommunities: [
      "Rural Women",
      "Domestic Violence Survivors",
      "Single Mothers",
      "Tribal Women",
    ],
    projectTypes: [
      "Skill Development",
      "Microfinance",
      "Legal Aid",
      "Leadership Training",
      "Women's Health",
    ],
    socialMedia: {
      facebook: "https://facebook.com/shaktiwomen",
      instagram: "https://instagram.com/shaktiwomen",
    },
    impactMetrics: {
      beneficiariesReached: 35000,
      projectsCompleted: 28,
      communitiesServed: 75,
    },
    expenseBreakdown: {
      programCosts: 7500000,
      adminCosts: 1200000,
      fundraisingCosts: 600000,
    },
  },
  {
    name: "Pawsitive India",
    description:
      "Animal rescue, rehabilitation, and adoption organization operating shelters in 5 major cities. We also run awareness campaigns against animal cruelty.",
    location: "Pune",
    latitude: 18.5204,
    longitude: 73.8567,
    logoUrl: "https://i.pravatar.cc/150?img=17",
    members: 95,
    followers: 11500,
    ownerName: "Dr. Vikram Desai",
    mission:
      "To rescue, rehabilitate, and rehome abandoned and injured animals while promoting compassion and responsible pet ownership.",
    vision:
      "A cruelty-free India where every animal is treated with dignity and compassion.",
    website: "https://pawsitiveindia.org",
    email: "rescue@pawsitiveindia.org",
    phone: "+91-20-67890123",
    address: "102, Kothrud, Pune - 411038",
    rating: 4.9,
    registrationNumber: "MH/2016/0789012",
    darpanNumber: "MH/2016/0789012",
    legalStatus: "Trust",
    panNumber: "AABCP3456K",
    bankName: "Kotak Mahindra Bank",
    bankAccountNumber: "78901234567",
    ifscCode: "KKBK0001234",
    certificates: [
      "Animal Welfare Board Registration",
      "80G Certificate",
      "12A Registration",
    ],
    targetCommunities: [
      "Stray Animals",
      "Injured Wildlife",
      "Abandoned Pets",
      "Urban Communities",
    ],
    projectTypes: [
      "Animal Rescue",
      "Shelter Management",
      "Sterilization Drives",
      "Adoption Services",
      "Anti-Cruelty Campaigns",
    ],
    socialMedia: {
      facebook: "https://facebook.com/pawsitiveindia",
      twitter: "https://twitter.com/pawsitiveindia",
      instagram: "https://instagram.com/pawsitiveindia",
    },
    impactMetrics: {
      beneficiariesReached: 45000,
      projectsCompleted: 120,
      communitiesServed: 40,
    },
    expenseBreakdown: {
      programCosts: 5500000,
      adminCosts: 900000,
      fundraisingCosts: 400000,
    },
  },
  {
    name: "Aarogya Health Mission",
    description:
      "Bringing affordable healthcare to rural and tribal communities through mobile clinics, telemedicine, mental health awareness, and preventive care programs.",
    location: "Hyderabad",
    latitude: 17.385,
    longitude: 78.4867,
    logoUrl: "https://i.pravatar.cc/150?img=18",
    members: 175,
    followers: 8900,
    ownerName: "Dr. Sanjay Reddy",
    mission:
      "To bridge the healthcare gap in underserved communities by providing affordable, accessible, and quality medical services.",
    vision:
      "An India where quality healthcare is a fundamental right, not a privilege.",
    website: "https://aarogyamission.org",
    email: "health@aarogyamission.org",
    phone: "+91-40-78901234",
    address: "34, Jubilee Hills, Hyderabad - 500033",
    rating: 4.4,
    registrationNumber: "TS/2011/0456789",
    fcraNumber: "FCRA/071234568",
    darpanNumber: "TS/2011/0456789",
    legalStatus: "Section 8 Company",
    panNumber: "AABCA7890L",
    tanNumber: "HYDA23456F",
    bankName: "Punjab National Bank",
    bankAccountNumber: "12345678901",
    ifscCode: "PUNB0123400",
    certificates: [
      "80G Certificate",
      "12A Registration",
      "FCRA Certificate",
      "WHO Partnership Certificate",
    ],
    targetCommunities: [
      "Tribal Communities",
      "Rural Villages",
      "Urban Slum Dwellers",
      "Migrant Workers",
    ],
    projectTypes: [
      "Mobile Clinics",
      "Telemedicine",
      "Mental Health",
      "Preventive Care",
      "Maternal Health",
    ],
    socialMedia: {
      facebook: "https://facebook.com/aarogyamission",
      twitter: "https://twitter.com/aarogyamission",
      instagram: "https://instagram.com/aarogyamission",
      linkedin: "https://linkedin.com/company/aarogyamission",
    },
    impactMetrics: {
      beneficiariesReached: 150000,
      projectsCompleted: 55,
      communitiesServed: 180,
    },
    expenseBreakdown: {
      programCosts: 16000000,
      adminCosts: 2500000,
      fundraisingCosts: 1100000,
    },
  },
  {
    name: "Silver Years Foundation",
    description:
      "Dedicated to elderly care and welfare, running old age homes, medical support programs, and companionship drives for senior citizens across North India.",
    location: "Lucknow",
    latitude: 26.8467,
    longitude: 80.9462,
    logoUrl: "https://i.pravatar.cc/150?img=19",
    members: 85,
    followers: 3800,
    ownerName: "Anand Mishra",
    mission:
      "To ensure every senior citizen lives their golden years with dignity, care, and companionship.",
    vision:
      "A society that honors and cares for its elders, ensuring no senior is ever abandoned or neglected.",
    website: "https://silveryears.org",
    email: "care@silveryears.org",
    phone: "+91-522-3456789",
    address: "89, Gomti Nagar, Lucknow - 226010",
    rating: 4.3,
    registrationNumber: "UP/2017/0567890",
    darpanNumber: "UP/2017/0567890",
    legalStatus: "Trust",
    panNumber: "AABSF2345M",
    bankName: "Union Bank of India",
    bankAccountNumber: "56789012345",
    ifscCode: "UBIN0534567",
    certificates: ["80G Certificate", "12A Registration"],
    targetCommunities: [
      "Abandoned Elderly",
      "Senior Citizens Below Poverty Line",
      "Elderly with Chronic Illness",
    ],
    projectTypes: [
      "Old Age Homes",
      "Medical Support",
      "Companionship Drives",
      "Elder Rights Advocacy",
      "Geriatric Care Training",
    ],
    socialMedia: {
      facebook: "https://facebook.com/silveryears",
      instagram: "https://instagram.com/silveryears",
    },
    impactMetrics: {
      beneficiariesReached: 12000,
      projectsCompleted: 18,
      communitiesServed: 35,
    },
    expenseBreakdown: {
      programCosts: 4500000,
      adminCosts: 800000,
      fundraisingCosts: 350000,
    },
  },
  {
    name: "Gram Vikas Rural Development",
    description:
      "Transforming rural India through sustainable agriculture, clean energy, water management, and village-level infrastructure development programs.",
    location: "Bhopal",
    latitude: 23.2599,
    longitude: 77.4126,
    logoUrl: "https://i.pravatar.cc/150?img=20",
    members: 300,
    followers: 7600,
    ownerName: "Mohan Patel",
    mission:
      "To uplift rural communities through integrated development programs that are sustainable, scalable, and community-driven.",
    vision:
      "Thriving, self-reliant rural communities that are engines of India's growth story.",
    website: "https://gramvikas.org",
    email: "info@gramvikas.org",
    phone: "+91-755-4567890",
    address: "12, Arera Colony, Bhopal - 462016",
    rating: 4.5,
    registrationNumber: "MP/2009/0678901",
    fcraNumber: "FCRA/061234569",
    darpanNumber: "MP/2009/0678901",
    legalStatus: "Society",
    panNumber: "AAACG5678N",
    tanNumber: "BPLG34567G",
    bankName: "Central Bank of India",
    bankAccountNumber: "34567890123",
    ifscCode: "CBIN0280123",
    certificates: [
      "80G Certificate",
      "12A Registration",
      "FCRA Certificate",
      "NABARD Partnership",
    ],
    targetCommunities: [
      "Marginal Farmers",
      "Landless Laborers",
      "Tribal Villages",
      "Women Self-Help Groups",
    ],
    projectTypes: [
      "Sustainable Agriculture",
      "Clean Energy",
      "Water Management",
      "Rural Infrastructure",
      "Farmer Training",
    ],
    socialMedia: {
      facebook: "https://facebook.com/gramvikas",
      twitter: "https://twitter.com/gramvikas",
      linkedin: "https://linkedin.com/company/gramvikas",
    },
    impactMetrics: {
      beneficiariesReached: 200000,
      projectsCompleted: 92,
      communitiesServed: 450,
    },
    expenseBreakdown: {
      programCosts: 22000000,
      adminCosts: 3200000,
      fundraisingCosts: 1500000,
    },
  },
  {
    name: "DigiShiksha Foundation",
    description:
      "Bridging the digital divide through computer literacy centers, coding bootcamps for underprivileged youth, and technology access programs in Tier-2 and Tier-3 cities.",
    location: "Kolkata",
    latitude: 22.5726,
    longitude: 88.3639,
    logoUrl: "https://i.pravatar.cc/150?img=21",
    members: 110,
    followers: 5200,
    ownerName: "Arjun Banerjee",
    mission:
      "To empower India's next generation with digital skills and technology access, ensuring no young person is left behind in the digital era.",
    vision:
      "A digitally literate India where every young person has the skills to thrive in the 21st century economy.",
    website: "https://digishiksha.org",
    email: "learn@digishiksha.org",
    phone: "+91-33-5678901",
    address: "67, Salt Lake Sector V, Kolkata - 700091",
    rating: 4.6,
    registrationNumber: "WB/2019/0890123",
    darpanNumber: "WB/2019/0890123",
    legalStatus: "Section 8 Company",
    panNumber: "AABCD1234P",
    bankName: "Yes Bank",
    bankAccountNumber: "89012345678",
    ifscCode: "YESB0000123",
    certificates: [
      "80G Certificate",
      "12A Registration",
      "NASSCOM Social Innovation Partner",
    ],
    targetCommunities: [
      "Underprivileged Youth",
      "Government School Students",
      "Rural Youth",
      "First-generation Learners",
    ],
    projectTypes: [
      "Digital Literacy",
      "Coding Bootcamps",
      "Computer Labs",
      "STEM Education",
      "Online Learning Platforms",
    ],
    socialMedia: {
      facebook: "https://facebook.com/digishiksha",
      twitter: "https://twitter.com/digishiksha",
      instagram: "https://instagram.com/digishiksha",
      linkedin: "https://linkedin.com/company/digishiksha",
    },
    impactMetrics: {
      beneficiariesReached: 28000,
      projectsCompleted: 22,
      communitiesServed: 60,
    },
    expenseBreakdown: {
      programCosts: 6000000,
      adminCosts: 1000000,
      fundraisingCosts: 500000,
    },
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
