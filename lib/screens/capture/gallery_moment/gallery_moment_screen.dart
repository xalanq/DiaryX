import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../widgets/annotated_region/system_ui_wrapper.dart';
import '../../../widgets/premium_glass_card/premium_glass_card.dart';
import '../../../widgets/premium_button/premium_button.dart';
import '../../../widgets/gradient_background/gradient_background.dart';
import '../../../services/camera_service.dart';
import '../../../stores/moment_store.dart';
import '../../../models/media_attachment.dart';
import '../../../databases/app_database.dart';
import '../../../themes/app_colors.dart';
import '../../../utils/app_logger.dart';

/// Gallery selection and moment creation screen
class GalleryMomentScreen extends StatefulWidget {
  const GalleryMomentScreen({super.key, this.preselectedMediaPaths});

  final List<String>? preselectedMediaPaths;

  @override
  State<GalleryMomentScreen> createState() => _GalleryMomentScreenState();
}

class _GalleryMomentScreenState extends State<GalleryMomentScreen>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

  final CameraService _cameraService = CameraService.instance;
  final TextEditingController _textController = TextEditingController();
  final FocusNode _textFocus = FocusNode();

  List<String> _selectedMediaPaths = [];
  List<MediaType> _mediaTypes = [];
  bool _isLoading = false;
  bool _isSaving = false;
  String _currentPhase = 'select'; // select, compose

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeWithPreselectedMedia();
    AppLogger.userAction('Gallery moment screen opened');
  }

  void _initializeWithPreselectedMedia() {
    if (widget.preselectedMediaPaths != null &&
        widget.preselectedMediaPaths!.isNotEmpty) {
      // Set preselected media and go directly to compose phase
      _selectedMediaPaths = List.from(widget.preselectedMediaPaths!);
      _mediaTypes = List.filled(_selectedMediaPaths.length, MediaType.image);
      _currentPhase = 'compose';

      AppLogger.userAction(
        '${_selectedMediaPaths.length} media items preselected from gallery',
      );
    }
  }

  void _initializeAnimations() {
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );

    _slideController.forward();
  }

  Future<void> _pickFromGallery() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Direct call to multiple image picker (supports photos and videos)
      final List<String> mediaPaths = await _cameraService
          .pickMultipleImagesFromGallery();

      if (mediaPaths.isNotEmpty) {
        setState(() {
          _selectedMediaPaths = mediaPaths;
          _mediaTypes = List.filled(mediaPaths.length, MediaType.image);
          _currentPhase = 'compose';
        });

        HapticFeedback.selectionClick();
        AppLogger.userAction(
          '${mediaPaths.length} items selected from gallery',
        );
      }
    } catch (e) {
      AppLogger.error('Failed to pick from gallery', e);
      _showError('Failed to select from gallery');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _pickFromFiles() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Use multiple image picker for file selection
      final List<String> imagePaths = await _cameraService
          .pickMultipleImagesFromGallery();

      if (imagePaths.isNotEmpty) {
        setState(() {
          _selectedMediaPaths = imagePaths;
          _mediaTypes = List.filled(imagePaths.length, MediaType.image);
          _currentPhase = 'compose';
        });

        HapticFeedback.selectionClick();
        AppLogger.userAction(
          '${imagePaths.length} files selected from device storage',
        );
      }
    } catch (e) {
      AppLogger.error('Failed to pick files from storage', e);
      _showError('Failed to select files');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _removeMedia(int index) {
    setState(() {
      _selectedMediaPaths.removeAt(index);
      _mediaTypes.removeAt(index);
    });

    if (_selectedMediaPaths.isEmpty) {
      setState(() {
        _currentPhase = 'select';
      });
    }

    HapticFeedback.selectionClick();
    AppLogger.userAction('Media removed from selection');
  }

  void _goBack() {
    if (_currentPhase == 'compose') {
      setState(() {
        _selectedMediaPaths.clear();
        _mediaTypes.clear();
        _currentPhase = 'select';
      });
      _textController.clear();
    } else {
      Navigator.of(context).pop();
    }
  }

  Future<void> _saveMoment() async {
    if (_selectedMediaPaths.isEmpty) return;

    setState(() {
      _isSaving = true;
    });

    try {
      final momentStore = Provider.of<MomentStore>(context, listen: false);

      // Create the moment data
      final textContent = _textController.text.trim();

      final moment = MomentData(
        id: 0, // Will be auto-generated
        content: textContent.isNotEmpty
            ? textContent
            : (_selectedMediaPaths.length == 1
                  ? 'Gallery moment'
                  : '${_selectedMediaPaths.length} gallery items'),
        moods: null, // Will be analyzed later
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        aiProcessed: false,
      );

      // Create media attachments
      final List<MediaAttachmentData> mediaAttachments = [];
      for (int i = 0; i < _selectedMediaPaths.length; i++) {
        final attachment = MediaAttachmentData(
          id: 0, // Will be auto-generated
          momentId: 0, // Will be updated after moment creation
          filePath: _selectedMediaPaths[i],
          mediaType: _mediaTypes[i],
          fileSize: null, // TODO: Calculate file size
          duration: null,
          thumbnailPath: null,
          createdAt: DateTime.now(),
        );
        mediaAttachments.add(attachment);
      }

      // Save the moment with media attachments
      await momentStore.createMomentWithMedia(moment, mediaAttachments);

      // Success feedback
      HapticFeedback.lightImpact();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 8),
                Text(
                  _selectedMediaPaths.length == 1
                      ? 'Gallery moment saved!'
                      : '${_selectedMediaPaths.length} items saved!',
                ),
              ],
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );

        // Navigate back after short delay
        await Future.delayed(const Duration(milliseconds: 1500));
        if (mounted) {
          Navigator.of(context).pop();
        }
      }

      AppLogger.userAction('Gallery moment saved successfully');
    } catch (e) {
      AppLogger.error('Failed to save gallery moment', e);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save moment: $e'),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  void dispose() {
    _slideController.dispose();
    _textController.dispose();
    _textFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SystemUiWrapper(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: false,
        appBar: _buildAppBar(isDark),
        body: PremiumScreenBackground(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _currentPhase == 'select'
                ? _buildSelectionPhase(isDark)
                : _buildComposePhase(isDark),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(bool isDark) {
    final String title = _currentPhase == 'select'
        ? 'Choose from Gallery'
        : (_selectedMediaPaths.length == 1
              ? 'New Moment'
              : 'New Moment (${_selectedMediaPaths.length} items)');

    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      leadingWidth: 80,
      leading: Container(
        padding: const EdgeInsets.only(left: 20, top: 8, bottom: 8),
        alignment: Alignment.centerLeft,
        child: GestureDetector(
          onTap: _goBack,
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
        title,
        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: isDark
              ? AppColors.darkTextPrimary
              : AppColors.lightTextPrimary,
        ),
      ),
      actions: _currentPhase == 'compose'
          ? [
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: _isSaving
                    ? SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: isDark
                              ? AppColors.darkPrimary
                              : AppColors.lightPrimary,
                        ),
                      )
                    : PremiumButton(
                        text: 'Save',
                        onPressed: _saveMoment,
                        borderRadius: 18,
                        constraints: const BoxConstraints(maxWidth: 100),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 8,
                        ),
                        textMaxLines: 1,
                        textStyle: Theme.of(context).textTheme.bodySmall
                            ?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                        animationDuration: const Duration(milliseconds: 200),
                      ),
              ),
            ]
          : null,
    );
  }

  Widget _buildSelectionPhase(bool isDark) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + kToolbarHeight + 24,
        bottom: 40,
        left: 20,
        right: 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header section
          Text(
            'What would you like to add?',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: isDark
                  ? AppColors.darkTextPrimary
                  : AppColors.lightTextPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Choose media from your gallery or browse files from device storage to create a moment.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
          const SizedBox(height: 32),

          // Selection options
          _buildSelectionOption(
            isDark: isDark,
            icon: Icons.photo_library_rounded,
            title: 'From Gallery',
            subtitle: 'Select multiple photos or videos from gallery',
            onTap: _isLoading ? null : _pickFromGallery,
            color: Colors.blue,
          ),

          const SizedBox(height: 16),

          _buildSelectionOption(
            isDark: isDark,
            icon: Icons.folder_rounded,
            title: 'From Files',
            subtitle: 'Browse and select files from device storage',
            onTap: _isLoading ? null : _pickFromFiles,
            color: Colors.green,
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSelectionOption({
    required bool isDark,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback? onTap,
    required Color color,
  }) {
    final theme = Theme.of(context);

    return PremiumGlassCard(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: () {
            if (onTap != null) {
              AppLogger.userAction('Gallery selection option tapped', {
                'option': title.toLowerCase().replaceAll(' ', '_'),
              });
              onTap();
            }
          },
          borderRadius: BorderRadius.circular(12),
          splashColor: color.withValues(alpha: 0.1),
          highlightColor: color.withValues(alpha: 0.05),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.transparent, width: 1),
            ),
            child: Row(
              children: [
                // Enhanced icon with premium styling
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: color.withValues(alpha: 0.2),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: color.withValues(alpha: 0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(icon, size: 24, color: color),
                ),
                const SizedBox(width: 16),

                // Text content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.lightTextPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color:
                              (isDark
                                      ? AppColors.darkTextSecondary
                                      : AppColors.lightTextSecondary)
                                  .withValues(alpha: 0.7),
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),

                // Chevron with subtle styling
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: (isDark ? Colors.white : Colors.black).withValues(
                      alpha: 0.05,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.chevron_right_rounded,
                    size: 18,
                    color:
                        (isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.lightTextSecondary)
                            .withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildComposePhase(bool isDark) {
    return SlideTransition(
      position: _slideAnimation,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + kToolbarHeight + 24,
          bottom: 40,
          left: 20,
          right: 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Media preview section
            if (_selectedMediaPaths.isNotEmpty) ...[
              _buildMediaPreviewSection(isDark),
              const SizedBox(height: 24),
            ],

            // Text input section
            _buildTextInputSection(isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildMediaPreviewSection(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Row(
          children: [
            Icon(
              _selectedMediaPaths.length == 1
                  ? (_mediaTypes.first == MediaType.image
                        ? Icons.photo_camera
                        : Icons.videocam)
                  : Icons.photo_library,
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              _selectedMediaPaths.length == 1
                  ? 'Selected ${_mediaTypes.first == MediaType.image ? 'Photo' : 'Video'}'
                  : 'Selected ${_selectedMediaPaths.length} Items',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.lightTextPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Media preview
        PremiumGlassCard(
          padding: const EdgeInsets.all(12),
          child: SizedBox(
            height: 200,
            width: double.infinity,
            child: _buildMediaPreview(),
          ),
        ),
      ],
    );
  }

  Widget _buildTextInputSection(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Row(
          children: [
            Icon(
              Icons.edit_note,
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              'Description',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.lightTextPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Text input card
        PremiumGlassCard(
          child: TextField(
            controller: _textController,
            focusNode: _textFocus,
            maxLines: null,
            minLines: 6,
            decoration: InputDecoration(
              hintText: _selectedMediaPaths.length == 1
                  ? 'Describe this moment...'
                  : 'Describe these moments...',
              hintStyle: TextStyle(
                color:
                    (isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary)
                        .withValues(alpha: 0.6),
                fontSize: 16,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
              filled: false,
            ),
            style: TextStyle(
              color: isDark
                  ? AppColors.darkTextPrimary
                  : AppColors.lightTextPrimary,
              fontSize: 16,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMediaPreview() {
    if (_selectedMediaPaths.isEmpty) return const SizedBox.shrink();

    if (_selectedMediaPaths.length == 1) {
      // Single media preview
      return _buildSingleMediaPreview(
        _selectedMediaPaths[0],
        _mediaTypes[0],
        0,
      );
    } else {
      // Multiple media preview
      return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _selectedMediaPaths.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(
              right: index < _selectedMediaPaths.length - 1 ? 12 : 0,
            ),
            child: _buildSingleMediaPreview(
              _selectedMediaPaths[index],
              _mediaTypes[index],
              index,
            ),
          );
        },
      );
    }
  }

  Widget _buildSingleMediaPreview(
    String filePath,
    MediaType mediaType,
    int index,
  ) {
    final file = File(filePath);

    return PremiumGlassCard(
      padding: const EdgeInsets.all(8),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              width: _selectedMediaPaths.length == 1 ? double.infinity : 160,
              height: double.infinity,
              child: mediaType == MediaType.image
                  ? Image.file(file, fit: BoxFit.cover)
                  : Container(
                      color: Colors.black54,
                      child: const Center(
                        child: Icon(
                          Icons.videocam,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                    ),
            ),
          ),

          // Remove button
          if (_selectedMediaPaths.length > 1)
            Positioned(
              top: 4,
              right: 4,
              child: GestureDetector(
                onTap: () => _removeMedia(index),
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.8),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, color: Colors.white, size: 16),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
