import 'dart:ui';
import 'package:flutter/material.dart';
import '../../themes/app_colors.dart';

/// Premium gradient background components
class GradientBackground extends StatelessWidget {
  final Widget child;
  final List<Color>? colors;
  final AlignmentGeometry begin;
  final AlignmentGeometry end;
  final List<double>? stops;
  final bool hasBlur;
  final double blurStrength;
  final bool isAnimated;

  const GradientBackground({
    super.key,
    required this.child,
    this.colors,
    this.begin = Alignment.topLeft,
    this.end = Alignment.bottomRight,
    this.stops,
    this.hasBlur = false,
    this.blurStrength = 5.0,
    this.isAnimated = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final defaultColors = isDark
        ? [
            AppColors.darkBackground,
            AppColors.darkSurface.withValues(alpha: 0.8),
            AppColors.darkBackground,
          ]
        : [
            AppColors.lightBackground,
            AppColors.lightSurface.withValues(alpha: 0.9),
            AppColors.lightBackground,
          ];

    Widget background = Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: begin,
          end: end,
          colors: colors ?? defaultColors,
          stops: stops ?? [0.0, 0.5, 1.0],
        ),
      ),
      child: child,
    );

    if (hasBlur) {
      background = BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurStrength, sigmaY: blurStrength),
        child: background,
      );
    }

    if (isAnimated) {
      return _AnimatedGradientBackground(
        colors: colors ?? defaultColors,
        begin: begin,
        end: end,
        stops: stops,
        child: child,
      );
    }

    return background;
  }
}

/// Animated gradient background
class _AnimatedGradientBackground extends StatefulWidget {
  final Widget child;
  final List<Color> colors;
  final AlignmentGeometry begin;
  final AlignmentGeometry end;
  final List<double>? stops;

  const _AnimatedGradientBackground({
    required this.child,
    required this.colors,
    required this.begin,
    required this.end,
    this.stops,
  });

  @override
  State<_AnimatedGradientBackground> createState() =>
      _AnimatedGradientBackgroundState();
}

class _AnimatedGradientBackgroundState
    extends State<_AnimatedGradientBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(
      begin: 0.0,
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
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.lerp(
                widget.begin as Alignment,
                widget.end as Alignment,
                _animation.value * 0.3,
              )!,
              end: Alignment.lerp(
                widget.end as Alignment,
                widget.begin as Alignment,
                _animation.value * 0.3,
              )!,
              colors: widget.colors,
              stops: widget.stops,
            ),
          ),
          child: widget.child,
        );
      },
    );
  }
}

/// Mesh gradient background for premium look
class MeshGradientBackground extends StatefulWidget {
  final Widget child;
  final bool isDark;
  final bool isAnimated;

  const MeshGradientBackground({
    super.key,
    required this.child,
    this.isDark = false,
    this.isAnimated = true,
  });

  @override
  State<MeshGradientBackground> createState() => _MeshGradientBackgroundState();
}

class _MeshGradientBackgroundState extends State<MeshGradientBackground>
    with TickerProviderStateMixin {
  late AnimationController _controller1;
  late AnimationController _controller2;
  late AnimationController _controller3;

  @override
  void initState() {
    super.initState();

    if (widget.isAnimated) {
      _controller1 = AnimationController(
        duration: const Duration(seconds: 12),
        vsync: this,
      )..repeat(reverse: true);

      _controller2 = AnimationController(
        duration: const Duration(seconds: 8),
        vsync: this,
      )..repeat(reverse: true);

      _controller3 = AnimationController(
        duration: const Duration(seconds: 15),
        vsync: this,
      )..repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    if (widget.isAnimated) {
      _controller1.dispose();
      _controller2.dispose();
      _controller3.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isAnimated) {
      return Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topLeft,
            radius: 1.5,
            colors: widget.isDark
                ? [
                    AppColors.darkPrimary.withValues(alpha: 0.1),
                    AppColors.darkBackground,
                  ]
                : [
                    AppColors.lightPrimary.withValues(alpha: 0.1),
                    AppColors.lightBackground,
                  ],
          ),
        ),
        child: widget.child,
      );
    }

    return AnimatedBuilder(
      animation: Listenable.merge([_controller1, _controller2, _controller3]),
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.lerp(
                Alignment.topLeft,
                Alignment.topRight,
                _controller1.value,
              )!,
              radius: 1.0 + _controller2.value * 0.5,
              colors: widget.isDark
                  ? [
                      Color.lerp(
                        AppColors.darkPrimary.withValues(alpha: 0.1),
                        AppColors.darkAccent.withValues(alpha: 0.1),
                        _controller3.value,
                      )!,
                      AppColors.darkBackground,
                    ]
                  : [
                      Color.lerp(
                        AppColors.lightPrimary.withValues(alpha: 0.1),
                        AppColors.lightAccent.withValues(alpha: 0.1),
                        _controller3.value,
                      )!,
                      AppColors.lightBackground,
                    ],
            ),
          ),
          child: widget.child,
        );
      },
    );
  }
}

/// Glass overlay with gradient effect
class GlassOverlay extends StatelessWidget {
  final Widget child;
  final double opacity;
  final double blur;
  final List<Color>? gradientColors;
  final bool hasGradient;

  const GlassOverlay({
    super.key,
    required this.child,
    this.opacity = 0.1,
    this.blur = 10,
    this.gradientColors,
    this.hasGradient = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          decoration: BoxDecoration(
            gradient: hasGradient
                ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors:
                        gradientColors ??
                        (isDark
                            ? [
                                Colors.white.withValues(alpha: opacity),
                                Colors.white.withValues(alpha: opacity * 0.5),
                              ]
                            : [
                                Colors.white.withValues(alpha: opacity + 0.1),
                                Colors.white.withValues(alpha: opacity),
                              ]),
                  )
                : null,
            color: hasGradient
                ? null
                : (isDark
                      ? Colors.white.withValues(alpha: opacity)
                      : Colors.white.withValues(alpha: opacity + 0.1)),
          ),
          child: child,
        ),
      ),
    );
  }
}

/// Premium card background with multiple gradient layers
class PremiumCardBackground extends StatelessWidget {
  final Widget child;
  final bool isDark;
  final bool hasGlow;
  final double borderRadius;

  const PremiumCardBackground({
    super.key,
    required this.child,
    this.isDark = false,
    this.hasGlow = false,
    this.borderRadius = 20,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  AppColors.darkSurface.withValues(alpha: 0.9),
                  AppColors.darkSurface.withValues(alpha: 0.7),
                ]
              : [
                  AppColors.lightSurface.withValues(alpha: 0.95),
                  AppColors.lightSurface.withValues(alpha: 0.85),
                ],
        ),
        boxShadow: hasGlow
            ? [
                BoxShadow(
                  color:
                      (isDark ? AppColors.darkPrimary : AppColors.lightPrimary)
                          .withValues(alpha: 0.2),
                  blurRadius: 20,
                  spreadRadius: -5,
                  offset: const Offset(0, 10),
                ),
              ]
            : null,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.1)
                    : Colors.white.withValues(alpha: 0.3),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

/// Floating gradient orb
class FloatingGradientOrb extends StatefulWidget {
  final double size;
  final List<Color> colors;
  final Duration duration;
  final bool isAnimated;

  const FloatingGradientOrb({
    super.key,
    this.size = 100,
    required this.colors,
    this.duration = const Duration(seconds: 4),
    this.isAnimated = true,
  });

  @override
  State<FloatingGradientOrb> createState() => _FloatingGradientOrbState();
}

class _FloatingGradientOrbState extends State<FloatingGradientOrb>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    if (widget.isAnimated) {
      _controller = AnimationController(duration: widget.duration, vsync: this)
        ..repeat(reverse: true);

      _scaleAnimation = Tween<double>(
        begin: 0.8,
        end: 1.2,
      ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

      _opacityAnimation = Tween<double>(
        begin: 0.3,
        end: 0.7,
      ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    }
  }

  @override
  void dispose() {
    if (widget.isAnimated) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isAnimated) {
      return Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(colors: widget.colors),
        ),
      );
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Opacity(
            opacity: _opacityAnimation.value,
            child: Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: widget.colors
                      .map(
                        (color) => color.withValues(
                          alpha: color.a * _opacityAnimation.value,
                        ),
                      )
                      .toList(),
                ),
                boxShadow: [
                  BoxShadow(
                    color: widget.colors.first.withValues(alpha: 0.3),
                    blurRadius: 30 * _scaleAnimation.value,
                    spreadRadius: 10 * _scaleAnimation.value,
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

/// Premium screen background wrapper
class PremiumScreenBackground extends StatelessWidget {
  final Widget child;
  final bool hasFloatingOrbs;
  final bool hasMeshGradient;
  final bool hasGeometricElements;

  const PremiumScreenBackground({
    super.key,
    required this.child,
    this.hasFloatingOrbs = true,
    this.hasMeshGradient = true,
    this.hasGeometricElements = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;

    return Stack(
      children: [
        // Base mesh gradient
        if (hasMeshGradient)
          Positioned.fill(
            child: MeshGradientBackground(isDark: isDark, child: Container()),
          ),

        // Floating orbs
        if (hasFloatingOrbs) ...[
          Positioned(
            top: size.height * 0.1,
            right: -50,
            child: FloatingGradientOrb(
              size: 150,
              colors: isDark
                  ? [
                      AppColors.darkPrimary.withValues(alpha: 0.1),
                      AppColors.darkAccent.withValues(alpha: 0.05),
                    ]
                  : [
                      AppColors.lightPrimary.withValues(alpha: 0.1),
                      AppColors.lightAccent.withValues(alpha: 0.05),
                    ],
              duration: const Duration(seconds: 6),
            ),
          ),
          Positioned(
            bottom: size.height * 0.2,
            left: -30,
            child: FloatingGradientOrb(
              size: 100,
              colors: isDark
                  ? [
                      AppColors.darkSecondary.withValues(alpha: 0.08),
                      Colors.transparent,
                    ]
                  : [
                      AppColors.lightSecondary.withValues(alpha: 0.08),
                      Colors.transparent,
                    ],
              duration: const Duration(seconds: 8),
            ),
          ),
        ],

        // Content
        Positioned.fill(child: child),
      ],
    );
  }
}
