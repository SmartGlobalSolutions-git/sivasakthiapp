import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:siva_sakthi/setting/need_help.dart';
import 'package:siva_sakthi/home/notification.dart';
import 'chit_model.dart';

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

class ChitStatementScreen extends StatefulWidget {
  final ChitData chit;

  const ChitStatementScreen({super.key, required this.chit});

  @override
  State<ChitStatementScreen> createState() => _ChitStatementScreenState();
}

class _ChitStatementScreenState extends State<ChitStatementScreen> {
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

  bool _isDownloading = false;

  final List<PassbookEntry> _entries = const [
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

  Future<void> _handleDownload() async {
    setState(() {
      _isDownloading = true;
    });

    try {
      final directory = await getApplicationDocumentsDirectory();

      final String csvFilePath = '${directory.path}/Chit_Statement_${widget.chit.groupCode.replaceAll(' ', '_')}.csv';
      final File csvFile = File(csvFilePath);
      final StringBuffer csv = StringBuffer();
      csv.writeln('SL. NO.,AUCTION DATE,DISCOUNT / DIV.,DIVIDENT,PAID DATE,INSTALLMENT (₹),RECEIPT NO.');
      for (final e in _entries) {
        csv.writeln('${e.slNo},${e.auctionDate},${e.discountDiv},${e.dividend},${e.paidDate},${e.installment},${e.receiptNo}');
      }
      await csvFile.writeAsString(csv.toString());

      if (!mounted) return;

      setState(() {
        _isDownloading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
              const SizedBox(width: 10),
              Text(
                'Download successfully',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          backgroundColor: const Color(0xFF00A86B),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isDownloading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Download failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

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
        onPressed: () => Navigator.of(context).maybePop(),
      ),
      title: Text(
        'Statement',
        style: GoogleFonts.manrope(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.black,
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
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.headset_mic, size: 14, color: Color(0xFF3C93F4)),
                ),
                const SizedBox(width: 4),
                Text(
                  'Need Help ?',
                  style: GoogleFonts.manrope(
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
                const Icon(Icons.notifications_none, color: Colors.black),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const NotificationScreen()),
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
      appBar: _buildAppBar(),
      body: SafeArea(
        top: false,
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
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
                  onTap: _isDownloading ? null : _handleDownload,
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
                        _isDownloading
                            ? const SizedBox(
                                width: 14,
                                height: 14,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(Icons.file_download_outlined,
                                size: 16, color: Colors.white),
                        const SizedBox(width: 6),
                        Text(
                          _isDownloading ? 'Saving...' : 'Download Statement',
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
            ],
          ),
        ),
      ),
    );
  }
}
