import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 数字九宫格键盘组件
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

    // 键盘按键样式
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
      // 固定所有按钮为72x72的尺寸
      fixedSize: WidgetStateProperty.all(const Size(56, 56)),
    );

    return Container(
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 第一行: 1 2 3
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNumberButton('1', keypadButtonStyle, theme),
              _buildNumberButton('2', keypadButtonStyle, theme),
              _buildNumberButton('3', keypadButtonStyle, theme),
            ],
          ),
          const SizedBox(height: 12),

          // 第二行: 4 5 6
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNumberButton('4', keypadButtonStyle, theme),
              _buildNumberButton('5', keypadButtonStyle, theme),
              _buildNumberButton('6', keypadButtonStyle, theme),
            ],
          ),
          const SizedBox(height: 12),

          // 第三行: 7 8 9
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNumberButton('7', keypadButtonStyle, theme),
              _buildNumberButton('8', keypadButtonStyle, theme),
              _buildNumberButton('9', keypadButtonStyle, theme),
            ],
          ),
          const SizedBox(height: 12),

          // 第四行: 空格 0 删除
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // 空格占位 - 使用透明按钮确保对齐
              _buildInvisibleButton(keypadButtonStyle),

              // 0 按钮
              _buildNumberButton('0', keypadButtonStyle, theme),

              // 删除按钮
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
              // 触觉反馈
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
          // 使用温和的次要文字颜色而不是突兀的红色
          return theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.8);
        }),
      ),
      onPressed: enabled
          ? () {
              // 触觉反馈
              HapticFeedback.lightImpact();
              onDeletePressed();
            }
          : null,
      child: Center(child: Icon(Icons.backspace_outlined)),
    );
  }

  Widget _buildInvisibleButton(ButtonStyle style) {
    return SizedBox(
      width: 56, // 确保和其他按钮相同的宽度
      height: 56, // 确保和其他按钮相同的高度
      child: Container(), // 完全透明的占位容器
    );
  }
}

/// 密码圆点显示组件
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

    // 动态计算显示的圆点数量
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
