import 'package:flutter/material.dart';
import 'package:siva_sakthi/payment/payment_method.dart';
import 'package:siva_sakthi/payment/payment_model.dart';

class ReviewPayScreen extends StatelessWidget {
  final List<ChitPayItem> payItems;

  const ReviewPayScreen({
    super.key,
    this.payItems = const [],
  });

  static const _blue = Color(0xFF3C93F4);
  static const _bg = Color(0xFFF4F4F4);
  static const _border = Color(0xFFD4D4D4);
  static const _black60 = Color(0x99000000);
  static const _black80 = Color(0xCC000000);

  TextStyle _t(double size, FontWeight w, Color c) =>
      TextStyle(fontFamily: 'Inter',
          fontSize: size,
          fontWeight: w,
          color: c,
          height: 1.0);

  int get totalAmount =>
      payItems.isEmpty
          ? 25000
          : payItems.fold(0, (sum, item) => sum + item.payingAmount);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _bg,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black, size: 22),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: Text(
            'Review & Pay', style: _t(16, FontWeight.w500, Colors.black)),
      ),
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
                    backgroundColor: _blue,
                    elevation: 0,
                    shape: const StadiumBorder(),
                  ),
                  child: Text(
                    'Pay ₹ ${formatInr(totalAmount)}',
                    style: _t(14, FontWeight.w500, Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------- My Chits Overview (328 x ~397, radius 16, border 1px #D4D4D4) ----------
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
        color: _bg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _border, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('My Chits Overview',
              style: _t(16, FontWeight.w500, Colors.black)),
          const SizedBox(height: 12),
          const Divider(height: 1, color: _border),
          for (int i = 0; i < items.length; i++) ...[
            const SizedBox(height: 14),
            _chitBlock(items[i]),
            const SizedBox(height: 14),
            const Divider(height: 1, color: _border),
          ],
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total Amount to Pay',
                  style: _t(14, FontWeight.w400, _black80)),
              Text('₹ ${formatInr(totalAmount)}',
                  style: _t(20, FontWeight.w600, _blue)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _chitBlock(ChitPayItem item) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Chit Amount', style: _t(12, FontWeight.w400, _black60)),
            Row(children: [
              Text('Chit ID', style: _t(12, FontWeight.w400, _black60)),
              const SizedBox(width: 4),
              Text(item.chit.chitId, style: _t(14.45, FontWeight.w500, _blue)),
            ]),
          ],
        ),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerLeft,
          child: Text('₹ ${formatInr(item.chit.chitAmount)}',
              style: _t(21.82, FontWeight.w600, _blue)),
        ),
        const SizedBox(height: 10),
        _amountRow(
            'Due Amount', '₹ ${formatInr(item.chit.dueAmount)}', Colors.black),
        const SizedBox(height: 8),
        _amountRow('Paying Amount', '₹ ${formatInr(item.payingAmount)}', _blue),
      ],
    );
  }

  Widget _amountRow(String label, String value, Color valueColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: _t(14, FontWeight.w400, _black80)),
        Text(value, style: _t(14, FontWeight.w600, valueColor)),
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
        color: _bg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _border, width: 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _infoRow('assets/icons/pay_account.png', 'A/C No : ', acNo),
          const Divider(height: 1, color: _border),
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
            TextSpan(text: label, style: _t(16, FontWeight.w500, _black60)),
            TextSpan(text: value, style: _t(16, FontWeight.w500, _blue)),
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