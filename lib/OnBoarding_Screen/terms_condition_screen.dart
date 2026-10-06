import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:siva_sakthi/home/home.dart';
import '../services/device_location_service.dart';

class TermsAndConditionScreen extends StatefulWidget {
  const TermsAndConditionScreen({super.key});

  @override
  State<TermsAndConditionScreen> createState() =>
      _TermsAndConditionScreenState();
}

class _TermsAndConditionScreenState extends State<TermsAndConditionScreen> {
  bool _isAgreed = false;
  bool _isLoading = true;
  String _title = 'Terms & Condition';
  String _agreementText = 'I have read and agree to the Terms & Risk\nDisclosure';
  String _buttonText = 'Agree & Continue';
  List<dynamic> _sections = [];

  @override
  void initState() {
    super.initState();
    _fetchTerms();
  }

  Future<void> _fetchTerms() async {
    try {
      final loc = await DeviceLocationService.getLocation();
      final deviceId = await DeviceLocationService.getDeviceId();
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      final response = await http.post(
        Uri.parse('https://chitsoft.in/wapp/api/chit_api/'),
        body: {
          'cid': '35318938',
          'type': '6011',
          'lt': loc['lat'] ?? '123',
          'ln': loc['lng'] ?? '123',
          'device_id': deviceId.isNotEmpty ? deviceId : '123',
          'token': token,
        },
      );

      if (response.statusCode == 200) {
        debugPrint('Terms & Conditions API Response: ${response.body}');
        final data = json.decode(response.body);
        if (data['error'] == false && data['sections'] != null) {
          if (mounted) {
            setState(() {
              _title = data['sections']['title'] ?? _title;
              _agreementText = data['sections']['agreement_text'] ?? _agreementText;
              _buttonText = data['sections']['button_text'] ?? _buttonText;
              _sections = data['sections']['sections'] ?? [];
              _isLoading = false;
            });
          }
          return;
        }
      }
    } catch (e) {
      debugPrint('Error fetching Terms & Conditions: $e');
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    // Regular: Inter 400, 12px, line-height: 21px (height = 21/12 = 1.75)
    final regularStyle = GoogleFonts.inter(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      color: const Color(0xFF1D2939),
    );

    // Bold span: Inter 700, 12px, line-height: 21px
    final boldStyle = GoogleFonts.inter(
      fontSize: 12,
      fontWeight: FontWeight.w700,
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
                _title,
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
                  child: _isLoading 
                      ? const Center(child: CircularProgressIndicator())
                      : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Last Updated [Date]\nEffective From [Date]',
                        style: regularStyle,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'By registering, accessing or using the App, you agree to these $_title. These Terms govern use of the App as a digital service channel.',
                        style: regularStyle,
                      ),
                      const SizedBox(height: 14),
                      ..._sections.map((section) {
                        return _buildSection(
                          section['heading'] ?? '',
                          section['content'] ?? '',
                          boldStyle,
                          regularStyle,
                        );
                      }),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),

            // Bottom Sticky Card with Checkbox & Agree Button
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 16.0,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
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
                              color: Colors
                                  .white, // always white background — no fill
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: _isAgreed
                                    ? const Color(
                                        0xFF12B76A,
                                      ) // green border when checked
                                    : const Color(
                                        0xFFD0D5DD,
                                      ), // gray border when unchecked
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
                            _agreementText,
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
                      onPressed: () async {
                        if (!_isAgreed) {
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Please accept the Terms & Conditions to proceed.',
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
                          return;
                        }
                        
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setBool('isLoggedIn', true);

                        if (!mounted) return;
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
                        _buttonText,
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
          Text(title, style: boldStyle),
          const SizedBox(height: 4),
          Text(body, style: regularStyle),
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
