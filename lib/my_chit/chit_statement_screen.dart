import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:siva_sakthi/setting/need_help.dart';
import 'package:siva_sakthi/home/notification.dart';
import 'chit_model.dart';

class ChitStatementEntry {
  final String sno;
  final String date;
  final String type; // 'Credit' or 'Debit'
  final String dividend;
  final String debit;
  final String credit;
  final String balance;

  const ChitStatementEntry({
    required this.sno,
    required this.date,
    required this.type,
    required this.dividend,
    required this.debit,
    required this.credit,
    required this.balance,
  });
}

class ChitStatementScreen extends StatefulWidget {
  final ChitData chit;

  const ChitStatementScreen({super.key, required this.chit});

  @override
  State<ChitStatementScreen> createState() => _ChitStatementScreenState();
}

class _ChitStatementScreenState extends State<ChitStatementScreen> {
  bool _isDownloading = false;

  final List<ChitStatementEntry> _entries = const [
    ChitStatementEntry(sno: '1', date: '15-02-2024', type: 'Credit', dividend: '₹500', debit: '-', credit: '₹10,000', balance: '₹10,000'),
    ChitStatementEntry(sno: '2', date: '20-03-2024', type: 'Debit', dividend: '-', debit: '₹10,000', credit: '-', balance: '₹0'),
    ChitStatementEntry(sno: '3', date: '20-03-2024', type: 'Credit', dividend: '₹500', debit: '-', credit: '₹10,000', balance: '₹10,000'),
    ChitStatementEntry(sno: '4', date: '20-04-2024', type: 'Debit', dividend: '-', debit: '₹10,000', credit: '-', balance: '₹0'),
    ChitStatementEntry(sno: '5', date: '20-04-2024', type: 'Credit', dividend: '₹500', debit: '-', credit: '₹10,000', balance: '₹10,000'),
    ChitStatementEntry(sno: '6', date: '20-05-2024', type: 'Debit', dividend: '-', debit: '₹10,000', credit: '-', balance: '₹0'),
    ChitStatementEntry(sno: '7', date: '20-05-2024', type: 'Credit', dividend: '₹500', debit: '-', credit: '₹10,000', balance: '₹10,000'),
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
      csv.writeln('S.NO,DATE,TYPE,DIVIDEND,DEBIT,CREDIT,BALANCE');
      for (final e in _entries) {
        csv.writeln('${e.sno},${e.date},${e.type},${e.dividend},${e.debit},${e.credit},${e.balance}');
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
                // Title "Chit Statement"
                Text(
                  'Chit Statement',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF000000),
                  ),
                ),
                const Spacer(),
                // Need Help Button
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const NeedHelpScreen(),
                      ),
                    );
                  },
                  child: Image.asset(
                    'assets/chit/Group 146124.png',
                    height: 33,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(width: 14),
                // Notification Icon
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const NotificationScreen(),
                      ),
                    );
                  },
                  child: Image.asset(
                    'assets/chit/notification-svgrepo-com (1) 1.png',
                    width: 22,
                    height: 22,
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Transaction Table Container
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
                    final double colWidth = (constraints.maxWidth / 8).clamp(38.0, 70.0);

                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      child: SizedBox(
                        width: colWidth * 8 > constraints.maxWidth ? colWidth * 8 : constraints.maxWidth,
                        height: constraints.maxHeight,
                        child: Row(
                          children: [
                            // 1. Blue Header Column (Left)
                            Expanded(
                              flex: 1,
                              child: Container(
                                color: const Color(0xFF3C93F4),
                                child: Column(
                                  children: [
                                    _buildHeaderCell('BALANCE', flex: 14),
                                    _buildHeaderCell('CREDIT', flex: 14),
                                    _buildHeaderCell('DEBIT', flex: 14),
                                    _buildHeaderCell('DIVIDEND', flex: 14),
                                    _buildHeaderCell('TYPE', flex: 14),
                                    _buildHeaderCell('DATE', flex: 18),
                                    _buildHeaderCell('S.NO', flex: 12, isBottom: true),
                                  ],
                                ),
                              ),
                            ),

                            // 2. Data Columns (7 Entries)
                            ..._entries.map((entry) {
                              return Expanded(
                                flex: 1,
                                child: Container(
                                  decoration: const BoxDecoration(
                                    border: Border(
                                      left: BorderSide(
                                        color: Color(0xFFF1F5F9),
                                        width: 0.8,
                                      ),
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      // BALANCE
                                      _buildDataCell(
                                        child: Text(
                                          entry.balance,
                                          style: GoogleFonts.inter(
                                            fontSize: 11.5,
                                            fontWeight: FontWeight.w700,
                                            color: const Color(0xFF0F172A),
                                          ),
                                        ),
                                        flex: 14,
                                      ),
                                      // CREDIT
                                      _buildDataCell(
                                        child: Text(
                                          entry.credit,
                                          style: GoogleFonts.inter(
                                            fontSize: 11.5,
                                            fontWeight: FontWeight.w700,
                                            color: entry.credit == '-'
                                                ? const Color(0xFF94A3B8)
                                                : const Color(0xFF00A86B),
                                          ),
                                        ),
                                        flex: 14,
                                      ),
                                      // DEBIT
                                      _buildDataCell(
                                        child: Text(
                                          entry.debit,
                                          style: GoogleFonts.inter(
                                            fontSize: 11.5,
                                            fontWeight: FontWeight.w700,
                                            color: entry.debit == '-'
                                                ? const Color(0xFF94A3B8)
                                                : const Color(0xFFEF4444),
                                          ),
                                        ),
                                        flex: 14,
                                      ),
                                      // DIVIDEND
                                      _buildDataCell(
                                        child: Text(
                                          entry.dividend,
                                          style: GoogleFonts.inter(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                            color: entry.dividend == '-'
                                                ? const Color(0xFF94A3B8)
                                                : const Color(0xFF1E293B),
                                          ),
                                        ),
                                        flex: 14,
                                      ),
                                      // TYPE (Badge: Credit green, Debit red)
                                      _buildDataCell(
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: entry.type == 'Credit'
                                                ? const Color(0xFFDCFCE7)
                                                : const Color(0xFFFEE2E2),
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Text(
                                            entry.type,
                                            style: GoogleFonts.inter(
                                              fontSize: 9.5,
                                              fontWeight: FontWeight.w700,
                                              color: entry.type == 'Credit'
                                                  ? const Color(0xFF00A86B)
                                                  : const Color(0xFFEF4444),
                                            ),
                                          ),
                                        ),
                                        flex: 14,
                                      ),
                                      // DATE
                                      _buildDataCell(
                                        child: Text(
                                          entry.date,
                                          style: GoogleFonts.inter(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w700,
                                            color: const Color(0xFF000000),
                                          ),
                                        ),
                                        flex: 18,
                                      ),
                                      // S.NO
                                      _buildDataCell(
                                        child: Text(
                                          entry.sno,
                                          style: GoogleFonts.inter(
                                            fontSize: 11.5,
                                            fontWeight: FontWeight.w800,
                                            color: const Color(0xFF000000),
                                          ),
                                        ),
                                        flex: 12,
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

          // Bottom Bar: Download Statement
          Container(
            height: 74,
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
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22.0),
              child: SizedBox(
                width: 316,
                height: 40,
                child: ElevatedButton.icon(
                  onPressed: _isDownloading ? null : _handleDownload,
                  icon: _isDownloading
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(
                          Icons.download_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                  label: Text(
                    _isDownloading ? 'Downloading...' : 'Download Statement',
                    style: GoogleFonts.inter(
                      fontSize: 14,
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
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(String text, {required int flex, bool isBottom = false}) {
    return Expanded(
      flex: flex,
      child: Container(
        decoration: BoxDecoration(
          border: isBottom
              ? null
              : Border(
                  bottom: BorderSide(
                    color: Color(0x33FFFFFF),
                    width: 0.8,
                  ),
                ),
        ),
        alignment: Alignment.center,
        child: RotatedBox(
          quarterTurns: 3,
          child: Text(
            text,
            style: GoogleFonts.inter(
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDataCell({required Widget child, required int flex, bool isBottom = false}) {
    return Expanded(
      flex: flex,
      child: Container(
        decoration: BoxDecoration(
          border: isBottom
              ? null
              : const Border(
                  bottom: BorderSide(
                    color: Color(0xFFF1F5F9),
                    width: 0.8,
                  ),
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
