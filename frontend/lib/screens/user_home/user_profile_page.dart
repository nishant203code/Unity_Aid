import 'package:flutter/material.dart';
import '../../widgets/theme/app_colors.dart';
import '../../models/user_model.dart';
import '../../data/sample_user_data.dart';
import '../../data/sample_ngo_data.dart';
import 'edit_profile_page.dart';
import '../login_page.dart';

class UserProfilePage extends StatelessWidget {
  final UserModel? user;
  const UserProfilePage({super.key, this.user});

  @override
  Widget build(BuildContext context) {
    final currentUser = user ?? sampleUser;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Dashboard',
            style: TextStyle(fontWeight: FontWeight.bold)),
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
            _buildProfileHeader(context, currentUser, theme),
            const SizedBox(height: 20),
            _buildStatsCard(context, currentUser, theme),
            const SizedBox(height: 20),
            _buildSection(context, title: 'Personal Information', children: [
              _InfoTile(
                  icon: Icons.person,
                  label: 'Full Name',
                  value: currentUser.name),
              _InfoTile(
                  icon: Icons.wc, label: 'Gender', value: currentUser.gender),
              _InfoTile(
                  icon: Icons.email, label: 'Email', value: currentUser.email),
              _InfoTile(
                  icon: Icons.phone, label: 'Phone', value: currentUser.phone),
              _InfoTile(
                  icon: Icons.work,
                  label: 'Occupation',
                  value: currentUser.occupation),
              _InfoTile(
                  icon: Icons.category,
                  label: 'Category',
                  value: currentUser.category),
            ]),
            const SizedBox(height: 20),
            _buildSection(context, title: 'Family Information', children: [
              _InfoTile(
                  icon: Icons.family_restroom,
                  label: "Mother's Name",
                  value: currentUser.motherName ?? 'Not provided'),
              _InfoTile(
                  icon: Icons.family_restroom,
                  label: "Father's Name",
                  value: currentUser.fatherName ?? 'Not provided'),
            ]),
            const SizedBox(height: 20),
            _buildSection(context, title: 'Address', children: [
              _InfoTile(
                  icon: Icons.location_on,
                  label: 'Address',
                  value: currentUser.address,
                  maxLines: 3),
            ]),
            const SizedBox(height: 20),
            _buildJoinedNGOsSection(context, currentUser),
            const SizedBox(height: 20),
            _buildSection(context, title: 'Account Information', children: [
              _InfoTile(
                  icon: Icons.calendar_today,
                  label: 'Member Since',
                  value: _formatDate(currentUser.joinedDate)),
              _InfoTile(
                icon: Icons.verified_user,
                label: 'Verification Status',
                value: currentUser.isVerified ? 'Verified ✓' : 'Not Verified',
                valueColor:
                    currentUser.isVerified ? Colors.green : Colors.orange,
              ),
            ]),
            const SizedBox(height: 20),
            _buildActionButtons(context, currentUser),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(
      BuildContext context, UserModel user, ThemeData theme) {
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
                  ? Text(user.name[0].toUpperCase(),
                      style: const TextStyle(
                          fontSize: 40, fontWeight: FontWeight.bold))
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
                    border: Border.all(
                        color: theme.scaffoldBackgroundColor, width: 2),
                  ),
                  child:
                      const Icon(Icons.verified, color: Colors.white, size: 24),
                ),
              ),
          ],
        ),
        const SizedBox(height: 16),
        Text(user.name,
            style: theme.textTheme.headlineSmall
                ?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(user.email,
            style: theme.textTheme.bodySmall?.copyWith(fontSize: 14)),
      ],
    );
  }

  Widget _buildStatsCard(
      BuildContext context, UserModel user, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(blurRadius: 15, color: Colors.black.withOpacity(0.06))
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _Stat(
              title: 'Total Donated',
              value: '₹${user.totalDonated.toStringAsFixed(0)}'),
          _Stat(title: 'Joined NGOs', value: '${user.joinedNGOIds.length}'),
          _Stat(
              title: 'Member Days',
              value: '${DateTime.now().difference(user.joinedDate).inDays}'),
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context,
      {required String title, required List<Widget> children}) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(blurRadius: 10, color: Colors.black.withOpacity(0.04))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(title,
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary)),
          ),
          Divider(height: 1, color: theme.dividerColor),
          ...children,
        ],
      ),
    );
  }

  Widget _buildJoinedNGOsSection(BuildContext context, UserModel user) {
    final theme = Theme.of(context);
    if (user.joinedNGOIds.isEmpty) {
      return _buildSection(context, title: 'Joined NGOs', children: [
        const Padding(
            padding: EdgeInsets.all(16), child: Text('No NGOs joined yet')),
      ]);
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(blurRadius: 10, color: Colors.black.withOpacity(0.04))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text('Joined NGOs',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary)),
          ),
          Divider(height: 1, color: theme.dividerColor),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: user.joinedNGOIds.length,
            separatorBuilder: (_, __) =>
                Divider(height: 1, color: theme.dividerColor),
            itemBuilder: (context, index) {
              final ngo = index < sampleNGOs.length ? sampleNGOs[index] : null;
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppColors.primary.withOpacity(0.1),
                  child: const Icon(Icons.volunteer_activism,
                      color: AppColors.primary),
                ),
                title: Text(ngo?.name ?? 'NGO ${index + 1}'),
                subtitle: Text(ngo?.location ?? 'Organization'),
                trailing: const Icon(Icons.chevron_right),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, UserModel currentUser) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: () => _navigateToEditProfile(context, currentUser),
              icon: const Icon(Icons.edit, color: Colors.white),
              label: const Text('Edit Details',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: OutlinedButton.icon(
              onPressed: () => _showLogoutDialog(context),
              icon: const Icon(Icons.logout, color: Colors.red),
              label: const Text('Log Out',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.red)),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.red, width: 2),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
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
          builder: (context) => EditProfilePage(user: currentUser)),
    );
    if (updatedUser != null && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Profile updated!'), backgroundColor: Colors.green),
      );
    }
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                  (route) => false);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Logout', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) => '${date.day}/${date.month}/${date.year}';
}

class _Stat extends StatelessWidget {
  final String title;
  final String value;
  const _Stat({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value,
            style: const TextStyle(
                color: AppColors.primary,
                fontSize: 18,
                fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        Text(title,
            style: const TextStyle(fontSize: 12), textAlign: TextAlign.center),
      ],
    );
  }
}

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
    final theme = Theme.of(context);
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
                Text(label,
                    style: theme.textTheme.bodySmall
                        ?.copyWith(fontWeight: FontWeight.w500, fontSize: 12)),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: valueColor ?? theme.textTheme.bodyLarge?.color,
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
