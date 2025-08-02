import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/custom_app_bar/custom_app_bar.dart';
import '../../widgets/glass_card/glass_card.dart';
import '../../widgets/error_states/error_states.dart';
import '../../widgets/loading_states/loading_states.dart';
import '../../stores/search_store.dart';
import '../../utils/app_logger.dart';

/// Search screen with AI-powered search and chatbot interface
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with AutomaticKeepAliveClientMixin {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  bool _isChatMode = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
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
      appBar: CustomAppBar(
        title: 'Search',
        showBackButton: false,
        actions: [
          IconButton(
            icon: Icon(_isChatMode ? Icons.search : Icons.chat),
            tooltip: _isChatMode ? 'Search Mode' : 'Chat Mode',
            onPressed: () {
              setState(() {
                _isChatMode = !_isChatMode;
              });
              AppLogger.userAction('Search mode changed', {
                'mode': _isChatMode ? 'chat' : 'search',
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Container(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              focusNode: _searchFocusNode,
              decoration: InputDecoration(
                hintText: _isChatMode
                    ? 'Ask about your entries...'
                    : 'Search your diary...',
                prefixIcon: Icon(_isChatMode ? Icons.chat : Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          context.read<SearchStore>().clearSearch();
                        },
                      )
                    : IconButton(
                        icon: const Icon(Icons.mic),
                        onPressed: () {
                          AppLogger.userAction('Voice search requested');
                        },
                      ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
              ),
              onChanged: (query) {
                if (query.isNotEmpty) {
                  context.read<SearchStore>().search(query);
                } else {
                  context.read<SearchStore>().clearSearch();
                }
              },
              onSubmitted: (query) {
                if (query.isNotEmpty) {
                  AppLogger.userAction('Search submitted', {'query': query});
                  context.read<SearchStore>().search(query);
                }
              },
            ),
          ),

          // Content based on mode
          Expanded(
            child: _isChatMode
                ? _buildChatInterface()
                : _buildSearchInterface(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchInterface() {
    return Consumer<SearchStore>(
      builder: (context, searchStore, child) {
        if (searchStore.currentQuery.isEmpty) {
          return _buildSearchSuggestions();
        }

        if (searchStore.isSearching) {
          return const Center(
            child: AppLoadingIndicator(message: 'Searching...'),
          );
        }

        if (searchStore.error != null) {
          return ErrorState(
            title: 'Search Error',
            message: searchStore.error,
            onAction: () => searchStore.search(searchStore.currentQuery),
          );
        }

        if (searchStore.searchResults.isEmpty) {
          return NoSearchResultsState(
            searchQuery: searchStore.currentQuery,
            onClearSearch: () {
              _searchController.clear();
              searchStore.clearSearch();
            },
          );
        }

        return _buildSearchResults(searchStore.searchResults);
      },
    );
  }

  Widget _buildChatInterface() {
    return GlassCard(
      margin: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.chat_bubble_outline, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'AI Chat Interface',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Coming in Phase 7',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchSuggestions() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recent Searches',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          Text(
            'No recent searches',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
          ),
          const SizedBox(height: 32),

          Text(
            'Search Tips',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),

          _SearchTip(
            icon: Icons.search,
            title: 'Search by content',
            description: 'Find entries containing specific words or phrases',
          ),
          _SearchTip(
            icon: Icons.mood,
            title: 'Search by mood',
            description: 'Filter entries by your emotional state',
          ),
          _SearchTip(
            icon: Icons.calendar_today,
            title: 'Search by date',
            description: 'Find entries from specific time periods',
          ),
          _SearchTip(
            icon: Icons.tag,
            title: 'Search by tags',
            description: 'Filter entries using your custom tags',
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults(List<dynamic> results) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: results.length,
      itemBuilder: (context, index) {
        return GlassCard(
          margin: const EdgeInsets.only(bottom: 16),
          onTap: () {
            AppLogger.userAction('Search result tapped', {'index': index});
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.edit_note, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    'Today, 2:30 PM', // TODO: Format actual date
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Text',
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: Colors.blue),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'Search result content would appear here...',
                style: Theme.of(context).textTheme.bodyLarge,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SearchTip extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _SearchTip({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
                ),
                Text(
                  description,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
