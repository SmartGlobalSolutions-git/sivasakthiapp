import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Opens the "Payment Details" bottom sheet (Figma: 360 x 550).
Future<void> showPaymentDetailsSheet(
    BuildContext context, {
      required String chitNo,
      required String groupName,
      required String amountText, // e.g. '₹4,12,500'
      required String paymentDate,
      required String paymentMode,
      required String transactionId,
      required String referenceNo,
      VoidCallback? onDownloadReceipt,
    }) {
  return showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (_) => PaymentDetailsSheet(
      chitNo: chitNo,
      groupName: groupName,
      amountText: amountText,
      paymentDate: paymentDate,
      paymentMode: paymentMode,
      transactionId: transactionId,
      referenceNo: referenceNo,
      onDownloadReceipt: onDownloadReceipt,
    ),
  );
}

class PaymentDetailsSheet extends StatelessWidget {
  final String chitNo;
  final String groupName;
  final String amountText;
  final String paymentDate;
  final String paymentMode;
  final String transactionId;
  final String referenceNo;
  final VoidCallback? onDownloadReceipt;

  const PaymentDetailsSheet({
    super.key,
    required this.chitNo,
    required this.groupName,
    required this.amountText,
    required this.paymentDate,
    required this.paymentMode,
    required this.transactionId,
    required this.referenceNo,
    this.onDownloadReceipt,
  });

  static const Color kBlue = Color(0xff266FAF);
  static const Color kAmountBlue = Color(0xff266FAF);
  static const Color kHeaderBg = Color(0xFFF0F7FF);
  static const Color kAmountBg = Color(0xFFF2F7FF);
  static const Color kSheetBorder = Color(0xFFF3F4F6);
  static const Color kLabel = Color(0xFF4B5563);
  static const Color kValue = Color(0xFF111827);

  // Asset paths (assets/payment/)
  static const String kWallet = 'assets/payment/ic_wallet.png';
  static const String kClose = 'assets/payment/ic_close.png';
  static const String kCheck = 'assets/payment/ic_check.png';
  static const String kCalendar = 'assets/payment/ic_calendar.png';
  static const String kCard = 'assets/payment/ic_card.png';
  static const String kReceipt = 'assets/payment/ic_receipt.png';
  static const String kHash = 'assets/payment/ic_hash.png';
  static const String kDownload = 'assets/payment/ic_download.png';

  Widget _img(String path, double size, IconData fallback, Color color) {
    return Image.asset(
      path,
      width: size,
      height: size,
      fit: BoxFit.contain,
      errorBuilder: (c, e, s) => Icon(fallback, size: size, color: color),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Figma: radius TL/TR 28, top border 1px #F3F4F6, padding 12/20/28/20, bg white
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        border: Border(top: BorderSide(color: kSheetBorder, width: 1)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // drag handle
              Center(
                child: Container(
                  width: 48,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD1D5DB),
                    borderRadius: BorderRadius.circular(9999),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              _buildTitleRow(context),
              const SizedBox(height: 14),
              _buildHeaderCard(),
              const SizedBox(height: 10),
              _buildAmountCard(),
              const SizedBox(height: 8),
              _row(kCalendar, Icons.calendar_today_outlined, 'Payment Date', paymentDate),
              _row(kCard, Icons.credit_card, 'Payment Mode', paymentMode),
              _row(kReceipt, Icons.receipt_long_outlined, 'Transaction ID', transactionId),
              _row(kHash, Icons.tag, 'Reference No', referenceNo, last: true),
              const SizedBox(height: 20),
              _buildDownloadButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitleRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Payment Details',
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: kValue,
          ),
        ),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => Navigator.pop(context),
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: _img(kClose, 20, Icons.close, kValue),
          ),
        ),
      ],
    );
  }

  // Figma: Main Chit Card Header Box 320 x 76, radius 16, padding 14, bg #F0F7FF, space-between
  Widget _buildHeaderCard() {
    return Container(
      width: double.infinity,
      height: 76,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: kHeaderBg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFFDCEAFE),
              borderRadius: BorderRadius.circular(12),
            ),
            child: _img(kWallet, 24, Icons.account_balance_wallet, kAmountBlue),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  chitNo,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    height: 24 / 16,
                    color: kValue,
                  ),
                ),
                Text(
                  groupName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    height: 16 / 12,
                    color: const Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          _approvedChip(),
        ],
      ),
    );
  }

  Widget _approvedChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFECFDF5),
        borderRadius: BorderRadius.circular(9999),
        border: Border.all(color: const Color(0xFF6EE7B7), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _img(kCheck, 14, Icons.check, const Color(0xFF047857)),
          const SizedBox(width: 4),
          Text(
            'Approved',
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF047857),
            ),
          ),
        ],
      ),
    );
  }

  // Figma: Amount Highlight Card 320 x 78, radius 16, padding 12/16, gap 2, bg #F2F7FF
  Widget _buildAmountCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: kAmountBg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Amount Paid',
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              height: 16 / 13,
              color: kLabel,
            ),
          ),
          const SizedBox(height: 2),
          // Inter ExtraBold 30 / lh 36 / ls -0.75 / #1969FE
          Text(
            amountText,
            style: GoogleFonts.inter(
              fontSize: 30,
              fontWeight: FontWeight.w800,
              height: 36 / 30,
              letterSpacing: -0.75,
              color: kAmountBlue,
            ),
          ),
        ],
      ),
    );
  }

  // Detail row: label Inter 500 12 #4B5563, value Inter 600 12 #111827 (right aligned)
  Widget _row(String asset, IconData fallback, String label, String value,
      {bool last = false}) {
    return Container(
      height: 53,
      decoration: BoxDecoration(
        border: last
            ? null
            : const Border(bottom: BorderSide(color: kSheetBorder, width: 1)),
      ),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(8),
            ),
            child: _img(asset, 16, fallback, kLabel),
          ),
          const SizedBox(width: 10),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              height: 16 / 12,
              color: kLabel,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                height: 16 / 12,
                color: kValue,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Figma: Primary Action Button 320 x 52, radius 12, padding 14/16, gap 10, #1E6BFF
  Widget _buildDownloadButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: onDownloadReceipt ?? () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xff266FAF),
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _img(kDownload, 20, Icons.download, Colors.white),
            const SizedBox(width: 10),
            Text(
              'Download Receipt',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}