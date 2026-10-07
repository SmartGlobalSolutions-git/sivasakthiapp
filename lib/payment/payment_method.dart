import 'package:flutter/material.dart';
import 'package:siva_sakthi/payment/payment_model.dart';
import 'package:siva_sakthi/payment/payment_proof.dart';
import 'package:google_fonts/google_fonts.dart';

class PaymentMethodsScreen extends StatefulWidget {
  final List<ChitPayItem> payItems;
  final int totalAmount;

  const PaymentMethodsScreen({
    super.key,
    this.payItems = const [],
    this.totalAmount = 25000,
  });

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  static const _blue = Color(0xff266FAF);
  static const _bg = Color(0xFFF4F4F4);
  static const _green = Color(0xFF047857);
  static const _slate = Color(0xFF64748B);
  static const _navy = Color(0xFF1E293B);
  static const _cardBorder = Color(0xFFE2E8F0);

  int _selected = 1; // 0 = Online Payment, 1 = QR

  TextStyle _t(double size, FontWeight w, Color c,
          {double? height, double? spacing}) =>
      GoogleFonts.inter(
          fontSize: size,
          fontWeight: w,
          color: c,
          height: height ?? 1.0,
          letterSpacing: spacing);

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
          'Payment Methods',
          style: GoogleFonts.manrope(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Total Amount to Pay', style: _t(16, FontWeight.w500, _slate)),
                  const SizedBox(height: 4),
                  // Inter ExtraBold 24 / lh 36 / ls -0.75
                  Text('₹ ${formatInr(widget.totalAmount)}',
                      style: _t(24, FontWeight.w800, _green, height: 36 / 24, spacing: -0.75)),
                  const SizedBox(height: 16),
                  Text('Select Payment Method',
                      style: _t(13.12, FontWeight.w600, _navy, height: 18.74 / 13.12)),
                  const SizedBox(height: 12),
                  _option(
                    index: 0,
                    icon: 'assets/icons/pay_card.png',
                    title: 'Online Payment',
                    subtitle: 'Pay securely using UPI, Debit/Credit Card, Net Banking',
                  ),
                  const SizedBox(height: 12),
                  _option(
                    index: 1,
                    icon: 'assets/icons/pay_qr.png',
                    title: 'QR',
                    subtitle: 'Pay using QR and upload payment proof',
                  ),
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
                onPressed: () {
                  if (_selected == 1) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PaymentProofScreen(
                          payItems: widget.payItems,
                          totalAmount: widget.totalAmount,
                        ),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _blue,
                  elevation: 0,
                  shape: const StadiumBorder(),
                ),
                child: Text('Continue', style: _t(14, FontWeight.w500, Colors.white)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Card: fill x 89.74, radius 14.99, border 0.94 #E2E8F0, padding 14.99
  Widget _option({
    required int index,
    required String icon,
    required String title,
    required String subtitle,
  }) {
    final selected = _selected == index;
    return GestureDetector(
      onTap: () => setState(() => _selected = index),
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(minHeight: 89.74),
        padding: const EdgeInsets.all(14.99),
        decoration: BoxDecoration(
          color: _bg,
          borderRadius: BorderRadius.circular(14.99),
          border: Border.all(color: selected ? _blue : _cardBorder, width: selected ? 1.5 : 0.94),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: selected ? Colors.white : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Image.asset(icon, width: 22, height: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: _t(13.12, FontWeight.w700, _navy, height: 18.74 / 13.12)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: _t(11.25, FontWeight.w400, _slate, height: 18.27 / 11.25)),
                ],
              ),
            ),
            const SizedBox(width: 8),
            selected
                ? const Icon(Icons.check_circle, color: _blue, size: 20)
                : Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: _cardBorder, width: 1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}