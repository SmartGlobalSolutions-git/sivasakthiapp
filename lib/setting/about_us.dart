import 'package:flutter/material.dart';

class _Colors {
  static const Color textBody = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);
}

class _TextStyles {
  static const String fontFamily = 'Inter';

  static const TextStyle body = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: _Colors.textBody,
    height: 1.6,
  );

  static const TextStyle bodyBold = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: _Colors.textBody,
    height: 1.6,
  );
}

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _Colors.white,
      appBar: _Header(title: 'About Us'),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(19, 16, 19, 32),
        children: [
          Text(
            'Siva Sakthi Chit Funds is dedicated to helping individuals, '
                'families, and business owners manage their financial goals '
                'through simple and organized chit fund plans.',
            style: _TextStyles.body,
          ),
          const SizedBox(height: 12),
          Text(
            'Our focus is on providing a transparent, reliable, and '
                'customer-friendly experience. We believe that regular savings, '
                'proper planning, and disciplined financial habits can help '
                'people prepare for future needs and manage important expenses '
                'with greater confidence.',
            style: _TextStyles.body,
          ),
          const SizedBox(height: 12),
          Text(
            'At Siva Sakthi Chit Funds, we offer different chit plans '
                'designed to suit various financial requirements and budgets. '
                'From joining a suitable plan to tracking installments, '
                'participating in auctions, checking statements, and managing '
                'payments, we aim to make the entire process easy and '
                'convenient for our customers.',
            style: _TextStyles.body,
          ),
          const SizedBox(height: 12),
          Text(
            'We value trust, transparency, timely service, and long-term '
                'customer relationships. Our team is committed to clearly '
                'explaining plan details, payment schedules, auction processes, '
                'and account information so that customers can make informed '
                'decisions.',
            style: _TextStyles.body,
          ),
          const SizedBox(height: 12),
          Text(
            'Through our digital services, customers can conveniently '
                'access important information related to their chit account, '
                'upcoming payments, transaction history, plan details, and '
                'other services from one place.',
            style: _TextStyles.body,
          ),
          const SizedBox(height: 16),
          Text('Our Mission', style: _TextStyles.bodyBold),
          const SizedBox(height: 6),
          Text(
            'To provide simple, transparent, and dependable chit fund '
                'services that support better saving habits and financial '
                'planning.',
            style: _TextStyles.body,
          ),
          const SizedBox(height: 16),
          Text('Our Vision', style: _TextStyles.bodyBold),
          const SizedBox(height: 6),
          Text(
            'To become a trusted financial service partner by delivering '
                'convenient solutions, responsible service, and a positive '
                'customer experience.',
            style: _TextStyles.body,
          ),
          const SizedBox(height: 16),
          Text('Our Core Values', style: _TextStyles.bodyBold),
          const SizedBox(height: 6),
          const _BulletList(items: [
            'Trust – Building strong and lasting relationships with our customers.',
            'Transparency – Providing clear information about plans, payments, and processes.',
            'Customer Focus – Keeping customer convenience and satisfaction at the centre of our services.',
            'Reliability – Delivering consistent and dependable support.',
            'Responsibility – Encouraging disciplined financial planning and regular savings.',
            'Convenience – Making account management simple through easy-to-use digital services.',
          ]),
          const SizedBox(height: 16),
          Text('Why Choose Siva Sakthi Chit Funds?', style: _TextStyles.bodyBold),
          const SizedBox(height: 6),
          Text(
            'With customer-friendly chit plans, clear processes, convenient '
                'payment management, account tracking, auction information, '
                'and dedicated support, Siva Sakthi Chit Funds aims to provide '
                'a smooth and dependable experience for every customer.',
            style: _TextStyles.body,
          ),
          const SizedBox(height: 16),
          Text('Siva Sakthi Chit Funds', style: _TextStyles.bodyBold),
          Text('Save Regularly • Plan Better • Grow Together', style: _TextStyles.body),
        ],
      ),
    );
  }
}

class _BulletList extends StatelessWidget {
  const _BulletList({required this.items});
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items
          .map((e) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('•  ', style: _TextStyles.body),
            Expanded(child: Text(e, style: _TextStyles.body)),
          ],
        ),
      ))
          .toList(),
    );
  }
}

// 57px header, white bg, back arrow + title — matches Figma "Rectangle 4"
class _Header extends StatelessWidget implements PreferredSizeWidget {
  const _Header({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Color(0xFF000000), size: 22),
        onPressed: () => Navigator.of(context).maybePop(),
      ),
      titleSpacing: 0,
      title: Text(
        title,
        style: const TextStyle(
          color: Color(0xFF000000),
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}