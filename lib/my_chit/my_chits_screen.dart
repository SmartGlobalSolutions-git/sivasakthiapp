import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:siva_sakthi/my_chit/chit_model.dart';
import 'package:siva_sakthi/setting/need_help.dart';
import 'package:siva_sakthi/home/notification.dart';
import 'chit_detail_screen.dart';

class MyChitsScreen extends StatelessWidget {
  const MyChitsScreen({super.key});

  final List<ChitData> _chits = const [
    ChitData(
      name: 'Chandru',
      groupCode: '10 - L',
      isPrized: false,
      chitValue: '₹ 10,00,000',
      startDate: '01 Jan 2024',
      endDate: '31 Aug 2025',
    ),
    ChitData(
      name: 'Chandru',
      groupCode: '10 - L',
      isPrized: true,
      chitValue: '₹ 10,00,000',
      startDate: '01 Jan 2024',
      endDate: '31 Aug 2025',
    ),
    ChitData(
      name: 'Chandru',
      groupCode: '10 - L',
      isPrized: false,
      chitValue: '₹ 10,00,000',
      startDate: '01 Jan 2024',
      endDate: '31 Aug 2025',
    ),
    ChitData(
      name: 'Chandru',
      groupCode: '10 - L',
      isPrized: false,
      chitValue: '₹ 10,00,000',
      startDate: '01 Jan 2024',
      endDate: '31 Aug 2025',
    ),
  ];

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
                    // Back action
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
                // Title "My Chits" - Inter 16px, Weight 600, Color #000000
                Text(
                  'My Chits',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF000000),
                  ),
                ),
                const Spacer(),
                // "Need Help ?" button - Blue
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
      body: ListView.builder(
        padding: const EdgeInsets.only(top: 14, bottom: 20),
        itemCount: _chits.length,
        itemBuilder: (context, index) {
          final chit = _chits[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ChitCardWidget(
              chit: chit,
              onViewDetail: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChitDetailScreen(chit: chit),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class ChitCardWidget extends StatelessWidget {
  final ChitData chit;
  final VoidCallback onViewDetail;

  const ChitCardWidget({
    super.key,
    required this.chit,
    required this.onViewDetail,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 143,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFF3C93F4),
          width: 0.6,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            offset: Offset(0, 4),
            blurRadius: 4,
            spreadRadius: 0,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(7.4),
        child: Stack(
          children: [
            // 1. Top Left: Active Badge Asset - exact size 63x54
            Positioned(
              top: 0,
              left: 0,
              width: 63,
              height: 54,
              child: Image.asset(
                'assets/chit/Group 1000004910.png',
                width: 63,
                height: 54,
                fit: BoxFit.fill,
              ),
            ),

            // Top Middle: Chandru & GROUP CODE 10 - L
            Positioned(
              top: 0,
              left: 75,
              right: 120,
              height: 54,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
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

            // Top Right: Status Badge (Non-prized or Prized)
            Positioned(
              top: 14,
              right: 12,
              child: Image.asset(
                chit.isPrized
                    ? 'assets/chit/Status Badge (1).png'
                    : 'assets/chit/Status Badge.png',
                height: 26,
                fit: BoxFit.contain,
              ),
            ),

            // 2. Horizontal Divider: Height 1px, Top 54px, Color #F1F5F9
            Positioned(
              top: 54,
              left: 0,
              right: 0,
              height: 1,
              child: Container(
                color: const Color(0xFFF1F5F9),
              ),
            ),

            // 3. Chit Value & Dates Grid
            Positioned(
              top: 63,
              left: 14,
              right: 14,
              height: 39,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Column 1: Chit Value
                  Expanded(
                    flex: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Chit Value',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF64748B),
                            height: 1.0,
                          ),
                        ),
                        Text(
                          chit.chitValue,
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF1D61D2),
                            height: 1.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Column 2: Start Date
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Start Date',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF64748B),
                            height: 1.0,
                          ),
                        ),
                        Text(
                          chit.startDate,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1E293B),
                            height: 1.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Column 3: End Date
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'End Date',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF64748B),
                            height: 1.0,
                          ),
                        ),
                        Text(
                          chit.endDate,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1E293B),
                            height: 1.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // 4. View Detail -> button
            Positioned(
              right: 14,
              bottom: 10,
              child: GestureDetector(
                onTap: onViewDetail,
                child: Image.asset(
                  'assets/chit/Group 1000004834.png',
                  height: 15,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
