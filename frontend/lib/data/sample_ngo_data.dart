import '../models/ngo_model.dart';

/// Sample NGO data demonstrating all fields in the comprehensive dashboard
/// Use this as a reference for populating NGO data from your backend/database

NGO getSampleNGO() {
  return NGO(
    // Basic Information
    name: 'Hope Foundation',
    description:
        'A non-profit organization dedicated to improving the lives of underprivileged children through education, healthcare, and community development programs.',
    location: 'Mumbai, Maharashtra',
    logoUrl: 'https://via.placeholder.com/150',
    members: 250,
    followers: 5420,

    // Legal & Registration Information
    registrationNumber: 'MH/2010/0123456',
    fcraNumber: 'FCRA/231440046',
    darpanNumber: 'MH/2010/0123456',
    legalStatus: 'Registered under Section 8 Company',
    panNumber: 'AABTH1234F',
    tanNumber: 'MUMH12345E',
    ownerName: 'Dr. Rajesh Kumar',
    certificates: [
      '80G Certificate - Tax Exemption',
      '12A Registration Certificate',
      'FCRA Certificate',
      'CSR-1 Registration',
    ],
    annualReports: [
      AnnualReport(
        year: '2023-24',
        title: 'Annual Report FY 2023-24',
        reportUrl: 'https://example.com/reports/2023-24.pdf',
      ),
      AnnualReport(
        year: '2022-23',
        title: 'Annual Report FY 2022-23',
        reportUrl: 'https://example.com/reports/2022-23.pdf',
      ),
    ],

    // Mission & Objectives
    mission:
        'To empower underprivileged children and youth through quality education, healthcare, and livelihood opportunities, enabling them to break the cycle of poverty.',
    vision:
        'A society where every child has access to quality education and healthcare, regardless of their socio-economic background.',
    targetCommunities: [
      'Urban Slums',
      'Rural Villages',
      'Tribal Communities',
      'Children with Disabilities',
    ],
    projectTypes: [
      'Education',
      'Healthcare',
      'Skill Development',
      'Women Empowerment',
      'Child Rights',
    ],

    // Financial Transparency
    financialReports: [
      FinancialReport(
        year: '2023-24',
        totalRevenue: 15000000,
        totalExpenses: 14250000,
        reportUrl: 'https://example.com/financials/2023-24.pdf',
      ),
      FinancialReport(
        year: '2022-23',
        totalRevenue: 12500000,
        totalExpenses: 11800000,
        reportUrl: 'https://example.com/financials/2022-23.pdf',
      ),
    ],
    fundingSources: [
      'Individual Donations',
      'Corporate CSR Funding',
      'International Grants',
      'Government Schemes',
      'Fundraising Events',
    ],
    expenseBreakdown: ExpenseBreakdown(
      programCosts: 11400000,
      adminCosts: 1900000,
      fundraisingCosts: 950000,
    ),
    auditReports: [
      'Audit Report 2023-24 by M/s ABC & Associates',
      'Audit Report 2022-23 by M/s ABC & Associates',
    ],

    // Leadership & Governance
    boardMembers: [
      BoardMember(
        name: 'Dr. Rajesh Kumar',
        position: 'Chairman & Founder',
        background:
            'PhD in Social Work, 25+ years experience in development sector',
        photoUrl: 'https://via.placeholder.com/100',
      ),
      BoardMember(
        name: 'Ms. Priya Sharma',
        position: 'Managing Trustee',
        background: 'MBA, Former Corporate Executive, Child Rights Activist',
        photoUrl: 'https://via.placeholder.com/100',
      ),
      BoardMember(
        name: 'Mr. Anil Mehta',
        position: 'Treasurer',
        background: 'Chartered Accountant, 20 years in financial management',
        photoUrl: 'https://via.placeholder.com/100',
      ),
      BoardMember(
        name: 'Dr. Sneha Patel',
        position: 'Member - Healthcare',
        background: 'MBBS, MD Pediatrics, Healthcare specialist',
      ),
    ],
    governanceStructure:
        'The organization is governed by a Board of Trustees consisting of 7 members. The Board meets quarterly and oversees all strategic decisions, financial planning, and program implementation.',

    // Program Evidence & Impact
    projects: [
      Project(
        title: 'Education for All - Rural Schools Program',
        description:
            'Established 15 learning centers in rural areas providing quality education to 2000+ children who previously had no access to schools.',
        photos: [
          'https://via.placeholder.com/300x200',
          'https://via.placeholder.com/300x200',
          'https://via.placeholder.com/300x200',
        ],
        status: 'Ongoing',
        outcome:
            'Improved literacy rates by 65% in target communities, 90% student retention',
        startDate: DateTime(2021, 6, 1),
      ),
      Project(
        title: 'Mobile Healthcare Units',
        description:
            'Deployed 5 mobile healthcare units providing free medical checkups and treatments in remote villages.',
        photos: [
          'https://via.placeholder.com/300x200',
          'https://via.placeholder.com/300x200',
        ],
        status: 'Completed',
        outcome: 'Served 50,000+ patients, conducted 500+ health camps',
        startDate: DateTime(2020, 1, 15),
        endDate: DateTime(2023, 12, 31),
      ),
      Project(
        title: 'Women Skill Development Center',
        description:
            'Training center providing vocational skills to women from economically weaker sections.',
        photos: [
          'https://via.placeholder.com/300x200',
        ],
        status: 'Ongoing',
        outcome: '300+ women trained, 85% employment rate',
        startDate: DateTime(2022, 3, 1),
      ),
    ],
    testimonials: [
      'Hope Foundation changed my life. I can now read and write, and I dream of becoming a teacher. - Neha, Student',
      'The mobile healthcare unit saved my mother\'s life. We are eternally grateful. - Ramesh, Beneficiary',
      'After completing the skill training, I started my own tailoring business and can now support my family. - Sunita, Trainee',
    ],
    impactMetrics: ImpactMetrics(
      beneficiariesReached: 75000,
      projectsCompleted: 45,
      communitiesServed: 120,
      customMetrics: {
        'Children Educated': 8500,
        'Lives Saved': 1200,
        'Women Employed': 450,
      },
    ),

    // Public Reputation & Partnerships
    partnerships: [
      Partnership(
        organizationName: 'UNICEF India',
        description: 'Partnership for child education and nutrition programs',
        logoUrl: 'https://via.placeholder.com/80',
      ),
      Partnership(
        organizationName: 'Tata Trust',
        description: 'CSR funding for healthcare projects',
        logoUrl: 'https://via.placeholder.com/80',
      ),
      Partnership(
        organizationName: 'Ministry of Rural Development',
        description: 'Government collaboration for skill development',
      ),
    ],
    reviews: [
      Review(
        reviewerName: 'Amit Desai',
        rating: 5.0,
        comment:
            'Transparent operations and genuine impact. I have been donating for 3 years and seen their work firsthand.',
        date: DateTime(2024, 1, 15),
      ),
      Review(
        reviewerName: 'Kavita Singh',
        rating: 4.5,
        comment:
            'Great organization doing excellent work. Very responsive to queries.',
        date: DateTime(2024, 2, 20),
      ),
      Review(
        reviewerName: 'Rahul Verma',
        rating: 5.0,
        comment:
            'Visited their project site and was impressed by the dedication of their team.',
        date: DateTime(2023, 12, 10),
      ),
    ],
    rating: 4.8,
    mediaMentions: [
      'The Times of India - Hope Foundation receives National Award for Excellence',
      'NDTV - Making a Difference: Hope Foundation\'s Education Initiative',
      'Hindustan Times - How Hope Foundation is transforming rural healthcare',
    ],

    // Communication & Accessibility
    website: 'https://hopefoundation.org',
    email: 'contact@hopefoundation.org',
    phone: '+91-22-12345678',
    address:
        '123, Social Welfare Building, Andheri West, Mumbai, Maharashtra - 400058',
    socialMedia: {
      'Facebook': 'https://facebook.com/hopefoundation',
      'Twitter': 'https://twitter.com/hopefoundation',
      'Instagram': 'https://instagram.com/hopefoundation',
      'LinkedIn': 'https://linkedin.com/company/hopefoundation',
    },

    // Banking Information
    bankName: 'State Bank of India',
    bankAccountNumber: '12345678901234',
    ifscCode: 'SBIN0001234',
  );
}

/// Function to create multiple sample NGOs for testing
List<NGO> getSampleNGOList() {
  return [
    getSampleNGO(),
    NGO(
      name: 'Green Earth Initiative',
      description:
          'Environmental conservation organization working on reforestation and climate action.',
      location: 'Bangalore, Karnataka',
      logoUrl: 'https://via.placeholder.com/150',
      members: 180,
      followers: 3200,
      registrationNumber: 'KA/2015/0987654',
      legalStatus: 'Society Registration Act',
      mission:
          'To combat climate change through massive reforestation and community awareness programs.',
      rating: 4.6,
      website: 'https://greenearthinitiative.org',
      email: 'info@greenearthinitiative.org',
      phone: '+91-80-98765432',
    ),
    NGO(
      name: 'Animal Welfare Society',
      description:
          'Dedicated to rescuing and rehabilitating stray and injured animals.',
      location: 'Delhi, NCR',
      logoUrl: 'https://via.placeholder.com/150',
      members: 95,
      followers: 2800,
      registrationNumber: 'DL/2018/0567890',
      legalStatus: 'Trust',
      mission:
          'To provide shelter, medical care, and adoption services for abandoned animals.',
      rating: 4.7,
      website: 'https://animalwelfaresociety.org',
      email: 'help@animalwelfaresociety.org',
      phone: '+91-11-23456789',
    ),
  ];
}

/// Exported list variable for easy access
final sampleNGOs = getSampleNGOList();
