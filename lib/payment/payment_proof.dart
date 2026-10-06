import 'dart:io';
import 'dart:ui' show PathMetric;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:siva_sakthi/payment/payment_model.dart';
import 'package:siva_sakthi/payment/payment_pending.dart';

class PaymentProofScreen extends StatefulWidget {
  final List<ChitPayItem> payItems;
  final int totalAmount;

  const PaymentProofScreen({
    super.key,
    this.payItems = const [],
    this.totalAmount = 25000,
  });

  @override
  State<PaymentProofScreen> createState() => _PaymentProofScreenState();
}

class _PaymentProofScreenState extends State<PaymentProofScreen> {
  static const _blue = Color(0xFF3C93F4);
  static const _bg = Color(0xFFF4F4F4);
  static const _border = Color(0xFFD4D4D4);
  static const _fieldBorder = Color(0xFFE2E8F0);
  static const _navy = Color(0xFF1E293B);
  static const _black60 = Color(0x99000000);

  final _utrController = TextEditingController();
  DateTime _date = DateTime.now();
  XFile? _imageFile;
  final ImagePicker _picker = ImagePicker();

  TextStyle _t(double size, FontWeight w, Color c) => GoogleFonts.inter(
    fontSize: size,
    fontWeight: w,
    color: c,
    height: 1.0,
  );

  String get _dateText =>
      '${_date.month.toString().padLeft(2, '0')}/${_date.day.toString().padLeft(2, '0')}/${_date.year}';

  Future<void> _pickDate() async {
    final d = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: _blue,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
            dialogTheme: const DialogThemeData(backgroundColor: Colors.white),
          ),
          child: child!,
        );
      },
    );
    if (d != null) setState(() => _date = d);
  }

  @override
  void dispose() {
    _utrController.dispose();
    super.dispose();
  }

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
          'Payment Proof',
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
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _bankCard(),
                  const SizedBox(height: 16),
                  _qrCard(),
                  const SizedBox(height: 20),
                  _label('UTR / Transaction ID'),
                  const SizedBox(height: 10),
                  _utrField(),
                  const SizedBox(height: 18),
                  _label('Payment Date'),
                  const SizedBox(height: 10),
                  _dateField(),
                  const SizedBox(height: 18),
                  _label('Upload Payment Screenshot'),
                  const SizedBox(height: 10),
                  _uploadBox(),
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
                  if (_utrController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please enter UTR / Transaction ID')),
                    );
                    return;
                  }
                  if (_imageFile == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please upload a payment screenshot')),
                    );
                    return;
                  }
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>ReceiptPendingScreen()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _blue,
                  elevation: 0,
                  shape: const StadiumBorder(),
                ),
                child: Text(
                  'Submit Payment proof',
                  style: _t(14, FontWeight.w500, Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _label(String text) => Text.rich(
    TextSpan(
      children: [
        TextSpan(text: text, style: _t(13, FontWeight.w600, _navy)),
        TextSpan(text: ' *', style: _t(13, FontWeight.w600, Colors.red)),
      ],
    ),
  );

  Widget _utrField() {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _fieldBorder),
      ),
      alignment: Alignment.center,
      child: TextField(
        controller: _utrController,
        style: _t(14, FontWeight.w400, _navy),
        decoration: InputDecoration(
          isCollapsed: true,
          border: InputBorder.none,
          hintText: 'Enter UTR / Transaction ID',
          hintStyle: _t(14, FontWeight.w400, const Color(0xFF94A3B8)),
        ),
      ),
    );
  }

  Widget _dateField() {
    return GestureDetector(
      onTap: _pickDate,
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: _fieldBorder),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(_dateText, style: _t(14, FontWeight.w400, _navy)),
            Image.asset('assets/icons/pay_cal.png', width: 20, height: 20),
          ],
        ),
      ),
    );
  }

  Widget _uploadBox() {
    return GestureDetector(
      onTap: () async {
        final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
        if (image != null) {
          setState(() {
            _imageFile = image;
          });
        }
      },
      child: CustomPaint(
        painter: _DashedBorderPainter(
          color: const Color(0xFFCBD5E1),
          radius: 12,
        ),
        child: Container(
          width: double.infinity,
          height: 140,
          alignment: Alignment.center,
          child: _imageFile != null
              ? Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.file(File(_imageFile!.path), fit: BoxFit.cover),
                        Container(
                          color: Colors.black38,
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.edit, color: Colors.white, size: 28),
                              const SizedBox(height: 4),
                              Text('Tap to change', style: _t(11, FontWeight.w500, Colors.white)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: Color(0xFFE8F6EF),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.cloud_upload_outlined,
                        size: 26,
                        color: _blue,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Click to upload screenshot',
                      style: _t(11, FontWeight.w600, _navy),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'JPG, PNG up to 5MB',
                      style: _t(9, FontWeight.w400, const Color(0xFF94A3B8)),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  // ---------- same A/C + UPI card as Review & Pay (328 x 89) ----------
  Widget _bankCard() {
    final acNo = widget.payItems.isNotEmpty
        ? widget.payItems.first.chit.acNo
        : '10108011866';
    final upiId = widget.payItems.isNotEmpty
        ? widget.payItems.first.chit.upiId
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
          Text.rich(
            TextSpan(
              children: [
                TextSpan(text: label, style: _t(16, FontWeight.w500, _black60)),
                TextSpan(text: value, style: _t(16, FontWeight.w500, _blue)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------- same QR card (320 x 146, radius 22) ----------
  Widget _qrCard() {
    return Container(
      width: 320,
      height: 146,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(22)),
      clipBehavior: Clip.antiAlias,
      child: Image.asset(
        'assets/images/payment_qr.png',
        width: 320,
        height: 146,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => Container(
          color: Colors.white,
          alignment: Alignment.center,
          child: const Icon(Icons.qr_code_2, size: 80, color: _blue),
        ),
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  final Color color;
  final double radius;
  _DashedBorderPainter({required this.color, required this.radius});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(Offset.zero & size, Radius.circular(radius)),
      );
    for (final PathMetric m in path.computeMetrics()) {
      double d = 0;
      while (d < m.length) {
        canvas.drawPath(m.extractPath(d, d + 5), paint);
        d += 9;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedBorderPainter old) =>
      old.color != color || old.radius != radius;
}
