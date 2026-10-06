import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:siva_sakthi/payment/payment.dart';
import 'package:siva_sakthi/payment/payment_detail_sheet.dart';
import 'package:siva_sakthi/payment/payment_model.dart';
import 'package:siva_sakthi/home/home.dart';
import 'package:siva_sakthi/home/notification.dart';
import 'package:siva_sakthi/setting/need_help.dart';

enum PaymentStatus { pending, approved }

class PaymentHistoryItem {
  final String chitNo;
  final String groupName;
  final String dateTime;
  final int amount;
  final PaymentStatus status;

  const PaymentHistoryItem({
    required this.chitNo,
    required this.groupName,
    required this.dateTime,
    required this.amount,
    required this.status,
  });
}

class _HistorySection {
  final String? title;
  final List<PaymentHistoryItem> items;
  const _HistorySection({this.title, required this.items});
}

class PaymentHistoryScreen extends StatefulWidget {
  const PaymentHistoryScreen({super.key});

  @override
  State<PaymentHistoryScreen> createState() => _PaymentHistoryScreenState();
}

class _PaymentHistoryScreenState extends State<PaymentHistoryScreen> {
  static const Color kBg = Color(0xFFF7F8FC);
  static const Color kTabActiveBg = Color(0xFFE0EEFF);
  static const Color kBlue = Color(0xFF3C93F4);
  static const Color kText = Color(0xFF1B1C1C);
  static const Color kAmount = Color(0xFF4659A5);
  static const Color kMuted = Color(0xFF4F4633);
  static const String kWalletAsset = 'assets/payment/ic_wallet.png';

  // TODO: replace with API data
  static const List<_HistorySection> _sections = [
    _HistorySection(items: [
      PaymentHistoryItem(
        chitNo: 'Chit / 1123',
        groupName: 'Group Name / L-10',
        dateTime: '24 Aug 2026, 11:45 AM',
        amount: 412500,
        status: PaymentStatus.pending,
      ),
      PaymentHistoryItem(
        chitNo: 'Chit / 1123',
        groupName: 'Group Name / L-10',
        dateTime: '24 Jul 2026, 10:45 AM',
        amount: 412500,
        status: PaymentStatus.pending,
      ),
    ]),
    _HistorySection(title: 'July 2026', items: [
      PaymentHistoryItem(
        chitNo: 'Chit / 1123',
        groupName: 'Group Name / L-10',
        dateTime: '24 Jun 2026, 9:45 AM',
        amount: 412500,
        status: PaymentStatus.approved,
      ),
      PaymentHistoryItem(
        chitNo: 'Chit / 1123',
        groupName: 'Group Name / L-10',
        dateTime: '24 May 2026, 10:45 AM',
        amount: 412500,
        status: PaymentStatus.approved,
      ),
      PaymentHistoryItem(
        chitNo: 'Chit / 1123',
        groupName: 'Group Name / L-10',
        dateTime: '24 Aug 2026, 11:45 AM',
        amount: 412500,
        status: PaymentStatus.approved,
      ),
      PaymentHistoryItem(
        chitNo: 'Chit / 1123',
        groupName: 'Group Name / L-10',
        dateTime: '24 Aug 2026, 11:45 AM',
        amount: 412500,
        status: PaymentStatus.approved,
      ),
      PaymentHistoryItem(
        chitNo: 'Chit / 1123',
        groupName: 'Group Name / L-10',
        dateTime: '24 Aug 2026, 11:45 AM',
        amount: 412500,
        status: PaymentStatus.approved,
      ),
    ]),
  ];

  void _onTabTap(int index) {
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
          const PaymentScreen(),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ),
      );
    }
  }

  // Approved card tap -> Payment Details bottom sheet
  void _showDetails(PaymentHistoryItem item) {
    showPaymentDetailsSheet(
      context,
      chitNo: item.chitNo,
      groupName: item.groupName,
      amountText: '₹${formatInr(item.amount)}',
      paymentDate: item.dateTime,
      // TODO: replace with API data
      paymentMode: 'UPI',
      transactionId: 'TXN123456789',
      referenceNo: 'REF458921',
    );
  }

  // ---------------- App bar (this screen only) ----------------
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
        'Payment History',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      appBar: _buildAppBar(context),
      body: Column(
        children: [
          _buildTabBar(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(top: 14, bottom: 16),
              children: _buildRows(),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- Tab bar (180 x 52 tabs) ----------------
  Widget _buildTabBar() {
    const labels = ['My Chit Overview', 'Payment History'];
    const int selectedIndex = 1;

    return Container(
      height: 52,
      color: Colors.white,
      child: Row(
        children: List.generate(labels.length, (i) {
          final bool active = i == selectedIndex;
          return Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => _onTabTap(i),
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: active ? kTabActiveBg : Colors.white,
                  border: active
                      ? const Border(
                    bottom: BorderSide(color: kBlue, width: 2),
                  )
                      : null,
                ),
                child: Text(
                  labels[i],
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: active ? FontWeight.w500 : FontWeight.w400,
                    color: active ? kBlue : const Color(0xFF6B7280),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  List<Widget> _buildRows() {
    final rows = <Widget>[];
    for (final section in _sections) {
      if (section.title != null) rows.add(_buildMonthHeader(section.title!));
      for (final item in section.items) {
        rows.add(
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: item.status == PaymentStatus.approved
                  ? () => _showDetails(item)
                  : null,
              child: _buildCard(item),
            ),
          ),
        );
        rows.add(const SizedBox(height: 10));
      }
    }
    return rows;
  }

  Widget _buildMonthHeader(String title) {
    Widget line() => Expanded(
      child: Container(height: 1, color: const Color(0xFFE5E5E5)),
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(5, 7, 5, 11),
      child: Row(
        children: [
          line(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              title,
              style: GoogleFonts.hankenGrotesk(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                height: 16 / 12,
                color: kMuted,
              ),
            ),
          ),
          line(),
        ],
      ),
    );
  }

  // Figma: Transaction Card 320 x 80, radius 10.97, border 0.91 #D3C5AD @10%
  Widget _buildCard(PaymentHistoryItem item) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.97),
        border: Border.all(color: const Color(0x1AD3C5AD), width: 0.91),
      ),
      child: Stack(
        children: [
          Positioned(
            left: 5,
            top: 18,
            child: Container(
              width: 44,
              height: 44,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: Color(0xFFEFF6FF),
                shape: BoxShape.circle,
              ),
              child: Image.asset(
                kWalletAsset,
                width: 22,
                height: 22,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stack) => const Icon(
                  Icons.account_balance_wallet,
                  size: 22,
                  color: kBlue,
                ),
              ),
            ),
          ),
          Positioned(
            left: 64,
            top: 9,
            right: 96,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.chitNo,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    height: 1.4,
                    color: kText,
                  ),
                ),
                Text(
                  item.groupName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    height: 1.5,
                    color: kText,
                  ),
                ),
                Text(
                  item.dateTime,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    height: 1.5,
                    color: kMuted,
                  ),
                ),
              ],
            ),
          ),
          Positioned(right: 10, top: 10, child: _buildStatusChip(item.status)),
          Positioned(
            right: 10,
            top: 46,
            child: Text(
              '₹${formatInr(item.amount)}',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                height: 25.6 / 16,
                color: kAmount,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(PaymentStatus status) {
    if (status == PaymentStatus.pending) {
      // Figma: bg #FFFBEB, border #FDE68A 80%, text #B45309, padding 2/8, gap 4
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          color: const Color(0xFFFFFBEB),
          borderRadius: BorderRadius.circular(9999),
          border: Border.all(color: const Color(0xCCFDE68A), width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                color: Color(0xFFF59E0B),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              'Pending',
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                height: 16.5 / 11,
                color: const Color(0xFFB45309),
              ),
            ),
          ],
        ),
      );
    }

    // Figma: bg #E0F8EB, text #08582F, padding 2/8, gap 2
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0xFFE0F8EB),
        borderRadius: BorderRadius.circular(9999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check, size: 14, color: Color(0xFF16A34A)),
          const SizedBox(width: 2),
          Text(
            'Approved',
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              height: 16.5 / 11,
              color: const Color(0xFF08582F),
            ),
          ),
        ],
      ),
    );
  }
}