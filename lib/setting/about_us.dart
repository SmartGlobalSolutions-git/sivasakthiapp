import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../services/device_location_service.dart';

class _Colors {
  static const Color textBody = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);
}

class _TextStyles {
  static const String fontFamily = 'Inter';

  static const TextStyle body = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: _Colors.textBody,
    height: 1.6,
  );

  static const TextStyle bodyBold = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: _Colors.textBody,
    height: 1.6,
  );
}

class AboutUsScreen extends StatefulWidget {
  const AboutUsScreen({super.key});

  @override
  State<AboutUsScreen> createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {
  bool _isLoading = true;
  String _title = 'About Us';
  List<dynamic> _description = [];
  Map<String, dynamic> _mission = {};
  Map<String, dynamic> _vision = {};
  Map<String, dynamic> _coreValues = {};
  Map<String, dynamic> _whyChooseUs = {};
  Map<String, dynamic> _footer = {};

  @override
  void initState() {
    super.initState();
    _fetchAboutUs();
  }

  Future<void> _fetchAboutUs() async {
    try {
      final loc = await DeviceLocationService.getLocation();
      final deviceId = await DeviceLocationService.getDeviceId();
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      final response = await http.post(
        Uri.parse('https://chitsoft.in/wapp/api/chit_api/'),
        body: {
          'cid': '35318938',
          'type': '6015',
          'lt': loc['lat'] ?? '123',
          'ln': loc['lng'] ?? '123',
          'device_id': deviceId.isNotEmpty ? deviceId : '123',
          'token': token,
        },
      );

      if (response.statusCode == 200) {
        debugPrint('About Us API Response: ${response.body}');
        final data = json.decode(response.body);
        if (data['error'] == false && data['data'] != null) {
          if (mounted) {
            setState(() {
              _title = data['data']['title'] ?? _title;
              _description = data['data']['description'] ?? [];
              _mission = data['data']['mission'] ?? {};
              _vision = data['data']['vision'] ?? {};
              _coreValues = data['data']['core_values'] ?? {};
              _whyChooseUs = data['data']['why_choose_us'] ?? {};
              _footer = data['data']['footer'] ?? {};
              _isLoading = false;
            });
          }
          return;
        }
      }
    } catch (e) {
      debugPrint('Error fetching About Us: $e');
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _Colors.white,
      appBar: _Header(title: _title),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : ListView(
        padding: const EdgeInsets.fromLTRB(19, 16, 19, 32),
        children: [
          ..._description.map((desc) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(desc.toString(), style: _TextStyles.body),
            );
          }),
          const SizedBox(height: 4),

          if (_mission.isNotEmpty) ...[
            Text(_mission['title'] ?? 'Our Mission', style: _TextStyles.bodyBold),
            const SizedBox(height: 6),
            Text(_mission['content'] ?? '', style: _TextStyles.body),
            const SizedBox(height: 16),
          ],

          if (_vision.isNotEmpty) ...[
            Text(_vision['title'] ?? 'Our Vision', style: _TextStyles.bodyBold),
            const SizedBox(height: 6),
            Text(_vision['content'] ?? '', style: _TextStyles.body),
            const SizedBox(height: 16),
          ],

          if (_coreValues.isNotEmpty) ...[
            Text(_coreValues['title'] ?? 'Our Core Values', style: _TextStyles.bodyBold),
            const SizedBox(height: 6),
            _BulletList(items: [
              for (var item in (_coreValues['items'] ?? []))
                '${item['title']} – ${item['description']}'
            ]),
            const SizedBox(height: 16),
          ],

          if (_whyChooseUs.isNotEmpty) ...[
            Text(_whyChooseUs['title'] ?? '', style: _TextStyles.bodyBold),
            const SizedBox(height: 6),
            Text(_whyChooseUs['content'] ?? '', style: _TextStyles.body),
            const SizedBox(height: 16),
          ],

          if (_footer.isNotEmpty) ...[
            Text(_footer['company'] ?? '', style: _TextStyles.bodyBold),
            Text(_footer['tagline'] ?? '', style: _TextStyles.body),
          ],
        ],
      ),
    );
  }
}

class _BulletList extends StatelessWidget {
  const _BulletList({required this.items});
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items
          .map((e) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('•  ', style: _TextStyles.body),
            Expanded(child: Text(e, style: _TextStyles.body)),
          ],
        ),
      ))
          .toList(),
    );
  }
}

// 57px header, white bg, back arrow + title — matches Figma "Rectangle 4"
class _Header extends StatelessWidget implements PreferredSizeWidget {
  const _Header({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Color(0xFF000000), size: 22),
        onPressed: () => Navigator.of(context).maybePop(),
      ),
      titleSpacing: 0,
      title: Text(
        title,
        style: const TextStyle(
          color: Color(0xFF000000),
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}