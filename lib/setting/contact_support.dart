import 'package:flutter/material.dart';

// ---- Figma tokens (Contact Us) ----
class _Colors {
  static const Color pageBg = Color(0xFFF2F3F5);
  static const Color white = Color(0xFFFFFFFF);
  static const Color textBlack = Color(0xFF000000);
  static const Color iconGreen = Color(0xFF058334); // phone vector, #058334
  static const Color iconBorder = Color(0xFFE0E0E0);
  static const Color chevron = Color(0xFF9E9E9E);
  static const Color cardBorder = Color(0x1A000000); // #000000 @ 10%, 0.5px
  static const Color cardShadow = Color(0x40000000); // #000000 @ 25%, y2 blur4
  static const Color divider = Color(0x63000000); // #000000 @ 39%, 0.2px
}

class _TextStyles {
  static const TextStyle headerTitle = TextStyle(
    fontFamily: 'Inter',
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: _Colors.textBlack,
  );

  // Add Poppins to pubspec.yaml fonts (or swap for your app font)
  static const TextStyle rowTitle = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: _Colors.textBlack,
  );
}

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _Colors.pageBg,
      appBar: const _Header(title: 'Contact Us'),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
        child: Align(
          alignment: Alignment.topCenter,
          child: Container(
            width: 328,
            height: 124,
            decoration: BoxDecoration(
              color: _Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _Colors.cardBorder, width: 0.5),
              boxShadow: const [
                BoxShadow(
                  color: _Colors.cardShadow,
                  offset: Offset(0, 2),
                  blurRadius: 4,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Material(
                color: _Colors.white,
                child: Column(
                  children: [
                    _ContactRow(
                      title: 'General Enquiry',
                      onTap: () {
                        // TODO: General Enquiry action (dial / open)
                      },
                    ),
                    Container(height: 0.2, color: _Colors.divider),
                    _ContactRow(
                      title: 'Agent Call',
                      onTap: () {
                        // TODO: Agent Call action (dial / open)
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ContactRow extends StatelessWidget {
  const _ContactRow({required this.title, required this.onTap});

  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            children: [
              Container(
                width: 34,
                height: 34,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: _Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: _Colors.iconBorder),
                ),
                // Swap for your exported SVG/PNG if you have the Figma vector
                child: const Icon(
                  Icons.phone_in_talk,
                  size: 18,
                  color: _Colors.iconGreen,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(child: Text(title, style: _TextStyles.rowTitle)),
              const Icon(Icons.chevron_right, size: 24, color: _Colors.chevron),
            ],
          ),
        ),
      ),
    );
  }
}

// 57px header, white bg, back arrow + title — sits below the status bar
class _Header extends StatelessWidget implements PreferredSizeWidget {
  const _Header({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _Colors.white,
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: 57,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: _Colors.textBlack),
                  onPressed: () => Navigator.of(context).maybePop(),
                ),
                Text(title, style: _TextStyles.headerTitle),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(57);
}