import 'package:flutter/material.dart';

import '../theme/app_glass_theme.dart';
import 'admin_articles_page.dart';
import 'admin_clubs_page.dart';
import 'admin_controller.dart';
import 'admin_facilities_page.dart';
import 'admin_mentors_page.dart';
import 'admin_modules_page.dart';
import 'admin_quizzes_page.dart';
import 'admin_users_page.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({
    required this.controller,
    super.key,
  });

  final AdminController controller;

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  @override
  void initState() {
    super.initState();
    widget.controller.loadDashboard();
  }

  Widget _buildMetricCard({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String count,
    required Color color,
    required VoidCallback onTap,
  }) {
    final glass = context.glassTheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: glass.cardBackground,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: glass.cardBorder, width: 1.2),
          boxShadow: glass.cardShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: color, size: 18),
                ),
                Text(
                  count,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: glass.titleText,
                  ),
                ),
              ],
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: glass.subtitleText,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    final glass = context.glassTheme;
    return Container(
      decoration: BoxDecoration(
        color: glass.cardBackground,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: glass.cardBorder, width: 1.2),
      ),
      child: Material(
        color: Colors.transparent,
        child: ListTile(
          onTap: onTap,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          title: Text(
            title,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: glass.titleText,
            ),
          ),
          subtitle: Text(
            subtitle,
            style: TextStyle(
              fontSize: 12,
              color: glass.subtitleText,
            ),
          ),
          trailing: Icon(Icons.chevron_right_rounded,
              color: glass.subtitleText, size: 22),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final glass = context.glassTheme;
    final isAmharic = Localizations.localeOf(context).languageCode == 'am';

    return Scaffold(
      backgroundColor: glass.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: glass.appBarBackground,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: glass.titleText),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isAmharic ? 'የአስተዳዳሪ ማዕከል' : 'Executive Admin Console',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: glass.titleText,
              ),
            ),
            Text(
              widget.controller.currentAdminEmail.isNotEmpty
                  ? widget.controller.currentAdminEmail
                  : 'natnaelzemene21@gmail.com',
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Color(0xFF38BDF8),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh_rounded, color: glass.titleText),
            tooltip: 'Refresh',
            onPressed: () => widget.controller.loadDashboard(),
          ),
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: Color(0xFFEF4444)),
            tooltip: 'Sign Out',
            onPressed: () {
              widget.controller.signOut();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: widget.controller,
        builder: (context, _) {
          final m = widget.controller.metrics;
          final auditLogs = widget.controller.auditLogs;

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
            children: [
              // Welcome Banner
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0284C7), Color(0xFF0369A1)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF0284C7).withValues(alpha: 0.3),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(Icons.dashboard_customize_rounded,
                          color: Colors.white, size: 28),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isAmharic
                                ? 'እንኳን ወደ የእኛ ጤና አስተዳዳሪ ማዕከል መጡ'
                                : 'Yegna Health Dynamic Management',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            isAmharic
                                ? 'ክበቦችን፣ ጥያቄዎችን፣ ሞጁሎችን እና ይዘቶችን በቀጥታ ያስተዳድሩ'
                                : 'Live control over clubs, quizzes, questions & directories',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.85),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Metrics Grid
              Text(
                isAmharic ? 'የስርዓት ቁልፍ መረጃዎች' : 'SYSTEM OVERVIEW',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: glass.isDark
                      ? const Color(0xFF38BDF8)
                      : const Color(0xFF005A71),
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 10),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 2.1,
                children: [
                  _buildMetricCard(
                    context: context,
                    icon: Icons.groups_rounded,
                    label: isAmharic ? 'የተማሪዎች ክበቦች' : 'Student Clubs',
                    count: '${m?.studentClubs ?? 4}',
                    color: const Color(0xFF10B981),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) =>
                            AdminClubsPage(controller: widget.controller),
                      ),
                    ),
                  ),
                  _buildMetricCard(
                    context: context,
                    icon: Icons.quiz_rounded,
                    label: isAmharic ? 'የፈተና ጥያቄዎች' : 'Quiz Questions',
                    count: '${m?.quizQuestions ?? 2}',
                    color: const Color(0xFF38BDF8),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) =>
                            AdminQuizzesPage(controller: widget.controller),
                      ),
                    ),
                  ),
                  _buildMetricCard(
                    context: context,
                    icon: Icons.menu_book_rounded,
                    label: isAmharic ? 'የትምህርት ሞጁሎች' : 'Learning Modules',
                    count: '${m?.learningModules ?? 1}',
                    color: const Color(0xFFF59E0B),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) =>
                            AdminModulesPage(controller: widget.controller),
                      ),
                    ),
                  ),
                  _buildMetricCard(
                    context: context,
                    icon: Icons.article_rounded,
                    label: isAmharic ? 'የጤና ፅሁፎች' : 'Published Articles',
                    count: '${m?.activeArticles ?? 1}',
                    color: const Color(0xFF8B5CF6),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) =>
                            AdminArticlesPage(controller: widget.controller),
                      ),
                    ),
                  ),
                  _buildMetricCard(
                    context: context,
                    icon: Icons.local_hospital_rounded,
                    label: isAmharic ? 'የጤና ተቋማት' : 'Health Facilities',
                    count: '${m?.verifiedFacilities ?? 1}',
                    color: const Color(0xFF06B6D4),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) =>
                            AdminFacilitiesPage(controller: widget.controller),
                      ),
                    ),
                  ),
                  _buildMetricCard(
                    context: context,
                    icon: Icons.people_alt_rounded,
                    label: isAmharic ? 'አማካሪዎች' : 'Peer Mentors',
                    count: '${m?.counselorMentors ?? 1}',
                    color: const Color(0xFFEC4899),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) =>
                            AdminMentorsPage(controller: widget.controller),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Management Tools Section
              Text(
                isAmharic ? 'የአስተዳደር ክፍሎች' : 'MANAGEMENT DIRECTORIES',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: glass.isDark
                      ? const Color(0xFF38BDF8)
                      : const Color(0xFF005A71),
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 10),
              _buildNavTile(
                context: context,
                icon: Icons.groups_rounded,
                title: isAmharic ? 'የተማሪዎች ክበቦች' : 'Student Health Clubs',
                subtitle: isAmharic
                    ? 'አዳዲስ ክበቦችን ማከል፣ ማሻሻል እና የአባላት ዝርዝር ማየት'
                    : 'Create clubs, assign mentors, view rosters',
                color: const Color(0xFF10B981),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) =>
                        AdminClubsPage(controller: widget.controller),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              _buildNavTile(
                context: context,
                icon: Icons.quiz_rounded,
                title: isAmharic ? 'የፈተና ጥያቄዎች ባንክ' : 'Quizzes & Question Bank',
                subtitle: isAmharic
                    ? 'ጥያቄዎችን ማከል፣ ማስወገድ፣ ትክክለኛ መልሶችን ማዘጋጀት'
                    : 'Manage questions, answer keys, explanations',
                color: const Color(0xFF38BDF8),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) =>
                        AdminQuizzesPage(controller: widget.controller),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              _buildNavTile(
                context: context,
                icon: Icons.menu_book_rounded,
                title: isAmharic ? 'የትምህርት ሞጁሎች' : 'Learning Modules CMS',
                subtitle: isAmharic
                    ? 'ሞጁሎችን እና የአኮርዲዮን ክፍሎችን ማስተዳደር'
                    : 'Create modules, edit reading accordions',
                color: const Color(0xFFF59E0B),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) =>
                        AdminModulesPage(controller: widget.controller),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              _buildNavTile(
                context: context,
                icon: Icons.article_rounded,
                title: isAmharic ? 'የጤና ፅሁፎች ማተሚያ' : 'Health Articles CMS',
                subtitle: isAmharic
                    ? 'የዶክተር ማስታወሻዎችን እና ፅሁፎችን ማተም'
                    : 'Publish doctor columns, guides, citations',
                color: const Color(0xFF8B5CF6),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) =>
                        AdminArticlesPage(controller: widget.controller),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              _buildNavTile(
                context: context,
                icon: Icons.local_hospital_rounded,
                title: isAmharic ? 'የጤና ተቋማት እና ካርታ' : 'Facilities & GPS Map',
                subtitle: isAmharic
                    ? 'ክሊኒኮችን፣ ጂፒኤስ መገኛዎችን እና አገልግሎቶችን ማስተዳደር'
                    : 'Register clinics, youth centers, coordinates',
                color: const Color(0xFF06B6D4),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) =>
                        AdminFacilitiesPage(controller: widget.controller),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              _buildNavTile(
                context: context,
                icon: Icons.people_alt_rounded,
                title: isAmharic ? 'አቻ አማካሪዎች' : 'Peer Mentors Directory',
                subtitle: isAmharic
                    ? 'የአማካሪዎችን ስልክ እና ቴሌግራም አድራሻ ማስተዳደር'
                    : 'Manage mentor contacts, phone, Telegram',
                color: const Color(0xFFEC4899),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) =>
                        AdminMentorsPage(controller: widget.controller),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              _buildNavTile(
                context: context,
                icon: Icons.manage_accounts_rounded,
                title: isAmharic ? 'የተጠቃሚ መለያዎች' : 'User Accounts & Roles',
                subtitle: isAmharic
                    ? 'የተጠቃሚ ሚናዎችን (Student, Mentor, Admin) ማስተካከል'
                    : 'Manage user roles, permissions, suspensions',
                color: const Color(0xFF64748B),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) =>
                        AdminUsersPage(controller: widget.controller),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Recent Audit Log Feed
              Text(
                isAmharic ? 'የቅርብ ጊዜ የአስተዳዳሪ እርምጃዎች' : 'RECENT ADMIN ACTIVITY',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: glass.isDark
                      ? const Color(0xFF38BDF8)
                      : const Color(0xFF005A71),
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: glass.cardBackground,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: glass.cardBorder, width: 1.2),
                ),
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(12),
                  itemCount: auditLogs.take(5).length,
                  separatorBuilder: (_, __) =>
                      Divider(height: 1, color: glass.divider),
                  itemBuilder: (context, index) {
                    final log = auditLogs[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 4),
                      child: Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Color(0xFF38BDF8),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  log.action,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: glass.titleText,
                                  ),
                                ),
                                Text(
                                  log.details,
                                  style: TextStyle(
                                    fontSize: 11.5,
                                    color: glass.subtitleText,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '${log.timestamp.hour}:${log.timestamp.minute.toString().padLeft(2, '0')}',
                            style: TextStyle(
                              fontSize: 11,
                              color: glass.subtitleText,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
