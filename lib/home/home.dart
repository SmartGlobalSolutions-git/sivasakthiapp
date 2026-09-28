import 'package:flutter/material.dart';

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

  String _selectedPlan = 'Smart Savings Scheme';
  final TextEditingController _investmentCtrl = TextEditingController();
  final TextEditingController _emiCtrl = TextEditingController();
  int _noOfEmis = 20;
  int _noOfMembers = 20;

  @override
  void dispose() {
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
          Icon(Icons.menu, color: kBlack, size: w(24)),
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
          Container(
            padding: EdgeInsets.symmetric(horizontal: w(12), vertical: h(7)),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: kBorderGrey, width: 0.6),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.person_outline, size: w(14), color: kBlack),
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
          SizedBox(width: w(14)),
          Icon(Icons.notifications_none_rounded, color: kBlack, size: w(24)),
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
        child: PageView(
          controller: _bannerController,
          onPageChanged: (i) => setState(() => _bannerIndex = i),
          children: [
            _bannerCard(w, h),
            _bannerCard(w, h),
            _bannerCard(w, h),
          ],
        ),
      ),
    );
  }

  Widget _bannerCard(double Function(double) w, double Function(double) h) {
    return GestureDetector(
      onTap: () {
        // Navigate to Plan Screen
      },
      child: Image.asset(
        'assets/siva_sakthi/home_banner.png',
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
        children: List.generate(4, (i) {
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
      }) {
    return Container(
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
          borderRadius: BorderRadius.circular(w(10)),
          border: Border.all(color: kDivider, width: 0.8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: w(38),
                  height: w(38),
                  decoration: BoxDecoration(
                    color: kBlue.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Container(
                    width: w(24),
                    height: w(24),
                    decoration: const BoxDecoration(
                      color: kBlue,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text('₹',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: w(13),
                            fontWeight: FontWeight.w700)),
                  ),
                ),
                SizedBox(width: w(10)),
                Expanded(
                  child: Text(
                    'Payment Due',
                    style: TextStyle(
                      color: kBlue,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text('View  Details',
                          style: TextStyle(
                            color: kBlue,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          )),
                      Icon(Icons.chevron_right, size: 16, color: kBlue),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(left: w(48), top: h(2)),
              child: RichText(
                text: TextSpan(
                  style: TextStyle(
                    color: kBlack,
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                  ),
                  children: [
                    const TextSpan(text: 'You have '),
                    TextSpan(
                      text: '1',
                      style: TextStyle(color: kRed, fontWeight: FontWeight.w600),
                    ),
                    const TextSpan(text: ' pending payment'),
                  ],
                ),
              ),
            ),
            SizedBox(height: h(14)),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: w(16), vertical: h(12)),
              decoration: BoxDecoration(
                color: kCardBg,
                borderRadius: BorderRadius.circular(w(10)),
                border: Border.all(color: kDivider, width: 0.5),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Due Date',
                            style: TextStyle(
                                color: kBlack.withOpacity(0.7),
                                fontSize: w(12),
                                fontWeight: FontWeight.w400)),
                        SizedBox(height: h(4)),
                        Text('25 May 2025',
                            style: TextStyle(
                                color: kRed,
                                fontSize: w(14),
                                fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Amount',
                            style: TextStyle(
                                color: kBlack.withOpacity(0.7),
                                fontSize: w(12),
                                fontWeight: FontWeight.w400)),
                        SizedBox(height: h(4)),
                        Text('5,000',
                            style: TextStyle(
                                color: kBlack,
                                fontSize: w(14),
                                fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
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
                    child: Text('Pay Now',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: w(13),
                            fontWeight: FontWeight.w700)),
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
        padding: EdgeInsets.all(w(16)),
        decoration: BoxDecoration(
          color: kCardBg,
          borderRadius: BorderRadius.circular(w(12)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Payment Assistance',
                      style: TextStyle(
                          color: kBlack,
                          fontSize: w(16),
                          fontWeight: FontWeight.w700)),
                  SizedBox(height: h(6)),
                  Text('Need help paying your due?\nContact your agent.',
                      style: TextStyle(
                          color: kBlack.withOpacity(0.7),
                          fontSize: w(12),
                          height: 1.4)),
                ],
              ),
            ),
            SizedBox(width: w(10)),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: kBlue,
                elevation: 0,
                padding: EdgeInsets.symmetric(horizontal: w(20), vertical: h(12)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(w(24)),
                ),
              ),
              child: Text('Call Now',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: w(13),
                      fontWeight: FontWeight.w700)),
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
          height: h(190),
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: w(16)),
            itemCount: plans.length,
            separatorBuilder: (_, __) => SizedBox(width: w(12)),
            itemBuilder: (context, index) {
              final plan = plans[index];
              return Container(
                width: w(200),
                padding: EdgeInsets.all(w(14)),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(w(12)),
                  border: Border.all(color: kDivider),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(plan['slots'] as String,
                            style: TextStyle(
                                color: kBlack.withOpacity(0.6), fontSize: w(11))),
                        if (plan['popular'] as bool)
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: w(8), vertical: h(3)),
                            decoration: BoxDecoration(
                              color: kRed.withOpacity(0.08),
                              border: Border.all(
                                  color: kRed.withOpacity(0.4), width: 0.8),
                              borderRadius: BorderRadius.circular(w(4)),
                            ),
                            child: Text('Popular',
                                style: TextStyle(color: kRed, fontSize: w(9))),
                          ),
                      ],
                    ),
                    SizedBox(height: h(10)),
                    Text('₹ ${plan['value']}',
                        style: TextStyle(
                            color: kBlue,
                            fontSize: w(19),
                            fontWeight: FontWeight.w700)),
                    SizedBox(height: h(4)),
                    Text('Subscription - ₹ ${plan['sub']}',
                        style: TextStyle(color: kBlue, fontSize: w(11))),
                    SizedBox(height: h(10)),
                    Text('Instalment - 60 months',
                        style: TextStyle(
                            color: kBlack.withOpacity(0.7), fontSize: w(10.5))),
                    Text('Start date - 01-Oct-2026',
                        style: TextStyle(
                            color: kBlack.withOpacity(0.7), fontSize: w(10.5))),
                    const Spacer(),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kBlue,
                          elevation: 0,
                          padding: EdgeInsets.symmetric(vertical: h(10)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(w(20)),
                          ),
                        ),
                        child: Text('Enquire now',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: w(12),
                                fontWeight: FontWeight.w600)),
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
          SizedBox(height: h(12)),
          _quickLinkTile(w, h, Icons.info_outline, 'About Siva Sakthi', 'About Siva Sakthi'),
          SizedBox(height: h(10)),
          _quickLinkTile(w, h, Icons.help_outline, 'Faq', 'Frequently asked questions'),
        ],
      ),
    );
  }

  Widget _quickLinkTile(
      double Function(double) w,
      double Function(double) h,
      IconData icon,
      String title,
      String subtitle,
      ) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: w(14), vertical: h(14)),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(w(10)),
          border: Border.all(color: kDivider),
        ),
        child: Row(
          children: [
            Icon(icon, color: kBlue, size: w(20)),
            SizedBox(width: w(12)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: TextStyle(
                          color: kBlack,
                          fontSize: w(14),
                          fontWeight: FontWeight.w600)),
                  Text(subtitle,
                      style: TextStyle(
                          color: kBlack.withOpacity(0.6), fontSize: w(11))),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: kBlack.withOpacity(0.5), size: w(18)),
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