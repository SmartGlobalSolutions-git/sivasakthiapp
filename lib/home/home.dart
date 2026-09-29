import 'dart:async';
import 'package:flutter/material.dart';
import 'package:siva_sakthi/home/available_chit_screen.dart';
import 'package:siva_sakthi/home/chit_schem_screen.dart';
import 'package:siva_sakthi/home/menu.dart';
import 'package:siva_sakthi/home/notification.dart';
import 'package:siva_sakthi/setting/about_us.dart';
import 'package:siva_sakthi/setting/faq_screen.dart';
import 'package:siva_sakthi/setting/need_help.dart';
import 'package:siva_sakthi/my_chit/my_chits_screen.dart';

// ==========================================================
// SIVA SAKTHI CHIT FUNDS - HOME SCREEN
// Built with MediaQuery-based responsive scaling (base 360x812).
// All colors, fonts and sizes match the Figma design.
// ==========================================================

class SivaSakthiHomeScreen extends StatefulWidget {
  const SivaSakthiHomeScreen({super.key});

  @override
  State<SivaSakthiHomeScreen> createState() => _SivaSakthiHomeScreenState();
}

class _SivaSakthiHomeScreenState extends State<SivaSakthiHomeScreen> {
  // ---- Figma colors ----
  static const Color kBlue = Color(0xFF3C93F4);
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

  @override
  void initState() {
    super.initState();
    _startBannerAutoScroll();
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
        child: const ProfileMenuScreen(),
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
            _buildBottomNav(w, h),
          ],
        ),
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
            'Hello Akhil',
            style: TextStyle(
              color: kBlack,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              height: 1.0,
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NeedHelpScreen(),
                ),
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
      double Function(double) w, double Function(double) h, String imagePath) {
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
      double Function(double) w, double Function(double) h) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: w(16)),
      child: Row(
        children: [
          Expanded(
            child: _quickActionCard(
              w, h,
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
              w, h,
              icon: Icons.calendar_month_outlined,
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
              w, h,
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
                  width: w(20),
                  height: w(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFFDFDFDF), width: 0.2),
                  ),
                  alignment: Alignment.center,
                  child: Icon(icon, size: w(11), color: kBlack),
                ),
                Icon(Icons.chevron_right, size: w(14), color: kBlack),
              ],
            ),
            SizedBox(height: h(10)),
            Text(
              title,
              style: TextStyle(
                color: kBlack,
                fontSize: w(11),
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: h(2)),
            Text(
              subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: kBlack.withOpacity(0.6),
                fontSize: w(7),
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
      double Function(double) w, double Function(double) h) {
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
                GestureDetector(
                  onTap: () {},
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'View Details',
                        style: TextStyle(
                          color: kBlue,
                          fontSize: w(13),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: w(2)),
                      Icon(Icons.chevron_right, size: w(18), color: kBlue),
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
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kRed,
                      elevation: 0,
                      padding: EdgeInsets.symmetric(
                          horizontal: w(18), vertical: h(10)),
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
      double Function(double) w, double Function(double) h) {
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
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: kBlue,
                elevation: 0,
                padding: EdgeInsets.symmetric(horizontal: w(20), vertical: h(9)),
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

  // ---------------- Let's Plan Your Growth ----------------
  Widget _buildPlanYourGrowth(
      double Function(double) w, double Function(double) h) {
    return Container(
      width: double.infinity,
      color: kBlue,
      padding: EdgeInsets.fromLTRB(w(16), h(24), w(16), h(28)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Let's Plan Your Growth",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: w(18),
                      fontWeight: FontWeight.w700)),
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
                Text('Investment Amount ₹',
                    style: TextStyle(
                        color: kBlue, fontSize: w(13), fontWeight: FontWeight.w500)),
                SizedBox(height: h(6)),
                _textField(w, h, _investmentCtrl, 'ex: 1,00,000'),
                SizedBox(height: h(4)),
                Text('Enter values in multiples of Lakhs (min-1 Lakh to max-1 Crore)',
                    style: TextStyle(color: kBlack.withOpacity(0.6), fontSize: w(10))),
                SizedBox(height: h(10)),
                Center(
                  child: Text('or',
                      style: TextStyle(
                          color: kBlack.withOpacity(0.6),
                          fontSize: w(12),
                          fontWeight: FontWeight.w500)),
                ),
                SizedBox(height: h(10)),
                Text('EMI Amount ₹',
                    style: TextStyle(
                        color: kBlue, fontSize: w(13), fontWeight: FontWeight.w500)),
                SizedBox(height: h(6)),
                _textField(w, h, _emiCtrl, 'ex: 1,00,000'),
                SizedBox(height: h(4)),
                Text('Enter values in multiples of 5000 (min-5000 to max-5Lakhs)',
                    style: TextStyle(color: kBlack.withOpacity(0.6), fontSize: w(10))),
                SizedBox(height: h(16)),
                Row(
                  children: [
                    Expanded(
                      child: _dropdownField(w, h, 'No Of EMI\'s', _noOfEmis,
                              (v) => setState(() => _noOfEmis = v)),
                    ),
                    SizedBox(width: w(12)),
                    Expanded(
                      child: _dropdownField(w, h, 'No Of Chit Members', _noOfMembers,
                              (v) => setState(() => _noOfMembers = v)),
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
                            height: 1.4),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kBlue,
                        elevation: 0,
                        padding: EdgeInsets.symmetric(
                            horizontal: w(28), vertical: h(13)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(w(24)),
                        ),
                      ),
                      child: Text('Submit',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: w(14),
                              fontWeight: FontWeight.w700)),
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
      double Function(double) w, double Function(double) h, String label) {
    final bool selected = _selectedPlan == label;
    return GestureDetector(
      onTap: () => setState(() => _selectedPlan = label),
      behavior: HitTestBehavior.opaque,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: w(16),
            height: w(16),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 1.5),
              color: selected ? Colors.white : Colors.transparent,
            ),
            alignment: Alignment.center,
            child: selected
                ? Container(
              width: w(8),
              height: w(8),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: kBlue,
              ),
            )
                : null,
          ),
          SizedBox(width: w(8)),
          Text(label,
              style: TextStyle(
                  color: Colors.white, fontSize: w(13), fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _textField(double Function(double) w, double Function(double) h,
      TextEditingController controller, String hint) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      style: TextStyle(fontSize: w(14), color: kBlack),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: kBlack.withOpacity(0.35), fontSize: w(14)),
        contentPadding: EdgeInsets.symmetric(horizontal: w(14), vertical: h(12)),
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
        Text(label,
            style: TextStyle(
                color: kBlue, fontSize: w(12), fontWeight: FontWeight.w500)),
        SizedBox(height: h(6)),
        Container(
          padding: EdgeInsets.symmetric(horizontal: w(12)),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(w(10)),
            border: Border.all(color: kDivider),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<int>(
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
      double Function(double) w, double Function(double) h) {
    final plans = [
      {'value': '10,00,000', 'sub': '16,000', 'slots': '14 slots left', 'popular': true},
      {'value': '50,000', 'sub': '700', 'slots': '15 slots left', 'popular': false},
      {'value': '5,00,000', 'sub': '8,500', 'slots': '9 slots left', 'popular': false},
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: w(16)),
          child: Text('Explore',
              style: TextStyle(
                  color: kBlack, fontSize: w(18), fontWeight: FontWeight.w600)),
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
                                  horizontal: w(8), vertical: h(3)),
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
                        onPressed: () {},
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
      double Function(double) w, double Function(double) h) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: w(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Quick Links',
              style: TextStyle(
                  color: kBlack, fontSize: w(18), fontWeight: FontWeight.w600)),
          SizedBox(height: h(14)),
          _quickLinkTile(
            w,
            h,
            iconAsset: 'assets/setting/about.png',
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

  // ---------------- Bottom nav ----------------
  Widget _buildBottomNav(
      double Function(double) w, double Function(double) h) {
    return Container(
      height: h(58),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: kDivider, width: 0.6)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navItem(w, h, Icons.home_outlined, 'Home', true),
          _navItem(w, h, Icons.calendar_month_outlined, 'Schemes', false),
          _navItem(w, h, Icons.payments_outlined, 'Payments', false),
          _navItem(w, h, Icons.credit_card_outlined, 'Profile', false),
        ],
      ),
    );
  }

  Widget _navItem(double Function(double) w, double Function(double) h,
      IconData icon, String label, bool active) {
    final color = active ? kBlue : kBlack.withOpacity(0.45);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: w(22)),
        SizedBox(height: h(2)),
        Text(label, style: TextStyle(color: color, fontSize: w(10))),
      ],
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