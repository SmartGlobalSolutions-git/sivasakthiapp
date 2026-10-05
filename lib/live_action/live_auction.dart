import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:siva_sakthi/bottom_navbar.dart';
import 'package:siva_sakthi/home/home.dart';

import 'live_bids.dart';

class LiveAuctionScreen extends StatefulWidget {
  const LiveAuctionScreen({super.key});

  @override
  State<LiveAuctionScreen> createState() => _LiveAuctionScreenState();
}

class _LiveAuctionScreenState extends State<LiveAuctionScreen> {
  final List<AuctionItem> _auctionItems = [
    AuctionItem(
      roomTitle: 'Live Auction Room',
      startTime: '2:30 PM',
      groupName: 'ssc001',
      dateMonth: '14 June',
      amount: '₹ 10,00,000',
    ),
    AuctionItem(
      roomTitle: 'Live Auction Room',
      startTime: '2:30 PM',
      groupName: 'ssc003',
      dateMonth: '14 Sep',
      amount: '₹ 10,00,000',
    ),
    AuctionItem(
      roomTitle: 'Live Auction Room',
      startTime: '2:30 PM',
      groupName: 'ssc003',
      dateMonth: '14 Sep',
      amount: '₹ 10,00,000',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black, size: 22),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const SivaSakthiHomeScreen()),
              (route) => false,
            );
          },
        ),
        title: Text(
          'Live Auction',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        itemCount: _auctionItems.length,
        itemBuilder: (context, index) {
          final item = _auctionItems[index];
          return _buildAuctionCard(item);
        },
      ),
      bottomNavigationBar: MainIconeFrames(
        currentIndex: 2,
        onTabSelected: (index) =>
            MainIconeFrames.navigateToTab(context, 2, index),
      ),
    );
  }

  Widget _buildAuctionCard(AuctionItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      height: 180,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            // Right Side Image (Ellipse 457.png) filling the card from top, right, bottom
            Positioned(
              top: 0,
              bottom: 0,
              right: 0,
              width: 145,
              child: Image.asset(
                'assets/liveauction/live_bg.png',
                fit: BoxFit.cover,
                alignment: Alignment.centerRight,
                errorBuilder: (context, error, stackTrace) =>
                    const SizedBox.shrink(),
              ),
            ),

            // Join Button positioned over the image with white border
            Positioned(
              right: 60,
              bottom: 20,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(22),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LiveBidsScreen(),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 7.5,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF13B156),
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color: Colors.white, width: 2.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.12),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'Join',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Left Side Content
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 138, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Header Row: Gavel icon & Room title
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/liveauction/live_act_room.png',
                        width: 38,
                        height: 38,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(
                              Icons.gavel,
                              size: 32,
                              color: Colors.orange,
                            ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              item.roomTitle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFF000000),
                              ),
                            ),
                            const SizedBox(height: 2),
                            RichText(
                              text: TextSpan(
                                text: 'Starts at ',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: const Color(0xFF475569),
                                  fontWeight: FontWeight.w400,
                                ),
                                children: [
                                  TextSpan(
                                    text: item.startTime,
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      color: const Color(0xFF018F48),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 4),

                  // Info items list matching Figma (Label 12px Regular, Value 16px SemiBold)
                  _buildInfoRow(
                    iconPath: 'assets/liveauction/live_group.png',
                    fallbackIcon: Icons.group,
                    label: 'Group Name: ',
                    value: item.groupName,
                    valueColor: const Color(0xFF1F2937),
                  ),
                  _buildInfoRow(
                    iconPath: 'assets/liveauction/live_date.png',
                    fallbackIcon: Icons.calendar_month,
                    label: 'Date/Month: ',
                    value: item.dateMonth,
                    valueColor: const Color(0xFF5850EC),
                  ),
                  _buildInfoRow(
                    iconPath: 'assets/liveauction/live_amount.png',
                    fallbackIcon: Icons.currency_rupee,
                    label: 'Amount: ',
                    value: item.amount,
                    valueColor: const Color(0xFF1E3A8A),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required String iconPath,
    required IconData fallbackIcon,
    required String label,
    required String value,
    required Color valueColor,
  }) {
    return Row(
      children: [
        Image.asset(
          iconPath,
          width: 24,
          height: 24,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) =>
              Icon(fallbackIcon, size: 22, color: Colors.blueGrey),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              text: label,
              style: GoogleFonts.inter(
                fontSize: 12,
                color: const Color(0xFF475569),
                fontWeight: FontWeight.w400,
              ),
              children: [
                TextSpan(
                  text: value,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: valueColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class AuctionItem {
  final String roomTitle;
  final String startTime;
  final String groupName;
  final String dateMonth;
  final String amount;

  AuctionItem({
    required this.roomTitle,
    required this.startTime,
    required this.groupName,
    required this.dateMonth,
    required this.amount,
  });
}
