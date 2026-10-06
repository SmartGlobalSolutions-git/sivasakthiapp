import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:siva_sakthi/bottom_navbar.dart';
import 'package:siva_sakthi/payment/payment_history.dart';
import 'package:siva_sakthi/payment/enter_payment.dart';
import 'package:siva_sakthi/payment/payment_model.dart';
import 'package:siva_sakthi/home/home.dart';
import 'package:siva_sakthi/home/notification.dart';
import 'package:siva_sakthi/setting/need_help.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  int _selectedTabIndex = 0;

  TextStyle _t(double size, FontWeight w, Color c) => TextStyle(
        fontFamily: 'Inter',
        fontSize: size,
        fontWeight: w,
        color: c,
        height: 1.0,
      );

  // Sample data representing user's chits
  final List<ChitPaymentItem> _chitItems = [
    ChitPaymentItem(
      id: '1',
      name: 'Chandru',
      groupDetail: '10-L',
      userType: 'Customer',
      chitValue: '10,00,000',
      startDate: '10 Jan 26',
      endDate: '10 Dec 26',
      runningBalance: '5,00,000',
      accountNumber: '10108011866',
      upiId: '10108011866@ubicaps',
      payableAmount: 12500,
      isSelected: true,
    ),
    ChitPaymentItem(
      id: '2',
      name: 'Chandru',
      groupDetail: '10-L',
      userType: 'Customer',
      chitValue: '10,00,000',
      startDate: '10 Jan 26',
      endDate: '10 Dec 26',
      runningBalance: '5,00,000',
      accountNumber: '10108011866',
      upiId: '10108011866@ubicaps',
      payableAmount: 12500,
      isSelected: false,
    ),
    ChitPaymentItem(
      id: '3',
      name: 'Chandru',
      groupDetail: '10-L',
      userType: 'Customer',
      chitValue: '10,00,000',
      startDate: '10 Jan 26',
      endDate: '10 Dec 26',
      runningBalance: '5,00,000',
      accountNumber: '10108011866',
      upiId: '10108011866@ubicaps',
      payableAmount: 12500,
      isSelected: false,
    ),
  ];

  int get _selectedCount => _chitItems.where((c) => c.isSelected).length;

  int get _totalPayableAmount {
    return _chitItems
        .where((c) => c.isSelected)
        .fold(0, (sum, item) => sum + item.payableAmount);
  }

  String _formatCurrency(int amount) {
    final str = amount.toString();
    if (str.length <= 3) return str;
    String lastThree = str.substring(str.length - 3);
    String remaining = str.substring(0, str.length - 3);
    String result = '';
    while (remaining.length > 2) {
      result = ',${remaining.substring(remaining.length - 2)}$result';
      remaining = remaining.substring(0, remaining.length - 2);
    }
    result = '$remaining$result,$lastThree';
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: _buildAppBar(context),
      body: Column(
        children: [
          // Top Segmented Tabs Bar
          _buildTopTabBar(),

          // Main Content
          Expanded(
            child: _selectedTabIndex == 0
                ? _buildMyChitsOverviewTab()
                : _buildPaymentHistoryTab(),
          ),
        ],
      ),
      bottomNavigationBar: MainIconeFrames(
        currentIndex: 3,
        onTabSelected: (index) => MainIconeFrames.navigateToTab(context, 3, index),
      ),
    );
  }

  Widget _buildTopTabBar() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFE2E8F0),
            width: 1.0,
          ),
        ),
      ),
      child: Row(
        children: [
          // Tab 1: My Chits Overview
          Expanded(
            child: InkWell(
              onTap: () {
                setState(() {
                  _selectedTabIndex = 0;
                });
              },
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: _selectedTabIndex == 0
                      ? const Color(0xFFE0EEFF)
                      : Colors.white,
                  border: _selectedTabIndex == 0
                      ? const Border(
                          bottom: BorderSide(
                            color: Color(0xFF3C93F4),
                            width: 2.0,
                          ),
                        )
                      : null,
                ),
                child: Text(
                  'My Chits Overview',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: _selectedTabIndex == 0
                        ? FontWeight.w500
                        : FontWeight.w400,
                    color: _selectedTabIndex == 0
                        ? const Color(0xFF3C93F4)
                        : const Color(0xFF6B7280),
                  ),
                ),
              ),
            ),
          ),

          // Tab 2: Payment History
          Expanded(
            child: InkWell(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        const PaymentHistoryScreen(),
                    transitionDuration: Duration.zero,
                    reverseTransitionDuration: Duration.zero,
                  ),
                );
              },
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: _selectedTabIndex == 1
                      ? const Color(0xFFE0EEFF)
                      : Colors.white,
                  border: _selectedTabIndex == 1
                      ? const Border(
                          bottom: BorderSide(
                            color: Color(0xFF3C93F4),
                            width: 2.0,
                          ),
                        )
                      : null,
                ),
                child: Text(
                  'Payment History',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: _selectedTabIndex == 1
                        ? FontWeight.w500
                        : FontWeight.w400,
                    color: _selectedTabIndex == 1
                        ? const Color(0xFF3C93F4)
                        : const Color(0xFF6B7280),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMyChitsOverviewTab() {
    return Column(
      children: [
        // Scrollable list of cards
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            itemCount: _chitItems.length,
            itemBuilder: (context, index) {
              final item = _chitItems[index];
              return _buildChitCard(item, index);
            },
          ),
        ),

        // Bottom Sticky Action Area
        Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, -3),
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Pay Selected Count Label
                Text(
                  'Pay Selected( $_selectedCount )',
                  style: _t(16, FontWeight.w500, const Color(0xFF1E293B)),
                ),
                const SizedBox(height: 10),

                // Pay Button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _selectedCount > 0
                        ? () {
                            final selectedChits = _chitItems
                                .where((c) => c.isSelected)
                                .map((item) => ChitItem(
                                      chitId: item.accountNumber,
                                      name: item.name,
                                      groupDetail: item.groupDetail,
                                      role: item.userType,
                                      chitValue: item.chitValue,
                                      dateRange:
                                          '${item.startDate} - ${item.endDate}',
                                      runningBalance: item.runningBalance,
                                      acNo: item.accountNumber,
                                      upiId: item.upiId,
                                      status: 'Running',
                                      chitAmount: int.tryParse(item.chitValue.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0,
                                      dueAmount: item.payableAmount,
                                    ))
                                .toList();

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EnterPaymentAmountScreen(
                                  chits: selectedChits,
                                ),
                              ),
                            );
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3C93F4),
                      disabledBackgroundColor: const Color(0xFF3C93F4),
                      disabledForegroundColor: Colors.white,
                      elevation: 0,
                      shape: const StadiumBorder(),
                    ),
                    child: Text(
                      _selectedCount > 0 ? 'Pay ₹ ${_formatCurrency(_totalPayableAmount)}' : 'Pay',
                      style: _t(14, FontWeight.w500, Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildChitCard(ChitPaymentItem item, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          item.isSelected = !item.isSelected;
        });
      },
      child: Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: item.isSelected
              ? const Color(0xFF93C5FD)
              : const Color(0xFFE2E8F0),
          width: item.isSelected ? 1.5 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            Positioned(
              right: 0,
              top: 0,
              child: CustomPaint(
                size: const Size(120, 80),
                painter: _CardTopRightAccentPainter(),
              ),
            ),

            // Card Inner Content
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- TOP ROW: Checkbox, Avatar, Name/Group, Customer Badge ---
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Interactive Checkbox
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            item.isSelected = !item.isSelected;
                          });
                        },
                        child: Container(
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            color: item.isSelected
                                ? const Color(0xFF2563EB)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: item.isSelected
                                  ? const Color(0xFF2563EB)
                                  : const Color(0xFF94A3B8),
                              width: 1.6,
                            ),
                          ),
                          child: item.isSelected
                              ? const Icon(
                                  Icons.check,
                                  size: 16,
                                  color: Colors.white,
                                )
                              : null,
                        ),
                      ),
                      const SizedBox(width: 10),

                      // Avatar with three_person icon (white color)
                      Container(
                        width: 42,
                        height: 42,
                        decoration: const BoxDecoration(
                          color: Color(0xFF2563EB),
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Image.asset(
                          'assets/icons/three_person.png',
                          width: 24,
                          height: 24,
                          color: Colors.white,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(
                            Icons.groups_rounded,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),

                      // Name & Group Detail
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.name,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 16.0,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                            const SizedBox(height: 2),
                            RichText(
                              text: TextSpan(
                                style: const TextStyle(
                                  fontSize: 12.0,
                                  fontFamily: 'Inter',
                                ),
                                children: [
                                  const TextSpan(
                                    text: 'Group Detail ',
                                    style: TextStyle(
                                      color: Color(0xFF64748B),
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  TextSpan(
                                    text: item.groupDetail,
                                    style: const TextStyle(
                                      color: Color(0xFF2563EB),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Customer Badge with user icon (blue color)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4.5,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFF6FF),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: const Color(0xFFBFDBFE),
                            width: 1.0,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              'assets/icons/user.png',
                              width: 14,
                              height: 14,
                              color: const Color(0xFF2563EB),
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(
                                Icons.person,
                                size: 14,
                                color: Color(0xFF2563EB),
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              item.userType,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 11.0,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF2563EB),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // --- MIDDLE ROW: 3 Stats (Chit Value, Start - End Date, Running Balance) ---
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Stat 1: Chit Value (Vault icon with round background)
                        Expanded(
                          flex: 10,
                          child: _buildStatItem(
                            iconPath: 'assets/icons/valut.png',
                            fallbackIcon: Icons.account_balance_wallet_outlined,
                            label: 'Chit Value',
                            value: item.chitValue,
                          ),
                        ),

                        // Vertical Divider
                        Container(
                          width: 1,
                          height: 38,
                          color: const Color(0xFFE2E8F0),
                        ),

                        // Stat 2: Start - End Date (Calendar icon in blue with round background)
                        Expanded(
                          flex: 12,
                          child: _buildStatItem(
                            iconPath: 'assets/icons/calendar.png',
                            fallbackIcon: Icons.calendar_today_outlined,
                            label: 'Start - End Date',
                            value: '${item.startDate} -\n${item.endDate}',
                            iconColor: const Color(0xFF2563EB),
                            isMultiLine: true,
                          ),
                        ),

                        // Vertical Divider
                        Container(
                          width: 1,
                          height: 38,
                          color: const Color.fromARGB(255, 211, 224, 243),
                        ),

                        // Stat 3: Running Balance (Rupee icon in blue with round background)
                        Expanded(
                          flex: 11,
                          child: _buildStatItem(
                            iconPath: 'assets/icons/rupee.png',
                            fallbackIcon: Icons.currency_rupee,
                            label: 'Running Balance',
                            value: item.runningBalance,
                            iconColor: const Color(0xFF2563EB),
                          ),
                        ),
                      ],
                    ),
                  ),


                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

  Widget _buildStatItem({
    required String iconPath,
    required IconData fallbackIcon,
    required String label,
    required String value,
    Color? iconColor,
    bool isMultiLine = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            iconPath,
            width: 13,
            height: 13,
            color: iconColor,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => Icon(
              fallbackIcon,
              size: 13,
              color: iconColor ?? const Color(0xFF2563EB),
            ),
          ),
          const SizedBox(width: 7),

          // Label and Value
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 10.0,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  maxLines: isMultiLine ? 2 : 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: isMultiLine ? 11.0 : 12.0,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0F172A),
                    height: isMultiLine ? 1.15 : 1.2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Payment History Tab with content removed
  Widget _buildPaymentHistoryTab() {
    return const SizedBox.shrink();
  }

  void _showPaymentDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFCBD5E1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Confirm Payment',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Paying for $_selectedCount chit${_selectedCount > 1 ? 's' : ''}',
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF64748B),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total Amount Payable',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF64748B),
                      ),
                    ),
                    Text(
                      '₹ ${_formatCurrency(_totalPayableAmount > 0 ? _totalPayableAmount : 12500)}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF2563EB),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: const Color(0xFF16A34A),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        content: Text(
                          'Payment of ₹ ${_formatCurrency(_totalPayableAmount > 0 ? _totalPayableAmount : 12500)} initiated successfully!',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  child: const Text(
                    'Proceed to Pay',
                    style: TextStyle(
                      fontSize: 16.5,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

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
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          } else {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const SivaSakthiHomeScreen()),
              (route) => false,
            );
          }
        },
      ),
      title: Text(
        'Payment',
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
}

/// Custom painter to draw the decorative subtle top-right curved wave
class _CardTopRightAccentPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: [
          Color(0xFF3B82F6),
          Color(0xFF93C5FD),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(size.width * 0.35, 0);
    path.quadraticBezierTo(
      size.width * 0.55,
      size.height * 0.7,
      size.width,
      size.height * 0.9,
    );
    path.lineTo(size.width, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class ChitPaymentItem {
  final String id;
  final String name;
  final String groupDetail;
  final String userType;
  final String chitValue;
  final String startDate;
  final String endDate;
  final String runningBalance;
  final String accountNumber;
  final String upiId;
  final int payableAmount;
  bool isSelected;

  ChitPaymentItem({
    required this.id,
    required this.name,
    required this.groupDetail,
    required this.userType,
    required this.chitValue,
    required this.startDate,
    required this.endDate,
    required this.runningBalance,
    required this.accountNumber,
    required this.upiId,
    required this.payableAmount,
    this.isSelected = false,
  });
}
