import 'dart:ui';
import 'dart:math';
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

        // Geometric elements
        if (hasGeometricElements) ...[
          // Wave decoration - bottom right corner
          Positioned(
            bottom: size.height * 0.3,
            right: size.width * 0.15,
            child: _SubtleWave(isDark: isDark),
          ),

          // Triangle - bottom right corner, partially extends beyond screen
          Positioned(
            bottom: size.height * 0.1,
            right: -size.width * 0.05,
            child: _SimpleTriangle(isDark: isDark),
          ),
        ],

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

/// Subtle wave decoration with gradient
class _SubtleWave extends StatefulWidget {
  final bool isDark;

  const _SubtleWave({required this.isDark});

  @override
  State<_SubtleWave> createState() => _SubtleWaveState();
}

class _SubtleWaveState extends State<_SubtleWave>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();

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
        return CustomPaint(
          size: const Size(200, 60),
          painter: _SubtleWavePainter(
            isDark: widget.isDark,
            animationValue: _animation.value,
          ),
        );
      },
    );
  }
}

class _SubtleWavePainter extends CustomPainter {
  final bool isDark;
  final double animationValue;

  _SubtleWavePainter({required this.isDark, required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();
    final amplitude = 15.0;
    final frequency = 2.0;
    final phase = animationValue * 2.0 * pi;

    path.moveTo(0, size.height / 2);

    // Reduce sampling points for better performance
    for (double x = 0; x <= size.width; x += 4) {
      final y =
          size.height / 2 +
          amplitude * sin((x / size.width) * frequency * 2 * pi + phase);
      path.lineTo(x, y);
    }

    final alpha = 0.08 + (animationValue * 0.04);

    // Simplify to single layer drawing while maintaining visual effect
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6.0
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3.0);

    final gradient = LinearGradient(
      colors: [
        (isDark ? AppColors.darkPrimary : AppColors.lightPrimary).withValues(
          alpha: 0.0,
        ),
        (isDark ? AppColors.darkPrimary : AppColors.lightPrimary).withValues(
          alpha: alpha,
        ),
        (isDark ? AppColors.darkPrimary : AppColors.lightPrimary).withValues(
          alpha: 0.0,
        ),
      ],
    );

    paint.shader = gradient.createShader(
      Rect.fromLTWH(0, 0, size.width, size.height),
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// Simple triangle decoration
class _SimpleTriangle extends StatefulWidget {
  final bool isDark;

  const _SimpleTriangle({required this.isDark});

  @override
  State<_SimpleTriangle> createState() => _SimpleTriangleState();
}

class _SimpleTriangleState extends State<_SimpleTriangle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 6),
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
        return CustomPaint(
          size: const Size(140, 120),
          painter: _SimpleTrianglePainter(
            isDark: widget.isDark,
            animationValue: _animation.value,
          ),
        );
      },
    );
  }
}

class _SimpleTrianglePainter extends CustomPainter {
  final bool isDark;
  final double animationValue;

  _SimpleTrianglePainter({required this.isDark, required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final alpha = 0.08 + (animationValue * 0.04);
    final centerX = size.width / 2;
    final centerY = size.height / 2;

    // Rotation angle to make triangle more casual
    final rotation = -0.2 + (animationValue * 0.1);

    // Simplify to 2-layer blur effect while maintaining visual hierarchy
    final layers = [
      {'blur': 25.0, 'alpha': alpha * 0.3, 'scale': 2.5},
      {'blur': 15.0, 'alpha': alpha * 0.6, 'scale': 1.8},
    ];

    for (final layer in layers) {
      final paint = Paint()
        ..style = PaintingStyle.fill
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, layer['blur']!);

      final scale = layer['scale']!;
      final layerAlpha = layer['alpha']!;

      // Save canvas state
      canvas.save();

      // Move to center point then rotate
      canvas.translate(centerX, centerY);
      canvas.rotate(rotation);
      canvas.translate(-centerX, -centerY);

      // Calculate scaled triangle
      final scaledWidth = size.width * scale;
      final scaledHeight = size.height * scale;
      final offsetX = (size.width - scaledWidth) / 2;
      final offsetY = (size.height - scaledHeight) / 2;

      // Create irregular triangle
      final path = Path()
        ..moveTo(centerX, offsetY * 0.8)
        ..lineTo(offsetX + scaledWidth * 1.1, offsetY + scaledHeight)
        ..lineTo(offsetX * 0.9, offsetY + scaledHeight)
        ..close();

      // Simplify gradient effect
      final gradient = RadialGradient(
        center: Alignment.center,
        radius: 1.2,
        colors: [
          (isDark ? AppColors.darkSecondary : AppColors.lightSecondary)
              .withValues(alpha: layerAlpha),
          (isDark ? AppColors.darkSecondary : AppColors.lightSecondary)
              .withValues(alpha: layerAlpha * 0.4),
          (isDark ? AppColors.darkSecondary : AppColors.lightSecondary)
              .withValues(alpha: 0.0),
        ],
        stops: const [0.0, 0.6, 1.0],
      );

      paint.shader = gradient.createShader(
        Rect.fromLTWH(0, 0, size.width, size.height),
      );

      canvas.drawPath(path, paint);

      // Restore canvas state
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// Elegant rectangle decoration
class _ElegantRectangle extends StatefulWidget {
  final bool isDark;

  const _ElegantRectangle({required this.isDark});

  @override
  State<_ElegantRectangle> createState() => _ElegantRectangleState();
}

class _ElegantRectangleState extends State<_ElegantRectangle>
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
        return CustomPaint(
          size: const Size(60, 20),
          painter: _ElegantRectanglePainter(
            isDark: widget.isDark,
            animationValue: _animation.value,
          ),
        );
      },
    );
  }
}

class _ElegantRectanglePainter extends CustomPainter {
  final bool isDark;
  final double animationValue;

  _ElegantRectanglePainter({
    required this.isDark,
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      const Radius.circular(2),
    );

    final alpha = 0.06 + (animationValue * 0.03);

    // Create gradient effect
    final gradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        (isDark ? AppColors.darkAccent : AppColors.lightAccent).withValues(
          alpha: alpha,
        ),
        (isDark ? AppColors.darkAccent : AppColors.lightAccent).withValues(
          alpha: alpha * 0.4,
        ),
      ],
    );

    paint.shader = gradient.createShader(
      Rect.fromLTWH(0, 0, size.width, size.height),
    );

    // Remove shadow effect for better performance
    canvas.drawRRect(rect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// Subtle circle decoration
class _SubtleCircle extends StatefulWidget {
  final bool isDark;

  const _SubtleCircle({required this.isDark});

  @override
  State<_SubtleCircle> createState() => _SubtleCircleState();
}

class _SubtleCircleState extends State<_SubtleCircle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 12),
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
        return CustomPaint(
          size: const Size(40, 40),
          painter: _SubtleCirclePainter(
            isDark: widget.isDark,
            animationValue: _animation.value,
          ),
        );
      },
    );
  }
}

class _SubtleCirclePainter extends CustomPainter {
  final bool isDark;
  final double animationValue;

  _SubtleCirclePainter({required this.isDark, required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final alpha = 0.05 + (animationValue * 0.025);

    // Create radial gradient effect
    final gradient = RadialGradient(
      center: Alignment.center,
      colors: [
        (isDark ? AppColors.darkPrimary : AppColors.lightPrimary).withValues(
          alpha: alpha,
        ),
        (isDark ? AppColors.darkPrimary : AppColors.lightPrimary).withValues(
          alpha: alpha * 0.2,
        ),
      ],
    );

    paint.shader = gradient.createShader(
      Rect.fromCircle(center: center, radius: radius),
    );

    // Remove shadow effect for better performance
    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// Right corner geometry combination
class _RightCornerGeometry extends StatefulWidget {
  final bool isDark;

  const _RightCornerGeometry({required this.isDark});

  @override
  State<_RightCornerGeometry> createState() => _RightCornerGeometryState();
}

class _RightCornerGeometryState extends State<_RightCornerGeometry>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 10),
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
        return CustomPaint(
          size: const Size(80, 60),
          painter: _RightCornerGeometryPainter(
            isDark: widget.isDark,
            animationValue: _animation.value,
          ),
        );
      },
    );
  }
}

class _RightCornerGeometryPainter extends CustomPainter {
  final bool isDark;
  final double animationValue;

  _RightCornerGeometryPainter({
    required this.isDark,
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Small circle - simplified gradient
    final circle1Alpha = 0.08 + (animationValue * 0.04);
    final circleGradient = RadialGradient(
      colors: [
        (isDark ? AppColors.darkPrimary : AppColors.lightPrimary).withValues(
          alpha: circle1Alpha,
        ),
        (isDark ? AppColors.darkPrimary : AppColors.lightPrimary).withValues(
          alpha: circle1Alpha * 0.3,
        ),
      ],
    );

    paint.shader = circleGradient.createShader(
      Rect.fromCircle(center: Offset(20, 15), radius: 8),
    );

    // Remove shadow effect
    canvas.drawCircle(Offset(20, 15), 8, paint);

    // Small rectangle - simplified gradient
    final rectAlpha = 0.06 + ((animationValue + 0.3) % 1.0 * 0.03);
    final rectGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        (isDark ? AppColors.darkSecondary : AppColors.lightSecondary)
            .withValues(alpha: rectAlpha),
        (isDark ? AppColors.darkSecondary : AppColors.lightSecondary)
            .withValues(alpha: rectAlpha * 0.4),
      ],
    );

    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(40, 20, 25, 8),
      const Radius.circular(2),
    );

    paint.shader = rectGradient.createShader(rect.outerRect);

    // Remove shadow effect
    canvas.drawRRect(rect, paint);

    // Simplify line drawing, remove blur effect
    paint
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..shader = null;

    final lineAlpha = 0.04 + ((animationValue + 0.9) % 1.0 * 0.02);
    paint.color = (isDark ? Colors.white : Colors.black).withValues(
      alpha: lineAlpha,
    );

    // Only draw simple lines, remove shadow and blur
    canvas.drawLine(Offset(50, 10), Offset(70, 15), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
