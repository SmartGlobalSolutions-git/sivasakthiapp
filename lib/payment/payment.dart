import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:siva_sakthi/payment/enter_payment.dart';
import 'package:siva_sakthi/payment/payment_history.dart';
import 'package:siva_sakthi/payment/payment_model.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  static const Color kBg = Color(0xFFF3F3F5);
  static const Color kTabActiveBg = Color(0xFFE0EEFF);

  // TODO: replace with API data
  final List<ChitItem> _chits = sampleChits;
  final Set<int> _selected = <int>{};

  int get _total =>
      _selected.fold<int>(0, (sum, i) => sum + _chits[i].defaultPayAmount);

  void _toggle(int index) {
    setState(() {
      if (!_selected.remove(index)) _selected.add(index);
    });
  }

  void _onTabTap(int index) {
    if (index == 1) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
          const PaymentHistoryScreen(),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ),
      );
    }
  }

  void _onPay() {
    final selectedChits =
    (_selected.toList()..sort()).map((i) => _chits[i]).toList();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EnterPaymentAmountScreen(chits: selectedChits),
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
        onPressed: () => Navigator.maybePop(context),
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
      backgroundColor: kBg,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _PayTabBar(
            labels: const ['My Chits Overview', 'Payment History'],
            selectedIndex: 0,
            activeBg: kTabActiveBg,
            onTap: _onTabTap,
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(21.5, 20, 21.5, 16),
              itemCount: _chits.length,
              separatorBuilder: (context, index) => const SizedBox(height: 9),
              itemBuilder: (context, i) => _ChitCardImage(
                selected: _selected.contains(i),
                onTap: () => _toggle(i),
              ),
            ),
          ),
          _PayBar(
            selectedCount: _selected.length,
            total: _total,
            onPay: _selected.isEmpty ? null : _onPay,
          ),
        ],
      ),
    );
  }
}

// =====================================================================
// Colors / constants
// =====================================================================
const Color _kBlue = Color(0xFF3C93F4);
const Color _kText = Color(0xFF1B1C1C);
const String _kCardImage = 'assets/images/payment_card.png';

// =====================================================================
// Tab bar (180 x 52 tabs)
// =====================================================================
class _PayTabBar extends StatelessWidget {
  final List<String> labels;
  final int selectedIndex;
  final Color activeBg;
  final ValueChanged<int> onTap;

  const _PayTabBar({
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
                    bottom: BorderSide(color: _kBlue, width: 2),
                  )
                      : null,
                ),
                child: Text(
                  labels[i],
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: active ? FontWeight.w500 : FontWeight.w400,
                    color: active ? _kBlue : const Color(0xFF6B7280),
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

// =====================================================================
// Pay Selected + Pay button
// =====================================================================
class _PayBar extends StatelessWidget {
  final int selectedCount;
  final int total;
  final VoidCallback? onPay;

  const _PayBar({
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
                color: _kText,
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
                  color: onPay == null ? _kBlue.withOpacity(0.5) : _kBlue,
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

// =====================================================================
// Chit card = image (317 x 158) + checkbox overlay
// =====================================================================
class _ChitCardImage extends StatelessWidget {
  final bool selected;
  final VoidCallback onTap;

  const _ChitCardImage({required this.selected, required this.onTap});

  // Figma card size and checkbox position inside the image
  static const double _cardW = 317;
  static const double _cardH = 158;
  static const double _boxLeft = 12;
  static const double _boxTop = 20.5;
  static const double _boxSize = 17;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AspectRatio(
        aspectRatio: _cardW / _cardH,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double s = constraints.maxWidth / _cardW;
            return Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    _kCardImage,
                    errorBuilder: (context, error, stack) => Container(
                      alignment: Alignment.center,
                      child: const Text('assets/payment/chit_card.png'),
                    ),
                  ),
                ),
                // Covers the checkbox that is baked into the image
                Positioned(
                  left: _boxLeft * s,
                  top: _boxTop * s,
                  child: Container(
                    width: _boxSize * s,
                    height: _boxSize * s,
                    decoration: BoxDecoration(
                      color: selected ? _kBlue : Colors.white,
                      borderRadius: BorderRadius.circular(4 * s),
                      border: Border.all(
                        color: selected ? _kBlue : const Color(0xFF444444),
                        width: 1.2,
                      ),
                    ),
                    child: selected
                        ? Icon(Icons.check, size: 12 * s, color: Colors.white)
                        : null,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}