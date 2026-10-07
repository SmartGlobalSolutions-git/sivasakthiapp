import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'auction_result.dart';

class BidderSelectorScreen extends StatefulWidget {
  const BidderSelectorScreen({super.key});

  @override
  State<BidderSelectorScreen> createState() => _BidderSelectorScreenState();
}

class _BidderSelectorScreenState extends State<BidderSelectorScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _spinController;
  late Animation<double> _spinAnimation;

  bool _isManualSpinning = false;
  double _currentAngle = 0.0;

  final List<WheelBidder> _bidders = const [
    WheelBidder(
      initials: 'SK',
      name: 'S.Kumar',
      sliceColor: Color(0xFFDCEEFE),
      avatarBg: Color(0xFFBFDBFE),
      avatarTextColor: Color(0xff266FAF),
    ),
    WheelBidder(
      initials: 'RP',
      name: 'R.Priya',
      sliceColor: Color(0xFFF1E6FF),
      avatarBg: Color(0xFFE9D5FF),
      avatarTextColor: Color(0xFF9333EA),
    ),
    WheelBidder(
      initials: 'MK',
      name: 'M.Karthik',
      sliceColor: Color(0xFFFFE2E5),
      avatarBg: Color(0xFFFBCFE8),
      avatarTextColor: Color(0xFFDB2777),
    ),
    WheelBidder(
      initials: 'AS',
      name: 'A.Saranya',
      sliceColor: Color(0xFFDCFCE7),
      avatarBg: Color(0xFFBBF7D0),
      avatarTextColor: Color(0xFF16A34A),
    ),
    WheelBidder(
      initials: 'VR',
      name: 'V.Ramesh',
      sliceColor: Color(0xFFE0E7FF),
      avatarBg: Color(0xFFC7D2FE),
      avatarTextColor: Color(0xFF4F46E5),
    ),
  ];

  @override
  void initState() {
    super.initState();

    // Pulse animation for speed lines and background
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    // Spin animation for 3.6 seconds (3 - 4 seconds)
    _spinController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3600),
    );

    _spinAnimation = CurvedAnimation(
      parent: _spinController,
      curve: Curves.easeOutCubic,
    );

    _spinController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _isManualSpinning = false;
          _currentAngle = _spinAnimation.value % (2 * pi);
        });

        // Navigate to the result screen after spin stops
        Future.delayed(const Duration(milliseconds: 400), () {
          if (mounted) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AuctionResultScreen(),
              ),
            );
          }
        });
      }
    });
  }

  void _triggerSpin() {
    if (_isManualSpinning) return;

    setState(() {
      _isManualSpinning = true;
    });

    _spinController.reset();

    // Spin 5-7 full revolutions then ease to a stop
    final int revolutions = 5 + Random().nextInt(3);
    final double extraAngle = Random().nextDouble() * 2 * pi;
    final double targetAngle = _currentAngle + (revolutions * 2 * pi) + extraAngle;

    _spinAnimation = Tween<double>(
      begin: _currentAngle,
      end: targetAngle,
    ).animate(CurvedAnimation(
      parent: _spinController,
      curve: Curves.easeOutCubic,
    ));

    _spinController.forward();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _spinController.dispose();
    super.dispose();
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
                                    const Icon(Icons.swap_vert, size: 15,color:  Color(0xff266FAF)),
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

                    const SizedBox(height: 20),

                    // Enlarged Spinning Bidder Wheel Section
                    Center(
                      child: SizedBox(
                        width: 330,
                        height: 345,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Background speed lines animation
                            AnimatedBuilder(
                              animation: _pulseController,
                              builder: (context, child) {
                                return CustomPaint(
                                  size: const Size(330, 330),
                                  painter: SpeedLinesPainter(
                                    pulseValue: _pulseController.value,
                                  ),
                                );
                              },
                            ),

                            // Rotating Wheel Body (Enlarged to 286x286)
                            AnimatedBuilder(
                              animation: _spinController,
                              builder: (context, child) {
                                final double angle = _isManualSpinning
                                    ? _spinAnimation.value
                                    : _currentAngle;

                                return Transform.rotate(
                                  angle: angle,
                                  child: CustomPaint(
                                    size: const Size(286, 286),
                                    painter: BidderWheelPainter(bidders: _bidders),
                                  ),
                                );
                              },
                            ),

                            // Top Red Triangle Indicator Marker (12 O'Clock Position)
                            Positioned(
                              top: 4,
                              child: Image.asset(
                                "assets/liveauction/Top Red Triangle Indicator Marker (12 O'Clock Position).png",
                                width: 30,
                                height: 30,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.arrow_drop_down, color: Colors.red, size: 32),
                              ),
                            ),

                            // Center Dual Refresh Button (Tapping spins the wheel)
                            GestureDetector(
                              onTap: _triggerSpin,
                              child: Container(
                                width: 68,
                                height: 68,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                                child: Image.asset(
                                  'assets/liveauction/live_spin_refresh.png',
                                  width: 68,
                                  height: 68,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const CircleAvatar(
                                    radius: 34,
                                    backgroundColor: Color(0xff266FAF),
                                    child: Icon(Icons.refresh, color: Colors.white, size: 34),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Text: Selecting Bidder... (Increased font size)
                    const Center(
                      child: Text(
                        'Selecting Bidder...',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff266FAF),
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Center(
                      child: Text(
                        'Please wait while we select a member randomly',
                        style: TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),
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
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF93C5FD),
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

class WheelBidder {
  final String initials;
  final String name;
  final Color sliceColor;
  final Color avatarBg;
  final Color avatarTextColor;

  const WheelBidder({
    required this.initials,
    required this.name,
    required this.sliceColor,
    required this.avatarBg,
    required this.avatarTextColor,
  });
}

class BidderWheelPainter extends CustomPainter {
  final List<WheelBidder> bidders;

  BidderWheelPainter({required this.bidders});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 4;
    final rect = Rect.fromCircle(center: center, radius: radius);

    final int count = bidders.length;
    final double sweepAngle = 2 * pi / count;

    // Outer wheel border
    final rimPaint = Paint()
      ..color = Color(0xff266FAF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6.5;

    // Draw the 5 pie slices
    for (int i = 0; i < count; i++) {
      // 12 o'clock corresponds to -pi/2
      final startAngle = -pi / 2 + i * sweepAngle;

      final slicePaint = Paint()
        ..color = bidders[i].sliceColor
        ..style = PaintingStyle.fill;

      canvas.drawArc(rect, startAngle, sweepAngle, true, slicePaint);

      // Divider line
      final dividerPaint = Paint()
        ..color = Colors.white
        ..strokeWidth = 2.5
        ..style = PaintingStyle.stroke;

      final endX = center.dx + radius * cos(startAngle);
      final endY = center.dy + radius * sin(startAngle);
      canvas.drawLine(center, Offset(endX, endY), dividerPaint);
    }

    // Outer blue rim
    canvas.drawCircle(center, radius, rimPaint);

    // Draw white dots / pins at slice boundaries on outer rim
    final pinPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    for (int i = 0; i < count; i++) {
      final angle = -pi / 2 + i * sweepAngle;
      final pinX = center.dx + radius * cos(angle);
      final pinY = center.dy + radius * sin(angle);
      canvas.drawCircle(Offset(pinX, pinY), 4.0, pinPaint);
    }

    // Draw initials avatar and name text inside each slice
    for (int i = 0; i < count; i++) {
      final midAngle = -pi / 2 + i * sweepAngle + sweepAngle / 2;
      final bidder = bidders[i];

      canvas.save();
      canvas.translate(center.dx, center.dy);
      canvas.rotate(midAngle + pi / 2);

      // 1. Draw Initials Avatar Circle near outer rim
      final avatarCenter = Offset(0, -radius * 0.73);
      final avatarBgPaint = Paint()
        ..color = bidder.avatarBg
        ..style = PaintingStyle.fill;
      canvas.drawCircle(avatarCenter, 15, avatarBgPaint);

      final initialsPainter = TextPainter(
        text: TextSpan(
          text: bidder.initials,
          style: TextStyle(
            color: bidder.avatarTextColor,
            fontSize: 12.5,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      initialsPainter.paint(
        canvas,
        avatarCenter - Offset(initialsPainter.width / 2, initialsPainter.height / 2),
      );

      // 2. Draw Bidder Name Text (Enlarged font)
      final namePainter = TextPainter(
        text: TextSpan(
          text: bidder.name,
          style: const TextStyle(
            color: Color(0xFF1E293B),
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      namePainter.paint(
        canvas,
        Offset(-namePainter.width / 2, -radius * 0.51),
      );

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class SpeedLinesPainter extends CustomPainter {
  final double pulseValue;

  SpeedLinesPainter({required this.pulseValue});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final baseRadius = size.width / 2 - 8;

    final arcPaint1 = Paint()
      ..color = const Color(0xFF60A5FA).withValues(alpha: 0.35 + 0.3 * pulseValue)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round;

    final arcPaint2 = Paint()
      ..color = const Color(0xFF93C5FD).withValues(alpha: 0.25 + 0.25 * (1 - pulseValue))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    // Left motion arcs
    final rectLeft1 = Rect.fromCircle(center: center, radius: baseRadius + 10);
    canvas.drawArc(rectLeft1, pi * 0.75, pi * 0.45, false, arcPaint1);

    final rectLeft2 = Rect.fromCircle(center: center, radius: baseRadius + 18);
    canvas.drawArc(rectLeft2, pi * 0.85, pi * 0.30, false, arcPaint2);

    // Right motion arcs
    final rectRight1 = Rect.fromCircle(center: center, radius: baseRadius + 10);
    canvas.drawArc(rectRight1, -pi * 0.20, pi * 0.45, false, arcPaint1);

    final rectRight2 = Rect.fromCircle(center: center, radius: baseRadius + 18);
    canvas.drawArc(rectRight2, -pi * 0.15, pi * 0.30, false, arcPaint2);
  }

  @override
  bool shouldRepaint(covariant SpeedLinesPainter oldDelegate) =>
      oldDelegate.pulseValue != pulseValue;
}
