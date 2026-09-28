import 'package:flutter/material.dart';

// ---- Figma tokens (Terms & Condition) ----
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
}

class TermsConditionScreen extends StatelessWidget {
  const TermsConditionScreen({super.key});

  static const List<String> _paragraphs = [
    'By registering with or using Siva Sakthi Chit Funds, you agree to '
        'follow the applicable chit plan rules, payment conditions, '
        'auction procedures, and company policies.',
    'Users must provide accurate personal details and complete the '
        'required KYC verification before joining any chit plan. All '
        'submitted information and documents must be valid and up to '
        'date.',
    'Before joining a chit plan, users should review important details '
        'such as the chit value, monthly installment, duration, due date, '
        'auction process, payment terms, and other applicable conditions.',
    'Installment payments must be made within the specified due dates. '
        'Delayed or missed payments may be handled according to the '
        'applicable chit agreement and company rules.',
    'Members participating in auctions or bidding must follow the '
        'prescribed auction procedures. Prize amount processing, '
        'documentation, surety requirements, and payment release will be '
        'subject to verification and the terms of the respective chit '
        'plan.',
    'Users are responsible for keeping their account, password, OTP, and '
        'other login information secure. Any unauthorized account '
        'activity should be reported to Siva Sakthi Chit Funds '
        'immediately.',
    'Payments may be processed through banks, payment gateways, or other '
        'authorized service providers. Transaction updates may sometimes '
        'be delayed due to banking, network, or technical issues.',
    'Users must not provide false information, upload fraudulent '
        'documents, misuse the application, interfere with services, or '
        'use the platform for any unlawful activity.',
    'Siva Sakthi Chit Funds may temporarily restrict or suspend access '
        'where fraudulent activity, incorrect information, misuse, or '
        'violation of the applicable terms is identified.',
    'App notifications, payment reminders, auction alerts, and other '
        'updates are provided for user convenience. Members remain '
        'responsible for checking their payment obligations and account '
        'details.',
    'Personal information and KYC details will be handled in accordance '
        'with our Privacy Policy and applicable requirements.',
    'Siva Sakthi Chit Funds may update these Terms & Conditions from '
        'time to time due to changes in services, company procedures, or '
        'applicable requirements.',
    'For any account, payment, auction, or service-related questions, '
        'users may contact Siva Sakthi Chit Funds Customer Support.',
    'By continuing to use our services, you confirm that you have read, '
        'understood, and agreed to these Terms & Conditions.',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _Colors.white,
      appBar: _Header(title: 'Terms & Condition'),
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(19, 16, 19, 32),
        itemCount: _paragraphs.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, i) => Text(_paragraphs[i], style: _TextStyles.body),
      ),
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