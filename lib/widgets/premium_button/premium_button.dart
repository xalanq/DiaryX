import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../themes/app_colors.dart';

/// Premium button with advanced visual effects and animations
class PremiumButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isIconFirst;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final BoxConstraints? constraints;
  final double elevation;
  final bool hasGradient;
  final List<Color>? gradientColors;
  final bool isFloating;
  final bool isOutlined;
  final double? width;
  final double? height;
  final TextStyle? textStyle;
  final int? textMaxLines;
  final bool hasRippleEffect;
  final Duration animationDuration;

  const PremiumButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.isIconFirst = true,
    this.borderRadius = 16,
    this.padding,
    this.constraints,
    this.elevation = 6,
    this.hasGradient = true,
    this.gradientColors,
    this.isFloating = true,
    this.isOutlined = false,
    this.width,
    this.height,
    this.textStyle,
    this.textMaxLines,
    this.hasRippleEffect = true,
    this.animationDuration = const Duration(milliseconds: 300),
  });

  @override
  State<PremiumButton> createState() => _PremiumButtonState();
}

class _PremiumButtonState extends State<PremiumButton>
    with TickerProviderStateMixin {
  late AnimationController _pressController;
  late AnimationController _hoverController;
  late AnimationController _rippleController;

  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;
  late Animation<double> _hoverAnimation;
  late Animation<double> _rippleAnimation;

  @override
  void initState() {
    super.initState();

    _pressController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _rippleController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _pressController, curve: Curves.easeInOut),
    );

    _elevationAnimation =
        Tween<double>(
          begin: widget.elevation,
          end: widget.elevation * 0.3,
        ).animate(
          CurvedAnimation(parent: _pressController, curve: Curves.easeInOut),
        );

    _hoverAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeInOut),
    );

    _rippleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _rippleController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _pressController.dispose();
    _hoverController.dispose();
    _rippleController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _pressController.forward();
    if (widget.hasRippleEffect) {
      _rippleController.reset();
      _rippleController.forward();
    }
  }

  void _onTapUp(TapUpDetails details) {
    _pressController.reverse();
  }

  void _onTapCancel() {
    _pressController.reverse();
  }

  void _onHover(bool hovering) {
    if (hovering) {
      _hoverController.forward();
    } else {
      _hoverController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isEnabled = widget.onPressed != null;

    return MouseRegion(
      onEnter: (_) => _onHover(true),
      onExit: (_) => _onHover(false),
      child: GestureDetector(
        onTapDown: isEnabled ? _onTapDown : null,
        onTapUp: isEnabled ? _onTapUp : null,
        onTapCancel: isEnabled ? _onTapCancel : null,
        onTap: isEnabled
            ? () {
                HapticFeedback.lightImpact();
                widget.onPressed?.call();
              }
            : null,
        child: AnimatedBuilder(
          animation: Listenable.merge([
            _pressController,
            _hoverController,
            _rippleController,
          ]),
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                width: widget.width,
                height: widget.height,
                constraints: widget.constraints,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  boxShadow: widget.isFloating && isEnabled
                      ? [
                          BoxShadow(
                            color: isDark
                                ? Colors.black.withValues(alpha: 0.3)
                                : Colors.black.withValues(alpha: 0.1),
                            blurRadius: _elevationAnimation.value,
                            offset: Offset(0, _elevationAnimation.value * 0.3),
                            spreadRadius: -2,
                          ),
                          BoxShadow(
                            color: isDark
                                ? Colors.black.withValues(alpha: 0.1)
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
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: widget.hasGradient && !widget.isOutlined
                            ? LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: isEnabled
                                    ? (widget.gradientColors ??
                                          AppColors.getPrimaryGradient(isDark))
                                    : [
                                        Colors.grey.withValues(alpha: 0.3),
                                        Colors.grey.withValues(alpha: 0.1),
                                      ],
                              )
                            : null,
                        color: widget.isOutlined
                            ? Colors.transparent
                            : (!widget.hasGradient
                                  ? (isEnabled
                                        ? (isDark
                                              ? AppColors.darkPrimary
                                              : AppColors.lightPrimary)
                                        : Colors.grey.withValues(alpha: 0.3))
                                  : null),
                        border: widget.isOutlined
                            ? Border.all(
                                color: isEnabled
                                    ? (isDark
                                          ? AppColors.darkPrimary
                                          : AppColors.lightPrimary)
                                    : Colors.grey.withValues(alpha: 0.3),
                                width: 2,
                              )
                            : Border.all(
                                color: Colors.white.withValues(alpha: 0.2),
                                width: 1,
                              ),
                        borderRadius: BorderRadius.circular(
                          widget.borderRadius,
                        ),
                      ),
                      child: Stack(
                        children: [
                          // Hover effect overlay
                          if (_hoverAnimation.value > 0)
                            Positioned.fill(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? Colors.white.withValues(
                                          alpha: _hoverAnimation.value * 0.05,
                                        )
                                      : Colors.white.withValues(
                                          alpha: _hoverAnimation.value * 0.1,
                                        ),
                                  borderRadius: BorderRadius.circular(
                                    widget.borderRadius,
                                  ),
                                ),
                              ),
                            ),
                          // Ripple effect
                          if (widget.hasRippleEffect &&
                              _rippleAnimation.value > 0)
                            Positioned.fill(
                              child: CustomPaint(
                                painter: _RipplePainter(
                                  animation: _rippleAnimation,
                                  color: isDark
                                      ? Colors.white.withValues(alpha: 0.1)
                                      : Colors.white.withValues(alpha: 0.3),
                                ),
                              ),
                            ),
                          // Button content
                          Container(
                            padding:
                                widget.padding ??
                                const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 16,
                                ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (widget.icon != null &&
                                    widget.isIconFirst) ...[
                                  Icon(
                                    widget.icon,
                                    color: widget.isOutlined
                                        ? (isEnabled
                                              ? (isDark
                                                    ? AppColors.darkPrimary
                                                    : AppColors.lightPrimary)
                                              : Colors.grey)
                                        : (isEnabled
                                              ? Colors.white
                                              : Colors.grey),
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                ],
                                Flexible(
                                  child: Text(
                                    widget.text,
                                    textAlign: TextAlign.center,
                                    maxLines: widget.textMaxLines,
                                    overflow: TextOverflow.ellipsis,
                                    style:
                                        widget.textStyle ??
                                        theme.textTheme.labelLarge?.copyWith(
                                          color: widget.isOutlined
                                              ? (isEnabled
                                                    ? (isDark
                                                          ? AppColors
                                                                .darkPrimary
                                                          : AppColors
                                                                .lightPrimary)
                                                    : Colors.grey)
                                              : (isEnabled
                                                    ? Colors.white
                                                    : Colors.grey),
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                ),
                                if (widget.icon != null &&
                                    !widget.isIconFirst) ...[
                                  const SizedBox(width: 8),
                                  Icon(
                                    widget.icon,
                                    color: widget.isOutlined
                                        ? (isEnabled
                                              ? (isDark
                                                    ? AppColors.darkPrimary
                                                    : AppColors.lightPrimary)
                                              : Colors.grey)
                                        : (isEnabled
                                              ? Colors.white
                                              : Colors.grey),
                                    size: 20,
                                  ),
                                ],
                              ],
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
        ),
      ),
    );
  }
}

/// Custom painter for ripple effect
class _RipplePainter extends CustomPainter {
  final Animation<double> animation;
  final Color color;

  _RipplePainter({required this.animation, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    if (animation.value == 0) return;

    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = size.width > size.height ? size.width : size.height;
    final radius = maxRadius * animation.value;

    // Use original color's alpha value, then adjust based on animation progress
    final originalAlpha = color.a;
    final currentAlpha = originalAlpha * (1.0 - animation.value);

    final paint = Paint()
      ..color = color.withValues(alpha: currentAlpha)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// Floating action button with premium effects
class PremiumFloatingActionButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData icon;
  final String? tooltip;
  final bool hasGradient;
  final List<Color>? gradientColors;
  final double size;

  const PremiumFloatingActionButton({
    super.key,
    this.onPressed,
    required this.icon,
    this.tooltip,
    this.hasGradient = true,
    this.gradientColors,
    this.size = 56,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: hasGradient
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: gradientColors ?? AppColors.getPrimaryGradient(isDark),
              )
            : null,
        color: hasGradient
            ? null
            : (isDark ? AppColors.darkPrimary : AppColors.lightPrimary),
        boxShadow: [
          BoxShadow(
            color: (isDark ? AppColors.darkPrimary : AppColors.lightPrimary)
                .withValues(alpha: 0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: -4,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        shape: const CircleBorder(),
        child: InkWell(
          onTap: onPressed,
          customBorder: const CircleBorder(),
          splashColor: Colors.white.withValues(alpha: 0.3),
          highlightColor: Colors.white.withValues(alpha: 0.1),
          child: Center(child: Icon(icon, color: Colors.white, size: 24)),
        ),
      ),
    );
  }
}

/// Premium icon button
class PremiumIconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final double size;
  final Color? color;
  final bool hasBackground;
  final bool hasGlow;

  const PremiumIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.size = 40,
    this.color,
    this.hasBackground = true,
    this.hasGlow = false,
  });

  @override
  State<PremiumIconButton> createState() => _PremiumIconButtonState();
}

class _PremiumIconButtonState extends State<PremiumIconButton>
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
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(_controller);
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

    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      onTap: widget.onPressed,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.hasBackground
                    ? (isDark
                          ? AppColors.darkSurface.withValues(alpha: 0.8)
                          : AppColors.lightSurface.withValues(alpha: 0.9))
                    : null,
                border: widget.hasBackground
                    ? Border.all(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.1)
                            : Colors.black.withValues(alpha: 0.1),
                        width: 1,
                      )
                    : null,
                boxShadow: widget.hasGlow
                    ? [
                        BoxShadow(
                          color: (widget.color ?? AppColors.lightPrimary)
                              .withValues(alpha: 0.3),
                          blurRadius: 12,
                          spreadRadius: 2,
                        ),
                      ]
                    : (widget.hasBackground
                          ? [
                              BoxShadow(
                                color: Colors.black.withValues(
                                  alpha: isDark ? 0.3 : 0.1,
                                ),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : null),
              ),
              child: Center(
                child: Icon(
                  widget.icon,
                  color:
                      widget.color ??
                      (isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary),
                  size: widget.size * 0.5,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
