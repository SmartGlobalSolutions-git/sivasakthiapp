import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:siva_sakthi/calculator/calculator_screen.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  static const primaryBlue = Color(0xFF3C93F4);

  final List<Map<String, dynamic>> _messages = [
    {
      'isUser': false,
      'text': "Hello! I'm your Chit Assistant.\nHow can I help you today?",
      'hasToolCard': false,
      'isTyping': false,
    },
  ];

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      // Add user message
      _messages.add({
        'isUser': true,
        'text': text,
        'hasToolCard': false,
        'isTyping': false,
      });
      // Add typing indicator
      _messages.add({
        'isUser': false,
        'text': '...',
        'hasToolCard': false,
        'isTyping': true,
      });
      _messageController.clear();
    });

    _scrollToBottom();

    // Simulate network delay for bot reply
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (!mounted) return;
      setState(() {
        // Remove typing indicator
        _messages.removeLast();

        final response = _generateBotResponse(text);
        _messages.add({
          'isUser': false,
          'text': response['text'],
          'hasToolCard': response['hasToolCard'],
          'isTyping': false,
        });
      });
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 100,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Map<String, dynamic> _generateBotResponse(String input) {
    final lower = input.toLowerCase();
    
    if (lower.contains('chit') || lower.contains('scheme') || lower.contains('plan')) {
      return {
        'text': "We offer various Chit Schemes ranging from ₹1,00,000 to ₹50,000,000 with flexible durations like 20, 30, 40, or 50 months. You can view them in the 'New Chits' section.",
        'hasToolCard': false,
      };
    } else if (lower.contains('pay') || lower.contains('due') || lower.contains('pending')) {
      return {
        'text': "You can easily pay your chit dues online via UPI, Net Banking, or by scanning our QR code. Navigate to the 'My Chits' or 'Payment' tab to clear pending dues.",
        'hasToolCard': false,
      };
    } else if (lower.contains('auction') || lower.contains('bid') || lower.contains('dividend') || lower.contains('calculate')) {
      return {
        'text': "You can calculate your potential dividend for upcoming auctions using our Bid Calculator. It considers the total pot, your bid amount, and the number of active participants.",
        'hasToolCard': true,
      };
    } else if (lower.contains('hi') || lower.contains('hello') || lower.contains('hey')) {
      return {
        'text': "Hello again! Let me know if you need any details about our chit schemes, payments, or upcoming auctions.",
        'hasToolCard': false,
      };
    } else {
      return {
        'text': "Thank you for reaching out! To give you the most accurate answer regarding that, please explore the app sections or contact our support team.",
        'hasToolCard': false,
      };
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double scaleW = screenSize.width / 360.0;
    final double scaleH = screenSize.height / 800.0;

    final double topPadding = MediaQuery.of(context).padding.top;
    final double statusBarH = topPadding > 20 ? topPadding : 24.0;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Color(0xFF0D1519),
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: Color(0xFF0D1519),
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F6F8),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(57 * scaleH.clamp(0.85, 1.2) + statusBarH),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTopStatusBar(context, statusBarH),
              AppBar(
                primary: false,
                backgroundColor: Colors.white,
                elevation: 0,
                scrolledUnderElevation: 0,
                toolbarHeight: 57 * scaleH.clamp(0.85, 1.2),
                systemOverlayStyle: const SystemUiOverlayStyle(
                  statusBarColor: Color(0xFF0D1519),
                  statusBarIconBrightness: Brightness.light,
                  statusBarBrightness: Brightness.dark,
                ),
                centerTitle: false,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Color(0xFF1E2638), size: 22),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                titleSpacing: 0,
                title: Text(
                  'Chatbot',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF1E2638),
                    height: 1.0,
                    letterSpacing: 0,
                  ),
                ),
              ),
            ],
          ),
        ),
        body: SafeArea(
          top: false,
          child: Column(
            children: [
              // Chat Messages List
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  padding: EdgeInsets.symmetric(
                    horizontal: 16 * scaleW.clamp(0.85, 1.2),
                    vertical: 12 * scaleH.clamp(0.85, 1.2),
                  ),
                  child: Column(
                    children: [
                      // Top Centered Bot Logo (Blue circle with roboto.png)
                      Center(
                        child: Container(
                          width: 72 * scaleW.clamp(0.85, 1.2),
                          height: 72 * scaleW.clamp(0.85, 1.2),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: primaryBlue,
                              width: 3.0,
                            ),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: primaryBlue.withValues(alpha: 0.18),
                                blurRadius: 10,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(4),
                          child: ClipOval(
                            child: Image.asset(
                              'assets/images/roboto.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 8 * scaleH.clamp(0.85, 1.2)),

                      // Timestamp
                      Text(
                        'Today, 10:42 AM',
                        style: GoogleFonts.inter(
                          fontSize: 12 * scaleW.clamp(0.85, 1.2),
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF757575),
                        ),
                      ),
                      SizedBox(height: 16 * scaleH.clamp(0.85, 1.2)),

                      // Chat messages
                      ..._messages.map((msg) => _buildMessageItem(msg, scaleW, scaleH)),
                    ],
                  ),
                ),
              ),

              // Bottom Input Bar (matching screenshot)
              Container(
                padding: EdgeInsets.fromLTRB(
                  16 * scaleW.clamp(0.85, 1.2),
                  10,
                  16 * scaleW.clamp(0.85, 1.2),
                  14,
                ),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    top: BorderSide(color: Color(0xFFE5E7EB), width: 1),
                  ),
                ),
                child: Container(
                  height: 48 * scaleH.clamp(0.85, 1.2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE5E7EB), width: 1.2),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      // Attachment paperclip icon
                      IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        icon: const Icon(
                          Icons.attach_file,
                          color: Color(0xFF374151),
                          size: 22,
                        ),
                        onPressed: () {},
                      ),
                      const SizedBox(width: 8),

                      // Input Text Field
                      Expanded(
                        child: TextField(
                          controller: _messageController,
                          style: GoogleFonts.inter(
                            fontSize: 14 * scaleW.clamp(0.85, 1.2),
                            color: const Color(0xFF1E2638),
                          ),
                          onSubmitted: (_) => _sendMessage(),
                          decoration: InputDecoration(
                            hintText: 'Ask Chit Assistant...',
                            hintStyle: GoogleFonts.inter(
                              fontSize: 14 * scaleW.clamp(0.85, 1.2),
                              color: const Color(0xFF9CA3AF),
                            ),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ),

                      // Send Button (Blue #3C93F4)
                      GestureDetector(
                        onTap: _sendMessage,
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: primaryBlue,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.send_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessageItem(Map<String, dynamic> msg, double scaleW, double scaleH) {
    final bool isUser = msg['isUser'] as bool;
    final String text = msg['text'] as String;
    final bool hasToolCard = msg['hasToolCard'] as bool;
    final bool isTyping = msg['isTyping'] as bool? ?? false;

    if (isUser) {
      return Padding(
        padding: EdgeInsets.only(bottom: 14 * scaleH.clamp(0.85, 1.2)),
        child: Align(
          alignment: Alignment.centerRight,
          child: Container(
            constraints: BoxConstraints(
              maxWidth: 240 * scaleW.clamp(0.85, 1.25),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: primaryBlue,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(
              text,
              style: GoogleFonts.inter(
                fontSize: 13.5 * scaleW.clamp(0.85, 1.2),
                fontWeight: FontWeight.w500,
                color: Colors.white,
                height: 1.35,
              ),
            ),
          ),
        ),
      );
    }

    // Typing indicator item
    if (isTyping) {
      return Padding(
        padding: EdgeInsets.only(bottom: 14 * scaleH.clamp(0.85, 1.2)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildBotAvatar(scaleW),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildDot(),
                  const SizedBox(width: 4),
                  _buildDot(),
                  const SizedBox(width: 4),
                  _buildDot(),
                ],
              ),
            ),
          ],
        ),
      );
    }

    // Bot message
    return Padding(
      padding: EdgeInsets.only(bottom: 14 * scaleH.clamp(0.85, 1.2)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Small bot avatar on the left
          _buildBotAvatar(scaleW),
          const SizedBox(width: 8),

          // Message bubble
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    text,
                    style: GoogleFonts.inter(
                      fontSize: 13.5 * scaleW.clamp(0.85, 1.2),
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF333333),
                      height: 1.4,
                    ),
                  ),

                  // Embedded Tool Card (Bid Calculator Tool)
                  if (hasToolCard) ...[
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9FAFB),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEBF4FE),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Icon(
                                  Icons.calculate_outlined,
                                  color: primaryBlue,
                                  size: 18,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Bid Calculator Tool',
                                style: GoogleFonts.inter(
                                  fontSize: 13 * scaleW.clamp(0.85, 1.2),
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF1E2638),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Estimate your returns instantly.',
                            style: GoogleFonts.inter(
                              fontSize: 12 * scaleW.clamp(0.85, 1.2),
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFF6B7280),
                            ),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: double.infinity,
                            height: 36,
                            child: OutlinedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const CalculatorScreen(),
                                  ),
                                );
                              },
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(
                                    color: primaryBlue, width: 1.2),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: EdgeInsets.zero,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Open Calculator',
                                    style: GoogleFonts.inter(
                                      fontSize: 13 * scaleW.clamp(0.85, 1.2),
                                      fontWeight: FontWeight.w600,
                                      color: primaryBlue,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  const Icon(
                                    Icons.arrow_forward,
                                    size: 16,
                                    color: primaryBlue,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBotAvatar(double scaleW) {
    return Container(
      width: 28 * scaleW.clamp(0.85, 1.2),
      height: 28 * scaleW.clamp(0.85, 1.2),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: primaryBlue, width: 1.5),
        color: Colors.white,
      ),
      padding: const EdgeInsets.all(2),
      child: ClipOval(
        child: Image.asset(
          'assets/images/roboto.png',
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget _buildDot() {
    return Container(
      width: 5,
      height: 5,
      decoration: const BoxDecoration(
        color: Color(0xFF9CA3AF),
        shape: BoxShape.circle,
      ),
    );
  }

  // Top Status Bar widget matching user screenshot (11:11 AM, icons, 5G, signal, battery 50%)
  Widget _buildTopStatusBar(BuildContext context, double statusBarH) {
    final Size screenSize = MediaQuery.of(context).size;
    final double scaleW = screenSize.width / 360.0;

    return Container(
      width: screenSize.width,
      height: statusBarH,
      color: const Color(0xFF0D1519),
      padding: EdgeInsets.symmetric(horizontal: 14 * scaleW.clamp(0.85, 1.2)),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left side: 11:11 AM, Camera, Chat bubble icons
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '11:11 AM',
                style: GoogleFonts.inter(
                  fontSize: 11.5 * scaleW.clamp(0.85, 1.2),
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  height: 1.0,
                ),
              ),
              SizedBox(width: 6 * scaleW.clamp(0.85, 1.2)),
              Icon(
                Icons.camera_alt_outlined,
                size: 13 * scaleW.clamp(0.85, 1.2),
                color: Colors.white.withValues(alpha: 0.9),
              ),
              SizedBox(width: 5 * scaleW.clamp(0.85, 1.2)),
              Icon(
                Icons.chat_bubble_outline_rounded,
                size: 12.5 * scaleW.clamp(0.85, 1.2),
                color: Colors.white.withValues(alpha: 0.9),
              ),
            ],
          ),

          // Right side: 5G, cellular signal, battery with 50%
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '5G',
                style: GoogleFonts.inter(
                  fontSize: 10.5 * scaleW.clamp(0.85, 1.2),
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  height: 1.0,
                ),
              ),
              SizedBox(width: 4 * scaleW.clamp(0.85, 1.2)),
              Icon(
                Icons.signal_cellular_alt,
                size: 13.5 * scaleW.clamp(0.85, 1.2),
                color: Colors.white,
              ),
              SizedBox(width: 5 * scaleW.clamp(0.85, 1.2)),
              // Battery icon
              Container(
                width: 19 * scaleW.clamp(0.85, 1.2),
                height: 9.5 * scaleW.clamp(0.85, 1.2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2.5),
                  border: Border.all(color: Colors.white, width: 1.1),
                ),
                padding: const EdgeInsets.all(1.2),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    width: 8 * scaleW.clamp(0.85, 1.2),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(1),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 4 * scaleW.clamp(0.85, 1.2)),
              Text(
                '50%',
                style: GoogleFonts.inter(
                  fontSize: 10.5 * scaleW.clamp(0.85, 1.2),
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  height: 1.0,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Floating Robot Icon Widget with micro animations
class CustomBotIcon extends StatefulWidget {
  final double size;
  final VoidCallback? onTap;

  const CustomBotIcon({
    super.key,
    this.size = 50,
    this.onTap,
  });

  @override
  State<CustomBotIcon> createState() => _CustomBotIconState();
}

class _CustomBotIconState extends State<CustomBotIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _shakeAnimation;
  late final Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat();

    _shakeAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: -0.10)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 15,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: -0.10, end: 0.10)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 20,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.10, end: -0.06)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 15,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: -0.06, end: 0.0)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 15,
      ),
      TweenSequenceItem(
        tween: ConstantTween<double>(0.0),
        weight: 35,
      ),
    ]).animate(_controller);

    _bounceAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: -4.0)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: -4.0, end: 2.0)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 35,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 2.0, end: 0.0)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 35,
      ),
    ]).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _bounceAnimation.value),
          child: Transform.rotate(
            angle: _shakeAnimation.value,
            alignment: Alignment.bottomCenter,
            child: child,
          ),
        );
      },
      child: GestureDetector(
        onTap: () {
          if (widget.onTap != null) {
            widget.onTap!();
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ChatbotScreen()),
            );
          }
        },
        child: Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            border: Border.all(color: const Color(0xFF3C93F4), width: 2),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF3C93F4).withValues(alpha: 0.3),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          padding: const EdgeInsets.all(4),
          child: ClipOval(
            child: Image.asset(
              'assets/images/roboto.png',
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
