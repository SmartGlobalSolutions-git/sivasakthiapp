import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:siva_sakthi/services/device_location_service.dart';

class StatementEntry {
  final String slNo;
  final String date;
  final String type;
  final String dividend;
  final String debit;
  final String credit;
  final String balance;

  const StatementEntry({
    required this.slNo,
    required this.date,
    required this.type,
    required this.dividend,
    required this.debit,
    required this.credit,
    required this.balance,
  });
}

class StatementViewScreen extends StatefulWidget {
  final String? chitId;
  final DateTimeRange? dateRange;
  const StatementViewScreen ({super.key, this.chitId, this.dateRange});

  @override
  State<StatementViewScreen > createState() => _StatementViewScreenState();
}

class _StatementViewScreenState extends State<StatementViewScreen> {
  static const Color kBg = Color(0xFFF3F3F5);
  static const Color kGold = Color(0xFF3C93F4);
  static const Color kHeaderBlue = Color(0xFF193FBD);
  static const Color kHeaderDivider = Color(0xFF3C93F4);
  static const Color kValueText = Color(0xFF111827);
  static const Color kDivider = Color(0xFFE5E7EB);
  static const Color kStripe = Color(0x80E5E5E5); // #E5E5E5 @ 50%
  static const double _borderWidth = 0.84;

  static const List<String> _labels = [
    'BALANCE',
    'CREDIT',
    'DEBIT',
    'DIVIDEND',
    'TYPE',
    'DATE',
    'S.NO',
  ];
  static const List<double> _rowHeights = [85, 95, 95, 80, 85, 120, 58];

  static const List<FontWeight> _rowWeights = [
    FontWeight.w400,
    FontWeight.w400,
    FontWeight.w400,
    FontWeight.w400,
    FontWeight.w400,
    FontWeight.w400,
    FontWeight.w700,
  ];

  static const double _labelColWidth = 42.0;
  static const double _dataColWidth = 41.9;

  bool _loading = true;
  List<StatementEntry> _entries = [];

  @override
  void initState() {
    super.initState();
    _fetchStatement();
  }

  Future<void> _fetchStatement() async {
    try {
      final String deviceId = await DeviceLocationService.getDeviceId();
      final Map<String, String> loc = await DeviceLocationService.getLocation();
      final response = await http.post(
        Uri.parse('https://chitsoft.in/wapp/api/chit_api/'),
        body: {
          'cid': '35318938',
          'type': '6008',
          'lt': loc['lat'] ?? '123',
          'ln': loc['lng'] ?? '123',
          'device_id': deviceId.isNotEmpty ? deviceId : '123',
          'chit_id': widget.chitId ?? '1',
          'cus_id': '1',
        },
      );
      if (response.statusCode == 200) {
        debugPrint('STATEMENT VIEW API RESPONSE: ${response.body}');
        final data = json.decode(response.body);
        if (data['error'] == false && data['transactions'] != null) {
          final List<dynamic> txns = data['transactions'];
          final List<StatementEntry> loadedEntries = txns.map((item) {
            String dividend = item['dividend'] == 0 ? '-' : '₹${item['dividend']}';
            String debit = item['debit'] == 0 ? '-' : '₹${item['debit']}';
            String credit = item['credit'] == 0 ? '-' : '₹${item['credit']}';
            String balance = '₹${item['balance']}';
            
            String type = '';
            if (credit != '-' && debit == '-') {
              type = 'Credit';
            } else if (debit != '-' && credit == '-') {
              type = 'Debit';
            } else {
              type = 'Debit';
            }

            return StatementEntry(
              slNo: item['sno']?.toString() ?? '',
              date: item['date']?.toString() ?? '',
              type: type,
              dividend: dividend,
              debit: debit,
              credit: credit,
              balance: balance,
            );
          }).toList();
          
          if (mounted) {
            setState(() {
              _entries = loadedEntries;
              _loading = false;
            });
          }
        } else {
          if (mounted) setState(() => _loading = false);
        }
      } else {
        if (mounted) setState(() => _loading = false);
      }
    } catch (e) {
      if (mounted) setState(() => _loading = false);
    }
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
        'Statement',
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
                  : _entries.isEmpty 
                      ? const Center(child: Text("No statement found"))
                      : SingleChildScrollView(
                          padding: const EdgeInsets.all(16),
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
                    e.balance,
                    e.credit,
                    e.debit,
                    e.dividend,
                    e.type,
                    e.date,
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
                        Widget content;
                        if (rowIndex == 4) {
                          // TYPE badge
                          bool isCredit = cells[rowIndex] == 'Credit';
                          content = RotatedBox(
                            quarterTurns: 3,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: isCredit ? const Color(0xFFE6F4EA) : const Color(0xFFFCE8E8),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                cells[rowIndex],
                                style: GoogleFonts.inter(
                                  fontSize: 8.5,
                                  fontWeight: FontWeight.w600,
                                  color: isCredit ? const Color(0xFF12B76A) : const Color(0xFFF04438),
                                ),
                              ),
                            ),
                          );
                        } else {
                          Color textColor = kValueText;
                          if (rowIndex == 1 && cells[rowIndex] != '-') {
                            textColor = const Color(0xFF12B76A); // CREDIT
                          } else if (rowIndex == 2 && cells[rowIndex] != '-') {
                            textColor = const Color(0xFFF04438); // DEBIT
                          }

                          content = RotatedBox(
                            quarterTurns: 3,
                            child: Text(
                              cells[rowIndex],
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                fontSize: 10.06,
                                height: 13.41 / 10.06,
                                fontWeight: _rowWeights[rowIndex],
                                color: textColor,
                              ),
                            ),
                          );
                        }

                        return Container(
                          height: _rowHeights[rowIndex],
                          alignment: Alignment.center,
                          child: content,
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