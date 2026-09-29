import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PassbookEntry {
  final String slNo;
  final String auctionDate;
  final String discountDiv;
  final String dividend;
  final String paidDate;
  final String installment;
  final String receiptNo;

  const PassbookEntry({
    required this.slNo,
    required this.auctionDate,
    required this.discountDiv,
    required this.dividend,
    required this.paidDate,
    required this.installment,
    required this.receiptNo,
  });
}

class PassbookScreen extends StatefulWidget {
  final String? chitId;
  final DateTimeRange? dateRange;
  const PassbookScreen({super.key, this.chitId, this.dateRange});

  @override
  State<PassbookScreen> createState() => _PassbookScreenState();
}

class _PassbookScreenState extends State<PassbookScreen> {
  static const Color kBg = Color(0xFFF3F3F5);
  static const Color kGold = Color(0xFF3C93F4);
  static const Color kHeaderBlue = Color(0xFF193FBD);
  static const Color kHeaderDivider = Color(0xFF3C93F4);
  static const Color kValueText = Color(0xFF111827);
  static const Color kDivider = Color(0xFFE5E7EB);
  static const Color kStripe = Color(0x80E5E5E5); // #E5E5E5 @ 50%
  static const double _borderWidth = 0.84;

  static const List<String> _labels = [
    'RECEIPT NO.',
    'INSTALLMENT (₹)',
    'PAID DATE',
    'DIVIDENT',
    'DISCOUNT / DIV.',
    'AUCTION DATE',
    'SL. NO.',
  ];
  static const List<double> _rowHeights = [90, 120, 93, 62, 114, 103, 55];

  // Figma: INSTALLMENT and SL. NO. rows are bold (700), others regular
  static const List<FontWeight> _rowWeights = [
    FontWeight.w400,
    FontWeight.w700,
    FontWeight.w400,
    FontWeight.w400,
    FontWeight.w400,
    FontWeight.w400,
    FontWeight.w700,
  ];

  static const double _labelColWidth = 37.47;
  static const double _dataColWidth = 35.8;

  bool _loading = true;
  List<PassbookEntry> _entries = const [];

  @override
  void initState() {
    super.initState();
    _fetchStatement();
  }

  Future<void> _fetchStatement() async {
    // TODO: replace with the real API call using widget.chitId / widget.dateRange
    await Future.delayed(const Duration(milliseconds: 300));
    setState(() {
      _entries = const [
        PassbookEntry(slNo: '01', auctionDate: '10-Nov-2023', discountDiv: '₹ -', dividend: '₹ -', paidDate: '10-Nov-2023', installment: '₹50,000.00', receiptNo: 'RCP-08101'),
        PassbookEntry(slNo: '02', auctionDate: '10-Dec-2023', discountDiv: '₹6,250.00', dividend: '₹150.00', paidDate: '12-Dec-2023', installment: '₹43,600.00', receiptNo: 'RCP-08422'),
        PassbookEntry(slNo: '03', auctionDate: '10-Jan-2024', discountDiv: '₹5,800.00', dividend: '₹200.00', paidDate: '11-Jan-2024', installment: '₹44,000.00', receiptNo: 'RCP-08990'),
        PassbookEntry(slNo: '04', auctionDate: '10-Feb-2024', discountDiv: '₹5,400.00', dividend: '₹150.00', paidDate: '10-Feb-2024', installment: '₹44,450.00', receiptNo: 'RCP-09312'),
        PassbookEntry(slNo: '05', auctionDate: '10-Mar-2024', discountDiv: '₹5,200.00', dividend: '₹100.00', paidDate: '14-Mar-2024', installment: '₹44,700.00', receiptNo: 'RCP-09780'),
        PassbookEntry(slNo: '06', auctionDate: '10-Apr-2024', discountDiv: '₹5,000.00', dividend: '₹150.00', paidDate: '10-Apr-2024', installment: '₹44,850.00', receiptNo: 'RCP-10145'),
        PassbookEntry(slNo: '07', auctionDate: '10-May-2024', discountDiv: '₹4,800.00', dividend: '₹100.00', paidDate: '11-May-2024', installment: '₹45,100.00', receiptNo: 'RCP-10620'),
        PassbookEntry(slNo: '08', auctionDate: '10-Jun-2024', discountDiv: '₹4,500.00', dividend: '₹120.00', paidDate: '12-Jun-2024', installment: '₹45,380.00', receiptNo: 'RCP-11005'),
        PassbookEntry(slNo: '09', auctionDate: '10-Jul-2024', discountDiv: '₹4,200.00', dividend: '₹150.00', paidDate: '10-Jul-2024', installment: '₹45,650.00', receiptNo: 'RCP-11440'),
      ];
      _loading = false;
    });
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
        'Passbook',
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
      backgroundColor: kBg,
      appBar: _buildAppBar(),
      body: SafeArea(
        top: false,
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator(color: kGold))
                  : SingleChildScrollView(
                // left padding only - table scrolls to the right edge like Figma
                padding: const EdgeInsets.only(left: 16, top: 16, bottom: 16),
                child: _buildPassbookTable(),
              ),
            ),
            _buildBottomActions(),
          ],
        ),
      ),
    );
  }

  // ---------------- Transposed passbook table ----------------
  Widget _buildPassbookTable() {
    final double totalHeight = _rowHeights.reduce((a, b) => a + b);

    return SizedBox(
      height: totalHeight,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Fixed left header column
          Container(
            width: _labelColWidth,
            decoration: const BoxDecoration(
              color: kHeaderBlue,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                bottomLeft: Radius.circular(8),
              ),
            ),
            child: Column(
              children: List.generate(_labels.length, (i) {
                final bool isLast = i == _labels.length - 1;
                return Container(
                  height: _rowHeights[i],
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: isLast
                        ? null
                        : const Border(
                      bottom: BorderSide(
                        color: kHeaderDivider,
                        width: _borderWidth,
                      ),
                    ),
                  ),
                  child: RotatedBox(
                    quarterTurns: 3,
                    child: Text(
                      _labels[i],
                      maxLines: 1,
                      style: GoogleFonts.inter(
                        fontSize: 10.06,
                        height: 13.41 / 10.06,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          // Scrollable data columns
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(_entries.length, (colIndex) {
                  final e = _entries[colIndex];
                  final bool striped = colIndex.isOdd;
                  final cells = [
                    e.receiptNo,
                    e.installment,
                    e.paidDate,
                    e.dividend,
                    e.discountDiv,
                    e.auctionDate,
                    e.slNo,
                  ];

                  return Container(
                    width: _dataColWidth,
                    decoration: BoxDecoration(
                      color: striped ? kStripe : Colors.white,
                      border: const Border(
                        right: BorderSide(
                          color: kDivider,
                          width: _borderWidth,
                        ),
                      ),
                    ),
                    child: Column(
                      children: List.generate(cells.length, (rowIndex) {
                        return Container(
                          height: _rowHeights[rowIndex],
                          alignment: Alignment.center,
                          child: RotatedBox(
                            quarterTurns: 3,
                            child: Text(
                              cells[rowIndex],
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                fontSize: 10.06,
                                height: 13.41 / 10.06,
                                fontWeight: _rowWeights[rowIndex],
                                color: kValueText,
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- Download & Share (fixed at bottom, no bottom nav) ----------------
  Widget _buildBottomActions() {
    return Container(
      width: double.infinity,
      color: Colors.white,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    // TODO: hook up passbook PDF download
                  },
                  child: Container(
                    height: 36,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: kGold,
                      borderRadius: BorderRadius.circular(39),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.file_download_outlined,
                            size: 16, color: Colors.white),
                        const SizedBox(width: 6),
                        Text(
                          'Download',
                          style: GoogleFonts.manrope(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    // TODO: hook up passbook share
                  },
                  child: Container(
                    height: 36,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(39),
                      border: Border.all(color: kGold, width: 1),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.share_outlined, size: 16, color: kGold),
                        const SizedBox(width: 6),
                        Text(
                          'Share',
                          style: GoogleFonts.manrope(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: kGold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}