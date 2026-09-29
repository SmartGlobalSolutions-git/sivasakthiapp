import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

void showChitEnquiryDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: true,
    barrierColor: Colors.black.withValues(alpha: 0.55),
    builder: (BuildContext dialogContext) => const ChitEnquiryDialog(),
  );
}

class ChitEnquiryDialog extends StatefulWidget {
  const ChitEnquiryDialog({super.key});

  @override
  State<ChitEnquiryDialog> createState() => _ChitEnquiryDialogState();
}

class _ChitEnquiryDialogState extends State<ChitEnquiryDialog> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  String? _nameError;
  String? _mobileError;
  String? _emailError;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(() {
      if (_nameError != null) setState(() => _nameError = null);
    });
    _mobileController.addListener(() {
      if (_mobileError != null) setState(() => _mobileError = null);
    });
    _emailController.addListener(() {
      if (_emailError != null) setState(() => _emailError = null);
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    final name = _nameController.text.trim();
    final mobile = _mobileController.text.trim();
    final email = _emailController.text.trim();

    String? nameError;
    String? mobileError;
    String? emailError;

    // 1. Name Validation
    if (name.isEmpty) {
      nameError = 'Please enter your name';
    } else if (name.length < 2) {
      nameError = 'Name must be at least 2 characters';
    } else if (!RegExp(r"^[a-zA-Z\s.']+$").hasMatch(name)) {
      nameError = 'Please enter a valid name (letters only)';
    }

    // 2. Mobile Number Validation
    if (mobile.isEmpty) {
      mobileError = 'Please enter your mobile number';
    } else if (mobile.length != 10 || !RegExp(r'^[6-9]\d{9}$').hasMatch(mobile)) {
      mobileError = 'Please enter a valid 10-digit mobile number';
    }

    // 3. Mail ID Validation (Optional - validate only if provided)
    if (email.isNotEmpty &&
        !RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(email)) {
      emailError = 'Please enter a valid email address';
    }

    if (nameError != null || mobileError != null || emailError != null) {
      setState(() {
        _nameError = nameError;
        _mobileError = mobileError;
        _emailError = emailError;
      });
      return;
    }

    // Clear errors if all valid
    setState(() {
      _nameError = null;
      _mobileError = null;
      _emailError = null;
    });

    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Enquiry submitted successfully! Our team will contact you.',
                style: GoogleFonts.poppins(fontSize: 13, color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF0E8746),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    final double screenWidth = mediaQuery.size.width;
    final double screenHeight = mediaQuery.size.height;
    final double scaleW = (screenWidth / 360.0).clamp(0.85, 1.25);
    final double scaleH = (screenHeight / 800.0).clamp(0.85, 1.25);

    // Dynamic horizontal padding to give dialog more width on mobile screens
    final double horizontalPadding = screenWidth > 500
        ? ((screenWidth - 420.0) / 2.0).clamp(16.0, 60.0)
        : 14.0;

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: (16.0 * scaleH).clamp(10.0, 20.0),
      ),
      child: Center(
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            constraints: BoxConstraints(
              maxWidth: (screenWidth * 0.94).clamp(360.0, 420.0),
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16 * scaleW),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 20,
                  spreadRadius: 2,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            padding: EdgeInsets.symmetric(
              horizontal: (22 * scaleW).clamp(18.0, 26.0),
              vertical: (16 * scaleH).clamp(12.0, 20.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Top Sivasakthi 3D Logo
                Center(
                  child: Image.asset(
                    'assets/images/sivasakthi.png',
                    height: (62 * scaleH).clamp(52.0, 70.0),
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.pie_chart, size: 44 * scaleW, color: const Color(0xFF3C93F4)),
                        Text(
                          'Sivasakthi',
                          style: GoogleFonts.poppins(
                            fontSize: (11 * scaleW).clamp(9.5, 13.0),
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1E2638),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 4 * scaleH),

                // SIVA SARAVANA text (Figma: width: 149, height: 22, Inter 600, 18.48px, line-height: 100%, color: #3C93F4)
                Center(
                  child: SizedBox(
                    width: 149 * scaleW,
                    height: 22 * scaleH,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.center,
                      child: Text(
                        'SIVA SARAVANA',
                        maxLines: 1,
                        softWrap: false,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 18.48,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF3C93F4),
                          height: 1.0,
                          letterSpacing: 0,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 3 * scaleH),

                // Chit Enquiry text (Figma: width: 151, height: 36, Poppins 700, 24px, line-height: 100%, color: #000000)
                Center(
                  child: SizedBox(
                    width: 151 * scaleW,
                    height: 36 * scaleH,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.center,
                      child: Text(
                        'Chit Enquiry',
                        maxLines: 1,
                        softWrap: false,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF000000),
                          height: 1.0,
                          letterSpacing: 0,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 3 * scaleH),

                // Find the right plan for you text (Figma: width: 192, height: 23, Poppins 400, 15px, line-height: 100%, color: #818181)
                Center(
                  child: SizedBox(
                    width: 192 * scaleW,
                    height: 23 * scaleH,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.center,
                      child: Text(
                        'Find the right plan for you',
                        maxLines: 1,
                        softWrap: false,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF818181),
                          height: 1.0,
                          letterSpacing: 0,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 12 * scaleH),

                // 1. Name Field
                _buildFieldLabel('Name', scaleW),
                _buildInputField(
                  controller: _nameController,
                  hintText: 'Enter your Name',
                  keyboardType: TextInputType.name,
                  textCapitalization: TextCapitalization.words,
                  errorText: _nameError,
                  scaleW: scaleW,
                  scaleH: scaleH,
                ),
                SizedBox(height: 8 * scaleH),

                // 2. Mobile Number Field
                _buildFieldLabel('Mobile Number', scaleW),
                _buildInputField(
                  controller: _mobileController,
                  hintText: 'Enter mobile number',
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                  errorText: _mobileError,
                  scaleW: scaleW,
                  scaleH: scaleH,
                ),
                SizedBox(height: 8 * scaleH),

                // 3. Mail ID (Optional) Field
                _buildFieldLabel('Mail ID (Optional)', scaleW),
                _buildInputField(
                  controller: _emailController,
                  hintText: 'Enter mail ID',
                  keyboardType: TextInputType.emailAddress,
                  errorText: _emailError,
                  scaleW: scaleW,
                  scaleH: scaleH,
                ),
                SizedBox(height: 8 * scaleH),

                // 4. Message Field (Increased size as requested)
                _buildFieldLabel('Message', scaleW),
                _buildMessageField(
                  controller: _messageController,
                  hintText: 'Tell us your requirement',
                  scaleW: scaleW,
                  scaleH: scaleH,
                ),
                SizedBox(height: 14 * scaleH),

                // Submit Enquiry Button
                SizedBox(
                  width: double.infinity,
                  height: (44 * scaleH).clamp(40.0, 48.0),
                  child: ElevatedButton(
                    onPressed: _handleSubmit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0E8746),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6 * scaleW),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Submit Enquiry →',
                          style: GoogleFonts.poppins(
                            fontSize: (15 * scaleW).clamp(13.0, 17.0),
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            height: 1.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 8 * scaleH),

                // Bottom Disclaimer Note (Strictly single line)
                Center(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'By submitting, you agree to be contacted by our team',
                      maxLines: 1,
                      softWrap: false,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: (10.5 * scaleW).clamp(9.0, 12.0),
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF667085),
                        height: 1.2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String label, double scaleW) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: (14 * scaleW).clamp(12.0, 16.0),
          fontWeight: FontWeight.w600,
          color: const Color(0xFF101828),
          height: 1.2,
          letterSpacing: 0,
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
    TextCapitalization textCapitalization = TextCapitalization.none,
    List<TextInputFormatter>? inputFormatters,
    String? errorText,
    required double scaleW,
    required double scaleH,
  }) {
    final bool hasError = errorText != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: (42 * scaleH).clamp(38.0, 48.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6 * scaleW),
            border: Border.all(
              color: hasError ? const Color(0xFFD92D20) : const Color(0xFFD0D5DD),
              width: hasError ? 1.2 : 1.0,
            ),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            textCapitalization: textCapitalization,
            inputFormatters: inputFormatters,
            style: GoogleFonts.poppins(
              fontSize: (13.5 * scaleW).clamp(11.5, 15.0),
              fontWeight: FontWeight.w400,
              color: const Color(0xFF101828),
            ),
            cursorColor: const Color(0xFF2E90FA),
            decoration: InputDecoration(
              isDense: true,
              hintText: hintText,
              hintStyle: GoogleFonts.poppins(
                fontSize: (13.5 * scaleW).clamp(11.5, 15.0),
                fontWeight: FontWeight.w400,
                color: const Color(0xFF98A2B3),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 14 * scaleW, vertical: 12 * scaleH),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
            ),
          ),
        ),
        if (hasError)
          Padding(
            padding: const EdgeInsets.only(top: 4.0, left: 2.0),
            child: Text(
              errorText,
              style: GoogleFonts.poppins(
                fontSize: (11 * scaleW).clamp(9.5, 12.5),
                fontWeight: FontWeight.w500,
                color: const Color(0xFFD92D20),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildMessageField({
    required TextEditingController controller,
    required String hintText,
    required double scaleW,
    required double scaleH,
  }) {
    return Container(
      height: (110 * scaleH).clamp(90.0, 130.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6 * scaleW),
        border: Border.all(
          color: const Color(0xFFD0D5DD),
          width: 1.0,
        ),
      ),
      child: TextField(
        controller: controller,
        maxLines: 5,
        style: GoogleFonts.poppins(
          fontSize: (13.5 * scaleW).clamp(11.5, 15.0),
          fontWeight: FontWeight.w400,
          color: const Color(0xFF101828),
        ),
        cursorColor: const Color(0xFF2E90FA),
        decoration: InputDecoration(
          isDense: true,
          hintText: hintText,
          hintStyle: GoogleFonts.poppins(
            fontSize: (13.5 * scaleW).clamp(11.5, 15.0),
            fontWeight: FontWeight.w400,
            color: const Color(0xFF98A2B3),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 14 * scaleW, vertical: 12 * scaleH),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
      ),
    );
  }
}
