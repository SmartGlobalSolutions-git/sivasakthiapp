import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:siva_sakthi/home/home.dart';

class TermsAndConditionScreen extends StatefulWidget {
  const TermsAndConditionScreen({super.key});

  @override
  State<TermsAndConditionScreen> createState() => _TermsAndConditionScreenState();
}

class _TermsAndConditionScreenState extends State<TermsAndConditionScreen> {
  bool _isAgreed = false; // Unchecked by default; user must manually check it

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    // Regular: Inter 400, 12px, line-height: 21px (height = 21/12 = 1.75)
    final regularStyle = GoogleFonts.inter(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      height: 21 / 12,
      letterSpacing: 0,
      color: const Color(0xFF1D2939),
    );

    // Bold span: Inter 700, 12px, line-height: 21px
    final boldStyle = GoogleFonts.inter(
      fontSize: 12,
      fontWeight: FontWeight.w700,
      height: 21 / 12,
      letterSpacing: 0,
      color: const Color(0xFF101828),
    );

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
        body: Column(
          children: [
            // Top black status bar
            Container(
              height: topPadding,
              width: double.infinity,
              color: const Color(0xFFF3F3F5),
            ),

            // App Bar: width: 360, height: 57, top: 24, background: #FFFFFF
            Container(
              width: double.infinity,
              height: 57,
              color: const Color(0xFFFFFFFF),
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              alignment: Alignment.center,
              child: Text(
                'Terms & Condition',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF101828),
                ),
              ),
            ),


            // Scrollable Content (clean background without outline)
            Expanded(
              child: Container(
                color: const Color(0xffffffff),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Last Updated [Date]\nEffective From [Date]',
                        style: regularStyle,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'By registering, accessing or using the App, you agree to these Terms & Conditions. These Terms govern use of the App as a digital service channel.',
                        style: regularStyle,
                      ),
                      const SizedBox(height: 14),
                      _buildSection(
                        'Use of Services',
                        'Users must provide correct and complete information while using Siva Sakthi services. Our services must not be used for any illegal or unauthorized activity.',
                        boldStyle,
                        regularStyle,
                      ),
                      _buildSection(
                        'User Information',
                        'Users are responsible for the accuracy of the personal and contact information they provide.',
                        boldStyle,
                        regularStyle,
                      ),
                      _buildSection(
                        'Products & Services',
                        'Details, availability, pricing, and other information related to our products or services may be updated from time to time.',
                        boldStyle,
                        regularStyle,
                      ),
                      _buildSection(
                        'Payments',
                        'All applicable payments must be completed through the available payment methods. Any additional charges, taxes, or service fees will be displayed where applicable.',
                        boldStyle,
                        regularStyle,
                      ),
                      _buildSection(
                        'Cancellation & Refund',
                        'Cancellation and refund requests will be handled according to the applicable cancellation and refund policy of Siva Sakthi.',
                        boldStyle,
                        regularStyle,
                      ),
                      _buildSection(
                        'Privacy',
                        'Personal information collected from users will be handled according to our Privacy Policy and applicable laws.',
                        boldStyle,
                        regularStyle,
                      ),
                      _buildSection(
                        'Third-Party Services',
                        'Siva Sakthi may use third-party services such as payment gateways, communication services, or external links. We are not responsible for issues caused directly by third-party platforms.',
                        boldStyle,
                        regularStyle,
                      ),
                      _buildSection(
                        'Intellectual Property',
                        'The Siva Sakthi name, logo, content, graphics, and other materials belong to Siva Sakthi or their respective owners and must not be copied or misused without permission.',
                        boldStyle,
                        regularStyle,
                      ),
                      _buildSection(
                        'Limitation of Liability',
                        'Siva Sakthi will make reasonable efforts to provide accurate and reliable services. However, we are not responsible for losses caused by circumstances beyond our reasonable control, technical interruptions, or incorrect information provided by users.',
                        boldStyle,
                        regularStyle,
                      ),
                      _buildSection(
                        'Changes to Terms',
                        'We may update these Terms and Conditions when required. Continued use of our services after an update means that you accept the revised terms.',
                        boldStyle,
                        regularStyle,
                      ),
                      _buildSection(
                        'Governing Law',
                        'These Terms and Conditions will be governed by the applicable laws of India. Any disputes will be subject to the jurisdiction specified by Siva Sakthi.',
                        boldStyle,
                        regularStyle,
                      ),
                      _buildSection(
                        'Contact Us',
                        'For questions regarding these Terms and Conditions, please contact Siva Sakthi through the official contact details provided on our website or application.',
                        boldStyle,
                        regularStyle,
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),

            // Bottom Sticky Card with Checkbox & Agree Button
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    offset: const Offset(0, -3),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () => setState(() => _isAgreed = !_isAgreed),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Checkbox: 18.46×18.46, outline-only (no fill), green tick when checked
                        GestureDetector(
                          onTap: () => setState(() => _isAgreed = !_isAgreed),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            width: 18.461538,
                            height: 18.461538,
                            decoration: BoxDecoration(
                              color: Colors.white, // always white background — no fill
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: _isAgreed
                                    ? const Color(0xFF12B76A) // green border when checked
                                    : const Color(0xFFD0D5DD), // gray border when unchecked
                                width: 1.5,
                              ),
                            ),
                            child: _isAgreed
                                ? CustomPaint(
                                    painter: _TickPainter(
                                      color: const Color(0xFF12B76A),
                                    ),
                                  )
                                : const SizedBox.shrink(),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'I have read and agree to the Terms & Risk\nDisclosure',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF344054),
                              height: 1.3,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  // Agree & Continue Button: full width, height: 50.08, border-radius: 11.08
                  SizedBox(
                    width: double.infinity,
                    height: 50.076923,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SivaSakthiHomeScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3C93F4),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(11.08),
                        ),
                      ),
                      child: Text(
                        'Agree & Continue',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
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
  }

  Widget _buildSection(
    String title,
    String body,
    TextStyle boldStyle,
    TextStyle regularStyle,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: boldStyle,
          ),
          const SizedBox(height: 4),
          Text(
            body,
            style: regularStyle,
          ),
        ],
      ),
    );
  }
}

/// Custom tick/checkmark painter — outline only, no fill. Color is passed in.
class _TickPainter extends CustomPainter {
  final Color color;
  const _TickPainter({this.color = const Color(0xFF12B76A)});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path()
      ..moveTo(size.width * 0.18, size.height * 0.50)
      ..lineTo(size.width * 0.42, size.height * 0.74)
      ..lineTo(size.width * 0.82, size.height * 0.28);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
