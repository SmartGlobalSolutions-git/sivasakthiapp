import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class RewardsAchievementsScreen extends StatelessWidget {
  const RewardsAchievementsScreen({super.key, this.onViewAll});

  final VoidCallback? onViewAll;

  static const List<_StatData> _stats = [
    _StatData(
      image: _RewardsAssets.statHappyClients,
      number: '25,000+',
      label: 'Happy Clients',
      fill: Color(0xFFEEFBF4),
      border: Color(0x99D2F3E1),
    ),
    _StatData(
      image: _RewardsAssets.statActiveGroups,
      number: '1,200+',
      label: 'Active Groups',
      fill: Color(0xFFF5F1FF),
      border: Color(0x99E3DAFB),
    ),
    _StatData(
      image: _RewardsAssets.statChitValue,
      number: '₹ 500+\nCrore',
      label: 'Total Chit Value',
      fill: Color(0xFFEDF6FF),
      border: Color(0x99D3E6FB),
      numberLineHeight: 1.0,
    ),
    _StatData(
      image: _RewardsAssets.statBranches,
      number: '2',
      label: 'Branches',
      fill: Color(0xFFFDF1F3),
      border: Color(0x99F9D9DE),
    ),
    _StatData(
      image: _RewardsAssets.statYearsOfTrust,
      number: '15+',
      label: 'Years of Trust',
      fill: Color(0xFFFFF8E8),
      border: Color(0x99F8EBD0),
    ),
    _StatData(
      image: _RewardsAssets.statCustomerSatisfaction,
      number: '98%',
      label: 'Customer\nSatisfaction',
      fill: Color(0xFFF5F3FF),
      border: Color(0x99E4DEFB),
      labelLineHeight: 1.0,
    ),
  ];

  static const List<_MilestoneData> _milestones = [
    _MilestoneData(
      title: 'First 1,000 Clients',
      year: 'Reached in 2015',
      circleColor: Color(0xFF0FA958),
      dotColor: Color(0xFF10B982),
      dotRingColor: Color(0xFFE5F6F0),
    ),
    _MilestoneData(
      title: '10,000+ Clients',
      year: 'Reached in 2018',
      circleColor: Color(0xFF6D28D9),
      dotColor: Color(0xFF7C3AED),
      dotRingColor: Color(0xFFEBE5FF),
    ),
    _MilestoneData(
      title: '20,000+ Clients',
      year: 'Reached in 2021',
      circleColor: Color(0xFF2563EB),
      dotColor: Color(0xFF2563EB),
      dotRingColor: Color(0xFFD9ECFA),
    ),
    _MilestoneData(
      title: '25,000+ Clients',
      year: 'Reached in 2024',
      circleColor: Color(0xFFF59E0B),
      dotColor: Color(0xFFF59E0B),
      dotRingColor: Color(0xFFFBF3CE),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _RewardsColors.background,
      appBar: AppBar(
        backgroundColor: _RewardsColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        toolbarHeight: 52.5,
        leadingWidth: 41,
        titleSpacing: 0,
        centerTitle: false,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => Navigator.of(context).maybePop(),
              child: const Icon(
                Icons.arrow_back,
                size: 24,
                color: _RewardsColors.appBarTitle,
              ),
            ),
          ),
        ),
        title: const Text(
          'Rewards & Achievements',
          style: TextStyle(
            fontFamily: _RewardsText.fontFamily,
            fontSize: 16,
            fontWeight: FontWeight.w400,
            height: 1.0,
            color: _RewardsColors.appBarTitle,
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero banner image (328 x 148)
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Image.asset(
                  _RewardsAssets.heroBanner,
                  width: 328,
                  height: 148,
                  fit: BoxFit.fill,
                ),
              ),
              const SizedBox(height: 18),

              // Company Achievements
              const Padding(
                padding: EdgeInsets.only(left: 17),
                child: _SectionHeading(
                  text: 'Company Achievements',
                  fontSize: 15.01,
                  lineHeight: 22.51,
                  letterSpacing: -0.38,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 17),
                child: Column(
                  children: [
                    _buildStatRow(0),
                    const SizedBox(height: 8),
                    _buildStatRow(3),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Chit Milestones heading + View All
              Padding(
                padding: const EdgeInsets.only(left: 17, right: 25),
                child: SizedBox(
                  height: 26,
                  child: Row(
                    children: [
                      const _SectionHeading(
                        text: 'Chit Milestones',
                        fontSize: 17,
                        lineHeight: 25.5,
                        letterSpacing: -0.43,
                      ),
                      const Spacer(),
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: onViewAll,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'View All',
                              style: TextStyle(
                                fontFamily: _RewardsText.fontFamily,
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                height: 1.5,
                                color: _RewardsColors.viewAll,
                              ),
                            ),
                            const Icon(
                              Icons.chevron_right,
                              size: 16,
                              color: _RewardsColors.viewAll,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Timeline
              Padding(
                padding: const EdgeInsets.only(left: 18),
                child: SizedBox(width: 315, child: _buildTimeline()),
              ),
              const SizedBox(height: 12),

              // Bottom banner image (315 x 131, radius 8)
              Padding(
                padding: const EdgeInsets.only(left: 18),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    _RewardsAssets.bottomBanner,
                    width: 315,
                    height: 131,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatRow(int startIndex) {
    return Row(
      children: [
        _StatCard(data: _stats[startIndex]),
        const SizedBox(width: 8),
        _StatCard(data: _stats[startIndex + 1]),
        const SizedBox(width: 8),
        _StatCard(data: _stats[startIndex + 2]),
      ],
    );
  }

  Widget _buildTimeline() {
    return Stack(
      children: [
        // Vertical connector between first and last marker
        Positioned(
          left: 8,
          top: 22,
          bottom: 22,
          child: Container(width: 2, color: _RewardsColors.connector),
        ),
        Column(
          children: [
            for (int i = 0; i < _milestones.length; i++) ...[
              if (i > 0) const SizedBox(height: 16),
              _MilestoneRow(data: _milestones[i]),
            ],
          ],
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Widgets
// ---------------------------------------------------------------------------

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({
    required this.text,
    required this.fontSize,
    required this.lineHeight,
    required this.letterSpacing,
  });

  final String text;
  final double fontSize;
  final double lineHeight;
  final double letterSpacing;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 26,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: TextStyle(
            fontFamily: _RewardsText.fontFamily,
            fontSize: fontSize,
            fontWeight: FontWeight.w700,
            height: lineHeight / fontSize,
            letterSpacing: letterSpacing,
            color: _RewardsColors.ink,
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.data});

  final _StatData data;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 97.11,
      height: 93.04,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: data.fill,
        borderRadius: BorderRadius.circular(17.66),
        border: Border.all(color: data.border, width: 0.88),
        boxShadow: const [
          BoxShadow(
            color: Color(0x05000000),
            offset: Offset(0, 0.88),
            blurRadius: 2.65,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            data.image,
            width: 33,
            height: 33,
            fit: BoxFit.contain,
          ),
          Text(
            data.number,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: _RewardsText.fontFamily,
              fontSize: 12.8,
              fontWeight: FontWeight.w700,
              height: data.numberLineHeight,
              color: _RewardsColors.ink,
            ),
          ),
          Text(
            data.label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: _RewardsText.fontFamily,
              fontSize: 8.83,
              fontWeight: FontWeight.w500,
              height: data.labelLineHeight,
              color: _RewardsColors.label,
            ),
          ),
        ],
      ),
    );
  }
}

class _MilestoneRow extends StatelessWidget {
  const _MilestoneRow({required this.data});

  final _MilestoneData data;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: Row(
        children: [
          // Left marker (18 ring + 10 dot)
          SizedBox(
            width: 18,
            child: Center(
              child: Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  color: data.dotRingColor,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: data.dotColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 5),

          // 44 x 44 coloured circle with people image
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: data.circleColor,
              shape: BoxShape.circle,
              boxShadow: const [
                BoxShadow(
                  color: Color(0x0D000000),
                  offset: Offset(0, 1),
                  blurRadius: 2,
                ),
              ],
            ),
            alignment: Alignment.center,
            child: Image.asset(
              _RewardsAssets.milestonePeople,
              width: 24,
              height: 24,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(width: 14),

          // Title + year
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: _RewardsText.fontFamily,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    height: 1.5,
                    letterSpacing: -0.28,
                    color: _RewardsColors.ink,
                  ),
                ),
                Text(
                  data.year,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: _RewardsText.fontFamily,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    height: 1.5,
                    letterSpacing: -0.24,
                    color: _RewardsColors.subtitle,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),

          // Status pill: padding 10/4, radius 9999, #E7F8EF
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: _RewardsColors.pillBackground,
              borderRadius: BorderRadius.circular(9999),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.check_circle,
                  size: 12,
                  color: _RewardsColors.pillText,
                ),
                const SizedBox(width: 6),
                const Text(
                  'Completed',
                  style: TextStyle(
                    fontFamily: _RewardsText.fontFamily,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    height: 1.5,
                    color: _RewardsColors.pillText,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Data models
// ---------------------------------------------------------------------------

class _StatData {
  const _StatData({
    required this.image,
    required this.number,
    required this.label,
    required this.fill,
    required this.border,
    this.numberLineHeight = 1.25,
    this.labelLineHeight = 1.25,
  });

  final String image;
  final String number;
  final String label;
  final Color fill;
  final Color border;
  final double numberLineHeight;
  final double labelLineHeight;
}

class _MilestoneData {
  const _MilestoneData({
    required this.title,
    required this.year,
    required this.circleColor,
    required this.dotColor,
    required this.dotRingColor,
  });

  final String title;
  final String year;
  final Color circleColor;
  final Color dotColor;
  final Color dotRingColor;
}

// ---------------------------------------------------------------------------
// Constants
// ---------------------------------------------------------------------------

class _RewardsColors {
  static const Color background = Color(0xFFF3F3F5);
  static const Color appBarTitle = Color(0xFF040404);
  static const Color ink = Color(0xFF0B163F);
  static const Color label = Color(0xFF65728A);
  static const Color subtitle = Color(0xFF696C7F);
  static const Color viewAll = Color(0xFF5C33D8);
  static const Color pillBackground = Color(0xFFE7F8EF);
  static const Color pillText = Color(0xFF0E9F56);
  static const Color connector = Color(0xFFE5EAEE);
}

class _RewardsText {
  static const String fontFamily = 'Inter';
}

class _RewardsAssets {
  static const String _base = 'assets/reward/';

  static const String heroBanner = '${_base}top_banner.png'; // 328 x 148
  static const String statHappyClients = '${_base}ach_c1.png'; // 33 x 33
  static const String statActiveGroups = '${_base}ach_c2.png'; // 33 x 33
  static const String statChitValue = '${_base}ach_c3.png'; // 33 x 33
  static const String statBranches = '${_base}ach_c4.png'; // 33 x 33
  static const String statYearsOfTrust = '${_base}ach_c5.png'; // 33 x 33
  static const String statCustomerSatisfaction = '${_base}ach_c6.png'; // 33 x 33
  static const String milestonePeople = '${_base}human.png'; // 24 x 24, white
  static const String bottomBanner = '${_base}bottom_banner.png'; // 315 x 131
}