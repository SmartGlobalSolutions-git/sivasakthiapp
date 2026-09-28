import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ==========================================================
// SIVA SAKTHI - Welcome / Onboarding Screen
// Built using flutter_screenutil for responsive scaling.
// Colors, fonts and sizes match the Figma design exactly.
// ==========================================================

class SivaSakthiWelcomeScreen extends StatelessWidget {
  const SivaSakthiWelcomeScreen({
    super.key,
    this.onGetStarted,
    this.onTermsTap,
  });

  final VoidCallback? onGetStarted;
  final VoidCallback? onTermsTap;

  // ---- Figma colors ----
  static const Color kBlue = Color(0xFF3C93F4);
  static const Color kBlack = Color(0xFF000000);
  static const Color kStarGold = Color(0xFFFFC300);
  static const Color kStarGrey = Color(0xFFD9D9D9);

  @override
  Widget build(BuildContext context) {
    // ScreenUtil scaling helpers
    double w(double v) => v.w;
    double h(double v) => v.h;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: false,
        bottom: false,
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ---------------- Hero image (from Figma) ----------------
              ClipRect(
                child: Transform.translate(
                  offset: Offset(0, h(10)),
                  child: Transform.scale(
                    scale: 1.15,
                    child: SizedBox(
                      width: double.infinity,
                      height: h(440),
                      child: Image.asset(
                        'assets/onboarding/get_started.png',
                        fit: BoxFit.cover,
                        alignment: Alignment.topCenter,
                        errorBuilder: (context, error, stackTrace) => Container(
                          height: h(360),
                          color: const Color(0xFF7FA9C6),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: h(28)),

              // ---------------- Welcome to / SIVA SAKTHI ----------------
              Text(
                'Welcome to',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: kBlack,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: h(4)),
              const Text(
                'SIVA SAKTHI',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: kBlue,
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),

              SizedBox(height: h(20)),

              // ---------------- Body paragraphs ----------------
              Padding(
                padding: EdgeInsets.symmetric(horizontal: w(20)),
                child: Column(
                  children: [
                    Text(
                      'SIVA SAKTHI is a trusted chit fund company offering '
                          'reliable, flexible, and transparent financial solutions '
                          'for individuals, families, and businesses.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: kBlack.withValues(alpha: 0.7),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        height: 18 / 14,
                      ),
                    ),
                    SizedBox(height: h(16)),
                    Text(
                      'With a customer-first approach and dedicated service, '
                          'we strive to build long-term relationships based on '
                          'trust, transparency, and reliability.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: kBlack.withValues(alpha: 0.7),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        height: 18 / 14,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: h(24)),

              // ---------------- Tagline ----------------
              const Text(
                'Save Smart. Plan Better. Grow Together.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: kBlue,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  height: 18 / 16,
                ),
              ),

              SizedBox(height: h(14)),

              // ---------------- Star rating (4.5 / 5) ----------------
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  final bool isHalf = index == 4;
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: w(3)),
                    child: isHalf
                        ? Stack(
                      children: [
                        Icon(Icons.star_rounded,
                            size: w(27), color: kStarGrey),
                        ClipRect(
                          clipper: _HalfClipper(),
                          child: Icon(Icons.star_rounded,
                              size: w(27), color: kStarGold),
                        ),
                      ],
                    )
                        : Icon(Icons.star_rounded,
                        size: w(27), color: kStarGold),
                  );
                }),
              ),

              SizedBox(height: h(28)),

              // ---------------- Get Started button ----------------
              Padding(
                padding: EdgeInsets.symmetric(horizontal: w(16)),
                child: SizedBox(
                  width: double.infinity,
                  height: h(48),
                  child: ElevatedButton(
                    onPressed: onGetStarted,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kBlue,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(w(68)),
                      ),
                    ),
                    child: Text(
                      'Get Started',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: w(17),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: h(14)),

              // ---------------- Terms & Privacy ----------------
              Padding(
                padding: EdgeInsets.only(bottom: h(18)),
                child: GestureDetector(
                  onTap: onTermsTap,
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(
                        color: kBlack.withValues(alpha: 0.7),
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                      ),
                      children: [
                        const TextSpan(text: 'By continuing,you agree to our '),
                        TextSpan(
                          text: 'Terms & Use & Privacy Policy',
                          style: const TextStyle(
                            color: kBlue,
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HalfClipper extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) => Rect.fromLTWH(0, 0, size.width / 2, size.height);

  @override
  bool shouldReclip(covariant CustomClipper<Rect> oldClipper) => false;
}