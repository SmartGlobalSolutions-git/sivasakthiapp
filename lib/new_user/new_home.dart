import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:siva_sakthi/calculator/chit_enquiry_dialog.dart';
import 'package:siva_sakthi/calculator/subscription_plan_screen.dart';
import 'package:siva_sakthi/new_user/new_calculator.dart';
import 'package:siva_sakthi/new_user/new_menu.dart';
import 'package:siva_sakthi/setting/about_us.dart';
import 'package:siva_sakthi/setting/faq_screen.dart';
import 'package:siva_sakthi/home/notification.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Scheme Selection Radio State
  String _selectedScheme = 'Smart Savings Scheme';

  // Calculator Form Controllers
  final TextEditingController _investmentController = TextEditingController();
  final TextEditingController _emiController = TextEditingController();

  String? _selectedEmis;
  String? _selectedMembers;

  final List<String> _emiOptions = ["10", "20", "25", "30", "40", "50"];
  final List<String> _memberOptions = ["10", "20", "25", "30", "40", "50"];

  int _selectedBottomNavIndex = 0;

  @override
  void dispose() {
    _investmentController.dispose();
    _emiController.dispose();
    super.dispose();
  }

  void _onSchemeChanged(String scheme) {
    setState(() {
      _selectedScheme = scheme;
    });
  }

  void _handleCalculatorSubmit() {
    final investmentText = _investmentController.text.trim();
    final emiText = _emiController.text.trim();

    final amountToPass = investmentText.isNotEmpty
        ? investmentText
        : (emiText.isNotEmpty ? emiText : '1,00,000');

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SubscriptionPlanScreen(
          investmentAmount: amountToPass,
          durationMonths: _selectedEmis ?? '20',
        ),
      ),
    );
  }



  void _showNeedHelpBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
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
                  Text(
                    'Need help?',
                    style: GoogleFonts.inter(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF0F172A),
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
              Text(
                "We're here to assist with your chit plans & queries.",
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF64748B),
                ),
              ),
              const SizedBox(height: 20),
              // Card 1: General Enquiry
              _buildHelpCard(
                icon: Icons.call_outlined,
                title: 'General Enquiry',
                subtitle: 'Account, group & plan queries',
                badgeText: '9 AM - 6 PM',
                badgeBgColor: const Color(0xFFDCFCE7),
                badgeTextColor: const Color(0xFF15803D),
                phoneText: '+91 90 4783 4783',
                onCallTap: () {},
              ),
            ],
          ),
        );
      },
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
    const kBlue = Color(0xFF3C93F4);
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
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: GoogleFonts.inter(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF64748B),
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
                  style: GoogleFonts.inter(
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
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF0F172A),
                ),
              ),
              ElevatedButton(
                onPressed: onCallTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: kBlue,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Call',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
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

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    // Responsive scaling based on reference 360 width
    final scaleW = (screenWidth / 360).clamp(0.85, 1.25);
    final scaleH = (mediaQuery.size.height / 800).clamp(0.85, 1.25);

    final double topPadding = mediaQuery.padding.top;
    final double bottomPadding = mediaQuery.padding.bottom;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      drawer: const NewUserMenuScreen(),
      // 100% Stiff Bottom Navigation Bar via Scaffold (never scrolls)
      bottomNavigationBar: _buildBottomNavigationBar(scaleW, bottomPadding),
      body: Column(
        children: [
          // 1. 100% Stiff Top App Bar (incorporates MediaQuery.padding.top, never scrolls)
          _buildAppBar(scaleW, topPadding),

          // Scrollable Middle Content ONLY
          Expanded(
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(), // Stiff scroll without bouncy overscroll
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // 2. Banner 1: Siva Sakthi Chit Funds (width: 360, height: 180, top: 78px)
                  _buildTopBanner(screenWidth, scaleW),

                  SizedBox(height: 9 * scaleW),

                  // 3. 6-Steps Registration Flow Image (Card 1: width: 328, height: 124, top: 267, left: 16)
                  _buildStepFlowCard(screenWidth, scaleW),

                  SizedBox(height: 13.17 * scaleW), // Figma exact gap (404.17 - 391)

                  // 4. Stats Image (Card 2: width: 328, height: 68.65, top: 404.17, left: 16)
                  _buildStatsBanner(screenWidth, scaleW),

                  SizedBox(height: 13.18 * scaleW), // Figma exact gap (486 - 472.82)

                  // 5. Unlock Financial Growth Card (Card 3: width: 328, height: 73, top: 486, left: 18)
                  _buildUnlockFinancialGrowthCard(screenWidth, scaleW, scaleH),

                  SizedBox(height: 15 * scaleW), // Figma gap to blue section

                  // 6. Blue Section: "Let's Plan Your Growth" (width: 845, height: 492, torn edges)
                  _buildBlueCalculatorSection(screenWidth, scaleW, scaleH),

                  SizedBox(height: 12 * scaleW),

                  // 7. What We Do Image (width: 361, height: 121, top: 1082px)
                  _buildWhatWeDoBanner(screenWidth, scaleW),

                  SizedBox(height: 18 * scaleW),

                  // 8. Quick Links Header & Cards (width: 328, height: 59, box-shadows)
                  _buildQuickLinksSection(screenWidth, scaleW, scaleH),

                  SizedBox(height: 24 * scaleH),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- 1. Custom App Bar ---
  // Stiff at the top, includes MediaQuery.padding.top for seamless notch/status bar support
  Widget _buildAppBar(double scaleW, double topPadding) {
    return Container(
      width: double.infinity,
      color: const Color(0xFFFDFEFE),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: topPadding),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: Stack(
              children: [
                // 1. Menu logo (width: 24, height: 24, top: 40px -> 16px, left: 12px)
                Positioned(
                  left: 12 * scaleW,
                  top: 16,
                  width: 24 * scaleW,
                  height: 24 * scaleW,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      _scaffoldKey.currentState?.openDrawer();
                    },
                    child: Image.asset(
                      'assets/images/menu.png',
                      width: 24 * scaleW,
                      height: 24 * scaleW,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) =>
                          Icon(Icons.menu, size: 24 * scaleW, color: const Color(0xFF1E2638)),
                    ),
                  ),
                ),

                // 2. Sivasakthi Logo (width: 37, height: 28.62264060974121, top: 37px -> 13px, left: 46px)
                Positioned(
                  left: 46 * scaleW,
                  top: 13,
                  width: 37 * scaleW,
                  height: 28.62264060974121 * scaleW,
                  child: Image.asset(
                    'assets/images/sivasakthi.png',
                    width: 37 * scaleW,
                    height: 28.62264060974121 * scaleW,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) =>
                        Image.asset('assets/images/logo.png', width: 37 * scaleW, height: 28.62264060974121 * scaleW),
                  ),
                ),

                // 3. SIVA SAKTHI & CHITS (Figma: top: 42px & 54.37px, left: 83px & 104.86px)
                Positioned(
                  left: 83 * scaleW,
                  top: 17.5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'SIVA SAKTHI',
                        style: GoogleFonts.inter(
                          fontSize: 9.89 * scaleW,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF3C93F4),
                          letterSpacing: 0,
                          height: 1.0,
                        ),
                      ),
                      const SizedBox(height: 0.5),
                      Text(
                        'CHITS',
                        style: GoogleFonts.inter(
                          fontSize: 5.96 * scaleW,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF3C93F4),
                          letterSpacing: 0.2,
                          height: 1.0,
                        ),
                      ),
                    ],
                  ),
                ),

                Positioned(
                  right: 20 * scaleW,
                  top: 16,
                  width: 24 * scaleW,
                  height: 24 * scaleW,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const NotificationScreen()),
                      );
                    },
                    child: Image.asset(
                      'assets/images/notification.png',
                      width: 24 * scaleW,
                      height: 24 * scaleW,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) =>
                          Icon(Icons.notifications_none, size: 24 * scaleW, color: const Color(0xFF1E2638)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 1.0,
            color: const Color(0xFFF1F5F9),
          ),
        ],
      ),
    );
  }

  // --- 2. Banner 1: Siva Sakthi Chit Funds ---
  // Specs: width: 360, height: 180, top: 78px, opacity: 1, angle: 0 deg
  Widget _buildTopBanner(double screenWidth, double scaleW) {
    final bannerWidth = screenWidth;
    final bannerHeight = 180 * scaleW;

    return GestureDetector(
      onTap: () => showChitEnquiryDialog(context),
      child: Container(
        width: bannerWidth,
        height: bannerHeight,
        color: const Color(0xFFF8FAFC),
        child: Image.asset(
          'assets/images/ss_family.png',
          width: bannerWidth,
          height: bannerHeight,
          fit: BoxFit.fill,
          errorBuilder: (context, error, stackTrace) => Image.asset(
            'assets/images/family.png',
            width: bannerWidth,
            height: bannerHeight,
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }

  // --- 3. 6-Steps Registration Flow Image ---
  // Specs: width: 328, height: 124, border-radius: 10px, top: 267px, left: 16px, opacity: 1, angle: 0 deg
  Widget _buildStepFlowCard(double screenWidth, double scaleW) {
    final cardWidth = 328 * scaleW;
    final cardHeight = 124 * scaleW;

    return Container(
      width: cardWidth,
      height: cardHeight,
      margin: EdgeInsets.symmetric(horizontal: 16 * scaleW),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.asset(
          'assets/images/details.jpeg',
          width: cardWidth,
          height: cardHeight,
          fit: BoxFit.fill,
          errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
        ),
      ),
    );
  }

  // --- 4. Stats Image ---
  // Specs: width: 328, height: 68.65116119384766, border-radius: 8.72px, top: 404.17px, left: 16px
  Widget _buildStatsBanner(double screenWidth, double scaleW) {
    final cardWidth = 328 * scaleW;
    final cardHeight = 68.65116119384766 * scaleW;

    return Container(
      width: cardWidth,
      height: cardHeight,
      margin: EdgeInsets.symmetric(horizontal: 16 * scaleW),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.72),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.72),
        child: Image.asset(
          'assets/images/details2.png',
          width: cardWidth,
          height: cardHeight,
          fit: BoxFit.cover,
          alignment: Alignment.center,
          errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
        ),
      ),
    );
  }

  // --- 5. Unlock Financial Growth Card ---
  // Specs: width: 328, height: 73, border: 0.8px solid #EEEAEA, border-radius: 8px, top: 486px, left: 18px
  Widget _buildUnlockFinancialGrowthCard(double screenWidth, double scaleW, double scaleH) {
    final cardWidth = 328 * scaleW;
    final cardHeight = 73 * scaleW;

    return Container(
      width: cardWidth,
      height: cardHeight,
      margin: EdgeInsets.only(left: 18 * scaleW, right: 14 * scaleW),
      padding: EdgeInsets.symmetric(horizontal: 14 * scaleW, vertical: 4 * scaleW),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFFEEEAEA),
          width: 0.8,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left: Title and Subtitle Column (matching screenshot line breaks)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title (2 lines: Unlock Financial Growth / with Chit Funds!)
                Text(
                  'Unlock Financial Growth\nwith Chit Funds!',
                  style: GoogleFonts.inter(
                    fontSize: 13 * scaleW,
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.normal,
                    height: 1.15,
                    letterSpacing: -0.1,
                    color: const Color(0xFF111827),
                  ),
                ),
                SizedBox(height: 2 * scaleW),
                // Subtitle (2 lines: Secure Your Future with Smart / Investments Today!)
                Text(
                  'Secure Your Future with Smart\nInvestments Today!',
                  style: GoogleFonts.inter(
                    fontSize: 9 * scaleW,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    height: 1.15,
                    letterSpacing: 0,
                    color: const Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(width: 8 * scaleW),

          // Right: "Contact Us" Pill Button (width: 101, height: 28, border-radius: 180px, bg: #3C93F4)
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => _showNeedHelpBottomSheet(context),
            child: Container(
              width: 101 * scaleW,
              height: 28 * scaleW,
              decoration: BoxDecoration(
                color: const Color(0xFF3C93F4),
                borderRadius: BorderRadius.circular(180),
              ),
              alignment: Alignment.center,
              child: Text(
                'Contact Us',
                style: GoogleFonts.inter(
                  fontSize: 11 * scaleW,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.normal,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- 6. Blue Section: "Let's Plan Your Growth" ---
  // Specs matching calculator_screen.dart:
  // Text sizes, Button size (130x40), Input fields (290x40), Dropdowns (138x40)
  Widget _buildBlueCalculatorSection(double screenWidth, double scaleW, double scaleH) {
    final sectionWidth = screenWidth;
    const primaryBlue = Color(0xFF3C93F4);

    return SizedBox(
      width: sectionWidth,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Background blue torn paper asset (assets/images/blue_round.png)
          Positioned.fill(
            child: Image.asset(
              'assets/images/blue_round.png',
              width: sectionWidth,
              fit: BoxFit.fill,
              errorBuilder: (context, error, stackTrace) =>
                  Container(color: primaryBlue),
            ),
          ),

          // Content inside Blue Section
          Padding(
            padding: EdgeInsets.only(
              left: 15 * scaleW.clamp(0.85, 1.2),
              right: 17 * scaleW.clamp(0.85, 1.2),
              top: 54 * scaleH.clamp(0.85, 1.2), // Figma: top: 631px (577 + 54 = 631)
              bottom: 36 * scaleH.clamp(0.85, 1.2),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title: "Let’s Plan Your Growth"
                // Specs: width: 218, height: 15, top: 631px, left: 20px (15 + 5)
                // Font: Inter, 20px, 600 Semi Bold, color: #FFFFFF, height: 1.0
                Padding(
                  padding: EdgeInsets.only(left: 5 * scaleW),
                  child: Text(
                    "Let’s Plan Your Growth",
                    style: GoogleFonts.inter(
                      fontSize: 20 * scaleW.clamp(0.85, 1.2),
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.normal,
                      height: 1.0,
                      letterSpacing: 0,
                      color: Colors.white,
                    ),
                  ),
                ),

                SizedBox(height: 16 * scaleH.clamp(0.85, 1.2)),

                // Radio Row 1: Smart Savings Scheme & Flexi Cash
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4 * scaleW),
                  child: Row(
                    children: [
                      _buildRadioButton('Smart Savings Scheme', scaleW),
                      const Spacer(),
                      _buildRadioButton('Flexi Cash', scaleW),
                      SizedBox(width: 8 * scaleW),
                    ],
                  ),
                ),
                SizedBox(height: 10 * scaleH.clamp(0.85, 1.2)),

                // Radio Row 2: Quick Cash
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4 * scaleW),
                  child: _buildRadioButton('Quick Cash', scaleW),
                ),
                SizedBox(height: 18 * scaleH.clamp(0.85, 1.2)),

                // White Box (Width: 328, minHeight: 318, Border Radius: 15px, Left: 15px, Top: 721px)
                Container(
                  width: 328 * scaleW.clamp(0.85, 1.2),
                  constraints: BoxConstraints(
                    minHeight: 318 * scaleH.clamp(0.85, 1.2),
                  ),
                  clipBehavior: Clip.antiAlias,
                  padding: EdgeInsets.symmetric(
                    horizontal: 19 * scaleW.clamp(0.85, 1.2),
                    vertical: 16 * scaleH.clamp(0.85, 1.2),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // Background Plant Watermark (width: 126, height: 206, border-radius: 83.97px)
                      Positioned(
                        right: -8,
                        bottom: 10,
                        child: IgnorePointer(
                          child: Opacity(
                            opacity: 0.50,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(83.97),
                              child: Image.asset(
                                'assets/images/plant.png',
                                width: 126 * scaleW.clamp(0.85, 1.2),
                                height: 206 * scaleH.clamp(0.85, 1.2),
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) =>
                                const SizedBox.shrink(),
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Form Elements inside the White Box
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // 1. Investment Amount ₹
                          Text(
                            'Investment Amount ₹',
                            style: GoogleFonts.inriaSans(
                              fontSize: 14 * scaleW.clamp(0.85, 1.2),
                              fontWeight: FontWeight.w400,
                              fontStyle: FontStyle.normal,
                              height: 1.0,
                              letterSpacing: 0,
                              color: primaryBlue,
                            ),
                          ),
                          SizedBox(height: 5 * scaleH.clamp(0.85, 1.2)),

                          // Input Field: width: 290, height: 40, border-radius: 8px, border-width: 1px
                          _buildTextField(
                            controller: _investmentController,
                            hintText: '1,00,000',
                            keyboardType: TextInputType.number,
                            scaleW: scaleW,
                            scaleH: scaleH,
                          ),
                          SizedBox(height: 4 * scaleH.clamp(0.85, 1.2)),

                          // Helper: Enter values in multiples of Lakhs (min-1 Lakh to max-1 Crore)
                          Text(
                            'Enter values in multiples of Lakhs (min-1 Lakh to max-1 Crore)',
                            style: GoogleFonts.inriaSans(
                              fontSize: 10 * scaleW.clamp(0.85, 1.2),
                              fontWeight: FontWeight.w400,
                              fontStyle: FontStyle.normal,
                              height: 1.0,
                              letterSpacing: 0,
                              color: const Color(0xFF000000),
                            ),
                          ),
                          SizedBox(height: 6 * scaleH.clamp(0.85, 1.2)),

                          // Centered "or"
                          Center(
                            child: Text(
                              'or',
                              style: GoogleFonts.inriaSans(
                                fontSize: 12 * scaleW.clamp(0.85, 1.2),
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.normal,
                                height: 1.0,
                                letterSpacing: 0,
                                color: const Color(0xFF333333),
                              ),
                            ),
                          ),
                          SizedBox(height: 4 * scaleH.clamp(0.85, 1.2)),

                          // 2. EMI Amount ₹
                          Text(
                            'EMI Amount ₹',
                            style: GoogleFonts.inriaSans(
                              fontSize: 14 * scaleW.clamp(0.85, 1.2),
                              fontWeight: FontWeight.w400,
                              fontStyle: FontStyle.normal,
                              height: 1.0,
                              letterSpacing: 0,
                              color: primaryBlue,
                            ),
                          ),
                          SizedBox(height: 5 * scaleH.clamp(0.85, 1.2)),

                          // Input Field: width: 290, height: 40, border-radius: 8px, border-width: 1px
                          _buildTextField(
                            controller: _emiController,
                            hintText: '1,00,000',
                            keyboardType: TextInputType.number,
                            scaleW: scaleW,
                            scaleH: scaleH,
                          ),
                          SizedBox(height: 4 * scaleH.clamp(0.85, 1.2)),

                          // Helper: Enter values in multiples of 5000 (min-5000 to max-5Lakhs)
                          Text(
                            'Enter values in multiples of 5000 (min-5000 to max-5Lakhs)',
                            style: GoogleFonts.inriaSans(
                              fontSize: 10 * scaleW.clamp(0.85, 1.2),
                              fontWeight: FontWeight.w400,
                              fontStyle: FontStyle.normal,
                              height: 1.0,
                              letterSpacing: 0,
                              color: const Color(0xFF000000),
                            ),
                          ),
                          SizedBox(height: 14 * scaleH.clamp(0.85, 1.2)),

                          // 3. Dropdowns Row: No Of EMI's & No Of Chit Members (each width: 138, height: 40)
                          Row(
                            children: [
                              // No Of EMI's
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "No Of EMI's",
                                      maxLines: 1,
                                      style: GoogleFonts.inriaSans(
                                        fontSize: 12.5 * scaleW.clamp(0.85, 1.05),
                                        fontWeight: FontWeight.w400,
                                        fontStyle: FontStyle.normal,
                                        height: 1.0,
                                        letterSpacing: 0,
                                        color: primaryBlue,
                                      ),
                                    ),
                                    SizedBox(height: 5 * scaleH.clamp(0.85, 1.2)),
                                    _buildDropdownField(
                                      value: _selectedEmis,
                                      hintText: '',
                                      items: _emiOptions,
                                      onChanged: (val) {
                                        if (val != null) {
                                          setState(() {
                                            _selectedEmis = val;
                                          });
                                        }
                                      },
                                      scaleW: scaleW,
                                      scaleH: scaleH,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 14 * scaleW.clamp(0.85, 1.2)),

                              // No Of Chit Members
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'No Of Chit Members',
                                      maxLines: 1,
                                      softWrap: false,
                                      overflow: TextOverflow.visible,
                                      style: GoogleFonts.inriaSans(
                                        fontSize: 12.5 * scaleW.clamp(0.85, 1.05),
                                        fontWeight: FontWeight.w400,
                                        fontStyle: FontStyle.normal,
                                        height: 1.0,
                                        letterSpacing: 0,
                                        color: primaryBlue,
                                      ),
                                    ),
                                    SizedBox(height: 5 * scaleH.clamp(0.85, 1.2)),
                                    _buildDropdownField(
                                      value: _selectedMembers,
                                      hintText: '',
                                      items: _memberOptions,
                                      onChanged: (val) {
                                        if (val != null) {
                                          setState(() {
                                            _selectedMembers = val;
                                          });
                                        }
                                      },
                                      scaleW: scaleW,
                                      scaleH: scaleH,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16 * scaleH.clamp(0.85, 1.2)),

                          // 4. Bottom Note & Submit Button (width: 130, height: 40, border-radius: 20px)
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              // Note text
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Note:',
                                      style: GoogleFonts.inriaSans(
                                        fontSize: 10.5 * scaleW.clamp(0.85, 1.2),
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF757575),
                                      ),
                                    ),
                                    Text(
                                      'Enter Values In Multiples Of\nLakhs In Investment',
                                      style: GoogleFonts.inriaSans(
                                        fontSize: 9.5 * scaleW.clamp(0.85, 1.2),
                                        fontWeight: FontWeight.w400,
                                        fontStyle: FontStyle.normal,
                                        color: const Color(0xFF757575),
                                        height: 1.2,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 8 * scaleW.clamp(0.85, 1.2)),

                              // Submit Button (width: 130, height: 40, border-radius: 20px, background: #3C93F4)
                              SizedBox(
                                width: 130 * scaleW.clamp(0.9, 1.2),
                                height: 40 * scaleH.clamp(0.85, 1.2),
                                child: ElevatedButton(
                                  onPressed: _handleCalculatorSubmit,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: primaryBlue,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    padding: EdgeInsets.zero,
                                  ),
                                  child: Text(
                                    'Submit',
                                    style: GoogleFonts.inter(
                                      fontSize: 14 * scaleW.clamp(0.85, 1.2),
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
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

  // Radio button widget (Inter font, 14px regular, white)
  Widget _buildRadioButton(String title, double scaleW) {
    final bool isSelected = _selectedScheme == title;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _onSchemeChanged(title),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 14 * scaleW.clamp(0.85, 1.2),
            height: 14 * scaleW.clamp(0.85, 1.2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? Colors.transparent : const Color(0x66E2E2E2),
              border: isSelected
                  ? Border.all(
                      color: Colors.white,
                      width: 2.0 * scaleW.clamp(0.85, 1.2),
                    )
                  : null,
            ),
          ),
          SizedBox(width: 6 * scaleW.clamp(0.85, 1.1)),
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 14 * scaleW.clamp(0.85, 1.1),
              fontWeight: FontWeight.w400,
              fontStyle: FontStyle.normal,
              height: 1.0,
              letterSpacing: 0,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  // Input Field: width: 290, height: 40, border-radius: 8px, border-width: 1px
  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
    required double scaleW,
    required double scaleH,
  }) {
    return Container(
      width: 290 * scaleW.clamp(0.85, 1.2),
      height: 40 * scaleH.clamp(0.85, 1.2),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFFD0D5DD),
          width: 1.0,
        ),
      ),
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(horizontal: 12 * scaleW.clamp(0.85, 1.2)),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: GoogleFonts.inriaSans(
          fontSize: 14 * scaleW.clamp(0.85, 1.2),
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.normal,
          height: 1.0,
          letterSpacing: 0,
          color: const Color(0xFF1D2939),
        ),
        decoration: InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.zero,
          hintText: hintText,
          hintStyle: GoogleFonts.inriaSans(
            fontSize: 14 * scaleW.clamp(0.85, 1.2),
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.normal,
            height: 1.0,
            letterSpacing: 0,
            color: const Color(0xFF98A2B3),
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }

  // Dropdown Box: width: 138, height: 40, border-radius: 8px, border-width: 1px
  Widget _buildDropdownField({
    required String? value,
    required String hintText,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    required double scaleW,
    required double scaleH,
  }) {
    return Container(
      width: 138 * scaleW.clamp(0.85, 1.2),
      height: 40 * scaleH.clamp(0.85, 1.2),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFFD0D5DD),
          width: 1.0,
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 10 * scaleW.clamp(0.85, 1.2)),
      alignment: Alignment.center,
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: hintText.isNotEmpty
              ? Text(
            hintText,
            style: GoogleFonts.inriaSans(
              fontSize: 14 * scaleW.clamp(0.85, 1.2),
              fontWeight: FontWeight.w400,
              fontStyle: FontStyle.normal,
              height: 1.0,
              letterSpacing: 0,
              color: const Color(0xFF98A2B3),
            ),
          )
              : null,
          isExpanded: true,
          icon: const Icon(
            Icons.keyboard_arrow_down,
            color: Color(0xFF667085),
            size: 20,
          ),
          style: GoogleFonts.inriaSans(
            fontSize: 14 * scaleW.clamp(0.85, 1.2),
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.normal,
            height: 1.0,
            letterSpacing: 0,
            color: const Color(0xFF1D2939),
          ),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  // --- 7. What We Do Banner ---
  // Specs: width: 361, height: 121, top: 1082px, opacity: 1, angle: 0 deg
  Widget _buildWhatWeDoBanner(double screenWidth, double scaleW) {
    final bannerWidth = screenWidth;
    final bannerHeight = 121 * scaleW;

    return SizedBox(
      width: bannerWidth,
      height: bannerHeight,
      child: Image.asset(
        'assets/images/ss_family2.png',
        width: bannerWidth,
        height: bannerHeight,
        fit: BoxFit.fill,
        errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
      ),
    );
  }

  // --- 8. Quick Links Section ---
  // Specs: Header "Quick Links"
  // Box 1 (About): width: 328, height: 59, border-radius: 8px, background: #FFFFFF
  // Box shadows: 0px 8px 16px 0px #00000014, 0px 0px 4px 0px #0000000A
  // Content details: width: 308, height: 24
  // Box 2 (Faq): width: 328, height: 59, border-radius: 8px, background: #FFFFFF
  // Content details: width: 308, height: 25
  Widget _buildQuickLinksSection(double screenWidth, double scaleW, double scaleH) {
    final cardWidth = (328 * scaleW).clamp(300.0, screenWidth - 28);
    final cardHeight = (59 * scaleH).clamp(56.0, 75.0);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16 * scaleW),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Quick Links (width: 76, height: 10, top: 1225px, left: 16px)
          Text(
            'Quick Links',
            style: GoogleFonts.inter(
              fontSize: 14 * scaleW,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF000000), // #000000
              height: 1.0,
              letterSpacing: 0,
            ),
          ),

          SizedBox(height: 12 * scaleW), // 1251 - (1225 + 14) = 12px

          // Box 1: About Siva Saravana Chits (P) LTD
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AboutUsScreen()),
              );
            },
            child: Container(
              width: cardWidth,
              height: cardHeight,
              padding: EdgeInsets.symmetric(horizontal: 14 * scaleW),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x14000000), // #00000014
                    blurRadius: 16,
                    offset: Offset(0, 8),
                  ),
                  BoxShadow(
                    color: Color(0x0A000000), // #0000000A
                    blurRadius: 4,
                    offset: Offset(0, 0),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Book/Info Icon
                  Image.asset(
                    'assets/images/about.png',
                    width: 24 * scaleW,
                    height: 24 * scaleW,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.info_outline, color: Color(0xFF3C93F4)),
                  ),

                  SizedBox(width: 12 * scaleW),

                  // Text content (width: 308, height: 24 in Figma)
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'About Siva Saravana Chits ( P ) LTD',
                          style: GoogleFonts.inter(
                            fontSize: 12 * scaleW,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF000000), // #000000
                            height: 1.0,
                            letterSpacing: 0,
                          ),
                          maxLines: 1,
                        ),
                        SizedBox(height: 4.5 * scaleW),
                        Text(
                          'About Siva Saravana Chits ( P ) LTD',
                          style: GoogleFonts.inter(
                            fontSize: 10 * scaleW,
                            fontWeight: FontWeight.w400,
                            color: const Color(0x66000000), // #00000066
                            height: 1.0,
                            letterSpacing: 0,
                          ),
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ),

                  // Right iOS arrow (vector: 6.02 x 10.68, color: #212121)
                  Container(
                    width: 24 * scaleW,
                    height: 24 * scaleW,
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 11 * scaleW,
                      color: const Color(0xFF212121),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 9 * scaleW), // 1319 - (1251 + 59) = 9px

          // Box 2: Faq
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FaqScreen()),
              );
            },
            child: Container(
              width: cardWidth,
              height: cardHeight,
              padding: EdgeInsets.symmetric(horizontal: 14 * scaleW),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x14000000), // #00000014
                    blurRadius: 16,
                    offset: Offset(0, 8),
                  ),
                  BoxShadow(
                    color: Color(0x0A000000), // #0000000A
                    blurRadius: 4,
                    offset: Offset(0, 0),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Message/Question Icon
                  Image.asset(
                    'assets/images/message.png',
                    width: 24 * scaleW,
                    height: 24 * scaleW,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.help_outline, color: Color(0xFF3C93F4)),
                  ),

                  SizedBox(width: 12 * scaleW),

                  // Text content (width: 308, height: 25 in Figma)
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Faq',
                          style: GoogleFonts.inter(
                            fontSize: 12 * scaleW,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF1E2638),
                            height: 1.0,
                            letterSpacing: 0,
                          ),
                          maxLines: 1,
                        ),
                        SizedBox(height: 4.5 * scaleW),
                        Text(
                          'Frequently asked questions',
                          style: GoogleFonts.inter(
                            fontSize: 10 * scaleW,
                            fontWeight: FontWeight.w400,
                            color: const Color(0x66000000), // #00000066
                            height: 1.0,
                            letterSpacing: 0,
                          ),
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ),

                  // Right iOS arrow (vector: 6.02 x 10.68, color: #212121)
                  Container(
                    width: 24 * scaleW,
                    height: 24 * scaleW,
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 11 * scaleW,
                      color: const Color(0xFF212121),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- 9. Bottom Navigation Bar ---
  // Specs: width: 38, height: 42, top: 7px, left: 42px (applied to all 3 icons/tabs)
  // Stiff at the bottom, incorporates MediaQuery.padding.bottom for gesture/navigation bar
  Widget _buildBottomNavigationBar(double scaleW, double bottomPadding) {
    const activeColor = Color(0xFF3C93F4);
    const inactiveColor = Color(0xFF818181);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(
          top: BorderSide(
            color: Color(0xFFE2E8F0),
            width: 1.0,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      padding: EdgeInsets.only(
        top: 7 * scaleW,
        bottom: bottomPadding > 0 ? bottomPadding : (8 * scaleW),
        left: 42 * scaleW,
        right: 42 * scaleW,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Home (Active: width: 38, height: 42, top: 7px, left: 42px)
          _buildBottomNavItem(
            index: 0,
            iconAsset: 'assets/images/home.png',
            fallbackIcon: Icons.home,
            label: 'Home',
            isActive: _selectedBottomNavIndex == 0,
            activeColor: activeColor,
            inactiveColor: inactiveColor,
            scaleW: scaleW,
            onTap: () {
              setState(() => _selectedBottomNavIndex = 0);
            },
          ),

          // 2. Calculator (Inactive: height: 42, top: 7px)
          _buildBottomNavItem(
            index: 1,
            iconAsset: 'assets/images/calculator.png',
            fallbackIcon: Icons.calculate_outlined,
            label: 'Calculator',
            isActive: _selectedBottomNavIndex == 1,
            activeColor: activeColor,
            inactiveColor: inactiveColor,
            scaleW: scaleW,
            onTap: () {
              setState(() => _selectedBottomNavIndex = 1);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CalculatorScreen_new(),
                ),
              ).then((_) {
                setState(() => _selectedBottomNavIndex = 0);
              });
            },
          ),

          // 3. Help (Inactive: width: 38, height: 42, top: 7px)
          _buildBottomNavItem(
            index: 2,
            iconAsset: 'assets/images/help.png',
            fallbackIcon: Icons.headset_mic_outlined,
            label: 'Help',
            isActive: _selectedBottomNavIndex == 2,
            activeColor: activeColor,
            inactiveColor: inactiveColor,
            scaleW: scaleW,
            onTap: () {
              setState(() => _selectedBottomNavIndex = 2);
              _showNeedHelpBottomSheet(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavItem({
    required int index,
    required String iconAsset,
    required IconData fallbackIcon,
    required String label,
    required bool isActive,
    required Color activeColor,
    required Color inactiveColor,
    required double scaleW,
    required VoidCallback onTap,
  }) {
    final color = isActive ? activeColor : inactiveColor;
    final itemWidth = (index == 1 ? 56.0 : 38.0) * scaleW;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: SizedBox(
        width: itemWidth,
        height: 42 * scaleW,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              iconAsset,
              width: 24 * scaleW,
              height: 24 * scaleW,
              fit: BoxFit.contain,
              color: isActive ? null : inactiveColor,
              errorBuilder: (context, error, stackTrace) =>
                  Icon(fallbackIcon, size: 24 * scaleW, color: color),
            ),
            SizedBox(height: 2.5 * scaleW),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 10 * scaleW,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                color: color,
                height: 1.0,
              ),
              maxLines: 1,
              overflow: TextOverflow.visible,
            ),
          ],
        ),
      ),
    );
  }
}
