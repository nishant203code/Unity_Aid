import '../models/donation_case_model.dart';

/// Sample donation cases for testing and demonstration

List<DonationCase> getSampleDonationCases() {
  return [
    DonationCase(
      id: "CASE001",
      title: "Emergency Medical Treatment for 8-Year-Old Girl",
      shortDescription:
          "Neha needs urgent heart surgery. Her family cannot afford the medical expenses.",
      fullDescription:
          "Neha Sharma, an 8-year-old bright and cheerful girl from Mumbai, has been diagnosed with a congenital heart defect that requires immediate surgical intervention. Her family, struggling with limited financial resources, cannot afford the costly medical treatment.",
      category: "Medical Emergency",
      location: "Mumbai, Maharashtra",
      imageUrl: "https://via.placeholder.com/400x300",
      targetAmount: 500000,
      raisedAmount: 320000,
      deadline: DateTime.now().add(const Duration(days: 15)),
      urgencyLevel: "Critical",
      beneficiaryName: "Neha Sharma",
      beneficiaryAge: 8,
      beneficiaryGender: "Female",
      caseStory:
          "Neha is a bright student in 3rd grade who loves drawing and playing with her friends. Last month, she started experiencing severe chest pain and breathing difficulties. After consultation with cardiologists at a leading hospital, it was revealed that she has a congenital heart defect that requires immediate open-heart surgery.\n\nHer father works as a daily wage laborer earning barely enough to feed the family. Her mother is a homemaker who takes care of Neha and her younger brother. The family has already exhausted their limited savings on initial consultations and tests. They are now desperately seeking financial assistance to save their daughter's life.\n\nThe surgery is scheduled for next month, and without it, Neha's condition will continue to deteriorate. The doctors have emphasized the urgency of the procedure. Every contribution, no matter how small, will help save Neha's life and give her a chance to fulfill her dreams.",
      requirements: [
        "Open Heart Surgery: ₹3,50,000",
        "Post-operative Care: ₹80,000",
        "Medications (6 months): ₹50,000",
        "Hospital Stay (15 days): ₹20,000",
      ],
      currentStatus:
          "Pre-surgery tests completed. Surgery scheduled for March 1, 2026. Awaiting final amount.",
      handlingNGO: "Hope Foundation",
      ngoLogoUrl: "https://via.placeholder.com/80",
      isVerified: true,
      supportersCount: 245,
      createdDate: DateTime.now().subtract(const Duration(days: 12)),
      additionalImages: [
        "https://via.placeholder.com/300x200",
        "https://via.placeholder.com/300x200",
        "https://via.placeholder.com/300x200",
      ],
      documents: {
        "Medical Reports": "https://example.com/docs/medical_report.pdf",
        "Doctor's Prescription": "https://example.com/docs/prescription.pdf",
        "Income Certificate": "https://example.com/docs/income_cert.pdf",
      },
    ),
    DonationCase(
      id: "CASE002",
      title: "Education Support for Orphaned Siblings",
      shortDescription:
          "Three siblings lost their parents in an accident. Help them continue their education.",
      fullDescription:
          "After losing both parents in a tragic road accident, Raj (14), Priya (12), and Arun (9) are struggling to continue their education. They now live with their elderly grandmother who cannot afford their school fees.",
      category: "Education",
      location: "Bangalore, Karnataka",
      imageUrl: "https://via.placeholder.com/400x300",
      targetAmount: 150000,
      raisedAmount: 85000,
      deadline: DateTime.now().add(const Duration(days: 30)),
      urgencyLevel: "High",
      beneficiaryName: "Raj, Priya & Arun Kumar",
      beneficiaryAge: null,
      beneficiaryGender: null,
      caseStory:
          "Six months ago, Raj, Priya, and Arun lost both their parents in a devastating road accident. Their father was a school teacher and their mother worked at a local shop. The family was living a modest but happy life until tragedy struck.\n\nNow the three children live with their 68-year-old grandmother who receives a small pension of ₹3,000 per month. Despite her best efforts, she cannot afford their school fees, books, uniforms, and other educational expenses.\n\nRaj is a brilliant student who dreams of becoming an engineer. Priya loves science and wants to be a doctor. Little Arun is just discovering his love for reading. All three are excellent students, but their education is now at risk.\n\nYour support will ensure these children can continue their studies, buy necessary books and uniforms, and have a fighting chance to build a better future despite their tragic loss.",
      requirements: [
        "School Fees (1 year): ₹90,000",
        "Books & Stationery: ₹25,000",
        "Uniforms & Shoes: ₹15,000",
        "School Transport: ₹20,000",
      ],
      currentStatus:
          "Children currently attending school. School fees due by end of February 2026.",
      handlingNGO: "Education for All Foundation",
      ngoLogoUrl: "https://via.placeholder.com/80",
      isVerified: true,
      supportersCount: 178,
      createdDate: DateTime.now().subtract(const Duration(days: 20)),
      additionalImages: [
        "https://via.placeholder.com/300x200",
        "https://via.placeholder.com/300x200",
      ],
      documents: {
        "Death Certificates": "https://example.com/docs/death_cert.pdf",
        "School Fee Structure": "https://example.com/docs/fee_structure.pdf",
        "Guardian Declaration": "https://example.com/docs/guardian_declaration.pdf",
      },
    ),
    DonationCase(
      id: "CASE003",
      title: "Flood Relief for 50 Families",
      shortDescription:
          "Recent floods destroyed homes of 50 families. They need immediate shelter and food.",
      fullDescription:
          "In the recent floods in Kerala, 50 families lost their homes and all belongings. They are currently living in temporary relief camps and need urgent assistance for rehabilitation.",
      category: "Disaster Relief",
      location: "Kochi, Kerala",
      imageUrl: "https://via.placeholder.com/400x300",
      targetAmount: 1000000,
      raisedAmount: 650000,
      deadline: DateTime.now().add(const Duration(days: 20)),
      urgencyLevel: "Critical",
      beneficiaryName: "Flood-affected families",
      beneficiaryAge: null,
      beneficiaryGender: null,
      caseStory:
          "Last week, unprecedented rainfall caused severe flooding in several villages near Kochi, Kerala. The flood waters rose rapidly, giving residents barely any time to evacuate. Many families lost everything - their homes, belongings, livestock, and crops.\n\nCurrently, 50 families (approximately 200 people including children and elderly) are taking shelter in a temporary relief camp set up by local authorities. They have lost their homes and have nowhere to return to. Many breadwinners have lost their tools and equipment needed for their livelihoods.\n\nThese families urgently need:\n- Temporary shelter materials to rebuild basic housing\n- Food supplies for the next 3 months\n- Clothing and blankets\n- Water purification tablets and basic medicines\n- Livelihood restoration support\n\nThe local NGO 'Care Kerala' is working on the ground to provide immediate relief and long-term rehabilitation. Your contribution will help these families get back on their feet and rebuild their lives.",
      requirements: [
        "Temporary Shelter Materials: ₹400,000",
        "Food Supplies (3 months): ₹300,000",
        "Clothing & Blankets: ₹100,000",
        "Medical Supplies: ₹80,000",
        "Livelihood Tools: ₹120,000",
      ],
      currentStatus:
          "Families in relief camps. Immediate food and shelter being provided. Rehabilitation phase starting soon.",
      handlingNGO: "Care Kerala",
      ngoLogoUrl: "https://via.placeholder.com/80",
      isVerified: true,
      supportersCount: 412,
      createdDate: DateTime.now().subtract(const Duration(days: 5)),
      additionalImages: [
        "https://via.placeholder.com/300x200",
        "https://via.placeholder.com/300x200",
        "https://via.placeholder.com/300x200",
        "https://via.placeholder.com/300x200",
      ],
      documents: {
        "Damage Assessment Report": "https://example.com/docs/damage_report.pdf",
        "Beneficiary List": "https://example.com/docs/beneficiary_list.pdf",
        "Relief Camp Details": "https://example.com/docs/camp_details.pdf",
      },
    ),
    DonationCase(
      id: "CASE004",
      title: "Wheelchair for Accident Victim",
      shortDescription:
          "25-year-old Ramesh lost mobility in accident. Needs a motorized wheelchair.",
      fullDescription:
          "Ramesh, a young software engineer, met with a serious accident that left him paralyzed from the waist down. He needs a motorized wheelchair to regain independence.",
      category: "Medical Aid",
      location: "Pune, Maharashtra",
      imageUrl: "https://via.placeholder.com/400x300",
      targetAmount: 180000,
      raisedAmount: 95000,
      deadline: DateTime.now().add(const Duration(days: 25)),
      urgencyLevel: "Medium",
      beneficiaryName: "Ramesh Patel",
      beneficiaryAge: 25,
      beneficiaryGender: "Male",
      caseStory:
          "Ramesh Patel was a promising 25-year-old software engineer with a bright future ahead. Three months ago, while returning from work, he met with a severe road accident caused by a reckless driver. The accident resulted in a spinal cord injury that left him paralyzed from the waist down.\n\nAfter months of treatment and therapy, doctors have confirmed that Ramesh will need to use a wheelchair permanently. However, to maintain some independence and continue working from home, he needs a motorized wheelchair that he can operate on his own.\n\nRamesh was the sole earning member of his family, supporting his parents and younger sister. The accident has already depleted the family's savings on medical treatments. They cannot afford the expensive motorized wheelchair that would allow Ramesh to move around independently and eventually return to work.\n\nA motorized wheelchair will help Ramesh:\n- Move around his home independently\n- Attend physiotherapy sessions on his own\n- Eventually return to work\n- Regain his dignity and self-reliance\n\nYour support will help a young man rebuild his life and regain his independence.",
      requirements: [
        "Motorized Wheelchair: ₹1,50,000",
        "Home Modifications: ₹20,000",
        "Physiotherapy (6 months): ₹10,000",
      ],
      currentStatus:
          "Physiotherapy ongoing. Wheelchair identified. Awaiting funds for purchase.",
      handlingNGO: "Mobility for All",
      ngoLogoUrl: "https://via.placeholder.com/80",
      isVerified: true,
      supportersCount: 132,
      createdDate: DateTime.now().subtract(const Duration(days: 18)),
      additionalImages: [
        "https://via.placeholder.com/300x200",
        "https://via.placeholder.com/300x200",
      ],
      documents: {
        "Medical Certificate": "https://example.com/docs/medical_cert.pdf",
        "Disability Certificate": "https://example.com/docs/disability_cert.pdf",
        "Wheelchair Quotation": "https://example.com/docs/wheelchair_quote.pdf",
      },
    ),
    DonationCase(
      id: "CASE005",
      title: "Clean Water Well for Rural Village",
      shortDescription:
          "Village of 500 people has no clean water source. Help build a well.",
      fullDescription:
          "Sunderpura village with a population of 500 has no access to clean drinking water. Villagers, especially women and children, walk 3 km daily to fetch water from a contaminated source.",
      category: "Community Development",
      location: "Sunderpura, Rajasthan",
      imageUrl: "https://via.placeholder.com/400x300",
      targetAmount: 300000,
      raisedAmount: 125000,
      deadline: DateTime.now().add(const Duration(days: 45)),
      urgencyLevel: "High",
      beneficiaryName: "Sunderpura Village Community",
      beneficiaryAge: null,
      beneficiaryGender: null,
      caseStory:
          "Sunderpura is a small village in rural Rajasthan with approximately 500 residents, mostly farmers and daily wage laborers. The village has never had access to clean drinking water. For generations, villagers have been dependent on a polluted pond 3 kilometers away.\n\nEvery day, women and young girls walk 6 kilometers (round trip) carrying heavy water pots on their heads. This strenuous task takes 2-3 hours daily. The water from the pond is contaminated and has caused numerous health issues, especially among children. Cases of diarrhea, typhoid, and other waterborne diseases are common.\n\nYoung girls often miss school because they need to help fetch water. The lack of clean water has severely impacted the health, education, and overall development of the community.\n\nThe proposed project:\n- Construct a deep borewell with a hand pump\n- Install a solar-powered water pump\n- Build a water storage tank\n- Create multiple distribution points in the village\n- Provide water quality testing equipment\n\nThis project will transform the lives of 500 people by:\n- Providing clean, safe drinking water\n- Reducing waterborne diseases significantly\n- Freeing women and girls from the daily burden\n- Allowing children to attend school regularly\n- Improving overall health and quality of life",
      requirements: [
        "Borewell Drilling: ₹1,50,000",
        "Solar Pump Installation: ₹80,000",
        "Water Storage Tank: ₹40,000",
        "Distribution System: ₹20,000",
        "Water Testing Kit: ₹10,000",
      ],
      currentStatus:
          "Land identified. Survey completed. Waiting for funds to start drilling.",
      handlingNGO: "Water for All Initiative",
      ngoLogoUrl: "https://via.placeholder.com/80",
      isVerified: true,
      supportersCount: 89,
      createdDate: DateTime.now().subtract(const Duration(days: 10)),
      additionalImages: [
        "https://via.placeholder.com/300x200",
        "https://via.placeholder.com/300x200",
        "https://via.placeholder.com/300x200",
      ],
      documents: {
        "Village Survey Report": "https://example.com/docs/survey_report.pdf",
        "Technical Proposal": "https://example.com/docs/technical_proposal.pdf",
        "Land Approval": "https://example.com/docs/land_approval.pdf",
      },
    ),
  ];
}
