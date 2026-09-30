import 'package:flutter/material.dart';
import 'package:siva_sakthi/home/home.dart';
import 'package:siva_sakthi/my_chit/my_chits_screen.dart';
import 'package:siva_sakthi/live_action/live_auction.dart';
import 'package:siva_sakthi/payment/payment.dart';

/// Reusable Bottom Navigation Component
class MainIconeFrames extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTabSelected;

  const MainIconeFrames({
    super.key,
    required this.currentIndex,
    required this.onTabSelected,
  });

  static void navigateToTab(BuildContext context, int currentIndex, int targetIndex) {
    if (currentIndex == targetIndex) return;
    Widget targetScreen;
    switch (targetIndex) {
      case 0:
        targetScreen = const SivaSakthiHomeScreen();
        break;
      case 1:
        targetScreen = const MyChitsScreen();
        break;
      case 2:
        targetScreen = const LiveAuctionScreen();
        break;
      case 3:
        targetScreen = const PaymentScreen();
        break;
      default:
        return;
    }
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => targetScreen,
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
  }

  static const List<MainNavigationItem> items = [
    MainNavigationItem(
      label: 'Home',
      unselectedAsset: 'assets/icons/home_unsel_navbar.png',
      selectedAsset: 'assets/icons/home_sel_navbar.png',
    ),
    MainNavigationItem(
      label: 'My Chits',
      unselectedAsset: 'assets/icons/chit_unsel_navbar.png',
      selectedAsset: 'assets/icons/chit_sel_navbar.png',
    ),
    MainNavigationItem(
      label: 'Live auction',
      unselectedAsset: 'assets/icons/bid_unsel_navbar.png',
      selectedAsset: 'assets/icons/bid_sel_navbar.png',
    ),
    MainNavigationItem(
      label: 'Payments',
      unselectedAsset: 'assets/icons/pay_sel_navbar.png',
      selectedAsset: 'assets/icons/pay_unsel_navbar.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Color(0xFFEFF1F4),
            width: 1.0,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(items.length, (index) {
              final isSelected = currentIndex == index;
              final item = items[index];

              return Expanded(
                child: InkWell(
                  onTap: () => onTabSelected(index),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          isSelected ? item.selectedAsset : item.unselectedAsset,
                          width: 25,
                          height: 25,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) => Icon(
                            isSelected ? Icons.circle : Icons.circle_outlined,
                            size: 24,
                            color: isSelected ? const Color(0xFF2563EB) : const Color(0xFF6B7280),
                          ),
                        ),
                        if (isSelected) ...[
                          const SizedBox(height: 3),
                          Text(
                            item.label,
                            style: const TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF2563EB),
                              letterSpacing: -0.1,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class MainNavigationItem {
  final String label;
  final String unselectedAsset;
  final String selectedAsset;

  const MainNavigationItem({
    required this.label,
    required this.unselectedAsset,
    required this.selectedAsset,
  });
}

/// Screen demonstrating all 4 states corresponding to Figma frames:
/// - Frame 1171279057 (Home selected)
/// - Frame 1171279060 (My Chits selected)
/// - Frame 1171279061 (Live auction selected)
/// - Frame 1171279062 (Payments selected)
class MainIconeFramesScreen extends StatefulWidget {
  const MainIconeFramesScreen({super.key});

  @override
  State<MainIconeFramesScreen> createState() => _MainIconeFramesScreenState();
}

class _MainIconeFramesScreenState extends State<MainIconeFramesScreen> {
  int _activeTabIndex = 2; // Default to Live auction

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: const Text(
          'Main Icone Frames',
          style: TextStyle(
            color: Color(0xFF1E293B),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Interactive Bottom Navigation',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Click any icon below to dynamically change the selected asset and label.',
              style: TextStyle(
                fontSize: 13,
                color: Color(0xFF64748B),
              ),
            ),
            const SizedBox(height: 12),

            // Live Interactive Bar
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              clipBehavior: Clip.antiAlias,
              child: MainIconeFrames(
                currentIndex: _activeTabIndex,
                onTabSelected: (index) {
                  setState(() {
                    _activeTabIndex = index;
                  });
                },
              ),
            ),

            const SizedBox(height: 28),

            const Text(
              'Static Figma Frames Preview',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 14),

            // Frame 1171279057: Home selected
            _buildFramePreview('Frame 1171279057', 0),
            const SizedBox(height: 14),

            // Frame 1171279060: My Chits selected
            _buildFramePreview('Frame 1171279060', 1),
            const SizedBox(height: 14),

            // Frame 1171279061: Live auction selected
            _buildFramePreview('Frame 1171279061', 2),
            const SizedBox(height: 14),

            // Frame 1171279062: Payments selected
            _buildFramePreview('Frame 1171279062', 3),
          ],
        ),
      ),
      bottomNavigationBar: MainIconeFrames(
        currentIndex: _activeTabIndex,
        onTabSelected: (index) {
          setState(() {
            _activeTabIndex = index;
          });
        },
      ),
    );
  }

  Widget _buildFramePreview(String frameName, int selectedIndex) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          frameName,
          style: const TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.w600,
            color: Color(0xFF64748B),
          ),
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFE2E8F0)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: MainIconeFrames(
            currentIndex: selectedIndex,
            onTabSelected: (index) {
              setState(() {
                _activeTabIndex = index;
              });
            },
          ),
        ),
      ],
    );
  }
}
