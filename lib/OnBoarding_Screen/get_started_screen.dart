import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:geolocator/geolocator.dart';

import 'yes_no_login_screen.dart';
import 'terms_condition_screen.dart';

class GetStartedScreen extends StatelessWidget {
  const GetStartedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      key: const ValueKey('get_started_screen'),
      value: const SystemUiOverlayStyle(
        statusBarColor: Color(0xFF0D1519),
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: Color(0xFF0D1519),
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Container(
              height: topPadding,
              width: double.infinity,
              color: const Color(0xFF0D1519),
            ),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final double baseW = 360.0;
                  final double baseH = 800.0;
                  final double scaleW = constraints.maxWidth / baseW;
                  final double scaleH = (constraints.maxHeight / baseH).clamp(
                    0.85,
                    1.25,
                  );

                  return SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    child: SizedBox(
                      width: constraints.maxWidth,
                      height: constraints.maxHeight < 800
                          ? 800
                          : constraints.maxHeight,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          // Family oval header image
                          Positioned(
                            top: -122 * scaleH,
                            left: (constraints.maxWidth - (425 * scaleW)) / 2,
                            width: 425 * scaleW,
                            height: 475 * scaleH,
                            child: Image.asset(
                              'assets/images/family.png',
                              fit: BoxFit.fill,
                              alignment: Alignment.topCenter,
                              errorBuilder: (_, _, _) => Container(
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Color(0xFF3C93F4),
                                      Color(0xFF1B65B7),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),

                          // Welcome to SIVA SAKTHI
                          Positioned(
                            top: 365 * scaleH,
                            left: 16 * scaleW,
                            right: 16 * scaleW,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Welcome to',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.inter(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF101828),
                                    height: 1.15,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'SIVA SAKTHI',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.inter(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF3C93F4),
                                    height: 1.15,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Description
                          Positioned(
                            top: 428 * scaleH,
                            left: 16 * scaleW,
                            right: 16 * scaleW,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'SIVA SAKTHI is a trusted chit fund company\noffering reliable, flexible, and transparent\nfinancial solutions for individuals, families, and\nbusinesses.',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.inter(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0xB2000000),
                                    height: 1.45,
                                  ),
                                ),
                                SizedBox(height: 10 * scaleH),
                                Text(
                                  'With a customer-first approach and dedicated\nservice, we strive to build long-term\nrelationships based on trust, transparency, and\nreliability.',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.inter(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0xB2000000),
                                    height: 1.45,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Tagline
                          Positioned(
                            top: 601 * scaleH,
                            left: 16 * scaleW,
                            right: 16 * scaleW,
                            child: Text(
                              'Save Smart. Plan Better. Grow Together.',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF3C93F4),
                                height: 1.15,
                              ),
                            ),
                          ),

                          // Star Rating (4 full + 1 half)
                          Positioned(
                            top: 630 * scaleH,
                            left: 0,
                            right: 0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                for (int i = 0; i < 4; i++)
                                  const Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 2.0,
                                    ),
                                    child: Icon(
                                      Icons.star_rounded,
                                      color: Color(0xFFFFC400),
                                      size: 26,
                                    ),
                                  ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 2.0,
                                  ),
                                  child: Stack(
                                    children: [
                                      const Icon(
                                        Icons.star_rounded,
                                        color: Color(0xFFE0E0E0),
                                        size: 26,
                                      ),
                                      ClipRect(
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          widthFactor: 0.5,
                                          child: const Icon(
                                            Icons.star_rounded,
                                            color: Color(0xFFFFC400),
                                            size: 26,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Get Started Button
                          Positioned(
                            top: 675 * scaleH,
                            left: 16,
                            right: 16,
                            child: SizedBox(
                              height: 50,
                              child: ElevatedButton(
                                onPressed: () async {
                                  try {
                                    LocationPermission permission = await Geolocator.checkPermission();
                                    if (permission == LocationPermission.denied) {
                                      await Geolocator.requestPermission();
                                    }
                                  } catch (_) {}
                                  
                                  if (!context.mounted) return;

                                  Navigator.of(context).push(
                                    PageRouteBuilder(
                                      transitionDuration: Duration.zero,
                                      reverseTransitionDuration: Duration.zero,
                                      pageBuilder: (context, animation, _) =>
                                          const UserTypeSelectionScreen(),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF3C93F4),
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(68),
                                  ),
                                ),
                                child: Text(
                                  'Get Started',
                                  style: GoogleFonts.inter(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          // Footer Terms link
                          Positioned(
                            top: 750 * scaleH,
                            left: 16 * scaleW,
                            right: 16 * scaleW,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'By continuing, you agree to our',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.inter(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0xB2000000),
                                    height: 1.3,
                                  ),
                                ),
                                Text(
                                  'Terms & Use & Privacy Policy',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.inter(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFF3C93F4),
                                    decoration: TextDecoration.underline,
                                    decorationColor: const Color(0xFF3C93F4),
                                    height: 1.3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
