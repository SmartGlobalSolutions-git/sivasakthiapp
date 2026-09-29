import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:siva_sakthi/setting/need_help.dart';
import 'package:siva_sakthi/home/notification.dart';
import 'chit_statement_screen.dart';
import 'passbook_screen.dart';
import 'chit_model.dart';

class ChitDetailScreen extends StatelessWidget {
  final ChitData chit;

  const ChitDetailScreen({super.key, required this.chit});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              children: [
                // Back button (arrow)
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Padding(
                    padding: EdgeInsets.only(right: 8.0),
                    child: Icon(
                      Icons.arrow_back,
                      color: Color(0xFF000000),
                      size: 24,
                    ),
                  ),
                ),
                // Title "Chits detail"
                Text(
                  'Chits detail',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF000000),
                  ),
                ),
                const Spacer(),
                // Need Help Button
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const NeedHelpScreen(),
                      ),
                    );
                  },
                  child: Image.asset(
                    'assets/chit/Group 146124.png',
                    height: 33,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(width: 14),
                // Notification Icon
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const NotificationScreen(),
                      ),
                    );
                  },
                  child: Image.asset(
                    'assets/chit/notification-svgrepo-com (1) 1.png',
                    width: 22,
                    height: 22,
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
        child: Column(
          children: [
            // 1. Top Summary Card
            _buildChitSummaryCard(),
            const SizedBox(height: 14),

            // 2. Running Balance Box
            _buildRunningBalanceCard(),
            const SizedBox(height: 14),

            // 3. Chit Duration Card
            _buildChitDurationCard(),
            const SizedBox(height: 16),

            // 4. Bottom Action Buttons: Chit Statement & Passbook
            _buildBottomActionButtons(context),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // 1. Top Summary Card (Figma: Height 166px, Radius 8px)
  Widget _buildChitSummaryCard() {
    return Container(
      height: 166,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFFE2E5E8),
          width: 0.6,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            offset: Offset(0, 4),
            blurRadius: 6,
            spreadRadius: 0,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(7.4),
        child: Column(
          children: [
            // Upper Header Part (Height: 52px)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
              child: Row(
                children: [
                  // Green Avatar Icon: Overlay.png
                  Image.asset(
                    'assets/chit/Overlay.png',
                    width: 38,
                    height: 38,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(width: 12),
                  // Chandru & GROUP CODE 10 - L
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          chit.name,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1E293B),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Text(
                              'GROUP CODE  ',
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF64748B),
                                letterSpacing: 0.3,
                              ),
                            ),
                            Text(
                              chit.groupCode,
                              style: GoogleFonts.inter(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF0F172A),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Status Badge: Unpriced
                  Image.asset(
                    'assets/chit/Status Badge (2).png',
                    height: 26,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
            ),

            // Divider: 1px #F1F5F9
            Container(height: 1, color: const Color(0xFFF1F5F9)),

            // Middle Values Row
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
              child: Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Chit Value',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF64748B),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          chit.chitValue,
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF00875A), // Green
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Start Date',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF64748B),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          chit.startDate,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1E293B),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'End Date',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF64748B),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          chit.endDate,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1E293B),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),

            // Bottom Strip: Total Divident (Larger crisp text)
            Container(
              height: 44,
              width: double.infinity,
              color: const Color(0xFFF3F5FF),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRect(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      widthFactor: 0.12,
                      child: Image.asset(
                        'assets/chit/Group 1000004930.png',
                        height: 24,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'TOTAL DIVIDENT  ',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF003D29),
                      letterSpacing: 0.5,
                    ),
                  ),
                  Text(
                    '₹ 1,00,000',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF003D29),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 2. Running Balance Card (Height: 44px, Bg: #FFF8DE, Border: 1px #D9AB07)
  Widget _buildRunningBalanceCard() {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8DE),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFFD9AB07),
          width: 1.0,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/chit/coin_plant.png',
            height: 26,
            fit: BoxFit.contain,
          ),
          const SizedBox(width: 10),
          Row(
            children: [
              Text(
                'RUNNING BALANCE  ',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF065F46),
                  letterSpacing: 0.5,
                ),
              ),
              Text(
                '₹ 5,00,000',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF065F46),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 3. Chit Duration Card (Height: 123px, Radius: 16px, Border: 1px #F1F5F9)
  Widget _buildChitDurationCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFF1F5F9),
          width: 1.0,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0C000000),
            offset: Offset(0, 4),
            blurRadius: 8,
            spreadRadius: 0,
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Chit Duration',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF0F172A),
                ),
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '6',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF0F172A),
                      ),
                    ),
                    TextSpan(
                      text: ' / 20 Months',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          LayoutBuilder(
            builder: (context, constraints) {
              final totalWidth = constraints.maxWidth;
              final double progressPercent = 6.0 / 20.0;
              final double pinWidth = 36.0;
              final double pinHeight = 25.0;
              final double pinLeft = (totalWidth * progressPercent) - (pinWidth / 2);

              return Column(
                children: [
                  // 6th Month Pin Indicator with Downward Arrow
                  SizedBox(
                    height: 27,
                    width: totalWidth,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Positioned(
                          left: pinLeft.clamp(0.0, totalWidth - pinWidth),
                          bottom: 2,
                          child: Image.asset(
                            'assets/chit/Current Pin (Month 6 Indicator).png',
                            width: pinWidth,
                            height: pinHeight,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Progress Track
                  Stack(
                    children: [
                      Container(
                        height: 6,
                        width: totalWidth,
                        decoration: BoxDecoration(
                          color: const Color(0xFFEEF2F6),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                      Container(
                        height: 6,
                        width: totalWidth * progressPercent,
                        decoration: BoxDecoration(
                          color: const Color(0xFF00A86B),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),

                  // Milestones
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildMilestoneDot('1', isCompleted: true),
                      _buildMilestoneDot('5', isCompleted: true),
                      _buildMilestoneDot('10', isCompleted: false),
                      _buildMilestoneDot('15', isCompleted: false),
                      _buildMilestoneDot('20', isCompleted: false),
                    ],
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 12),

          // Footer
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Color(0xFF00A86B),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                'Completed: 6',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1E293B),
                ),
              ),
              const Spacer(),
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Color(0xFFCBD5E1),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                'Remaining: 14',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF64748B),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMilestoneDot(String label, {required bool isCompleted}) {
    final dotColor = isCompleted ? const Color(0xFF00A86B) : const Color(0xFFCBD5E1);
    final textColor = isCompleted ? const Color(0xFF007A4D) : const Color(0xFF94A3B8);

    return Column(
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            color: dotColor,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: isCompleted ? FontWeight.w700 : FontWeight.w500,
            color: textColor,
          ),
        ),
      ],
    );
  }

  // 4. Bottom Action Buttons: Chit Statement & Passbook (155 x 80)
  Widget _buildBottomActionButtons(BuildContext context) {
    return Row(
      children: [
        // Left Button: Chit Statement (155 x 80, #4558A2)
        Expanded(
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChitStatementScreen(chit: chit),
                ),
              );
            },
            child: Container(
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xFF4558A2), // Figma #4558A2
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        Icons.description,
                        color: Colors.white,
                        size: 22,
                      ),
                      Icon(
                        Icons.chevron_right,
                        color: Colors.white,
                        size: 22,
                      ),
                    ],
                  ),
                  Text(
                    'Chit Statement',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 14),

        // Right Button: Passbook (155 x 80, #5BAE34)
        Expanded(
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PassbookScreen(chit: chit),
                ),
              );
            },
            child: Container(
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xFF5BAE34),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        Icons.menu_book_rounded,
                        color: Colors.white,
                        size: 22,
                      ),
                      Icon(
                        Icons.chevron_right,
                        color: Colors.white,
                        size: 22,
                      ),
                    ],
                  ),
                  Text(
                    'Passbook',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
