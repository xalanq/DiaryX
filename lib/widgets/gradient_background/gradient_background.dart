import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';
import '../../themes/app_colors.dart';

/// Global animation configuration
class _AnimationConfig {
  static const int targetFPS = 15;
  static const Duration frameInterval = Duration(
    milliseconds: 1000 ~/ targetFPS,
  );
}

/// Utility class for creating common tweens
class _AnimationTweens {
  // 基础往返Tween (0.0 → 1.0 → 0.0)
  static Tween<double> reversible({double begin = 0.0, double end = 1.0}) {
    return Tween<double>(begin: begin, end: end);
  }

  // Scale变化Tween (0.8 → 1.2)
  static Tween<double> get scale => Tween<double>(begin: 0.8, end: 1.2);

  // Opacity变化Tween (0.3 → 0.7)
  static Tween<double> get opacity => Tween<double>(begin: 0.3, end: 0.7);

  // Alignment插值Tween
  static AlignmentTween alignmentLerp({
    required Alignment begin,
    required Alignment end,
  }) {
    return AlignmentTween(begin: begin, end: end);
  }

  // 颜色插值Tween
  static ColorTween colorLerp({required Color begin, required Color end}) {
    return ColorTween(begin: begin, end: end);
  }

  // 往返进度计算 (处理0→1→0的循环)
  static double reversibleProgress(double totalProgress) {
    if (totalProgress <= 0.5) {
      return totalProgress * 2; // 0 to 1
    } else {
      return 2 - (totalProgress * 2); // 1 to 0
    }
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

class _MeshGradientBackgroundState extends State<MeshGradientBackground> {
  Timer? _timer;
  double _animationValue1 = 0.0;
  double _animationValue2 = 0.0;
  double _animationValue3 = 0.0;
  late DateTime _startTime;

  // 使用Flutter内置Tween替代手动计算
  late final AlignmentTween _alignmentTween;
  late final Tween<double> _radiusTween;
  late final ColorTween _colorTween1;

  @override
  void initState() {
    super.initState();

    // 初始化Tween对象
    _alignmentTween = _AnimationTweens.alignmentLerp(
      begin: Alignment.topLeft,
      end: Alignment.topRight,
    );

    _radiusTween = _AnimationTweens.reversible(begin: 1.0, end: 1.5);

    _colorTween1 = _AnimationTweens.colorLerp(
      begin: widget.isDark
          ? AppColors.darkPrimary.withValues(alpha: 0.1)
          : AppColors.lightPrimary.withValues(alpha: 0.1),
      end: widget.isDark
          ? AppColors.darkAccent.withValues(alpha: 0.1)
          : AppColors.lightAccent.withValues(alpha: 0.1),
    );

    if (widget.isAnimated) {
      _startTime = DateTime.now();

      _timer = Timer.periodic(_AnimationConfig.frameInterval, (timer) {
        final elapsed = DateTime.now().difference(_startTime);
        final totalSeconds = elapsed.inMilliseconds / 1000.0;

        // 使用工具方法计算往返进度
        final progress1 = (totalSeconds % 24) / 24;
        final progress2 = (totalSeconds % 16) / 16;
        final progress3 = (totalSeconds % 30) / 30;

        setState(() {
          _animationValue1 = Curves.easeInOut.transform(
            _AnimationTweens.reversibleProgress(progress1),
          );
          _animationValue2 = Curves.easeInOut.transform(
            _AnimationTweens.reversibleProgress(progress2),
          );
          _animationValue3 = Curves.easeInOut.transform(
            _AnimationTweens.reversibleProgress(progress3),
          );
        });
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
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

    return Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          // 使用AlignmentTween进行插值
          center: _alignmentTween.transform(_animationValue1),
          // 使用Tween进行半径插值
          radius: _radiusTween.transform(_animationValue2),
          colors: [
            // 使用ColorTween进行颜色插值
            _colorTween1.transform(_animationValue3)!,
            widget.isDark
                ? AppColors.darkBackground
                : AppColors.lightBackground,
          ],
        ),
      ),
      child: widget.child,
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

class _FloatingGradientOrbState extends State<FloatingGradientOrb> {
  Timer? _timer;
  double _animationValue = 0.0;
  late DateTime _startTime;

  // 使用Flutter内置Tween
  late final Tween<double> _scaleTween;
  late final Tween<double> _opacityTween;
  late final Tween<double> _blurTween;

  @override
  void initState() {
    super.initState();

    // 初始化Tween对象
    _scaleTween = _AnimationTweens.scale; // 0.8 → 1.2
    _opacityTween = _AnimationTweens.opacity; // 0.3 → 0.7
    _blurTween = _AnimationTweens.reversible(begin: 30.0, end: 40.0); // 模糊半径

    if (widget.isAnimated) {
      _startTime = DateTime.now();

      _timer = Timer.periodic(_AnimationConfig.frameInterval, (timer) {
        final elapsed = DateTime.now().difference(_startTime);
        final totalSeconds = elapsed.inMilliseconds / 1000.0;
        final cycleDuration = widget.duration.inSeconds * 2; // 往返周期
        final progress = (totalSeconds % cycleDuration) / cycleDuration;

        setState(() {
          _animationValue = Curves.easeInOut.transform(
            _AnimationTweens.reversibleProgress(progress),
          );
        });
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
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

    // 使用Tween计算动画值
    final scaleValue = _scaleTween.transform(_animationValue);
    final opacityValue = _opacityTween.transform(_animationValue);
    final blurValue = _blurTween.transform(_animationValue);

    return Transform.scale(
      scale: scaleValue,
      child: Opacity(
        opacity: opacityValue,
        child: Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: widget.colors
                  .map(
                    (color) => color.withValues(alpha: color.a * opacityValue),
                  )
                  .toList(),
            ),
            boxShadow: [
              BoxShadow(
                color: widget.colors.first.withValues(alpha: 0.3),
                blurRadius: blurValue,
                spreadRadius: 10 * scaleValue,
              ),
            ],
          ),
        ),
      ),
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
    this.hasGeometricElements = true,
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
            bottom: size.height * 0.1,
            left: -50,
            child: FloatingGradientOrb(
              size: 100,
              colors: isDark
                  ? [
                      AppColors.darkSecondary.withValues(alpha: 0.1),
                      Colors.transparent,
                    ]
                  : [
                      AppColors.lightPrimary.withValues(alpha: 0.3),
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

class _SubtleWaveState extends State<_SubtleWave> {
  Timer? _timer;
  double _animationValue = 0.0;
  late DateTime _startTime;

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now();

    _timer = Timer.periodic(_AnimationConfig.frameInterval, (timer) {
      final elapsed = DateTime.now().difference(_startTime);
      final totalSeconds = elapsed.inMilliseconds / 1000.0;
      // 20秒周期，不往返
      final progress = (totalSeconds % 20) / 20;

      setState(() {
        _animationValue = progress;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(200, 60),
      painter: _SubtleWavePainter(
        isDark: widget.isDark,
        animationValue: _animationValue,
      ),
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

class _SimpleTriangleState extends State<_SimpleTriangle> {
  Timer? _timer;
  double _animationValue = 0.0;
  late DateTime _startTime;

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now();

    _timer = Timer.periodic(_AnimationConfig.frameInterval, (timer) {
      final elapsed = DateTime.now().difference(_startTime);
      final totalSeconds = elapsed.inMilliseconds / 1000.0;
      final cycleDuration = 12; // 6秒往返 = 12秒总周期
      final progress = (totalSeconds % cycleDuration) / cycleDuration;

      setState(() {
        _animationValue = Curves.easeInOut.transform(
          _AnimationTweens.reversibleProgress(progress),
        );
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(140, 120),
      painter: _SimpleTrianglePainter(
        isDark: widget.isDark,
        animationValue: _animationValue,
      ),
    );
  }
}

class _SimpleTrianglePainter extends CustomPainter {
  final bool isDark;
  final double animationValue;

  _SimpleTrianglePainter({required this.isDark, required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final alpha = 0.15 + (animationValue * 0.04);
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
