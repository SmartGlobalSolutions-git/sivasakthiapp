import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:siva_sakthi/home/home.dart';

class ReceiptPendingScreen extends StatefulWidget {
  const ReceiptPendingScreen({super.key});

  @override
  State<ReceiptPendingScreen> createState() => _ReceiptPendingScreenState();
}

class _ReceiptPendingScreenState extends State<ReceiptPendingScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const SivaSakthiHomeScreen()),
          (route) => false,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final scaleW = (screenWidth / 360.0).clamp(0.85, 1.25);
    final topPadding = mediaQuery.padding.top;
    final bottomPadding = mediaQuery.padding.bottom;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // 1. App Bar (No Back Arrow)
          _buildAppBar(context, scaleW, topPadding),

          // 2. Middle Content Area
          Expanded(
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Spacing to GIF
                  SizedBox(height: 124 * scaleW),

                  // 1. Receipt Verify GIF
                  Center(
                    child: Image.asset(
                      'assets/images/receipt_verify.gif',
                      width: 186 * scaleW,
                      height: 186 * scaleW,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 186 * scaleW,
                        height: 186 * scaleW,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3F4F6),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Icon(
                          Icons.receipt_long,
                          size: 80 * scaleW,
                          color: const Color(0xFF3C93F4),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 24 * scaleW),

                  // 2. Title: "Receipt Pending"
                  Text(
                    'Receipt Pending',
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    softWrap: false,
                    style: GoogleFonts.inter(
                      fontSize: 20.49 * scaleW,
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.normal,
                      height: 1.25,
                      letterSpacing: -0.51 * scaleW,
                      color: const Color(0xFF030712),
                    ),
                  ),

                  SizedBox(height: 12 * scaleW),

                  // 3. Description text
                  Container(
                    width: 300 * scaleW,
                    alignment: Alignment.center,
                    child: Text(
                      'Your payment is being processed. The\nreceipt will be generated shortly once the\npayment is confirmed.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 12.81 * scaleW,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                        height: 20.82 / 12.81,
                        letterSpacing: 0,
                        color: const Color(0xFF6B7280),
                      ),
                    ),
                  ),

                  SizedBox(height: 34 * scaleW),

                  // 4. Orange Alert Box
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {},
                    child: Container(
                      width: 292 * scaleW,
                      padding: EdgeInsets.symmetric(
                        horizontal: 10 * scaleW,
                        vertical: 11 * scaleW,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF6E4),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: const Color(0xFFFDE6B8).withValues(alpha: 0.7),
                          width: 0.85,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 1.71,
                            offset: const Offset(0, 0.85),
                          ),
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/timer.png',
                            width: 22 * scaleW,
                            height: 22 * scaleW,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) => Icon(
                              Icons.access_time_filled,
                              color: const Color(0xFFEA580C),
                              size: 22 * scaleW,
                            ),
                          ),
                          SizedBox(width: 6 * scaleW),

                          Flexible(
                            child: Text(
                              'Please check back later or refresh to\nview your receipt.',
                              textAlign: TextAlign.left,
                              softWrap: true,
                              style: GoogleFonts.inter(
                                fontSize: 11.95 * scaleW,
                                fontWeight: FontWeight.w500,
                                height: 16.44 / 11.95,
                                letterSpacing: 0,
                                color: const Color(0xFF78350F),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: bottomPadding > 0 ? bottomPadding + 20 : 40 * scaleW),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- App Bar ---
  Widget _buildAppBar(BuildContext context, double scaleW, double topPadding) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: EdgeInsets.only(top: topPadding),
      child: Container(
        height: 57 * scaleW,
        padding: EdgeInsets.symmetric(horizontal: 16 * scaleW),
        alignment: Alignment.centerLeft,
        child: Text(
          'Receipt Pending',
          style: GoogleFonts.inter(
            fontSize: 16 * scaleW,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF111827),
            letterSpacing: 0,
            height: 1.0,
          ),
        ),
      ),
    );
  }
}
