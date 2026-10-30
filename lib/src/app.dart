import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import 'auth/auth_controller.dart';
import 'auth/auth_pages.dart';
import 'locale_controller.dart';

class AppShell extends StatefulWidget {
  const AppShell({
    required this.localeController,
    required this.authController,
    super.key,
  });

  final LocaleController localeController;
  final AuthController authController;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _selectedIndex = 0;
  bool _accountRouteOpen = false;
  bool _recoveryRouteOpen = false;

  @override
  void initState() {
    super.initState();
    widget.authController.addListener(_handleAuthChange);
    WidgetsBinding.instance.addPostFrameCallback((_) => _handleAuthChange());
  }

  @override
  void dispose() {
    widget.authController.removeListener(_handleAuthChange);
    super.dispose();
  }

  void _handleAuthChange() {
    if (!mounted ||
        !widget.authController.recoveryRequested ||
        _accountRouteOpen ||
        _recoveryRouteOpen) {
      return;
    }
    _recoveryRouteOpen = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      Navigator.of(context)
          .push<void>(MaterialPageRoute<void>(
            builder: (_) => AuthPage(
              controller: widget.authController,
              initialMode: AuthPageMode.newPassword,
            ),
          ))
          .whenComplete(() => _recoveryRouteOpen = false);
    });
  }

  void _openAccount() {
    _accountRouteOpen = true;
    final page = widget.authController.isAuthenticated
        ? ProfilePage(controller: widget.authController)
        : AuthPage(controller: widget.authController);
    Navigator.of(context)
        .push<void>(MaterialPageRoute<void>(builder: (_) => page))
        .whenComplete(() => _accountRouteOpen = false);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final pages = [
      _HomePage(
        onOpenSettings: () => setState(() => _selectedIndex = 3),
        onOpenAccount: _openAccount,
        accountLabel: widget.authController.isAuthenticated
            ? l10n.manageAccount
            : l10n.accountTitle,
      ),
      _PlaceholderPage(title: l10n.learnTab, message: l10n.learnPlaceholder),
      _PlaceholderPage(
          title: l10n.servicesTab, message: l10n.servicesPlaceholder),
      _SettingsPage(
        localeController: widget.localeController,
        authController: widget.authController,
        onOpenAccount: _openAccount,
      ),
    ];
    return Scaffold(
      appBar: AppBar(title: Text(l10n.appTitle)),
      body: SafeArea(child: pages[_selectedIndex]),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) =>
            setState(() => _selectedIndex = index),
        destinations: [
          NavigationDestination(
              icon: const Icon(Icons.home_outlined), label: l10n.homeTab),
          NavigationDestination(
              icon: const Icon(Icons.menu_book_outlined), label: l10n.learnTab),
          NavigationDestination(
              icon: const Icon(Icons.local_hospital_outlined),
              label: l10n.servicesTab),
          NavigationDestination(
              icon: const Icon(Icons.settings_outlined),
              label: l10n.settingsTab),
        ],
      ),
    );
  }
}

class _HomePage extends StatelessWidget {
  const _HomePage({
    required this.onOpenSettings,
    required this.onOpenAccount,
    required this.accountLabel,
  });

  final VoidCallback onOpenSettings;
  final VoidCallback onOpenAccount;
  final String accountLabel;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const Icon(Icons.health_and_safety_outlined, size: 64),
        const SizedBox(height: 16),
        Text(l10n.welcomeTitle,
            style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 8),
        Text(l10n.welcomeBody),
        const SizedBox(height: 24),
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: FilledButton.icon(
            onPressed: onOpenAccount,
            icon: const Icon(Icons.person_outline),
            label: Text(accountLabel),
          ),
        ),
        const SizedBox(height: 24),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(l10n.foundationLabel,
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Text(l10n.foundationBody),
              const SizedBox(height: 8),
              TextButton.icon(
                onPressed: onOpenSettings,
                icon: const Icon(Icons.language),
                label: Text(l10n.languageTitle),
              ),
            ]),
          ),
        ),
      ],
    );
  }
}

class _PlaceholderPage extends StatelessWidget {
  const _PlaceholderPage({required this.title, required this.message});

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Icon(Icons.hourglass_empty, size: 48),
            const SizedBox(height: 16),
            Text(title, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(message, textAlign: TextAlign.center),
          ]),
        ),
      );
}

class _SettingsPage extends StatelessWidget {
  const _SettingsPage({
    required this.localeController,
    required this.authController,
    required this.onOpenAccount,
  });

  final LocaleController localeController;
  final AuthController authController;
  final VoidCallback onOpenAccount;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final selectedLanguage = localeController.locale.languageCode;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(l10n.settingsTab,
            style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 8),
        Text(l10n.settingsPlaceholder),
        const SizedBox(height: 16),
        Card(
          child: ListTile(
            leading: Icon(authController.isAuthenticated
                ? Icons.account_circle_outlined
                : Icons.person_outline),
            title: Text(authController.isAuthenticated
                ? l10n.profile
                : l10n.accountTitle),
            subtitle: Text(authController.isAuthenticated
                ? l10n.accountSignedInAs(authController.user?.email ?? '')
                : l10n.guestAccessDescription),
            trailing: const Icon(Icons.chevron_right),
            onTap: onOpenAccount,
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: ListTile(
            leading: const Icon(Icons.language),
            title: Text(l10n.languageTitle),
            subtitle: Text(l10n.languageDescription),
            trailing: DropdownButton<String>(
              value: selectedLanguage,
              onChanged: (value) {
                if (value != null) localeController.setLanguage(value);
              },
              items: [
                DropdownMenuItem(
                    value: 'en', child: Text(l10n.englishLanguage)),
                DropdownMenuItem(
                    value: 'am', child: Text(l10n.amharicLanguage)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
