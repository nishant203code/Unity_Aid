import 'package:flutter/material.dart';
import '../../models/ngo_model.dart';
import 'package:url_launcher/url_launcher.dart';

class NGODetailPage extends StatelessWidget {
  final NGO ngo;

  const NGODetailPage({super.key, required this.ngo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(ngo.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // Share functionality
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(context),
            _buildTabSections(context),
          ],
        ),
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
            Theme.of(context).primaryColor.withOpacity(0.7),
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
            backgroundColor: Colors.white,
          ),
          const SizedBox(height: 16),
          Text(
            ngo.name,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.location_on, color: Colors.white70, size: 18),
              const SizedBox(width: 4),
              Text(
                ngo.location,
                style: const TextStyle(color: Colors.white70, fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (ngo.rating != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ...List.generate(
                  5,
                  (index) => Icon(
                    index < ngo.rating!.round()
                        ? Icons.star
                        : Icons.star_border,
                    color: Colors.amber,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${ngo.rating!.toStringAsFixed(1)} / 5.0',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatCard('Members', ngo.members.toString()),
              _buildStatCard('Followers', ngo.followers.toString()),
              if (ngo.impactMetrics != null)
                _buildStatCard('Beneficiaries',
                    ngo.impactMetrics!.beneficiariesReached.toString()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
          ),
        ],
      ),
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
            child: TabBarView(
              children: [
                _buildOverviewTab(),
                _buildLegalTab(),
                _buildFinancialTab(),
                _buildLeadershipTab(),
                _buildProjectsTab(),
                _buildPartnershipsTab(),
                _buildContactTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('About'),
          _buildCard(Text(ngo.description)),
          const SizedBox(height: 16),
          if (ngo.mission != null) ...[
            _buildSectionTitle('Mission'),
            _buildCard(Text(ngo.mission!)),
            const SizedBox(height: 16),
          ],
          if (ngo.vision != null) ...[
            _buildSectionTitle('Vision'),
            _buildCard(Text(ngo.vision!)),
            const SizedBox(height: 16),
          ],
          if (ngo.targetCommunities != null &&
              ngo.targetCommunities!.isNotEmpty) ...[
            _buildSectionTitle('Target Communities'),
            _buildCard(
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: ngo.targetCommunities!
                    .map((community) => Chip(label: Text(community)))
                    .toList(),
              ),
            ),
            const SizedBox(height: 16),
          ],
          if (ngo.projectTypes != null && ngo.projectTypes!.isNotEmpty) ...[
            _buildSectionTitle('Types of Projects'),
            _buildCard(
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: ngo.projectTypes!
                    .map((type) => Chip(
                          label: Text(type),
                          backgroundColor: Colors.blue.shade50,
                        ))
                    .toList(),
              ),
            ),
          ],
          if (ngo.impactMetrics != null) ...[
            const SizedBox(height: 16),
            _buildSectionTitle('Impact Metrics'),
            _buildCard(
              Column(
                children: [
                  _buildMetricRow(
                    Icons.people,
                    'Beneficiaries Reached',
                    ngo.impactMetrics!.beneficiariesReached.toString(),
                  ),
                  const Divider(),
                  _buildMetricRow(
                    Icons.assignment_turned_in,
                    'Projects Completed',
                    ngo.impactMetrics!.projectsCompleted.toString(),
                  ),
                  const Divider(),
                  _buildMetricRow(
                    Icons.location_city,
                    'Communities Served',
                    ngo.impactMetrics!.communitiesServed.toString(),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLegalTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Registration Information'),
          _buildCard(
            Column(
              children: [
                if (ngo.registrationNumber != null)
                  _buildInfoRow('Registration Number', ngo.registrationNumber!),
                if (ngo.legalStatus != null) ...[
                  const Divider(),
                  _buildInfoRow('Legal Status', ngo.legalStatus!),
                ],
                if (ngo.panNumber != null) ...[
                  const Divider(),
                  _buildInfoRow('PAN Number', ngo.panNumber!),
                ],
                if (ngo.tanNumber != null) ...[
                  const Divider(),
                  _buildInfoRow('TAN Number', ngo.tanNumber!),
                ],
              ],
            ),
          ),
          if (ngo.certificates != null && ngo.certificates!.isNotEmpty) ...[
            const SizedBox(height: 16),
            _buildSectionTitle('Certificates'),
            _buildCard(
              Column(
                children: ngo.certificates!
                    .map((cert) => ListTile(
                          leading: const Icon(Icons.verified),
                          title: Text(cert),
                          trailing: const Icon(Icons.download),
                          onTap: () {
                            // Download certificate
                          },
                        ))
                    .toList(),
              ),
            ),
          ],
          if (ngo.annualReports != null && ngo.annualReports!.isNotEmpty) ...[
            const SizedBox(height: 16),
            _buildSectionTitle('Annual Reports'),
            _buildCard(
              Column(
                children: ngo.annualReports!
                    .map((report) => ListTile(
                          leading: const Icon(Icons.description),
                          title: Text(report.title),
                          subtitle: Text('Year: ${report.year}'),
                          trailing: const Icon(Icons.open_in_new),
                          onTap: () {
                            // Open report URL
                          },
                        ))
                    .toList(),
              ),
            ),
          ],
          if ((ngo.registrationNumber == null &&
                  ngo.legalStatus == null &&
                  ngo.panNumber == null &&
                  ngo.tanNumber == null) &&
              (ngo.certificates == null || ngo.certificates!.isEmpty) &&
              (ngo.annualReports == null || ngo.annualReports!.isEmpty))
            _buildCard(
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(24.0),
                  child: Text(
                    'Legal information not available',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFinancialTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (ngo.expenseBreakdown != null) ...[
            _buildSectionTitle('Expense Breakdown'),
            _buildCard(
              Column(
                children: [
                  _buildExpenseBar(
                    'Program Costs',
                    ngo.expenseBreakdown!.programPercentage,
                    Colors.green,
                  ),
                  const SizedBox(height: 12),
                  _buildExpenseBar(
                    'Admin Costs',
                    ngo.expenseBreakdown!.adminPercentage,
                    Colors.orange,
                  ),
                  const SizedBox(height: 12),
                  _buildExpenseBar(
                    'Fundraising Costs',
                    ngo.expenseBreakdown!.fundraisingPercentage,
                    Colors.blue,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
          if (ngo.financialReports != null &&
              ngo.financialReports!.isNotEmpty) ...[
            _buildSectionTitle('Financial Reports'),
            _buildCard(
              Column(
                children: ngo.financialReports!
                    .map((report) => ExpansionTile(
                          leading: const Icon(Icons.account_balance),
                          title: Text('FY ${report.year}'),
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                children: [
                                  _buildInfoRow('Total Revenue',
                                      '₹${report.totalRevenue.toStringAsFixed(2)}'),
                                  const Divider(),
                                  _buildInfoRow('Total Expenses',
                                      '₹${report.totalExpenses.toStringAsFixed(2)}'),
                                  const SizedBox(height: 8),
                                  ElevatedButton.icon(
                                    icon: const Icon(Icons.download),
                                    label: const Text('Download Report'),
                                    onPressed: () {
                                      // Download report
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ))
                    .toList(),
              ),
            ),
            const SizedBox(height: 16),
          ],
          if (ngo.fundingSources != null && ngo.fundingSources!.isNotEmpty) ...[
            _buildSectionTitle('Funding Sources'),
            _buildCard(
              Column(
                children: ngo.fundingSources!
                    .map((source) => ListTile(
                          leading: const Icon(Icons.account_balance_wallet),
                          title: Text(source),
                        ))
                    .toList(),
              ),
            ),
            const SizedBox(height: 16),
          ],
          if (ngo.auditReports != null && ngo.auditReports!.isNotEmpty) ...[
            _buildSectionTitle('Audit Reports'),
            _buildCard(
              Column(
                children: ngo.auditReports!
                    .map((audit) => ListTile(
                          leading: const Icon(Icons.fact_check),
                          title: Text(audit),
                          trailing: const Icon(Icons.download),
                          onTap: () {
                            // Download audit report
                          },
                        ))
                    .toList(),
              ),
            ),
          ],
          if (ngo.expenseBreakdown == null &&
              (ngo.financialReports == null || ngo.financialReports!.isEmpty) &&
              (ngo.fundingSources == null || ngo.fundingSources!.isEmpty) &&
              (ngo.auditReports == null || ngo.auditReports!.isEmpty))
            _buildCard(
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(24.0),
                  child: Text(
                    'Financial information not available',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLeadershipTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (ngo.governanceStructure != null) ...[
            _buildSectionTitle('Governance Structure'),
            _buildCard(Text(ngo.governanceStructure!)),
            const SizedBox(height: 16),
          ],
          if (ngo.boardMembers != null && ngo.boardMembers!.isNotEmpty) ...[
            _buildSectionTitle('Board Members & Trustees'),
            ...ngo.boardMembers!.map((member) => _buildCard(
                  ListTile(
                    leading: member.photoUrl != null
                        ? CircleAvatar(
                            backgroundImage: NetworkImage(member.photoUrl!),
                          )
                        : const CircleAvatar(
                            child: Icon(Icons.person),
                          ),
                    title: Text(
                      member.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          member.position,
                          style: TextStyle(color: Colors.blue.shade700),
                        ),
                        const SizedBox(height: 4),
                        Text(member.background),
                      ],
                    ),
                    isThreeLine: true,
                  ),
                  bottomMargin: 12,
                )),
          ],
          if ((ngo.governanceStructure == null) &&
              (ngo.boardMembers == null || ngo.boardMembers!.isEmpty))
            _buildCard(
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(24.0),
                  child: Text(
                    'Leadership information not available',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildProjectsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (ngo.projects != null && ngo.projects!.isNotEmpty) ...[
            ...ngo.projects!.map((project) => _buildCard(
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              project.title,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Chip(
                            label: Text(project.status),
                            backgroundColor: project.status == 'Completed'
                                ? Colors.green.shade100
                                : Colors.blue.shade100,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(project.description),
                      const SizedBox(height: 12),
                      if (project.photos.isNotEmpty)
                        SizedBox(
                          height: 120,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: project.photos.length,
                            itemBuilder: (context, index) => Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  project.photos[index],
                                  width: 160,
                                  height: 120,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Icon(Icons.calendar_today,
                              size: 16, color: Colors.grey.shade600),
                          const SizedBox(width: 4),
                          Text(
                            'Started: ${project.startDate.year}-${project.startDate.month}-${project.startDate.day}',
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                          if (project.endDate != null) ...[
                            const SizedBox(width: 16),
                            Icon(Icons.event_available,
                                size: 16, color: Colors.grey.shade600),
                            const SizedBox(width: 4),
                            Text(
                              'Ended: ${project.endDate!.year}-${project.endDate!.month}-${project.endDate!.day}',
                              style: TextStyle(color: Colors.grey.shade600),
                            ),
                          ],
                        ],
                      ),
                      if (project.outcome != null) ...[
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.check_circle,
                                  color: Colors.green.shade700),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Outcome: ${project.outcome!}',
                                  style:
                                      TextStyle(color: Colors.green.shade900),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                  bottomMargin: 16,
                )),
            if (ngo.testimonials != null && ngo.testimonials!.isNotEmpty) ...[
              const SizedBox(height: 16),
              _buildSectionTitle('Testimonials'),
              ...ngo.testimonials!.map((testimonial) => _buildCard(
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.format_quote, color: Colors.blue.shade300),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            testimonial,
                            style: const TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                      ],
                    ),
                    bottomMargin: 12,
                  )),
            ],
          ] else
            _buildCard(
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(24.0),
                  child: Text(
                    'No projects available',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPartnershipsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (ngo.partnerships != null && ngo.partnerships!.isNotEmpty) ...[
            _buildSectionTitle('Partnerships'),
            ...ngo.partnerships!.map((partnership) => _buildCard(
                  ListTile(
                    leading: partnership.logoUrl != null
                        ? CircleAvatar(
                            backgroundImage: NetworkImage(partnership.logoUrl!),
                          )
                        : const CircleAvatar(
                            child: Icon(Icons.business),
                          ),
                    title: Text(
                      partnership.organizationName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(partnership.description),
                  ),
                  bottomMargin: 12,
                )),
            const SizedBox(height: 16),
          ],
          if (ngo.reviews != null && ngo.reviews!.isNotEmpty) ...[
            _buildSectionTitle('Community Reviews'),
            ...ngo.reviews!.map((review) => _buildCard(
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            child: Text(review.reviewerName[0].toUpperCase()),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  review.reviewerName,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                Row(
                                  children: [
                                    ...List.generate(
                                      5,
                                      (index) => Icon(
                                        index < review.rating.round()
                                            ? Icons.star
                                            : Icons.star_border,
                                        color: Colors.amber,
                                        size: 16,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      '${review.date.year}-${review.date.month}-${review.date.day}',
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(review.comment),
                    ],
                  ),
                  bottomMargin: 12,
                )),
          ],
          if (ngo.mediaMentions != null && ngo.mediaMentions!.isNotEmpty) ...[
            const SizedBox(height: 16),
            _buildSectionTitle('Media Mentions'),
            _buildCard(
              Column(
                children: ngo.mediaMentions!
                    .map((mention) => ListTile(
                          leading: const Icon(Icons.newspaper),
                          title: Text(mention),
                          trailing: const Icon(Icons.open_in_new),
                          onTap: () {
                            // Open media link
                          },
                        ))
                    .toList(),
              ),
            ),
          ],
          if ((ngo.partnerships == null || ngo.partnerships!.isEmpty) &&
              (ngo.reviews == null || ngo.reviews!.isEmpty) &&
              (ngo.mediaMentions == null || ngo.mediaMentions!.isEmpty))
            _buildCard(
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(24.0),
                  child: Text(
                    'No partnerships or reviews available',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildContactTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Contact Information'),
          _buildCard(
            Column(
              children: [
                if (ngo.website != null)
                  ListTile(
                    leading: const Icon(Icons.language),
                    title: const Text('Website'),
                    subtitle: Text(ngo.website!),
                    trailing: const Icon(Icons.open_in_new),
                    onTap: () {
                      _launchURL(ngo.website!);
                    },
                  ),
                if (ngo.email != null) ...[
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.email),
                    title: const Text('Email'),
                    subtitle: Text(ngo.email!),
                    trailing: const Icon(Icons.send),
                    onTap: () {
                      _launchURL('mailto:${ngo.email}');
                    },
                  ),
                ],
                if (ngo.phone != null) ...[
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.phone),
                    title: const Text('Phone'),
                    subtitle: Text(ngo.phone!),
                    trailing: const Icon(Icons.call),
                    onTap: () {
                      _launchURL('tel:${ngo.phone}');
                    },
                  ),
                ],
                if (ngo.address != null) ...[
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.location_on),
                    title: const Text('Address'),
                    subtitle: Text(ngo.address!),
                    trailing: const Icon(Icons.map),
                    onTap: () {
                      // Open in maps
                    },
                  ),
                ],
              ],
            ),
          ),
          if (ngo.socialMedia != null && ngo.socialMedia!.isNotEmpty) ...[
            const SizedBox(height: 16),
            _buildSectionTitle('Social Media'),
            _buildCard(
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: ngo.socialMedia!.entries.map((entry) {
                  IconData icon;
                  switch (entry.key.toLowerCase()) {
                    case 'facebook':
                      icon = Icons.facebook;
                      break;
                    case 'twitter':
                      icon = Icons.alternate_email;
                      break;
                    case 'instagram':
                      icon = Icons.photo_camera;
                      break;
                    case 'linkedin':
                      icon = Icons.business;
                      break;
                    default:
                      icon = Icons.link;
                  }
                  return ActionChip(
                    avatar: Icon(icon),
                    label: Text(entry.key),
                    onPressed: () {
                      _launchURL(entry.value);
                    },
                  );
                }).toList(),
              ),
            ),
          ],
          if (ngo.website == null &&
              ngo.email == null &&
              ngo.phone == null &&
              ngo.address == null &&
              (ngo.socialMedia == null || ngo.socialMedia!.isEmpty))
            _buildCard(
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(24.0),
                  child: Text(
                    'Contact information not available',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildCard(Widget child, {double bottomMargin = 0}) {
    return Container(
      margin: EdgeInsets.only(bottom: bottomMargin),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: child,
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(value),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue),
          const SizedBox(width: 12),
          Expanded(child: Text(label)),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpenseBar(String label, double percentage, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            Text(
              '${percentage.toStringAsFixed(1)}%',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: percentage / 100,
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 24,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              icon: const Icon(Icons.volunteer_activism),
              label: const Text('Donate'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: () {
                // Navigate to donate page
              },
            ),
          ),
          const SizedBox(width: 12),
          OutlinedButton.icon(
            icon: const Icon(Icons.favorite_border),
            label: const Text('Follow'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            ),
            onPressed: () {
              // Follow NGO
            },
          ),
        ],
      ),
    );
  }

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}
