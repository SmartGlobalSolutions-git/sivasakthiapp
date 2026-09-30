import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:siva_sakthi/new_user/new_calculator.dart';
import 'package:siva_sakthi/chat_bot/chat.dart';

class NewUserMenuScreen extends StatelessWidget {
  const NewUserMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scaleW = (MediaQuery.of(context).size.width / 360.0).clamp(0.85, 1.25);

    return Drawer(
      backgroundColor: Colors.white,
      width: 313 * scaleW,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header: Hello / User + Need Help? ──
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 19 * scaleW,
                vertical: 16 * scaleW,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // User avatar profile (width: 33, height: 33, border: 1px solid #DDDDDD, inner icon: 14.65 x 18.33)
                  Container(
                    width: 33 * scaleW,
                    height: 33 * scaleW,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      border: Border.all(
                        color: const Color(0xFFDDDDDD),
                        width: 1,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: 14.65 * scaleW,
                      height: 18.33 * scaleW,
                      child: const FittedBox(
                        fit: BoxFit.contain,
                        child: Icon(
                          Icons.person,
                          color: Color(0xFF9E9E9E),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 7 * scaleW),
                  // Hello / User text (Figma exact: left: 56px, Inter 10px #000000CC 400 & Inter 14px #000000 500)
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Hello',
                          textAlign: TextAlign.left,
                          maxLines: 1,
                          style: GoogleFonts.inter(
                            fontSize: 10 * scaleW,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xCC000000),
                            height: 1.0,
                          ),
                        ),
                        SizedBox(height: 5 * scaleW),
                        Text(
                          'User',
                          textAlign: TextAlign.left,
                          maxLines: 1,
                          style: GoogleFonts.inter(
                            fontSize: 14 * scaleW,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF000000),
                            height: 1.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Need Help ? button (matching subscription_plan_screen)
                  GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Support representative will contact you soon!'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: (8 * scaleW).clamp(6.0, 12.0),
                        vertical: (4 * scaleW).clamp(3.0, 6.0),
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16 * scaleW),
                        border: Border.all(
                          color: const Color(0xFFD0D5DD),
                          width: 0.8,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            'assets/images/help_operator.png',
                            width: 14 * scaleW,
                            height: 14 * scaleW,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) => const Icon(
                              Icons.headset_mic,
                              size: 14,
                              color: Color(0xFF3C93F4),
                            ),
                          ),
                          SizedBox(width: 4 * scaleW),
                          Text(
                            'Need Help ?',
                            style: GoogleFonts.inter(
                              fontSize: (11 * scaleW).clamp(9.5, 13.0),
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF018F46),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 14 * scaleW),

            // ── Card 1: Profile, Calculator, Chatbot (Figma: width: 275, height: 162, radius: 14px, top: 88, left: 19) ──
            Center(
              child: Container(
                width: 275 * scaleW,
                height: 162 * scaleW,
                padding: EdgeInsets.symmetric(
                  horizontal: 16 * scaleW,
                  vertical: 16 * scaleW,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF4F5F7),
                  borderRadius: BorderRadius.circular(14 * scaleW),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildCardMenuItem(
                      context,
                      iconAsset: 'assets/images/profile_menu.png',
                      fallbackIcon: Icons.person_outline,
                      label: 'Profile',
                      scaleW: scaleW,
                      onTap: () => Navigator.pop(context),
                    ),
                    _buildCardMenuItem(
                      context,
                      iconAsset: 'assets/images/calc_menu.png',
                      fallbackIcon: Icons.calculate_outlined,
                      label: 'Calculator',
                      scaleW: scaleW,
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const CalculatorScreen_new()),
                        );
                      },
                    ),
                    _buildCardMenuItem(
                      context,
                      iconAsset: 'assets/images/chatbot_menu.png',
                      fallbackIcon: Icons.smart_toy_outlined,
                      label: 'Chatbot',
                      scaleW: scaleW,
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ChatbotScreen()),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 11 * scaleW),

            // ── Card 2: Settings, Rewards & Achievements (Figma: width: 275, height: 101, radius: 14px, top: 261, left: 19) ──
            Center(
              child: Container(
                width: 275 * scaleW,
                height: 101 * scaleW,
                padding: EdgeInsets.symmetric(
                  horizontal: 16 * scaleW,
                  vertical: 16 * scaleW,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF4F5F7),
                  borderRadius: BorderRadius.circular(14 * scaleW),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildCardMenuItem(
                      context,
                      iconAsset: 'assets/images/settings_menu.png',
                      fallbackIcon: Icons.settings_outlined,
                      label: 'Settings',
                      scaleW: scaleW,
                      onTap: () => Navigator.pop(context),
                    ),
                    _buildCardMenuItem(
                      context,
                      iconAsset: 'assets/images/rewards_menu.png',
                      fallbackIcon: Icons.emoji_events_outlined,
                      label: 'Rewards & Achievements',
                      scaleW: scaleW,
                      onTap: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
            ),

            const Spacer(),

            // ── Footer: App version ──
            Center(
              child: Padding(
                padding: EdgeInsets.only(bottom: 20 * scaleW),
                child: Text(
                  'App V1.0125',
                  style: GoogleFonts.inter(
                    fontSize: 11 * scaleW,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF9CA3AF),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Card menu item (Figma exact row: height: 27, icon: 27x27, single-line left-aligned text)
  Widget _buildCardMenuItem(
      BuildContext context, {
        required String iconAsset,
        required IconData fallbackIcon,
        required String label,
        required double scaleW,
        required VoidCallback onTap,
      }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8 * scaleW),
      child: SizedBox(
        height: 27 * scaleW,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // White circular icon wrapper (width: 27, height: 27)
            Container(
              width: 27 * scaleW,
              height: 27 * scaleW,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Image.asset(
                  iconAsset,
                  width: 16 * scaleW,
                  height: 16 * scaleW,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => Icon(
                    fallbackIcon,
                    size: 15 * scaleW,
                    color: const Color(0xFF1F2937),
                  ),
                ),
              ),
            ),
            SizedBox(width: 10 * scaleW),
            Expanded(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  label,
                  maxLines: 1,
                  softWrap: false,
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontSize: 14 * scaleW,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF111827),
                    height: 1.0,
                  ),
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              size: 16 * scaleW,
              color: const Color(0xFF374151),
            ),
          ],
        ),
      ),
    );
  }
}
