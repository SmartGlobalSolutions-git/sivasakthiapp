import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:siva_sakthi/chat_bot/chat.dart';
import 'package:siva_sakthi/statement/statement_view.dart';
import 'package:siva_sakthi/services/device_location_service.dart';

class StatementSearchScreen extends StatefulWidget {
  const StatementSearchScreen({super.key});

  @override
  State<StatementSearchScreen> createState() => _StatementSearchScreenState();
}

class _StatementSearchScreenState extends State<StatementSearchScreen> {
  final TextEditingController _chitIdController = TextEditingController();
  DateTimeRange? _selectedRange;
  List<dynamic> _chits = [];
  bool _isLoadingChits = true;
  String? _selectedChitId;

  static const Color kBg = Color(0xFFF3F3F5);
  static const Color kGold = Color(0xFF3C93F4);
  static const Color kGreen = Color(0xFF3C93F4);
  static const Color kLabelGrey = Color(0xFF4B5563);
  static const Color kPlaceholderGrey = Color(0xFF9CA3AF);
  static const Color kValueGrey = Color(0xFF374151);
  static const Color kFieldBorder = Color(0xFF878D97);

  @override
  void initState() {
    super.initState();
    _fetchChits();
  }

  Future<void> _fetchChits() async {
    try {
      final String deviceId = await DeviceLocationService.getDeviceId();
      final Map<String, String> loc = await DeviceLocationService.getLocation();
      final response = await http.post(
        Uri.parse('https://chitsoft.in/wapp/api/chit_api/'),
        body: {
          'cid': '35318938',
          'type': '6006',
          'lt': loc['lat'] ?? '123',
          'ln': loc['lng'] ?? '123',
          'device_id': deviceId.isNotEmpty ? deviceId : '123',
          'cus_id': '1',
        },
      );
      if (response.statusCode == 200) {
        debugPrint('STATEMENT API RESPONSE: ${response.body}');
        final data = json.decode(response.body);
        if (data['error'] == false && data['chits'] != null) {
          setState(() {
            _chits = data['chits'];
            _isLoadingChits = false;
          });
        } else {
          setState(() => _isLoadingChits = false);
        }
      } else {
        setState(() => _isLoadingChits = false);
      }
    } catch (e) {
      setState(() => _isLoadingChits = false);
    }
  }

  @override
  void dispose() {
    _chitIdController.dispose();
    super.dispose();
  }

  String _fmt(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

  Future<void> _pickDateRange() async {
    final DateTime? start = await showDatePicker(
      context: context,
      initialDate: _selectedRange?.start ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      helpText: 'Select Start Date',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: kGreen,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: kGreen),
            ),
          ),
          child: child!,
        );
      },
    );
    if (start == null) return;

    final DateTime? end = await showDatePicker(
      context: context,
      initialDate: _selectedRange?.end ?? start,
      firstDate: start,
      lastDate: DateTime(2100),
      helpText: 'Select End Date',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: kGreen,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: kGreen),
            ),
          ),
          child: child!,
        );
      },
    );
    if (end == null) return;

    setState(() {
      _selectedRange = DateTimeRange(start: start, end: end);
    });
  }

  void _onRefresh() {
    setState(() {
      _chitIdController.clear();
      _selectedChitId = null;
      _selectedRange = null;
    });
  }

  void _onSubmit() {
    // TODO: pass _chitIdController.text and _selectedRange to the passbook API
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StatementViewScreen(
          chitId: _chitIdController.text,
          dateRange: _selectedRange,
        ),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      appBar: _buildAppBar(),
      floatingActionButton: const Padding(
        padding: EdgeInsets.only(bottom: 40.0, right: 8.0),
        child: _FloatingRobotButton(),
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              _buildChitIdRow(),
              const SizedBox(height: 16),
              _buildDateRangeHeader(),
              const SizedBox(height: 8),
              _buildDateRangeField(),
              const SizedBox(height: 20),
              _buildSubmitButton(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChitIdRow() {
    return Row(
      children: [
        Flexible(
          child: Text(
            'Chit ID',
            style: GoogleFonts.manrope(
              fontSize: 16.09,
              fontWeight: FontWeight.w400,
              height: 25.03 / 16.09,
              color: kLabelGrey,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          ':',
          style: GoogleFonts.manrope(
            fontSize: 16.09,
            fontWeight: FontWeight.w400,
            color: kLabelGrey,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Container(
            height: 38,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: kFieldBorder, width: 1),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _isLoadingChits
                      ? const Center(
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        )
                      : PopupMenuButton<String>(
                          color: Colors.white,
                          position: PopupMenuPosition.under,
                          constraints: const BoxConstraints(maxHeight: 300),
                          onSelected: (val) {
                            setState(() {
                              _selectedChitId = val;
                              _chitIdController.text = val;
                            });
                          },
                          itemBuilder: (context) {
                            return _chits.map((chit) {
                              return PopupMenuItem<String>(
                                value: chit['chit_id'].toString(),
                                child: Text(
                                  '${chit['chit_id']}',
                                  style: GoogleFonts.manrope(
                                    fontSize: 14.3,
                                    fontWeight: FontWeight.w400,
                                    color: kValueGrey,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              );
                            }).toList();
                          },
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  _selectedChitId ?? 'Select Chit ID:',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.manrope(
                                    fontSize: _selectedChitId == null ? 12.0 : 14.3,
                                    fontWeight: FontWeight.w400,
                                    color: _selectedChitId == null ? kPlaceholderGrey : kValueGrey,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const Icon(Icons.arrow_drop_down, color: kLabelGrey),
                            ],
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateRangeHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            'Select Date Range',
            style: GoogleFonts.manrope(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              height: 24 / 16,
              color: kValueGrey,
            ),
          ),
        ),
        Flexible(
          child: GestureDetector(
            onTap: _onRefresh,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.refresh, size: 16, color: kLabelGrey),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    'Refresh',
                    style: GoogleFonts.manrope(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      height: 20 / 14,
                      color: kLabelGrey,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateRangeField() {
    final String label = _selectedRange == null
        ? 'Select a date range'
        : '${_fmt(_selectedRange!.start)} - ${_fmt(_selectedRange!.end)}';

    return GestureDetector(
      onTap: _pickDateRange,
      child: Container(
        width: double.infinity,
        height: 50,
        padding: const EdgeInsets.only(top: 12, right: 16, bottom: 12, left: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(9999),
          border: Border.all(color: kFieldBorder, width: 1),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.manrope(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  height: 24 / 16,
                  color: _selectedRange == null ? kPlaceholderGrey : kValueGrey,
                ),
              ),
            ),
            const Icon(Icons.calendar_today_outlined, size: 20, color: kLabelGrey),
          ],
        ),
      ),
    );
  }

  // Figma: Submit button 203 x 40, radius 39, centered
  Widget _buildSubmitButton() {
    return Center(
      child: GestureDetector(
        onTap: _onSubmit,
        child: Container(
          width: 203,
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: kGold,
            borderRadius: BorderRadius.circular(39),
          ),
          child: Text(
            'Submit',
            style: GoogleFonts.manrope(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class _FloatingRobotButton extends StatefulWidget {
  const _FloatingRobotButton();

  @override
  State<_FloatingRobotButton> createState() => _FloatingRobotButtonState();
}

class _FloatingRobotButtonState extends State<_FloatingRobotButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0, end: -10).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _animation.value),
          child: child,
        );
      },
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ChatbotScreen(),
            ),
          );
        },
        child: Image.asset(
          'assets/icons/chat_rob.png',
          width: 52,
          height: 52,
          fit: BoxFit.contain,
          errorBuilder: (_, _, _) => const Icon(
            Icons.smart_toy,
            size: 40,
            color: Color(0xFF3C93F4),
          ),
        ),
      ),
    );
  }
}