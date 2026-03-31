import 'package:flutter/material.dart';
import '../../models/ngo_model.dart';
import '../../widgets/theme/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';

class NGODetailPage extends StatelessWidget {
  final NGO ngo;
  const NGODetailPage({super.key, required this.ngo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(ngo.name),
        actions: [IconButton(icon: const Icon(Icons.share), onPressed: () {})],
      ),
      body: SingleChildScrollView(
        child: Column(
            children: [_buildHeader(context), _buildTabSections(context)]),
      ),
      bottomNavigationBar: _buildBottomBar(context),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor.withOpacity(0.7)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          CircleAvatar(
              radius: 60,
              backgroundImage: NetworkImage(ngo.logoUrl),
              backgroundColor: Colors.white),
          const SizedBox(height: 16),
          Text(ngo.name,
              style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
              textAlign: TextAlign.center),
          const SizedBox(height: 8),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Icon(Icons.location_on, color: Colors.white70, size: 18),
            const SizedBox(width: 4),
            Text(ngo.location,
                style: const TextStyle(color: Colors.white70, fontSize: 16)),
          ]),
          if (ngo.rating != null) ...[
            const SizedBox(height: 16),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              ...List.generate(
                  5,
                  (i) => Icon(
                        i < ngo.rating!.round()
                            ? Icons.star
                            : Icons.star_border,
                        color: Colors.amber,
                        size: 24,
                      )),
              const SizedBox(width: 8),
              Text('${ngo.rating!.toStringAsFixed(1)} / 5.0',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600)),
            ]),
          ],
          const SizedBox(height: 16),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            _buildStatCard('Members', ngo.members.toString()),
            _buildStatCard('Followers', ngo.followers.toString()),
            if (ngo.impactMetrics != null)
              _buildStatCard('Beneficiaries',
                  ngo.impactMetrics!.beneficiariesReached.toString()),
          ]),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12)),
      child: Column(children: [
        Text(value,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold)),
        Text(label,
            style: const TextStyle(color: Colors.white70, fontSize: 12)),
      ]),
    );
  }

  Widget _buildTabSections(BuildContext context) {
    return DefaultTabController(
      length: 7,
      child: Column(
        children: [
          const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'Overview'),
              Tab(text: 'Legal'),
              Tab(text: 'Financial'),
              Tab(text: 'Leadership'),
              Tab(text: 'Projects'),
              Tab(text: 'Partnerships'),
              Tab(text: 'Contact'),
            ],
          ),
          SizedBox(
            height: 600,
            child: TabBarView(children: [
              _buildOverviewTab(context),
              _buildLegalTab(context),
              _buildFinancialTab(context),
              _buildLeadershipTab(context),
              _buildProjectsTab(context),
              _buildPartnershipsTab(context),
              _buildContactTab(context),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewTab(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _buildSectionTitle('About', context),
        _buildCard(context, Text(ngo.description)),
        if (ngo.mission != null) ...[
          const SizedBox(height: 16),
          _buildSectionTitle('Mission', context),
          _buildCard(context, Text(ngo.mission!))
        ],
        if (ngo.vision != null) ...[
          const SizedBox(height: 16),
          _buildSectionTitle('Vision', context),
          _buildCard(context, Text(ngo.vision!))
        ],
        if (ngo.targetCommunities != null &&
            ngo.targetCommunities!.isNotEmpty) ...[
          const SizedBox(height: 16),
          _buildSectionTitle('Target Communities', context),
          _buildCard(
              context,
              Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: ngo.targetCommunities!
                      .map((c) => Chip(label: Text(c)))
                      .toList())),
        ],
        if (ngo.impactMetrics != null) ...[
          const SizedBox(height: 16),
          _buildSectionTitle('Impact Metrics', context),
          _buildCard(
              context,
              Column(children: [
                _buildMetricRow(
                    Icons.people,
                    'Beneficiaries Reached',
                    ngo.impactMetrics!.beneficiariesReached.toString(),
                    context),
                const Divider(),
                _buildMetricRow(
                    Icons.assignment_turned_in,
                    'Projects Completed',
                    ngo.impactMetrics!.projectsCompleted.toString(),
                    context),
                const Divider(),
                _buildMetricRow(Icons.location_city, 'Communities Served',
                    ngo.impactMetrics!.communitiesServed.toString(), context),
              ])),
        ],
      ]),
    );
  }

  Widget _buildLegalTab(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _buildSectionTitle('Registration Information', context),
        _buildCard(
            context,
            Column(children: [
              if (ngo.registrationNumber != null)
                _buildInfoRow(
                    'Registration Number', ngo.registrationNumber!, context),
              if (ngo.legalStatus != null) ...[
                const Divider(),
                _buildInfoRow('Legal Status', ngo.legalStatus!, context)
              ],
              if (ngo.panNumber != null) ...[
                const Divider(),
                _buildInfoRow('PAN Number', ngo.panNumber!, context)
              ],
            ])),
        if (ngo.certificates != null && ngo.certificates!.isNotEmpty) ...[
          const SizedBox(height: 16),
          _buildSectionTitle('Certificates', context),
          _buildCard(
              context,
              Column(
                  children: ngo.certificates!
                      .map((cert) => ListTile(
                            leading: const Icon(Icons.verified),
                            title: Text(cert),
                            trailing: const Icon(Icons.download),
                          ))
                      .toList())),
        ],
      ]),
    );
  }

  Widget _buildFinancialTab(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        if (ngo.expenseBreakdown != null) ...[
          _buildSectionTitle('Expense Breakdown', context),
          _buildCard(
              context,
              Column(children: [
                _buildExpenseBar(
                    'Program Costs',
                    ngo.expenseBreakdown!.programPercentage,
                    Colors.green,
                    context),
                const SizedBox(height: 12),
                _buildExpenseBar(
                    'Admin Costs',
                    ngo.expenseBreakdown!.adminPercentage,
                    Colors.orange,
                    context),
                const SizedBox(height: 12),
                _buildExpenseBar(
                    'Fundraising Costs',
                    ngo.expenseBreakdown!.fundraisingPercentage,
                    Colors.blue,
                    context),
              ])),
          const SizedBox(height: 16),
        ],
        if (ngo.expenseBreakdown == null &&
            (ngo.financialReports == null || ngo.financialReports!.isEmpty))
          _buildCard(
              context,
              const Center(
                  child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Text('Financial information not available',
                          style: TextStyle(color: Colors.grey))))),
      ]),
    );
  }

  Widget _buildLeadershipTab(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        if (ngo.governanceStructure != null) ...[
          _buildSectionTitle('Governance Structure', context),
          _buildCard(context, Text(ngo.governanceStructure!)),
          const SizedBox(height: 16),
        ],
        if (ngo.boardMembers != null && ngo.boardMembers!.isNotEmpty) ...[
          _buildSectionTitle('Board Members & Trustees', context),
          ...ngo.boardMembers!.map((member) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildCard(
                    context,
                    ListTile(
                      leading: member.photoUrl != null
                          ? CircleAvatar(
                              backgroundImage: NetworkImage(member.photoUrl!))
                          : const CircleAvatar(child: Icon(Icons.person)),
                      title: Text(member.name,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(member.position,
                                style:
                                    const TextStyle(color: AppColors.primary)),
                            const SizedBox(height: 4),
                            Text(member.background),
                          ]),
                      isThreeLine: true,
                    )),
              )),
        ],
        if ((ngo.governanceStructure == null) &&
            (ngo.boardMembers == null || ngo.boardMembers!.isEmpty))
          _buildCard(
              context,
              const Center(
                  child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Text('Leadership information not available',
                          style: TextStyle(color: Colors.grey))))),
      ]),
    );
  }

  Widget _buildProjectsTab(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        if (ngo.projects != null && ngo.projects!.isNotEmpty)
          ...ngo.projects!.map((project) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _buildCard(
                    context,
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(children: [
                            Expanded(
                                child: Text(project.title,
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold))),
                            Chip(label: Text(project.status)),
                          ]),
                          const SizedBox(height: 8),
                          Text(project.description),
                          if (project.outcome != null) ...[
                            const SizedBox(height: 8),
                            Builder(builder: (ctx) {
                              final isDark =
                                  Theme.of(ctx).brightness == Brightness.dark;
                              return Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? Colors.green.withOpacity(0.15)
                                      : Colors.green.shade50,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(children: [
                                  const Icon(Icons.check_circle,
                                      color: Colors.green),
                                  const SizedBox(width: 8),
                                  Expanded(
                                      child: Text(
                                          'Outcome: ${project.outcome!}',
                                          style: TextStyle(
                                              color: isDark
                                                  ? Colors.green.shade300
                                                  : Colors.green.shade900))),
                                ]),
                              );
                            }),
                          ],
                        ])),
              ))
        else
          _buildCard(
              context,
              const Center(
                  child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Text('No projects available',
                          style: TextStyle(color: Colors.grey))))),
      ]),
    );
  }

  Widget _buildPartnershipsTab(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        if (ngo.reviews != null && ngo.reviews!.isNotEmpty) ...[
          _buildSectionTitle('Community Reviews', context),
          ...ngo.reviews!.map((review) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildCard(
                    context,
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(children: [
                            CircleAvatar(
                                child:
                                    Text(review.reviewerName[0].toUpperCase())),
                            const SizedBox(width: 12),
                            Expanded(
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                  Text(review.reviewerName,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  Row(children: [
                                    ...List.generate(
                                        5,
                                        (i) => Icon(
                                            i < review.rating.round()
                                                ? Icons.star
                                                : Icons.star_border,
                                            color: Colors.amber,
                                            size: 16)),
                                    const SizedBox(width: 8),
                                    Text(
                                        '${review.date.year}-${review.date.month}-${review.date.day}',
                                        style: const TextStyle(
                                            color: Colors.grey, fontSize: 12)),
                                  ]),
                                ])),
                          ]),
                          const SizedBox(height: 12),
                          Text(review.comment),
                        ])),
              )),
        ] else
          _buildCard(
              context,
              const Center(
                  child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Text('No partnerships or reviews available',
                          style: TextStyle(color: Colors.grey))))),
      ]),
    );
  }

  Widget _buildContactTab(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _buildSectionTitle('Contact Information', context),
        _buildCard(
            context,
            Column(children: [
              if (ngo.website != null)
                ListTile(
                    leading: const Icon(Icons.language),
                    title: const Text('Website'),
                    subtitle: Text(ngo.website!),
                    trailing: const Icon(Icons.open_in_new),
                    onTap: () => _launchURL(ngo.website!)),
              if (ngo.email != null) ...[
                const Divider(),
                ListTile(
                    leading: const Icon(Icons.email),
                    title: const Text('Email'),
                    subtitle: Text(ngo.email!),
                    trailing: const Icon(Icons.send),
                    onTap: () => _launchURL('mailto:${ngo.email}'))
              ],
              if (ngo.phone != null) ...[
                const Divider(),
                ListTile(
                    leading: const Icon(Icons.phone),
                    title: const Text('Phone'),
                    subtitle: Text(ngo.phone!),
                    trailing: const Icon(Icons.call),
                    onTap: () => _launchURL('tel:${ngo.phone}'))
              ],
              if (ngo.address != null) ...[
                const Divider(),
                ListTile(
                    leading: const Icon(Icons.location_on),
                    title: const Text('Address'),
                    subtitle: Text(ngo.address!),
                    trailing: const Icon(Icons.map))
              ],
            ])),
      ]),
    );
  }

  Widget _buildSectionTitle(String title, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(title,
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildCard(BuildContext context, Widget child,
      {double bottomMargin = 0}) {
    final theme = Theme.of(context);
    return Container(
      margin: EdgeInsets.only(bottom: bottomMargin),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 2))
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: child,
    );
  }

  Widget _buildInfoRow(String label, String value, BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(
            flex: 2,
            child: Text(label,
                style: theme.textTheme.bodySmall
                    ?.copyWith(fontWeight: FontWeight.bold))),
        Expanded(
            flex: 3, child: Text(value, style: theme.textTheme.bodyMedium)),
      ]),
    );
  }

  Widget _buildMetricRow(
      IconData icon, String label, String value, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(children: [
        Icon(icon, color: AppColors.primary),
        const SizedBox(width: 12),
        Expanded(child: Text(label)),
        Text(value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      ]),
    );
  }

  Widget _buildExpenseBar(
      String label, double percentage, Color color, BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        Text('${percentage.toStringAsFixed(1)}%',
            style: TextStyle(fontWeight: FontWeight.bold, color: color)),
      ]),
      const SizedBox(height: 8),
      ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: LinearProgressIndicator(
          value: percentage / 100,
          backgroundColor: isDark ? Colors.white12 : Colors.grey.shade200,
          valueColor: AlwaysStoppedAnimation<Color>(color),
          minHeight: 24,
        ),
      ),
    ]);
  }

  Widget _buildBottomBar(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, -2))
        ],
      ),
      child: Row(children: [
        Expanded(
            child: ElevatedButton.icon(
          icon: const Icon(Icons.volunteer_activism),
          label: const Text('Donate'),
          style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16)),
          onPressed: () {},
        )),
        const SizedBox(width: 12),
        OutlinedButton.icon(
          icon: const Icon(Icons.favorite_border),
          label: const Text('Follow'),
          style: OutlinedButton.styleFrom(
              padding:
                  const EdgeInsets.symmetric(vertical: 16, horizontal: 24)),
          onPressed: () {},
        ),
      ]),
    );
  }

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }
}
