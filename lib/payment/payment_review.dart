import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:siva_sakthi/payment/payment_method.dart';
import 'package:siva_sakthi/payment/payment_model.dart';
import 'package:siva_sakthi/payment/widget.dart';

class ReviewPayScreen extends StatelessWidget {
  final List<ChitPayItem> payItems;

  const ReviewPayScreen({
    super.key,
    this.payItems = const [],
  });

  static const Color kTileBg = Color(0xFFFAFAFA);
  static const Color kTileBorder = Color(0xFFE5E7EB);
  static const Color kLine = Color(0xFFD1D5DB);

  int get totalAmount =>
      payItems.isEmpty
          ? 25000
          : payItems.fold(0, (sum, item) => sum + item.payingAmount);

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      centerTitle: false,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black, size: 22),
        onPressed: () => Navigator.maybePop(context),
      ),
      title: Text(
        'Review & Pay',
        style: GoogleFonts.manrope(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: Column(
                  children: [
                    _overviewCard(),
                    const SizedBox(height: 12),
                    _bankCard(),
                    const SizedBox(height: 12),
                    _qrCard(),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () =>
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              PaymentMethodsScreen(
                                payItems: payItems,
                                totalAmount: totalAmount,
                              ),
                        ),
                      ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPayBlue,
                    elevation: 0,
                    shape: const StadiumBorder(),
                  ),
                  child: Text(
                    'Pay ₹ ${formatInr(totalAmount)}',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _overviewCard() {
    final items = payItems.isNotEmpty
        ? payItems
        : sampleChits
        .map((c) => ChitPayItem(chit: c, payingAmount: c.defaultPayAmount))
        .toList();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: kTileBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: kTileBorder, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('My Chits Overview',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: kPayText,
              )),
          const SizedBox(height: 12),
          Container(height: 1, color: kTileBorder),
          for (int i = 0; i < items.length; i++) ...[
            const SizedBox(height: 14),
            _chitBlock(items[i]),
            const SizedBox(height: 14),
            if (i != items.length - 1)
              Container(height: 1, color: kLine),
          ],
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total Amount to Pay',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: kPayGrey,
                  )),
              Text('₹ ${formatInr(totalAmount)}',
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: kPayBlue,
                  )),
            ],
          ),
        ],
      ),
    );
  }

  Widget _chitBlock(ChitPayItem item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Chit Amount',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  height: 16 / 12,
                  color: kPayGrey,
                )),
            Row(children: [
              Text('Chit ID  ',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    height: 16 / 12,
                    color: kPayGrey,
                  )),
              Text(item.chit.chitId,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    height: 16 / 12,
                    fontWeight: FontWeight.w500,
                    color: kPayBlue,
                  )),
            ]),
          ],
        ),
        const SizedBox(height: 4),
        Text('₹ ${formatInr(item.chit.chitAmount)}',
            style: GoogleFonts.inter(
              fontSize: 20,
              height: 26 / 20,
              fontWeight: FontWeight.w500,
              color: kPayBlue,
            )),
        const SizedBox(height: 10),
        _amountRow('Due Amount', '₹ ${formatInr(item.chit.dueAmount)}', kPayText),
        const SizedBox(height: 8),
        _amountRow('Paying Amount', '₹ ${formatInr(item.payingAmount)}', kPayBlue),
      ],
    );
  }

  Widget _amountRow(String label, String value, Color valueColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: GoogleFonts.inter(
              fontSize: 14,
              height: 20 / 14,
              color: kPayText,
            )),
        Text(value,
            style: GoogleFonts.inter(
              fontSize: 14,
              height: 20 / 14,
              color: valueColor,
              fontWeight: valueColor == kPayBlue ? FontWeight.w600 : FontWeight.w400,
            )),
      ],
    );
  }

  // ---------- A/C + UPI card (328 x 89) ----------
  Widget _bankCard() {
    final acNo = payItems.isNotEmpty ? payItems.first.chit.acNo : '10108011866';
    final upiId = payItems.isNotEmpty
        ? payItems.first.chit.upiId
        : '10108011866@ubicaps';

    return Container(
      width: double.infinity,
      height: 89,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: kTileBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: kTileBorder, width: 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _infoRow('assets/icons/pay_account.png', 'A/C No : ', acNo),
          Container(height: 1, color: kTileBorder),
          _infoRow('assets/icons/pay_upi.png', 'UPI ID : ', upiId),
        ],
      ),
    );
  }

  Widget _infoRow(String icon, String label, String value) {
    return SizedBox(
      height: 40,
      child: Row(
        children: [
          Image.asset(icon, width: 24, height: 24),
          const SizedBox(width: 10),
          Text.rich(TextSpan(children: [
            TextSpan(
                text: label,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: kPayGrey,
                )),
            TextSpan(
                text: value,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: kPayBlue,
                )),
          ])),
        ],
      ),
    );
  }

  // ---------- QR card (320 x 146, radius 22, gradient, border #3C93F4 70%) ----------
  Widget _qrCard() {
    return Container(
      width: 320,
      height: 146,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
      ),
      clipBehavior: Clip.antiAlias,
      child: Image.asset(
        'assets/images/payment_qr.png',
        width: 320,
        height: 146,
        fit: BoxFit.cover,
      ),
    );
  }
}