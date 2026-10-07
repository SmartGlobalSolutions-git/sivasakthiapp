import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:siva_sakthi/services/device_location_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:siva_sakthi/setting/need_help.dart';
import 'package:siva_sakthi/home/notification.dart';
import 'chit_model.dart';
import 'chit_statement_screen.dart';
import 'passbook_screen.dart';
import 'my_chits_screen.dart' show ChitItem, ChitPrizeStatus;

class ChitsDetailScreen extends StatefulWidget {
  final ChitItem chit;
  const ChitsDetailScreen({super.key, required this.chit});

  @override
  State<ChitsDetailScreen> createState() => _ChitsDetailScreenState();
}

class _ChitsDetailScreenState extends State<ChitsDetailScreen> {
  static const Color kBg = Color(0xFFF3F3F5);
  static const Color kLabel = Color(0xFF475569);
  static const Color kNavy = Color(0xFF1E293B);
  static const Color kGreen = Color(0xFF059669);
  static const Color kGold = Color(0xFFD9AB07);

  // Assets (PNG)
  static const String kBack = 'assets/chits/ic_back.png';
  static const String kHelp = 'assets/images/help_operator.png';
  static const String kBell = 'assets/images/notification.png';
  static const String kGroupGreen = 'assets/chits/ic_group_green.png';
  static const String kDividend = 'assets/icons/divident_chit.png';
  static const String kCoins = 'assets/icons/running_balance.png';
  static const String kStatement = 'assets/chits/ic_statement.png';
  static const String kPassbook = 'assets/chits/ic_passbook.png';
  static const String kChevron = 'assets/chits/ic_chevron_white.png';

  // ---------------- helpers ----------------
  TextStyle _t(double size, FontWeight w, Color c,
      {double? height, double? spacing}) =>
      GoogleFonts.inter(
        fontSize: size,
        fontWeight: w,
        color: c,
        height: height ?? 1.0,
        letterSpacing: spacing,
      );

  /// PNG icon with Material fallback (so app doesn't crash before assets are added)
  Widget _icon(String asset, double size, IconData fallback,
      {Color? color, double? height}) {
    return Image.asset(
      asset,
      width: size,
      height: height ?? size,
      fit: BoxFit.contain,
      errorBuilder: (c, e, s) => Icon(fallback, size: size, color: color ?? Colors.black87),
    );
  }

  bool _isLoading = true;
  String _runningBalance = '0';
  String _totalPaid = '0';
  int _due = 0;
  String _totalMonths = '0';

  @override
  void initState() {
    super.initState();
    _runningBalance = widget.chit.runningBalance;
    _totalPaid = widget.chit.totalDividend;
    _due = widget.chit.completedMonths;
    _totalMonths = widget.chit.totalMonths.toString();
    _fetchDue();
  }

  Future<void> _fetchDue() async {
    try {
      final String deviceId = await DeviceLocationService.getDeviceId();
      final Map<String, String> loc = await DeviceLocationService.getLocation();
      final response = await http.post(
        Uri.parse('https://chitsoft.in/wapp/api/chit_api/'),
        body: {
          'cid': '35318938',
          'type': '6009',
          'lt': loc['lat'] ?? '123',
          'ln': loc['lng'] ?? '123',
          'device_id': deviceId.isNotEmpty ? deviceId : '123',
          'chit_id': widget.chit.chitId,
          'cus_id': '1',
        },
      );
      if (response.statusCode == 200) {
        debugPrint('CHIT DUE API RESPONSE: ${response.body}');
        final data = json.decode(response.body);
        if (data['error'] == false) {
          if (mounted) {
            setState(() {
              _due = int.tryParse(data['due']?.toString() ?? '') ?? _due;
              _totalMonths = data['total_months']?.toString() ?? _totalMonths;
              _runningBalance = '₹${data['running_balance'] ?? 0}';
              _totalPaid = '₹${data['total_paid'] ?? 0}';
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
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      appBar: _buildAppBar(context),
      body: _isLoading 
          ? const Center(child: CircularProgressIndicator()) 
          : ListView(
        padding: const EdgeInsets.only(top: 17, bottom: 24),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _buildMainCard(),
          ),
          const SizedBox(height: 21),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _buildRunningBalance(),
          ),
          const SizedBox(height: 16),
          // Figma: Chit Duration section is 330 wide at left 14
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: _buildDuration(),
          ),
          const SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: _actionButton(
                    label: 'Chit Statement',
                    color: const Color(0xFF4659A5),
                    icon: kStatement,
                    fallback: Icons.description,
                    onTap: () {
                      final chitData = ChitData(
                        name: widget.chit.name,
                        chitId: widget.chit.chitId,
                        groupCode: widget.chit.groupCode,
                        isPrized: widget.chit.prizeStatus == ChitPrizeStatus.prized,
                        chitValue: widget.chit.chitValue,
                        startDate: widget.chit.startDate,
                        endDate: widget.chit.endDate,
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChitStatementScreen(chit: chitData),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: _actionButton(
                    label: 'Passbook',
                    color: const Color(0xFF78B22D),
                    icon: kPassbook,
                    fallback: Icons.menu_book,
                    onTap: () {
                      final chitData = ChitData(
                        name: widget.chit.name,
                        chitId: widget.chit.chitId,
                        groupCode: widget.chit.groupCode,
                        isPrized: widget.chit.prizeStatus == ChitPrizeStatus.prized,
                        chitValue: widget.chit.chitValue,
                        startDate: widget.chit.startDate,
                        endDate: widget.chit.endDate,
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChitPassbookScreen(chit: chitData),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
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
        onPressed: () => Navigator.of(context).maybePop(),
      ),
      title: Text(
        'Chits detail',
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
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.headset_mic, size: 14, color: Color(0xff266FAF)),
                ),
                const SizedBox(width: 4),
                Text(
                  'Need Help ?',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: Color(0xff266FAF),
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
              MaterialPageRoute(builder: (context) => const NotificationScreen()),
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

  // Figma: Group 1000004931 -> 328 x 160, white, border 0.6 #E2E5E8
  Widget _buildMainCard() {
    final prized = widget.chit.prizeStatus == ChitPrizeStatus.prized;
    return Container(
      height: 160,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE2E5E8), width: 0.6),
        boxShadow: const [
          BoxShadow(color: Color(0x33000000), offset: Offset(0, 4), blurRadius: 4),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            left: 13,
            top: 15,
            child: Container(
              width: 30,
              height: 30,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: Color(0xFFD1EBDD),
                shape: BoxShape.circle,
              ),
              child: _icon(kGroupGreen, 18, Icons.groups, color: kGreen),
            ),
          ),
          Positioned(
            left: 53,
            top: 14,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.chit.name,
                    style: _t(12, FontWeight.w500, Colors.black, spacing: -0.5)),
                if (widget.chit.chitId.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Row(
                      children: [
                        Text('CHIT ID -',
                            style: _t(10, FontWeight.w500, kLabel, spacing: 0.55)),
                        const SizedBox(width: 6),
                        Text(widget.chit.chitId, style: _t(11, FontWeight.w600, kNavy)),
                      ],
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Row(
                    children: [
                      Text('GROUP CODE',
                          style: _t(11, FontWeight.w500, kLabel, spacing: 0.55)),
                      const SizedBox(width: 6),
                      Text(widget.chit.groupCode, style: _t(16, FontWeight.w700, kNavy)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 10,
            top: 8,
            child: prized
                ? _badge('Prized', const Color(0xFFDDE3FF),
                const Color(0xFF2D3A8C), const Color(0xFF1E2A78))
                : _badge('Unpriced', const Color(0xFFF0FDF4),
                const Color(0xFFBBF7D0), const Color(0xFF047857)),
          ),
          // Chit Value / Start Date / End Date
          Positioned(
            left: 13,
            right: 12,
            top: 72,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 118,
                  child: _gridCol('Chit Value', widget.chit.chitValue,
                      _t(14, FontWeight.w700, kGreen, height: 20 / 14), 3.5),
                ),
                SizedBox(
                  width: 109,
                  child: _gridCol('Start Date', widget.chit.startDate, _dateStyle, 5.5),
                ),
                Expanded(child: _gridCol('End Date', widget.chit.endDate, _dateStyle, 5.5)),
              ],
            ),
          ),
          // Total dividend band (bottom 41)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 41,
            child: Container(
              color: const Color(0xFFF2F6FE),
              padding: const EdgeInsets.only(left: 33),
              child: Row(
                children: [
                  _icon(kDividend, 23, Icons.call_split, color: kGreen),
                  const SizedBox(width: 10),
                  Text('TOTAL PAiD',
                      style: _t(12, FontWeight.w500, kNavy, spacing: 0.6)),
                  const SizedBox(width: 24),
                  Text(_totalPaid,
                      style: _t(18, FontWeight.w700, kNavy, spacing: -0.45)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  TextStyle get _dateStyle => _t(10, FontWeight.w600, kNavy, height: 14 / 10);

  Widget _gridCol(String label, String value, TextStyle valueStyle, double gap) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: _t(11, FontWeight.w500, kLabel, height: 16.5 / 11)),
        SizedBox(height: gap),
        Text(value, style: valueStyle),
      ],
    );
  }

  Widget _buildRunningBalance() {
    return Container(
      height: 44,
      padding: const EdgeInsets.only(left: 33),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8DE),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: kGold, width: 1),
      ),
      child: Row(
        children: [
          _icon(kCoins, 24, Icons.savings, color: kGold, height: 26),
          const SizedBox(width: 12),
          Text('RUNNING BALANCE',
              style: _t(11, FontWeight.w500, const Color(0xFF022C22),
                  height: 16.5 / 11, spacing: 0.55)),
          const SizedBox(width: 6),
          Text(_runningBalance,
              style: _t(18, FontWeight.w700, const Color(0xFF003E21),
                  height: 28 / 18, spacing: -0.45)),
        ],
      ),
    );
  }

  Widget _buildDuration() {
    final done = _due;
    final totalStr = _totalMonths;
    final total = int.tryParse(totalStr) ?? widget.chit.totalMonths;
    return Container(
      height: 123,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF1F5F9), width: 1),
      ),
      child: Stack(
        children: [
          Positioned(
            left: 16,
            right: 16,
            top: 8,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Chit Duration',
                    style: _t(16, FontWeight.w600, const Color(0xFF0F172A),
                        height: 20 / 16)),
                Text.rich(TextSpan(children: [
                  TextSpan(
                      text: '$done',
                      style: _t(20, FontWeight.w700, const Color(0xFF0F172A))),
                  TextSpan(
                      text: ' / $total Months',
                      style: _t(14, FontWeight.w500, const Color(0xFF94A3B8))),
                ])),
              ],
            ),
          ),
          Positioned(
            left: 19,
            right: 19,
            top: 42,
            child: _buildTimeline(done, total),
          ),
          // Footer stats
          Positioned(
            left: 16,
            right: 16,
            top: 96,
            height: 20,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _dot(8, kGreen),
                      const SizedBox(width: 8),
                      _stat('Completed: ', '$done'),
                    ],
                  ),
                ),
                _dot(4, const Color(0xFFCBD5E1)),
                Align(
                  alignment: Alignment.centerRight,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _dot(8, const Color(0xFFCBD5E1)),
                      const SizedBox(width: 8),
                      _stat('Remaining: ', '${total - done}'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _dot(double size, Color color) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(color: color, shape: BoxShape.circle),
  );

  Widget _stat(String label, String value) => Text.rich(TextSpan(children: [
    TextSpan(text: label, style: _t(13, FontWeight.w400, kLabel)),
    TextSpan(text: value, style: _t(13, FontWeight.w600, kNavy)),
  ]));

  String _ordinal(int n) {
    if (n % 100 >= 11 && n % 100 <= 13) return '${n}th';
    switch (n % 10) {
      case 1:
        return '${n}st';
      case 2:
        return '${n}nd';
      case 3:
        return '${n}rd';
      default:
        return '${n}th';
    }
  }

  /// Track 288 x 12 (radius 9999, #F1F5F9, border #E2E8F0 60%), green progress,
  /// "6th" tag, 5 milestone dots (1, 5, 10, 15, 20) and labels.
  Widget _buildTimeline(int completed, int total) {
    const marks = [1, 5, 10, 15, 20];
    const tagW = 27.0;

    return LayoutBuilder(builder: (context, c) {
      final w = c.maxWidth;
      final progress = (completed / total).clamp(0.0, 1.0);
      final fillEnd = w * progress;

      // first: left aligned, last: right aligned, others centered at i * w/4
      Widget place(int i, double width, Widget child, double top) {
        if (i == 0) return Positioned(left: 0, top: top, child: child);
        if (i == marks.length - 1) return Positioned(right: 0, top: top, child: child);
        final x = i * (w / (marks.length - 1));
        return Positioned(left: x - width / 2, top: top, child: child);
      }

      return SizedBox(
        height: 52,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // track
            Positioned(
              left: 0,
              right: 0,
              top: 3,
              height: 12,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(9999),
                  border: Border.all(color: const Color(0x99E2E8F0), width: 1),
                ),
              ),
            ),
            // progress fill
            Positioned(
              left: 2,
              top: 5,
              height: 8,
              width: (fillEnd - 2).clamp(0.0, w),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(9999),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF10B981), Color(0xFF059669)],
                  ),
                ),
              ),
            ),
            // "6th" tag + pointer
            Positioned(
              left: fillEnd - tagW / 2,
              top: 0,
              child: Column(
                children: [
                  Container(
                    width: tagW,
                    height: 15,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: kGreen,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(_ordinal(completed),
                        style: _t(10, FontWeight.w700, Colors.white)),
                  ),
                  CustomPaint(size: const Size(8, 4), painter: _PointerPainter()),
                ],
              ),
            ),
            // dots
            for (int i = 0; i < marks.length; i++)
              place(
                i,
                6,
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: marks[i] <= completed ? kGreen : const Color(0xFFCBD5E1),
                    shape: BoxShape.circle,
                  ),
                ),
                26,
              ),
            // labels
            for (int i = 0; i < marks.length; i++)
              place(
                i,
                24,
                SizedBox(
                  width: (i == 0 || i == marks.length - 1) ? null : 24,
                  child: Text(
                    '${marks[i] == 20 ? total : marks[i]}',
                    textAlign: i == 0
                        ? TextAlign.left
                        : (i == marks.length - 1 ? TextAlign.right : TextAlign.center),
                    style: marks[i] <= completed
                        ? _t(12, FontWeight.w600, kGreen)
                        : _t(12, FontWeight.w500, const Color(0xFF94A3B8)),
                  ),
                ),
                35,
              ),
          ],
        ),
      );
    });
  }

  // Chit Statement / Passbook buttons: ~155 x 80, radius 12
  Widget _actionButton({
    required String label,
    required Color color,
    required String icon,
    required IconData fallback,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Stack(
          children: [
            Positioned(
              left: 16,
              top: 14,
              child: _icon(icon, 20, fallback, color: Colors.white),
            ),
            Positioned(
              right: 16,
              top: 16,
              child: _icon(kChevron, 12, Icons.chevron_right, color: Colors.white),
            ),
            Positioned(
              left: 16,
              bottom: 11,
              child: Text(label,
                  style: _t(18, FontWeight.w500, Colors.white, height: 22 / 18)),
            ),
          ],
        ),
      ),
    );
  }
}

class _PointerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width / 2, size.height)
      ..close();
    canvas.drawPath(path, Paint()..color = const Color(0xFF059669));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}