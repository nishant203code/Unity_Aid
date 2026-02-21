import 'package:flutter/material.dart';
import '../../widgets/theme/app_colors.dart';
import '../../models/user_model.dart';
import '../../models/ngo_model.dart';
import '../../data/sample_user_data.dart';
import '../../data/sample_ngo_data.dart';
import 'edit_profile_page.dart';
import '../login_page.dart';

class UserProfilePage extends StatelessWidget {
  final UserModel? user;

  const UserProfilePage({super.key, this.user});

  @override
  Widget build(BuildContext context) {
    // Use provided user or default to sample user
    final currentUser = user ?? sampleUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "User Dashboard",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _navigateToEditProfile(context, currentUser),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),

            /// PROFILE HEADER
            _buildProfileHeader(context, currentUser),

            const SizedBox(height: 20),

            /// STATS CARD
            _buildStatsCard(context, currentUser),

            const SizedBox(height: 20),

            /// PERSONAL INFO SECTION
            _buildSection(
              title: "Personal Information",
              children: [
                _InfoTile(
                    icon: Icons.person,
                    label: "Full Name",
                    value: currentUser.name),
                _InfoTile(
                    icon: Icons.wc, label: "Gender", value: currentUser.gender),
                _InfoTile(
                    icon: Icons.email,
                    label: "Email",
                    value: currentUser.email),
                _InfoTile(
                    icon: Icons.phone,
                    label: "Phone",
                    value: currentUser.phone),
                _InfoTile(
                    icon: Icons.work,
                    label: "Occupation",
                    value: currentUser.occupation),
                _InfoTile(
                    icon: Icons.category,
                    label: "Category",
                    value: currentUser.category),
              ],
            ),

            const SizedBox(height: 20),

            /// FAMILY INFO SECTION
            _buildSection(
              title: "Family Information",
              children: [
                _InfoTile(
                  icon: Icons.family_restroom,
                  label: "Mother's Name",
                  value: currentUser.motherName ?? "Not provided",
                ),
                _InfoTile(
                  icon: Icons.family_restroom,
                  label: "Father's Name",
                  value: currentUser.fatherName ?? "Not provided",
                ),
              ],
            ),

            const SizedBox(height: 20),

            /// ADDRESS SECTION
            _buildSection(
              title: "Address",
              children: [
                _InfoTile(
                  icon: Icons.location_on,
                  label: "Address",
                  value: currentUser.address,
                  maxLines: 3,
                ),
              ],
            ),

            const SizedBox(height: 20),

            /// JOINED NGOs SECTION
            _buildJoinedNGOsSection(currentUser),

            const SizedBox(height: 20),

            /// ACCOUNT INFO
            _buildSection(
              title: "Account Information",
              children: [
                _InfoTile(
                  icon: Icons.calendar_today,
                  label: "Member Since",
                  value: _formatDate(currentUser.joinedDate),
                ),
                _InfoTile(
                  icon: Icons.verified_user,
                  label: "Verification Status",
                  value: currentUser.isVerified ? "Verified ✓" : "Not Verified",
                  valueColor:
                      currentUser.isVerified ? Colors.green : Colors.orange,
                ),
              ],
            ),

            const SizedBox(height: 20),

            /// ACTION BUTTONS
            _buildActionButtons(context),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, UserModel user) {
    return Column(
      children: [
        Stack(
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage: user.profilePictureUrl != null
                  ? NetworkImage(user.profilePictureUrl!)
                  : null,
              child: user.profilePictureUrl == null
                  ? Text(
                      user.name[0].toUpperCase(),
                      style: const TextStyle(
                          fontSize: 40, fontWeight: FontWeight.bold),
                    )
                  : null,
            ),
            if (user.isVerified)
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Icon(
                    Icons.verified,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          user.name,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          user.email,
          style: TextStyle(
            color: Theme.of(context).textTheme.bodySmall?.color,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildStatsCard(BuildContext context, UserModel user) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            blurRadius: 15,
            color: Theme.of(context).shadowColor.withOpacity(0.1),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _Stat(
              title: "Total Donated",
              value: "₹${user.totalDonated.toStringAsFixed(0)}"),
          _Stat(title: "Joined NGOs", value: "${user.joinedNGOIds.length}"),
          _Stat(
              title: "Member Days",
              value: "${DateTime.now().difference(user.joinedDate).inDays}"),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            color: Colors.black.withOpacity(0.03),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ),
          const Divider(height: 1),
          ...children,
        ],
      ),
    );
  }

  Widget _buildJoinedNGOsSection(UserModel user) {
    if (user.joinedNGOIds.isEmpty) {
      return _buildSection(
        title: "Joined NGOs",
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text("No NGOs joined yet"),
          ),
        ],
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            color: Colors.black.withOpacity(0.03),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              "Joined NGOs",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ),
          const Divider(height: 1),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: user.joinedNGOIds.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              // Try to find the NGO from sample data (using index as fallback)
              NGO? ngo;

              // Try to match by name or use index
              if (index < sampleNGOs.length) {
                ngo = sampleNGOs[index];
              }

              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppColors.primary.withOpacity(0.1),
                  child: const Icon(Icons.volunteer_activism,
                      color: AppColors.primary),
                ),
                title: Text(ngo?.name ?? "NGO ${index + 1}"),
                subtitle: Text(ngo?.location ?? "Organization"),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // TODO: Navigate to NGO details
                },
              );
            },
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  Widget _buildActionButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          /// EDIT DETAILS BUTTON
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: () =>
                  _navigateToEditProfile(context, user ?? sampleUser),
              icon: const Icon(Icons.edit, color: Colors.white),
              label: const Text(
                'Edit Details',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),

          /// LOGOUT BUTTON
          SizedBox(
            width: double.infinity,
            height: 50,
            child: OutlinedButton.icon(
              onPressed: () => _showLogoutDialog(context),
              icon: const Icon(Icons.logout, color: Colors.red),
              label: const Text(
                'Log Out',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.red, width: 2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToEditProfile(
      BuildContext context, UserModel currentUser) async {
    final updatedUser = await Navigator.push<UserModel>(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfilePage(user: currentUser),
      ),
    );

    if (updatedUser != null) {
      // TODO: Update user data in state management/database
      // For now, just show a success message
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:
                Text('Profile updated! Please restart the app to see changes.'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // Close dialog
                Navigator.pop(dialogContext);

                // Navigate to login page and clear all previous routes
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => const LoginPage(),
                  ),
                  (route) => false,
                );

                // TODO: Clear user session/token from storage
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text(
                'Logout',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}

/// Widget for displaying statistics
class _Stat extends StatelessWidget {
  final String title;
  final String value;

  const _Stat({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: AppColors.primary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          title,
          style: const TextStyle(fontSize: 12),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

/// Widget for displaying information tiles
class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final int maxLines;
  final Color? valueColor;

  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
    this.maxLines = 1,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: valueColor ?? Colors.black87,
                  ),
                  maxLines: maxLines,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
