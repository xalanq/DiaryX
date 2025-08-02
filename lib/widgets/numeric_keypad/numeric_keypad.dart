import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Numeric keypad component
class NumericKeypad extends StatelessWidget {
  final Function(String) onNumberPressed;
  final VoidCallback onDeletePressed;
  final bool enabled;

  const NumericKeypad({
    super.key,
    required this.onNumberPressed,
    required this.onDeletePressed,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Keypad button style
    final keypadButtonStyle = ButtonStyle(
      backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.disabled)) {
          return theme.colorScheme.surfaceContainerHighest.withValues(
            alpha: 0.3,
          );
        }
        if (states.contains(WidgetState.pressed)) {
          return theme.colorScheme.primary.withValues(alpha: 0.12);
        }
        return theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.6);
      }),
      foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.disabled)) {
          return theme.colorScheme.onSurface.withValues(alpha: 0.38);
        }
        return theme.colorScheme.onSurface;
      }),
      elevation: WidgetStateProperty.all(0),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      // Fix all buttons to 56x56 size
      fixedSize: WidgetStateProperty.all(const Size(56, 56)),
    );

    return Container(
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // First row: 1 2 3
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNumberButton('1', keypadButtonStyle, theme),
              _buildNumberButton('2', keypadButtonStyle, theme),
              _buildNumberButton('3', keypadButtonStyle, theme),
            ],
          ),
          const SizedBox(height: 12),

          // Second row: 4 5 6
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNumberButton('4', keypadButtonStyle, theme),
              _buildNumberButton('5', keypadButtonStyle, theme),
              _buildNumberButton('6', keypadButtonStyle, theme),
            ],
          ),
          const SizedBox(height: 12),

          // Third row: 7 8 9
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNumberButton('7', keypadButtonStyle, theme),
              _buildNumberButton('8', keypadButtonStyle, theme),
              _buildNumberButton('9', keypadButtonStyle, theme),
            ],
          ),
          const SizedBox(height: 12),

          // Fourth row: space 0 delete
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Spacer placeholder - use transparent button for alignment
              _buildInvisibleButton(keypadButtonStyle),

              // 0 button
              _buildNumberButton('0', keypadButtonStyle, theme),

              // Delete button
              _buildDeleteButton(keypadButtonStyle, theme),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNumberButton(String number, ButtonStyle style, ThemeData theme) {
    return FilledButton(
      style: style,
      onPressed: enabled
          ? () {
              // Haptic feedback
              HapticFeedback.lightImpact();
              onNumberPressed(number);
            }
          : null,
      child: Text(
        number,
        style: theme.textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildDeleteButton(ButtonStyle style, ThemeData theme) {
    return FilledButton(
      style: style.copyWith(
        foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.disabled)) {
            return theme.colorScheme.onSurface.withValues(alpha: 0.38);
          }
          // Use gentle secondary text color instead of jarring red
          return theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.8);
        }),
      ),
      onPressed: enabled
          ? () {
              // Haptic feedback
              HapticFeedback.lightImpact();
              onDeletePressed();
            }
          : null,
      child: Center(child: Icon(Icons.backspace_outlined)),
    );
  }

  Widget _buildInvisibleButton(ButtonStyle style) {
    return FilledButton(
      style: style.copyWith(
        backgroundColor: WidgetStateProperty.all(Colors.transparent),
        foregroundColor: WidgetStateProperty.all(Colors.transparent),
        elevation: WidgetStateProperty.all(0),
        overlayColor: WidgetStateProperty.all(Colors.transparent),
      ),
      onPressed: null, // 不可点击
      child: const Text(
        '0', // 占位文字，但透明不可见
        style: TextStyle(color: Colors.transparent),
      ),
    );
  }
}

/// Password dots display component
class PasswordDots extends StatelessWidget {
  final int length;
  final bool hasError;
  final int? expectedLength;

  const PasswordDots({
    super.key,
    required this.length,
    this.hasError = false,
    this.expectedLength,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Dynamically calculate the number of dots to display
    final displayLength =
        expectedLength ??
        (length == 0 ? 4 : (length < 4 ? 4 : (length > 6 ? 6 : length)));

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        border: hasError
            ? Border.all(
                color: theme.colorScheme.error.withValues(alpha: 0.5),
                width: 1.5,
              )
            : null,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(displayLength, (index) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            child: _buildDot(context, index < length, hasError),
          );
        }),
      ),
    );
  }

  Widget _buildDot(BuildContext context, bool filled, bool hasError) {
    final theme = Theme.of(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: filled
            ? (hasError ? theme.colorScheme.error : theme.colorScheme.primary)
            : Colors.transparent,
        border: Border.all(
          color: filled
              ? Colors.transparent
              : (hasError
                    ? theme.colorScheme.error.withValues(alpha: 0.5)
                    : theme.colorScheme.onSurfaceVariant.withValues(
                        alpha: 0.4,
                      )),
          width: 1.5,
        ),
      ),
    );
  }
}
