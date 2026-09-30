import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'otp_screen.dart';

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

  void _onGetOtp() {
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
          backgroundColor: const Color(0xFFD92D20),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
      setState(() {
        _phoneError = 'Please enter a valid mobile number';
      });
      return;
    }

    // 3. Valid 10-digit mobile number -> proceed to OTP screen
    setState(() {
      _phoneError = null;
    });

    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
        pageBuilder: (context, animation, secondaryAnimation) =>
            OtpVerificationScreen(phoneNumber: phone),
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

            // App Bar with progress indicator
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 8.0,
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
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
                          color: const Color(0xFF3C93F4),
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
                                      // Country code box (height: 46, radius: 8, border: #D2D2D2, bg: #FBFBFB)
                                      Container(
                                        height: 46,
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

                                      // Number input box (height: 46, radius: 8, border: #D2D2D2, bg: #FBFBFB)
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () {
                                            _phoneFocusNode.requestFocus();
                                            if (_phoneController
                                                    .selection
                                                    .baseOffset <
                                                0) {
                                              _phoneController.selection =
                                                  TextSelection.collapsed(
                                                    offset: _phoneController
                                                        .text
                                                        .length,
                                                  );
                                            }
                                          },
                                          child: Container(
                                            height: 46,
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                            ),
                                            decoration: BoxDecoration(
                                              color: const Color(
                                                0xFFFBFBFB,
                                              ), // #FBFBFB
                                              borderRadius:
                                                  BorderRadius.circular(
                                                    8,
                                                  ), // radius: 8px
                                              border: Border.all(
                                                color: _phoneError != null
                                                    ? const Color(0xFFD92D20)
                                                    : (_phoneFocusNode.hasFocus
                                                          ? const Color(
                                                              0xFF3C93F4,
                                                            )
                                                          : const Color(
                                                              0xFFD2D2D2,
                                                            )), // border: 1px solid #D2D2D2
                                                width: 1.0,
                                              ),
                                            ),
                                            child: Stack(
                                              alignment: Alignment.centerLeft,
                                              children: [
                                                // 10 underscore slots: 2 - 4 - 4 grouping with lengthened spacing
                                                FittedBox(
                                                  fit: BoxFit.scaleDown,
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: List.generate(10, (
                                                      index,
                                                    ) {
                                                      final text =
                                                          _phoneController.text;
                                                      final hasChar =
                                                          index < text.length;
                                                      final char = hasChar
                                                          ? text[index]
                                                          : '';
                                                      // Group spacing: 2 dashes, wide space, 4 dashes, wide space, 4 dashes
                                                      final isGroupBreak =
                                                          (index == 1 ||
                                                          index == 5);

                                                      // Calculate active cursor position
                                                      final rawOffset =
                                                          _phoneController
                                                              .selection
                                                              .baseOffset;
                                                      final cursorPos =
                                                          (rawOffset >= 0 &&
                                                              rawOffset <=
                                                                  text.length)
                                                          ? rawOffset
                                                          : text.length;

                                                      final showCursorBefore =
                                                          _phoneFocusNode
                                                              .hasFocus &&
                                                          _cursorVisible &&
                                                          (cursorPos == index);

                                                      final showCursorAfter =
                                                          _phoneFocusNode
                                                              .hasFocus &&
                                                          _cursorVisible &&
                                                          (cursorPos == 10 &&
                                                              index == 9);

                                                      Widget buildSlotChild() {
                                                        final charWidget =
                                                            hasChar
                                                            ? Text(
                                                                char,
                                                                style: GoogleFonts.inter(
                                                                  fontSize: 18,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  color: const Color(
                                                                    0xFF101828,
                                                                  ),
                                                                ),
                                                              )
                                                            : null;

                                                        final cursorLine =
                                                            Container(
                                                              width: 1.5,
                                                              height: 20,
                                                              color:
                                                                  const Color(
                                                                    0xFF3C93F4,
                                                                  ),
                                                            );

                                                        if (showCursorBefore) {
                                                          if (hasChar) {
                                                            return Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: [
                                                                cursorLine,
                                                                charWidget!,
                                                              ],
                                                            );
                                                          } else {
                                                            return cursorLine;
                                                          }
                                                        } else if (showCursorAfter) {
                                                          return Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              charWidget!,
                                                              cursorLine,
                                                            ],
                                                          );
                                                        } else {
                                                          return charWidget ??
                                                              const SizedBox.shrink();
                                                        }
                                                      }

                                                      return GestureDetector(
                                                        behavior:
                                                            HitTestBehavior
                                                                .opaque,
                                                        onTap: () {
                                                          _phoneFocusNode
                                                              .requestFocus();
                                                          final currentText =
                                                              _phoneController
                                                                  .text;
                                                          if (index <
                                                              currentText
                                                                  .length) {
                                                            _phoneController
                                                                    .selection =
                                                                TextSelection.collapsed(
                                                                  offset:
                                                                      index + 1,
                                                                );
                                                          } else {
                                                            _phoneController
                                                                    .selection =
                                                                TextSelection.collapsed(
                                                                  offset:
                                                                      currentText
                                                                          .length,
                                                                );
                                                          }
                                                        },
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                right:
                                                                    isGroupBreak
                                                                    ? 16.0
                                                                    : (index < 9
                                                                          ? 5.0
                                                                          : 0.0),
                                                              ),
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              SizedBox(
                                                                height: 24,
                                                                child: Center(
                                                                  child:
                                                                      buildSlotChild(),
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                height: 2,
                                                              ),
                                                              // width: 15, stroke: 1.5, color: #000000
                                                              Container(
                                                                width: 15,
                                                                height: 1.5,
                                                                decoration: BoxDecoration(
                                                                  color: const Color(
                                                                    0xFF000000,
                                                                  ),
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                        0.5,
                                                                      ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    }),
                                                  ),
                                                ),

                                                // Transparent TextField overlay wrapped in IgnorePointer so taps hit individual slots
                                                IgnorePointer(
                                                  child: Opacity(
                                                    opacity: 0.0,
                                                    child: TextField(
                                                      controller:
                                                          _phoneController,
                                                      focusNode:
                                                          _phoneFocusNode,
                                                      keyboardType:
                                                          TextInputType.phone,
                                                      inputFormatters: [
                                                        FilteringTextInputFormatter
                                                            .digitsOnly,
                                                        LengthLimitingTextInputFormatter(
                                                          10,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
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
                                      onPressed: _onGetOtp,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(
                                          0xFF3C93F4,
                                        ),
                                        foregroundColor: Colors.white,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            68,
                                          ),
                                        ),
                                      ),
                                      child: Text(
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
