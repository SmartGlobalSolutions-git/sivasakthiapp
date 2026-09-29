import 'package:flutter/material.dart';

// ---- Figma tokens (Need Help?) ----
class _Colors {
  static const Color pageBg = Color(0xFFF2F3F5);
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color black80 = Color(0xCC000000); // search icon, #000000 @ 80%
  static const Color black60 = Color(0x99000000); // "Chat to ... 24/7", @ 60%
  static const Color black50 = Color(0x80000000); // subtitle, @ 50%
  static const Color green = Color(0xFF058334); // Chat button + icons
  static const Color searchBorder = Color(0x69000000); // @ 41%, 1px
  static const Color cardBorder = Color(0x1A000000); // @ 10%, 0.5px
  static const Color iconBorder = Color(0x24000000); // @ 14%, 1px
  static const Color shadow = Color(0x40000000); // @ 25%, y2 blur4
  static const Color divider = Color(0x63000000); // @ 39%, 0.2px
  static const Color chevron = Color(0xFF9E9E9E);
  static const Color hint = Color(0xFF9E9E9E);
}

class _TextStyles {
  static const TextStyle headerTitle = TextStyle(
    fontFamily: 'Inter',
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: _Colors.black,
  );

  // "Hi Akhil, How can we help ?" — Inter 600, 24px
  static const TextStyle greeting = TextStyle(
    fontFamily: 'Inter',
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: _Colors.black,
    height: 1.2,
  );

  // "Search a topic or find your query in the FAQs" — Inter 500, 14px, 50%
  static const TextStyle subtitle = TextStyle(
    fontFamily: 'Inter',
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: _Colors.black50,
  );

  // "Chat to Akhil 24/7 or one of our team" — Inter 500, 13px, 60%
  static const TextStyle chatCaption = TextStyle(
    fontFamily: 'Inter',
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: _Colors.black60,
  );

  // "Contact us" — Inter 500, 16px
  static const TextStyle sectionTitle = TextStyle(
    fontFamily: 'Inter',
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: _Colors.black,
  );

  static const TextStyle chatButton = TextStyle(
    fontFamily: 'Inter',
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: _Colors.white,
  );

  // Add Poppins to pubspec.yaml fonts (or swap for your app font)
  static const TextStyle rowTitle = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: _Colors.black,
  );

  static const TextStyle searchText = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: _Colors.black,
  );
}

class NeedHelpScreen extends StatelessWidget {
  const NeedHelpScreen({super.key, this.userName = 'Bharathi'});

  /// Shown in the greeting and the "Chat to ... 24/7" caption.
  final String userName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _Colors.pageBg,
      appBar: const _Header(title: 'Need Help?'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Hi $userName,\nHow can we help ?', style: _TextStyles.greeting),
                  const SizedBox(height: 12),
                  const Text(
                    'Search a topic or find your query in the FAQs',
                    style: _TextStyles.subtitle,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            _SearchBox(onSubmitted: (query) {
              // TODO: search FAQs with [query]
            }),
            const SizedBox(height: 16),
            Center(
              child: _ChatButton(onTap: () {
                // TODO: open chat
              }),
            ),
            const SizedBox(height: 18),
            Center(
              child: Text('Chat to $userName 24/7 or one of our team',
                  style: _TextStyles.chatCaption),
            ),
            const SizedBox(height: 18),
            const Padding(
              padding: EdgeInsets.only(left: 1),
              child: Text('Contact us', style: _TextStyles.sectionTitle),
            ),
            const SizedBox(height: 20),
            _ContactCard(
              children: [
                _ContactRow(
                  title: 'General Enquiry',
                  icon: Icons.phone_in_talk,
                  top: 20,
                  bottom: 10,
                  onTap: () {
                    // TODO: General Enquiry action
                  },
                ),
                const _Divider(),
                _ContactRow(
                  title: 'Collection/Payment Support',
                  icon: Icons.phone_in_talk,
                  top: 13.5,
                  bottom: 13,
                  onTap: () {
                    // TODO: Collection/Payment Support action
                  },
                ),
                const _Divider(),
                _ContactRow(
                  title: 'Email',
                  icon: Icons.mail_outline,
                  top: 11,
                  bottom: 10.5,
                  onTap: () {
                    // TODO: Email action
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// 328 x 51, radius 12, 1px border (#000000 @ 41%), padding L16 R17
class _SearchBox extends StatelessWidget {
  const _SearchBox({required this.onSubmitted});
  final ValueChanged<String> onSubmitted;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 51,
      width: double.infinity,
      padding: const EdgeInsets.only(left: 27, right: 28),
      decoration: BoxDecoration(
        color: _Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _Colors.searchBorder, width: 1),
        boxShadow: const [
          BoxShadow(color: _Colors.shadow, offset: Offset(0, 2), blurRadius: 4),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              onSubmitted: onSubmitted,
              textInputAction: TextInputAction.search,
              style: _TextStyles.searchText,
              decoration: const InputDecoration(
                isCollapsed: true,
                border: InputBorder.none,
                hintText: 'How can we help you ?',
                hintStyle: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: _Colors.hint,
                ),
              ),
            ),
          ),
          const Icon(Icons.search, size: 20, color: _Colors.black80),
        ],
      ),
    );
  }
}

// 130 x 40, radius 24, #058334, padding T8 R6 B8 L12, gap 10
class _ChatButton extends StatelessWidget {
  const _ChatButton({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: _Colors.green,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 6, 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text('Chat with us', style: _TextStyles.chatButton),
              SizedBox(width: 10),
              // Swap for your exported chat/globe icon from Figma
              Icon(Icons.chat_bubble_outline, size: 22, color: _Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}

// 328 x 181, radius 12, 0.5px border (#000000 @ 10%), shadow y2 blur4 @ 25%
class _ContactCard extends StatelessWidget {
  const _ContactCard({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: _Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _Colors.cardBorder, width: 0.5),
        boxShadow: const [
          BoxShadow(color: _Colors.shadow, offset: Offset(0, 2), blurRadius: 4),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Material(
          color: _Colors.white,
          child: Column(children: children),
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) =>
      Container(height: 0.2, color: _Colors.divider);
}

class _ContactRow extends StatelessWidget {
  const _ContactRow({
    required this.title,
    required this.icon,
    required this.top,
    required this.bottom,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final double top;
  final double bottom;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.fromLTRB(15, top, 15, bottom),
        child: Row(
          children: [
            // 34 x 34, radius 8, 1px border (#000000 @ 14%)
            Container(
              width: 34,
              height: 34,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: _Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: _Colors.iconBorder, width: 1),
              ),
              child: Icon(icon, size: 18, color: _Colors.green),
            ),
            const SizedBox(width: 15),
            Expanded(child: Text(title, style: _TextStyles.rowTitle)),
            const Icon(Icons.chevron_right, size: 24, color: _Colors.chevron),
          ],
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
                  icon: const Icon(Icons.arrow_back, color: _Colors.black),
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