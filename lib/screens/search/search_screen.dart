import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../widgets/premium_glass_card/premium_glass_card.dart';
import '../../widgets/gradient_background/gradient_background.dart';
import '../../widgets/animations/premium_animations.dart';
import '../../widgets/premium_button/premium_button.dart';

import '../../stores/search_store.dart';
import '../../utils/app_logger.dart';
import '../../themes/app_colors.dart';

part 'search_bar.dart';
part 'search_filters.dart';
part 'search_suggestions.dart';
part 'search_results.dart';
part 'chat_interface.dart';

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
