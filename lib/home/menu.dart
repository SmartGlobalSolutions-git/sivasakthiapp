import 'package:flutter/material.dart';
import 'package:siva_sakthi/calculator/calculator_screen.dart';
import 'package:siva_sakthi/chat_bot/chat.dart';
import 'package:siva_sakthi/live_action/live_auction.dart';
import 'package:siva_sakthi/passbook/passbook.dart';
import 'package:siva_sakthi/payment/payment.dart';
import 'package:siva_sakthi/setting/need_help.dart';
import 'package:siva_sakthi/setting/profile_info.dart';
import 'package:siva_sakthi/setting/setting.dart';
import 'package:siva_sakthi/statement/statement.dart';
import 'package:siva_sakthi/setting/reward.dart';

/// Menu screen / drawer — matches Figma design
class ProfileMenuScreen extends StatelessWidget {
  final String userName;
  final String appVersion;
  final VoidCallback? onNeedHelpTap;
  final VoidCallback? onProfileTap;
  final VoidCallback? onPaymentTap;
  final VoidCallback? onCalculatorTap;
  final VoidCallback? onLiveAuctionTap;
  final VoidCallback? onPassbookTap;
  final VoidCallback? onChatbotTap;
  final VoidCallback? onStatementTap;
  final VoidCallback? onSettingsTap;
  final VoidCallback? onRewardsTap;

  const ProfileMenuScreen({
    super.key,
    this.userName = '',
    this.appVersion = 'App V1.0125',
    this.onNeedHelpTap,
    this.onProfileTap,
    this.onPaymentTap,
    this.onCalculatorTap,
    this.onLiveAuctionTap,
    this.onPassbookTap,
    this.onChatbotTap,
    this.onStatementTap,
    this.onSettingsTap,
    this.onRewardsTap,
  });

  // ---- Figma tokens ----
  static const Color _cardColor = Color(0xFFF5F5F5);
  static const Color _black = Color(0xFF000000);
  static const Color _needHelpBorder = Color(0xFF9B9B9B);
  static const Color _needHelpBlue =Color(0xff266FAF);

  // ---- Asset paths (PNG) ----
  static const String _profileIcon = 'assets/icons/profile_menu.png';
  static const String _paymentIcon = 'assets/icons/pay_menu.png';
  static const String _calculatorIcon = 'assets/icons/cal_menu.png';
  static const String _liveAuctionIcon = 'assets/icons/live_menu.png';
  static const String _passbookIcon = 'assets/icons/pass_menu.png';
  static const String _chatbotIcon = 'assets/icons/chat_menu.png';
  static const String _statementIcon = 'assets/icons/state_menu.png';
  static const String _settingsIcon = 'assets/icons/set_menu.png';
  static const String _rewardsIcon = 'assets/icons/rewards_menu.png';
  static const String _needHelpIcon = 'assets/icons/need_help.png';

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: SafeArea(
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: 20),
              _MenuCard(
                items: [
                  _MenuItemData('Profile', _profileIcon, onProfileTap ?? () {
                    Navigator.of(context).maybePop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ProfileScreen()),
                    );
                  }),
                  _MenuItemData('Payment', _paymentIcon, onPaymentTap  ?? () {
                    Navigator.of(context).maybePop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const PaymentScreen()),
                    );
                  }),
                  _MenuItemData('Calculator', _calculatorIcon, onCalculatorTap ?? () {
                    Navigator.of(context).maybePop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const CalculatorScreen()),
                    );
                  }),
                  _MenuItemData('Live auction', _liveAuctionIcon, onLiveAuctionTap ?? () {
                    Navigator.of(context).maybePop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const LiveAuctionScreen()),
                    );
                  }),
                  _MenuItemData('Passbook', _passbookIcon, onPassbookTap ?? () {
                    Navigator.of(context).maybePop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const PassbookSearchScreen()),
                    );
                  }),
                  _MenuItemData('Chatbot', _chatbotIcon, onChatbotTap ?? () {
                    Navigator.of(context).maybePop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ChatbotScreen()),
                    );
                  }),
                  _MenuItemData('Statement', _statementIcon, onStatementTap ?? () {
                    Navigator.of(context).maybePop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const StatementSearchScreen()),
                    );
                  }),
                ],
              ),
              const SizedBox(height: 24),
              _MenuCard(
                items: [
                  _MenuItemData('Settings', _settingsIcon, onSettingsTap ?? () {
                    Navigator.of(context).maybePop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SettingScreen()),
                    );
                  }),
                  _MenuItemData('Rewards & Achievements', _rewardsIcon, onRewardsTap ?? () {
                    Navigator.of(context).maybePop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const RewardsAchievementsScreen()),
                    );
                  }),
                ],
              ),
              const SizedBox(height: 22),
              Center(
                child: Text(
                  appVersion,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    color: _black.withValues(alpha: 0.6),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Avatar circle with outline and person icon matching the design image
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFFF3F4F6),
            border: Border.all(color: const Color(0xFFD1D5DB), width: 1),
          ),
          child: const Icon(
            Icons.person_outline,
            size: 24,
            color: Color(0xFF9CA3AF),
          ),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Hello',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 11,
                fontWeight: FontWeight.w400,
                color: _black.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              userName,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: _black,
              ),
            ),
          ],
        ),
        const Spacer(),
        // Need Help pill button
        GestureDetector(
          onTap: () {
            if (onNeedHelpTap != null) {
              onNeedHelpTap!();
            } else {
              Navigator.of(context).maybePop();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const NeedHelpScreen()),
              );
            }
          },
          behavior: HitTestBehavior.opaque,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6.5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: _needHelpBorder, width: 0.8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  _needHelpIcon,
                  width: 16,
                  height: 16,
                  fit: BoxFit.contain,
                ),
                const SizedBox(width: 5),
                const Text(
                  'Need Help ?',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                    color: _needHelpBlue,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _MenuItemData {
  final String label;
  final String iconAsset;
  final VoidCallback? onTap;
  const _MenuItemData(this.label, this.iconAsset, this.onTap);
}

class _MenuCard extends StatelessWidget {
  final List<_MenuItemData> items;

  const _MenuCard({required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: ProfileMenuScreen._cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: items.map((e) => _MenuRow(data: e)).toList(),
      ),
    );
  }
}

class _MenuRow extends StatelessWidget {
  final _MenuItemData data;

  const _MenuRow({required this.data});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: data.onTap,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8.5),
        child: Row(
          children: [
            // White circular badge with icon
            Container(
              width: 36,
              height: 36,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Image.asset(
                data.iconAsset,
                width: 22,
                height: 22,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                data.label,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: ProfileMenuScreen._black,
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right,
              size: 18,
              color: Color(0xFF9E9E9E),
            ),
          ],
        ),
      ),
    );
  }
}