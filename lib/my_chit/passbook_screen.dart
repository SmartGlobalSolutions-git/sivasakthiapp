import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'chit_model.dart';

class PassbookEntry {
  final String slNo;
  final String receiptNo;
  final String receiptDate;
  final String amount;
  final String payType;

  const PassbookEntry({
    required this.slNo,
    required this.receiptNo,
    required this.receiptDate,
    required this.amount,
    required this.payType,
  });
}

class ChitPassbookScreen extends StatefulWidget {
  final ChitData chit;

  const ChitPassbookScreen({super.key, required this.chit});

  @override
  State<ChitPassbookScreen> createState() => _ChitPassbookScreenState();
}

class _ChitPassbookScreenState extends State<ChitPassbookScreen> {
  static const Color kBg = Color(0xFFF3F3F5);
  static const Color kGold = Color(0xFF3C93F4);
  static const Color kHeaderBlue = Color(0xFF3C93F4);
  static const Color kHeaderDivider = Colors.white24;
  static const Color kValueText = Color(0xFF111827);
  static const Color kDivider = Color(0xFFE5E7EB);
  static const Color kStripe = Color(0x80E5E5E5); // #E5E5E5 @ 50%
  static const double _borderWidth = 0.84;

  static const List<String> _labels = [
    'S.NO',
    'RECEIPT NO.',
    'RECEIPT DATE',
    'AMOUNT',
    'PAY TYPE',
  ];
  static const List<double> _rowHeights = [70, 140, 140, 140, 148];

  static const List<FontWeight> _rowWeights = [
    FontWeight.w700,
    FontWeight.w400,
    FontWeight.w400,
    FontWeight.w700,
    FontWeight.w400,
  ];

  static const double _labelColWidth = 42.7;
  static const double _dataColWidth = 42.7;

  bool _isDownloading = false;
  bool _isSharing = false;

  final List<PassbookEntry> _entries = const [
    PassbookEntry(slNo: '01', receiptNo: 'RCP-08101', receiptDate: '10-Nov-2023', amount: '₹50,000.00', payType: 'Online'),
    PassbookEntry(slNo: '02', receiptNo: 'RCP-08422', receiptDate: '12-Dec-2023', amount: '₹43,600.00', payType: 'Cash'),
    PassbookEntry(slNo: '03', receiptNo: 'RCP-08990', receiptDate: '11-Jan-2024', amount: '₹44,000.00', payType: 'Online'),
    PassbookEntry(slNo: '04', receiptNo: 'RCP-09312', receiptDate: '10-Feb-2024', amount: '₹44,450.00', payType: 'Cash'),
    PassbookEntry(slNo: '05', receiptNo: 'RCP-09780', receiptDate: '14-Mar-2024', amount: '₹44,700.00', payType: 'Online'),
    PassbookEntry(slNo: '06', receiptNo: 'RCP-10145', receiptDate: '10-Apr-2024', amount: '₹44,850.00', payType: 'Cash'),
    PassbookEntry(slNo: '07', receiptNo: 'RCP-10620', receiptDate: '11-May-2024', amount: '₹45,100.00', payType: 'Online'),
    PassbookEntry(slNo: '08', receiptNo: 'RCP-11005', receiptDate: '12-Jun-2024', amount: '₹45,380.00', payType: 'Cash'),
    PassbookEntry(slNo: '09', receiptNo: 'RCP-11440', receiptDate: '10-Jul-2024', amount: '₹45,650.00', payType: 'Online'),
    PassbookEntry(slNo: '', receiptNo: 'Total', receiptDate: '', amount: '₹4,07,730.00', payType: ''),
  ];

  Future<void> _handleDownload() async {
    setState(() {
      _isDownloading = true;
    });

    try {
      final directory = await getApplicationDocumentsDirectory();

      final String csvFilePath = '${directory.path}/Chit_Passbook_${widget.chit.groupCode.replaceAll(' ', '_')}.csv';
      final File csvFile = File(csvFilePath);
      final StringBuffer csv = StringBuffer();
      csv.writeln('S.NO,RECEIPT NO.,RECEIPT DATE,AMOUNT,PAY TYPE');
      for (final e in _entries) {
        csv.writeln('${e.slNo},${e.receiptNo},${e.receiptDate},"${e.amount}",${e.payType}');
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
        SnackBar(content: Text('Download failed: $e'), backgroundColor: Colors.red),
      );
    }
  }

  Future<void> _handleShare() async {
    setState(() {
      _isSharing = true;
    });

    try {
      final tempDir = await getTemporaryDirectory();
      final String shareFilePath = '${tempDir.path}/Passbook_${widget.chit.groupCode.replaceAll(' ', '_')}.csv';
      final File shareFile = File(shareFilePath);
      final StringBuffer csv = StringBuffer();
      csv.writeln('S.NO,RECEIPT NO.,RECEIPT DATE,AMOUNT,PAY TYPE');
      for (final e in _entries) {
        csv.writeln('${e.slNo},${e.receiptNo},${e.receiptDate},"${e.amount}",${e.payType}');
      }
      await shareFile.writeAsString(csv.toString());

      if (!mounted) return;

      setState(() {
        _isSharing = false;
      });

      // ignore: deprecated_member_use
      await Share.shareXFiles(
        [XFile(shareFile.path)],
        text: 'Passbook Ledger - ${widget.chit.name} (Group ${widget.chit.groupCode})',
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isSharing = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Share failed: $e'), backgroundColor: Colors.red),
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
                    e.slNo,
                    e.receiptNo,
                    e.receiptDate,
                    e.amount,
                    e.payType,
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
                          _isDownloading ? 'Saving...' : 'Download',
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
                  onTap: _isSharing ? null : _handleShare,
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
                        _isSharing
                            ? const SizedBox(
                                width: 14,
                                height: 14,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: kGold,
                                ),
                              )
                            : const Icon(Icons.share_outlined, size: 16, color: kGold),
                        const SizedBox(width: 6),
                        Text(
                          _isSharing ? 'Sharing...' : 'Share',
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

