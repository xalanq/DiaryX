import 'dart:convert';
import 'dart:io';
import 'package:diaryx/services/ai/llm_engine.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gpt_markdown/gpt_markdown.dart';
import 'package:image_picker/image_picker.dart';

import '../../widgets/premium_glass_card/premium_glass_card.dart';
import '../../widgets/gradient_background/gradient_background.dart';
import '../../widgets/animations/premium_animations.dart';

import '../../stores/chat_store.dart';
import '../../databases/app_database.dart';
import '../../utils/app_logger.dart';
import '../../utils/snackbar_helper.dart';
import '../../services/ai/models/cancellation_token.dart';
import '../../services/ai/ai_engine.dart';
import '../../utils/file_helper.dart';
import '../../themes/app_colors.dart';
import '../../widgets/image_preview/premium_image_preview.dart';

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
    // Use addPostFrameCallback to avoid setState during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    // Add multiple frame callbacks to ensure UI is fully built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 100), () {
        if (_scrollController.hasClients && mounted) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
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
              return Text(
                chatStore.currentChat!.title,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface,
                  height: 1.1,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
              );
            },
          ),
          actions: const [SizedBox(width: kToolbarHeight)],
        ),
        body: PremiumScreenBackground(
          child: Column(
            children: [
              // Messages area
              Expanded(
                child: Consumer<ChatStore>(
                  builder: (context, chatStore, child) {
                    // Handle errors with SnackBar instead of covering the message list
                    if (chatStore.error != null) {
                      // Filter out user cancellation errors using type checking
                      final error = chatStore.error!;
                      final isCancellationError = _isCancellationError(error);

                      if (!isCancellationError) {
                        // Only show non-cancellation errors in SnackBar
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (mounted) {
                            SnackBarHelper.showError(
                              context,
                              error.toString(),
                              duration: const Duration(seconds: 4),
                            );
                          }
                        });
                      }

                      // Always clear the error after checking it
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (mounted) {
                          chatStore.clearError();
                        }
                      });
                    }

                    if (chatStore.isLoading &&
                        chatStore.currentMessages.isEmpty) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final messages = chatStore.currentMessages;
                    if (messages.isEmpty) {
                      return _buildEmptyState();
                    }

                    return ListView.builder(
                      controller: _scrollController,
                      padding: EdgeInsets.only(
                        top: MediaQuery.of(context).padding.top + 20,
                        bottom: 20,
                        left: 20,
                        right: 20,
                      ),
                      itemCount: _getItemCount(messages),
                      itemBuilder: (context, index) {
                        return _buildMessageItem(context, messages, index);
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
                        onSendMessage: (text, {List<String>? imagePaths}) =>
                            _sendMessage(text, imagePaths: imagePaths),
                        onSendImage: (imagePaths, {String? text}) =>
                            _sendImageMessage(imagePaths, text: text),
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
                Icons.chat,
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

  /// Unified message sending method that handles both text and images
  Future<void> _sendMessage(String content, {List<String>? imagePaths}) async {
    if (content.trim().isEmpty && (imagePaths == null || imagePaths.isEmpty)) {
      return;
    }

    // Dismiss keyboard first
    FocusScope.of(context).unfocus();

    _messageController.clear();
    final chatStore = context.read<ChatStore>();
    await chatStore.sendMessage(content, imagePaths: imagePaths);

    // Use addPostFrameCallback to avoid setState during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  /// Convenience method for sending image messages with optional text
  Future<void> _sendImageMessage(
    List<String> imagePaths, {
    String? text,
  }) async {
    return _sendMessage(text ?? '', imagePaths: imagePaths);
  }

  /// Check if the error is a cancellation error (direct or wrapped in AIEngineException)
  bool _isCancellationError(Exception error) {
    // Check if it's directly a cancellation exception
    if (error is OperationCancelledException) {
      return true;
    }

    // Check if it's an AIEngineException wrapping a cancellation exception
    if (error is AIEngineException &&
        (error.originalError is OperationCancelledException ||
            (error.originalError is LLMEngineException &&
                error.originalError.originalError
                    is OperationCancelledException))) {
      return true;
    }

    return false;
  }

  int _getItemCount(List<ChatMessageData> messages) {
    int count = 0;
    DateTime? lastDate;

    for (final message in messages) {
      final messageDate = DateTime(
        message.createdAt.year,
        message.createdAt.month,
        message.createdAt.day,
      );

      if (lastDate == null || !messageDate.isAtSameMomentAs(lastDate)) {
        count++; // Add date separator
        lastDate = messageDate;
      }
      count++; // Add message
    }

    return count;
  }

  Widget _buildMessageItem(
    BuildContext context,
    List<ChatMessageData> messages,
    int index,
  ) {
    // int messageIndex = 0;
    int currentIndex = 0;
    DateTime? lastDate;

    for (int i = 0; i < messages.length; i++) {
      final message = messages[i];
      final messageDate = DateTime(
        message.createdAt.year,
        message.createdAt.month,
        message.createdAt.day,
      );

      // Check if we need a date separator
      if (lastDate == null || !messageDate.isAtSameMomentAs(lastDate)) {
        if (currentIndex == index) {
          return _buildDateSeparator(messageDate);
        }
        currentIndex++;
        lastDate = messageDate;
      }

      // Check if this is the message we want
      if (currentIndex == index) {
        return FadeInSlideUp(
          delay: Duration(milliseconds: 50 * i),
          child: _ChatMessageBubble(
            message: message,
            onTap: () => _scrollToBottom(),
            showOnlyTime: true, // New parameter
          ),
        );
      }
      currentIndex++;
    }

    return const SizedBox.shrink();
  }

  Widget _buildDateSeparator(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    String dateText;
    if (date.isAtSameMomentAs(today)) {
      dateText = 'Today';
    } else if (date.isAtSameMomentAs(yesterday)) {
      dateText = 'Yesterday';
    } else {
      dateText = '${date.day}/${date.month}/${date.year}';
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 1,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.2),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              dateText,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.6),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: 1,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.2),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
