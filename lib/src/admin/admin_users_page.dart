import 'package:flutter/material.dart';

import '../theme/app_glass_theme.dart';
import 'admin_controller.dart';
import 'admin_models.dart';

class AdminUsersPage extends StatefulWidget {
  const AdminUsersPage({
    required this.controller,
    super.key,
  });

  final AdminController controller;

  @override
  State<AdminUsersPage> createState() => _AdminUsersPageState();
}

class _AdminUsersPageState extends State<AdminUsersPage> {
  final _searchController = TextEditingController();
  String _search = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _changeRole(ManagedUser user) {
    showDialog<void>(
      context: context,
      builder: (ctx) {
        final glass = ctx.glassTheme;
        return AlertDialog(
          backgroundColor: glass.modalBackground,
          title: Text(
            'Change Role: ${user.displayName}',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: glass.titleText,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Student / Member'),
                leading: const Icon(Icons.school_rounded),
                onTap: () {
                  widget.controller.updateUserRole(user.id, 'student');
                  Navigator.of(ctx).pop();
                },
              ),
              ListTile(
                title: const Text('Counselor / Mentor'),
                leading: const Icon(Icons.support_agent_rounded),
                onTap: () {
                  widget.controller.updateUserRole(user.id, 'mentor');
                  Navigator.of(ctx).pop();
                },
              ),
              ListTile(
                title: const Text('Content Author'),
                leading: const Icon(Icons.edit_note_rounded),
                onTap: () {
                  widget.controller.updateUserRole(user.id, 'content_author');
                  Navigator.of(ctx).pop();
                },
              ),
              ListTile(
                title: const Text('Administrator'),
                leading: const Icon(Icons.admin_panel_settings_rounded,
                    color: Color(0xFF38BDF8)),
                onTap: () {
                  widget.controller.updateUserRole(user.id, 'admin');
                  Navigator.of(ctx).pop();
                },
              ),
            ],
          ),
        );
      },
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
        title: Text(
          isAmharic ? 'የተጠቃሚዎች ማስተዳደሪያ' : 'User Accounts Directory',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w800,
            color: glass.titleText,
          ),
        ),
      ),
      body: ListenableBuilder(
        listenable: widget.controller,
        builder: (context, _) {
          var users = widget.controller.users;
          if (_search.isNotEmpty) {
            final q = _search.toLowerCase();
            users = users.where((u) {
              return u.displayName.toLowerCase().contains(q) ||
                  u.email.toLowerCase().contains(q) ||
                  u.role.toLowerCase().contains(q);
            }).toList();
          }

          return Column(
            children: [
              Container(
                color: glass.appBarBackground,
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
                child: Container(
                  height: 44,
                  decoration: BoxDecoration(
                    color: glass.isDark
                        ? const Color(0xFF0F172A)
                        : const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: glass.isDark
                          ? const Color(0xFF1E293B)
                          : const Color(0xFFE2E8F0),
                    ),
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (v) => setState(() => _search = v.trim()),
                    style: TextStyle(fontSize: 13.5, color: glass.titleText),
                    decoration: InputDecoration(
                      hintText: 'Search by name, email, or role...',
                      hintStyle:
                          TextStyle(fontSize: 13, color: glass.subtitleText),
                      prefixIcon: Icon(Icons.search_rounded,
                          size: 20, color: glass.subtitleText),
                      suffixIcon: _search.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear_rounded, size: 18),
                              onPressed: () {
                                _searchController.clear();
                                setState(() => _search = '');
                              },
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: users.isEmpty
                    ? Center(
                        child: Text(
                          'No users found matching query.',
                          style: TextStyle(
                            fontSize: 14,
                            color: glass.subtitleText,
                          ),
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: users.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final u = users[index];
                          final isSuspended =
                              u.status == AccountStatus.suspended;

                          return Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: glass.cardBackground,
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: isSuspended
                                    ? const Color(0xFFEF4444)
                                        .withValues(alpha: 0.5)
                                    : glass.cardBorder,
                                width: 1.2,
                              ),
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 20,
                                  backgroundColor: u.isAdmin
                                      ? const Color(0xFF0284C7)
                                      : const Color(0xFF334155),
                                  child: Text(
                                    u.displayName.isNotEmpty
                                        ? u.displayName[0]
                                        : 'U',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            u.displayName,
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w800,
                                              color: glass.titleText,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 6, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: u.isAdmin
                                                  ? const Color(0xFF0284C7)
                                                      .withValues(alpha: 0.15)
                                                  : const Color(0xFF64748B)
                                                      .withValues(alpha: 0.15),
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                            child: Text(
                                              u.role.toUpperCase(),
                                              style: TextStyle(
                                                fontSize: 9.5,
                                                fontWeight: FontWeight.w800,
                                                color: u.isAdmin
                                                    ? const Color(0xFF38BDF8)
                                                    : glass.subtitleText,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        u.email,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: glass.subtitleText,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '🏛️ ${u.joinedClubCount} Clubs • 📝 ${u.completedQuizzesCount} Quizzes',
                                        style: const TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF0284C7),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                      Icons.manage_accounts_outlined,
                                      size: 20),
                                  tooltip: 'Change Role',
                                  onPressed: () => _changeRole(u),
                                ),
                                IconButton(
                                  icon: Icon(
                                    isSuspended
                                        ? Icons.check_circle_outline_rounded
                                        : Icons.block_rounded,
                                    size: 20,
                                    color: isSuspended
                                        ? const Color(0xFF10B981)
                                        : const Color(0xFFEF4444),
                                  ),
                                  tooltip: isSuspended
                                      ? 'Activate Account'
                                      : 'Suspend Account',
                                  onPressed: () =>
                                      widget.controller.toggleUserStatus(u.id),
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
