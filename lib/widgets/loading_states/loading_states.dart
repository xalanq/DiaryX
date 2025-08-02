import 'package:flutter/material.dart';
import '../../themes/app_colors.dart';
import '../../consts/env_config.dart';

/// Custom loading indicator following the app's design
class AppLoadingIndicator extends StatelessWidget {
  final double size;
  final Color? color;
  final String? message;

  const AppLoadingIndicator({
    super.key,
    this.size = 24,
    this.color,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            valueColor: AlwaysStoppedAnimation<Color>(
              color ??
                  (isDark ? AppColors.darkPrimary : AppColors.lightPrimary),
            ),
          ),
        ),
        if (message != null) ...[
          const SizedBox(height: 16),
          Text(
            message!,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }
}

/// Full screen loading overlay
class LoadingOverlay extends StatelessWidget {
  final String? message;
  final bool showBackground;

  const LoadingOverlay({super.key, this.message, this.showBackground = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: showBackground
          ? Colors.black.withOpacity(0.3)
          : Colors.transparent,
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: AppLoadingIndicator(size: 32, message: message),
        ),
      ),
    );
  }
}

/// Skeleton loading for list items
class SkeletonLoader extends StatefulWidget {
  final double width;
  final double height;
  final BorderRadius? borderRadius;

  const SkeletonLoader({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius,
  });

  @override
  State<SkeletonLoader> createState() => _SkeletonLoaderState();
}

class _SkeletonLoaderState extends State<SkeletonLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: EnvConfig.longAnimationDuration,
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.3, end: 0.7).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: (isDark ? Colors.grey[800] : Colors.grey[300])?.withOpacity(
              _animation.value,
            ),
            borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
          ),
        );
      },
    );
  }
}

/// Skeleton loader for entry cards
class EntryCardSkeleton extends StatelessWidget {
  const EntryCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const SkeletonLoader(
                width: 12,
                height: 12,
                borderRadius: BorderRadius.all(Radius.circular(6)),
              ),
              const SizedBox(width: 8),
              const SkeletonLoader(width: 80, height: 12),
              const Spacer(),
              SkeletonLoader(
                width: 60,
                height: 12,
                borderRadius: BorderRadius.circular(6),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const SkeletonLoader(width: double.infinity, height: 16),
          const SizedBox(height: 8),
          const SkeletonLoader(width: 200, height: 16),
          const SizedBox(height: 8),
          const SkeletonLoader(width: 150, height: 16),
          const SizedBox(height: 12),
          Row(
            children: [
              SkeletonLoader(
                width: 50,
                height: 20,
                borderRadius: BorderRadius.circular(10),
              ),
              const SizedBox(width: 8),
              SkeletonLoader(
                width: 60,
                height: 20,
                borderRadius: BorderRadius.circular(10),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Loading state for lists
class ListLoadingState extends StatelessWidget {
  final int itemCount;
  final Widget Function() itemBuilder;

  const ListLoadingState({
    super.key,
    this.itemCount = 5,
    required this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: itemCount,
      itemBuilder: (context, index) => itemBuilder(),
    );
  }
}

/// Simple pulse animation widget
class PulseAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;

  const PulseAnimation({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 1000),
  });

  @override
  State<PulseAnimation> createState() => _PulseAnimationState();
}

class _PulseAnimationState extends State<PulseAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: widget.duration,
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Opacity(opacity: _animation.value, child: widget.child);
      },
    );
  }
}
