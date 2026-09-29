import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:siva_sakthi/payment/payment_model.dart';
import 'package:siva_sakthi/payment/payment_review.dart';
import 'package:siva_sakthi/payment/widget.dart';

class EnterPaymentAmountScreen extends StatefulWidget {
  final List<ChitItem> chits;
  const EnterPaymentAmountScreen({super.key, required this.chits});

  @override
  State<EnterPaymentAmountScreen> createState() =>
      _EnterPaymentAmountScreenState();
}

class _EnterPaymentAmountScreenState extends State<EnterPaymentAmountScreen> {
  static const Color kLine = Color(0xFFD1D5DB);
  static const Color kTileBg = Color(0xFFFAFAFA);
  static const Color kTileBorder = Color(0xFFE5E7EB);
  static const Color kTagGold = Color(0xFFF2B90C);

  late final List<TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();
    _controllers = widget.chits
        .map((c) => TextEditingController(text: formatInr(c.defaultPayAmount)))
        .toList();
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  int _amountAt(int i) =>
      int.tryParse(_controllers[i].text.replaceAll(',', '')) ?? 0;

  int get _total => List.generate(_controllers.length, _amountAt)
      .fold<int>(0, (sum, v) => sum + v);

  void _setQuickAmount(int index, int value) {
    setState(() => _controllers[index].text = formatInr(value));
  }

  void _onPay() {
    final List<ChitPayItem> payItems = [];
    for (int i = 0; i < widget.chits.length; i++) {
      final amt = _amountAt(i);
      if (amt > 0) {
        payItems.add(ChitPayItem(chit: widget.chits[i], payingAmount: amt));
      }
    }
    if (payItems.isEmpty) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReviewPayScreen(payItems: payItems),
      ),
    );
  }

  // ---------------- App bar (this screen only) ----------------
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      centerTitle: false,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black, size: 22),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        'Payment',
        style: GoogleFonts.inter(
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
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(18, 2, 18, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'My Chits Overview',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      height: 24 / 16,
                      color: kPayText,
                    ),
                  ),
                  const SizedBox(height: 14),
                  for (int i = 0; i < widget.chits.length; i++) ...[
                    _buildTile(i),
                    if (i != widget.chits.length - 1)
                      const SizedBox(height: 16),
                  ],
                ],
              ),
            ),
          ),
          PaymentPayBar(
            selectedCount: widget.chits.length,
            total: _total,
            onPay: _total > 0 ? _onPay : null,
          ),
        ],
      ),
    );
  }

  Widget _line() => Container(height: 1, color: kLine);

  Widget _buildTile(int index) {
    final ChitItem c = widget.chits[index];
    final List<int> quick = [5000, 10000, 15000, c.dueAmount];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 17),
      decoration: BoxDecoration(
        color: kTileBg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: kTileBorder, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Chit Amount + Running tag ........ Chit ID
          Row(
            children: [
              Text(
                'Chit Amount',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  height: 16 / 12,
                  color: kPayGrey,
                ),
              ),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: kTagGold,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  c.status,
                  style: GoogleFonts.inter(
                    fontSize: 8,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                'Chit ID  ',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  height: 16 / 12,
                  color: kPayGrey,
                ),
              ),
              Text(
                c.chitId,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  height: 16 / 12,
                  fontWeight: FontWeight.w500,
                  color: kPayBlue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '₹ ${formatInr(c.chitAmount)}',
            style: GoogleFonts.inter(
              fontSize: 20,
              height: 26 / 20,
              fontWeight: FontWeight.w500,
              color: kPayBlue,
            ),
          ),
          const SizedBox(height: 8),
          _line(),
          const SizedBox(height: 19),
          // Due Amount
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Due Amount',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  height: 20 / 14,
                  color: kPayText,
                ),
              ),
              Text(
                '₹ ${formatInr(c.dueAmount)}',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  height: 20 / 14,
                  color: kPayBlue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 13),
          // Enter Amount
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Enter Amount',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  height: 20 / 14,
                  color: kPayText,
                ),
              ),
              _buildAmountField(index),
            ],
          ),
          const SizedBox(height: 17),
          _line(),
          const SizedBox(height: 12),
          Text(
            'Quick Action',
            style: GoogleFonts.inter(
              fontSize: 14,
              height: 20 / 14,
              color: kPayText,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              for (int q = 0; q < quick.length; q++) ...[
                Expanded(
                  child: GestureDetector(
                    onTap: () => _setQuickAmount(index, quick[q]),
                    child: Container(
                      height: 29,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: const Color(0xFF6B7280),
                          width: 1,
                        ),
                      ),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          '₹ ${formatInr(quick[q])}',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: const Color(0xFF374151),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                if (q != quick.length - 1) const SizedBox(width: 8),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAmountField(int index) {
    final TextStyle style = GoogleFonts.inter(
      fontSize: 14,
      color: kPayBlue,
    );

    return Container(
      width: 156,
      height: 37,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: kPayBlue, width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('₹ ', style: style),
          SizedBox(
            width: 80,
            child: TextField(
              controller: _controllers[index],
              keyboardType: TextInputType.number,
              inputFormatters: [_InrInputFormatter()],
              onChanged: (_) => setState(() {}),
              cursorColor: kPayBlue,
              style: style,
              decoration: const InputDecoration(
                isDense: true,
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
                hintText: '0',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Typing panna panna 1,00,000 format-la maathum
class _InrInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    String digits = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.isEmpty) return const TextEditingValue(text: '');
    if (digits.length > 9) digits = digits.substring(0, 9);
    final String text = formatInr(int.parse(digits));
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}