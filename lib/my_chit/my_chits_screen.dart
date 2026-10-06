import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:siva_sakthi/services/device_location_service.dart';
import 'package:siva_sakthi/bottom_navbar.dart';
import 'package:siva_sakthi/my_chit/chit_detail_screen.dart';
import 'package:siva_sakthi/setting/need_help.dart';
import 'package:siva_sakthi/home/notification.dart';
import 'package:siva_sakthi/home/home.dart';

enum ChitPrizeStatus { nonPrized, prized }

class ChitItem {
  final String name;
  final String chitId;
  final String groupCode;
  final String chitValue;
  final String startDate;
  final String endDate;
  final ChitPrizeStatus prizeStatus;
  final String totalDividend;
  final String runningBalance;
  final int completedMonths;
  final int totalMonths;

  const ChitItem({
    required this.name,
    required this.chitId,
    required this.groupCode,
    required this.chitValue,
    required this.startDate,
    required this.endDate,
    required this.prizeStatus,
    required this.totalDividend,
    required this.runningBalance,
    required this.completedMonths,
    required this.totalMonths,
  });
}

class MyChitsScreen extends StatefulWidget {
  /// Set false if your app already has a bottom nav shell.
  final bool showBottomNav;

  const MyChitsScreen({super.key, this.showBottomNav = true});

  @override
  State<MyChitsScreen> createState() => _MyChitsScreenState();
}

class _MyChitsScreenState extends State<MyChitsScreen> {
  static const Color kBg = Color(0xFFF3F3F5);
  static const Color kBlue = Color(0xFF3C93F4);
  static const Color kLabel = Color(0xFF475569);
  static const Color kNavy = Color(0xFF1E293B);

  // Assets (PNG)
  static const String kBack = 'assets/chits/ic_back.png';
  static const String kHelp = 'assets/images/help_operator.png';
  static const String kBell = 'assets/images/notification.png';
  static const String kGroupBlue = 'assets/chits/ic_group_blue.png';
  static const String kArrowRight = 'assets/chits/ic_arrow_right_blue.png';

  List<ChitItem> _chits = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchChits();
  }

  Future<void> _fetchChits() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String savedCusId = prefs.getString('cus_id') ?? '1';

      final String deviceId = await DeviceLocationService.getDeviceId();
      final Map<String, String> loc = await DeviceLocationService.getLocation();
      final response = await http.post(
        Uri.parse('https://chitsoft.in/wapp/api/chit_api/'),
        body: {
          'cid': '35318938',
          'type': '6004',
          'lt': loc['lat'] ?? '123',
          'ln': loc['lng'] ?? '123',
          'device_id': deviceId.isNotEmpty ? deviceId : '123',
          'cus_id': savedCusId,
        },
      );
      if (response.statusCode == 200) {
        debugPrint('MY CHITS API RESPONSE: ${response.body}');
        final data = json.decode(response.body);
        if (data['error'] == false && data['plans'] != null) {
          final List<dynamic> plansJson = data['plans'];
          final List<ChitItem> loadedChits = plansJson.map((jsonItem) {
            final name = jsonItem['name']?.toString() ?? '';
            final chitId = jsonItem['chit_sno']?.toString() ?? '';

            final groupCode = jsonItem['gname']?.toString() ?? '';
            final chitValueStr = jsonItem['ch_value']?.toString() ?? '0';
            final startDate = jsonItem['cd_date']?.toString() ?? '';
            final endDate = jsonItem['td_date']?.toString() ?? '';

            final prizeStatusStr = jsonItem['prize_status']?.toString() ?? '';
            final prizeStatus = prizeStatusStr.toLowerCase() == 'prized'
                ? ChitPrizeStatus.prized
                : ChitPrizeStatus.nonPrized;

            final totalDividend = jsonItem['total_divident']?.toString() ?? '0';
            final totalDue = jsonItem['total_due_amt']?.toString() ?? '0';

            final completedMonths =
                int.tryParse(jsonItem['months_elapsed']?.toString() ?? '0') ??
                0;
            final totalMonths =
                int.tryParse(jsonItem['total_months']?.toString() ?? '0') ?? 0;

            return ChitItem(
              name: name,
              chitId: chitId,
              groupCode: groupCode,
              chitValue: '₹ $chitValueStr',
              startDate: _formatDate(startDate),
              endDate: _formatDate(endDate),
              prizeStatus: prizeStatus,
              totalDividend: '₹ $totalDividend',
              runningBalance: '₹ $totalDue',
              completedMonths: completedMonths,
              totalMonths: totalMonths,
            );
          }).toList();

          if (mounted) {
            setState(() {
              _chits = loadedChits;
              _isLoading = false;
            });
          }
        } else {
          if (mounted) setState(() => _isLoading = false);
        }
      } else {
        if (mounted) setState(() => _isLoading = false);
      }
    } catch (e) {
      debugPrint('Error fetching chits: $e');
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String _formatDate(String dateStr) {
    if (dateStr.isEmpty || dateStr == '0000-00-00') return '';
    try {
      final DateTime d = DateTime.parse(dateStr);
      final months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];
      return '${d.day.toString().padLeft(2, '0')} ${months[d.month - 1]} ${d.year}';
    } catch (e) {
      return dateStr;
    }
  }

  // ---------------- helpers ----------------
  TextStyle _t(
    double size,
    FontWeight w,
    Color c, {
    double? height,
    double? spacing,
  }) => GoogleFonts.inter(
    fontSize: size,
    fontWeight: w,
    color: c,
    height: height ?? 1.0,
    letterSpacing: spacing,
  );

  /// PNG icon with Material fallback (so app doesn't crash before assets are added)
  Widget _icon(String asset, double size, IconData fallback, {Color? color}) {
    return Image.asset(
      asset,
      width: size,
      height: size,
      fit: BoxFit.contain,
      errorBuilder: (c, e, s) =>
          Icon(fallback, size: size, color: color ?? Colors.black87),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      appBar: _buildAppBar(context),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _chits.isEmpty
          ? const Center(child: Text("No chits found"))
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 11, 16, 24),
              itemCount: _chits.length,
              separatorBuilder: (_, __) => const SizedBox(height: 18),
              itemBuilder: (context, i) => _buildCard(context, _chits[i]),
            ),
      bottomNavigationBar: widget.showBottomNav
          ? MainIconeFrames(
              currentIndex: 1,
              onTabSelected: (index) =>
                  MainIconeFrames.navigateToTab(context, 1, index),
            )
          : const SizedBox.shrink(),
    );
  }

  // ---------------- App bar ----------------
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFFF4F5F7),
      elevation: 0,
      scrolledUnderElevation: 0,
      automaticallyImplyLeading: false,
      centerTitle: false,
      titleSpacing: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Color(0xFF1E2638), size: 22),
        onPressed: () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const SivaSakthiHomeScreen()),
            (route) => false,
          );
        },
      ),
      title: Text(
        'My Chits',
        style: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: const Color(0xFF1E2638),
        ),
      ),
      actions: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const NeedHelpScreen()),
            );
          },
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 14),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFD0D5DD), width: 0.8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/images/help_operator.png',
                  width: 14,
                  height: 14,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.headset_mic,
                    size: 14,
                    color: Color(0xFF3C93F4),
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  'Need Help ?',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF3C93F4),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 4),
        IconButton(
          icon: Image.asset(
            'assets/images/notification.png',
            width: 20,
            height: 20,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.notifications_none, color: Color(0xFF1E2638)),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const NotificationScreen(),
              ),
            );
          },
        ),
        const SizedBox(width: 6),
      ],
    );
  }

  // Status pill: hug x 26, radius 9999, border 1, padding 4/10, gap 6
  Widget _badge(String label, Color bg, Color border, Color fg) {
    return Container(
      height: 26,
      padding: const EdgeInsets.symmetric(horizontal: 9),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(9999),
        border: Border.all(color: border, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: fg, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(label, style: _t(13, FontWeight.w600, fg)),
        ],
      ),
    );
  }

  // Figma: Chit card 328 x 143, radius 8, border 0.6 #3C93F4, white,
  // shadow x0 y4 blur4 #000 25%
  Widget _buildCard(BuildContext context, ChitItem c) {
    final prized = c.prizeStatus == ChitPrizeStatus.prized;
    return Container(
      height: 143,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: kBlue, width: 0.6),
        boxShadow: const [
          BoxShadow(
            color: Color(0x40000000),
            offset: Offset(0, 4),
            blurRadius: 4,
          ),
        ],
      ),
      child: Stack(
        children: [
          // Avatar block 63 x 54, #3C93F4 @20%
          Positioned(
            left: 0,
            top: 1,
            width: 63,
            height: 54,
            child: Container(
              color: const Color(0x333C93F4),
              child: Stack(
                children: [
                  Positioned(
                    top: 7,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        width: 26,
                        height: 26,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: _icon(
                          kGroupBlue,
                          16,
                          Icons.groups,
                          color: kBlue,
                        ),
                      ),
                    ),
                  ),
                  // Active pill 45 x 12, radius 12, #3C93F4
                  Positioned(
                    top: 37,
                    left: 9,
                    width: 45,
                    height: 12,
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: kBlue,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Active',
                        style: _t(9.5, FontWeight.w500, Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // header divider
          const Positioned(
            left: 0,
            right: 0,
            top: 54,
            height: 1,
            child: ColoredBox(color: Color(0xFFE5E7EB)),
          ),
          // Name + Chit ID + group code
          Positioned(
            left: 71,
            top: 7,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  c.name,
                  style: _t(12, FontWeight.w500, Colors.black, spacing: -0.5),
                ),
                if (c.chitId.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Row(
                      children: [
                        Text(
                          'CHIT ID -',
                          style: _t(10, FontWeight.w500, kLabel, spacing: 0.55),
                        ),
                        const SizedBox(width: 6),
                        Text(c.chitId, style: _t(11, FontWeight.w600, kNavy)),
                      ],
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Row(
                    children: [
                      Text(
                        'GROUP CODE',
                        style: _t(10, FontWeight.w500, kLabel, spacing: 0.55),
                      ),
                      const SizedBox(width: 6),
                      Text(c.groupCode, style: _t(11, FontWeight.w600, kNavy)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Prize badge
          Positioned(
            right: 7,
            top: 8,
            child: prized
                ? _badge(
                    'Prized',
                    const Color(0xFFDDE3FF),
                    const Color(0xFF2D3A8C),
                    const Color(0xFF1E2A78),
                  )
                : _badge(
                    'Non-prized',
                    const Color(0xFFFFFAE6),
                    const Color(0xFFD9AB07),
                    const Color(0xFFD9AB07),
                  ),
          ),
          // Chit Value / Start Date / End Date
          Positioned(
            left: 14,
            right: 12,
            top: 63,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 119,
                  child: _gridCol(
                    'Chit Value',
                    c.chitValue,
                    _t(
                      14,
                      FontWeight.w700,
                      const Color(0xFF2545C4),
                      height: 20 / 14,
                    ),
                    2.5,
                  ),
                ),
                SizedBox(
                  width: 108,
                  child: _gridCol('Start Date', c.startDate, _dateStyle, 4.5),
                ),
                Expanded(
                  child: _gridCol('End Date', c.endDate, _dateStyle, 4.5),
                ),
              ],
            ),
          ),
          // View Detail ->
          Positioned(
            right: 12,
            top: 118,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ChitsDetailScreen(chit: c)),
              ),
              child: Row(
                children: [
                  Text('View Detail', style: _t(12, FontWeight.w400, kBlue)),
                  const SizedBox(width: 4),
                  _icon(kArrowRight, 14, Icons.arrow_forward, color: kBlue),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  TextStyle get _dateStyle => _t(10, FontWeight.w600, kNavy, height: 14 / 10);

  Widget _gridCol(
    String label,
    String value,
    TextStyle valueStyle,
    double gap,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: _t(11, FontWeight.w500, kLabel, height: 16.5 / 11)),
        SizedBox(height: gap),
        Text(value, style: valueStyle),
      ],
    );
  }
}
