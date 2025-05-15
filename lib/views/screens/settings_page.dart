import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:read_the_label/theme/app_theme.dart';
import 'package:read_the_label/views/screens/profile_page.dart';
import 'package:read_the_label/views/screens/privacy_page.dart';
import 'package:read_the_label/views/screens/pin_setup_screen.dart';
import 'package:read_the_label/viewmodels/theme_view_model.dart';
import 'package:read_the_label/viewmodels/language_view_model.dart';
import 'package:read_the_label/viewmodels/pin_view_model.dart';
import 'package:read_the_label/services/language_service.dart';
import 'package:read_the_label/l10n/app_localizations.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeVM = Provider.of<ThemeViewModel>(context);
    final languageVM = Provider.of<LanguageViewModel>(context);
    final pinVM = Provider.of<PinViewModel>(context);
    final l10n = AppLocalizations.of(context);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).padding.bottom + 80,
          top: MediaQuery.of(context).padding.top + 10,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                l10n.settings,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
            _buildSettingsSection(
              context,
              'Preferences',
              [
                _buildSettingsTile(
                  context,
                  l10n.darkMode,
                  Icons.dark_mode,
                  trailing: Switch(
                    value: themeVM.themeMode == ThemeMode.dark,
                    onChanged: (value) => themeVM.toggleTheme(),
                  ),
                ),
                _buildSettingsTile(
                  context,
                  l10n.language,
                  Icons.language,
                  trailing: Consumer<LanguageViewModel>(
                    builder: (context, languageVM, _) {
                      return DropdownButton<String>(
                        value: languageVM.locale.languageCode,
                        items: languageVM.availableLanguages.map((lang) {
                          return DropdownMenuItem<String>(
                            value: lang['code'],
                            child: Text(lang['name']!),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            languageVM.setLanguage(Locale(newValue));
                          }
                        },
                      );
                    },
                  ),
                ),
                _buildSettingsTile(
                  context,
                  l10n.notifications,
                  Icons.notifications,
                  trailing: Switch(
                    value: true,
                    onChanged: (value) {
                      // TODO: Implement notifications toggle
                    },
                  ),
                ),
              ],
            ),
            _buildSettingsSection(
              context,
              l10n.security,
              [
                Consumer<PinViewModel>(
                  builder: (context, pinVM, _) {
                    return _buildSettingsTile(
                      context,
                      l10n.pinCode,
                      Icons.lock,
                      trailing: Switch(
                        value: pinVM.isPinEnabled,
                        onChanged: (value) {
                          if (value) {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const PinSetupScreen(),
                              ),
                            );
                          } else {
                            pinVM.removePin();
                          }
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
            _buildSettingsSection(
              context,
              'Account',
              [
                _buildSettingsTile(
                  context,
                  l10n.profile,
                  Icons.person,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const ProfilePage(),
                      ),
                    );
                  },
                ),
                _buildSettingsTile(
                  context,
                  l10n.privacy,
                  Icons.privacy_tip,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const PrivacyPage(),
                      ),
                    );
                  },
                ),
              ],
            ),
            _buildSettingsSection(
              context,
              'About',
              [
                _buildSettingsTile(
                  context,
                  l10n.version,
                  Icons.info,
                  trailing: const Text('1.0.0'),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => _StubPage(title: l10n.version, text: 'App version: 1.0.0'),
                      ),
                    );
                  },
                ),
                _buildSettingsTile(
                  context,
                  l10n.termsOfService,
                  Icons.description,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => _StubPage(
                          title: l10n.termsOfService,
                          text: 'By using this app, you agree to abide by all applicable laws and regulations. The app is provided as-is without any warranties. We reserve the right to update these terms at any time. Continued use of the app constitutes acceptance of any changes to the terms. For questions, contact support.',
                        ),
                      ),
                    );
                  },
                ),
                _buildSettingsTile(
                  context,
                  l10n.privacyPolicy,
                  Icons.policy,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => _StubPage(
                          title: l10n.privacyPolicy,
                          text: 'We respect your privacy and are committed to protecting your personal information. We only collect data necessary to provide and improve our services. Your data will not be shared with third parties except as required by law. You may review, update, or delete your information at any time. For more details, contact support.',
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsSection(
    BuildContext context,
    String title,
    List<Widget> children,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            title,
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
            ),
          ),
        ),
        ...children,
        const Divider(),
      ],
    );
  }

  Widget _buildSettingsTile(
    BuildContext context,
    String title,
    IconData icon, {
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: Theme.of(context).colorScheme.primary,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurface,
          fontFamily: 'Poppins',
        ),
      ),
      trailing: trailing,
      onTap: onTap,
    );
  }
}

class _StubPage extends StatelessWidget {
  final String title;
  final String text;
  const _StubPage({required this.title, required this.text});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Text(text, style: const TextStyle(fontSize: 18)),
        ),
      ),
    );
  }
} 