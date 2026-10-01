import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'subscription_plan_screen.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _selectedScheme = 'Smart Savings Scheme';
  final TextEditingController _investmentController = TextEditingController();
  final TextEditingController _emiController = TextEditingController();
  String? _selectedNoOfEmis;
  String? _selectedNoOfChitMembers;

  final List<String> _emiOptions = ['10', '12', '15', '20', '25', '30', '40', '50'];
  final List<String> _chitMemberOptions = ['10', '12', '15', '20', '25', '30', '40', '50'];

  @override
  void dispose() {
    _investmentController.dispose();
    _emiController.dispose();
    super.dispose();
  }

  void _navigateToSubscriptionPlan() {
    final investmentText = _investmentController.text.trim();
    final emiText = _emiController.text.trim();

    if (investmentText.isEmpty && emiText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter Investment Amount or EMI Amount'),
          backgroundColor: Color(0xFFE11D48),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (_selectedNoOfEmis == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select No Of EMI's"),
          backgroundColor: Color(0xFFE11D48),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (_selectedNoOfChitMembers == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select No Of Chit Members'),
          backgroundColor: Color(0xFFE11D48),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final amountToPass = investmentText.isNotEmpty ? investmentText : emiText;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SubscriptionPlanScreen(
          investmentAmount: amountToPass,
          durationMonths: _selectedNoOfEmis!,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    final Size screenSize = mediaQuery.size;
    final double screenWidth = screenSize.width;
    final double screenHeight = screenSize.height;
    final double scaleW = (screenWidth / 360.0).clamp(0.85, 1.25);
    final double scaleH = (screenHeight / 800.0).clamp(0.85, 1.25);
    const primaryBlue = Color(0xFF3C93F4);

    final double topPadding = mediaQuery.padding.top;
    final double bottomPadding = mediaQuery.padding.bottom;
    final double statusBarH = topPadding > 20 ? topPadding : 24.0;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Color(0xFF0D1519),
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: Color(0xFF0D1519),
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(56.0 * scaleH + statusBarH),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTopStatusBar(context, statusBarH),
              Container(
                width: screenWidth,
                height: 56.0 * scaleH,
                color: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 16 * scaleW),
                child: Row(
                  children: [
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        if (Navigator.canPop(context)) {
                          Navigator.pop(context);
                        }
                      },
                      child: Padding(
                        padding: EdgeInsets.only(right: 12 * scaleW),
                        child: Icon(
                          Icons.arrow_back,
                          color: const Color(0xFF1E2638),
                          size: (22 * scaleW).clamp(18.0, 24.0),
                        ),
                      ),
                    ),
                    Text(
                      'Calculator',
                      style: GoogleFonts.inter(
                        fontSize: (16 * scaleW).clamp(14.0, 18.0),
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF1E2638),
                        height: 1.0,
                        letterSpacing: 0,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Blue Section (with exact torn bottom edge from assets/images/bgblue.png)
            Stack(
              clipBehavior: Clip.none,
              children: [
                // Solid blue underlay to guarantee solid coverage
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: 480 * scaleH,
                  child: Container(color: primaryBlue),
                ),

                // Blue Torn Paper Background Asset (Width: 392, Left: -19 in Figma)
                Positioned(
                  left: -19 * scaleW,
                  top: -24 * scaleH,
                  width: 398 * scaleW,
                  bottom: 0,
                  child: Image.asset(
                    'assets/calculator/bgblue.png',
                    fit: BoxFit.fill,
                    alignment: Alignment.topCenter,
                    errorBuilder: (context, error, stackTrace) =>
                        Container(color: primaryBlue),
                  ),
                ),

                // Blue Header Cap to ensure seamless edge with white bar
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: 10 * scaleH,
                  child: Container(color: primaryBlue),
                ),

                // Content inside the Blue Section (Figma gap to radio button: 38px)
                Padding(
                  padding: EdgeInsets.only(
                    left: 16 * scaleW.clamp(0.85, 1.2),
                    right: 16 * scaleW.clamp(0.85, 1.2),
                    top: 18 * scaleH.clamp(0.85, 1.2),
                    bottom: 60 * scaleH.clamp(0.85, 1.2), // Room for torn bottom edge
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Radio Row 1: Smart Savings Scheme & Flexi Cash
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 17 * scaleW),
                        child: Row(
                          children: [
                            _buildRadioButton('Smart Savings Scheme', scaleW),
                            const Spacer(),
                            _buildRadioButton('Flexi Cash', scaleW),
                            SizedBox(width: 8 * scaleW),
                          ],
                        ),
                      ),
                      SizedBox(height: 10 * scaleH.clamp(0.85, 1.2)),

                      // Radio Row 2: Quick Cash
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 17 * scaleW),
                        child: _buildRadioButton('Quick Cash', scaleW),
                      ),
                      SizedBox(height: 18 * scaleH.clamp(0.85, 1.2)),

                      // White Box (Width: 328, Border Radius: 20px, Shadow, Matching Figma)
                      Center(
                        child: Container(
                          width: 328 * scaleW.clamp(0.85, 1.2),
                          padding: EdgeInsets.symmetric(
                            horizontal: 19 * scaleW.clamp(0.85, 1.2),
                            vertical: 18 * scaleH.clamp(0.85, 1.2),
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.08),
                                blurRadius: 16,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Stack(
                            children: [
                              // Background Plant Watermark (width: 126, height: 206, border-radius: 83.97px)
                              Positioned(
                                right: -8,
                                bottom: 10,
                                child: Opacity(
                                  opacity: 0.22,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(83.97),
                                    child: Image.asset(
                                      'assets/calculator/plant.png',
                                      width: 126 * scaleW.clamp(0.85, 1.2),
                                      height: 206 * scaleH.clamp(0.85, 1.2),
                                      fit: BoxFit.contain,
                                      errorBuilder: (context, error, stackTrace) =>
                                          const SizedBox.shrink(),
                                    ),
                                  ),
                                ),
                              ),

                              // Form Elements inside the White Box
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // 1. Investment Amount ₹ (font-family: Inria Sans; font-size: 14px; font-weight: 400; color: #3C93F4)
                                  Text(
                                    'Investment Amount ₹',
                                    style: GoogleFonts.inriaSans(
                                      fontSize: 14 * scaleW.clamp(0.85, 1.2),
                                      fontWeight: FontWeight.w400,
                                      fontStyle: FontStyle.normal,
                                      height: 1.0,
                                      letterSpacing: 0,
                                      color: primaryBlue,
                                    ),
                                  ),
                                  SizedBox(height: 5 * scaleH.clamp(0.85, 1.2)),

                                  // Input Field: width: 290, height: 40, border-radius: 8px, border-width: 1px
                                  _buildTextField(
                                    controller: _investmentController,
                                    hintText: '1,00,000',
                                    keyboardType: TextInputType.number,
                                    scaleW: scaleW,
                                    scaleH: scaleH,
                                  ),
                                  SizedBox(height: 4 * scaleH.clamp(0.85, 1.2)),

                                  // Helper: Enter values in multiples of Lakhs (min-1 Lakh to max-1 Crore)
                                  Text(
                                    'Enter values in multiples of Lakhs (min-1 Lakh to max-1 Crore)',
                                    style: GoogleFonts.inriaSans(
                                      fontSize: 10 * scaleW.clamp(0.85, 1.2),
                                      fontWeight: FontWeight.w400,
                                      fontStyle: FontStyle.normal,
                                      height: 1.0,
                                      letterSpacing: 0,
                                      color: const Color(0xFF000000),
                                    ),
                                  ),
                                  SizedBox(height: 6 * scaleH.clamp(0.85, 1.2)),

                                  // Centered "or"
                                  Center(
                                    child: Text(
                                      'or',
                                      style: GoogleFonts.inriaSans(
                                        fontSize: 12 * scaleW.clamp(0.85, 1.2),
                                        fontWeight: FontWeight.w400,
                                        fontStyle: FontStyle.normal,
                                        height: 1.0,
                                        letterSpacing: 0,
                                        color: const Color(0xFF333333),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 4 * scaleH.clamp(0.85, 1.2)),

                                  // 2. EMI Amount ₹ (font-family: Inria Sans; font-size: 14px; font-weight: 400; color: #3C93F4)
                                  Text(
                                    'EMI Amount ₹',
                                    style: GoogleFonts.inriaSans(
                                      fontSize: 14 * scaleW.clamp(0.85, 1.2),
                                      fontWeight: FontWeight.w400,
                                      fontStyle: FontStyle.normal,
                                      height: 1.0,
                                      letterSpacing: 0,
                                      color: primaryBlue,
                                    ),
                                  ),
                                  SizedBox(height: 5 * scaleH.clamp(0.85, 1.2)),

                                  // Input Field: width: 290, height: 40, border-radius: 8px, border-width: 1px
                                  _buildTextField(
                                    controller: _emiController,
                                    hintText: '1,00,000',
                                    keyboardType: TextInputType.number,
                                    scaleW: scaleW,
                                    scaleH: scaleH,
                                  ),
                                  SizedBox(height: 4 * scaleH.clamp(0.85, 1.2)),

                                  // Helper: Enter values in multiples of 5000 (min-5000 to max-5Lakhs)
                                  Text(
                                    'Enter values in multiples of 5000 (min-5000 to max-5Lakhs)',
                                    style: GoogleFonts.inriaSans(
                                      fontSize: 10 * scaleW.clamp(0.85, 1.2),
                                      fontWeight: FontWeight.w400,
                                      fontStyle: FontStyle.normal,
                                      height: 1.0,
                                      letterSpacing: 0,
                                      color: const Color(0xFF000000),
                                    ),
                                  ),
                                  SizedBox(height: 14 * scaleH.clamp(0.85, 1.2)),

                                  // 3. Dropdowns Row: No Of EMI's & No Of Chit Members (each width: 138, height: 40)
                                  Row(
                                    children: [
                                      // No Of EMI's
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "No Of EMI's",
                                              maxLines: 1,
                                              style: GoogleFonts.inriaSans(
                                                fontSize: 12.5 * scaleW.clamp(0.85, 1.05),
                                                fontWeight: FontWeight.w400,
                                                fontStyle: FontStyle.normal,
                                                height: 1.0,
                                                letterSpacing: 0,
                                                color: primaryBlue,
                                              ),
                                            ),
                                            SizedBox(height: 5 * scaleH.clamp(0.85, 1.2)),
                                            _buildDropdownField(
                                              value: _selectedNoOfEmis,
                                              hintText: '20',
                                              items: _emiOptions,
                                              onChanged: (val) {
                                                if (val != null) {
                                                  setState(() {
                                                    _selectedNoOfEmis = val;
                                                  });
                                                }
                                              },
                                              scaleW: scaleW,
                                              scaleH: scaleH,
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 14 * scaleW.clamp(0.85, 1.2)),

                                      // No Of Chit Members
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'No Of Chit Members',
                                              maxLines: 1,
                                              softWrap: false,
                                              overflow: TextOverflow.visible,
                                              style: GoogleFonts.inriaSans(
                                                fontSize: 12.5 * scaleW.clamp(0.85, 1.05),
                                                fontWeight: FontWeight.w400,
                                                fontStyle: FontStyle.normal,
                                                height: 1.0,
                                                letterSpacing: 0,
                                                color: primaryBlue,
                                              ),
                                            ),
                                            SizedBox(height: 5 * scaleH.clamp(0.85, 1.2)),
                                            _buildDropdownField(
                                              value: _selectedNoOfChitMembers,
                                              hintText: '20',
                                              items: _chitMemberOptions,
                                              onChanged: (val) {
                                                if (val != null) {
                                                  setState(() {
                                                    _selectedNoOfChitMembers = val;
                                                  });
                                                }
                                              },
                                              scaleW: scaleW,
                                              scaleH: scaleH,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 16 * scaleH.clamp(0.85, 1.2)),

                                  // 4. Bottom Note & Submit Button (width: 130, height: 40, border-radius: 20px)
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      // Note text
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              'Note:',
                                              style: GoogleFonts.inriaSans(
                                                fontSize: 10.5 * scaleW.clamp(0.85, 1.2),
                                                fontWeight: FontWeight.w600,
                                                color: const Color(0xFF757575),
                                              ),
                                            ),
                                            Text(
                                              'Enter Values In Multiples Of\nLakhs In Investment',
                                              style: GoogleFonts.inriaSans(
                                                fontSize: 9.5 * scaleW.clamp(0.85, 1.2),
                                                fontWeight: FontWeight.w400,
                                                fontStyle: FontStyle.normal,
                                                color: const Color(0xFF757575),
                                                height: 1.2,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 8 * scaleW.clamp(0.85, 1.2)),

                                      // Submit Button (width: 130, height: 40, border-radius: 20px, background: #3C93F4)
                                      SizedBox(
                                        width: 130 * scaleW.clamp(0.9, 1.2),
                                        height: 40 * scaleH.clamp(0.85, 1.2),
                                        child: ElevatedButton(
                                          onPressed: _navigateToSubscriptionPlan,
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: primaryBlue,
                                            elevation: 0,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(20),
                                            ),
                                            padding: EdgeInsets.zero,
                                          ),
                                          child: Text(
                                            'Submit',
                                            style: GoogleFonts.inter(
                                              fontSize: 14 * scaleW.clamp(0.85, 1.2),
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Bottom Spacing (clean white below torn edge)
            SizedBox(height: bottomPadding > 0 ? bottomPadding + 30 * scaleH : 60 * scaleH),
          ],
        ),
      ),
    ),
  );
}

  // Radio button widget (Inter font, 14px regular, white)
  Widget _buildRadioButton(String title, double scaleW) {
    final bool isSelected = _selectedScheme == title;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        setState(() {
          _selectedScheme = title;
        });
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 14 * scaleW.clamp(0.85, 1.2),
            height: 14 * scaleW.clamp(0.85, 1.2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? Colors.transparent : const Color(0x66E2E2E2),
              border: isSelected
                  ? Border.all(
                      color: Colors.white,
                      width: 2.0 * scaleW.clamp(0.85, 1.2),
                    )
                  : null,
            ),
          ),
          SizedBox(width: 6 * scaleW.clamp(0.85, 1.1)),
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 14 * scaleW.clamp(0.85, 1.1),
              fontWeight: FontWeight.w400,
              fontStyle: FontStyle.normal,
              height: 1.0,
              letterSpacing: 0,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  // Input Field: width: 290, height: 40, border-radius: 8px, border-width: 1px
  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
    required double scaleW,
    required double scaleH,
  }) {
    return Container(
      width: 290 * scaleW.clamp(0.85, 1.2),
      height: 40 * scaleH.clamp(0.85, 1.2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFFD0D5DD),
          width: 1.0,
        ),
      ),
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(horizontal: 12 * scaleW.clamp(0.85, 1.2)),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: GoogleFonts.inriaSans(
          fontSize: 14 * scaleW.clamp(0.85, 1.2),
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.normal,
          height: 1.0,
          letterSpacing: 0,
          color: const Color(0xFF1D2939),
        ),
        decoration: InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.zero,
          hintText: hintText,
          hintStyle: GoogleFonts.inriaSans(
            fontSize: 14 * scaleW.clamp(0.85, 1.2),
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.normal,
            height: 1.0,
            letterSpacing: 0,
            color: const Color(0xFF98A2B3),
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }

  // Dropdown Box: width: 138, height: 40, border-radius: 8px, border-width: 1px
  Widget _buildDropdownField({
    required String? value,
    required String hintText,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    required double scaleW,
    required double scaleH,
  }) {
    return Container(
      width: 138 * scaleW.clamp(0.85, 1.2),
      height: 40 * scaleH.clamp(0.85, 1.2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFFD0D5DD),
          width: 1.0,
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 10 * scaleW.clamp(0.85, 1.2)),
      alignment: Alignment.center,
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Text(
            hintText,
            style: GoogleFonts.inriaSans(
              fontSize: 14 * scaleW.clamp(0.85, 1.2),
              fontWeight: FontWeight.w400,
              fontStyle: FontStyle.normal,
              height: 1.0,
              letterSpacing: 0,
              color: const Color(0xFF98A2B3),
            ),
          ),
          isExpanded: true,
          icon: const Icon(
            Icons.keyboard_arrow_down,
            color: Color(0xFF667085),
            size: 20,
          ),
          style: GoogleFonts.inriaSans(
            fontSize: 14 * scaleW.clamp(0.85, 1.2),
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.normal,
            height: 1.0,
            letterSpacing: 0,
            color: const Color(0xFF1D2939),
          ),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  // Top Status Bar widget matching user screenshot (11:11 AM, icons, 5G, signal, battery 50%)
  Widget _buildTopStatusBar(BuildContext context, double statusBarH) {
    final Size screenSize = MediaQuery.of(context).size;
    final double scaleW = screenSize.width / 360.0;

    return Container(
      width: screenSize.width,
      height: statusBarH,
      color: const Color(0xFF0D1519),
      padding: EdgeInsets.symmetric(horizontal: 14 * scaleW.clamp(0.85, 1.2)),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left side: 11:11 AM, Camera, Chat bubble icons
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '11:11 AM',
                style: GoogleFonts.inter(
                  fontSize: 11.5 * scaleW.clamp(0.85, 1.2),
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  height: 1.0,
                ),
              ),
              SizedBox(width: 6 * scaleW.clamp(0.85, 1.2)),
              Icon(
                Icons.camera_alt_outlined,
                size: 13 * scaleW.clamp(0.85, 1.2),
                color: Colors.white.withValues(alpha: 0.9),
              ),
              SizedBox(width: 5 * scaleW.clamp(0.85, 1.2)),
              Icon(
                Icons.chat_bubble_outline_rounded,
                size: 12.5 * scaleW.clamp(0.85, 1.2),
                color: Colors.white.withValues(alpha: 0.9),
              ),
            ],
          ),

          // Right side: 5G, cellular signal, battery with 50%
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '5G',
                style: GoogleFonts.inter(
                  fontSize: 10.5 * scaleW.clamp(0.85, 1.2),
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  height: 1.0,
                ),
              ),
              SizedBox(width: 4 * scaleW.clamp(0.85, 1.2)),
              Icon(
                Icons.signal_cellular_alt,
                size: 13.5 * scaleW.clamp(0.85, 1.2),
                color: Colors.white,
              ),
              SizedBox(width: 5 * scaleW.clamp(0.85, 1.2)),
              // Battery icon
              Container(
                width: 19 * scaleW.clamp(0.85, 1.2),
                height: 9.5 * scaleW.clamp(0.85, 1.2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2.5),
                  border: Border.all(color: Colors.white, width: 1.1),
                ),
                padding: const EdgeInsets.all(1.2),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    width: 8 * scaleW.clamp(0.85, 1.2),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(1),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 4 * scaleW.clamp(0.85, 1.2)),
              Text(
                '50%',
                style: GoogleFonts.inter(
                  fontSize: 10.5 * scaleW.clamp(0.85, 1.2),
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  height: 1.0,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

