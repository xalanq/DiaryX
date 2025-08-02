import 'dart:ui';
import 'package:flutter/material.dart';
import '../../themes/app_colors.dart';

/// Premium glass morphism card with advanced visual effects
class PremiumGlassCard extends StatefulWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final Color? backgroundColor;
  final double blur;
  final double opacity;
  final VoidCallback? onTap;
  final bool hasShadow;
  final bool hasGradient;
  final List<Color>? gradientColors;
  final bool isFloating;
  final double elevation;
  final bool hasShimmer;

  const PremiumGlassCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius = 20,
    this.backgroundColor,
    this.blur = 15,
    this.opacity = 0.08,
    this.onTap,
    this.hasShadow = true,
    this.hasGradient = false,
    this.gradientColors,
    this.isFloating = true,
    this.elevation = 8,
    this.hasShimmer = false,
  });

  @override
  State<PremiumGlassCard> createState() => _PremiumGlassCardState();
}

class _PremiumGlassCardState extends State<PremiumGlassCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _elevationAnimation =
        Tween<double>(
          begin: widget.elevation,
          end: widget.elevation * 0.6,
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeInOut,
          ),
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
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            margin:
                widget.margin ??
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              boxShadow: widget.hasShadow && widget.isFloating
                  ? [
                      // Primary shadow for depth
                      BoxShadow(
                        color: isDark
                            ? AppColors.shadowDark
                            : AppColors.shadowLight,
                        blurRadius: _elevationAnimation.value,
                        offset: Offset(0, _elevationAnimation.value * 0.3),
                        spreadRadius: -2,
                      ),
                      // Secondary shadow for softness
                      BoxShadow(
                        color: isDark
                            ? Colors.black.withValues(alpha: 0.2)
                            : Colors.black.withValues(alpha: 0.05),
                        blurRadius: _elevationAnimation.value * 2,
                        offset: Offset(0, _elevationAnimation.value * 0.6),
                        spreadRadius: -4,
                      ),
                    ]
                  : null,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: widget.blur,
                  sigmaY: widget.blur,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: widget.hasGradient
                        ? LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors:
                                widget.gradientColors ??
                                AppColors.getGlassMorphismGradient(isDark),
                            stops: const [0.0, 1.0],
                          )
                        : null,
                    color: widget.hasGradient
                        ? null
                        : widget.backgroundColor ??
                              (isDark
                                  ? AppColors.glassDark.withValues(
                                      alpha: widget.opacity + 0.05,
                                    )
                                  : AppColors.glassLight.withValues(
                                      alpha: widget.opacity + 0.85,
                                    )),
                    borderRadius: BorderRadius.circular(widget.borderRadius),
                    border: Border.all(
                      color: isDark
                          ? AppColors.glassBorderDark.withValues(alpha: 0.2)
                          : AppColors.glassBorder.withValues(alpha: 0.4),
                      width: 1.2,
                    ),
                  ),
                  child: widget.hasShimmer
                      ? Stack(
                          children: [
                            Positioned.fill(
                              child: Container(
                                padding:
                                    widget.padding ?? const EdgeInsets.all(20),
                                child: widget.child,
                              ),
                            ),
                            Positioned.fill(
                              child: _ShimmerEffect(
                                borderRadius: widget.borderRadius,
                                isDark: isDark,
                              ),
                            ),
                          ],
                        )
                      : Container(
                          padding: widget.padding ?? const EdgeInsets.all(20),
                          child: widget.child,
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

/// Shimmer effect for premium cards
class _ShimmerEffect extends StatefulWidget {
  final double borderRadius;
  final bool isDark;

  const _ShimmerEffect({required this.borderRadius, required this.isDark});

  @override
  State<_ShimmerEffect> createState() => _ShimmerEffectState();
}

class _ShimmerEffectState extends State<_ShimmerEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();

    _animation = Tween<double>(
      begin: -1.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          child: Transform.translate(
            offset: Offset(_animation.value * 300, 0),
            child: Container(
              width: 100,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: widget.isDark
                      ? [
                          Colors.transparent,
                          Colors.white.withValues(alpha: 0.02),
                          Colors.transparent,
                        ]
                      : [
                          Colors.transparent,
                          Colors.white.withValues(alpha: 0.3),
                          Colors.transparent,
                        ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Premium action card with glass morphism
class PremiumActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  final Color? iconColor;
  final bool hasGradient;
  final bool hasShimmer;

  const PremiumActionCard({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
    this.iconColor,
    this.hasGradient = true,
    this.hasShimmer = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return PremiumGlassCard(
      onTap: onTap,
      hasGradient: hasGradient,
      hasShimmer: hasShimmer,
      gradientColors: hasGradient ? AppColors.getPrimaryGradient(isDark) : null,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icon container with floating effect
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [
                  (iconColor ?? AppColors.lightPrimary).withValues(alpha: 0.2),
                  (iconColor ?? AppColors.lightPrimary).withValues(alpha: 0.05),
                ],
                stops: const [0.0, 1.0],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: (iconColor ?? AppColors.lightPrimary).withValues(
                    alpha: 0.1,
                  ),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              icon,
              size: 36,
              color:
                  iconColor ??
                  (isDark ? AppColors.darkPrimary : AppColors.lightPrimary),
            ),
          ),
          const SizedBox(height: 20),
          // Title
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              letterSpacing: -0.2,
            ),
            textAlign: TextAlign.center,
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 6),
            Text(
              subtitle!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.7),
                letterSpacing: 0.1,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}

/// Premium moment card for timeline
class PremiumMomentCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool isSelected;
  final String? mood;

  const PremiumMomentCard({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.isSelected = false,
    this.mood,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return PremiumGlassCard(
      onTap: onTap,
      hasGradient: isSelected,
      gradientColors: isSelected
          ? (isDark
                ? [
                    AppColors.darkPrimary.withValues(alpha: 0.3),
                    AppColors.darkAccent.withValues(alpha: 0.1),
                  ]
                : [
                    AppColors.lightPrimary.withValues(alpha: 0.2),
                    AppColors.lightAccent.withValues(alpha: 0.1),
                  ])
          : null,
      child: GestureDetector(
        onLongPress: onLongPress,
        child: Stack(
          children: [
            child,
            // Mood indicator with glow effect
            if (mood != null)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: AppColors.getEmotionColor(mood!),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.getEmotionColor(
                          mood!,
                        ).withValues(alpha: 0.6),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
