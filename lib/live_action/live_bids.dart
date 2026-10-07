import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'bidder_selector.dart';

class LiveBidsScreen extends StatelessWidget {
  const LiveBidsScreen({super.key});

  final List<BidderItem> _bidders = const [
    BidderItem(
      initials: 'SK',
      name: 'S.Kumar',
      phone: '+91 98765 43210',
      time: '11:06 AM',
      avatarBg: Color(0xFFDBEAFE),
      avatarText: Color(0xFF2563EB),
      isLatest: true,
    ),
    BidderItem(
      initials: 'RP',
      name: 'R.Priya',
      phone: '+91 87654 32109',
      time: '11:05 AM',
      avatarBg: Color(0xFFF3E8FF),
      avatarText: Color(0xFF9333EA),
      isLatest: false,
    ),
    BidderItem(
      initials: 'MK',
      name: 'M.Karthik',
      phone: '+91 76543 21098',
      time: '11:02 AM',
      avatarBg: Color(0xFFFCE7F3),
      avatarText: Color(0xFFDB2777),
      isLatest: false,
    ),
    BidderItem(
      initials: 'AS',
      name: 'A.Saranya',
      phone: '+91 65432 10987',
      time: '10:58 AM',
      avatarBg: Color(0xFFDCFCE7),
      avatarText: Color(0xFF16A34A),
      isLatest: false,
    ),
    BidderItem(
      initials: 'VR',
      name: 'V.Ramesh',
      phone: '+91 54321 09876',
      time: '10:55 AM',
      avatarBg: Color(0xFFE0E7FF),
      avatarText: Color(0xFF4F46E5),
      isLatest: false,
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
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text(
          'Live Auction',
          style: GoogleFonts.manrope(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Timer Banner (Increased text sizes)
                    Container(
                      width: double.infinity,
                      height: 160,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD4E7FE),
                        borderRadius: BorderRadius.circular(16),
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFFD9ECFF),
                            Color(0xFFC7E2FE),
                          ],
                        ),
                      ),
                      alignment: Alignment.centerLeft,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF097E4A),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF097E4A).withValues(alpha: 0.25),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Time Remaining',
                              style: GoogleFonts.inter(
                                color: const Color(0xFFD1FAE5),
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: const [
                                Text(
                                  '1:36',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                SizedBox(width: 5),
                                Text(
                                  'Min',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    // Member Statistics Card with larger text
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header: Icon + Member Statistics
                          Row(
                            children: [
                              Image.asset(
                                'assets/liveauction/live_member.png',
                                width: 24,
                                height: 24,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.people, size: 24, color: Color(0xff266FAF)),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Member Statistics',
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF1E293B),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          // Three statistics items
                          Row(
                            children: [
                              // 1. Active
                              Expanded(
                                child: _buildStatItem(
                                  iconPath: 'assets/liveauction/live_active.png',
                                  iconBgColor: const Color(0xFFE8F8F0),
                                  fallbackIcon: Icons.check_circle,
                                  fallbackColor: Colors.green,
                                  label: 'Active',
                                  value: '1',
                                  valueColor: Color(0xff266FAF),
                                ),
                              ),

                              // Vertical Divider
                              Container(
                                width: 1,
                                height: 60,
                                color: const Color(0xFFF1F3F5),
                              ),

                              // 2. Total Bids
                              Expanded(
                                child: _buildStatItem(
                                  iconPath: 'assets/liveauction/live_bid.png',
                                  iconBgColor: const Color(0xFFFDE8E8),
                                  fallbackIcon: Icons.pan_tool,
                                  fallbackColor: Colors.redAccent,
                                  label: 'Total Bids',
                                  value: '5',
                                  valueColor: const Color(0xFF6366F1),
                                ),
                              ),

                              // Vertical Divider
                              Container(
                                width: 1,
                                height: 60,
                                color: const Color(0xFFF1F3F5),
                              ),

                              // 3. Participated Members
                              Expanded(
                                child: _buildStatItem(
                                  iconPath: 'assets/liveauction/live_participated.png',
                                  iconBgColor: const Color(0xFFEBF3FE),
                                  fallbackIcon: Icons.groups,
                                  fallbackColor: Colors.orange,
                                  label: 'Participated\nMembers',
                                  value: '4',
                                  valueColor: Color(0xff266FAF),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Section Title Row: Live Bids(5) & Latest First Filter
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Live Bids(5)',
                          style: GoogleFonts.inriaSans(
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF1D1D1D),
                            decoration: TextDecoration.underline,
                            decorationThickness: 1.5,
                          ),
                        ),

                        // Filter Pill: Vector.png + Latest First + Arrow Down
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 7,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: const Color(0xFFE2E8F0),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                'assets/liveauction/Vector.png',
                                width: 15,
                                height: 15,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.swap_vert, size: 15, color: Color(0xff266FAF)),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Latest First',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF334155),
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(
                                Icons.keyboard_arrow_down,
                                size: 18,
                                color: Color(0xFF94A3B8),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // List of Bidder Cards
                    ..._bidders.map((bidder) => _buildBidderCard(bidder)),
                  ],
                ),
              ),
            ),

            // Bottom CALL OFF Button
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const BidderSelectorScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff266FAF),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'CALL OFF',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBidderCard(BidderItem bidder) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: bidder.isLatest
            ? Border.all(color: const Color(0xFF86EFAC), width: 1.3)
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Initials Avatar
          CircleAvatar(
            radius: 22,
            backgroundColor: bidder.avatarBg,
            child: Text(
              bidder.initials,
              style: TextStyle(
                color: bidder.avatarText,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Name and Phone number
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  bidder.name,
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  bidder.phone,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),

          // Time and Latest badge
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/liveauction/SVG.png',
                    width: 15,
                    height: 15,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.access_time, size: 15, color: Color(0xFF94A3B8)),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    bidder.time,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
              if (bidder.isLatest) ...[
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCFCE7),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'Latest',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF16A34A),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required String iconPath,
    required Color iconBgColor,
    required IconData fallbackIcon,
    required Color fallbackColor,
    required String label,
    required String value,
    required Color valueColor,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: iconBgColor,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Image.asset(
            iconPath,
            width: 24,
            height: 24,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) =>
                Icon(fallbackIcon, size: 22, color: fallbackColor),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF64748B),
            height: 1.15,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}

class BidderItem {
  final String initials;
  final String name;
  final String phone;
  final String time;
  final Color avatarBg;
  final Color avatarText;
  final bool isLatest;

  const BidderItem({
    required this.initials,
    required this.name,
    required this.phone,
    required this.time,
    required this.avatarBg,
    required this.avatarText,
    required this.isLatest,
  });
}
