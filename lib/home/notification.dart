import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ---- Figma tokens (Notification) ----
class _Colors {
  static const Color pageBg = Color(0xFFF2F3F5);
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color black80 = Color(0xCC000000);
  static const Color divider = Color(0x1F000000);

  static const Color green = Color(0xFF058334); // time, highlight, icons
  static const Color greenBg = Color(0x5CA0FDAA); // #A0FDAA @ 36%

  static const Color orange = Color(0xFFDF8C07);
  static const Color orangeBg = Color(0x33DF8C07); // #DF8C07 @ 20%

  static const Color plum = Color(0xFF7F2B73);
  static const Color plumBg = Color(0x367F2B73); // #7F2B73 @ 21%

  static const Color violet = Color(0xFF9333EA);
  static const Color lilacBg = Color(0xFFE5D2F9); // #E5D2F9

  static const Color red = Color(0xFFE5091E);
}

class _TextStyles {

  // Title — Inter 600, 13px, #000000
  static const TextStyle title = TextStyle(
    fontFamily: 'Inter',
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: _Colors.black,
    height: 1.2,
  );

  // Time — Inter 500, 10px
  static const TextStyle time = TextStyle(
    fontFamily: 'Inter',
    fontSize: 10,
    fontWeight: FontWeight.w500,
    height: 1.2,
  );

  // Message — Inter 400, 12px, line-height 20, #000000 @ 80%
  static const TextStyle body = TextStyle(
    fontFamily: 'Inter',
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: _Colors.black80,
    height: 20 / 12,
  );

  static const TextStyle highlight = TextStyle(
    fontFamily: 'Inter',
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: _Colors.green,
    height: 20 / 12,
  );
}

class NotificationItem {
  const NotificationItem({
    required this.title,
    required this.message,
    required this.time,
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.dotColor,
    this.highlight,
    this.timeColor = _Colors.green,
    this.filledIcon = false,
    // Per-item spacing tuned to the Figma frames
    this.topPadding = 17,
    this.titleGap = 1,
    this.bottomPadding = 15.5,
  });

  final String title;
  final String message;
  final String time;
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final Color dotColor;

  /// Part of [message] shown in bold green (e.g. "15 Sep 2026").
  final String? highlight;
  final Color timeColor;

  /// Solid rounded square with a white glyph (used by "Overdue Payment").
  final bool filledIcon;

  final double topPadding;
  final double titleGap;
  final double bottomPadding;
}

const List<NotificationItem> _sampleItems = [
  NotificationItem(
    title: 'Auction Date Announced',
    message: 'Your chit auction for “Monthly Savings Chit”\n is Scheduled for 15 Sep 2026',
    highlight: '15 Sep 2026',
    time: '10:30 AM',
    icon: Icons.calendar_month_outlined,
    iconColor: _Colors.green,
    iconBg: _Colors.greenBg,
    dotColor: _Colors.green,
    topPadding: 22.5,
    titleGap: 4.5,
    bottomPadding: 17,
  ),
  NotificationItem(
    title: 'Auction Reminder',
    message: 'Your upcoming chit auction is tomorrow.\nCheck the auction details.',
    time: '09:00 AM',
    icon: Icons.notifications_none,
    iconColor: _Colors.green,
    iconBg: _Colors.greenBg,
    dotColor: _Colors.green,
  ),
  NotificationItem(
    title: 'Payment Due',
    message: 'Your ₹5,000 chit payment is due on\n10 Sep 2026.',
    time: 'Yesterday , 8:45 PM',
    icon: Icons.currency_rupee,
    iconColor: _Colors.green,
    iconBg: _Colors.greenBg,
    dotColor: _Colors.red,
  ),
  NotificationItem(
    title: 'Payment Successful',
    message: 'Your ₹5,000 payment for “Monthly\nSavings Chit” was successfully received.',
    time: 'Yesterday ,11:45 PM',
    icon: Icons.verified_outlined,
    iconColor: _Colors.green,
    iconBg: _Colors.greenBg,
    dotColor: _Colors.green,
  ),
  NotificationItem(
    title: 'Payment Due Tomorrow',
    message: 'Your upcoming chit installment is due\ntomorrow. Pay on time to avoid\ndelays.',
    time: 'Today ,9:00 AM',
    icon: Icons.schedule,
    iconColor: _Colors.orange,
    iconBg: _Colors.orangeBg,
    dotColor: _Colors.orange,
  ),
  NotificationItem(
    title: 'Overdue Payment',
    message: 'Your ₹5,000 installment is overdue.\nPlease make your payment as soon as\npossible.',
    time: '2 Sep, 7:30 PM',
    icon: Icons.priority_high,
    iconColor: _Colors.orange,
    iconBg: _Colors.orangeBg,
    dotColor: _Colors.orange,
    filledIcon: true,
    topPadding: 19.5,
    titleGap: 2.5,
    bottomPadding: 17.5,
  ),
  NotificationItem(
    title: 'Enrollment Confirmed',
    message: 'Your enrollment in “Monthly Savings\nChit-₹1 Lakh”has been successfully confirmed.',
    time: '1 Sep, 10:20 AM',
    timeColor: _Colors.black,
    icon: Icons.edit_document,
    iconColor: _Colors.plum,
    iconBg: _Colors.plumBg,
    dotColor: _Colors.plum,
  ),
  NotificationItem(
    title: 'New Chit Enrollment',
    message: 'You have successfully joined a new chit group.\nView your chit details.',
    time: '1 Sep, 10:20 AM',
    timeColor: _Colors.black,
    icon: Icons.groups,
    iconColor: _Colors.plum,
    iconBg: _Colors.plumBg,
    dotColor: _Colors.plum,
  ),
  NotificationItem(
    title: 'Welcome to SIVA SARAVANA!',
    message: 'Your account has been created successfully.\nStart managing your chit plans with ease.',
    time: '9:30 AM',
    timeColor: _Colors.black,
    icon: Icons.handshake_outlined,
    iconColor: _Colors.violet,
    iconBg: _Colors.lilacBg,
    dotColor: _Colors.violet,
  ),
];

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key, this.items = _sampleItems});

  final List<NotificationItem> items;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _Colors.pageBg,
      appBar: AppBar(
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
          'Notification',
          style: GoogleFonts.manrope(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
      ),
      body: ListView.separated(
        padding: EdgeInsets.zero,
        itemCount: items.length,
        separatorBuilder: (context, index) => Container(height: 0.5, color: _Colors.divider),
        itemBuilder: (context, i) => _NotificationTile(item: items[i]),
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({required this.item});

  final NotificationItem item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, item.topPadding, 18.5, item.bottomPadding),
      child: Row(
        children: [
          _IconCircle(item: item),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        item.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: _TextStyles.title,
                      ),
                    ),
                    Text(
                      item.time,
                      style: _TextStyles.time.copyWith(color: item.timeColor),
                    ),
                    const SizedBox(width: 8.5),
                    SizedBox(
                      height: 12,
                      child: Center(
                        child: Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: item.dotColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: item.titleGap),
                _Message(item: item),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// 40 x 40 circle (padding 8 -> 24 glyph)
class _IconCircle extends StatelessWidget {
  const _IconCircle({required this.item});

  final NotificationItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: item.iconBg, shape: BoxShape.circle),
      child: item.filledIcon
          ? Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: item.iconColor,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(item.icon, size: 18, color: _Colors.white),
      )
          : Icon(item.icon, size: 24, color: item.iconColor),
    );
  }
}

class _Message extends StatelessWidget {
  const _Message({required this.item});

  final NotificationItem item;

  @override
  Widget build(BuildContext context) {
    final highlight = item.highlight;
    if (highlight == null || !item.message.contains(highlight)) {
      return Text(item.message, style: _TextStyles.body);
    }
    final parts = item.message.split(highlight);
    return Text.rich(
      TextSpan(
        style: _TextStyles.body,
        children: [
          TextSpan(text: parts.first),
          TextSpan(text: highlight, style: _TextStyles.highlight),
          TextSpan(text: parts.sublist(1).join(highlight)),
        ],
      ),
    );
  }
}