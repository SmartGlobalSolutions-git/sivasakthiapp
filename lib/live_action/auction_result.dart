import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AuctionResultScreen extends StatefulWidget {
  final bool initialIsWinner;

  const AuctionResultScreen({
    super.key,
    this.initialIsWinner = true,
  });

  @override
  State<AuctionResultScreen> createState() => _AuctionResultScreenState();
}

class _AuctionResultScreenState extends State<AuctionResultScreen> {
  late bool _isWinner;

  @override
  void initState() {
    super.initState();
    _isWinner = widget.initialIsWinner;
  }

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
        actions: [
          // Toggle to preview both screens (Winner view & Participant view)
          TextButton.icon(
            onPressed: () {
              setState(() {
                _isWinner = !_isWinner;
              });
            },
            icon: Icon(
              _isWinner ? Icons.person_outline : Icons.emoji_events_outlined,
              size: 20,
              color: const Color(0xFF2563EB),
            ),
            label: Text(
              _isWinner ? 'View Participant' : 'View Winner',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2563EB),
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Timer Banner (Increased text size)
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
                              const Icon(Icons.people, size: 24, color: Colors.blue),
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
                            valueColor: const Color(0xFF2563EB),
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
                            valueColor: const Color(0xFF2563EB),
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
                              const Icon(Icons.swap_vert, size: 15, color: Color(0xFF2563EB)),
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

              const SizedBox(height: 28),

              // Switch between Screen 1 (Winner) and Screen 2 (You Didn't win)
              if (_isWinner) _buildWinnerView() else _buildParticipantView(),
            ],
          ),
        ),
      ),
    );
  }

  // SCREEN 1: Winner Screen
  Widget _buildWinnerView() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 10),

          // Trophy image (image 1315.png)
          Image.asset(
            'assets/liveauction/live_winner.png',
            width: 160,
            height: 160,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.emoji_events, size: 120, color: Colors.amber),
          ),

          const SizedBox(height: 22),

          // "Winner" text in green (Enlarged)
          const Text(
            'Winner',
            style: TextStyle(
              fontSize: 29,
              fontWeight: FontWeight.bold,
              color: Color(0xFF16A34A),
              letterSpacing: 0.2,
            ),
          ),

          const SizedBox(height: 8),

          // S.Kumar - +91 98765 43210 (Enlarged)
          RichText(
            text: const TextSpan(
              text: 'S.Kumar ',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
              children: [
                TextSpan(
                  text: '- +91 98765 43210',
                  style: TextStyle(
                    fontSize: 15.5,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  // SCREEN 2: Participant View (You Didn't win this auction)
  Widget _buildParticipantView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 10),

        // Sad thumbs-down emoji (image 1317.png)
        Image.asset(
          'assets/liveauction/live_lost.png',
          width: 100,
          height: 100,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) =>
              const Icon(Icons.thumb_down, size: 80, color: Colors.orange),
        ),

        const SizedBox(height: 18),

        // "You Didn’t win this auction" (Enlarged)
        const Text(
          "You Didn’t win this auction",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E293B),
          ),
        ),

        const SizedBox(height: 6),

        // "Better luck next time!" (Enlarged)
        const Text(
          'Better luck next time!',
          style: TextStyle(
            fontSize: 15.5,
            fontWeight: FontWeight.w400,
            color: Color(0xFF6B7280),
          ),
        ),

        const SizedBox(height: 28),

        // Winner Highlight Card (Green container)
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: const Color(0xFFDCFCE7),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Image.asset(
                'assets/liveauction/live_winner.png',
                width: 68,
                height: 68,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.emoji_events, size: 55, color: Colors.amber),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Winner',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF16A34A),
                      ),
                    ),
                    const SizedBox(height: 4),
                    RichText(
                      text: const TextSpan(
                        text: 'S.Kumar ',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                        children: [
                          TextSpan(
                            text: '- +91 98765 43210',
                            style: TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF64748B),
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
        ),

        const SizedBox(height: 14),

        // Thank You Banner (Gold/Beige container)
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            color: const Color(0xFFF6E8B9),
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.center,
          child: const Text(
            'Thank you for participating in\nthis auction',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF715216),
              height: 1.3,
            ),
          ),
        ),

        const SizedBox(height: 30),
      ],
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
