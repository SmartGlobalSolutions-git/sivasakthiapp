import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:siva_sakthi/services/device_location_service.dart';

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
  static const Color kHeaderBlue = Color(0xFF3C93F4);
  static const Color kHeaderDivider = Color(0xFF3C93F4);
  static const Color kValueText = Color(0xFF111827);
  static const Color kDivider = Color(0xFFE5E7EB);
  static const Color kStripe = Color(0x80E5E5E5);
  static const double _borderWidth = 0.84;

  static const List<String> _labels = [
    'AMOUNT',
    'PAY TYPE',
    'RECEIPT DATE',
    'RECEIPT NO.',
    'S.NO',
  ];
  static const List<double> _rowHeights = [148, 140, 140, 140, 70];

  static const List<FontWeight> _rowWeights = [
    FontWeight.w700,
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
    try {
      final prefs = await SharedPreferences.getInstance();
      final String savedCusId = prefs.getString('cus_id') ?? '1';

      final String deviceId = await DeviceLocationService.getDeviceId();
      final Map<String, String> loc = await DeviceLocationService.getLocation();
      final response = await http.post(
        Uri.parse('https://chitsoft.in/wapp/api/chit_api/'),
        body: {
          'cid': '35318938',
          'type': '6005',
          'lt': loc['lat'] ?? '123',
          'ln': loc['lng'] ?? '123',
          'device_id': deviceId.isNotEmpty ? deviceId : '123',
          'chit_id': widget.chitId ?? '',
          'cus_id': savedCusId,
        },
      );
      if (response.statusCode == 200) {
        debugPrint('PASSBOOK VIEW API RESPONSE: ${response.body}');
        final data = json.decode(response.body);
        if (data['error'] == false && data['receipts'] != null) {
          final List<dynamic> receipts = data['receipts'];
          int slNo = 1;
          final List<PassbookEntry> loadedEntries = receipts.map((item) {
            final receiptNo = item['receipt_no']?.toString() ?? '';
            final receiptDate = item['receipt_date']?.toString() ?? '';
            final amount = item['amount']?.toString() ?? '0';
            final payType = item['p_type_label']?.toString() ?? '';
            
            return PassbookEntry(
              slNo: (slNo++).toString().padLeft(2, '0'),
              receiptNo: receiptNo,
              receiptDate: receiptDate,
              amount: '₹$amount.00',
              payType: payType,
            );
          }).toList();
          
          final totalAmtStr = data['total_amount']?.toString() ?? '0';

          if (mounted) {
            setState(() {
              _entries = loadedEntries;
              if (_entries.isNotEmpty) {
                 _entries.add(PassbookEntry(
                    slNo: '', 
                    receiptNo: '', 
                    receiptDate: '', 
                    amount: '₹$totalAmtStr.00', 
                    payType: 'Total'
                 ));
              }
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
                  : _entries.isEmpty 
                      ? const Center(child: Text("No receipts found"))
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
                    e.amount,
                    e.payType,
                    e.receiptDate,
                    e.receiptNo,
                    e.slNo,
                  ];

                  final isTotalCol = e.payType == 'Total';

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
                      children: () {
                        if (isTotalCol) {
                          return [
                            Container(
                              height: _rowHeights[0] + _rowHeights[1],
                              alignment: Alignment.center,
                              child: Container(
                                width: double.infinity,
                                height: double.infinity,
                                margin: const EdgeInsets.symmetric(vertical: 48.0, horizontal: 4.0),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(color: kGold, width: 1),
                                ),
                                alignment: Alignment.center,
                                child: RotatedBox(
                                  quarterTurns: 3,
                                  child: Text(
                                    'Total = ${e.amount}',
                                    maxLines: 1,
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.inter(
                                      fontSize: 13.5,
                                      height: 13.41 / 10.06,
                                      fontWeight: FontWeight.w700,
                                      color: kGold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(height: _rowHeights[2]),
                            Container(height: _rowHeights[3]),
                            Container(height: _rowHeights[4]),
                          ];
                        } else {
                          return List.generate(cells.length, (rowIndex) {
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
                          });
                        }
                      }(),
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