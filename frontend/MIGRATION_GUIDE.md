## Migration Guide: Basic to Comprehensive NGO Data

This guide shows how to gradually enhance your NGO data from basic information to the comprehensive dashboard format.

### Current Basic Format (Minimal)
```dart
NGO(
  name: "Care Foundation",
  description: "Providing disaster relief and emergency aid.",
  location: "Delhi",
  logoUrl: "https://i.pravatar.cc/150?img=10",
  members: 120,
  followers: 5400,
)
```

### Step-by-Step Enhancement

#### Phase 1: Add Legal Information (High Priority)
```dart
NGO(
  name: "Care Foundation",
  description: "Providing disaster relief and emergency aid.",
  location: "Delhi",
  logoUrl: "https://i.pravatar.cc/150?img=10",
  members: 120,
  followers: 5400,
  
  // New: Legal info builds trust
  registrationNumber: "DL/2018/012345",
  legalStatus: "Registered Society",
  panNumber: "AABCC1234D",
)
```

#### Phase 2: Add Contact Information (High Priority)
```dart
NGO(
  // ... previous fields ...
  
  // New: Essential for communication
  website: "https://carefoundation.org",
  email: "contact@carefoundation.org",
  phone: "+91-11-12345678",
  address: "123 Relief Road, Delhi 110001",
)
```

#### Phase 3: Add Mission & Impact (Medium Priority)
```dart
NGO(
  // ... previous fields ...
  
  // New: Shows purpose and results
  mission: "To provide immediate relief and long-term rehabilitation to disaster-affected communities.",
  projectTypes: ["Disaster Relief", "Emergency Aid", "Rehabilitation"],
  impactMetrics: ImpactMetrics(
    beneficiariesReached: 50000,
    projectsCompleted: 25,
    communitiesServed: 40,
  ),
  rating: 4.5,
)
```

#### Phase 4: Add Financial Transparency (Medium Priority)
```dart
NGO(
  // ... previous fields ...
  
  // New: Shows responsible fund usage
  expenseBreakdown: ExpenseBreakdown(
    programCosts: 8000000,    // ₹80 lakhs
    adminCosts: 1500000,       // ₹15 lakhs
    fundraisingCosts: 500000,  // ₹5 lakhs
  ),
  fundingSources: [
    "Individual Donations",
    "Corporate CSR",
    "Government Grants",
  ],
)
```

#### Phase 5: Full Comprehensive Format
See [sample_ngo_data.dart](lib/data/sample_ngo_data.dart) for complete example with:
- Leadership details
- Project portfolios
- Partnerships
- Reviews and testimonials
- Complete documentation

---

## Quick Update: Replace Sample Data in ngo_search_page.dart

### Option 1: Use Sample Data File
Replace the hardcoded NGOs in `ngo_search_page.dart`:

```dart
import 'package:unityaid/data/sample_ngo_data.dart';

class _NGOSearchPageState extends State<NGOSearchPage> {
  // Replace this:
  // final List<NGO> ngos = [
  //   NGO(name: "Care Foundation", ...),
  //   NGO(name: "HopeWorks", ...),
  // ];
  
  // With this:
  final List<NGO> ngos = getSampleNGOList();
  
  // ... rest of code
}
```

### Option 2: Enhanced Inline Data
Update the existing NGOs with more fields:

```dart
class _NGOSearchPageState extends State<NGOSearchPage> {
  final List<NGO> ngos = [
    NGO(
      name: "Care Foundation",
      description: "Providing disaster relief and emergency aid to affected communities across India.",
      location: "Delhi",
      logoUrl: "https://i.pravatar.cc/150?img=10",
      members: 120,
      followers: 5400,
      // Add these new fields:
      registrationNumber: "DL/2018/012345",
      legalStatus: "Registered Society under Societies Registration Act",
      panNumber: "AABCC1234D",
      mission: "To provide immediate relief and long-term rehabilitation to disaster-affected communities.",
      projectTypes: ["Disaster Relief", "Emergency Aid", "Rehabilitation", "Food Security"],
      website: "https://carefoundation.org",
      email: "contact@carefoundation.org",
      phone: "+91-11-12345678",
      rating: 4.5,
      impactMetrics: ImpactMetrics(
        beneficiariesReached: 50000,
        projectsCompleted: 25,
        communitiesServed: 40,
      ),
    ),
    
    NGO(
      name: "HopeWorks",
      description: "Empowering underprivileged communities through sustainable development programs.",
      location: "Mumbai",
      logoUrl: "https://i.pravatar.cc/150?img=11",
      members: 80,
      followers: 3200,
      // Add these new fields:
      registrationNumber: "MH/2015/067890",
      legalStatus: "Section 8 Company",
      panNumber: "AABHW5678E",
      mission: "To empower underprivileged communities through education, healthcare, and livelihood opportunities.",
      projectTypes: ["Education", "Healthcare", "Skill Development", "Women Empowerment"],
      website: "https://hopeworks.org",
      email: "info@hopeworks.org",
      phone: "+91-22-98765432",
      rating: 4.7,
      impactMetrics: ImpactMetrics(
        beneficiariesReached: 35000,
        projectsCompleted: 18,
        communitiesServed: 28,
      ),
    ),
  ];
  
  // ... rest of code
}
```

---

## Backend Integration Checklist

When connecting to your backend/database:

### Must Have (for listing page)
- [ ] Basic info: name, description, location, logoUrl
- [ ] Stats: members, followers
- [ ] Registration number
- [ ] Rating (if available)

### Should Have (for detail page)
- [ ] Contact info: website, email, phone
- [ ] Mission statement
- [ ] Project types
- [ ] Impact metrics

### Nice to Have (for comprehensive view)
- [ ] Financial reports
- [ ] Leadership details
- [ ] Project portfolio
- [ ] Reviews and partnerships

### Database Schema Example

```sql
-- NGOs table (main data)
CREATE TABLE ngos (
  id VARCHAR PRIMARY KEY,
  name VARCHAR NOT NULL,
  description TEXT,
  location VARCHAR,
  logo_url VARCHAR,
  registration_number VARCHAR,
  legal_status VARCHAR,
  pan_number VARCHAR,
  mission TEXT,
  website VARCHAR,
  email VARCHAR,
  phone VARCHAR,
  address TEXT,
  rating DECIMAL(2,1),
  verified BOOLEAN DEFAULT false
);

-- Impact metrics
CREATE TABLE ngo_metrics (
  ngo_id VARCHAR REFERENCES ngos(id),
  beneficiaries_reached INT,
  projects_completed INT,
  communities_served INT
);

-- Projects
CREATE TABLE ngo_projects (
  id VARCHAR PRIMARY KEY,
  ngo_id VARCHAR REFERENCES ngos(id),
  title VARCHAR,
  description TEXT,
  status VARCHAR,
  start_date DATE,
  end_date DATE
);

-- Reviews
CREATE TABLE ngo_reviews (
  id VARCHAR PRIMARY KEY,
  ngo_id VARCHAR REFERENCES ngos(id),
  reviewer_name VARCHAR,
  rating DECIMAL(2,1),
  comment TEXT,
  date TIMESTAMP
);
```

### API Response Format

```json
{
  "status": "success",
  "data": {
    "ngo": {
      "id": "ngo123",
      "name": "Care Foundation",
      "description": "...",
      "location": "Delhi",
      "logo_url": "...",
      "members": 120,
      "followers": 5400,
      "registration_number": "DL/2018/012345",
      "legal_status": "Registered Society",
      "pan_number": "AABCC1234D",
      "mission": "...",
      "rating": 4.5,
      "verified": true,
      "contact": {
        "website": "...",
        "email": "...",
        "phone": "...",
        "address": "..."
      },
      "metrics": {
        "beneficiaries_reached": 50000,
        "projects_completed": 25,
        "communities_served": 40
      },
      "projects": [...],
      "reviews": [...]
    }
  }
}
```

---

## Progressive Enhancement Strategy

Start simple and add features over time:

### Week 1: Basic Dashboard
- Show existing basic info
- Add registration number if available
- Add contact buttons

### Week 2: Verification
- Add legal information section
- Display certificates
- Show verified badge

### Week 3: Transparency
- Add financial data
- Show expense breakdown
- Link to reports

### Week 4: Social Proof
- Implement review system
- Add partnership logos
- Show media mentions

### Week 5+: Full Features
- Complete project portfolios
- Leadership profiles
- Impact stories
- Advanced filtering

---

## Testing the Dashboard

### Test with Minimal Data
```dart
// This should work fine - shows only available info
NGO minimalNGO = NGO(
  name: "Test NGO",
  description: "Basic description",
  location: "Test City",
  logoUrl: "https://via.placeholder.com/150",
  members: 10,
  followers: 50,
);
```

### Test with Complete Data
```dart
// Use sample data
import 'package:unityaid/data/sample_ngo_data.dart';
NGO fullNGO = getSampleNGO();
```

### Test Empty Sections
The dashboard gracefully handles missing data by showing "Information not available" messages.

---

## Need Help?

Check the comprehensive examples in:
- `lib/data/sample_ngo_data.dart` - Complete sample data
- `lib/models/ngo_model.dart` - All available fields
- `NGO_DASHBOARD_README.md` - Full documentation
