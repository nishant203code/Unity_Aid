import 'package:flutter/material.dart';
import '../../widgets/theme/app_colors.dart';
import '../../models/ngo_model.dart';
import '../../data/sample_ngo_data.dart';
import '../login_page.dart';

class NGOProfilePage extends StatelessWidget {
  final NGO? ngo;

  const NGOProfilePage({super.key, this.ngo});

  @override
  Widget build(BuildContext context) {
    // Use provided NGO or default to sample NGO
    final currentNGO = ngo ?? getSampleNGO();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "NGO Dashboard",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // TODO: Navigate to edit NGO profile
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Edit NGO profile coming soon!')),
              );
            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'logout') {
                _showLogoutDialog(context);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout, color: Colors.red, size: 20),
                    SizedBox(width: 8),
                    Text('Logout'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),

            /// PROFILE HEADER
            _buildProfileHeader(context, currentNGO),

            const SizedBox(height: 20),

            /// STATS CARD
            _buildStatsCard(context, currentNGO),

            const SizedBox(height: 20),

            /// BASIC INFORMATION
            _buildSection(
              title: "Basic Information",
              children: [
                _InfoTile(
                  icon: Icons.business,
                  label: "Organization Name",
                  value: currentNGO.name,
                ),
                if (currentNGO.ownerName != null)
                  _InfoTile(
                    icon: Icons.person,
                    label: "Owner/Founder",
                    value: currentNGO.ownerName!,
                  ),
                _InfoTile(
                  icon: Icons.location_on,
                  label: "Location",
                  value: currentNGO.location,
                ),
                _InfoTile(
                  icon: Icons.description,
                  label: "Description",
                  value: currentNGO.description,
                  maxLines: 3,
                ),
                if (currentNGO.rating != null)
                  _InfoTile(
                    icon: Icons.star,
                    label: "Rating",
                    value: "${currentNGO.rating}/5.0",
                    valueColor: Colors.amber,
                  ),
              ],
            ),

            const SizedBox(height: 20),

            /// LEGAL & REGISTRATION
            if (currentNGO.registrationNumber != null ||
                currentNGO.legalStatus != null)
              _buildSection(
                title: "Legal & Registration",
                children: [
                  if (currentNGO.registrationNumber != null)
                    _InfoTile(
                      icon: Icons.badge,
                      label: "Registration Number",
                      value: currentNGO.registrationNumber!,
                    ),
                  if (currentNGO.fcraNumber != null)
                    _InfoTile(
                      icon: Icons.verified_user,
                      label: "FCRA Number",
                      value: currentNGO.fcraNumber!,
                    ),
                  if (currentNGO.darpanNumber != null)
                    _InfoTile(
                      icon: Icons.assignment,
                      label: "DARPAN Registration Number",
                      value: currentNGO.darpanNumber!,
                    ),
                  if (currentNGO.legalStatus != null)
                    _InfoTile(
                      icon: Icons.gavel,
                      label: "Legal Status",
                      value: currentNGO.legalStatus!,
                    ),
                  if (currentNGO.panNumber != null)
                    _InfoTile(
                      icon: Icons.credit_card,
                      label: "PAN Number",
                      value: currentNGO.panNumber!,
                    ),
                  if (currentNGO.tanNumber != null)
                    _InfoTile(
                      icon: Icons.account_balance,
                      label: "TAN Number",
                      value: currentNGO.tanNumber!,
                    ),
                ],
              ),

            if (currentNGO.registrationNumber != null ||
                currentNGO.legalStatus != null)
              const SizedBox(height: 20),

            /// CERTIFICATES
            if (currentNGO.certificates != null &&
                currentNGO.certificates!.isNotEmpty)
              _buildCertificatesSection(currentNGO),

            if (currentNGO.certificates != null &&
                currentNGO.certificates!.isNotEmpty)
              const SizedBox(height: 20),

            /// MISSION & VISION
            if (currentNGO.mission != null || currentNGO.vision != null)
              _buildSection(
                title: "Mission & Vision",
                children: [
                  if (currentNGO.mission != null)
                    _InfoTile(
                      icon: Icons.flag,
                      label: "Mission",
                      value: currentNGO.mission!,
                      maxLines: 5,
                    ),
                  if (currentNGO.vision != null)
                    _InfoTile(
                      icon: Icons.visibility,
                      label: "Vision",
                      value: currentNGO.vision!,
                      maxLines: 5,
                    ),
                ],
              ),

            if (currentNGO.mission != null || currentNGO.vision != null)
              const SizedBox(height: 20),

            /// CONTACT INFORMATION
            if (currentNGO.email != null || currentNGO.phone != null)
              _buildSection(
                title: "Contact Information",
                children: [
                  if (currentNGO.email != null)
                    _InfoTile(
                      icon: Icons.email,
                      label: "Email",
                      value: currentNGO.email!,
                    ),
                  if (currentNGO.phone != null)
                    _InfoTile(
                      icon: Icons.phone,
                      label: "Phone",
                      value: currentNGO.phone!,
                    ),
                  if (currentNGO.address != null)
                    _InfoTile(
                      icon: Icons.home,
                      label: "Address",
                      value: currentNGO.address!,
                      maxLines: 3,
                    ),
                  if (currentNGO.website != null)
                    _InfoTile(
                      icon: Icons.language,
                      label: "Website",
                      value: currentNGO.website!,
                    ),
                ],
              ),

            if (currentNGO.email != null || currentNGO.phone != null)
              const SizedBox(height: 20),

            /// BANKING INFORMATION
            if (currentNGO.bankName != null ||
                currentNGO.bankAccountNumber != null)
              _buildSection(
                title: "Banking Information",
                children: [
                  if (currentNGO.bankName != null)
                    _InfoTile(
                      icon: Icons.account_balance,
                      label: "Bank Name",
                      value: currentNGO.bankName!,
                    ),
                  if (currentNGO.bankAccountNumber != null)
                    _InfoTile(
                      icon: Icons.account_balance_wallet,
                      label: "Bank Account Number",
                      value: currentNGO.bankAccountNumber!,
                    ),
                  if (currentNGO.ifscCode != null)
                    _InfoTile(
                      icon: Icons.code,
                      label: "IFSC Code",
                      value: currentNGO.ifscCode!,
                    ),
                ],
              ),

            if (currentNGO.bankName != null ||
                currentNGO.bankAccountNumber != null)
              const SizedBox(height: 20),

            /// IMPACT METRICS
            if (currentNGO.impactMetrics != null)
              _buildImpactMetricsSection(currentNGO.impactMetrics!),

            if (currentNGO.impactMetrics != null) const SizedBox(height: 20),

            /// PROJECTS
            if (currentNGO.projects != null && currentNGO.projects!.isNotEmpty)
              _buildProjectsSection(currentNGO),

            if (currentNGO.projects != null && currentNGO.projects!.isNotEmpty)
              const SizedBox(height: 20),

            /// BOARD MEMBERS
            if (currentNGO.boardMembers != null &&
                currentNGO.boardMembers!.isNotEmpty)
              _buildBoardMembersSection(currentNGO),

            if (currentNGO.boardMembers != null &&
                currentNGO.boardMembers!.isNotEmpty)
              const SizedBox(height: 20),

            /// ACTION BUTTONS
            _buildActionButtons(context),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, NGO ngo) {
    return Column(
      children: [
        Stack(
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage: NetworkImage(ngo.logoUrl),
            ),
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
          ngo.name,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          ngo.location,
          style: TextStyle(
            color: Theme.of(context).textTheme.bodySmall?.color,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildStatsCard(BuildContext context, NGO ngo) {
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
          _Stat(title: "Members", value: "${ngo.members}"),
          _Stat(title: "Followers", value: "${ngo.followers}"),
          _Stat(
            title: "Projects",
            value: "${ngo.projects?.length ?? 0}",
          ),
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

  Widget _buildCertificatesSection(NGO ngo) {
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
              "Certificates",
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
            itemCount: ngo.certificates!.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.green.withOpacity(0.1),
                  child: const Icon(Icons.verified, color: Colors.green),
                ),
                title: Text(ngo.certificates![index]),
                trailing: const Icon(Icons.chevron_right),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildImpactMetricsSection(ImpactMetrics metrics) {
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
              "Impact Metrics",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ),
          const Divider(height: 1),
          _InfoTile(
            icon: Icons.people,
            label: "Beneficiaries Reached",
            value: "${metrics.beneficiariesReached}",
          ),
          _InfoTile(
            icon: Icons.check_circle,
            label: "Projects Completed",
            value: "${metrics.projectsCompleted}",
          ),
          _InfoTile(
            icon: Icons.location_city,
            label: "Communities Served",
            value: "${metrics.communitiesServed}",
          ),
        ],
      ),
    );
  }

  Widget _buildProjectsSection(NGO ngo) {
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
              "Active Projects",
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
            itemCount: ngo.projects!.length.clamp(0, 5), // Show max 5
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final project = ngo.projects![index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppColors.primary.withOpacity(0.1),
                  child: const Icon(Icons.folder, color: AppColors.primary),
                ),
                title: Text(project.title),
                subtitle: Text(
                  project.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: const Icon(Icons.chevron_right),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBoardMembersSection(NGO ngo) {
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
              "Board Members",
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
            itemCount: ngo.boardMembers!.length.clamp(0, 5), // Show max 5
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final member = ngo.boardMembers![index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: member.photoUrl != null
                      ? NetworkImage(member.photoUrl!)
                      : null,
                  child: member.photoUrl == null
                      ? Text(member.name[0].toUpperCase())
                      : null,
                ),
                title: Text(member.name),
                subtitle: Text(member.position),
                trailing: const Icon(Icons.chevron_right),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          /// EDIT BUTTON
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: () {
                // TODO: Navigate to edit NGO profile
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Edit NGO profile coming soon!')),
                );
              },
              icon: const Icon(Icons.edit, color: Colors.white),
              label: const Text(
                'Edit NGO Profile',
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

  static void _showLogoutDialog(BuildContext context) {
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
                Navigator.pop(dialogContext);
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => const LoginPage(),
                  ),
                  (route) => false,
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
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
