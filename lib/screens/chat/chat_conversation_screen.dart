import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gpt_markdown/gpt_markdown.dart';

import '../../widgets/premium_glass_card/premium_glass_card.dart';
import '../../widgets/gradient_background/gradient_background.dart';
import '../../widgets/animations/premium_animations.dart';
import '../../widgets/premium_button/premium_button.dart';

import '../../stores/chat_store.dart';
import '../../databases/app_database.dart';
import '../../utils/app_logger.dart';
import '../../themes/app_colors.dart';

part 'components/chat_message_bubble.dart';
part 'components/chat_input.dart';
part 'components/chat_markdown_renderer.dart';

/// Premium chat conversation screen with AI-powered messaging
class ChatConversationScreen extends StatefulWidget {
  final int chatId;

  const ChatConversationScreen({super.key, required this.chatId});

  @override
  State<ChatConversationScreen> createState() => _ChatConversationScreenState();
}

class _ChatConversationScreenState extends State<ChatConversationScreen>
    with TickerProviderStateMixin {
  late ScrollController _scrollController;
  late TextEditingController _messageController;
  late FocusNode _messageFocusNode;
  late AnimationController _inputAnimationController;
  late Animation<double> _inputSlideAnimation;

  bool _isComposing = false;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _loadChatMessages();
    AppLogger.userAction('Chat conversation opened', {'chatId': widget.chatId});
  }

  void _initializeControllers() {
    _scrollController = ScrollController();
    _messageController = TextEditingController();
    _messageFocusNode = FocusNode(descendantsAreFocusable: false);

    // Listen to text changes to update composing state
    _messageController.addListener(() {
      final isComposing = _messageController.text.trim().isNotEmpty;
      if (_isComposing != isComposing) {
        setState(() {
          _isComposing = isComposing;
        });
      }
    });

    // Input animation controller
    _inputAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _inputSlideAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _inputAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    // Start input animation
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        _inputAnimationController.forward();
      }
    });
  }

  Future<void> _loadChatMessages() async {
    final chatStore = context.read<ChatStore>();
    await chatStore.loadChatMessages(widget.chatId);
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _messageController.dispose();
    _messageFocusNode.dispose();
    _inputAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      behavior: HitTestBehavior.translucent,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leadingWidth: 80, // Fixed width for consistent alignment
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
          title: Consumer<ChatStore>(
            builder: (context, chatStore, child) {
              if (chatStore.currentChat == null) {
                return const Text('Chat');
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    chatStore.currentChat!.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  if (chatStore.isStreaming) ...[
                    Text(
                      'AI is typing...',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ],
              );
            },
          ),
          actions: const [SizedBox(width: 8)],
        ),
        body: PremiumScreenBackground(
          child: Column(
            children: [
              // Messages area
              Expanded(
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
                              color: Theme.of(context).colorScheme.error,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Error loading messages',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              chatStore.error!,
                              style: Theme.of(context).textTheme.bodyMedium,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 24),
                            PremiumButton(
                              text: 'Retry',
                              onPressed: _loadChatMessages,
                            ),
                          ],
                        ),
                      );
                    }

                    final messages = chatStore.currentMessages;
                    if (messages.isEmpty) {
                      return _buildEmptyState();
                    }

                    return ListView.builder(
                      controller: _scrollController,
                      padding: EdgeInsets.only(
                        top:
                            MediaQuery.of(context).padding.top +
                            kToolbarHeight +
                            16,
                        bottom: 16,
                        left: 20,
                        right: 20,
                      ),
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final message = messages[index];
                        return FadeInSlideUp(
                          delay: Duration(milliseconds: 50 * index),
                          child: _ChatMessageBubble(
                            message: message,
                            onTap: () => _scrollToBottom(),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),

              // Message input area
              AnimatedBuilder(
                animation: _inputSlideAnimation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, 100 * (1 - _inputSlideAnimation.value)),
                    child: Opacity(
                      opacity: _inputSlideAnimation.value,
                      child: _ChatInput(
                        controller: _messageController,
                        focusNode: _messageFocusNode,
                        isComposing: _isComposing,
                        onSendMessage: _sendMessage,
                        onSendImage: _sendImageMessage,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FadeInSlideUp(
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.2),
                    Theme.of(
                      context,
                    ).colorScheme.secondary.withValues(alpha: 0.2),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Icon(
                Icons.chat_bubble_outline,
                size: 40,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          const SizedBox(height: 24),
          FadeInSlideUp(
            delay: const Duration(milliseconds: 200),
            child: Text(
              'Start the conversation',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 12),
          FadeInSlideUp(
            delay: const Duration(milliseconds: 400),
            child: Text(
              'Send your first message to begin chatting with your AI companion.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.7),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _sendMessage(String content) async {
    if (content.trim().isEmpty) return;

    _scrollToBottom();

    _messageController.clear();
    final chatStore = context.read<ChatStore>();
    await chatStore.sendMessage(content);

    _scrollToBottom();
  }

  Future<void> _sendImageMessage(List<String> imagePaths) async {
    final chatStore = context.read<ChatStore>();
    await chatStore.sendMessage('', imagePaths: imagePaths);

    _scrollToBottom();
  }
}
