import 'package:flutter/material.dart';
import 'package:siva_sakthi/setting/about_us.dart';
import 'package:siva_sakthi/setting/faq_screen.dart';
import 'package:siva_sakthi/setting/privacy_policy.dart';
import 'package:siva_sakthi/setting/profile_info.dart';
import 'package:siva_sakthi/setting/terms_condition.dart';


// ==========================================================
// SETTING SCREEN
// ==========================================================

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  static const Color kTitle = Color(0xFF000000);
  static const Color kSectionLabel = Color(0xFF6B7280);
  static const Color kRowText = Color(0xFF1A1C1C);
  static const Color kRowValue = Color(0xFF9CA3AF);
  static const Color kRed = Color(0xFFE11D48);
  static const Color kPageBg = Color(0xFFF5F5F6);
  static const Color kDivider = Color(0xFFEDEDED);

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
                value: 'English',
                onTap: () {},
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

            _sectionCard(w, h, [_logoutRow(w, h, onTap: () {})]),
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