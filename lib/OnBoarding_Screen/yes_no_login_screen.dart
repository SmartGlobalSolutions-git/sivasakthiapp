import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:siva_sakthi/new_user/new_home.dart';
import 'login_screen.dart';

/// User Type Selection Screen: Figma Android Medium - 15
/// New User or Existing User choice
class UserTypeSelectionScreen extends StatelessWidget {
  const UserTypeSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

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
                  final double scaleH =
                      (constraints.maxHeight / baseH).clamp(0.85, 1.25);

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
                          // Family arch header
                          Positioned(
                            top: -122 * scaleH,
                            left:
                                (constraints.maxWidth - (425 * scaleW)) / 2,
                            width: 425 * scaleW,
                            height: 475 * scaleH,
                            child: Image.asset(
                              'assets/images/family.png',
                              fit: BoxFit.fill,
                              alignment: Alignment.topCenter,
                            ),
                          ),

                          // Options container
                          Positioned(
                            top: 410 * scaleH,
                            left: 16 * scaleW,
                            right: 16 * scaleW,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Are you a New or Existing User?',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.inter(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF101828),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Choose an option below to continue',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0xFF667085),
                                  ),
                                ),
                                SizedBox(height: 36 * scaleH),

                                // Yes, I'm an Existing User -> LoginScreen
                                SizedBox(
                                  width: double.infinity,
                                  height: 48,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) => const LoginScreen(),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          const Color(0xFF3C93F4),
                                      foregroundColor: Colors.white,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(68),
                                      ),
                                    ),
                                    child: Text(
                                      "Yes, I'm an Existing User",
                                      style: GoogleFonts.inter(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),

                                SizedBox(height: 16 * scaleH),

                                // First Time With Us? (New User) -> HomeScreen (new_home.dart)
                                SizedBox(
                                  width: double.infinity,
                                  height: 48,
                                  child: OutlinedButton(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) => const HomeScreen(),
                                        ),
                                      );
                                    },
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor:
                                          const Color(0xFF3C93F4),
                                      side: const BorderSide(
                                        color: Color(0xFF3C93F4),
                                        width: 1.5,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(68),
                                      ),
                                    ),
                                    child: Text(
                                      'First Time With Us?',
                                      style: GoogleFonts.inter(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF3C93F4),
                                      ),
                                    ),
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
