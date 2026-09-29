import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'chit_model.dart';

class PassbookEntry {
  final String slNo;
  final String chitDate;
  final String discountDiv;
  final String divident;
  final String paidDate;
  final String installment;
  final String receiptNo;

  const PassbookEntry({
    required this.slNo,
    required this.chitDate,
    required this.discountDiv,
    required this.divident,
    required this.paidDate,
    required this.installment,
    required this.receiptNo,
  });
}

class PassbookScreen extends StatefulWidget {
  final ChitData chit;

  const PassbookScreen({super.key, required this.chit});

  @override
  State<PassbookScreen> createState() => _PassbookScreenState();
}

class _PassbookScreenState extends State<PassbookScreen> {
  bool _isDownloading = false;
  bool _isSharing = false;

  final List<PassbookEntry> _entries = const [
    PassbookEntry(slNo: '01', chitDate: '10-Nov-2023', discountDiv: '₹ -', divident: '₹ -', paidDate: '10-Nov-2023', installment: '₹50,000.00', receiptNo: 'RCP-08101'),
    PassbookEntry(slNo: '02', chitDate: '10-Dec-2023', discountDiv: '₹6,250.00', divident: '₹150.00', paidDate: '12-Dec-2023', installment: '₹43,600.00', receiptNo: 'RCP-08422'),
    PassbookEntry(slNo: '03', chitDate: '10-Jan-2024', discountDiv: '₹5,800.00', divident: '₹200.00', paidDate: '11-Jan-2024', installment: '₹44,000.00', receiptNo: 'RCP-08990'),
    PassbookEntry(slNo: '04', chitDate: '10-Feb-2024', discountDiv: '₹5,400.00', divident: '₹150.00', paidDate: '10-Feb-2024', installment: '₹44,450.00', receiptNo: 'RCP-09312'),
    PassbookEntry(slNo: '05', chitDate: '10-Mar-2024', discountDiv: '₹5,200.00', divident: '₹100.00', paidDate: '14-Mar-2024', installment: '₹44,700.00', receiptNo: 'RCP-09780'),
    PassbookEntry(slNo: '06', chitDate: '10-Apr-2024', discountDiv: '₹5,000.00', divident: '₹150.00', paidDate: '10-Apr-2024', installment: '₹44,850.00', receiptNo: 'RCP-10145'),
    PassbookEntry(slNo: '07', chitDate: '10-May-2024', discountDiv: '₹4,800.00', divident: '₹100.00', paidDate: '11-May-2024', installment: '₹45,100.00', receiptNo: 'RCP-10620'),
    PassbookEntry(slNo: '08', chitDate: '10-Jun-2024', discountDiv: '₹4,500.00', divident: '₹120.00', paidDate: '12-Jun-2024', installment: '₹45,380.00', receiptNo: 'RCP-11005'),
    PassbookEntry(slNo: '09', chitDate: '10-Jul-2024', discountDiv: '₹4,200.00', divident: '₹150.00', paidDate: '10-Jul-2024', installment: '₹45,650.00', receiptNo: 'RCP-11440'),
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
      csv.writeln('SL. NO.,CHIT DATE,DISCOUNT / DIV.,DIVIDENT,PAID DATE,INSTALLMENT (₹),RECEIPT NO.');
      for (final e in _entries) {
        csv.writeln('${e.slNo},${e.chitDate},${e.discountDiv},${e.divident},${e.paidDate},${e.installment},${e.receiptNo}');
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
      csv.writeln('SL. NO.,CHIT DATE,DISCOUNT / DIV.,DIVIDENT,PAID DATE,INSTALLMENT (₹),RECEIPT NO.');
      for (final e in _entries) {
        csv.writeln('${e.slNo},${e.chitDate},${e.discountDiv},${e.divident},${e.paidDate},${e.installment},${e.receiptNo}');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              children: [
                // Back button (arrow)
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Padding(
                    padding: EdgeInsets.only(right: 8.0),
                    child: Icon(
                      Icons.arrow_back,
                      color: Color(0xFF000000),
                      size: 24,
                    ),
                  ),
                ),
                // Title "Passbook"
                Text(
                  'Passbook',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF000000),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Excel Box Grid Ledger Table Container
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 10.0, 16.0, 10.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFF94A3B8),
                    width: 1.0,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x0A000000),
                      offset: Offset(0, 4),
                      blurRadius: 8,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final double colWidth = (constraints.maxWidth / 10).clamp(34.0, 60.0);

                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      child: SizedBox(
                        width: colWidth * 10 > constraints.maxWidth ? colWidth * 10 : constraints.maxWidth,
                        height: constraints.maxHeight,
                        child: Row(
                          children: [
                            // 1. Blue Excel Header Column (Left)
                            Expanded(
                              flex: 1,
                              child: Container(
                                color: const Color(0xFF3C93F4), // Darker rich royal blue
                                child: Column(
                                  children: [
                                    _buildExcelHeaderBox('RECEIPT NO.', flex: 16),
                                    _buildExcelHeaderBox('INSTALLMENT (₹)', flex: 16),
                                    _buildExcelHeaderBox('PAID DATE', flex: 15),
                                    _buildExcelHeaderBox('DIVIDENT', flex: 13),
                                    _buildExcelHeaderBox('DISCOUNT / DIV.', flex: 14),
                                    _buildExcelHeaderBox('CHIT DATE', flex: 15),
                                    _buildExcelHeaderBox('SL. NO.', flex: 11, isBottom: true),
                                  ],
                                ),
                              ),
                            ),

                            // 2. 9 Data Columns with Excel Grid Box Borders
                            ..._entries.asMap().entries.map((item) {
                              final int index = item.key;
                              final PassbookEntry entry = item.value;
                              final Color cellBg = index.isEven ? Colors.white : const Color(0xFFF1F5F9);

                              return Expanded(
                                flex: 1,
                                child: Container(
                                  color: cellBg,
                                  child: Column(
                                    children: [
                                      // RECEIPT NO.
                                      _buildExcelDataBox(
                                        child: Text(
                                          entry.receiptNo,
                                          style: GoogleFonts.inter(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w700,
                                            color: const Color(0xFF000000), // Dark bold text
                                          ),
                                        ),
                                        flex: 16,
                                      ),
                                      // INSTALLMENT (₹)
                                      _buildExcelDataBox(
                                        child: Text(
                                          entry.installment,
                                          style: GoogleFonts.inter(
                                            fontSize: 11.5,
                                            fontWeight: FontWeight.w900,
                                            color: const Color(0xFF000000), // Solid dark black
                                          ),
                                        ),
                                        flex: 16,
                                      ),
                                      // PAID DATE
                                      _buildExcelDataBox(
                                        child: Text(
                                          entry.paidDate,
                                          style: GoogleFonts.inter(
                                            fontSize: 9.5,
                                            fontWeight: FontWeight.w700,
                                            color: const Color(0xFF000000), // Dark bold text
                                          ),
                                        ),
                                        flex: 15,
                                      ),
                                      // DIVIDENT
                                      _buildExcelDataBox(
                                        child: Text(
                                          entry.divident,
                                          style: GoogleFonts.inter(
                                            fontSize: 9.5,
                                            fontWeight: FontWeight.w700,
                                            color: entry.divident.contains('-')
                                                ? const Color(0xFF64748B)
                                                : const Color(0xFF000000), // Dark text
                                          ),
                                        ),
                                        flex: 13,
                                      ),
                                      // DISCOUNT / DIV.
                                      _buildExcelDataBox(
                                        child: Text(
                                          entry.discountDiv,
                                          style: GoogleFonts.inter(
                                            fontSize: 9.5,
                                            fontWeight: FontWeight.w700,
                                            color: entry.discountDiv.contains('-')
                                                ? const Color(0xFF64748B)
                                                : const Color(0xFF000000), // Dark text
                                          ),
                                        ),
                                        flex: 14,
                                      ),
                                      // CHIT DATE
                                      _buildExcelDataBox(
                                        child: Text(
                                          entry.chitDate,
                                          style: GoogleFonts.inter(
                                            fontSize: 9.5,
                                            fontWeight: FontWeight.w700,
                                            color: const Color(0xFF000000), // Dark bold text
                                          ),
                                        ),
                                        flex: 15,
                                      ),
                                      // SL. NO.
                                      _buildExcelDataBox(
                                        child: Text(
                                          entry.slNo,
                                          style: GoogleFonts.inter(
                                            fontSize: 11.5,
                                            fontWeight: FontWeight.w900,
                                            color: const Color(0xFF000000), // Solid dark black
                                          ),
                                        ),
                                        flex: 11,
                                        isBottom: true,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),

          // Bottom Bar: Download & Share Buttons
          Container(
            height: 66,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(
                  color: Color(0xFFC1C3C8),
                  width: 1.0,
                ),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Download Button (Darker blue)
                SizedBox(
                  width: 154,
                  height: 36,
                  child: ElevatedButton.icon(
                    onPressed: _isDownloading ? null : _handleDownload,
                    icon: _isDownloading
                        ? const SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(
                            Icons.download_rounded,
                            color: Colors.white,
                            size: 16,
                          ),
                    label: Text(
                      _isDownloading ? 'Saving...' : 'Download',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3C93F4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(140),
                      ),
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 14),

                // Share Button (Darker blue outline & text)
                SizedBox(
                  width: 154,
                  height: 36,
                  child: OutlinedButton.icon(
                    onPressed: _isSharing ? null : _handleShare,
                    icon: _isSharing
                        ? const SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Color(0xFF3C93F4),
                            ),
                          )
                        : const Icon(
                            Icons.share_outlined,
                            color: Color(0xFF3C93F4),
                            size: 16,
                          ),
                    label: Text(
                      _isSharing ? 'Sharing...' : 'Share',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF3C93F4),
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFF3C93F4), width: 1.2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(140),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExcelHeaderBox(String text, {required int flex, bool isBottom = false}) {
    return Expanded(
      flex: flex,
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            right: const BorderSide(color: Color(0x40FFFFFF), width: 0.8),
            bottom: isBottom
                ? BorderSide.none
                : const BorderSide(color: Color(0x40FFFFFF), width: 0.8),
          ),
        ),
        alignment: Alignment.center,
        child: RotatedBox(
          quarterTurns: 3,
          child: Text(
            text,
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: 0.4,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildExcelDataBox({required Widget child, required int flex, bool isBottom = false}) {
    return Expanded(
      flex: flex,
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            right: const BorderSide(color: Color(0xFF94A3B8), width: 0.8),
            bottom: isBottom
                ? BorderSide.none
                : const BorderSide(color: Color(0xFF94A3B8), width: 0.8),
          ),
        ),
        alignment: Alignment.center,
        child: RotatedBox(
          quarterTurns: 3,
          child: child,
        ),
      ),
    );
  }
}
