import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:siva_sakthi/calculator/subscription_plan_screen.dart';

enum CalculatorScheme { smartSavings, flexiCash, quickCash }

class CalculatorScreen_new extends StatefulWidget {
  const CalculatorScreen_new({super.key});

  @override
  State<CalculatorScreen_new> createState() => _CalculatorScreen_newState();
}

class _CalculatorScreen_newState extends State<CalculatorScreen_new> {
  CalculatorScheme _selectedScheme = CalculatorScheme.smartSavings;

  final TextEditingController _investmentController = TextEditingController();
  final TextEditingController _monthController = TextEditingController();
  final TextEditingController _emiController = TextEditingController();

  @override
  void dispose() {
    _investmentController.dispose();
    _monthController.dispose();
    _emiController.dispose();
    super.dispose();
  }

  void _calculateAndShowResult() {
    final invText = _investmentController.text.trim();
    final emiText = _emiController.text.trim();
    final monthText = _monthController.text.trim();

    if (invText.isEmpty && emiText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter Investment Amount or EMI Amount'),
          backgroundColor: Colors.black,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SubscriptionPlanScreen(
          investmentAmount: invText.isNotEmpty ? invText : emiText,
          durationMonths: monthText.isNotEmpty ? monthText : '20',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xFF000000),
            size: 22,
          ),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
        ),
        titleSpacing: 0,
        title: const Text(
          'Let\'s Plan Your Growth',
          style: TextStyle(
            color: Color(0xFF000000),
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Blue section with straight top and torn bottom paper edge
            ClipRect(
              child: Stack(
                clipBehavior: Clip.hardEdge,
                children: [
                  Positioned.fill(
                    child: Container(color: const Color(0xff266FAF)),
                  ),

                  // Foreground Content (Radios + White Card)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // --- TOP SCHEMES RADIO SELECTION ---
                        // Row 1: Smart Savings Scheme & Flexi Cash
                        Row(
                          children: [
                            Expanded(
                              flex: 13,
                              child: _buildRadioOption(
                                label: 'Smart Savings Scheme',
                                scheme: CalculatorScheme.smartSavings,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              flex: 9,
                              child: _buildRadioOption(
                                label: 'Flexi Cash',
                                scheme: CalculatorScheme.flexiCash,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        // Row 2: Quick Cash
                        _buildRadioOption(
                          label: 'Quick Cash',
                          scheme: CalculatorScheme.quickCash,
                        ),

                        const SizedBox(height: 18),

                        // --- MAIN WHITE CARD ---
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.08),
                                blurRadius: 18,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16, 18, 16, 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Row 1: Investment ₹ (Left) & Month (Right)
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Investment ₹',
                                            style: GoogleFonts.inriaSans(
                                              color: const Color(0xff266FAF),
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          _buildInputField(
                                            controller: _investmentController,
                                            hintText: 'ex: 1,00,000',
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 14),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Month',
                                            style: GoogleFonts.inriaSans(
                                              color: const Color(0xff266FAF),
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          _buildInputField(
                                            controller: _monthController,
                                            hintText: 'ex: 12',
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 18),

                                // Row 2: Emi ₹ (Left half)
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Emi ₹',
                                            style: GoogleFonts.inriaSans(
                                              color: const Color(0xff266FAF),
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          _buildInputField(
                                            controller: _emiController,
                                            hintText: 'ex: 1,00,000',
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 14),
                                    const Expanded(
                                      child: SizedBox.shrink(),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 24),

                                // Bottom Row: Note & Submit Button
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    // Left: Note
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Note:',
                                            style: GoogleFonts.inriaSans(
                                              color: const Color(0xFF757575),
                                              fontSize: 10.5,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            'Enter Values In Multiples Of Lakhs\nIn Investment',
                                            style: GoogleFonts.inriaSans(
                                              color: const Color(0xFF757575),
                                              fontSize: 9.5,
                                              fontWeight: FontWeight.w400,
                                              height: 1.2,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    // Right: Submit Button
                                    ElevatedButton(
                                      onPressed: _calculateAndShowResult,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFF3C93F4),
                                        elevation: 0,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 36,
                                          vertical: 13,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(24),
                                        ),
                                      ),
                                      child: Text(
                                        'Submit',
                                        style: GoogleFonts.inter(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Clean white area below the torn edge (matches second image)
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildRadioOption({
    required String label,
    required CalculatorScheme scheme,
  }) {
    final isSelected = _selectedScheme == scheme;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedScheme = scheme;
        });
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? Colors.white : Colors.white70,
                width: 2,
              ),
            ),
            alignment: Alignment.center,
            child: isSelected
                ? Container(
              width: 10,
              height: 10,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            )
                : null,
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              label,
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hintText,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        style: GoogleFonts.inriaSans(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: const Color(0xFF1D2939),
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: GoogleFonts.inriaSans(
            color: const Color(0xFF98A2B3),
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Color(0xFFE2E8F0),
              width: 1.2,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Color(0xFF3C93F4),
              width: 1.5,
            ),
          ),
        ),
      ),
    );
  }
}
