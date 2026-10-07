import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:siva_sakthi/services/device_location_service.dart';
import 'get_started_screen.dart';


class SplashScreen extends StatefulWidget {
  final VoidCallback? onComplete;
  final bool enableAutoNavigate;

  const SplashScreen({
    super.key,
    this.onComplete,
    this.enableAutoNavigate = true,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  Timer? _transitionTimer;
  bool _hasProceeded = false;

  static const String _titleText = 'SIVA SAKTHI';
  static const String _subtitleText = 'CHITS';

  static const LinearGradient _bgGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    stops: [0.4434, 0.99],
    colors: [
      Color(0xFF226EC3),
      Color(0xFF10345D),
    ],
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(const AssetImage('assets/onboarding/splash_logo.png'), context);
  }

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3600),
    );

    _animController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (widget.enableAutoNavigate || widget.onComplete != null) {
          _transitionTimer = Timer(const Duration(milliseconds: 1200), () {
            if (mounted) _proceed();
          });
        }
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        Future.delayed(const Duration(milliseconds: 150), () {
          if (mounted) _animController.forward();
        });
      }
    });
  }

  void _onTapScreen() {
    if (widget.enableAutoNavigate || widget.onComplete != null) {
      _proceed();
    } else {
      // Replay animation on tap when running splash screen alone
      _restartAnimation();
    }
  }

  void _restartAnimation() {
    _transitionTimer?.cancel();
    _animController.reset();
    _animController.forward();
  }

  void _proceed() {
    if (!mounted || _hasProceeded) return;
    _hasProceeded = true;
    _transitionTimer?.cancel();
    _animController.stop();

    _checkAppVersion();
  }

  Future<void> _checkAppVersion() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      final String version = packageInfo.version;

      final loc = await DeviceLocationService.getLocation();
      final deviceId = await DeviceLocationService.getDeviceId();

      final response = await http.post(
        Uri.parse('https://chitsoft.in/wapp/api/chit_api/'),
        body: {
          'cid': '35318938',
          'type': '6017',
          'lt': loc['lat'] ?? '123',
          'ln': loc['lng'] ?? '123',
          'device_id': deviceId.isNotEmpty ? deviceId : '123',
          'version': version,
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['error'] == false) {
          final bool updateRequired = data['update_required'] ?? false;
          if (updateRequired) {
            final String downloadUrl = data['download_url'] ?? '';
            if (mounted) {
              _showUpdatePopup(downloadUrl);
            }
            return; // Stop proceeding
          }
        }
      }
    } catch (e) {
      debugPrint('Version check error: $e');
    }
    
    // If no update required or API fails, proceed normally
    _navigateToNextScreen();
  }

  void _showUpdatePopup(String url) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text(
          'Update Required',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
            color: const Color(0xFF0F172A),
          ),
        ),
        content: Text(
          'A new version of the app is available. Please update to continue.',
          style: GoogleFonts.inter(
            color: const Color(0xFF64748B),
          ),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF226EC3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () async {
              if (url.isNotEmpty) {
                final uri = Uri.parse(url);
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                }
              }
            },
            child: Text(
              'UPDATE',
              style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToNextScreen() {
    if (!mounted) return;
    if (widget.onComplete != null) {
      widget.onComplete!();
    } else {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 350),
          pageBuilder: (_, _, _) => const GetStartedScreen(),
          transitionsBuilder: (context, anim, _, child) =>
              FadeTransition(opacity: anim, child: child),
        ),
      );
    }
  }

  @override
  void dispose() {
    _transitionTimer?.cancel();
    _animController.dispose();
    super.dispose();
  }

  // Radius calculation for the expanding gradient dot
  double _calculateRadius(double progress, double maxRadius) {
    if (progress <= 0.12) {
      // Small blue dot stays at exact center (Android Large - 4)
      return 10.0;
    } else if (progress <= 0.38) {
      // Expand dot to cover the entire screen from exact center (Android Large - 5)
      final t = ((progress - 0.12) / (0.38 - 0.12)).clamp(0.0, 1.0);
      final curved = Curves.easeInOutCubic.transform(t);
      return 10.0 + (maxRadius - 10.0) * curved;
    } else {
      return maxRadius;
    }
  }

  // Logo scale animation
  double _calculateLogoScale(double progress) {
    if (progress < 0.38) return 0.0;
    if (progress >= 0.54) return 1.0;
    final t = ((progress - 0.38) / (0.54 - 0.38)).clamp(0.0, 1.0);
    return Curves.easeOutBack.transform(t);
  }

  // Logo opacity animation
  double _calculateLogoOpacity(double progress) {
    if (progress < 0.38) return 0.0;
    if (progress >= 0.48) return 1.0;
    final t = ((progress - 0.38) / (0.48 - 0.38)).clamp(0.0, 1.0);
    return Curves.easeIn.transform(t);
  }

  // "SIVA SAKTHI" typewriter text
  String _calculateTitle(double progress) {
    if (progress < 0.54) return '';
    if (progress >= 0.74) return _titleText;
    final t = ((progress - 0.54) / (0.74 - 0.54)).clamp(0.0, 1.0);
    final count = (t * _titleText.length).clamp(0, _titleText.length).toInt();
    return _titleText.substring(0, count);
  }

  // "CHITS" typewriter text
  String _calculateSubtitle(double progress) {
    if (progress < 0.74) return '';
    if (progress >= 0.89) return _subtitleText;
    final t = ((progress - 0.74) / (0.89 - 0.74)).clamp(0.0, 1.0);
    final count =
    (t * _subtitleText.length).clamp(0, _subtitleText.length).toInt();
    return _subtitleText.substring(0, count);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animController,
      builder: (context, _) {
        final progress = _animController.value;
        final isDarkTheme = progress >= 0.30;

        return AnnotatedRegion<SystemUiOverlayStyle>(
          key: const ValueKey('splash_screen'),
          value: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness:
            isDarkTheme ? Brightness.light : Brightness.dark,
            statusBarBrightness:
            isDarkTheme ? Brightness.dark : Brightness.light,
            systemNavigationBarColor:
            isDarkTheme ? const Color(0xFF10345D) : Colors.white,
            systemNavigationBarIconBrightness:
            isDarkTheme ? Brightness.light : Brightness.dark,
          ),
          child: Scaffold(
            backgroundColor: Colors.white,
            body: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: _onTapScreen,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final size =
                  Size(constraints.maxWidth, constraints.maxHeight);
                  // Exact center of the screen
                  final center = Offset(size.width / 2, size.height / 2);

                  // Distance to 4 screen corners to ensure full screen coverage
                  final d1 = (center - Offset.zero).distance;
                  final d2 = (center - Offset(size.width, 0)).distance;
                  final d3 = (center - Offset(0, size.height)).distance;
                  final d4 =
                      (center - Offset(size.width, size.height)).distance;
                  final maxRadius =
                      math.max(math.max(d1, d2), math.max(d3, d4)) + 20.0;

                  final currentRadius = _calculateRadius(progress, maxRadius);
                  final logoScale = _calculateLogoScale(progress);
                  final logoOpacity = _calculateLogoOpacity(progress);
                  final currentTitle = _calculateTitle(progress);
                  final currentSubtitle = _calculateSubtitle(progress);
                  const logoDiameter = 105.0;

                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      // Expanding Gradient Circle from Exact Center / Full Background
                      if (currentRadius >= maxRadius)
                        const DecoratedBox(
                          decoration: BoxDecoration(gradient: _bgGradient),
                          child: SizedBox.expand(),
                        )
                      else if (currentRadius > 0)
                        ClipPath(
                          clipper: CircleRevealClipper(
                            center: center,
                            radius: currentRadius,
                          ),
                          child: const DecoratedBox(
                            decoration: BoxDecoration(gradient: _bgGradient),
                            child: SizedBox.expand(),
                          ),
                        ),

                      // Siva Sakthi Empty Logo at the EXACT SAME Center
                      Center(
                        child: Opacity(
                          opacity: logoOpacity,
                          child: Transform.scale(
                            scale: logoScale,
                            alignment: Alignment.center,
                            child: Container(
                              width: logoDiameter,
                              height: logoDiameter,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.22),
                                    blurRadius: 18,
                                    spreadRadius: 2,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: ClipOval(
                                  child: Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Image.asset(
                                      'assets/onboarding/splash_logo.png',
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.contain,
                                      errorBuilder: (_, _, _) => const Icon(
                                        Icons.account_balance,
                                        size: 50,
                                        color: Color(0xFF226EC3),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Text Typed in White Directly Below the Logo Image
                      Positioned(
                        top: (size.height / 2) + (logoDiameter / 2) + 20,
                        left: 16,
                        right: 16,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // SIVA SAKTHI typed text in one line (White)
                            SizedBox(
                              height: 34,
                              child: Center(
                                child: Text(
                                  currentTitle,
                                  maxLines: 1,
                                  softWrap: false,
                                  overflow: TextOverflow.visible,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.inter(
                                    fontSize: 25,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 3.0,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 6),

                            // CHITS typed text smaller than SIVA SAKTHI (White)
                            SizedBox(
                              height: 22,
                              child: Center(
                                child: Text(
                                  currentSubtitle,
                                  maxLines: 1,
                                  softWrap: false,
                                  overflow: TextOverflow.visible,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.inter(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 5.5,
                                    color: Colors.white.withValues(alpha: 0.95),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Custom Clipper for circular expanding reveal
class CircleRevealClipper extends CustomClipper<Path> {
  final Offset center;
  final double radius;

  const CircleRevealClipper({required this.center, required this.radius});

  @override
  Path getClip(Size size) {
    final path = Path();
    if (radius <= 0) return path;
    path.addOval(Rect.fromCircle(center: center, radius: radius));
    return path;
  }

  @override
  bool shouldReclip(CircleRevealClipper oldClipper) {
    return oldClipper.radius != radius || oldClipper.center != center;
  }
}
