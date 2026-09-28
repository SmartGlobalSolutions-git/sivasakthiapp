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

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _Colors.white,
      appBar: _Header(title: 'Privacy policy'),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(19, 16, 19, 32),
        children: const [
          _Para('Effective Date: [Enter Date]'),
          SizedBox(height: 12),
          _Para(
            'Siva Sakthi Chit Funds values your privacy and is committed to '
                'protecting the personal information you share with us. This '
                'Privacy Policy explains how we collect, use, store, and '
                'protect your information when you use our mobile application, '
                'website, or related services.',
          ),
          SizedBox(height: 16),
          _SectionHeader('1. Information We Collect'),
          _Para('We may collect information such as:'),
          _Bullets([
            'Full Name',
            'Mobile Number',
            'Email Address',
            'Residential Address',
            'Date of Birth',
            'Profile Information',
            'KYC and identity verification details',
            'Bank or payment-related information',
            'Chit plan and subscription details',
            'Installment and payment information',
            'Auction or bid-related details',
            'Transaction history',
            'Uploaded documents or payment proofs',
            'Enquiry and customer support information',
            'Device and basic app usage information',
          ]),
          _Para('We collect only the information required to provide and manage our services.'),
          SizedBox(height: 16),
          _SectionHeader('2. How We Use Your Information'),
          _Para('Your information may be used to:'),
          _Bullets([
            'Create and manage your account',
            'Verify your identity and customer details',
            'Manage chit plan participation',
            'Process and record payments',
            'Display payment and transaction history',
            'Manage auctions, bids, and related activities',
            'Send payment reminders and service notifications',
            'Respond to enquiries and support requests',
            'Maintain customer records',
            'Improve our app, website, and services',
            'Prevent misuse, fraud, or unauthorized activity',
            'Meet applicable legal and regulatory requirements',
          ]),
          SizedBox(height: 16),
          _SectionHeader('3. KYC and Documents'),
          _Para('Where required, customers may be asked to provide identity or supporting documents for verification.'),
          _Para('Such information will be used only for legitimate business, verification, compliance, and account management purposes.'),
          SizedBox(height: 16),
          _SectionHeader('4. Payment Information'),
          _Para('Payment-related information may be processed through authorized payment service providers, banks, or other approved financial service partners.'),
          _Para('We may maintain necessary transaction details for account management, payment confirmation, reconciliation, and record-keeping.'),
          SizedBox(height: 16),
          _SectionHeader('5. How We Share Information'),
          _Para('We do not sell or rent your personal information.'),
          _Para('Information may be shared only when necessary with:'),
          _Bullets([
            'Authorized service providers',
            'Payment service providers or banks',
            'Verification service providers',
            'Technology and hosting providers',
            'Professional advisers or auditors',
            'Government or regulatory authorities where legally required',
          ]),
          _Para('Service providers are expected to use the information only for the purpose for which it is provided.'),
          SizedBox(height: 16),
          _SectionHeader('6. Data Security'),
          _Para('We take reasonable administrative, technical, and organizational measures to protect your personal information against unauthorized access, misuse, loss, alteration, or disclosure.'),
          _Para('However, no online platform or electronic storage system can guarantee complete security.'),
          SizedBox(height: 16),
          _SectionHeader('7. Data Retention'),
          _Para('We may retain personal and transaction information for as long as necessary to:'),
          _Bullets([
            'Provide our services',
            'Maintain financial and customer records',
            'Resolve complaints or disputes',
            'Meet legal and regulatory obligations',
          ]),
          _Para('Information may be deleted or securely disposed of when it is no longer required, subject to applicable record-retention requirements.'),
          SizedBox(height: 16),
          _SectionHeader('8. Notifications and Communications'),
          _Para('We may send service-related communications such as:'),
          _Bullets([
            'Payment reminders',
            'Chit plan updates',
            'Auction notifications',
            'Account-related alerts',
            'Transaction confirmations',
            'Important service announcements',
          ]),
          _Para('Users may manage optional promotional communications where such options are available.'),
          SizedBox(height: 16),
          _SectionHeader('9. User Rights'),
          _Para('Depending on applicable law, users may request to:'),
          _Bullets([
            'Access their personal information',
            'Correct inaccurate information',
            'Update account details',
            'Request deletion of eligible information',
            'Raise concerns regarding the use of their personal data',
          ]),
          _Para('Some information may need to be retained where required for legal, financial, regulatory, or record-keeping purposes.'),
          SizedBox(height: 16),
          _SectionHeader('10. Third-Party Services'),
          _Para('Our app or website may use third-party services such as payment gateways, notification providers, analytics tools, or other technology services.'),
          _Para('These third parties may process information according to their own privacy policies and applicable requirements.'),
          SizedBox(height: 16),
          _SectionHeader("11. Children's Privacy"),
          _Para('Our services are not intended for individuals who are not legally eligible to participate in the services offered by Siva Sakthi Chit Funds.'),
          _Para('We do not knowingly collect personal information from children except where permitted and appropriately authorized under applicable law.'),
          SizedBox(height: 16),
          _SectionHeader('12. Changes to This Privacy Policy'),
          _Para('We may update this Privacy Policy from time to time due to changes in our services, business practices, or legal requirements.'),
          _Para('Any updated Privacy Policy may be published within our application or website along with the revised effective date.'),
          SizedBox(height: 16),
          _SectionHeader('13. Contact Us'),
          _Para('For questions, concerns, corrections, or privacy-related requests, please contact:'),
          _Para('Siva Sakthi Chit Funds\nPhone: [Enter Phone Number]\nEmail: [Enter Email Address]\nAddress: [Enter Office Address]'),
          SizedBox(height: 16),
          _Para('By using Siva Sakthi Chit Funds services, you acknowledge that you have read and understood this Privacy Policy.'),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(text, style: _TextStyles.bodyBold),
    );
  }
}

class _Para extends StatelessWidget {
  const _Para(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text, style: _TextStyles.body),
    );
  }
}

class _Bullets extends StatelessWidget {
  const _Bullets(this.items);
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: items
            .map((e) => Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('•  ', style: _TextStyles.body),
              Expanded(child: Text(e, style: _TextStyles.body)),
            ],
          ),
        ))
            .toList(),
      ),
    );
  }
}

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