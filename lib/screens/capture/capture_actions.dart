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

/// Premium mood selector with direct selection
class _PremiumMoodSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final moodOptions = MoodUtils.allMoodOptions;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    (isDark ? AppColors.darkPrimary : AppColors.lightPrimary)
                        .withValues(alpha: 0.1),
                    Colors.transparent,
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.flash_on_rounded,
                size: 18,
                color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Quick Action',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Mood options in organized rows (3x3 grid layout)
        Column(
          children: [
            // First row - 3 moods
            Row(
              children: [
                Expanded(child: _MoodOptionButton(mood: moodOptions[0])),
                const SizedBox(width: 12),
                Expanded(child: _MoodOptionButton(mood: moodOptions[1])),
                const SizedBox(width: 12),
                Expanded(child: _MoodOptionButton(mood: moodOptions[2])),
              ],
            ),
            const SizedBox(height: 12),
            // Second row - 3 moods
            Row(
              children: [
                Expanded(child: _MoodOptionButton(mood: moodOptions[3])),
                const SizedBox(width: 12),
                Expanded(child: _MoodOptionButton(mood: moodOptions[4])),
                const SizedBox(width: 12),
                Expanded(child: _MoodOptionButton(mood: moodOptions[5])),
              ],
            ),
            const SizedBox(height: 12),
            // Third row - 3 moods
            Row(
              children: [
                Expanded(child: _MoodOptionButton(mood: moodOptions[6])),
                const SizedBox(width: 12),
                Expanded(child: _MoodOptionButton(mood: moodOptions[7])),
                const SizedBox(width: 12),
                Expanded(child: _MoodOptionButton(mood: moodOptions[8])),
              ],
            ),
          ],
        ),
      ],
    );
  }
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

  void _handleMoodSelection() async {
    AppLogger.userAction('Mood selected: ${widget.mood.label}');
    HapticFeedback.lightImpact();

    try {
      // Get MomentStore instance
      final momentStore = Provider.of<MomentStore>(context, listen: false);

      // Create a new moment with just the emoji and mood
      final newMoment = Moment(
        content:
            '${widget.mood.label} ${widget.mood.emoji}', // Use emoji as content
        moods: [widget.mood.label], // Add the mood
        tags: [], // No tags for quick emoji moments
        images: [], // No media attachments
        audios: [],
        videos: [],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Save the moment
      final success = await momentStore.createMoment(newMoment);

      if (success && mounted) {
        // Show success feedback
        SnackBarHelper.showSuccess(
          context,
          'Moment "${widget.mood.emoji}" created successfully',
        );

        // Navigate back to home
        if (AppRoutes.canPop(context)) {
          AppRoutes.pop(context);
        } else {
          AppRoutes.toHome(context);
        }
      } else if (mounted) {
        // Show error if creation failed
        SnackBarHelper.showError(context, 'Failed to create moment');
      }
    } catch (e) {
      AppLogger.error('Failed to create emoji moment', e);
      if (mounted) {
        SnackBarHelper.showError(context, 'Failed to create moment: $e');
      }
    }
  }
}
