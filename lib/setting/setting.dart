import 'package:flutter/material.dart';
import 'package:siva_sakthi/setting/about_us.dart';
import 'package:siva_sakthi/setting/faq_screen.dart';
import 'package:siva_sakthi/setting/privacy_policy.dart';
import 'package:siva_sakthi/setting/profile_info.dart';
import 'package:siva_sakthi/setting/terms_condition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:siva_sakthi/OnBoarding_Screen/login_screen.dart';

// ==========================================================
// SETTING SCREEN
// ==========================================================

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  String _selectedLanguage = 'English';

  static const Color kTitle = Color(0xFF000000);
  static const Color kSectionLabel = Color(0xFF6B7280);
  static const Color kRowText = Color(0xFF1A1C1C);
  static const Color kRowValue = Color(0xFF9CA3AF);
  static const Color kRed = Color(0xFFE11D48);
  static const Color kPageBg = Color(0xFFF5F5F6);
  static const Color kDivider = Color(0xFFEDEDED);

  void _showLanguageBottomSheet(BuildContext context) {
    final languages = ['English', 'Tamil (தமிழ்)'];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFCBD5E1),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Select Language',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF111827),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Color(0xFFF1F5F9),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      size: 18,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...languages.map((lang) {
              final isSelected = _selectedLanguage == lang ||
                  (_selectedLanguage == 'English' && lang == 'English') ||
                  (_selectedLanguage == 'Tamil' && lang.startsWith('Tamil'));

              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFFF0F7FF) : const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? const Color(0xFF3C93F4) : const Color(0xFFE2E8F0),
                    width: isSelected ? 1.5 : 1.0,
                  ),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                  title: Text(
                    lang,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                      color: isSelected ? const Color(0xFF3C93F4) : const Color(0xFF1E2638),
                    ),
                  ),
                  trailing: isSelected
                      ? const Icon(Icons.check_circle, color: Color(0xFF3C93F4), size: 22)
                      : const Icon(Icons.radio_button_unchecked, color: Color(0xFF94A3B8), size: 22),
                  onTap: () {
                    setState(() {
                      _selectedLanguage = lang.contains('Tamil') ? 'Tamil' : 'English';
                    });
                    Navigator.pop(context);
                  },
                ),
              );
            }),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text(
            'Logout',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Are you sure you want to logout?',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          'No',
                          style: TextStyle(
                            color: Color(0xFF64748B),
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.clear();
                        
                        if (!context.mounted) return;
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (_) => const LoginScreen()),
                          (route) => false,
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF3C93F4),
                          borderRadius: BorderRadius.circular(12),
                        
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          'Yes',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;
    final sh = MediaQuery.of(context).size.height;
    double w(double v) => sw * (v / 360);
    double h(double v) => sh * (v / 812);

    return Scaffold(
      backgroundColor: kPageBg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: kTitle, size: w(22)),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        titleSpacing: 0,
        title: Text(
          'Setting',
          style: TextStyle(
            color: kTitle,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        padding: EdgeInsets.fromLTRB(w(16), h(12), w(16), h(24)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionLabel(w, h, 'ACCOUNT'),
            _sectionCard(w, h, [
              _settingRow(
                w,
                h,
                iconAsset: 'assets/setting/profile.png',
                fallback: Icons.person_outline,
                title: 'Profile Information',
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => ProfileScreen()),
                  ),
              ),
            ]),
            SizedBox(height: h(18)),

            _sectionLabel(w, h, 'APP PREFERENCES'),
            _sectionCard(w, h, [
              _settingRow(
                w,
                h,
                iconAsset: 'assets/setting/lan.png',
                fallback: Icons.language,
                title: 'Language',
                value: _selectedLanguage,
                onTap: () => _showLanguageBottomSheet(context),
              ),
            ]),
            SizedBox(height: h(18)),

            _sectionLabel(w, h, 'SECURITY & PRIVACY'),
            _sectionCard(w, h, [
              _settingRow(
                w,
                h,
                iconAsset: 'assets/setting/privacy.png',
                fallback: Icons.shield_outlined,
                title: 'Privacy Policy',
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const PrivacyPolicyScreen()),
                ),
              ),
              _rowDivider(w),
              _settingRow(
                w,
                h,
                iconAsset: 'assets/setting/terms.png',
                fallback: Icons.description_outlined,
                title: 'Terms & Conditions',
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const TermsConditionScreen()),
                ),
              ),
            ]),
            SizedBox(height: h(18)),

            _sectionLabel(w, h, 'SUPPORT'),
            _sectionCard(w, h, [
              _settingRow(
                w,
                h,
                iconAsset: 'assets/setting/help_sup.png',
                fallback: Icons.support_agent_outlined,
                title: 'Help & Support',
                onTap: () {},
              ),
              _rowDivider(w),
              _settingRow(
                w,
                h,
                iconAsset: 'assets/setting/faq.png',
                fallback: Icons.help_outline,
                title: 'FAQs',
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const FaqScreen()),
                ),
              ),
            ]),
            SizedBox(height: h(18)),

            _sectionLabel(w, h, 'ABOUT'),
            _sectionCard(w, h, [
              _settingRow(
                w,
                h,
                iconAsset: 'assets/setting/about.png',
                fallback: Icons.info_outline,
                title: 'About Us',
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const AboutUsScreen()),
                ),
              ),
              _rowDivider(w),
              _settingRow(
                w,
                h,
                iconAsset: 'assets/setting/app.png',
                fallback: Icons.verified_outlined,
                title: 'App Version',
                value: '1.0.0',
                showChevron: false,
                onTap: null,
              ),
            ]),
            SizedBox(height: h(18)),

            _sectionCard(w, h, [_logoutRow(w, h, onTap: () => _showLogoutDialog(context))]),
          ],
        ),
      ),
    );
  }

  // ---------------- Section label ----------------
  Widget _sectionLabel(
      double Function(double) w,
      double Function(double) h,
      String text,
      ) {
    return Padding(
      padding: EdgeInsets.only(left: w(4), bottom: h(6)),
      child: Text(
        text,
        style: TextStyle(
          color: kSectionLabel,
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.55,
        ),
      ),
    );
  }

  // ---------------- Card wrapper ----------------
  Widget _sectionCard(
      double Function(double) w,
      double Function(double) h,
      List<Widget> children,
      ) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(w(12)),
      ),
      child: Column(children: children),
    );
  }

  Widget _rowDivider(double Function(double) w) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: w(16)),
      child: Divider(height: 1, thickness: 1, color: kDivider),
    );
  }

  // ---------------- Setting row ----------------
  Widget _settingRow(
      double Function(double) w,
      double Function(double) h, {
        required String iconAsset,
        required IconData fallback,
        required String title,
        String? value,
        bool showChevron = true,
        VoidCallback? onTap,
      }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: w(16), vertical: h(14)),
        child: Row(
          children: [
            Image.asset(
              iconAsset,
              width: w(18),
              height: w(18),
              errorBuilder: (context, error, stackTrace) =>
                  Icon(fallback, size: w(22), color: const Color(0xFF1E7A52)),
            ),
            SizedBox(width: w(14)),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: kRowText,
                  fontSize: w(14.66),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            if (value != null)
              Padding(
                padding: EdgeInsets.only(right: w(8)),
                child: Text(
                  value,
                  style: TextStyle(
                    color: kRowValue,
                    fontSize: w(14),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            if (showChevron)
              Icon(Icons.chevron_right, size: w(20), color: kRowValue),
          ],
        ),
      ),
    );
  }

  // ---------------- Logout row ----------------
  Widget _logoutRow(
      double Function(double) w,
      double Function(double) h, {
        required VoidCallback onTap,
      }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: h(16)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/settings/logout.png',
              width: w(18),
              height: w(18),
              errorBuilder: (context, error, stackTrace) =>
                  Icon(Icons.logout, size: w(18), color: kRed),
            ),
            SizedBox(width: w(8)),
            Text(
              'Logout',
              style: TextStyle(
                color: kRed,
                fontSize: w(18.32),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}