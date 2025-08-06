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
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).padding.bottom + 20,
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
      AppLogger.userAction('Image picker requested');

      // Show image source selection dialog
      final ImageSource? source = await _showImageSourceDialog();
      if (source == null) return;

      final ImagePicker picker = ImagePicker();
      final List<XFile> images;

      if (source == ImageSource.gallery) {
        // Allow multiple image selection from gallery
        images = await picker.pickMultiImage(
          maxWidth: 1920,
          maxHeight: 1920,
          imageQuality: 85,
        );
      } else {
        // Single image from camera
        final XFile? image = await picker.pickImage(
          source: source,
          maxWidth: 1920,
          maxHeight: 1920,
          imageQuality: 85,
        );
        images = image != null ? [image] : [];
      }

      if (images.isNotEmpty) {
        // Convert XFile list to path list and send to chat
        final imagePaths = images.map((image) => image.path).toList();
        AppLogger.userAction('Images selected', {'count': images.length});
        widget.onSendImage(imagePaths);
      }
    } catch (e) {
      AppLogger.error('Failed to pick image', e);

      // Show error snackbar
      if (mounted) {
        SnackBarHelper.showError(
          context,
          'Failed to select image. Please try again.',
        );
      }
    }
  }

  Future<ImageSource?> _showImageSourceDialog() async {
    return showDialog<ImageSource>(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: PremiumGlassCard(
          padding: const EdgeInsets.all(24),
          backgroundColor: Theme.of(
            context,
          ).colorScheme.surface.withValues(alpha: 0.95),
          borderRadius: 20,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Select Image Source',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 20),

              // Camera option
              _buildSourceOption(
                icon: Icons.camera_alt_outlined,
                title: 'Camera',
                subtitle: 'Take a new photo',
                onTap: () => Navigator.of(context).pop(ImageSource.camera),
              ),

              const SizedBox(height: 12),

              // Gallery option
              _buildSourceOption(
                icon: Icons.photo_library_outlined,
                title: 'Gallery',
                subtitle: 'Choose from gallery',
                onTap: () => Navigator.of(context).pop(ImageSource.gallery),
              ),

              const SizedBox(height: 20),

              // Cancel button
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.7),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSourceOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Theme.of(
                context,
              ).colorScheme.outline.withValues(alpha: 0.2),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(
                    context,
                  ).colorScheme.primary.withValues(alpha: 0.1),
                ),
                child: Icon(
                  icon,
                  color: Theme.of(context).colorScheme.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
