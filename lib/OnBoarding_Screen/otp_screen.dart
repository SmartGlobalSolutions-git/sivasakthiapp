import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'terms_condition_screen.dart';

/// OTP Verification Screen: Figma Android Medium - 14
/// 6-digit OTP entry with countdown timer
/// Screen 4: Android Medium - 14 (Enter your OTP)
class OtpVerificationScreen extends StatefulWidget {
  final String phoneNumber;

  const OtpVerificationScreen({
    super.key,
    this.phoneNumber = '',
  });

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  int _remainingSeconds = 45;
  Timer? _countdownTimer;

  @override
  void initState() {
    super.initState();
    for (final c in _controllers) {
      c.addListener(() {
        setState(() {});
      });
    }
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
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _onVerify() {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
        pageBuilder: (context, animation, secondaryAnimation) =>
            const TermsAndConditionScreen(),
      ),
    );
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
                          color: const Color(0xFF3C93F4),
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
                  final bool isOtpReady = _controllers.every((c) => c.text.trim().isNotEmpty);

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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: List.generate(6, (index) {
                                return SizedBox(
                                  width: (constraints.maxWidth - (30.0 * scaleW) - (5 * 8)) / 6,
                                  height: 48,
                                  child: TextField(
                                    controller: _controllers[index],
                                    focusNode: _focusNodes[index],
                                    keyboardType: TextInputType.number,
                                    textAlign: TextAlign.center,
                                    maxLength: 1,
                                    style: GoogleFonts.inter(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF101828),
                                    ),
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                    decoration: InputDecoration(
                                      counterText: '',
                                      contentPadding: EdgeInsets.zero,
                                      filled: true,
                                      fillColor: const Color(0xFFEDEDED),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: const BorderSide(
                                          color: Color(0xFFEDEDED),
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: const BorderSide(
                                          color: Color(0xFFEDEDED),
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: const BorderSide(
                                          color: Color(0xFF3C93F4),
                                          width: 1.5,
                                        ),
                                      ),
                                    ),
                                    onChanged: (value) {
                                      if (value.isNotEmpty && index < 5) {
                                        _focusNodes[index + 1].requestFocus();
                                      } else if (value.isEmpty && index > 0) {
                                        _focusNodes[index - 1].requestFocus();
                                      }
                                      setState(() {});
                                    },
                                  ),
                                );
                              }),
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
                                          color: const Color(0xFF3C93F4),
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
                                          ? const Color(0xFF3C93F4)
                                          : const Color(0xFF3C93F4).withValues(alpha: 0.5),
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
                                onPressed: () {
                                  if (isOtpReady) {
                                    _onVerify();
                                  }
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