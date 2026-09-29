import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:siva_sakthi/payment/payment_model.dart';

const Color kPayBlue = Color(0xFF3C93F4);
const Color kPayText = Color(0xFF1B1C1C);
const Color kPayGrey = Color(0xFF4B5563);

// ---------------- Tab bar (180 x 52 tabs) ----------------
class PaymentTabBar extends StatelessWidget {
  final List<String> labels;
  final int selectedIndex;
  final Color activeBg;
  final ValueChanged<int> onTap;

  const PaymentTabBar({
    super.key,
    required this.labels,
    required this.selectedIndex,
    required this.activeBg,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      color: Colors.white,
      child: Row(
        children: List.generate(labels.length, (i) {
          final bool active = i == selectedIndex;
          return Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => onTap(i),
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: active ? activeBg : Colors.white,
                  border: active
                      ? const Border(
                    bottom: BorderSide(color: kPayBlue, width: 2),
                  )
                      : null,
                ),
                child: Text(
                  labels[i],
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: active ? FontWeight.w500 : FontWeight.w400,
                    color: active ? kPayBlue : const Color(0xFF6B7280),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

// ---------------- Pay Selected + Pay button ----------------
class PaymentPayBar extends StatelessWidget {
  final int selectedCount;
  final int total;
  final VoidCallback? onPay;

  const PaymentPayBar({
    super.key,
    required this.selectedCount,
    required this.total,
    required this.onPay,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Pay Selected( $selectedCount )',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: kPayText,
              ),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: onPay,
              child: Container(
                width: double.infinity,
                height: 48,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: onPay == null
                      ? kPayBlue.withValues(alpha: 0.5)
                      : kPayBlue,
                  borderRadius: BorderRadius.circular(39),
                ),
                child: Text(
                  'Pay ₹ ${formatInr(total)}',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}