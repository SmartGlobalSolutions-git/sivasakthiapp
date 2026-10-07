import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:siva_sakthi/services/device_location_service.dart';
import 'package:siva_sakthi/bottom_navbar.dart';
import 'package:siva_sakthi/home/available_chit_screen.dart';
import 'package:siva_sakthi/home/chit_schem_screen.dart';
import 'package:siva_sakthi/home/menu.dart';
import 'package:siva_sakthi/home/notification.dart';
import 'package:siva_sakthi/setting/about_us.dart';
import 'package:siva_sakthi/setting/faq_screen.dart';
import 'package:siva_sakthi/setting/need_help.dart';
import 'package:siva_sakthi/my_chit/my_chits_screen.dart' hide ChitItem;
import 'package:siva_sakthi/payment/enter_payment.dart';
import 'package:siva_sakthi/payment/payment_model.dart';
import 'package:siva_sakthi/calculator/chit_enquiry_dialog.dart';
import 'package:siva_sakthi/calculator/calculator_scheme.dart';
// ==========================================================
// SIVA SAKTHI CHIT FUNDS - HOME SCREEN
// ==========================================================

class SivaSakthiHomeScreen extends StatefulWidget {
  const SivaSakthiHomeScreen({super.key});

  @override
  State<SivaSakthiHomeScreen> createState() => _SivaSakthiHomeScreenState();
}

class _SivaSakthiHomeScreenState extends State<SivaSakthiHomeScreen> {
  // ---- Figma colors ----
  static const Color kBlue = Color(0xff266FAF);
  static const Color kBlack = Color(0xFF000000);
  static const Color kBorderGrey = Color(0xFF9B9B9B);
  static const Color kDivider = Color(0xFFD7D7D7);
  static const Color kCardBg = Color(0xFFF6F6F6);
  static const Color kRed = Color(0xFFD40909);
  static const Color kGreenEnd = Color(0xFF43D389);
  static const Color kYellowEnd = Color(0xFFE9C958);
  static const Color kRedEnd = Color(0xFFD23D51);

  final PageController _bannerController = PageController();
  int _bannerIndex = 0;
  Timer? _bannerTimer;

  final List<String> _bannerImages = const [
    'assets/home/banner_1.png',
    'assets/home/banner_2.png',
    'assets/home/banner_3.png',
  ];

  String _selectedPlan = 'Smart Savings Scheme';
  final TextEditingController _investmentCtrl = TextEditingController();
  final TextEditingController _emiCtrl = TextEditingController();
  int _noOfEmis = 20;
  int _noOfMembers = 20;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _userName = 'Loading...';
  bool _isLoadingPlan = false;

  @override
  void initState() {
    super.initState();
    _startBannerAutoScroll();
    _fetchProfileName();
  }

  Future<void> _fetchProfileName() async {
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
              final String fetchedName = data['name']?.toString().trim() ?? '';
              _userName = fetchedName.isEmpty ? 'User' : fetchedName;
            });
          }
        } else {
          if (mounted) setState(() => _userName = 'User');
        }
      } else {
        if (mounted) setState(() => _userName = 'User');
      }
    } catch (e) {
      debugPrint('Error fetching profile in home.dart: $e');
      if (mounted) setState(() => _userName = 'User');
    }
  }

  void _startBannerAutoScroll() {
    _bannerTimer?.cancel();
    _bannerTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (_bannerController.hasClients) {
        final nextPage = (_bannerIndex + 1) % _bannerImages.length;
        _bannerController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _bannerTimer?.cancel();
    _bannerController.dispose();
    _investmentCtrl.dispose();
    _emiCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;
    final sh = MediaQuery.of(context).size.height;
    double w(double v) => sw * (v / 360);
    double h(double v) => sh * (v / 812);

    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        width: sw * 0.82,
        backgroundColor: Colors.white,
        elevation: 16,
        shape: const RoundedRectangleBorder(),
        child: ProfileMenuScreen(userName: _userName),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildTopBar(w, h),
            Expanded(
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildBanner(w, h),
                    SizedBox(height: h(12)),
                    _buildDots(w, h),
                    SizedBox(height: h(18)),
                    _buildQuickActionCards(w, h),
                    SizedBox(height: h(16)),
                    _buildPaymentDueCard(w, h),
                    SizedBox(height: h(16)),
                    _buildPaymentAssistanceCard(w, h),
                    SizedBox(height: h(24)),
                    _buildPlanYourGrowth(w, h),
                    SizedBox(height: h(24)),
                    _buildExploreSection(w, h),
                    SizedBox(height: h(24)),
                    _buildQuickLinks(w, h),
                    SizedBox(height: h(16)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: MainIconeFrames(
        currentIndex: 0,
        onTabSelected: (index) =>
            MainIconeFrames.navigateToTab(context, 0, index),
      ),
    );
  }

  // ---------------- Top bar ----------------
  Widget _buildTopBar(double Function(double) w, double Function(double) h) {
    return Padding(
      padding: EdgeInsets.fromLTRB(w(16), h(12), w(16), h(12)),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              _scaffoldKey.currentState?.openDrawer();
            },
            child: Icon(Icons.menu, color: kBlack, size: w(24)),
          ),
          SizedBox(width: w(16)),
          Text(
            'Hello $_userName',
            style: TextStyle(
              color: kBlack,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NeedHelpScreen()),
              );
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: w(12), vertical: h(7)),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: kBorderGrey, width: 0.6),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/icons/need_help.png',
                    width: w(14),
                    height: w(14),
                    fit: BoxFit.contain,
                  ),
                  SizedBox(width: w(4)),
                  const Text(
                    'Need Help ?',
                    style: TextStyle(
                      color: kBlue,
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: w(14)),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationScreen(),
                ),
              );
            },
            child: Image.asset(
              'assets/icons/notifi.png',
              width: w(24),
              height: w(24),
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- Banner carousel ----------------
  Widget _buildBanner(double Function(double) w, double Function(double) h) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: w(0)),
      child: SizedBox(
        height: h(171),
        child: PageView.builder(
          controller: _bannerController,
          onPageChanged: (i) => setState(() => _bannerIndex = i),
          itemCount: _bannerImages.length,
          itemBuilder: (context, index) =>
              _bannerCard(w, h, _bannerImages[index]),
        ),
      ),
    );
  }

  Widget _bannerCard(
    double Function(double) w,
    double Function(double) h,
    String imagePath,
  ) {
    return GestureDetector(
      onTap: () {
        // Navigate to Plan Screen
      },
      child: Image.asset(
        imagePath,
        width: double.infinity,
        height: h(171),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          color: const Color(0xFFEAF2FB),
          alignment: Alignment.center,
          child: const Icon(Icons.image_outlined, color: kBlue),
        ),
      ),
    );
  }

  Widget _buildDots(double Function(double) w, double Function(double) h) {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(_bannerImages.length, (i) {
          final bool active = i == _bannerIndex;
          return Container(
            margin: EdgeInsets.symmetric(horizontal: w(2)),
            width: active ? w(18) : w(6),
            height: h(6),
            decoration: BoxDecoration(
              color: active ? kBlue : const Color(0xFFD9D9D9),
              borderRadius: BorderRadius.circular(4),
            ),
          );
        }),
      ),
    );
  }

  // ---------------- 3 quick-action gradient cards ----------------
  Widget _buildQuickActionCards(
    double Function(double) w,
    double Function(double) h,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: w(16)),
      child: Row(
        children: [
          Expanded(
            child: _quickActionCard(
              w,
              h,
              icon: Icons.map_outlined,
              title: 'My Chit',
              subtitle: 'Chit Overview',
              endColor: kGreenEnd,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MyChitsScreen(),
                  ),
                );
              },
            ),
          ),
          SizedBox(width: w(8)),
          Expanded(
            child: _quickActionCard(
              w,
              h,
              icon: Icons.calendar_today,
              title: 'Available Chits',
              subtitle: 'View available chit plans',
              endColor: kYellowEnd,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AvailableChitScreen(),
                  ),
                );
              },
            ),
          ),
          SizedBox(width: w(8)),
          Expanded(
            child: _quickActionCard(
              w,
              h,
              icon: Icons.groups_outlined,
              title: 'Chit Scheme',
              subtitle: 'Explore available chit plans',
              endColor: kRedEnd,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ChitSchemScreen(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _quickActionCard(
    double Function(double) w,
    double Function(double) h, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color endColor,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: w(10), vertical: h(11)),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(w(5.5)),
          border: Border.all(color: kDivider, width: 0.68),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.white, endColor],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: w(25),
                  height: w(25),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFFDFDFDF),
                      width: 0.2,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Icon(icon, size: w(18), color: kBlue),
                ),
                Icon(Icons.chevron_right, size: w(18), color: kBlack),
              ],
            ),
            SizedBox(height: h(10)),
            Text(
              title,
              style: TextStyle(
                color: kBlack,
                fontSize: w(11),
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: h(2)),
            Text(
              subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: kBlack.withOpacity(0.6),
                fontSize: w(10),
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- Payment Due card ----------------
  Widget _buildPaymentDueCard(
    double Function(double) w,
    double Function(double) h,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: w(16)),
      child: Container(
        padding: EdgeInsets.all(w(14)),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(w(14)),
          border: Border.all(color: const Color(0xFFE5E7EB), width: 0.8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Rupee circle icon
                Container(
                  width: w(44),
                  height: w(44),
                  decoration: const BoxDecoration(
                    color: Color(0xFFDCEBFC),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Container(
                    width: w(30),
                    height: w(30),
                    decoration: const BoxDecoration(
                      color: kBlue,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '₹',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: w(16),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: w(12)),
                // Payment Due title and pending payment count
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Payment Due',
                        style: TextStyle(
                          color: kBlue,
                          fontSize: w(18),
                          fontWeight: FontWeight.w600,
                          height: 1.1,
                        ),
                      ),
                      SizedBox(height: h(4)),
                      RichText(
                        text: TextSpan(
                          style: TextStyle(
                            color: kBlack,
                            fontSize: w(13),
                            fontWeight: FontWeight.w400,
                          ),
                          children: [
                            const TextSpan(text: 'You have '),
                            TextSpan(
                              text: '1',
                              style: TextStyle(
                                color: kRed,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const TextSpan(text: ' pending payment'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

              ],
            ),
            SizedBox(height: h(14)),
            // Inner card
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: w(16), vertical: h(14)),
              decoration: BoxDecoration(
                color: kCardBg,
                borderRadius: BorderRadius.circular(w(12)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Due Date',
                        style: TextStyle(
                          color: const Color(0xFF6B7280),
                          fontSize: w(13),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: h(6)),
                      Text(
                        '25 May 2025',
                        style: TextStyle(
                          color: kRed,
                          fontSize: w(15),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: w(28)),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Amount',
                        style: TextStyle(
                          color: const Color(0xFF6B7280),
                          fontSize: w(13),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: h(6)),
                      Text(
                        '5,000',
                        style: TextStyle(
                          color: kBlack,
                          fontSize: w(16),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const EnterPaymentAmountScreen(
                            chits: [
                              ChitItem(
                                chitId: '12345',
                                name: 'Akhil',
                                groupDetail: '10-L',
                                role: 'Customer',
                                chitValue: '10,00,000',
                                dateRange: '25 May 2025',
                                runningBalance: '5,00,000',
                                acNo: '10108011866',
                                upiId: '10108011866@ubicaps',
                                status: 'Running',
                                chitAmount: 100000,
                                dueAmount: 5000,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kRed,
                      elevation: 0,
                      padding: EdgeInsets.symmetric(
                        horizontal: w(18),
                        vertical: h(10),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(w(20)),
                      ),
                    ),
                    child: Text(
                      'Pay Now',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: w(13),
                        fontWeight: FontWeight.w700,
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

  // ---------------- Payment Assistance card ----------------
  Widget _buildPaymentAssistanceCard(
    double Function(double) w,
    double Function(double) h,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: w(16)),
      child: Container(
        height: h(80),
        padding: EdgeInsets.symmetric(horizontal: w(14), vertical: h(10)),
        decoration: BoxDecoration(
          color: const Color(0xFFFAFAFA),
          borderRadius: BorderRadius.circular(w(8)),
          border: Border.all(color: const Color(0xFFEEEAEA), width: 0.8),
          boxShadow: const [
            BoxShadow(
              color: Color(0x14000000), // #000000 @ 8%
              offset: Offset(0, 8),
              blurRadius: 16,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Payment Assistance',
                    style: TextStyle(
                      color: kBlack,
                      fontSize: w(16),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: h(3)),
                  Text(
                    'Need help paying your due?\nContact your agent.',
                    style: TextStyle(
                      color: const Color(0xFF6B7280),
                      fontSize: w(12),
                      height: 1.25,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: w(10)),
            ElevatedButton(
              onPressed: () => _showNeedHelpBottomSheet(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: kBlue,
                elevation: 0,
                padding: EdgeInsets.symmetric(
                  horizontal: w(20),
                  vertical: h(9),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(w(20)),
                ),
              ),
              child: Text(
                'Call Now',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: w(14),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- Need Help Bottom Sheet (Figma Design) ----------------
  void _showNeedHelpBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const _NeedHelpBottomSheetContent(),
    );
  }



  // ---------------- Let's Plan Your Growth ----------------
  Widget _buildPlanYourGrowth(
    double Function(double) w,
    double Function(double) h,
  ) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: kBlue,

      ),
      padding: EdgeInsets.fromLTRB(w(16), h(24), w(16), h(28)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Let's Plan Your Growth",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: w(18),
                  fontWeight: FontWeight.w700,
                ),
              ),
              Icon(Icons.smart_toy_outlined, color: Colors.white, size: w(28)),
            ],
          ),
          SizedBox(height: h(14)),
          Wrap(
            spacing: w(18),
            runSpacing: h(8),
            children: [
              _planRadio(w, h, 'Smart Savings Scheme'),
              _planRadio(w, h, 'Quick Cash'),
              _planRadio(w, h, 'Flexi Cash'),
            ],
          ),
          SizedBox(height: h(16)),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(w(16)),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(w(16)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Investment Amount ₹',
                  style: TextStyle(
                    color: kBlue,
                    fontSize: w(13),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: h(6)),
                _textField(w, h, _investmentCtrl, 'ex: 1,00,000'),
                SizedBox(height: h(4)),
                Text(
                  'Enter values in multiples of Lakhs (min-1 Lakh to max-1 Crore)',
                  style: TextStyle(
                    color: kBlack.withOpacity(0.6),
                    fontSize: w(10),
                  ),
                ),
                SizedBox(height: h(10)),
                Center(
                  child: Text(
                    'or',
                    style: TextStyle(
                      color: kBlack.withOpacity(0.6),
                      fontSize: w(12),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(height: h(10)),
                Text(
                  'EMI Amount ₹',
                  style: TextStyle(
                    color: kBlue,
                    fontSize: w(13),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: h(6)),
                _textField(w, h, _emiCtrl, 'ex: 1,00,000'),
                SizedBox(height: h(4)),
                Text(
                  'Enter values in multiples of 5000 (min-5000 to max-5Lakhs)',
                  style: TextStyle(
                    color: kBlack.withOpacity(0.6),
                    fontSize: w(10),
                  ),
                ),
                SizedBox(height: h(16)),
                Row(
                  children: [
                    Expanded(
                      child: _dropdownField(
                        w,
                        h,
                        'No Of EMI\'s',
                        _noOfEmis,
                        (v) => setState(() => _noOfEmis = v),
                      ),
                    ),
                    SizedBox(width: w(12)),
                    Expanded(
                      child: _dropdownField(
                        w,
                        h,
                        'No Of Chit Members',
                        _noOfMembers,
                        (v) => setState(() => _noOfMembers = v),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: h(16)),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        'Note:\nEnter Values In Multiples Of\nLakhs In Investment',
                        style: TextStyle(
                          color: kBlack.withOpacity(0.6),
                          fontSize: w(10),
                          height: 1.4,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _isLoadingPlan ? null : () async {
                        final invText = _investmentCtrl.text.trim();
                        final emiText = _emiCtrl.text.trim();

                        if (invText.isEmpty && emiText.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please enter Investment Amount or EMI Amount', style: TextStyle(color: Colors.white)),
                              backgroundColor: Colors.black,
                              duration: Duration(seconds: 2),
                              behavior: SnackBarBehavior.fixed,
                            ),
                          );
                          return;
                        }
                        
                        setState(() { _isLoadingPlan = true; });

                        try {
                          final loc = await DeviceLocationService.getLocation();
                          final deviceId = await DeviceLocationService.getDeviceId();
                          final response = await http.post(
                            Uri.parse('https://chitsoft.in/wapp/api/chit_api/'),
                            body: {
                              'cid': '35318938',
                              'type': '6003',
                              'lt': loc['lat'] ?? '123',
                              'ln': loc['lng'] ?? '123',
                              'device_id': deviceId.isNotEmpty ? deviceId : '123',
                            },
                          );

                          if (response.statusCode == 200) {
                            final data = json.decode(response.body);
                            if (data['chit'] != null) {
                              List<dynamic> chits = data['chit'];
                              
                              final amountToPass = invText.isNotEmpty ? invText : emiText;
                              int targetAmount = int.tryParse(amountToPass.replaceAll(',', '').replaceAll(' ', '')) ?? 0;
                              int targetNom = _noOfEmis;
                              bool isEmi = emiText.isNotEmpty;
                              
                              dynamic matchedChit;
                              bool isExactMatch = false;

                              for (var chit in chits) {
                                int chitValue = int.tryParse(chit['ch_value'].toString()) ?? 0;
                                int emiAmount = int.tryParse(chit['amount'].toString()) ?? 0;
                                int checkValue = isEmi ? emiAmount : chitValue;
                                int nom = int.tryParse(chit['nom'].toString()) ?? 0;

                                if (checkValue == targetAmount && nom == targetNom) {
                                  matchedChit = chit;
                                  isExactMatch = true;
                                  break;
                                }
                              }

                              if (!isExactMatch && chits.isNotEmpty) {
                                chits.sort((a, b) {
                                  int valA = int.tryParse(a[isEmi ? 'amount' : 'ch_value'].toString()) ?? 0;
                                  int valB = int.tryParse(b[isEmi ? 'amount' : 'ch_value'].toString()) ?? 0;
                                  if (valA != valB) return valA.compareTo(valB);
                                  
                                  int nomA = int.tryParse(a['nom'].toString()) ?? 0;
                                  int nomB = int.tryParse(b['nom'].toString()) ?? 0;
                                  return nomA.compareTo(nomB);
                                });

                                for (var chit in chits) {
                                  int checkValue = int.tryParse(chit[isEmi ? 'amount' : 'ch_value'].toString()) ?? 0;
                                  int nom = int.tryParse(chit['nom'].toString()) ?? 0;
                                  if (checkValue >= targetAmount && nom >= targetNom) {
                                    matchedChit = chit;
                                    break;
                                  }
                                }

                                if (matchedChit == null) {
                                  for (var chit in chits) {
                                    int checkValue = int.tryParse(chit[isEmi ? 'amount' : 'ch_value'].toString()) ?? 0;
                                    if (checkValue >= targetAmount) {
                                      matchedChit = chit;
                                      break;
                                    }
                                  }
                                }

                                matchedChit ??= chits.last;
                                
                                if (mounted) {
                                  int shownValue = int.tryParse(matchedChit[isEmi ? 'amount' : 'ch_value'].toString()) ?? 0;
                                  int shownNom = int.tryParse(matchedChit['nom'].toString()) ?? 0;
                                  
                                  String msg = '';
                                  if (shownValue != targetAmount && shownNom != targetNom) {
                                    msg = 'We don\'t have a ₹$targetAmount plan for $targetNom months. Showing nearest plan: ₹$shownValue for $shownNom months.';
                                  } else if (shownValue != targetAmount) {
                                    msg = 'We don\'t have a ₹$targetAmount plan. Showing nearest plan: ₹$shownValue.';
                                  } else if (shownNom != targetNom) {
                                    msg = 'We don\'t have this plan for $targetNom months. Showing nearest plan for $shownNom months.';
                                  }

                                  if (msg.isNotEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(msg, style: const TextStyle(color: Colors.white)),
                                        backgroundColor: Colors.black,
                                        behavior: SnackBarBehavior.fixed,
                                      ),
                                    );
                                  }
                                }
                              }

                              if (mounted && matchedChit != null) {
                                int planId = matchedChit['id'];
                                String displayTopAmount = matchedChit[isEmi ? 'amount' : 'ch_value'].toString();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CalculatorSchemeScreen(
                                      planId: planId,
                                      displayTopAmount: displayTopAmount,
                                    ),
                                  ),
                                );
                              }
                            }
                          }
                        } catch (e) {
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Error fetching plans', style: TextStyle(color: Colors.white)),
                                backgroundColor: Colors.black,
                                behavior: SnackBarBehavior.fixed,
                              ),
                            );
                          }
                        } finally {
                          if (mounted) {
                            setState(() { _isLoadingPlan = false; });
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kBlue,
                        elevation: 0,
                        padding: EdgeInsets.symmetric(
                          horizontal: w(28),
                          vertical: h(13),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(w(24)),
                        ),
                      ),
                      child: _isLoadingPlan
                          ? SizedBox(
                              width: w(16),
                              height: w(16),
                              child: const CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                            )
                          : Text(
                              'Submit',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: w(14),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _planRadio(
    double Function(double) w,
    double Function(double) h,
    String label,
  ) {
    final bool selected = _selectedPlan == label;
    return GestureDetector(
      onTap: () => setState(() => _selectedPlan = label),
      behavior: HitTestBehavior.opaque,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: w(14),
            height: w(14),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: selected ? Colors.transparent : const Color(0x66E2E2E2),
              border: selected
                  ? Border.all(color: Colors.white, width: w(2.0))
                  : null,
            ),
          ),
          SizedBox(width: w(8)),
          Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: w(13),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _textField(
    double Function(double) w,
    double Function(double) h,
    TextEditingController controller,
    String hint,
  ) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      style: TextStyle(fontSize: w(14), color: kBlack),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: kBlack.withOpacity(0.35), fontSize: w(14)),
        contentPadding: EdgeInsets.symmetric(
          horizontal: w(14),
          vertical: h(12),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(w(10)),
          borderSide: const BorderSide(color: kDivider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(w(10)),
          borderSide: const BorderSide(color: kDivider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(w(10)),
          borderSide: const BorderSide(color: kBlue),
        ),
      ),
    );
  }

  Widget _dropdownField(
    double Function(double) w,
    double Function(double) h,
    String label,
    int value,
    ValueChanged<int> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: kBlue,
            fontSize: w(12),
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: h(6)),
        Container(
          padding: EdgeInsets.symmetric(horizontal: w(12)),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(w(10)),
            border: Border.all(color: kDivider),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              dropdownColor: Colors.white,
              value: value,
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down, color: kBlack),
              style: TextStyle(color: kBlack, fontSize: w(14)),
              items: [10, 20, 30, 40]
                  .map((e) => DropdownMenuItem(value: e, child: Text('$e')))
                  .toList(),
              onChanged: (v) {
                if (v != null) onChanged(v);
              },
            ),
          ),
        ),
      ],
    );
  }

  // ---------------- Explore section ----------------
  Widget _buildExploreSection(
    double Function(double) w,
    double Function(double) h,
  ) {
    final plans = [
      {
        'value': '10,00,000',
        'sub': '16,000',
        'slots': '14 slots left',
        'popular': true,
      },
      {
        'value': '50,000',
        'sub': '700',
        'slots': '15 slots left',
        'popular': false,
      },
      {
        'value': '5,00,000',
        'sub': '8,500',
        'slots': '9 slots left',
        'popular': false,
      },
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: w(16)),
          child: Text(
            'Explore',
            style: TextStyle(
              color: kBlack,
              fontSize: w(18),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(height: h(12)),
        SizedBox(
          height: h(235),
          child: ListView.separated(
            clipBehavior: Clip.none,
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.fromLTRB(w(16), h(6), w(16), h(30)),
            itemCount: plans.length,
            separatorBuilder: (_, __) => SizedBox(width: w(14)),
            itemBuilder: (context, index) {
              final plan = plans[index];
              final bool isPopular = plan['popular'] as bool;
              return Container(
                width: w(220),
                padding: EdgeInsets.fromLTRB(w(15), h(14), w(15), h(14)),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(w(16)),
                  border: Border.all(color: const Color(0xFFE4E4E4), width: 1),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x1A000000), // #000000 @ 10%
                      offset: Offset(0, 6),
                      blurRadius: 13,
                      spreadRadius: 0,
                    ),
                    BoxShadow(
                      color: Color(0x17000000), // #000000 @ 9%
                      offset: Offset(0, 24),
                      blurRadius: 24,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          plan['slots'] as String,
                          style: TextStyle(
                            color: const Color(0xFF6B7280),
                            fontSize: w(12),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        if (isPopular)
                          CustomPaint(
                            painter: _DottedBorderPainter(
                              color: const Color(0xFFE53935),
                              strokeWidth: 1.0,
                              dashWidth: 3.0,
                              dashSpace: 2.0,
                              radius: w(4),
                            ),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: w(8),
                                vertical: h(3),
                              ),
                              child: Text(
                                'Popular',
                                style: TextStyle(
                                  color: const Color(0xFFE53935),
                                  fontSize: w(11),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          )
                        else
                          const SizedBox(height: 20),
                      ],
                    ),
                    SizedBox(height: h(8)),
                    Text(
                      '₹ ${plan['value']}',
                      style: TextStyle(
                        color: kBlue,
                        fontSize: w(21),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: h(4)),
                    Text(
                      'Subscription - ₹ ${plan['sub']}',
                      style: TextStyle(
                        color: kBlue,
                        fontSize: w(12),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: h(8)),
                    Text(
                      'Instalment - 60 months',
                      style: TextStyle(
                        color: const Color(0xFF6B7280),
                        fontSize: w(10.5),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: h(2)),
                    Text(
                      'Start date - 01-Oct - 2026',
                      style: TextStyle(
                        color: const Color(0xFF6B7280),
                        fontSize: w(10.5),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const Spacer(),
                    SizedBox(
                      width: double.infinity,
                      height: h(38),
                      child: ElevatedButton(
                        onPressed: () {
                          showChitEnquiryDialog(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kBlue,
                          elevation: 0,
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(w(24)),
                          ),
                        ),
                        child: Text(
                          'Enquire now',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: w(13),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ---------------- Quick Links ----------------
  Widget _buildQuickLinks(
    double Function(double) w,
    double Function(double) h,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: w(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Links',
            style: TextStyle(
              color: kBlack,
              fontSize: w(18),
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: h(14)),
          _quickLinkTile(
            w,
            h,
            iconAsset: 'assets/setting/about_us.png',
            fallbackIcon: Icons.info_outline,
            title: 'About Siva Sakthi',
            subtitle: 'About Siva Sakthi',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AboutUsScreen()),
              );
            },
          ),
          SizedBox(height: h(12)),
          _quickLinkTile(
            w,
            h,
            iconAsset: 'assets/setting/faq.png',
            fallbackIcon: Icons.help_outline,
            title: 'Faq',
            subtitle: 'Frequently asked questions',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FaqScreen()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _quickLinkTile(
    double Function(double) w,
    double Function(double) h, {
    required String iconAsset,
    required IconData fallbackIcon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: h(59),
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: w(14)),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(w(8)),
          border: Border.all(color: const Color(0xFFE5E7EB), width: 0.8),
          boxShadow: const [
            BoxShadow(
              color: Color(0x14000000), // #000000 @ 8%
              offset: Offset(0, 8),
              blurRadius: 16,
              spreadRadius: 0,
            ),
            BoxShadow(
              color: Color(0x0A000000), // #000000 @ 4%
              offset: Offset(0, 0),
              blurRadius: 4,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              iconAsset,
              width: w(22),
              height: w(22),
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) =>
                  Icon(fallbackIcon, color: kBlue, size: w(22)),
            ),
            SizedBox(width: w(12)),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: kBlack,
                      fontSize: w(14),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: h(2)),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: const Color(0xFF9E9E9E),
                      fontSize: w(11.5),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: kBlack, size: w(20)),
          ],
        ),
      ),
    );
  }
}

class _NeedHelpBottomSheetContent extends StatefulWidget {
  const _NeedHelpBottomSheetContent();

  @override
  State<_NeedHelpBottomSheetContent> createState() => _NeedHelpBottomSheetContentState();
}

class _NeedHelpBottomSheetContentState extends State<_NeedHelpBottomSheetContent> {
  bool _isLoading = true;
  String _generalPhone = '';
  String _customerPhone = '';

  @override
  void initState() {
    super.initState();
    _fetchContactInfo();
  }

  Future<void> _fetchContactInfo() async {
    try {
      final loc = await DeviceLocationService.getLocation();
      final deviceId = await DeviceLocationService.getDeviceId();
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      final response = await http.post(
        Uri.parse('https://chitsoft.in/wapp/api/chit_api/'),
        body: {
          'cid': '35318938',
          'type': '6012',
          'lt': loc['lat'] ?? '123',
          'ln': loc['lng'] ?? '123',
          'device_id': deviceId.isNotEmpty ? deviceId : '123',
          'token': token,
        },
      );

      if (response.statusCode == 200) {
        debugPrint('Home Need Help API Response: ${response.body}');
        final data = json.decode(response.body);
        if (data['error'] == false && data['contact'] != null) {
          if (mounted) {
            setState(() {
              _generalPhone = data['contact']['general_phone'] ?? '';
              _customerPhone = data['contact']['customer_phone'] ?? '';
              _isLoading = false;
            });
          }
          return;
        }
      }
    } catch (e) {
      debugPrint('Error fetching contact info: $e');
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle bar
          Center(
            child: Container(
              width: 38,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFE2E8F0),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Header title and close icon
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Need help?',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0F172A),
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: Color(0xFFF1F5F9),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close,
                    size: 20,
                    color: Color(0xFF64748B),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            "We're here to assist with your chit plans & queries.",
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 20),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Center(child: CircularProgressIndicator()),
            )
          else ...[
            // Card 1: General Enquiry
            _buildHelpCard(
              icon: Icons.call_outlined,
              title: 'General Enquiry',
              subtitle: 'Account, group & plan queries',
              badgeText: '9 AM - 6 PM',
              badgeBgColor: const Color(0xFFDCFCE7),
              badgeTextColor: const Color(0xFF15803D),
              phoneText: '+91 $_generalPhone',
              onCallTap: () async {
                if (_generalPhone.isNotEmpty) {
                  final Uri url = Uri.parse('tel:$_generalPhone');
                  try {
                    await launchUrl(url);
                  } catch (e) {
                    debugPrint('Could not launch $_generalPhone');
                  }
                }
              },
            ),
            const SizedBox(height: 14),
            // Card 2: Collection Support
            _buildHelpCard(
              icon: Icons.headset_mic_outlined,
              title: 'Collection Support',
              subtitle: 'Payment, dues & settlement',
              badgeText: 'Priority',
              badgeBgColor: const Color(0xFFF1F5F9),
              badgeTextColor: const Color(0xFF64748B),
              phoneText: '+91 $_customerPhone',
              onCallTap: () async {
                if (_customerPhone.isNotEmpty) {
                  final Uri url = Uri.parse('tel:$_customerPhone');
                  try {
                    await launchUrl(url);
                  } catch (e) {
                    debugPrint('Could not launch $_customerPhone');
                  }
                }
              },
            ),
          ],
          const SizedBox(height: 10),
        ],
      ),
    );
  }


  Widget _buildHelpCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required String badgeText,
    required Color badgeBgColor,
    required Color badgeTextColor,
    required String phoneText,
    required VoidCallback onCallTap,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
                ),
                alignment: Alignment.center,
                child: Icon(icon, color: const Color(0xFF334155), size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: badgeBgColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  badgeText,
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600,
                    color: badgeTextColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                phoneText,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0F172A),
                ),
              ),
              ElevatedButton(
                onPressed: onCallTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor:Color(0xff266FAF),
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Call',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward_rounded,
                      color: Colors.white,
                      size: 15,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}


// ---------------- Dotted Border Painter ----------------
class _DottedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashWidth;
  final double dashSpace;
  final double radius;

  _DottedBorderPainter({
    required this.color,
    this.strokeWidth = 1.0,
    this.dashWidth = 3.0,
    this.dashSpace = 2.0,
    this.radius = 4.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        strokeWidth / 2,
        strokeWidth / 2,
        size.width - strokeWidth,
        size.height - strokeWidth,
      ),
      Radius.circular(radius),
    );

    final path = Path()..addRRect(rrect);
    final metrics = path.computeMetrics();

    for (final metric in metrics) {
      double distance = 0.0;
      while (distance < metric.length) {
        final double length = (distance + dashWidth < metric.length)
            ? dashWidth
            : metric.length - distance;
        final extractPath = metric.extractPath(distance, distance + length);
        canvas.drawPath(extractPath, paint);
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DottedBorderPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.dashWidth != dashWidth ||
        oldDelegate.dashSpace != dashSpace ||
        oldDelegate.radius != radius;
  }
}
