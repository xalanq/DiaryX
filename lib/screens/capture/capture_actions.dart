part of 'capture_screen.dart';

/// Premium quick actions section
class _PremiumQuickActions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PremiumGlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Mood selection grid (no header)
          _PremiumMoodSelector(),
        ],
      ),
    );
  }
}

/// Premium quick action item
class _PremiumQuickActionItem extends StatefulWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _PremiumQuickActionItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  State<_PremiumQuickActionItem> createState() =>
      _PremiumQuickActionItemState();
}

class _PremiumQuickActionItemState extends State<_PremiumQuickActionItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.onTap,
              onTapDown: (_) => _controller.forward(),
              onTapUp: (_) => _controller.reverse(),
              onTapCancel: () => _controller.reverse(),
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  children: [
                    // Enhanced icon
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          colors: [
                            (isDark
                                    ? AppColors.darkPrimary
                                    : AppColors.lightPrimary)
                                .withValues(alpha: 0.1),
                            Colors.transparent,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        widget.icon,
                        size: 20,
                        color: isDark
                            ? AppColors.darkPrimary
                            : AppColors.lightPrimary,
                      ),
                    ),
                    const SizedBox(width: 16),

                    // Text content
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.title,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            widget.subtitle,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.textTheme.bodySmall?.color
                                  ?.withValues(alpha: 0.7),
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Chevron
                    Icon(
                      Icons.chevron_right_rounded,
                      size: 20,
                      color: theme.textTheme.bodyMedium?.color?.withValues(
                        alpha: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Premium recent moments section
class _PremiumRecentMoments extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return PremiumGlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        colors: [
                          (isDark
                                  ? AppColors.darkPrimary
                                  : AppColors.lightPrimary)
                              .withValues(alpha: 0.1),
                          Colors.transparent,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.history_rounded,
                      size: 18,
                      color: isDark
                          ? AppColors.darkPrimary
                          : AppColors.lightPrimary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Recent Moments',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {
                  AppLogger.userAction('View all moments from capture');
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                ),
                child: Text(
                  'View All',
                  style: TextStyle(
                    color: isDark
                        ? AppColors.darkPrimary
                        : AppColors.lightPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Empty state with beautiful design
          Center(
            child: Column(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      colors: [
                        (isDark
                                ? AppColors.darkSurface
                                : AppColors.lightSurface)
                            .withValues(alpha: 0.5),
                        Colors.transparent,
                      ],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.auto_stories_outlined,
                    size: 28,
                    color: theme.textTheme.bodyMedium?.color?.withValues(
                      alpha: 0.4,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'No recent moments',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: theme.textTheme.bodyMedium?.color?.withValues(
                      alpha: 0.7,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Start capturing your thoughts',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.textTheme.bodySmall?.color?.withValues(
                      alpha: 0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 16), // Additional bottom spacing
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Premium mood selector with direct selection
class _PremiumMoodSelector extends StatelessWidget {
  final List<MoodOption> _moodOptions = [
    MoodOption(emoji: '😊', label: 'Happy', color: Colors.green),
    MoodOption(emoji: '😢', label: 'Sad', color: Colors.blue),
    MoodOption(emoji: '😴', label: 'Calm', color: Colors.indigo),
    MoodOption(emoji: '🎉', label: 'Excited', color: Colors.orange),
    MoodOption(emoji: '😰', label: 'Anxious', color: Colors.red),
    MoodOption(emoji: '🤔', label: 'Thoughtful', color: Colors.purple),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'How are you feeling?',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: Theme.of(
              context,
            ).textTheme.bodyLarge?.color?.withValues(alpha: 0.8),
          ),
        ),
        const SizedBox(height: 16),

        // Mood options in organized rows
        Column(
          children: [
            // First row - 3 moods
            Row(
              children: [
                Expanded(child: _MoodOptionButton(mood: _moodOptions[0])),
                const SizedBox(width: 12),
                Expanded(child: _MoodOptionButton(mood: _moodOptions[1])),
                const SizedBox(width: 12),
                Expanded(child: _MoodOptionButton(mood: _moodOptions[2])),
              ],
            ),
            const SizedBox(height: 12),
            // Second row - 3 moods
            Row(
              children: [
                Expanded(child: _MoodOptionButton(mood: _moodOptions[3])),
                const SizedBox(width: 12),
                Expanded(child: _MoodOptionButton(mood: _moodOptions[4])),
                const SizedBox(width: 12),
                Expanded(child: _MoodOptionButton(mood: _moodOptions[5])),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

/// Mood option data class
class MoodOption {
  final String emoji;
  final String label;
  final Color color;

  MoodOption({required this.emoji, required this.label, required this.color});
}

/// Individual mood option button
class _MoodOptionButton extends StatefulWidget {
  final MoodOption mood;

  const _MoodOptionButton({required this.mood});

  @override
  State<_MoodOptionButton> createState() => _MoodOptionButtonState();
}

class _MoodOptionButtonState extends State<_MoodOptionButton>
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
              _handleMoodSelection();
            },
            onTapCancel: () {
              setState(() => _isPressed = false);
              _controller.reverse();
            },
            child: Container(
              height: 70,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: _isPressed
                    ? widget.mood.color.withValues(alpha: 0.15)
                    : widget.mood.color.withValues(alpha: 0.08),
                border: Border.all(
                  color: widget.mood.color.withValues(alpha: 0.25),
                  width: 1,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(widget.mood.emoji, style: const TextStyle(fontSize: 20)),
                  const SizedBox(height: 4),
                  Text(
                    widget.mood.label,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: 11,
                      color: theme.textTheme.bodySmall?.color?.withValues(
                        alpha: 0.8,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _handleMoodSelection() {
    AppLogger.userAction('Mood selected: ${widget.mood.label}');
    HapticFeedback.lightImpact();

    // TODO: Save mood selection to moment or preferences
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Mood "${widget.mood.label}" selected'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
