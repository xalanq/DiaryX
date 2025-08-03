import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../widgets/premium_glass_card/premium_glass_card.dart';
import '../../widgets/gradient_background/gradient_background.dart';
import '../../widgets/animations/premium_animations.dart';
import '../../widgets/premium_button/premium_button.dart';

import '../../stores/search_store.dart';
import '../../utils/app_logger.dart';
import '../../themes/app_colors.dart';

/// Premium search screen with AI-powered search and chatbot interface
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  late TextEditingController _searchController;
  late FocusNode _searchFocusNode;

  bool _isChatMode = false;
  bool _showFilters = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchFocusNode = FocusNode();
    AppLogger.userAction('Search screen opened');
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      body: PremiumScreenBackground(
        child: Column(
          children: [
            // Enhanced search bar with integrated controls
            Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 20,
                bottom: 4,
                left: 20,
                right: 20,
              ),
              child: FadeInSlideUp(
                child: _PremiumSearchBar(
                  controller: _searchController,
                  focusNode: _searchFocusNode,
                  isChatMode: _isChatMode,
                  showFilters: _showFilters,
                  onSearchChanged: (query) {
                    if (query.isNotEmpty) {
                      context.read<SearchStore>().search(query);
                    } else {
                      context.read<SearchStore>().clearSearch();
                    }
                  },
                  onSearchSubmitted: (query) {
                    if (query.isNotEmpty) {
                      AppLogger.userAction('Search submitted', {
                        'query': query,
                      });
                      context.read<SearchStore>().search(query);
                    }
                  },
                  onClearSearch: () {
                    _searchController.clear();
                    context.read<SearchStore>().clearSearch();
                  },
                  onVoiceSearch: () {
                    AppLogger.userAction('Voice search requested');
                    _showComingSoon(context, 'Voice Search');
                  },
                  onModeChanged: () {
                    setState(() {
                      _isChatMode = !_isChatMode;
                    });
                    AppLogger.userAction('Search mode changed', {
                      'mode': _isChatMode ? 'chat' : 'search',
                    });
                  },
                  onFilterPressed: () {
                    setState(() {
                      _showFilters = !_showFilters;
                    });
                    AppLogger.userAction('Search filters toggled');
                  },
                ),
              ),
            ),

            // Fixed filters panel (if enabled)
            if (_showFilters)
              FadeInSlideUp(
                delay: const Duration(milliseconds: 300),
                child: _PremiumFiltersPanel(),
              ),

            // Scrollable content area
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: FadeInSlideUp(
                  delay: Duration(milliseconds: _showFilters ? 400 : 300),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      bottom: 100,
                    ), // Space for bottom nav
                    child: _isChatMode
                        ? _buildChatInterface()
                        : _buildSearchInterface(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showComingSoon(BuildContext context, String feature) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('$feature Coming Soon'),
        content: Text('This feature will be available in a future update.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchInterface() {
    return Consumer<SearchStore>(
      builder: (context, searchStore, child) {
        if (searchStore.currentQuery.isEmpty) {
          return _PremiumSearchSuggestions();
        }

        if (searchStore.isSearching) {
          return const _PremiumSearchLoadingState();
        }

        if (searchStore.searchResults.isEmpty) {
          return _PremiumNoResultsState(
            searchQuery: searchStore.currentQuery,
            onClearSearch: () {
              _searchController.clear();
              searchStore.clearSearch();
            },
          );
        }

        return _PremiumSearchResults(results: searchStore.searchResults);
      },
    );
  }

  Widget _buildChatInterface() {
    return _PremiumChatInterface();
  }
}

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

/// Premium filters panel
class _PremiumFiltersPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: PremiumGlassCard(
        child: Column(
          children: [
            Row(
              children: [
                Icon(
                  Icons.filter_list_rounded,
                  size: 20,
                  color: isDark
                      ? AppColors.darkPrimary
                      : AppColors.lightPrimary,
                ),
                const SizedBox(width: 12),
                Text(
                  'Filters',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    AppLogger.userAction('Clear all filters');
                  },
                  child: Text(
                    'Clear All',
                    style: TextStyle(
                      color: isDark
                          ? AppColors.darkAccent
                          : AppColors.lightAccent,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _PremiumFilterChip(label: 'Text', isSelected: false),
                _PremiumFilterChip(label: 'Voice', isSelected: false),
                _PremiumFilterChip(label: 'Images', isSelected: false),
                _PremiumFilterChip(label: 'Videos', isSelected: false),
                _PremiumFilterChip(label: 'This Week', isSelected: false),
                _PremiumFilterChip(label: 'This Month', isSelected: false),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Premium filter chip
class _PremiumFilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;

  const _PremiumFilterChip({required this.label, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          AppLogger.userAction('Filter selected', {'filter': label});
        },
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            gradient: isSelected
                ? LinearGradient(colors: AppColors.getPrimaryGradient(isDark))
                : null,
            color: isSelected
                ? null
                : (isDark
                      ? AppColors.darkSurface.withValues(alpha: 0.6)
                      : AppColors.lightSurface.withValues(alpha: 0.8)),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected
                  ? Colors.transparent
                  : (isDark
                        ? Colors.white.withValues(alpha: 0.1)
                        : Colors.black.withValues(alpha: 0.1)),
              width: 1,
            ),
          ),
          child: Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: isSelected
                  ? Colors.white
                  : (isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

/// Premium search suggestions
class _PremiumSearchSuggestions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StaggeredAnimationContainer(
      staggerDelay: const Duration(milliseconds: 100),
      children: [
        const SizedBox(height: 16),
        _PremiumRecentSearches(),
        const SizedBox(height: 20),
        _PremiumSearchTips(),
        const SizedBox(height: 20),
      ],
    );
  }
}

/// Premium recent searches section
class _PremiumRecentSearches extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header similar to profile page
        Padding(
          padding: const EdgeInsets.only(left: 20, bottom: 12),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: [
                      (isDark ? AppColors.darkPrimary : AppColors.lightPrimary)
                          .withValues(alpha: 0.1),
                      Colors.transparent,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.history_rounded,
                  size: 18,
                  color: isDark
                      ? AppColors.darkPrimary
                      : AppColors.lightPrimary,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Recent Searches',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        // Card with content - similar to profile page
        PremiumGlassCard(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.symmetric(vertical: 32),
          child: Center(
            child: Column(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      colors: [
                        (isDark
                                ? AppColors.darkSurface
                                : AppColors.lightSurface)
                            .withValues(alpha: 0.5),
                        Colors.transparent,
                      ],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.search_off_rounded,
                    size: 28,
                    color: theme.textTheme.bodyMedium?.color?.withValues(
                      alpha: 0.4,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'No recent searches',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: theme.textTheme.bodyMedium?.color?.withValues(
                      alpha: 0.7,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Your searches will appear here',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.textTheme.bodySmall?.color?.withValues(
                      alpha: 0.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Premium search tips section
class _PremiumSearchTips extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header similar to profile page
        Padding(
          padding: const EdgeInsets.only(left: 20, bottom: 12),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: [
                      (isDark ? AppColors.darkAccent : AppColors.lightAccent)
                          .withValues(alpha: 0.1),
                      Colors.transparent,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.lightbulb_rounded,
                  size: 18,
                  color: isDark ? AppColors.darkAccent : AppColors.lightAccent,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Search Tips',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        // Card with items - similar to profile page
        PremiumGlassCard(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              _PremiumSearchTip(
                icon: Icons.text_fields_rounded,
                title: 'Search by content',
                description: 'Find moments containing specific words',
                color: Colors.blue,
              ),
              _buildDivider(isDark),
              _PremiumSearchTip(
                icon: Icons.mood_rounded,
                title: 'Search by mood',
                description: 'Filter moments by emotional state',
                color: Colors.green,
              ),
              _buildDivider(isDark),
              _PremiumSearchTip(
                icon: Icons.calendar_today_rounded,
                title: 'Search by date',
                description: 'Find moments from specific periods',
                color: Colors.orange,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDivider(bool isDark) {
    return Divider(
      indent: 84, // 20 (card padding) + 44 (icon width) + 20 (gap)
      endIndent: 20,
      height: 1,
      color: (isDark ? AppColors.darkPrimary : AppColors.lightPrimary)
          .withValues(alpha: 0.2),
    );
  }
}

/// Premium search tip item
class _PremiumSearchTip extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color color;

  const _PremiumSearchTip({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () {
          AppLogger.userAction('Search tip tapped', {'tip': title});
        },
        borderRadius: BorderRadius.circular(12),
        splashColor: color.withValues(alpha: 0.1),
        highlightColor: color.withValues(alpha: 0.05),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.transparent, width: 1),
          ),
          child: Row(
            children: [
              // Enhanced icon
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: color.withValues(alpha: 0.2),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: color.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(icon, size: 22, color: color),
              ),
              const SizedBox(width: 16),

              // Text content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.textTheme.bodyMedium?.color?.withValues(
                          alpha: 0.7,
                        ),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),

              // Chevron with subtle animation hint
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: (isDark ? Colors.white : Colors.black).withValues(
                    alpha: 0.05,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.chevron_right_rounded,
                  size: 18,
                  color: theme.textTheme.bodyMedium?.color?.withValues(
                    alpha: 0.6,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Premium search loading state
class _PremiumSearchLoadingState extends StatelessWidget {
  const _PremiumSearchLoadingState();

  @override
  Widget build(BuildContext context) {
    return StaggeredAnimationContainer(
      children: [
        const SizedBox(height: 16),
        ...List.generate(
          5,
          (index) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: ShimmerLoading(
              child: PremiumGlassCard(
                child: Container(
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Premium no results state
class _PremiumNoResultsState extends StatelessWidget {
  final String searchQuery;
  final VoidCallback onClearSearch;

  const _PremiumNoResultsState({
    required this.searchQuery,
    required this.onClearSearch,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Center(
      child: FadeInSlideUp(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: PremiumGlassCard(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ScaleInBounce(
                  delay: const Duration(milliseconds: 200),
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        colors: [
                          (isDark
                                  ? AppColors.darkSurface
                                  : AppColors.lightSurface)
                              .withValues(alpha: 0.5),
                          Colors.transparent,
                        ],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.search_off_rounded,
                      size: 40,
                      color: theme.textTheme.bodyMedium?.color?.withValues(
                        alpha: 0.4,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'No Results Found',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  'We couldn\'t find any moments matching\n"$searchQuery"',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.textTheme.bodyMedium?.color?.withValues(
                      alpha: 0.7,
                    ),
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                PremiumButton(
                  text: 'Clear Search',
                  onPressed: onClearSearch,
                  isOutlined: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Premium search results
class _PremiumSearchResults extends StatelessWidget {
  final List<dynamic> results;

  const _PremiumSearchResults({required this.results});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        children: results.asMap().entries.map((entry) {
          final index = entry.key;
          final result = entry.value;
          return FadeInSlideUp(
            delay: Duration(milliseconds: index * 100),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _PremiumSearchResultCard(result: result, index: index),
            ),
          );
        }).toList(),
      ),
    );
  }
}

/// Premium search result card
class _PremiumSearchResultCard extends StatelessWidget {
  final dynamic result;
  final int index;

  const _PremiumSearchResultCard({required this.result, required this.index});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return PremiumGlassCard(
      onTap: () {
        AppLogger.userAction('Search result tapped', {'index': index});
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with metadata
          Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withValues(alpha: 0.4),
                      blurRadius: 6,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Today, 2:30 PM', // TODO: Format actual date
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.blue.withValues(alpha: 0.2),
                      Colors.blue.withValues(alpha: 0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.blue.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.text_fields_rounded,
                      size: 12,
                      color: Colors.blue,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Text',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.blue,
                        fontWeight: FontWeight.w600,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Content preview
          Text(
            'Search result content would appear here with highlighted keywords...',
            style: theme.textTheme.bodyLarge?.copyWith(height: 1.6),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 16),

          // Footer with tags and relevance
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color:
                      (isDark ? AppColors.darkSurface : AppColors.lightSurface)
                          .withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: (isDark ? Colors.white : Colors.black).withValues(
                      alpha: 0.1,
                    ),
                    width: 1,
                  ),
                ),
                child: Text(
                  '#sample',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: AppColors.getPrimaryGradient(isDark),
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '95% match',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Premium chat interface
class _PremiumChatInterface extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return StaggeredAnimationContainer(
      staggerDelay: const Duration(milliseconds: 150),
      children: [
        const SizedBox(height: 16),
        // Chat welcome
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: PremiumGlassCard(
            hasGradient: true,
            gradientColors: isDark
                ? [
                    AppColors.darkPrimary.withValues(alpha: 0.3),
                    AppColors.darkAccent.withValues(alpha: 0.1),
                  ]
                : [
                    AppColors.lightPrimary.withValues(alpha: 0.2),
                    AppColors.lightAccent.withValues(alpha: 0.1),
                  ],
            child: Column(
              children: [
                ScaleInBounce(
                  delay: const Duration(milliseconds: 200),
                  child: Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: AppColors.getPrimaryGradient(isDark),
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color:
                              (isDark
                                      ? AppColors.darkPrimary
                                      : AppColors.lightPrimary)
                                  .withValues(alpha: 0.4),
                          blurRadius: 20,
                          spreadRadius: 0,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.psychology_rounded,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'AI Assistant',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Ask me anything about your diary moments.\nI can help you find patterns and insights.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.textTheme.bodyMedium?.color?.withValues(
                      alpha: 0.7,
                    ),
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: AppColors.getPrimaryGradient(isDark),
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    'Phase 7',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),

        // Coming soon placeholder
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: PremiumGlassCard(
            child: Column(
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      colors: [
                        (isDark
                                ? AppColors.darkSurface
                                : AppColors.lightSurface)
                            .withValues(alpha: 0.3),
                        Colors.transparent,
                      ],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.auto_awesome_rounded,
                    size: 48,
                    color: theme.textTheme.bodyMedium?.color?.withValues(
                      alpha: 0.3,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Coming Soon',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: theme.textTheme.titleLarge?.color?.withValues(
                      alpha: 0.8,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Advanced AI chat features will be available in Phase 7',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.textTheme.bodyMedium?.color?.withValues(
                      alpha: 0.6,
                    ),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
