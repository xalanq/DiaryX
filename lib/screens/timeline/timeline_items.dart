part of 'timeline_screen.dart';

/// Premium moment list item widget for displaying individual moments with advanced glass morphism design
class _PremiumMomentListItem extends StatefulWidget {
  final Moment moment;
  final int index;

  const _PremiumMomentListItem({required this.moment, required this.index});

  @override
  State<_PremiumMomentListItem> createState() => _PremiumMomentListItemState();
}

class _PremiumMomentListItemState extends State<_PremiumMomentListItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  bool _isTextExpanded = false;
  static const int _maxLinesCollapsed = 3;
  static const int _maxCharactersCollapsed = 150;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    // Start entrance animation
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTap() {
    AppLogger.userAction('Moment tapped', {'momentId': widget.moment.id});
    AppRoutes.toTextMoment(context, existingMoment: widget.moment);
  }

  void _onLongPress() {
    AppLogger.userAction('Moment long pressed', {'index': widget.index});
    // TODO: Show moment options
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: Container(
              margin: const EdgeInsets.only(left: 20, right: 20, bottom: 16),
              child: PremiumGlassCard(
                padding: const EdgeInsets.all(0),
                borderRadius: 24,
                hasGradient: false,
                elevation: 8,
                backgroundColor: isDark
                    ? AppColors.glassDark.withValues(alpha: 0.15)
                    : AppColors.glassLight.withValues(alpha: 0.85),
                child: Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(24),
                  child: InkWell(
                    onTap: _onTap,
                    onLongPress: _onLongPress,
                    borderRadius: BorderRadius.circular(24),
                    splashColor:
                        (isDark
                                ? AppColors.darkPrimary
                                : AppColors.lightPrimary)
                            .withValues(alpha: 0.1),
                    highlightColor:
                        (isDark
                                ? AppColors.darkPrimary
                                : AppColors.lightPrimary)
                            .withValues(alpha: 0.05),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Enhanced moment header with time and mood emojis
                          _buildMomentHeader(theme, isDark),

                          const SizedBox(height: 16),

                          // Text content with enhanced typography and expand/collapse
                          if (widget.moment.content.isNotEmpty) ...[
                            _buildExpandableTextContent(theme),
                            const SizedBox(height: 16),
                          ],

                          // Media content section (audio first, then images)
                          _buildMediaContent(context),

                          const SizedBox(height: 16),

                          // Enhanced tags section
                          _buildTagsSection(theme, isDark),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// Build the enhanced moment header with time and mood emojis
  Widget _buildMomentHeader(ThemeData theme, bool isDark) {
    return Row(
      children: [
        // Time display with enhanced styling
        Text(
          _formatTime(widget.moment.createdAt),
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: isDark
                ? AppColors.darkTextPrimary.withValues(alpha: 0.9)
                : AppColors.lightTextPrimary.withValues(alpha: 0.8),
          ),
        ),

        const SizedBox(width: 12),

        // Multiple mood emojis (up to 5)
        _buildMoodEmojis(isDark),

        const Spacer(),
      ],
    );
  }

  /// Build multiple mood emojis (up to 5)
  Widget _buildMoodEmojis(bool isDark) {
    final moods = widget.moment.moods.take(5).toList(); // Limit to 5 emojis

    if (moods.isEmpty) {
      // Don't display anything if no moods are set
      return const SizedBox.shrink();
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: moods.asMap().entries.map((entry) {
        final index = entry.key;
        final mood = entry.value;
        final moodColor = MoodColors.getMoodColor(mood);
        final moodEmoji = MoodUtils.getEmojiByValue(mood);

        return Container(
          margin: EdgeInsets.only(right: index < moods.length - 1 ? 6 : 0),
          child: Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  moodColor.withValues(alpha: 0.15),
                  moodColor.withValues(alpha: 0.05),
                ],
              ),
              border: Border.all(
                color: moodColor.withValues(alpha: 0.25),
                width: 1,
              ),
            ),
            child: Center(
              child: Text(moodEmoji, style: const TextStyle(fontSize: 14)),
            ),
          ),
        );
      }).toList(),
    );
  }

  /// Format time only (no date)
  String _formatTime(DateTime date) {
    final hour = date.hour;
    final minute = date.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '$displayHour:$minute $period';
  }

  /// Build media content section with audio players and image previews
  Widget _buildMediaContent(BuildContext context) {
    final hasAudio = widget.moment.audios.isNotEmpty;
    final hasImages = widget.moment.images.isNotEmpty;
    final hasVideos = widget.moment.videos.isNotEmpty;

    if (!hasAudio && !hasImages && !hasVideos) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Audio players (displayed first)
        if (hasAudio) ...[
          ...widget.moment.audios.map(
            (audio) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: PremiumAudioPlayer(
                audioPath: audio.filePath,
                showDuration: true,
              ),
            ),
          ),
        ],

        // Image previews with grid layout
        if (hasImages) ...[
          if (hasAudio) const SizedBox(height: 8),
          _buildImageGrid(context),
        ],

        // Video thumbnails (if any)
        if (hasVideos) ...[
          if (hasAudio || hasImages) const SizedBox(height: 8),
          _buildVideoThumbnails(context),
        ],
      ],
    );
  }

  /// Build image grid with clickable previews
  Widget _buildImageGrid(BuildContext context) {
    final images = widget.moment.images;
    if (images.isEmpty) return const SizedBox.shrink();

    if (images.length == 1) {
      // Single image - full width
      return _buildSingleImagePreview(context, images.first, 0);
    } else if (images.length == 2) {
      // Two images - side by side
      return Row(
        children: [
          Expanded(child: _buildImagePreview(context, images[0], 0)),
          const SizedBox(width: 8),
          Expanded(child: _buildImagePreview(context, images[1], 1)),
        ],
      );
    } else {
      // Multiple images - grid layout
      return _buildMultiImageGrid(context, images);
    }
  }

  /// Build single full-width image preview
  Widget _buildSingleImagePreview(
    BuildContext context,
    MediaAttachment image,
    int index,
  ) {
    return GestureDetector(
      onTap: () => _openImagePreview(context, index),
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.file(
            File(image.filePath),
            fit: BoxFit.cover,
            width: double.infinity,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.grey.withValues(alpha: 0.2),
                child: const Center(
                  child: Icon(Icons.image_not_supported, color: Colors.grey),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  /// Build regular image preview for grid
  Widget _buildImagePreview(
    BuildContext context,
    MediaAttachment image,
    int index,
  ) {
    return GestureDetector(
      onTap: () => _openImagePreview(context, index),
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.file(
            File(image.filePath),
            fit: BoxFit.cover,
            width: double.infinity,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.grey.withValues(alpha: 0.2),
                child: const Center(
                  child: Icon(Icons.image_not_supported, color: Colors.grey),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  /// Build multi-image grid layout
  Widget _buildMultiImageGrid(
    BuildContext context,
    List<MediaAttachment> images,
  ) {
    return Column(
      children: [
        // First row - two images
        Row(
          children: [
            Expanded(child: _buildImagePreview(context, images[0], 0)),
            const SizedBox(width: 8),
            Expanded(child: _buildImagePreview(context, images[1], 1)),
          ],
        ),
        const SizedBox(height: 8),
        // Second row - remaining images or "more" indicator
        if (images.length > 2) ...[
          Row(
            children: [
              if (images.length > 2)
                Expanded(child: _buildImagePreview(context, images[2], 2)),
              const SizedBox(width: 8),
              if (images.length > 3)
                Expanded(
                  child: Stack(
                    children: [
                      _buildImagePreview(context, images[3], 3),
                      if (images.length > 4)
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.black.withValues(alpha: 0.6),
                            ),
                            child: Center(
                              child: Text(
                                '+${images.length - 4}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                )
              else
                const Expanded(child: SizedBox()),
            ],
          ),
        ],
      ],
    );
  }

  /// Build video thumbnails section
  Widget _buildVideoThumbnails(BuildContext context) {
    // TODO: Implement video thumbnail previews
    return Container(
      height: 60,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey.withValues(alpha: 0.1),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          const Icon(Icons.videocam_rounded, color: Colors.grey),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '${widget.moment.videos.length} video${widget.moment.videos.length > 1 ? 's' : ''}',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  /// Open image preview with gallery support
  void _openImagePreview(BuildContext context, int initialIndex) {
    final imagePaths = widget.moment.images.map((img) => img.filePath).toList();
    PremiumImagePreview.showGallery(
      context,
      imagePaths,
      initialIndex: initialIndex,
      heroTag: 'moment_${widget.moment.id}_image',
    );
  }

  /// Build expandable text content with collapse/expand functionality
  Widget _buildExpandableTextContent(ThemeData theme) {
    final content = widget.moment.content;
    final needsExpansion =
        content.length > _maxCharactersCollapsed ||
        content.split('\n').length > _maxLinesCollapsed;

    if (!needsExpansion) {
      // Short content - just display normally
      return Text(
        content,
        style: theme.textTheme.bodyLarge?.copyWith(
          height: 1.6,
          color: theme.brightness == Brightness.dark
              ? AppColors.darkTextPrimary.withValues(alpha: 0.9)
              : AppColors.lightTextPrimary.withValues(alpha: 0.8),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: Text(
            content,
            style: theme.textTheme.bodyLarge?.copyWith(
              height: 1.6,
              color: theme.brightness == Brightness.dark
                  ? AppColors.darkTextPrimary.withValues(alpha: 0.9)
                  : AppColors.lightTextPrimary.withValues(alpha: 0.8),
            ),
            maxLines: _isTextExpanded ? null : _maxLinesCollapsed,
            overflow: _isTextExpanded
                ? TextOverflow.visible
                : TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () {
            setState(() {
              _isTextExpanded = !_isTextExpanded;
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color:
                  (theme.brightness == Brightness.dark
                          ? AppColors.darkPrimary
                          : AppColors.lightPrimary)
                      .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color:
                    (theme.brightness == Brightness.dark
                            ? AppColors.darkPrimary
                            : AppColors.lightPrimary)
                        .withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _isTextExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  size: 16,
                  color: theme.brightness == Brightness.dark
                      ? AppColors.darkPrimary
                      : AppColors.lightPrimary,
                ),
                const SizedBox(width: 4),
                Text(
                  _isTextExpanded ? 'Collapse' : 'Expand',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.brightness == Brightness.dark
                        ? AppColors.darkPrimary
                        : AppColors.lightPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Build enhanced tags section
  Widget _buildTagsSection(ThemeData theme, bool isDark) {
    // For now using static tags, but this should be dynamic from the moment data
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _PremiumTagChip(label: 'personal', isDark: isDark),
        _PremiumTagChip(label: 'reflection', isDark: isDark),
      ],
    );
  }
}

/// Premium tag chip with enhanced styling (no shadow)
class _PremiumTagChip extends StatelessWidget {
  final String label;
  final bool isDark;

  const _PremiumTagChip({required this.label, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [
                  AppColors.darkSurface.withValues(alpha: 0.8),
                  AppColors.darkSurface.withValues(alpha: 0.6),
                ]
              : [
                  AppColors.lightSurface.withValues(alpha: 0.9),
                  AppColors.lightSurface.withValues(alpha: 0.7),
                ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.1)
              : Colors.black.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Text(
        '#$label',
        style: theme.textTheme.bodySmall?.copyWith(
          fontWeight: FontWeight.w500,
          color: isDark
              ? AppColors.darkTextSecondary
              : AppColors.lightTextSecondary,
        ),
      ),
    );
  }
}
