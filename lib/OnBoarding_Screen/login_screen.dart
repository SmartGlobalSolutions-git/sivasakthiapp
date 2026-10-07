import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import '../services/device_location_service.dart';
import 'otp_screen.dart';
import 'yes_no_login_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final FocusNode _phoneFocusNode = FocusNode();
  String? _phoneError;
  bool _cursorVisible = true;
  Timer? _cursorTimer;

  @override
  void initState() {
    super.initState();
    _phoneController.addListener(() {
      if (_phoneError != null) {
        setState(() {
          _phoneError = null;
        });
      } else {
        setState(() {});
      }
    });
    _phoneFocusNode.addListener(() {
      if (_phoneFocusNode.hasFocus) {
        // Start blinking cursor when focused
        _cursorTimer?.cancel();
        _cursorTimer = Timer.periodic(const Duration(milliseconds: 500), (_) {
          if (mounted) setState(() => _cursorVisible = !_cursorVisible);
        });
      } else {
        // Stop blinking cursor when unfocused
        _cursorTimer?.cancel();
        _cursorTimer = null;
        setState(() => _cursorVisible = false);
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    _cursorTimer?.cancel();
    _phoneController.dispose();
    _phoneFocusNode.dispose();
    super.dispose();
  }

  bool _isLoading = false;

  // Configurable API URL for login/send OTP
  static const String _apiUrl = 'https://chitsoft.in/wapp/api/chit_api/';

  Future<void> _onGetOtp() async {
    if (_isLoading) return;

    final phone = _phoneController.text.trim();

    // 1. If 1 to 9 digits (or less than 10 digits) entered, show SnackBar message
    if (phone.length < 10) {
      if (_phoneError != null) {
        setState(() => _phoneError = null);
      }
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please enter a 10-digit mobile number',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          backgroundColor: const Color(0xFF000000),
          behavior: SnackBarBehavior.fixed,
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    // 2. If 10 digits entered, validate: must start with 6, 7, 8, or 9 and not be all repeating
    final bool isValidMobile =
        RegExp(r'^[6-9]\d{9}$').hasMatch(phone) &&
        !RegExp(r'^(\d)\1{9}$').hasMatch(phone);

    if (!isValidMobile) {
      if (_phoneError != null) {
        setState(() => _phoneError = null);
      }
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please enter a valid mobile number',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          backgroundColor: const Color(0xFF000000),
          behavior: SnackBarBehavior.fixed,
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }
  

    setState(() {
      _phoneError = null;
      _isLoading = true;
    });

    try {
      final String deviceId = await DeviceLocationService.getDeviceId();
      final Map<String, String> loc = await DeviceLocationService.getLocation();

      final Map<String, String> formParams = {
        'cid': '35318938',
        'type': '6001',
        'lt': loc['lat'] ?? '123',
        'ln': loc['lng'] ?? '123',
        'device_id': deviceId,
        'mobile': phone,
      };

      http.Response response = await http.post(
        Uri.parse(_apiUrl),
        body: formParams,
      ).timeout(const Duration(seconds: 10));

      debugPrint('==================================================');
      debugPrint('LOGIN API REQUEST: $formParams');
      debugPrint('LOGIN API STATUS CODE: ${response.statusCode}');
      debugPrint('LOGIN API RESPONSE BODY: ${response.body}');
      debugPrint('==================================================');

      final Map<String, dynamic> data = jsonDecode(response.body);

      final bool isError = data['error'] == true;
      final String errorMsg = data['error_msg']?.toString() ??
          (isError ? 'Something went wrong' : 'Allow to next page');

      if (!mounted) return;

      // Show error_msg in SnackBar message only on error
      if (isError) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              errorMsg,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            backgroundColor: const Color(0xFF000000),
            behavior: SnackBarBehavior.fixed,
            duration: const Duration(seconds: 3),
          ),
        );
      }

      if (!isError) {
        final String token = data['token']?.toString() ?? '';
        final String cusId = data['cus_id']?.toString() ?? '';
        Navigator.of(context).push(
          PageRouteBuilder(
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
            pageBuilder: (context, animation, secondaryAnimation) =>
                OtpVerificationScreen(
              phoneNumber: phone,
              token: token,
              cusId: cusId,
            ),
          ),
        );
      }
    } catch (e) {
      debugPrint('==================================================');
      debugPrint('LOGIN API EXCEPTION: $e');
      debugPrint('==================================================');
      if (!mounted) return;

      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please check internet connection or API URL.',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          backgroundColor: const Color(0xFF000000),
          behavior: SnackBarBehavior.fixed,
          duration: const Duration(seconds: 3),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Color(0xFF0D1519),
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        body: Column(
          children: [
            // Top black status bar
            Container(
              height: topPadding,
              width: double.infinity,
              color: const Color(0xFF0D1519),
            ),

            // App Bar with progress indicator
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 8.0,
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const UserTypeSelectionScreen()),
                      );
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Color(0xFF101828),
                    ),
                  ),
                  const Spacer(),
                  // Progress indicator (Step 1 active)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 18,
                        height: 4,
                        decoration: BoxDecoration(
                          color: const Color(0xff266FAF),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Container(
                        width: 4,
                        height: 4,
                        decoration: const BoxDecoration(
                          color: Color(0xFFD0D5DD),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  const SizedBox(width: 48), // Balance back button
                ],
              ),
            ),

            // Content
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final double scaleW = constraints.maxWidth / 360.0;
                  final double scaleH = (constraints.maxHeight / 700.0).clamp(
                    0.85,
                    1.2,
                  );
                  // phone readiness checked on click

                  return Stack(
                    children: [
                      // Decorative bottom illustration (assets/images/hide_logo.png)
                      Positioned(
                        bottom: 0,
                        right: -10,
                        width: 290 * scaleW.clamp(0.85, 1.15),
                        height: 270 * scaleH,
                        child: IgnorePointer(
                          child: Image.asset(
                            'assets/images/hide_logo.png',
                            fit: BoxFit.contain,
                            alignment: Alignment.bottomRight,
                          ),
                        ),
                      ),

                      // Main Form
                      SingleChildScrollView(
                        physics: const ClampingScrollPhysics(),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: constraints.maxHeight,
                          ),
                          child: IntrinsicHeight(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 15.0 * scaleW,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 28 * scaleH),
                                  SizedBox(
                                    width: 293 * scaleW,
                                    child: Text(
                                      'Login to manage\nyour chit account?',
                                      style: GoogleFonts.inter(
                                        fontSize: 32 * scaleW.clamp(0.85, 1.05),
                                        fontWeight: FontWeight.w400, // Regular
                                        color: const Color(
                                          0xFF000000,
                                        ), // #000000
                                        height: 38 / 32, // line-height: 38px
                                        letterSpacing: 0,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 14),
                                  SizedBox(
                                    width: 274 * scaleW,
                                    child: Text(
                                      'Access your chit account and manage\nyour payments with ease.',
                                      style: GoogleFonts.inter(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400, // Regular
                                        color: const Color(
                                          0xB2000000,
                                        ), // #000000B2
                                        height: 18 / 14, // line-height: 18px
                                        letterSpacing: 0,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 28),

                                  // Phone Input Field
                                  Row(
                                    children: [
                                      // Country code box
                                      Container(
                                        height: 42,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFFBFBFB),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          border: Border.all(
                                            color: const Color(0xFFD2D2D2),
                                            width: 1.0,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              '+91',
                                              style: GoogleFonts.inter(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500,
                                                color: const Color(0xFF101828),
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            CustomPaint(
                                              size: const Size(11.15, 6.55),
                                              painter:
                                                  const _ChevronDownPainter(
                                                    color: Color(0xFF2A2523),
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 10),

                                      // Number input box
                                      Expanded(
                                        child: Container(
                                          height: 42,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                          ),
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFFBFBFB),
                                            borderRadius: BorderRadius.circular(8),
                                            border: Border.all(
                                              color: _phoneError != null
                                                  ? const Color(0xFFD92D20)
                                                  : (_phoneFocusNode.hasFocus
                                                        ? Color(0xff266FAF)
                                                        : const Color(0xFFD2D2D2)),
                                              width: 1.0,
                                            ),
                                          ),
                                          child: TextField(
                                            controller: _phoneController,
                                            focusNode: _phoneFocusNode,
                                            keyboardType: TextInputType.phone,
                                            style: GoogleFonts.inter(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: const Color(0xFF101828),
                                              letterSpacing: 1.5,
                                            ),
                                            inputFormatters: [
                                              FilteringTextInputFormatter.digitsOnly,
                                              LengthLimitingTextInputFormatter(10),
                                            ],
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              isDense: true,
                                              contentPadding: EdgeInsets.zero,
                                              hintText: 'Enter Mobile Number',
                                              hintStyle: GoogleFonts.inter(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w400,
                                                color: const Color(0xFF9CA3AF),
                                                letterSpacing: 0,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  if (_phoneError != null) ...[
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.error_outline_rounded,
                                          size: 14,
                                          color: Color(0xFFD92D20),
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          _phoneError!,
                                          style: GoogleFonts.inter(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                            color: const Color(0xFFD92D20),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],

                                  const Spacer(),

                                  // Get OTP Button (Always enabled appearance, navigates only when mobile number is valid)
                                  SizedBox(
                                    width: double.infinity,
                                    height: 52,
                                    child: ElevatedButton(
                                      onPressed: _isLoading ? null : _onGetOtp,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Color(0xff266FAF),
                                        foregroundColor: Colors.white,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            68,
                                          ),
                                        ),
                                      ),
                                      child: _isLoading
                                          ? const SizedBox(
                                              width: 22,
                                              height: 22,
                                              child: CircularProgressIndicator(
                                                color: Colors.white,
                                                strokeWidth: 2.5,
                                              ),
                                            )
                                          : Text(
                                              'Get OTP',
                                              style: GoogleFonts.inter(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white,
                                              ),
                                            ),
                                    ),
                                  ),
                                  SizedBox(height: 51 * scaleH),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
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

/// Custom down arrow chevron matching exact Figma dimensions:
/// width: 11.15, height: 6.55, color: #2A2523
class _ChevronDownPainter extends CustomPainter {
  final Color color;
  const _ChevronDownPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path()
      ..moveTo(0.8, 1.0)
      ..lineTo(size.width / 2, size.height - 1.0)
      ..lineTo(size.width - 0.8, 1.0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
