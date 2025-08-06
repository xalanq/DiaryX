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
                padding: EdgeInsets.only(left: 16, top: 16, right: 16, bottom: 12),
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
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
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
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: isUser
              ? [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.secondary,
                ]
              : [
                  Theme.of(context).colorScheme.secondary,
                  Theme.of(context).colorScheme.primary,
                ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Icon(
        isUser ? Icons.person_outline : Icons.smart_toy_outlined,
        color: Colors.white,
        size: 18,
      ),
    );
  }

  Widget _buildImageAttachments() {
    // TODO: Parse and display image attachments
    return Container(
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.5),
      ),
      child: const Center(child: Icon(Icons.image_outlined)),
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
