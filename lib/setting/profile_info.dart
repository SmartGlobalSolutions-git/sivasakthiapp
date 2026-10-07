import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../services/device_location_service.dart';

// ---- Figma tokens (Profile) ----
class _Colors {
  static const Color primaryBlue = Color(0xff266FAF); // app bar + header curve
  static const Color iconBg = Color(0x1A3C93F4); // #3C93F4 @ 10%
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color name = Color(0xff266FAF);
  static const Color rowLabel = Color(0xFF111827);
  static const Color rowValue = Color(0xFF6B7280);
  static const Color border = Color(0xFFF3F4F6); // card border + dividers
  static const Color shadow = Color(0x0D000000); // #000000 @ 5%
  static const Color avatarRing = Color(0xFFC4C4C4);
}

class _TextStyles {
  // App bar title — Inter 400, 16px, white
  static const TextStyle appBarTitle = TextStyle(
    fontFamily: 'Inter',
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: _Colors.white,
  );

  // "Akhil Mohan" — Inter 600, 20px, #0E2E97
  static const TextStyle name = TextStyle(
    fontFamily: 'Inter',
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: _Colors.name,
    height: 1.2,
  );

  // "+91 7025053212" — Inter 500, 14px, #000000
  static const TextStyle phone = TextStyle(
    fontFamily: 'Inter',
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: _Colors.black,
    height: 1.2,
  );

  // "SSCHT10245" — Inter 600 (span), 14px, #000000
  static const TextStyle customerId = TextStyle(
    fontFamily: 'Inter',
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: _Colors.black,
    height: 1.2,
  );

  // "Personal information" — Inter 500, 16px, #000000
  static const TextStyle sectionTitle = TextStyle(
    fontFamily: 'Inter',
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: _Colors.black,
  );

  // Row label — Manrope 500, 13px, line-height 16.25, #111827
  // (add Manrope to pubspec.yaml fonts)
  static const TextStyle rowLabel = TextStyle(
    fontFamily: 'Manrope',
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: _Colors.rowLabel,
    height: 1.25,
  );

  // Row value — Manrope 400, 13px, line-height 18.57, #6B7280
  static const TextStyle rowValue = TextStyle(
    fontFamily: 'Manrope',
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: _Colors.rowValue,
    height: 1.43,
  );
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isLoading = true;
  String _name = '';
  String _phone = '';
  String _customerId = '';
  String _dateOfBirth = '';
  String _gender = '';
  String _email = '';
  String _address = '';

  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  Future<void> _fetchProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String savedCusId = prefs.getString('cus_id') ?? '1';

      final String deviceId = await DeviceLocationService.getDeviceId();
      final Map<String, String> loc = await DeviceLocationService.getLocation();
      
      final response = await http.post(
        Uri.parse('https://chitsoft.in/wapp/api/chit_api/'),
        body: {
          'cid': '35318938',
          'type': '6010',
          'lt': loc['lat'] ?? '123',
          'ln': loc['lng'] ?? '123',
          'device_id': deviceId.isNotEmpty ? deviceId : '123',
          'cus_id': savedCusId,
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['error'] == false) {
          if (mounted) {
            setState(() {
              String safeString(dynamic value) {
                final str = value?.toString().trim() ?? '';
                return str.isEmpty ? '-' : str;
              }

              _name = safeString(data['name']);
              _phone = safeString(data['mobile']);
              _customerId = safeString(data['cus_id']);
              _dateOfBirth = safeString(data['dob']);
              
              final genderCode = data['gender']?.toString().trim() ?? '';
              if (genderCode.isEmpty) {
                _gender = '-';
              } else {
                _gender = genderCode == 'M' ? 'Male' : (genderCode == 'F' ? 'Female' : genderCode);
              }
              
              _email = safeString(data['email']);
              _address = safeString(data['address']);
              _isLoading = false;
            });
          }
          return;
        }
      }
    } catch (_) {}

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final rows = <_InfoRow>[
      _InfoRow(icon: Icons.calendar_month_outlined, label: 'Date of Birth', value: _dateOfBirth),
      _InfoRow(icon: Icons.wc, label: 'Gender', value: _gender),
      _InfoRow(icon: Icons.mail_outline, label: 'Email Address', value: _email),
      _InfoRow(icon: Icons.location_on_outlined, label: 'Address', value: _address),
    ];

    return Scaffold(
      backgroundColor: _Colors.white,
      appBar: AppBar(
        backgroundColor: _Colors.primaryBlue,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        toolbarHeight: 57,
        leadingWidth: 47,
        titleSpacing: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: IconButton(
            padding: EdgeInsets.zero,
            icon: const Icon(Icons.arrow_back, color: _Colors.white),
            onPressed: () => Navigator.of(context).maybePop(),
          ),
        ),
        title: const Text('Profile', style: _TextStyles.appBarTitle),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Blue curved header (186) + avatar (150) overlapping it
            SizedBox(
              height: 198,
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    height: 186,
                    child: ClipPath(
                      clipper: _HeaderCurveClipper(),
                      child: const ColoredBox(color: _Colors.primaryBlue),
                    ),
                  ),
                  Positioned(
                    top: 49,
                    left: 0,
                    right: 0,
                    child: Center(child: _Avatar(image: null)),
                  ),
                ],
              ),
            ),
            if (_isLoading)
              const Padding(
                padding: EdgeInsets.only(top: 50),
                child: Center(child: CircularProgressIndicator(color: _Colors.primaryBlue)),
              )
            else ...[
              const SizedBox(height: 15),
              Text(_name, style: _TextStyles.name),
              const SizedBox(height: 4),
              Text(_phone, style: _TextStyles.phone),
              const SizedBox(height: 23),
            const Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 22),
                child: Text('Personal information', style: _TextStyles.sectionTitle),
              ),
            ),
            const SizedBox(height: 31),
            // 325 wide, radius 14.86, 0.93px border, shadow y0.93 blur1.86 @ 5%
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 17),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: _Colors.white,
                  borderRadius: BorderRadius.circular(14.86),
                  border: Border.all(color: _Colors.border, width: 0.93),
                  boxShadow: const [
                    BoxShadow(
                      color: _Colors.shadow,
                      offset: Offset(0, 0.93),
                      blurRadius: 1.86,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Column(
                    children: [
                      for (int i = 0; i < rows.length; i++) ...[
                        rows[i],
                        if (i != rows.length - 1)
                          Container(height: 0.93, color: _Colors.border),
                      ],
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
          ],
        ),
      ),
    );
  }
}

// Blue header whose bottom edge dips at the sides and rises behind the avatar
class _HeaderCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final w = size.width;
    final h = size.height;
    return Path()
      ..moveTo(0, 0)
      ..lineTo(0, h)
      ..cubicTo(w * 0.10, h - 3, w * 0.22, h - 19, w * 0.36, h - 41)
      ..lineTo(w * 0.64, h - 41)
      ..cubicTo(w * 0.78, h - 19, w * 0.90, h - 3, w, h)
      ..lineTo(w, 0)
      ..close();
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

// 150px circle with grey ring
class _Avatar extends StatelessWidget {
  const _Avatar({this.image});
  final ImageProvider? image;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 150,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _Colors.white,
        border: Border.all(color: _Colors.avatarRing, width: 3),
      ),
      child: ClipOval(
        child: image != null
            ? Image(image: image!, fit: BoxFit.cover)
            : const Icon(Icons.person, size: 80, color: _Colors.avatarRing),
      ),
    );
  }
}

// Icon box 34x34 (radius 8, #3C93F4 @ 10%) + label/value, padding 17 / 14.5
class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.label, required this.value});

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(17, 14.5, 17, 14.5),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: _Colors.iconBg,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 20, color: _Colors.primaryBlue),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(label, style: _TextStyles.rowLabel),
                const SizedBox(height: 4),
                Text(value, style: _TextStyles.rowValue),
              ],
            ),
          ),
        ],
      ),
    );
  }
}