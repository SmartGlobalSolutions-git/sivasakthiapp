import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:pinput/pinput.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/device_location_service.dart';
import 'terms_condition_screen.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String phoneNumber;
  final String token;
  final String cusId;

  const OtpVerificationScreen({
    super.key,
    this.phoneNumber = '',
    this.token = '',
    this.cusId = '',
  });

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final TextEditingController _otpController = TextEditingController();
  final FocusNode _otpFocusNode = FocusNode();

  int _remainingSeconds = 45;
  Timer? _countdownTimer;

  @override
  void initState() {
    super.initState();
    _otpController.addListener(() {
      setState(() {});
    });
    _startTimer();
  }

  void _startTimer() {
    _countdownTimer?.cancel();
    setState(() => _remainingSeconds = 45);
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() => _remainingSeconds--);
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _otpController.dispose();
    _otpFocusNode.dispose();
    super.dispose();
  }

  bool _isLoading = false;
  static const String _apiUrl = 'https://chitsoft.in/wapp/api/chit_api/';

  Future<void> _onVerify() async {
    if (_isLoading) return;

    final otp = _otpController.text.trim();

    if (otp.length < 6) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please enter the 6-digit OTP',
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
      _isLoading = true;
    });

    try {
      final String deviceId = await DeviceLocationService.getDeviceId();
      final Map<String, String> loc = await DeviceLocationService.getLocation();

      final Map<String, String> formParams = {
        'cid': '35318938',
        'type': '6002',
        'lt': loc['lat'] ?? '123',
        'ln': loc['lng'] ?? '123',
        'device_id': deviceId,
        'mobile': widget.phoneNumber,
        'otp': otp,
        'token': widget.token,
      };

      final response = await http.post(
        Uri.parse(_apiUrl),
        body: formParams,
      ).timeout(const Duration(seconds: 10));

      debugPrint('==================================================');
      debugPrint('OTP VERIFY API REQUEST: $formParams');
      debugPrint('OTP VERIFY API STATUS CODE: ${response.statusCode}');
      debugPrint('OTP VERIFY API RESPONSE BODY: ${response.body}');
      debugPrint('==================================================');

      final Map<String, dynamic> data = jsonDecode(response.body);
      final bool isError = data['error'] == true;
      final String errorMsg = data['error_msg']?.toString() ??
          (isError ? 'OTP verification failed' : 'OTP verified successfully');

      if (!mounted) return;

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
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('cus_id', widget.cusId);
        await prefs.setString('token', widget.token);
        
        Navigator.of(context).push(
          PageRouteBuilder(
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
            pageBuilder: (context, animation, secondaryAnimation) =>
                const TermsAndConditionScreen(),
          ),
        );
      }
    } catch (e) {
      debugPrint('==================================================');
      debugPrint('OTP VERIFY API EXCEPTION: $e');
      debugPrint('==================================================');
      if (!mounted) return;

      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please check internet connection.',
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

            // App Bar with progress indicator (Step 2 active)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back, color: Color(0xFF101828)),
                  ),
                  const Spacer(),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 4,
                        height: 4,
                        decoration: const BoxDecoration(
                          color: Color(0xFFD0D5DD),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Container(
                        width: 18,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Color(0xff266FAF),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  const SizedBox(width: 48),
                ],
              ),
            ),

            // Content
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final double scaleW = constraints.maxWidth / 360.0;
                  final double scaleH = (constraints.maxHeight / 700.0).clamp(0.85, 1.2);
                  final bool isOtpReady = _otpController.text.trim().length == 6;

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
                              padding: EdgeInsets.symmetric(horizontal: 15.0 * scaleW),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 28 * scaleH),
                            Text(
                              'Enter your OTP',
                              style: GoogleFonts.inter(
                                fontSize: 32 * scaleW.clamp(0.85, 1.05),
                                fontWeight: FontWeight.w400, // Regular
                                color: const Color(0xFF000000), // #000000
                                height: 38 / 32, // line-height: 38px
                                letterSpacing: 0,
                              ),
                            ),
                            const SizedBox(height: 14),
                            Text(
                              "We've sent a 6-digit OTP to your\nregistered mobile number.",
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w400, // Regular
                                color: const Color(0xB2000000), // #000000B2
                                height: 18 / 14, // line-height: 18px
                                letterSpacing: 0,
                              ),
                            ),
                            const SizedBox(height: 28),

                            // 6 OTP Digit Boxes
                            Pinput(
                              length: 6,
                              controller: _otpController,
                              focusNode: _otpFocusNode,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              defaultPinTheme: PinTheme(
                                width: (constraints.maxWidth - (30.0 * scaleW) - (5 * 8)) / 6,
                                height: 48,
                                textStyle: GoogleFonts.inter(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF101828),
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEDEDED),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: const Color(0xFFEDEDED)),
                                ),
                              ),
                              focusedPinTheme: PinTheme(
                                width: (constraints.maxWidth - (30.0 * scaleW) - (5 * 8)) / 6,
                                height: 48,
                                textStyle: GoogleFonts.inter(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF101828),
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEDEDED),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Color(0xff266FAF), width: 1.5),
                                ),
                              ),
                            ),

                            const SizedBox(height: 24),

                            // Timer & Resend Row
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                RichText(
                                  text: TextSpan(
                                    text: "Didn't receive OTP ",
                                    style: GoogleFonts.inter(
                                      fontSize: 13,
                                      color: const Color(0xFF667085),
                                    ),
                                    children: [
                                      TextSpan(
                                        text: '00:${_remainingSeconds.toString().padLeft(2, '0')}',
                                        style: GoogleFonts.inter(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xff266FAF),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: _remainingSeconds == 0 ? _startTimer : null,
                                  child: Text(
                                    'Resend OTP',
                                    style: GoogleFonts.inter(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: _remainingSeconds == 0
                                          ? Color(0xff266FAF)
                                          : Color(0xff266FAF).withValues(alpha: 0.5),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const Spacer(),

                            // Verify Button (Always enabled appearance, navigates only when OTP is complete)
                             SizedBox(
                              width: double.infinity,
                              height: 52,
                              child: ElevatedButton(
                                onPressed: _isLoading ? null : _onVerify,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xff266FAF),
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(68),
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
                                        'Verify',
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