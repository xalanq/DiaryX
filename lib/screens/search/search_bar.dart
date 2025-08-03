part of 'search_screen.dart';

/// Premium search bar with integrated controls
class _PremiumSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool isChatMode;
  final bool showFilters;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String> onSearchSubmitted;
  final VoidCallback onClearSearch;
  final VoidCallback onVoiceSearch;
  final VoidCallback onModeChanged;
  final VoidCallback onFilterPressed;

  const _PremiumSearchBar({
    required this.controller,
    required this.focusNode,
    required this.isChatMode,
    required this.showFilters,
    required this.onSearchChanged,
    required this.onSearchSubmitted,
    required this.onClearSearch,
    required this.onVoiceSearch,
    required this.onModeChanged,
    required this.onFilterPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      children: [
        // Mode header
        Row(
          children: [
            Container(
              width: 4,
              height: 24,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: AppColors.getPrimaryGradient(isDark),
                ),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                isChatMode ? 'AI Assistant' : 'Search your diary',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            // Mode toggle button
            PremiumIconButton(
              icon: isChatMode ? Icons.search_rounded : Icons.chat_rounded,
              onPressed: onModeChanged,
              hasGlow: isChatMode,
              size: 44,
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Enhanced search bar
        PremiumGlassCard(
          padding: EdgeInsets.symmetric(vertical: 6),
          borderRadius: 24,
          child: Row(
            children: [
              // Leading icon
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Icon(
                  isChatMode ? Icons.chat_rounded : Icons.search_rounded,
                  color: isDark
                      ? AppColors.darkPrimary
                      : AppColors.lightPrimary,
                  size: 24,
                ),
              ),

              // Search input
              Expanded(
                child: TextField(
                  controller: controller,
                  focusNode: focusNode,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    hintText: isChatMode
                        ? 'Ask about your moments...'
                        : 'Search your diary...',
                    hintStyle: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.textTheme.bodyLarge?.color?.withValues(
                        alpha: 0.5,
                      ),
                    ),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    focusedErrorBorder: InputBorder.none,
                    fillColor: Colors.transparent,
                    filled: true,
                    hoverColor: Colors.transparent,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                  ),
                  onChanged: onSearchChanged,
                  onSubmitted: onSearchSubmitted,
                ),
              ),

              // Trailing actions
              if (controller.text.isNotEmpty) ...[
                PremiumIconButton(
                  icon: Icons.clear_rounded,
                  onPressed: onClearSearch,
                  size: 40,
                  hasBackground: false,
                ),
              ] else ...[
                PremiumIconButton(
                  icon: Icons.mic_rounded,
                  onPressed: onVoiceSearch,
                  size: 40,
                  hasBackground: false,
                  color: isDark ? AppColors.darkAccent : AppColors.lightAccent,
                ),
              ],

              // Filter button (only in search mode)
              if (!isChatMode) ...[
                const SizedBox(width: 8),
                PremiumIconButton(
                  icon: Icons.tune_rounded,
                  onPressed: onFilterPressed,
                  size: 40,
                  hasGlow: showFilters,
                ),
              ],

              const SizedBox(width: 12),
            ],
          ),
        ),
      ],
    );
  }
}
