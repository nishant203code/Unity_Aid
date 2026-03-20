# NGO Comprehensive Dashboard

## Overview
The NGO Dashboard provides a detailed view of NGO information across 7 key categories to help users verify the authenticity and trustworthiness of NGOs before donating or engaging with them.

## Features

### 1. **Legal & Registration Information** ✅
Displays:
- Registration number and legal status
- PAN/TAN numbers
- Government certificates (80G, 12A, FCRA, etc.)
- Annual compliance reports

**Why it matters**: Proves the organization is legally registered and accountable.

### 2. **Mission & Objectives** ✅
Shows:
- Organization's mission and vision
- Target communities served
- Types of projects undertaken

**Why it matters**: Helps verify the NGO has clear, consistent goals (not vague or constantly changing).

### 3. **Financial Transparency** ✅
Includes:
- Annual financial reports
- Revenue and expense breakdown
- Funding sources
- Program vs Admin vs Fundraising cost percentages
- Audit reports

**Why it matters**: Demonstrates responsible use of donations with visual expense breakdown.

### 4. **Leadership & Governance** ✅
Displays:
- Board members/trustees with photos
- Leadership backgrounds
- Governance structure

**Why it matters**: Shows who is responsible for decisions and their qualifications.

### 5. **Program Evidence & Impact** ✅
Features:
- Detailed project information with photos
- Measurable outcomes and impact metrics
- Beneficiaries reached
- Projects completed
- Community testimonials

**Why it matters**: Provides proof of real-world impact, not just promises.

### 6. **Public Reputation & Partnerships** ✅
Shows:
- Partnerships with credible organizations
- Community reviews with ratings
- Media mentions and coverage

**Why it matters**: Independent validation builds trust through third-party verification.

### 7. **Communication & Accessibility** ✅
Provides:
- Website, email, phone, address
- Social media links
- Direct contact options (call, email, maps)

**Why it matters**: Genuine NGOs are accessible and responsive, not evasive.

## UI Components

### Header Section
- NGO logo and name
- Location
- Star rating (1-5)
- Key statistics (Members, Followers, Beneficiaries)

### Tabbed Interface
7 tabs for organized information:
1. Overview - Mission, vision, and summary
2. Legal - Registration and compliance documents
3. Financial - Transparent financial reports and breakdowns
4. Leadership - Board members and governance
5. Projects - Field work evidence with photos and outcomes
6. Partnerships - Collaborations and reviews
7. Contact - All communication channels

### Bottom Action Bar
- **Donate Button**: Primary call-to-action
- **Follow Button**: Allows users to follow NGO updates

## Usage

### Basic Example

```dart
import 'package:flutter/material.dart';
import 'package:unityaid/models/ngo_model.dart';
import 'package:unityaid/screens/ngo_search/ngo_detail_page.dart';

// Navigate to NGO detail page
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => NGODetailPage(ngo: myNGO),
  ),
);
```

### Creating NGO with Complete Data

```dart
NGO ngo = NGO(
  // Basic Info (Required)
  name: 'Hope Foundation',
  description: 'Organization description...',
  location: 'Mumbai, Maharashtra',
  logoUrl: 'https://example.com/logo.png',
  members: 250,
  followers: 5420,
  
  // Legal Info (Optional but recommended)
  registrationNumber: 'MH/2010/0123456',
  legalStatus: 'Section 8 Company',
  panNumber: 'AABTH1234F',
  tanNumber: 'MUMH12345E',
  
  // Mission (Optional but recommended)
  mission: 'Our mission statement...',
  vision: 'Our vision statement...',
  targetCommunities: ['Urban Slums', 'Rural Villages'],
  projectTypes: ['Education', 'Healthcare'],
  
  // Financial Data (Optional)
  expenseBreakdown: ExpenseBreakdown(
    programCosts: 11400000,
    adminCosts: 1900000,
    fundraisingCosts: 950000,
  ),
  
  // Leadership (Optional)
  boardMembers: [
    BoardMember(
      name: 'Dr. Rajesh Kumar',
      position: 'Chairman',
      background: 'PhD in Social Work...',
    ),
  ],
  
  // Impact Metrics (Optional)
  impactMetrics: ImpactMetrics(
    beneficiariesReached: 75000,
    projectsCompleted: 45,
    communitiesServed: 120,
  ),
  
  // Contact Info (Optional but recommended)
  website: 'https://hopefoundation.org',
  email: 'contact@hopefoundation.org',
  phone: '+91-22-12345678',
  address: '123, Mumbai, India',
  socialMedia: {
    'Facebook': 'https://facebook.com/hopefoundation',
    'Twitter': 'https://twitter.com/hopefoundation',
  },
);
```

### Sample Data
For testing and development, use the sample data:

```dart
import 'package:unityaid/data/sample_ngo_data.dart';

// Get a single sample NGO with all fields populated
NGO sampleNGO = getSampleNGO();

// Get multiple sample NGOs
List<NGO> sampleNGOs = getSampleNGOList();
```

## Data Model

### Main NGO Model
All fields are optional except the basic required fields (name, description, location, logoUrl, members, followers).

### Supporting Models
- `AnnualReport` - For compliance documents
- `FinancialReport` - For financial transparency
- `ExpenseBreakdown` - Automatic percentage calculations
- `BoardMember` - Leadership information
- `Project` - Program evidence with photos
- `ImpactMetrics` - Measurable outcomes
- `Partnership` - Collaborations
- `Review` - Community feedback

## Integration with Backend

When fetching NGO data from your backend:

1. **Minimal Data**: Provide at least basic info + 2-3 categories for listing
2. **Detailed View**: Load all available data when user clicks on NGO
3. **Lazy Loading**: Consider loading heavy data (photos, documents) on-demand
4. **Verification Badge**: Add a `verified` boolean field to highlight verified NGOs

### Recommended Backend Structure
```json
{
  "id": "ngo123",
  "name": "Hope Foundation",
  "basic_info": { ... },
  "legal_info": { ... },
  "financial_data": { ... },
  "leadership": { ... },
  "projects": [ ... ],
  "partnerships": [ ... ],
  "contact_info": { ... },
  "verified": true,
  "verification_date": "2024-01-15"
}
```

## Trust Indicators

The dashboard automatically highlights trust signals:
- ✅ Green checkmarks for completed sections
- ⭐ Star ratings from community reviews
- 📊 Visual expense breakdown showing program efficiency
- 📜 Downloadable certificates and reports
- 🤝 Partnerships with credible organizations
- 💬 Real testimonials from beneficiaries

## Red Flags to Check

The dashboard helps identify warning signs:
- ❌ Missing registration or legal information
- ❌ No financial transparency
- ❌ Vague or constantly changing mission
- ❌ No leadership information
- ❌ No proof of impact or projects
- ❌ No contact information or unresponsive
- ❌ No partnerships or independent validation

## Customization

### Theme Colors
The dashboard uses Material Theme colors. Customize in your theme:
```dart
ThemeData(
  primaryColor: Colors.blue,
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
)
```

### Tab Order
Modify tab order in the `_buildTabSections()` method.

### Action Buttons
Update bottom bar actions in `_buildBottomBar()` to navigate to your donate/follow pages.

## Dependencies

Required package:
```yaml
dependencies:
  url_launcher: ^6.2.1  # For opening links
```

Already installed in your pubspec.yaml.

## Future Enhancements

Consider adding:
- [ ] Document viewer for certificates/reports
- [ ] Photo gallery for project images
- [ ] Map view for NGO location
- [ ] Share NGO profile feature
- [ ] Bookmark/favorite functionality
- [ ] Report/flag suspicious NGOs
- [ ] Compare multiple NGOs side-by-side
- [ ] Filter NGOs by verification status
