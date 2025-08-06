part of '../chat_conversation_screen.dart';

/// Glass morphism message bubble with modern styling
class _ChatMessageBubble extends StatefulWidget {
  final ChatMessageData message;
  final VoidCallback? onTap;
  final bool showOnlyTime;

  const _ChatMessageBubble({
    required this.message,
    this.onTap,
    this.showOnlyTime = false,
  });

  @override
  State<_ChatMessageBubble> createState() => _ChatMessageBubbleState();
}

class _ChatMessageBubbleState extends State<_ChatMessageBubble> {
  @override
  Widget build(BuildContext context) {
    final isUser = widget.message.role == 'user';
    final isStreaming = widget.message.isStreaming;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // AI avatar (left side)
          if (!isUser) ...[
            _buildAvatar(isUser: false),
            const SizedBox(width: 12),
          ],

          // Message bubble
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              child: PremiumGlassCard(
                padding: EdgeInsets.only(
                  left: 16,
                  top: 16,
                  right: 16,
                  bottom: 12,
                ),
                backgroundColor: isUser
                    ? Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.1)
                    : Theme.of(
                        context,
                      ).colorScheme.surface.withValues(alpha: 0.8),
                borderRadius: 20,
                hasBorder: true,
                hasGradient: false,
                hasShadow: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Message content
                    if (widget.message.content.isNotEmpty) ...[
                      _ChatMarkdownRenderer(
                        content: widget.message.content,
                        isUser: isUser,
                      ),
                    ],

                    // Image attachments
                    if (widget.message.attachments != null) ...[
                      const SizedBox(height: 12),
                      _buildImageAttachments(),
                    ],

                    // Timestamp and status (more subtle)
                    const SizedBox(height: 6),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: isUser
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      children: [
                        if (isStreaming) ...[
                          SizedBox(
                            width: 10,
                            height: 10,
                            child: CircularProgressIndicator(
                              strokeWidth: 1.5,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                        ],
                        Text(
                          widget.showOnlyTime
                              ? _formatTimeOnly(widget.message.createdAt)
                              : _formatMessageTime(widget.message.createdAt),
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withValues(alpha: 0.4),
                                fontSize: 11,
                                fontWeight: FontWeight.w400,
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // User avatar (right side)
          if (isUser) ...[
            const SizedBox(width: 12),
            _buildAvatar(isUser: true),
          ],
        ],
      ),
    );
  }

  Widget _buildAvatar({required bool isUser}) {
    if (isUser) {
      // User avatar with gradient background and person icon
      return Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.secondary,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Icon(Icons.person_outline, color: Colors.white, size: 18),
      );
    } else {
      // AI assistant avatar with product logo
      return Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).colorScheme.surface,
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: ClipOval(
          child: Image.asset(
            'assets/images/logo_round.png',
            width: 30,
            height: 30,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              // Fallback to icon if image fails to load
              return Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.secondary,
                      Theme.of(context).colorScheme.primary,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Icon(
                  Icons.smart_toy_outlined,
                  color: Colors.white,
                  size: 18,
                ),
              );
            },
          ),
        ),
      );
    }
  }

  Widget _buildImageAttachments() {
    // Parse attachments from JSON string
    AppLogger.info(
      'Building image attachments for message: ${widget.message.id}',
    );
    AppLogger.info('Attachments data: ${widget.message.attachments}');

    if (widget.message.attachments == null ||
        widget.message.attachments!.isEmpty) {
      AppLogger.info('No attachments found for message: ${widget.message.id}');
      return const SizedBox.shrink();
    }

    try {
      final List<dynamic> attachmentsList = json.decode(
        widget.message.attachments!,
      );
      AppLogger.info('Parsed attachments list: $attachmentsList');

      final List<Map<String, dynamic>> imageAttachments = attachmentsList
          .where((attachment) => attachment['type'] == 'image')
          .cast<Map<String, dynamic>>()
          .toList();

      AppLogger.info(
        'Found ${imageAttachments.length} image attachments: $imageAttachments',
      );

      if (imageAttachments.isEmpty) {
        AppLogger.info(
          'No image attachments found for message: ${widget.message.id}',
        );
        return const SizedBox.shrink();
      }

      return _buildImageGrid(imageAttachments);
    } catch (e) {
      AppLogger.error('Failed to parse message attachments', e);
      return Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.red.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          'Error parsing attachments: $e',
          style: TextStyle(color: Colors.red, fontSize: 12),
        ),
      );
    }
  }

  Widget _buildImageGrid(List<Map<String, dynamic>> imageAttachments) {
    final imageCount = imageAttachments.length;

    if (imageCount == 1) {
      return _buildSingleImage(imageAttachments[0]);
    } else if (imageCount == 2) {
      return _buildTwoImages(imageAttachments);
    } else if (imageCount <= 4) {
      return _buildMultipleImages(imageAttachments);
    } else {
      return _buildMoreThanFourImages(imageAttachments);
    }
  }

  Widget _buildSingleImage(Map<String, dynamic> attachment) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 280, maxHeight: 280),
      child: _buildImagePreview(attachment['path'] as String, borderRadius: 16),
    );
  }

  Widget _buildTwoImages(List<Map<String, dynamic>> attachments) {
    return SizedBox(
      height: 160,
      child: Row(
        children: [
          Expanded(
            child: _buildImagePreview(
              attachments[0]['path'] as String,
              borderRadius: 12,
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: _buildImagePreview(
              attachments[1]['path'] as String,
              borderRadius: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMultipleImages(List<Map<String, dynamic>> attachments) {
    return SizedBox(
      height: 160,
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: _buildImagePreview(
                    attachments[0]['path'] as String,
                    borderRadius: 12,
                  ),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: _buildImagePreview(
                    attachments[1]['path'] as String,
                    borderRadius: 12,
                  ),
                ),
              ],
            ),
          ),
          if (attachments.length > 2) ...[
            const SizedBox(height: 4),
            Expanded(
              child: Row(
                children: [
                  if (attachments.length > 2)
                    Expanded(
                      child: _buildImagePreview(
                        attachments[2]['path'] as String,
                        borderRadius: 12,
                      ),
                    ),
                  if (attachments.length > 3) ...[
                    const SizedBox(width: 4),
                    Expanded(
                      child: _buildImagePreview(
                        attachments[3]['path'] as String,
                        borderRadius: 12,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMoreThanFourImages(List<Map<String, dynamic>> attachments) {
    return SizedBox(
      height: 160,
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: _buildImagePreview(
                    attachments[0]['path'] as String,
                    borderRadius: 12,
                  ),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: _buildImagePreview(
                    attachments[1]['path'] as String,
                    borderRadius: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: _buildImagePreview(
                    attachments[2]['path'] as String,
                    borderRadius: 12,
                  ),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Stack(
                    children: [
                      _buildImagePreview(
                        attachments[3]['path'] as String,
                        borderRadius: 12,
                      ),
                      if (attachments.length > 4)
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.black.withValues(alpha: 0.6),
                          ),
                          child: Center(
                            child: Text(
                              '+${attachments.length - 4}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImagePreview(String imagePath, {double borderRadius = 8}) {
    AppLogger.info('🖼️ === BUILDING IMAGE PREVIEW ===');
    AppLogger.info('Input relative path: $imagePath');

    return FutureBuilder<String>(
      future: FileHelper.toAbsolutePath(imagePath),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          AppLogger.info('⏳ Converting path to absolute...');
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
              color: Theme.of(
                context,
              ).colorScheme.surface.withValues(alpha: 0.5),
            ),
            child: const Center(
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        }

        if (snapshot.hasError || !snapshot.hasData) {
          AppLogger.error('❌ Failed to convert to absolute path');
          AppLogger.error('Error: ${snapshot.error}');
          AppLogger.error('Data: ${snapshot.data}');
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
              color: Colors.red.withValues(alpha: 0.2),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.broken_image_outlined, color: Colors.red),
                Text(
                  'Path Error',
                  style: TextStyle(color: Colors.red, fontSize: 10),
                ),
                Text(
                  imagePath,
                  style: TextStyle(color: Colors.red, fontSize: 8),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        final absolutePath = snapshot.data!;
        AppLogger.info('✅ Converted to absolute path: $absolutePath');
        final file = File(absolutePath);

        return FutureBuilder<bool>(
          future: file.exists(),
          builder: (context, existsSnapshot) {
            if (existsSnapshot.connectionState == ConnectionState.waiting) {
              AppLogger.info('⏳ Checking if file exists...');
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(borderRadius),
                  color: Theme.of(
                    context,
                  ).colorScheme.surface.withValues(alpha: 0.5),
                ),
                child: const Center(
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              );
            }

            if (existsSnapshot.hasError ||
                !existsSnapshot.hasData ||
                !existsSnapshot.data!) {
              AppLogger.error('❌ Image file does not exist: $absolutePath');
              AppLogger.error('Error: ${existsSnapshot.error}');
              AppLogger.error('Exists data: ${existsSnapshot.data}');

              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(borderRadius),
                  color: Colors.orange.withValues(alpha: 0.2),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.image_not_supported, color: Colors.orange),
                    Text(
                      'File Missing',
                      style: TextStyle(color: Colors.orange, fontSize: 10),
                    ),
                    Text(
                      absolutePath.split('/').last,
                      style: TextStyle(color: Colors.orange, fontSize: 8),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }

            AppLogger.info('✅ Image file exists, displaying: $absolutePath');

            return GestureDetector(
              onTap: () => _showImagePreview(absolutePath),
              child: Hero(
                tag: 'chat_image_$absolutePath',
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(borderRadius),
                        image: DecorationImage(
                          image: FileImage(file),
                          fit: BoxFit.cover,
                          onError: (error, stackTrace) {
                            AppLogger.error('💥 Error loading image: $error');
                            AppLogger.error('Stack trace: $stackTrace');
                          },
                        ),
                      ),
                    ),
                    // Add a small debug indicator
                    Positioned(
                      bottom: 2,
                      right: 2,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showImagePreview(String imagePath) {
    PremiumImagePreview.showSingle(
      context,
      imagePath,
      heroTag: 'chat_image_$imagePath',
    );
  }

  String _formatMessageTime(DateTime time) {
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

  String _formatTimeOnly(DateTime time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
