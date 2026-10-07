import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../services/device_location_service.dart';
import 'contact_support.dart';


// ---- Figma tokens (FAQ) ----
class _Colors {
  static const Color primaryBlue = Color(0xff266FAF);
  static const Color border = Color(0xFFF3F4F6);
  static const Color textDark = Color(0xFF111827);
  static const Color textBody = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);
  static const Color scaffoldBg = Color(0xFFF7F8FA);
  static const Color shadow = Color(0x08000000);
}

class _TextStyles {
  static const String fontFamily = 'Inter';
  static const TextStyle faqQuestion = TextStyle(
    fontFamily: fontFamily,
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: _Colors.textDark,
    height: 1.35,
  );

  static const TextStyle faqAnswer = TextStyle(
    fontFamily: fontFamily,
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: _Colors.white,
    height: 1.4,
  );

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
  );
}

class _FaqItem {
  const _FaqItem(this.question, this.answer);
  final String question;
  final String answer;
}

class FaqScreen extends StatefulWidget {
  const FaqScreen({super.key});

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  bool _isLoading = true;
  List<_FaqItem> _faqItems = [];
  int? _expandedIndex = 0;

  @override
  void initState() {
    super.initState();
    _fetchFaq();
  }

  Future<void> _fetchFaq() async {
    try {
      final loc = await DeviceLocationService.getLocation();
      final deviceId = await DeviceLocationService.getDeviceId();
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      final response = await http.post(
        Uri.parse('https://chitsoft.in/wapp/api/chit_api/'),
        body: {
          'cid': '35318938',
          'type': '6014',
          'lt': loc['lat'] ?? '123',
          'ln': loc['lng'] ?? '123',
          'device_id': deviceId.isNotEmpty ? deviceId : '123',
          'token': token,
        },
      );

      if (response.statusCode == 200) {
        debugPrint('FAQ API Response: ${response.body}');
        final data = json.decode(response.body);
        if (data['error'] == false && data['faq'] != null) {
          final List<dynamic> faqList = data['faq'];
          if (mounted) {
            setState(() {
              _faqItems = faqList.map((f) => _FaqItem(
                f['question']?.toString() ?? '', 
                f['answer']?.toString() ?? ''
              )).toList();
              _isLoading = false;
            });
          }
          return;
        }
      }
    } catch (e) {
      debugPrint('Error fetching FAQ: $e');
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
      backgroundColor: _Colors.scaffoldBg,
      appBar: _Header(title: 'FAQ'),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: [
          for (int i = 0; i < _faqItems.length; i++) ...[
            _FaqCard(
              index: i + 1,
              item: _faqItems[i],
              expanded: _expandedIndex == i,
              onTap: () => setState(() {
                _expandedIndex = _expandedIndex == i ? null : i;
              }),
            ),
            const SizedBox(height: 12),
          ],
          const _ContactSupportCard(),
        ],
      ),
    );
  }
}

class _FaqCard extends StatelessWidget {
  const _FaqCard({
    required this.index,
    required this.item,
    required this.expanded,
    required this.onTap,
  });

  final int index;
  final _FaqItem item;
  final bool expanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: double.infinity,
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: _Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: _Colors.border, width: 0.93),
        boxShadow: const [
          BoxShadow(color: _Colors.shadow, blurRadius: 2.8, offset: Offset(0, 0.93)),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _NumberBadge(number: index),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(item.question, style: _TextStyles.faqQuestion),
                ),
                Icon(
                  expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  color: _Colors.textDark,
                ),
              ],
            ),
            if (expanded) ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(11),
                decoration: BoxDecoration(
                  color: _Colors.primaryBlue,
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Text(item.answer, style: _TextStyles.faqAnswer),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _NumberBadge extends StatelessWidget {
  const _NumberBadge({required this.number});
  final int number;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 26,
      height: 26,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: _Colors.primaryBlue.withValues(alpha: 0.12),
        shape: BoxShape.circle,
      ),
      child: Text(
        '$number',
        style: _TextStyles.faqQuestion.copyWith(
          color: _Colors.primaryBlue,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _ContactSupportCard extends StatelessWidget {
  const _ContactSupportCard();

  void _navigateToContactUs(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ContactUsScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _navigateToContactUs(context),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _Colors.primaryBlue.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              decoration: const BoxDecoration(color: _Colors.white, shape: BoxShape.circle),
              child: const Icon(Icons.headset_mic_outlined, color: _Colors.primaryBlue),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Still have a question?', style: _TextStyles.bodyBold.copyWith(fontSize: 14)),
                  Text("We're here to help you.", style: _TextStyles.body.copyWith(fontSize: 12)),
                ],
              ),
            ),
            OutlinedButton(
              onPressed: () => _navigateToContactUs(context),
              style: OutlinedButton.styleFrom(
                foregroundColor: _Colors.primaryBlue,
                side: const BorderSide(color: _Colors.primaryBlue),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [Text('Contact Support'), SizedBox(width: 4), Icon(Icons.arrow_forward, size: 16)],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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