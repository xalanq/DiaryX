part of 'report_screen.dart';

/// Premium stats overview with beautiful design
class _PremiumStatsOverview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _PremiumStatCard(
                title: 'Total Moments',
                value: '0',
                icon: Icons.book_rounded,
                gradient: [const Color(0xFF667EEA), const Color(0xFF764BA2)],
                iconBg: const Color(0xFF667EEA),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _PremiumStatCard(
                title: 'This Week',
                value: '0',
                icon: Icons.calendar_month_rounded,
                gradient: [const Color(0xFF11998E), const Color(0xFF38EF7D)],
                iconBg: const Color(0xFF11998E),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _PremiumStatCard(
                title: 'Streak',
                value: '0 days',
                icon: Icons.local_fire_department_rounded,
                gradient: [const Color(0xFFFF6B6B), const Color(0xFFFFE66D)],
                iconBg: const Color(0xFFFF6B6B),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _PremiumStatCard(
                title: 'Avg. Mood',
                value: 'N/A',
                icon: Icons.sentiment_satisfied_rounded,
                gradient: [const Color(0xFF8B5CF6), const Color(0xFFD946EF)],
                iconBg: const Color(0xFF8B5CF6),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Beautiful premium statistics card with modern design
class _PremiumStatCard extends StatefulWidget {
  final String title;
  final String value;
  final IconData icon;
  final List<Color> gradient;
  final Color iconBg;

  const _PremiumStatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.gradient,
    required this.iconBg,
  });

  @override
  State<_PremiumStatCard> createState() => _PremiumStatCardState();
}

class _PremiumStatCardState extends State<_PremiumStatCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

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
    final isDark = theme.brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTapDown: (_) => _controller.forward(),
            onTapUp: (_) => _controller.reverse(),
            onTapCancel: () => _controller.reverse(),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: widget.gradient
                      .map(
                        (color) => color.withValues(alpha: isDark ? 0.8 : 0.9),
                      )
                      .toList(),
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: widget.gradient.first.withValues(alpha: 0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.black.withValues(alpha: 0.2)
                      : Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.2),
                    width: 1.5,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Modern icon design
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.3),
                            width: 1,
                          ),
                        ),
                        child: Icon(widget.icon, size: 24, color: Colors.white),
                      ),

                      const SizedBox(height: 16),

                      // Title with modern typography
                      Text(
                        widget.title,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Colors.white.withValues(alpha: 0.9),
                          height: 1.2,
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Value display with emphasis
                      Text(
                        widget.value,
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          height: 0.9,
                          color: Colors.white,
                          fontSize: 28,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
