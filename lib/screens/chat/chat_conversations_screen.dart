import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../widgets/premium_glass_card/premium_glass_card.dart';
import '../../widgets/gradient_background/gradient_background.dart';
import '../../widgets/animations/premium_animations.dart';
import '../../widgets/premium_button/premium_button.dart';

import '../../stores/chat_store.dart';
import '../../databases/app_database.dart';
import '../../utils/app_logger.dart';
import '../../routes.dart';
import '../../themes/app_colors.dart';

/// Chat conversations list screen
class ChatConversationsScreen extends StatefulWidget {
  const ChatConversationsScreen({super.key});

  @override
  State<ChatConversationsScreen> createState() =>
      _ChatConversationsScreenState();
}

class _ChatConversationsScreenState extends State<ChatConversationsScreen> {
  @override
  void initState() {
    super.initState();
    _loadChats();
    AppLogger.userAction('Chat conversations screen opened');
  }

  Future<void> _loadChats() async {
    final chatStore = context.read<ChatStore>();
    await chatStore.loadChats();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leadingWidth: 80,
        leading: Container(
          padding: const EdgeInsets.only(left: 20, top: 8, bottom: 8),
          alignment: Alignment.centerLeft,
          child: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: (isDark ? Colors.black : Colors.white).withValues(
                  alpha: 0.1,
                ),
                shape: BoxShape.circle,
                border: Border.all(
                  color: (isDark ? Colors.white : Colors.black).withValues(
                    alpha: 0.1,
                  ),
                  width: 1,
                ),
              ),
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.lightTextPrimary,
                size: 18,
              ),
            ),
          ),
        ),
        title: Text(
          'Conversations',
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
        centerTitle: true,
        actions: [
          Container(
            padding: const EdgeInsets.only(right: 20, top: 8, bottom: 8),
            child: GestureDetector(
              onTap: _createNewChat,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      theme.colorScheme.primary,
                      theme.colorScheme.secondary,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.add_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
      body: PremiumScreenBackground(
        child: Consumer<ChatStore>(
          builder: (context, chatStore, child) {
            if (chatStore.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (chatStore.error != null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: theme.colorScheme.error,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error loading chats',
                      style: theme.textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      chatStore.error!,
                      style: theme.textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    PremiumButton(text: 'Retry', onPressed: _loadChats),
                  ],
                ),
              );
            }

            if (chatStore.chats.isEmpty) {
              return const _ChatEmptyState();
            }

            return ListView.builder(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 20,
                bottom: MediaQuery.of(context).padding.bottom + 20,
                left: 20,
                right: 20,
              ),
              itemCount: chatStore.chats.length,
              itemBuilder: (context, index) {
                final chat = chatStore.chats[index];
                return FadeInSlideUp(
                  delay: Duration(milliseconds: 100),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _ChatListItem(
                      chat: chat,
                      onTap: () => _navigateToChat(chat.id),
                      onDelete: () => _deleteChat(chat.id),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Future<void> _createNewChat() async {
    AppLogger.userAction('Creating new draft chat from conversations screen');
    final chatStore = context.read<ChatStore>();
    final draftChat = chatStore.createDraftChat();

    if (mounted) {
      await AppRoutes.toChatConversation(context, chatId: draftChat.id);
    }
  }

  Future<void> _navigateToChat(int chatId) async {
    AppLogger.userAction('Navigating to chat conversation', {'chatId': chatId});
    await AppRoutes.toChatConversation(context, chatId: chatId);
  }

  Future<void> _deleteChat(int chatId) async {
    final confirmed = await _showDeleteConfirmation();
    if (confirmed && mounted) {
      AppLogger.userAction('Deleting chat', {'chatId': chatId});
      final chatStore = context.read<ChatStore>();
      await chatStore.deleteChat(chatId);
    }
  }

  Future<bool> _showDeleteConfirmation() async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Theme.of(context).colorScheme.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Text(
                'Delete Chat',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              content: Text(
                'Are you sure you want to delete this chat? This action cannot be undone.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text(
                    'Delete',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            );
          },
        ) ??
        false;
  }
}

/// Empty state widget for when there are no chats
class _ChatEmptyState extends StatelessWidget {
  const _ChatEmptyState();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 64,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No conversations yet',
            style: theme.textTheme.titleLarge?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start a conversation using AI Analysis templates',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// Chat list item widget for conversations
class _ChatListItem extends StatelessWidget {
  final ChatData chat;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _ChatListItem({
    required this.chat,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PremiumGlassCard(
      padding: const EdgeInsets.all(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Row(
          children: [
            // Chat avatar
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.primary,
                    theme.colorScheme.secondary,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.smart_toy_outlined,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),

            // Chat content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    chat.title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatChatTime(chat.updatedAt),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),

            // Delete button
            IconButton(
              onPressed: onDelete,
              icon: Icon(
                Icons.delete_outline,
                color: theme.colorScheme.error,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatChatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inMinutes < 1) {
      return 'now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else {
      return '${time.day}/${time.month} ${time.hour}:${time.minute.toString().padLeft(2, '0')}';
    }
  }
}
