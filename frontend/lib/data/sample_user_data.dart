import '../models/user_model.dart';

/// Sample user data for demonstration
final sampleUser = UserModel(
  id: 'user_001',
  name: 'Rahul Sharma',
  email: 'rahul.sharma@email.com',
  phone: '+91 98765 43210',
  gender: 'Male',
  profilePictureUrl: 'https://i.pravatar.cc/300',
  isVerified: true,
  totalDonated: 18500.0,
  address: '123, MG Road, Bangalore, Karnataka - 560001',
  motherName: 'Sunita Sharma',
  fatherName: 'Rajesh Sharma',
  occupation: 'Software Engineer',
  category: 'Regular Supporter',
  joinedNGOIds: ['ngo_001', 'ngo_002', 'ngo_003'],
  joinedDate: DateTime(2024, 1, 15),
);

final sampleUser2 = UserModel(
  id: 'user_002',
  name: 'Priya Verma',
  email: 'priya.verma@email.com',
  phone: '+91 87654 32109',
  gender: 'Female',
  profilePictureUrl: 'https://i.pravatar.cc/300?img=5',
  isVerified: true,
  totalDonated: 25000.0,
  address: '456, Park Street, Mumbai, Maharashtra - 400001',
  motherName: 'Anjali Verma',
  fatherName: 'Amit Verma',
  occupation: 'Doctor',
  category: 'Premium Donor',
  joinedNGOIds: ['ngo_001', 'ngo_004', 'ngo_005', 'ngo_006'],
  joinedDate: DateTime(2023, 6, 20),
);
