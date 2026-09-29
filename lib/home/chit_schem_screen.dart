import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:siva_sakthi/calculator/subscription_plan_screen.dart';
import 'available_chit_screen.dart';

/// Chit Schemes Screen (Tab: Chits Schemes selected)
/// Figma: width: 360, height: 60 per row, border: 0.5px bottom #ADADAD
class ChitSchemScreen extends StatelessWidget {
  const ChitSchemScreen({super.key});

  static const List<Map<String, dynamic>> _schemes = [
    {'value': '₹ 1,00,000', 'members': 20, 'months': 20},
    {'value': '₹ 2,00,000', 'members': 20, 'months': 20},
    {'value': '₹ 3,00,000', 'members': 20, 'months': 20},
    {'value': '₹ 4,00,000', 'members': 20, 'months': 20},
    {'value': '₹ 5,00,000', 'members': 20, 'months': 20},
    {'value': '₹ 10,00,000', 'members': 20, 'months': 20},
    {'value': '₹ 15,00,000', 'members': 20, 'months': 20},
    {'value': '₹ 20,00,000', 'members': 20, 'months': 20},
    {'value': '₹ 25,00,000', 'members': 20, 'months': 20},
    {'value': '₹ 50,00,000', 'members': 20, 'months': 20},
  ];

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double scaleW = screenSize.width / 360.0;
    final double scaleH = screenSize.height / 800.0;

    final double topPadding = MediaQuery.of(context).padding.top;
    final double statusBarH = topPadding > 20 ? topPadding : 24.0;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Color(0xFF0D1519),
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: Color(0xFF0D1519),
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(56 * scaleH.clamp(0.85, 1.2) + statusBarH),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTopStatusBar(context, statusBarH),
              AppBar(
                primary: false,
                backgroundColor: const Color(0xFFF4F5F7),
                elevation: 0,
                scrolledUnderElevation: 0,
                toolbarHeight: 56 * scaleH.clamp(0.85, 1.2),
                systemOverlayStyle: const SystemUiOverlayStyle(
                  statusBarColor: Color(0xFF0D1519),
                  statusBarIconBrightness: Brightness.light,
                  statusBarBrightness: Brightness.dark,
                ),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Color(0xFF1E2638), size: 22),
                  onPressed: () => Navigator.of(context).maybePop(),
                ),
                titleSpacing: 0,
                title: Text(
                  'Chits Schemes',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF1E2638),
                    height: 1.0,
                    letterSpacing: 0,
                  ),
                ),
                actions: [
                  // Need Help ? button
                  GestureDetector(
                    onTap: () {
                      // Navigator.of(context).push(
                      //   MaterialPageRoute(builder: (_) => const ChatbotScreen()),
                      // );
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 14),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFD0D5DD), width: 0.8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            'assets/images/help_operator.png',
                            width: 14 * scaleW.clamp(0.85, 1.2),
                            height: 14 * scaleH.clamp(0.85, 1.2),
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.headset_mic, size: 14, color: Color(0xFF3C93F4)),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Need Help ?',
                            style: GoogleFonts.inter(
                              fontSize: 11 * scaleW.clamp(0.85, 1.1),
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF3C93F4),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  // Notification Bell
                  IconButton(
                    icon: Image.asset(
                      'assets/images/notification.png',
                      width: 20 * scaleW.clamp(0.85, 1.2),
                      height: 20 * scaleH.clamp(0.85, 1.2),
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.notifications_none, color: Color(0xFF1E2638)),
                    ),
                    onPressed: () {},
                  ),
                  const SizedBox(width: 6),
                ],
              ),
            ],
          ),
        ),
        body: Column(
          children: [

            // Tabs Row: Figma Component 2: width: 360, height: 52, top: 84px
            Container(
              height: 52,
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  bottom: BorderSide(color: Color(0xFFF4F5F7), width: 1.0),
                ),
              ),
              child: Row(
                children: [
                  // Tab 1: Chits Schemes (Active)
                  Expanded(
                    child: Container(
                      height: 52,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: Color(0xFFE2EFFF),
                        border: Border(
                          bottom: BorderSide(
                            color: Color(0xFF3C93F4),
                            width: 3.0,
                          ),
                        ),
                      ),
                      child: Text(
                        'Chits Schemes',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          height: 1.0,
                          letterSpacing: 0,
                          color: const Color(0xFF3C93F4),
                        ),
                      ),
                    ),
                  ),
                  // Tab 2: Available Chits (Inactive)
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).pushReplacement(
                          PageRouteBuilder(
                            pageBuilder: (_, _, _) =>
                                const AvailableChitScreen(),
                            transitionDuration: Duration.zero,
                          ),
                        );
                      },
                      child: Container(
                        height: 52,
                        alignment: Alignment.center,
                        color: Colors.white,
                        child: Text(
                          'Available Chits',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            height: 1.0,
                            letterSpacing: 0,
                            color: const Color(0xFF667085),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Table Header Row: width: 360, height: 50, border-radius: 4px, border: 1px solid #E5E7EB, bg: #FFFFFF
            Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: const Color(0xFFF4F5F7), width: 1.0),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      'Chit Value',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        height: 1.0,
                        color: const Color(0xFF1A1A1A),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Members',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        height: 1.0,
                        color: const Color(0xFF1A1A1A),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Months',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        height: 1.0,
                        color: const Color(0xFF1A1A1A),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 48,
                    child: Text(
                      'View',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        height: 1.0,
                        color: const Color(0xFF1A1A1A),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Gap between Header and first row showing light grey background
            Container(height: 3.0, color: const Color(0xFFF4F5F7)),

            // Table rows list: Light grey background with spaced white rectangle boxes
            Expanded(
              child: Container(
                color: const Color(0xFFF4F5F7),
                child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemCount: _schemes.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 3.0),
                  itemBuilder: (context, index) {
                    final item = _schemes[index];
                    return Container(
                      height: 60.0,
                      color: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          // Chit Value
                          Expanded(
                            flex: 3,
                            child: Text(
                              item['value'] as String,
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                height: 1.0,
                                letterSpacing: 0,
                                color: const Color(0xFF3C93F4),
                              ),
                            ),
                          ),
                          // Members
                          Expanded(
                            flex: 2,
                            child: Text(
                              '${item['members']}',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFF344054),
                              ),
                            ),
                          ),
                          // Months
                          Expanded(
                            flex: 2,
                            child: Text(
                              '${item['months']}',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFF344054),
                              ),
                            ),
                          ),
                          // View icon
                          SizedBox(
                            width: 48,
                            child: Center(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          SubscriptionPlanScreen(
                                        investmentAmount: (item['value']
                                                as String)
                                            .replaceAll('₹', '')
                                            .trim(),
                                        durationMonths:
                                            '${item['months']}',
                                      ),
                                    ),
                                  );
                                },
                                child: Image.asset(
                                  'assets/icons/eye.png',
                                  width: 22,
                                  height: 14,
                                  fit: BoxFit.contain,
                                  errorBuilder: (_, _, _) => const Icon(
                                    Icons.visibility_outlined,
                                    size: 22,
                                    color: Color(0xFF101828),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Top Status Bar widget matching SubscriptionPlanScreen (11:11 AM, icons, 5G, signal, battery 50%)
  Widget _buildTopStatusBar(BuildContext context, double statusBarH) {
    final Size screenSize = MediaQuery.of(context).size;
    final double scaleW = screenSize.width / 360.0;

    return Container(
      width: screenSize.width,
      height: statusBarH,
      color: const Color(0xFF0D1519),
      padding: EdgeInsets.symmetric(horizontal: 14 * scaleW.clamp(0.85, 1.2)),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left side: 11:11 AM, Camera, Chat bubble icons
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '11:11 AM',
                style: GoogleFonts.inter(
                  fontSize: 11.5 * scaleW.clamp(0.85, 1.2),
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  height: 1.0,
                ),
              ),
              SizedBox(width: 6 * scaleW.clamp(0.85, 1.2)),
              Icon(
                Icons.camera_alt_outlined,
                size: 13 * scaleW.clamp(0.85, 1.2),
                color: Colors.white.withValues(alpha: 0.9),
              ),
              SizedBox(width: 5 * scaleW.clamp(0.85, 1.2)),
              Icon(
                Icons.chat_bubble_outline_rounded,
                size: 12.5 * scaleW.clamp(0.85, 1.2),
                color: Colors.white.withValues(alpha: 0.9),
              ),
            ],
          ),

          // Right side: 5G, cellular signal, battery with 50%
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '5G',
                style: GoogleFonts.inter(
                  fontSize: 10.5 * scaleW.clamp(0.85, 1.2),
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  height: 1.0,
                ),
              ),
              SizedBox(width: 4 * scaleW.clamp(0.85, 1.2)),
              Icon(
                Icons.signal_cellular_alt,
                size: 13.5 * scaleW.clamp(0.85, 1.2),
                color: Colors.white,
              ),
              SizedBox(width: 5 * scaleW.clamp(0.85, 1.2)),
              // Battery icon
              Container(
                width: 19 * scaleW.clamp(0.85, 1.2),
                height: 9.5 * scaleW.clamp(0.85, 1.2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2.5),
                  border: Border.all(color: Colors.white, width: 1.1),
                ),
                padding: const EdgeInsets.all(1.2),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    width: 8 * scaleW.clamp(0.85, 1.2),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(1),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 4 * scaleW.clamp(0.85, 1.2)),
              Text(
                '50%',
                style: GoogleFonts.inter(
                  fontSize: 10.5 * scaleW.clamp(0.85, 1.2),
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  height: 1.0,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
