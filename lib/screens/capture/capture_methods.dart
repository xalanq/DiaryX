part of 'capture_screen.dart';

/// Premium capture method selection section
class _PremiumCaptureSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Main capture buttons
        Row(
          children: [
            Expanded(
              child: _PremiumCaptureButton(
                icon: Icons.mic_rounded,
                title: 'Voice',
                subtitle: 'Record audio',
                color: Colors.blue,
                onTap: () {
                  AppLogger.userAction('Voice capture selected');
                  _showComingSoon(context, 'Voice Recording');
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _PremiumCaptureButton(
                icon: Icons.camera_alt_rounded,
                title: 'Photo',
                subtitle: 'Take picture',
                color: Colors.green,
                onTap: () {
                  AppLogger.userAction('Photo capture selected');
                  _showComingSoon(context, 'Photo Capture');
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _PremiumCaptureButton(
                icon: Icons.edit_rounded,
                title: 'Text',
                subtitle: 'Write it down',
                color: Colors.orange,
                onTap: () {
                  AppLogger.userAction('Text capture selected');
                  _showComingSoon(context, 'Text Moment');
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _PremiumCaptureButton(
                icon: Icons.videocam_rounded,
                title: 'Video',
                subtitle: 'Record moment',
                color: Colors.purple,
                onTap: () {
                  AppLogger.userAction('Video capture selected');
                  _showComingSoon(context, 'Video Recording');
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showComingSoon(BuildContext context, String feature) {
    HapticFeedback.lightImpact();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Coming Soon'),
        content: Text('$feature will be available in future updates.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

/// Premium capture button with animations
class _PremiumCaptureButton extends StatefulWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _PremiumCaptureButton({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  State<_PremiumCaptureButton> createState() => _PremiumCaptureButtonState();
}

class _PremiumCaptureButtonState extends State<_PremiumCaptureButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTapDown: (_) {
              setState(() => _isPressed = true);
              _controller.forward();
            },
            onTapUp: (_) {
              setState(() => _isPressed = false);
              _controller.reverse();
              widget.onTap();
            },
            onTapCancel: () {
              setState(() => _isPressed = false);
              _controller.reverse();
            },
            child: PremiumGlassCard(
              padding: const EdgeInsets.all(20),
              hasGradient: true,
              gradientColors: _isPressed
                  ? [
                      widget.color.withValues(alpha: 0.15),
                      widget.color.withValues(alpha: 0.08),
                    ]
                  : [
                      widget.color.withValues(alpha: 0.1),
                      widget.color.withValues(alpha: 0.05),
                    ],
              child: Column(
                children: [
                  // Icon with background
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          widget.color.withValues(alpha: 0.2),
                          widget.color.withValues(alpha: 0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: widget.color.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: Icon(widget.icon, size: 28, color: widget.color),
                  ),
                  const SizedBox(height: 16),

                  // Title
                  Text(
                    widget.title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Subtitle
                  Text(
                    widget.subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.textTheme.bodySmall?.color?.withValues(
                        alpha: 0.7,
                      ),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
