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
  bool _isLoading = false;
  String? _error;
  bool _isStreaming = false;
  CancellationToken? _currentCancellationToken;

  // Getters
  List<ChatData> get chats => _chats;
  List<ChatMessageData> get currentMessages => _currentMessages;
  ChatData? get currentChat => _currentChat;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isStreaming => _isStreaming;
  bool get hasChats => _chats.isNotEmpty;

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
      AppLogger.info('Loading messages for chat: $chatId');
      final messagesData = await _database.getMessagesByChatId(chatId);
      _currentMessages = messagesData;

      // Find and set current chat
      _currentChat = _chats.firstWhere(
        (chat) => chat.id == chatId,
        orElse: () => throw Exception('Chat not found'),
      );

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

  /// Send a message to the current chat
  Future<void> sendMessage(
    String content, {
    List<String>? imagePaths,
    List<Moment>? contextMoments,
  }) async {
    if (_currentChat == null) {
      AppLogger.error('Attempted to send message with no active chat session');
      _setError('No active chat session');
      return;
    }

    // Validate message content or attachments
    if (content.trim().isEmpty && (imagePaths == null || imagePaths.isEmpty)) {
      AppLogger.warn('Attempted to send empty message');
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
        // Don't show error for cancelled operations
        AppLogger.info('AI response generation was cancelled by user');
      } else {
        AppLogger.error('Failed to generate AI response', e);
        _setError('Failed to generate AI response: $e');
      }
    } finally {
      _setStreaming(false);
      _currentCancellationToken = null;
    }
  }

  /// Cancel current streaming response
  void cancelStreaming() async {
    if (_isStreaming && _currentCancellationToken != null) {
      AppLogger.info('Cancelling streaming response');
      _currentCancellationToken!.cancel();
      _setStreaming(false);
      _clearError(); // Clear any error state when cancelling

      // Find and stop any currently streaming assistant message
      final streamingMessageIndex = _currentMessages.indexWhere(
        (msg) => msg.role == 'assistant' && msg.isStreaming,
      );

      if (streamingMessageIndex != -1) {
        final streamingMessage = _currentMessages[streamingMessageIndex];
        AppLogger.info('Stopping streaming message: ${streamingMessage.id}');

        try {
          // If message has no content, delete it; otherwise just stop streaming
          if (streamingMessage.content.trim().isEmpty) {
            AppLogger.info(
              'Deleting empty streaming message: ${streamingMessage.id}',
            );

            // Delete from database
            await _database.deleteChatMessage(streamingMessage.id);

            // Remove from local state
            _currentMessages.removeAt(streamingMessageIndex);
          } else {
            AppLogger.info(
              'Stopping streaming for message with content: ${streamingMessage.id}',
            );

            // Update database - set isStreaming to false
            await _database.updateChatMessage(
              ChatMessagesCompanion(
                id: Value(streamingMessage.id),
                isStreaming: const Value(false),
              ),
            );

            // Update local state
            _currentMessages[streamingMessageIndex] = streamingMessage.copyWith(
              isStreaming: false,
            );
          }

          notifyListeners();
          AppLogger.info(
            'Successfully handled cancelled streaming for message: ${streamingMessage.id}',
          );
        } catch (e) {
          AppLogger.error('Failed to handle cancelled streaming message', e);
        }
      }
    }
  }

  /// Update chat title based on first message
  Future<void> _updateChatTitle(int chatId, String firstMessage) async {
    try {
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

  /// Clear current chat and messages
  void clearCurrentChat() {
    _currentChat = null;
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
