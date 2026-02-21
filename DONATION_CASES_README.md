# 💝 Case-Based Donation System

## Overview
The donation section now features a comprehensive case browsing system where users can view multiple donation cases, click on any case to see detailed information, and donate directly to specific causes.

## Features Implemented

### 📋 Case Listing
- **Browse Cases Tab**: View all available donation cases
- **Category Filter**: Filter cases by category (Medical Emergency, Education, Disaster Relief, etc.)
- **Visual Cards**: Each case displays:
  - Hero image
  - Verification badge (if verified)
  - Urgency level (Critical, High, Medium, Low)
  - Category and location
  - Title and short description
  - Progress bar with raised amount and goal
  - Supporters count and days remaining
  - Handling NGO information

### 🔍 Case Detail Popup
When users click on a case card, a detailed bottom sheet appears with:

#### **Complete Information Sections:**
1. **Hero Image** - Large image with close button and verified badge
2. **Category & Priority** - Visual badges showing category and urgency
3. **Progress Section** - Large progress bar with percentage and amounts
4. **Beneficiary Information** - Name, age, gender
5. **The Story** - Full narrative of the case with context
6. **Fund Breakdown** - Itemized list of requirements
7. **Current Status** - Latest updates on the case
8. **Gallery** - Additional images if available
9. **Supporting Documents** - Downloadable verification documents
10. **Handled By** - NGO information with verification
11. **Statistics** - Supporters, days left, share option

#### **Bottom Action Bar:**
- Shows remaining amount needed
- Large "Donate Now" button that:
  - Closes the detail dialog
  - Navigates to donation form
  - Pre-fills the case ID

### 💳 Direct Donation Tab
- Original donation form preserved
- Supports both NGO and Case donations
- Auto-navigates here when case ID is prefilled

## Data Model

### DonationCase Structure
```dart
class DonationCase {
  // Basic Info
  String id, title, shortDescription, fullDescription
  String category, location, imageUrl
  double targetAmount, raisedAmount
  DateTime deadline
  String urgencyLevel
  
  // Beneficiary
  String beneficiaryName
  int? beneficiaryAge
  String? beneficiaryGender
  
  // Details
  String caseStory
  List<String> requirements
  String currentStatus
  
  // NGO
  String? handlingNGO
  String? ngoLogoUrl
  bool isVerified
  
  // Additional
  int supportersCount
  DateTime createdDate
  List<String>? additionalImages
  Map<String, String>? documents
}
```

## Sample Data Provided

5 complete sample cases in [sample_donation_cases.dart](lib/data/sample_donation_cases.dart):

1. **Medical Emergency** - 8-year-old needs heart surgery
2. **Education** - Orphaned siblings need school fees
3. **Disaster Relief** - 50 families affected by floods
4. **Medical Aid** - Wheelchair for accident victim
5. **Community Development** - Clean water well for village

Each case includes:
- Complete story with emotional context
- Detailed fund breakdown
- Multiple images
- Verification documents
- Realistic data

## User Flow

```
Donate Page
    ↓
Browse Cases Tab
    ↓
View Case Cards (filtered by category)
    ↓
Click on Case Card
    ↓
Case Detail Dialog Opens (Scrollable Bottom Sheet)
    ↓
Read Complete Case Information
    ↓
Click "Donate Now" Button at Bottom
    ↓
Navigate to Direct Donation Tab
    ↓
Form Pre-filled with Case ID
    ↓
Complete Donation
```

## UI Components

### Files Created/Modified

**New Files:**
- `lib/models/donation_case_model.dart` - Data model
- `lib/data/sample_donation_cases.dart` - Sample data
- `lib/screens/donate/widgets/donation_case_card.dart` - Case card widget
- `lib/screens/donate/widgets/case_detail_dialog.dart` - Detail dialog

**Modified Files:**
- `lib/screens/donate/donate_page.dart` - Added tabs and case list

## Key Features

### ✅ Trust Indicators
- Verified badge for authenticated cases
- NGO partnership display
- Document availability
- Supporter count

### ⏰ Urgency Indicators
- Color-coded urgency levels
- Days remaining countdown
- Expiring soon warnings (≤7 days)

### 📊 Progress Visualization
- Progress bar with percentage
- Amount raised vs goal
- Remaining amount needed
- Visual progress indicators

### 📱 Responsive Design
- Draggable bottom sheet
- Smooth scrolling
- Image galleries
- Mobile-optimized layout

## Customization

### Change Case Categories
Edit the categories list in `donate_page.dart`:
```dart
final categories = [
  'All', 
  'Medical Emergency', 
  'Education', 
  // Add your categories
];
```

### Add More Cases
Add to `sample_donation_cases.dart`:
```dart
DonationCase(
  id: "CASE006",
  title: "Your Case Title",
  // ... other fields
)
```

### Modify Urgency Colors
Edit `_getUrgencyColor()` in `donation_case_card.dart` and `case_detail_dialog.dart`

### Customize Dialog Height
In `case_detail_dialog.dart`, modify:
```dart
DraggableScrollableSheet(
  initialChildSize: 0.9,  // 90% of screen
  minChildSize: 0.5,       // Minimum 50%
  maxChildSize: 0.95,      // Maximum 95%
)
```

## Integration with Backend

### API Structure Needed

**GET /api/cases** - List all cases
```json
{
  "cases": [
    {
      "id": "CASE001",
      "title": "...",
      "category": "...",
      // ... other fields
    }
  ]
}
```

**GET /api/cases/:id** - Get case details
```json
{
  "case": {
    "id": "CASE001",
    "fullDescription": "...",
    "caseStory": "...",
    "requirements": [...],
    // ... complete case data
  }
}
```

### Database Schema

```sql
CREATE TABLE donation_cases (
  id VARCHAR PRIMARY KEY,
  title VARCHAR NOT NULL,
  short_description TEXT,
  full_description TEXT,
  case_story TEXT,
  category VARCHAR,
  location VARCHAR,
  image_url VARCHAR,
  target_amount DECIMAL(10,2),
  raised_amount DECIMAL(10,2),
  deadline DATE,
  urgency_level VARCHAR,
  beneficiary_name VARCHAR,
  beneficiary_age INT,
  current_status TEXT,
  handling_ngo_id VARCHAR,
  is_verified BOOLEAN,
  supporters_count INT,
  created_at TIMESTAMP
);

CREATE TABLE case_requirements (
  id SERIAL PRIMARY KEY,
  case_id VARCHAR REFERENCES donation_cases(id),
  requirement TEXT,
  amount DECIMAL(10,2)
);

CREATE TABLE case_documents (
  id SERIAL PRIMARY KEY,
  case_id VARCHAR REFERENCES donation_cases(id),
  document_name VARCHAR,
  document_url VARCHAR
);
```

## Testing

### Test with Sample Data
The app currently uses sample data from `getSampleDonationCases()`. To test:

1. Run the app
2. Navigate to Donate section
3. You'll see 2 tabs:
   - **Browse Cases** - Shows all sample cases
   - **Direct Donation** - Original donation form
4. Click on any case card
5. Scroll through the detailed information
6. Click "Donate Now" at the bottom
7. Observe navigation to donation form with pre-filled case ID

### Test Different Categories
Use the filter chips at the top of Browse Cases tab to filter by category.

### Test Urgency Levels
Cases are marked with different urgency levels (Critical, High, Medium, Low) with color-coded badges.

## Future Enhancements

Consider adding:
- [ ] Search functionality for cases
- [ ] Sort options (deadline, amount needed, urgency)
- [ ] Favorite/bookmark cases
- [ ] Share case feature
- [ ] Case update notifications
- [ ] Donation history for specific cases
- [ ] Success stories/outcomes
- [ ] Case comments/messages
- [ ] Real-time progress updates
- [ ] Related cases suggestions
- [ ] Case verification workflow
- [ ] Photo upload for beneficiaries
- [ ] Video testimonials
- [ ] Multi-currency support
- [ ] Recurring donation option

## Visual Design

### Color Coding
- **Critical**: Red - Immediate attention needed
- **High**: Orange - Urgent but not emergency
- **Medium**: Blue - Important, moderate timeline
- **Low**: Green - Stable, long-term case

### Progress Indicators
- 0-30%: Just started
- 31-60%: Making progress
- 61-90%: Nearly there
- 91-100%: Almost complete

### Verification Badge
Green badge with checkmark indicates:
- NGO verified the case
- Documents submitted
- Beneficiary authenticated

## Accessibility

- Proper contrast ratios for text
- Touch targets 48x48 pixels minimum
- Scrollable content with clear indicators
- Loading states for images
- Error handling for failed image loads

---

## Quick Start

The case-based donation system is ready to use! Sample data is already integrated. Users can now:

1. **Browse** multiple real-world like donation cases
2. **Filter** by category to find relevant cases
3. **Click** on any case to see complete details
4. **Read** the full story, requirements, and status
5. **Donate** directly from the detail view

All navigation and data flow is implemented and working! 🎉
