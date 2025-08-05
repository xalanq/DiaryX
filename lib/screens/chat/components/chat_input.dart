part of '../chat_conversation_screen.dart';

/// Responsive chat input with image attachment support
class _ChatInput extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool isComposing;
  final Function(String) onSendMessage;
  final Function(List<String>) onSendImage;

  const _ChatInput({
    required this.controller,
    required this.focusNode,
    required this.isComposing,
    required this.onSendMessage,
    required this.onSendImage,
  });

  @override
  State<_ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends State<_ChatInput> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).padding.bottom + 16,
      ),
      child: PremiumGlassCard(
        padding: const EdgeInsets.all(8),
        backgroundColor: Theme.of(
          context,
        ).colorScheme.surface.withValues(alpha: 0.9),
        borderRadius: 28,
        child: Row(
          children: [
            // Image attachment button
            _buildImageButton(),
            const SizedBox(width: 8),

            // Text input field
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Theme.of(
                    context,
                  ).colorScheme.surface.withValues(alpha: 0.01),
                ),
                child: TextField(
                  controller: widget.controller,
                  focusNode: widget.focusNode,
                  autofocus: false,
                  decoration: InputDecoration(
                    hintText: 'Type a message...',
                    hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    fillColor: Colors.transparent,
                    filled: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  maxLines: 5,
                  minLines: 1,
                  textCapitalization: TextCapitalization.sentences,
                  onSubmitted: (text) {
                    if (text.trim().isNotEmpty) {
                      widget.onSendMessage(text);
                    }
                  },
                ),
              ),
            ),

            const SizedBox(width: 8),

            // Send button
            _buildSendButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildImageButton() {
    return Consumer<ChatStore>(
      builder: (context, chatStore, child) {
        final isDisabled = chatStore.isStreaming;

        return GestureDetector(
          onTap: isDisabled ? null : _pickImage,
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDisabled
                  ? Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.1)
                  : Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.1),
            ),
            child: Icon(
              Icons.image_outlined,
              color: isDisabled
                  ? Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.3)
                  : Theme.of(context).colorScheme.primary,
              size: 20,
            ),
          ),
        );
      },
    );
  }

  Widget _buildSendButton() {
    return Consumer<ChatStore>(
      builder: (context, chatStore, child) {
        final canSend = widget.isComposing && !chatStore.isStreaming;
        final isStreaming = chatStore.isStreaming;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: canSend || isStreaming
                ? LinearGradient(
                    colors: [
                      isStreaming
                          ? Theme.of(context).colorScheme.error
                          : Theme.of(context).colorScheme.primary,
                      isStreaming
                          ? Theme.of(
                              context,
                            ).colorScheme.error.withValues(alpha: 0.8)
                          : Theme.of(context).colorScheme.secondary,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : LinearGradient(
                    colors: [
                      Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.15),
                      Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.15),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () {
                if (isStreaming) {
                  // Stop streaming
                  chatStore.cancelStreaming();
                } else if (canSend) {
                  // Send message
                  _sendMessage();
                }
              },
              child: Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(shape: BoxShape.circle),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    isStreaming ? Icons.stop_rounded : Icons.send_rounded,
                    key: ValueKey(isStreaming ? 'stop' : 'send'),
                    color: canSend || isStreaming
                        ? Colors.white
                        : Theme.of(
                            context,
                          ).colorScheme.onSurface.withValues(alpha: 0.5),
                    size: 18,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _sendMessage() {
    final message = widget.controller.text.trim();
    if (message.isNotEmpty) {
      widget.onSendMessage(message);
    }
  }

  Future<void> _pickImage() async {
    try {
      // TODO: Implement image picker
      AppLogger.userAction('Image picker requested');

      // For now, show a placeholder dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Image Attachments',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          content: Text(
            'Image attachment functionality will be implemented in the next update.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'OK',
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
            ),
          ],
        ),
      );
    } catch (e) {
      AppLogger.error('Failed to pick image', e);
    }
  }
}
