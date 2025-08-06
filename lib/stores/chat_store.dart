import 'package:flutter/material.dart';
import 'package:drift/drift.dart';
import 'dart:convert';
import '../databases/app_database.dart';
import '../services/ai/ai_service.dart';
import '../services/ai/models/chat_models.dart';
import '../services/ai/models/cancellation_token.dart';
import '../models/moment.dart';
import '../utils/app_logger.dart';

/// Store for managing chat sessions and messages state
class ChatStore extends ChangeNotifier {
  final AppDatabase _database = AppDatabase.instance;
  final AIService _aiService = AIService.instance;

  List<ChatData> _chats = [];
  List<ChatMessageData> _currentMessages = [];
  ChatData? _currentChat;
  ChatData? _draftChat; // Draft chat that hasn't been saved to database yet
  bool _isLoading = false;
  String? _error;
  bool _isStreaming = false;
  CancellationToken? _currentCancellationToken;

  // Getters
  List<ChatData> get chats => _chats;
  List<ChatMessageData> get currentMessages => _currentMessages;
  ChatData? get currentChat => _currentChat ?? _draftChat;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isStreaming => _isStreaming;
  bool get hasChats => _chats.isNotEmpty;
  bool get isDraftChat => _draftChat != null;

  /// Load all chat sessions from database
  Future<void> loadChats() async {
    _setLoading(true);
    _clearError();

    try {
      AppLogger.info('Loading chats from database');
      final chatsData = await _database.getAllChats();
      _chats = chatsData;
      AppLogger.info('Loaded ${_chats.length} chats');
    } catch (e) {
      AppLogger.error('Failed to load chats', e);
      _setError('Failed to load chats: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Load messages for a specific chat
  Future<void> loadChatMessages(int chatId) async {
    _setLoading(true);
    _clearError();

    try {
      // Handle draft chat case (chatId = -1)
      if (chatId == -1 && _draftChat != null) {
        AppLogger.info('Loading draft chat');
        _currentMessages = [];
        // _draftChat is already set, so currentChat getter will return it
        AppLogger.info('Loaded draft chat with 0 messages');
        return;
      }

      AppLogger.info('Loading messages for chat: $chatId');
      final messagesData = await _database.getMessagesByChatId(chatId);

      // Load all messages as they are - user cancellations should preserve content
      _currentMessages = messagesData;

      // Find and set current chat
      _currentChat = _chats.firstWhere(
        (chat) => chat.id == chatId,
        orElse: () => throw Exception('Chat not found'),
      );

      // Clear draft chat if we're loading a real chat
      _draftChat = null;

      AppLogger.info(
        'Loaded ${_currentMessages.length} messages for chat: $chatId',
      );
    } catch (e) {
      AppLogger.error('Failed to load chat messages', e);
      _setError('Failed to load messages: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Create a new chat session
  Future<ChatData?> createNewChat({String? title}) async {
    _setLoading(true);
    _clearError();

    try {
      AppLogger.info('Creating new chat');
      final now = DateTime.now();

      final chatCompanion = ChatsCompanion.insert(
        title: title ?? 'New Chat',
        createdAt: now,
        updatedAt: now,
      );

      final chatId = await _database.insertChat(chatCompanion);

      // Create the ChatData object
      final newChat = ChatData(
        id: chatId,
        title: title ?? 'New Chat',
        createdAt: now,
        updatedAt: now,
        isActive: true,
      );

      _chats.insert(0, newChat); // Add to beginning of list
      _currentChat = newChat;
      _currentMessages = [];

      AppLogger.info('Created new chat with ID: $chatId');
      return newChat;
    } catch (e) {
      AppLogger.error('Failed to create new chat', e);
      _setError('Failed to create new chat: $e');
      return null;
    } finally {
      _setLoading(false);
    }
  }

  /// Create a new draft chat session (not saved to database until first message)
  ChatData createDraftChat({String? title}) {
    AppLogger.info('Creating new draft chat');
    final now = DateTime.now();

    // Clear any existing chat state
    _currentChat = null;
    _currentMessages = [];
    _clearError();

    // Create a draft chat with a temporary ID
    _draftChat = ChatData(
      id: -1, // Temporary ID for draft
      title: title ?? 'New Chat',
      createdAt: now,
      updatedAt: now,
      isActive: true,
    );

    notifyListeners();
    AppLogger.info('Created draft chat');
    return _draftChat!;
  }

  /// Send a message to the current chat
  Future<void> sendMessage(
    String content, {
    List<String>? imagePaths,
    List<Moment>? contextMoments,
  }) async {
    // Validate message content or attachments
    if (content.trim().isEmpty && (imagePaths == null || imagePaths.isEmpty)) {
      AppLogger.warn('Attempted to send empty message');
      return;
    }

    // If this is a draft chat, create it in the database first
    if (_draftChat != null) {
      await _createChatFromDraft();
    }

    if (_currentChat == null) {
      AppLogger.error('Attempted to send message with no active chat session');
      _setError('No active chat session');
      return;
    }

    _clearError();

    // First, save the user message - this should always succeed
    try {
      AppLogger.info('Saving user message to chat: ${_currentChat!.id}');

      // Prepare attachments if any
      String? attachmentsJson;
      if (imagePaths != null && imagePaths.isNotEmpty) {
        final attachments = imagePaths
            .map((path) => {'type': 'image', 'path': path})
            .toList();
        attachmentsJson = jsonEncode(attachments);
      }

      // Insert user message
      final userMessageCompanion = ChatMessagesCompanion.insert(
        chatId: _currentChat!.id,
        role: 'user',
        content: content,
        attachments: Value(attachmentsJson),
        createdAt: DateTime.now(),
      );

      final userMessageId = await _database.insertChatMessage(
        userMessageCompanion,
      );

      // Create user message data for local state
      final userMessage = ChatMessageData(
        id: userMessageId,
        chatId: _currentChat!.id,
        role: 'user',
        content: content,
        attachments: attachmentsJson,
        createdAt: DateTime.now(),
        isStreaming: false,
      );

      _currentMessages.add(userMessage);

      // Update chat title if this is the first message
      if (_currentMessages.length == 1) {
        await _updateChatTitle(_currentChat!.id, content);
      }

      notifyListeners();
      AppLogger.info('User message saved successfully with ID: $userMessageId');
    } catch (e) {
      AppLogger.error('Failed to save user message', e);
      _setError('Failed to save message: $e');
      return; // Don't proceed to AI response if user message failed
    }

    // Then, generate AI response - this can be cancelled or fail without affecting user message
    try {
      await _generateAIResponse(contextMoments: contextMoments);
    } catch (e) {
      if (e is OperationCancelledException) {
        // Don't show error for cancelled operations - user message is already saved
        AppLogger.info('AI response generation was cancelled by user');
      } else {
        AppLogger.error('Failed to generate AI response', e);
        _setError('Failed to generate AI response: $e');
      }
    }
  }

  /// Generate AI response using streaming
  Future<void> _generateAIResponse({List<Moment>? contextMoments}) async {
    if (_currentChat == null) {
      AppLogger.error('Cannot generate AI response: no active chat session');
      return;
    }

    _setStreaming(true);
    _currentCancellationToken = CancellationToken();

    try {
      AppLogger.info(
        'Creating assistant message placeholder for chat: ${_currentChat!.id}',
      );

      // Create assistant message placeholder
      final assistantMessageCompanion = ChatMessagesCompanion.insert(
        chatId: _currentChat!.id,
        role: 'assistant',
        content: '',
        createdAt: DateTime.now(),
        isStreaming: Value(true),
      );

      final assistantMessageId = await _database.insertChatMessage(
        assistantMessageCompanion,
      );

      AppLogger.info('Created assistant message with ID: $assistantMessageId');

      // Create streaming message for local state
      final streamingMessage = ChatMessageData(
        id: assistantMessageId,
        chatId: _currentChat!.id,
        role: 'assistant',
        content: '',
        attachments: null,
        createdAt: DateTime.now(),
        isStreaming: true,
      );

      _currentMessages.add(streamingMessage);
      notifyListeners();

      // Prepare chat history for AI
      final chatMessages = _currentMessages
          .where((msg) => !msg.isStreaming)
          .map(
            (msg) => ChatMessage(
              role: msg.role,
              content: msg.content,
              images: _parseImageAttachments(msg.attachments),
            ),
          )
          .toList();

      // Use provided context moments or empty list
      final momentSummaries = contextMoments ?? <Moment>[];

      // Stream AI response
      String fullResponse = '';
      await for (final chunk in _aiService.chat(
        chatMessages,
        momentSummaries,
        _currentCancellationToken!,
      )) {
        if (_currentCancellationToken?.isCancelled ?? true) {
          break;
        }

        fullResponse += chunk;

        // Update the streaming message in local state
        final index = _currentMessages.indexWhere(
          (msg) => msg.id == assistantMessageId,
        );
        if (index != -1) {
          _currentMessages[index] = _currentMessages[index].copyWith(
            content: fullResponse,
          );
          notifyListeners();
        }
      }

      // Finalize the message
      if (!(_currentCancellationToken?.isCancelled ?? true)) {
        AppLogger.info('Finalizing assistant message: $assistantMessageId');

        // Update the message with final content
        await _database.updateChatMessage(
          ChatMessagesCompanion(
            id: Value(assistantMessageId),
            content: Value(fullResponse),
            isStreaming: const Value(false),
          ),
        );

        // Update local state
        final index = _currentMessages.indexWhere(
          (msg) => msg.id == assistantMessageId,
        );
        if (index != -1) {
          _currentMessages[index] = _currentMessages[index].copyWith(
            content: fullResponse,
            isStreaming: false,
          );
        }

        // Update chat timestamp
        await _database.updateChatTimestamp(_currentChat!.id);
        await _updateChatInList();
      }
    } catch (e) {
      if (e is OperationCancelledException) {
        // Don't show error for cancelled operations - preserve the message as is
        AppLogger.info(
          'AI response generation was cancelled by user - preserving current state',
        );
      } else {
        AppLogger.error('Failed to generate AI response', e);
        _setError('Failed to generate AI response: $e');

        // Only clean up empty messages on actual errors (not user cancellation)
        await _cleanupEmptyAssistantMessagesOnError();
      }
    } finally {
      _setStreaming(false);
      _currentCancellationToken = null;
    }
  }

  /// Cancel current streaming response
  void cancelStreaming() async {
    if (_currentCancellationToken != null) {
      AppLogger.info('Cancelling streaming response');
      _currentCancellationToken!.cancel();
      _setStreaming(false);
      _clearError(); // Clear any error state when cancelling

      // Find any streaming assistant message
      final streamingMessageIndex = _currentMessages.indexWhere(
        (msg) => msg.role == 'assistant' && msg.isStreaming,
      );

      if (streamingMessageIndex != -1) {
        final streamingMessage = _currentMessages[streamingMessageIndex];
        AppLogger.info(
          'Preserving cancelled assistant message: ${streamingMessage.id}',
        );

        try {
          // Check if there's any content to preserve
          final hasContent = streamingMessage.content.trim().isNotEmpty;

          if (hasContent) {
            AppLogger.info(
              'Preserving cancelled assistant message: ${streamingMessage.id} (content: "${streamingMessage.content.length} chars")',
            );

            // Critical fix: save current content to database
            await _database.updateChatMessage(
              ChatMessagesCompanion(
                id: Value(streamingMessage.id),
                content: Value(
                  streamingMessage.content,
                ), // Save current content
                isStreaming: const Value(false),
              ),
            );

            // Update local state - preserve all content
            _currentMessages[streamingMessageIndex] = streamingMessage.copyWith(
              isStreaming: false,
            );

            notifyListeners();
            AppLogger.info(
              'Successfully preserved cancelled assistant message: ${streamingMessage.id} with ${streamingMessage.content.length} characters',
            );
          } else {
            AppLogger.info(
              'Deleting empty cancelled assistant message: ${streamingMessage.id}',
            );

            // Delete from database if no content was generated
            await _database.deleteChatMessage(streamingMessage.id);

            // Remove from local state
            _currentMessages.removeAt(streamingMessageIndex);

            notifyListeners();
            AppLogger.info(
              'Successfully deleted empty cancelled assistant message: ${streamingMessage.id}',
            );
          }
        } catch (e) {
          AppLogger.error('Failed to handle cancelled assistant message', e);
        }
      }
    }
  }

  /// Clean up empty assistant messages only on system errors (not user cancellation)
  /// This method should only be called when there's a genuine system error
  Future<void> _cleanupEmptyAssistantMessagesOnError() async {
    try {
      AppLogger.info(
        'Cleaning up empty assistant messages due to system error',
      );

      // Find any assistant message with empty content in current chat
      final emptyAssistantIndex = _currentMessages.indexWhere(
        (msg) => msg.role == 'assistant' && msg.content.trim().isEmpty,
      );

      if (emptyAssistantIndex != -1) {
        final emptyMessage = _currentMessages[emptyAssistantIndex];
        AppLogger.info(
          'Cleaning up empty assistant message due to error: ${emptyMessage.id}',
        );

        // Remove from database
        await _database.deleteChatMessage(emptyMessage.id);

        // Remove from local state
        _currentMessages.removeAt(emptyAssistantIndex);

        notifyListeners();
        AppLogger.info('Successfully cleaned up empty assistant message');
      }
    } catch (e) {
      AppLogger.error('Failed to cleanup empty assistant messages on error', e);
    }
  }

  /// Update chat title based on first message
  Future<void> _updateChatTitle(int chatId, String firstMessage) async {
    try {
      // Check if chat already has a custom title (not the default "New Chat")
      final currentChat = _chats.firstWhere((chat) => chat.id == chatId);
      if (currentChat.title != 'New Chat') {
        AppLogger.info(
          'Chat already has custom title: ${currentChat.title}, skipping auto-update',
        );
        return;
      }

      // Generate a title from the first message (first 30 characters)
      String title = firstMessage.length > 30
          ? '${firstMessage.substring(0, 30)}...'
          : firstMessage;

      // Remove newlines and extra spaces
      title = title
          .replaceAll('\n', ' ')
          .replaceAll(RegExp(r'\s+'), ' ')
          .trim();

      final chatCompanion = ChatsCompanion(
        id: Value(chatId),
        title: Value(title),
        updatedAt: Value(DateTime.now()),
      );

      await _database.updateChat(chatCompanion);

      // Update local state
      final index = _chats.indexWhere((chat) => chat.id == chatId);
      if (index != -1) {
        _chats[index] = _chats[index].copyWith(title: title);
        notifyListeners();
      }
    } catch (e) {
      AppLogger.error('Failed to update chat title', e);
    }
  }

  /// Update chat in the chats list (for reordering)
  Future<void> _updateChatInList() async {
    if (_currentChat == null) return;

    try {
      final updatedChat = await _database.getChatById(_currentChat!.id);
      if (updatedChat != null) {
        // Remove old version and add updated version at the top
        _chats.removeWhere((chat) => chat.id == _currentChat!.id);
        _chats.insert(0, updatedChat);
        _currentChat = updatedChat;
        notifyListeners();
      }
    } catch (e) {
      AppLogger.error('Failed to update chat in list', e);
    }
  }

  /// Delete a chat session
  Future<void> deleteChat(int chatId) async {
    _setLoading(true);
    _clearError();

    try {
      AppLogger.info('Deleting chat: $chatId');
      await _database.deleteChat(chatId);

      _chats.removeWhere((chat) => chat.id == chatId);

      // Clear current chat if it was deleted
      if (_currentChat?.id == chatId) {
        _currentChat = null;
        _currentMessages = [];
      }

      AppLogger.info('Chat deleted successfully: $chatId');
    } catch (e) {
      AppLogger.error('Failed to delete chat', e);
      _setError('Failed to delete chat: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Parse image attachments from JSON string
  List<MediaItem>? _parseImageAttachments(String? attachmentsJson) {
    if (attachmentsJson == null) return null;

    try {
      final attachments = jsonDecode(attachmentsJson) as List;
      return attachments
          .where((attachment) => attachment['type'] == 'image')
          .map(
            (attachment) => MediaItem(
              type: 'base64', // Will be converted when sending to AI
              data: attachment['path'],
            ),
          )
          .toList();
    } catch (e) {
      AppLogger.error('Failed to parse image attachments', e);
      return null;
    }
  }

  /// Create actual chat from draft when first message is sent
  Future<void> _createChatFromDraft() async {
    if (_draftChat == null) return;

    try {
      AppLogger.info('Converting draft chat to actual chat');
      final now = DateTime.now();

      final chatCompanion = ChatsCompanion.insert(
        title: _draftChat!.title,
        createdAt: now,
        updatedAt: now,
      );

      final chatId = await _database.insertChat(chatCompanion);

      // Create the actual ChatData object
      final actualChat = ChatData(
        id: chatId,
        title: _draftChat!.title,
        createdAt: now,
        updatedAt: now,
        isActive: true,
      );

      _chats.insert(0, actualChat); // Add to beginning of list
      _currentChat = actualChat;
      _draftChat = null; // Clear draft

      AppLogger.info('Successfully converted draft to actual chat with ID: $chatId');
    } catch (e) {
      AppLogger.error('Failed to create chat from draft', e);
      _setError('Failed to create chat: $e');
      rethrow;
    }
  }

  /// Clear current chat and messages
  void clearCurrentChat() {
    _currentChat = null;
    _draftChat = null;
    _currentMessages = [];
    notifyListeners();
  }

  // Private helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setStreaming(bool streaming) {
    _isStreaming = streaming;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _currentCancellationToken?.cancel();
    super.dispose();
  }
}

/// Extension to add copyWith method to ChatMessageData
extension ChatMessageDataExtension on ChatMessageData {
  ChatMessageData copyWith({
    int? id,
    int? chatId,
    String? role,
    String? content,
    String? attachments,
    DateTime? createdAt,
    bool? isStreaming,
  }) {
    return ChatMessageData(
      id: id ?? this.id,
      chatId: chatId ?? this.chatId,
      role: role ?? this.role,
      content: content ?? this.content,
      attachments: attachments ?? this.attachments,
      createdAt: createdAt ?? this.createdAt,
      isStreaming: isStreaming ?? this.isStreaming,
    );
  }
}

/// Extension to add copyWith method to ChatData
extension ChatDataExtension on ChatData {
  ChatData copyWith({
    int? id,
    String? title,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
  }) {
    return ChatData(
      id: id ?? this.id,
      title: title ?? this.title,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
    );
  }
}
