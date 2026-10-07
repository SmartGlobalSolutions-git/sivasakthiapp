import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import '../services/device_location_service.dart';
import 'chit_enquiry_dialog.dart';
import '../setting/need_help.dart';
import '../home/notification.dart';

class SubscriptionPlanScreen extends StatefulWidget {
  final String investmentAmount;
  final String durationMonths;
  final String planId;

  const SubscriptionPlanScreen({
    super.key,
    this.investmentAmount = '1,00,000',
    this.durationMonths = '20',
    this.planId = '16',
  });

  @override
  State<SubscriptionPlanScreen> createState() => _SubscriptionPlanScreenState();
}

class _SubscriptionPlanScreenState extends State<SubscriptionPlanScreen> {
  bool _isLoading = true;
  String? _errorMessage;
  Map<String, dynamic>? _itemData;
  List<dynamic> _scheduleList = [];
  Map<String, dynamic>? _totalsData;

  static const String _apiUrl = 'https://chitsoft.in/wapp/api/chit_api/';

  @override
  void initState() {
    super.initState();
    _fetchSubscriptionPlan();
  }

  String _formatAmount(dynamic val) {
    if (val == null) return '0';
    final numVal = num.tryParse(val.toString()) ?? 0;
    final str = numVal.toInt().toString();
    if (str.length <= 3) return str;
    final lastThree = str.substring(str.length - 3);
    final otherNumbers = str.substring(0, str.length - 3);
    final formatted = otherNumbers.replaceAllMapped(
        RegExp(r'(\d+?)(?=(\d\d)+$)'), (Match m) => '${m[1]},');
    return '$formatted,$lastThree';
  }

  Future<void> _fetchSubscriptionPlan() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final String deviceId = await DeviceLocationService.getDeviceId();
    final Map<String, String> loc = await DeviceLocationService.getLocation();

    final Map<String, String> formParams = {
      'cid': '35318938',
      'type': '6003',
      'lt': loc['lat'] ?? '123',
      'ln': loc['lng'] ?? '123',
      'device_id': deviceId.isNotEmpty ? deviceId : '123',
      'token': 'aiwg7ljinjgxw26r',
      'id': widget.planId,
    };

    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        body: formParams,
      ).timeout(const Duration(seconds: 10));

      debugPrint('==================================================');
      debugPrint('SUBSCRIPTION PLAN API REQUEST: $formParams');
      debugPrint('SUBSCRIPTION PLAN API STATUS CODE: ${response.statusCode}');
      debugPrint('SUBSCRIPTION PLAN API RESPONSE BODY: ${response.body}');
      debugPrint('==================================================');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        setState(() {
          _itemData = data['item'] as Map<String, dynamic>?;
          _scheduleList = (data['schedule'] as List<dynamic>?) ?? [];
          _totalsData = data['totals'] as Map<String, dynamic>?;
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'Failed to load plan (${response.statusCode})';
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('==================================================');
      debugPrint('SUBSCRIPTION PLAN API EXCEPTION: $e');
      debugPrint('==================================================');

      setState(() {
        _errorMessage = 'Network error: Unable to load subscription plan';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double statusBarH = MediaQuery.of(context).padding.top;
    final double bottomPadding = MediaQuery.of(context).padding.bottom;
    final double scaleW = screenSize.width / 360.0;
    final double scaleH = screenSize.height / 800.0;
    const Color primaryBlue =  Color(0xff266FAF);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Color(0xFF0D1519),
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: Color(0xFF0D1519),
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F9FB),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(56 * scaleH + statusBarH),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTopStatusBar(context, statusBarH),
              AppBar(
                primary: false,
                backgroundColor: Colors.white,
                elevation: 0,
                scrolledUnderElevation: 0,
                toolbarHeight: 56 * scaleH,
                systemOverlayStyle: const SystemUiOverlayStyle(
                  statusBarColor: Color(0xFF0D1519),
                  statusBarIconBrightness: Brightness.light,
                  statusBarBrightness: Brightness.dark,
                ),
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: const Color(0xFF1E2638),
                  size: (22 * scaleW).clamp(18.0, 24.0),
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
              titleSpacing: 0,
              title: Text(
                'Chit Scheme',
                style: GoogleFonts.inter(
                  fontSize: (16 * scaleW).clamp(14.0, 18.0),
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF1E2638),
                  height: 1.0,
                  letterSpacing: 0,
                ),
              ),
              actions: [
                // Need Help ? button
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const NeedHelpScreen()),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: (14 * scaleH).clamp(10.0, 16.0)),
                    padding: EdgeInsets.symmetric(
                      horizontal: (8 * scaleW).clamp(6.0, 12.0),
                      vertical: (4 * scaleH).clamp(3.0, 6.0),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16 * scaleW),
                      border: Border.all(color: const Color(0xFFD0D5DD), width: 0.8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'assets/images/help_operator.png',
                          width: 14 * scaleW,
                          height: 14 * scaleH,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) =>
                              Icon(Icons.headset_mic, size: 14 * scaleW, color: primaryBlue),
                        ),
                        SizedBox(width: 4 * scaleW),
                        Text(
                          'Need Help ?',
                          style: GoogleFonts.inter(
                            fontSize: (11 * scaleW).clamp(9.5, 13.0),
                            fontWeight: FontWeight.w500,
                            color: primaryBlue,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 4 * scaleW),
                // Notification Bell
                IconButton(
                  icon: Image.asset(
                    'assets/images/notification.png',
                    width: 20 * scaleW,
                    height: 20 * scaleH,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) =>
                        Icon(Icons.notifications_none, size: 20 * scaleW, color: const Color(0xFF1E2638)),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const NotificationScreen()),
                    );
                  },
                ),
                SizedBox(width: 6 * scaleW),
              ],
            ),
          ],
        ),
      ),
      body: SafeArea(
        top: false,
        child: Stack(
          children: [
            // Blue Gradient Banner behind Header & Upper Table (Size: 360 x 229 matching Figma)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 229 * scaleH.clamp(0.85, 1.2),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      primaryBlue.withValues(alpha: 0.85),
                      primaryBlue.withValues(alpha: 0.30),
                      Colors.white.withValues(alpha: 0.0),
                    ],
                    stops: const [0.0, 0.45, 0.90],
                  ),
                ),
              ),
            ),

            // Main Content: Amount, Table, and Enquire Now
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Amount Display: ₹ 1,00,000 (Color: #3C93F4)
                Center(
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: 10 * scaleH.clamp(0.85, 1.2),
                      bottom: 12 * scaleH.clamp(0.85, 1.2),
                    ),
                    child: Text(
                      '₹ ${_itemData != null && _itemData!['ch_value'] != null ? _formatAmount(_itemData!['ch_value']) : widget.investmentAmount}',
                      style: GoogleFonts.inter(
                        fontSize: 32 * scaleW.clamp(0.85, 1.2),
                        fontWeight: FontWeight.w800,
                        color: primaryBlue,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ),
                ),

                // Subscription Table Card (Blue Theme)
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 14 * scaleW.clamp(0.85, 1.2),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFCBD5E1), width: 1.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Column(
                          children: [
                            // Table Header (Solid Blue #3C93F4)
                            Container(
                              color: primaryBlue,
                              padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 4),
                              child: Row(
                                children: [
                                  _buildHeaderCell('Month', flex: 2, scale: scaleW),
                                  _buildHeaderCell('Due Amount\n(₹)', flex: 3, scale: scaleW),
                                  _buildHeaderCell('Divident\n(₹)', flex: 2, scale: scaleW),
                                  _buildHeaderCell('Bid Value\n(₹)', flex: 2, scale: scaleW),
                                  _buildHeaderCell('Payment\n(₹)', flex: 3, scale: scaleW, showRightBorder: false),
                                ],
                              ),
                            ),

                            // Scrollable Rows (dynamic schedule list from API)
                            Expanded(
                              child: _isLoading
                                  ? const Center(
                                      child: CircularProgressIndicator(
                                        color: primaryBlue,
                                      ),
                                    )
                                  : _errorMessage != null && _scheduleList.isEmpty
                                      ? Center(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                _errorMessage!,
                                                style: GoogleFonts.inter(
                                                  fontSize: 13,
                                                  color: const Color(0xFF64748B),
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              ElevatedButton(
                                                onPressed: _fetchSubscriptionPlan,
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: primaryBlue,
                                                  elevation: 0,
                                                ),
                                                child: const Text('Retry', style: TextStyle(color: Colors.white)),
                                              ),
                                            ],
                                          ),
                                        )
                                      : ScrollConfiguration(
                                          behavior: const ScrollBehavior().copyWith(overscroll: false),
                                          child: ListView.builder(
                                            physics: const ClampingScrollPhysics(),
                                            itemCount: _scheduleList.length,
                                            itemBuilder: (context, index) {
                                              final row = _scheduleList[index];
                                              final isEven = index % 2 == 0;
                                              final monthStr = row['sno']?.toString() ?? '${index + 1}';
                                              final subStr = _formatAmount(row['due_amt']);
                                              final divStr = _formatAmount(row['divident']);
                                              final bidStr = _formatAmount(row['bid_amt']);
                                              final prizeStr = _formatAmount(row['payment']);

                                              return Container(
                                                decoration: BoxDecoration(
                                                  color: isEven ? const Color(0xFFFAFCFF) : Colors.white,
                                                  border: const Border(
                                                    bottom: BorderSide(
                                                      color: Color(0xFFCBD5E1),
                                                      width: 1.0,
                                                    ),
                                                  ),
                                                ),
                                                child: Row(
                                                  children: [
                                                    _buildDataCell(monthStr, flex: 2, isMonth: true, scale: scaleW),
                                                    _buildDataCell(subStr, flex: 3, scale: scaleW),
                                                    _buildDataCell(divStr, flex: 2, scale: scaleW),
                                                    _buildDataCell(bidStr, flex: 2, scale: scaleW),
                                                    _buildDataCell(prizeStr, flex: 3, scale: scaleW, showRightBorder: false),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                            ),

                            // Total Row (Soft Blue #EBF4FE with dynamic totals from API)
                            Container(
                              decoration: const BoxDecoration(
                                color: Color(0xFFEBF4FE),
                                border: Border(
                                  top: BorderSide(color: Color(0xFFCBD5E1), width: 1.0),
                                  bottom: BorderSide(color: Color(0xFFCBD5E1), width: 1.0),
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 4),
                              child: Row(
                                children: [
                                  _buildSummaryCell('Total', flex: 2, isLabel: true, scale: scaleW),
                                  _buildSummaryCell(
                                    _totalsData != null ? _formatAmount(_totalsData!['due_amt']) : '—',
                                    flex: 3,
                                    scale: scaleW,
                                  ),
                                  _buildSummaryCell(
                                    _totalsData != null ? _formatAmount(_totalsData!['divident']) : '—',
                                    flex: 2,
                                    scale: scaleW,
                                  ),
                                  _buildSummaryCell('—', flex: 2, scale: scaleW),
                                  _buildSummaryCell(
                                    _totalsData != null ? _formatAmount(_totalsData!['total']) : '—',
                                    flex: 3,
                                    scale: scaleW,
                                    showRightBorder: false,
                                  ),
                                ],
                              ),
                            ),

                            // Indicative Note
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(
                                    Icons.info_outline,
                                    size: 15,
                                    color: primaryBlue,
                                  ),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      'This is an indicative plan. Values may vary based on actual chit group rules.',
                                      style: GoogleFonts.inriaSans(
                                        fontSize: 10 * scaleW.clamp(0.85, 1.2),
                                        color: const Color(0xFF475467),
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // Bottom Enquire Now Button (Long pill button per user screenshot)
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    20 * scaleW,
                    10 * scaleH,
                    20 * scaleW,
                    bottomPadding > 0 ? bottomPadding + 6 : 14 * scaleH,
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    height: (48 * scaleH).clamp(44.0, 56.0),
                    child: ElevatedButton(
                      onPressed: () {
                        showChitEnquiryDialog(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryBlue,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24 * scaleW),
                        ),
                      ),
                      child: Text(
                        'Enquire Now',
                        style: GoogleFonts.inter(
                          fontSize: (15 * scaleW).clamp(13.0, 17.0),
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

  Widget _buildHeaderCell(
    String text, {
    required int flex,
    required double scale,
    bool showRightBorder = true,
  }) {
    return Expanded(
      flex: flex,
      child: Container(
        decoration: BoxDecoration(
          border: showRightBorder
              ? Border(
                  right: BorderSide(
                    color: Colors.white.withValues(alpha: 0.35),
                    width: 1.0,
                  ),
                )
              : null,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            fontSize: 10 * scale,
            fontWeight: FontWeight.w600,
            color: Colors.white,
            height: 1.15,
          ),
        ),
      ),
    );
  }

  Widget _buildDataCell(
    String text, {
    required int flex,
    bool isMonth = false,
    bool showRightBorder = true,
    required double scale,
  }) {
    return Expanded(
      flex: flex,
      child: Container(
        decoration: BoxDecoration(
          border: showRightBorder
              ? const Border(
                  right: BorderSide(
                    color: Color(0xFFCBD5E1),
                    width: 1.0,
                  ),
                )
              : null,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 6),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: GoogleFonts.inriaSans(
            fontSize: 11 * scale,
            fontWeight: isMonth ? FontWeight.w700 : FontWeight.w400,
            color: isMonth ? const  Color(0xff266FAF) : const Color(0xFF1D2939),
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCell(
    String text, {
    required int flex,
    bool isLabel = false,
    bool showRightBorder = true,
    required double scale,
  }) {
    return Expanded(
      flex: flex,
      child: Container(
        decoration: BoxDecoration(
          border: showRightBorder
              ? const Border(
                  right: BorderSide(
                    color: Color(0xFFCBD5E1),
                    width: 1.0,
                  ),
                )
              : null,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: GoogleFonts.inriaSans(
            fontSize: 11 * scale,
            fontWeight: FontWeight.w700,
            color: Color(0xff266FAF),
          ),
        ),
      ),
    );
  }

  Widget _buildTopStatusBar(BuildContext context, double statusBarH) {
    final Size screenSize = MediaQuery.of(context).size;
    final double scaleW = screenSize.width / 360.0;

    return Container(
      width: screenSize.width,
      height: statusBarH,
      color: const Color(0xFF0D1519),
      padding: EdgeInsets.symmetric(horizontal: 14 * scaleW.clamp(0.85, 1.2)),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left side: 11:11 AM, Camera, Chat bubble icons
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '11:11 AM',
                style: GoogleFonts.inter(
                  fontSize: 11.5 * scaleW.clamp(0.85, 1.2),
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  height: 1.0,
                ),
              ),
              SizedBox(width: 6 * scaleW.clamp(0.85, 1.2)),
              Icon(
                Icons.camera_alt_outlined,
                size: 13 * scaleW.clamp(0.85, 1.2),
                color: Colors.white.withValues(alpha: 0.9),
              ),
              SizedBox(width: 5 * scaleW.clamp(0.85, 1.2)),
              Icon(
                Icons.chat_bubble_outline_rounded,
                size: 12.5 * scaleW.clamp(0.85, 1.2),
                color: Colors.white.withValues(alpha: 0.9),
              ),
            ],
          ),

          // Right side: 5G, cellular signal, battery with 50%
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '5G',
                style: GoogleFonts.inter(
                  fontSize: 10.5 * scaleW.clamp(0.85, 1.2),
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  height: 1.0,
                ),
              ),
              SizedBox(width: 4 * scaleW.clamp(0.85, 1.2)),
              Icon(
                Icons.signal_cellular_alt,
                size: 13.5 * scaleW.clamp(0.85, 1.2),
                color: Colors.white,
              ),
              SizedBox(width: 5 * scaleW.clamp(0.85, 1.2)),
              // Battery icon
              Container(
                width: 19 * scaleW.clamp(0.85, 1.2),
                height: 9.5 * scaleW.clamp(0.85, 1.2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2.5),
                  border: Border.all(color: Colors.white, width: 1.1),
                ),
                padding: const EdgeInsets.all(1.2),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    width: 8 * scaleW.clamp(0.85, 1.2),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(1),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 4 * scaleW.clamp(0.85, 1.2)),
              Text(
                '50%',
                style: GoogleFonts.inter(
                  fontSize: 10.5 * scaleW.clamp(0.85, 1.2),
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  height: 1.0,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

