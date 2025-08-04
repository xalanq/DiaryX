import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../models/draft.dart';
import '../../../widgets/annotated_region/system_ui_wrapper.dart';
import '../../../widgets/premium_glass_card/premium_glass_card.dart';
import '../../../widgets/gradient_background/gradient_background.dart';
import '../../../widgets/animations/premium_animations.dart';
import '../../../widgets/premium_button/premium_button.dart';
import '../../../widgets/audio_recorder/audio_player.dart';
import '../../../widgets/image_preview/premium_image_preview.dart';

import '../../../stores/moment_store.dart';
import '../../../models/moment.dart';
import '../../../models/mood.dart';
import '../../../models/media_attachment.dart';
import '../../../services/draft_service.dart';
import '../../../services/camera_service.dart';
import '../../../themes/app_colors.dart';
import '../../../utils/app_logger.dart';
import '../../../routes.dart';

/// Premium text moment creation screen with auto-save and modern UI
class TextMomentScreen extends StatefulWidget {
  final Moment? existingMoment;

  const TextMomentScreen({super.key, this.existingMoment});

  @override
  State<TextMomentScreen> createState() => _TextMomentScreenState();
}

class _TextMomentScreenState extends State<TextMomentScreen>
    with TickerProviderStateMixin {
  late TextEditingController _textController;
  late FocusNode _textFocusNode;
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  final DraftService _draftService = DraftService();
  Timer? _autoSaveTimer;
  List<String> _selectedMoods =
      []; // Multiple mood selection support with order
  List<DraftMediaData> _mediaAttachments = []; // Draft media attachments
  bool _isUnsaved = false;
  bool _isSaving = false;
  bool _isCreating = false;
  DateTime? _lastSaveTime;
  bool _isDraftLoaded = false;

  // Auto-save settings
  static const Duration _autoSaveDelay = Duration(seconds: 2);

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _initializeAnimations();
    _loadExistingContent();
    _loadDraftIfNeeded();
    _setupTextListener();

    AppLogger.userAction('Text moment screen opened', {
      'isEditing': widget.existingMoment != null,
    });
  }

  void _initializeControllers() {
    _textController = TextEditingController();
    _textFocusNode = FocusNode();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));
    _scaleAnimation = Tween<double>(
      begin: 0.95,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _scaleController, curve: Curves.easeOut));

    _fadeController.forward();
    _scaleController.forward();
  }

  void _loadExistingContent() {
    if (widget.existingMoment != null) {
      _textController.text = widget.existingMoment!.content;
      _selectedMoods = List<String>.from(
        widget.existingMoment!.moods,
      ); // Load all existing moods with order
    }
  }

  Future<void> _loadDraftIfNeeded({bool forceReload = false}) async {
    // Load appropriate state based on editing mode
    if (widget.existingMoment != null) {
      // Editing mode: load temporary editing state if force reload
      if (forceReload) {
        try {
          final editingTemp = _draftService.loadEditingTemp();
          if (editingTemp != null && mounted) {
            setState(() {
              _textController.text = editingTemp.content;
              // Load moods from editing temp
              _selectedMoods = List<String>.from(editingTemp.moods);
              // Load media attachments from editing temp
              _mediaAttachments = List<DraftMediaData>.from(
                editingTemp.mediaAttachments,
              );
              _isUnsaved = true;
            });

            AppLogger.info(
              'Loaded editing temp: ${editingTemp.content.length} chars, moods: ${_selectedMoods.join(", ")}, media: ${_mediaAttachments.length}',
            );

            // Clear editing temp after loading
            _draftService.clearEditingTemp();
          }
        } catch (e) {
          AppLogger.error('Failed to load editing temp', e);
        }
      }
    } else {
      // New moment mode: load draft
      if (!_isDraftLoaded || forceReload) {
        try {
          final draft = await _draftService.loadDraft();
          if (draft != null && mounted) {
            setState(() {
              _textController.text = draft.content;
              // Load moods from draft
              _selectedMoods = List<String>.from(draft.moods);
              // Load media attachments from draft
              _mediaAttachments = List<DraftMediaData>.from(
                draft.mediaAttachments,
              );
              _isDraftLoaded = true;
              if (draft.hasContent) {
                _isUnsaved = true;
              }
            });

            AppLogger.info(
              'Loaded draft: ${draft.content.length} chars, moods: ${_selectedMoods.join(", ")}, media: ${_mediaAttachments.length}',
            );
          } else {
            setState(() {
              _isDraftLoaded = false;
            });
          }
        } catch (e) {
          AppLogger.error('Failed to load draft', e);
          setState(() {
            _isDraftLoaded = false;
          });
        }
      }
    }
  }

  void _setupTextListener() {
    _textController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    setState(() {
      if (!_isUnsaved &&
          (_textController.text.isNotEmpty ||
              _selectedMoods.isNotEmpty ||
              _mediaAttachments.isNotEmpty)) {
        _isUnsaved = true;
      } else if (_isUnsaved &&
          _textController.text.isEmpty &&
          _selectedMoods.isEmpty &&
          _mediaAttachments.isEmpty) {
        _isUnsaved = false;
      }
    });

    // Auto-save draft for new moments only
    if (widget.existingMoment == null) {
      _draftService.autoSaveDraft(
        content: _textController.text,
        moods: _selectedMoods.isNotEmpty ? _selectedMoods : null,
        mediaAttachments: _mediaAttachments.isNotEmpty
            ? _mediaAttachments
            : null,
      );
    }

    // Reset auto-save timer for existing moments
    if (widget.existingMoment != null) {
      _autoSaveTimer?.cancel();
      if (_textController.text.trim().isNotEmpty) {
        _autoSaveTimer = Timer(_autoSaveDelay, _performAutoSave);
      }
    }
  }

  Future<void> _performAutoSave() async {
    if (_textController.text.trim().isEmpty || _isSaving) return;

    setState(() {
      _isSaving = true;
    });

    try {
      // Auto-save only updates local state and existing moment, doesn't create new moment
      if (widget.existingMoment != null) {
        // If editing existing moment, update database
        if (!mounted) return;
        final momentStore = Provider.of<MomentStore>(context, listen: false);

        final updatedMoment = widget.existingMoment!.copyWith(
          content: _textController.text.trim(),
          moods: _selectedMoods,
          updatedAt: DateTime.now(),
        );
        await momentStore.updateMoment(updatedMoment);
        AppLogger.info('Auto-saved existing moment update');
      } else {
        // If new moment, auto-save only saves local state, doesn't create database record
        AppLogger.info('Auto-save: content cached locally (not published)');
      }

      if (mounted) {
        setState(() {
          _isUnsaved = false;
          _lastSaveTime = DateTime.now();
        });
      }

      // Show success feedback
      await Future.delayed(const Duration(milliseconds: 500));
    } catch (e) {
      AppLogger.error('Auto-save failed', e);
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  Future<void> _createMoment() async {
    if (_textController.text.trim().isEmpty) {
      if (mounted) {
        AppRoutes.pop(context);
      }
      return;
    }

    setState(() {
      _isCreating = true;
    });

    try {
      if (!mounted) return;
      final momentStore = Provider.of<MomentStore>(context, listen: false);

      if (widget.existingMoment != null) {
        // Update existing moment
        final updatedMoment = widget.existingMoment!.copyWith(
          content: _textController.text.trim(),
          moods: _selectedMoods,
          updatedAt: DateTime.now(),
        );
        await momentStore.updateMoment(updatedMoment);
        AppLogger.info('Updated existing moment');
      } else {
        // Create new moment with media attachments
        final moods = _selectedMoods.isNotEmpty ? _selectedMoods : <String>[];

        // Separate media by type
        final images = <MediaAttachment>[];
        final audios = <MediaAttachment>[];
        final videos = <MediaAttachment>[];

        for (final draftMedia in _mediaAttachments) {
          final mediaAttachment = MediaAttachment(
            filePath: draftMedia.filePath,
            mediaType: draftMedia.mediaType,
            fileSize: draftMedia.fileSize,
            duration: draftMedia.duration,
            thumbnailPath: draftMedia.thumbnailPath,
            createdAt: DateTime.now(),
            momentId: 0, // Will be set when saving
          );

          switch (draftMedia.mediaType) {
            case MediaType.image:
              images.add(mediaAttachment);
              break;
            case MediaType.audio:
              audios.add(mediaAttachment);
              break;
            case MediaType.video:
              videos.add(mediaAttachment);
              break;
          }
        }

        final newMoment = Moment(
          content: _textController.text.trim(),
          moods: moods,
          images: images,
          audios: audios,
          videos: videos,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        final success = await momentStore.createMoment(newMoment);
        if (success) {
          // Clear draft after successful creation
          await _draftService.clearDraft();
          AppLogger.info(
            'Created new moment with ${_mediaAttachments.length} media attachments and cleared draft',
          );
        }
      }

      HapticFeedback.mediumImpact();

      // Add success animation
      if (mounted) {
        await _scaleController.reverse();
        await _scaleController.forward();
      }

      if (mounted) {
        AppRoutes.pop(
          context,
          true,
        ); // Return true to indicate moment was saved
      }
    } catch (e) {
      AppLogger.error('Failed to create moment', e);
      if (mounted) {
        setState(() {
          _isCreating = false;
        });

        // Show error feedback
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create moment: ${e.toString()}'),
            backgroundColor: Colors.red.shade600,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    }
  }

  void _onMoodSelectedString(String mood) {
    final wasSelected = _selectedMoods.contains(mood);

    setState(() {
      // If clicked mood is already selected, deselect it; otherwise add it to selection in order
      if (wasSelected) {
        _selectedMoods.remove(mood); // Deselect - remove from list
      } else {
        _selectedMoods.add(
          mood,
        ); // Add to selection at the end (preserves order)
      }
      _isUnsaved = true;
    });

    HapticFeedback.selectionClick();
    AppLogger.userAction('Mood selected', {
      'moods': _selectedMoods,
      'mood': mood,
      'action': wasSelected ? 'deselected' : 'selected',
    });

    // Auto-save draft for new moments
    if (widget.existingMoment == null) {
      _draftService.autoSaveDraft(
        content: _textController.text,
        moods: _selectedMoods.isNotEmpty ? _selectedMoods : null,
        mediaAttachments: _mediaAttachments.isNotEmpty
            ? _mediaAttachments
            : null,
      );
    } else {
      // Trigger auto-save for existing moments
      _autoSaveTimer?.cancel();
      _autoSaveTimer = Timer(_autoSaveDelay, _performAutoSave);
    }
  }

  Future<void> _handleBackNavigation() async {
    // Save draft when navigating back (for new moments only)
    if (widget.existingMoment == null) {
      await _draftService.saveDraft(
        content: _textController.text,
        moods: _selectedMoods.isNotEmpty ? _selectedMoods : null,
        mediaAttachments: _mediaAttachments.isNotEmpty
            ? _mediaAttachments
            : null,
      );
    } else if (_isUnsaved && _textController.text.trim().isNotEmpty) {
      // Auto-save existing moment if unsaved
      await _performAutoSave();
    }

    if (mounted) {
      AppRoutes.pop(context);
    }
  }

  // Media attachment methods
  Future<void> _showMediaSelectionDialog() async {
    final selectedOption = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _MediaSelectionBottomSheet(),
    );

    if (selectedOption != null && mounted) {
      switch (selectedOption) {
        case 'camera':
          await _takePhoto();
          break;
        case 'gallery':
          await _pickFromGallery();
          break;
        case 'voice':
          await _recordVoice();
          break;
        case 'video':
          await _recordVideo();
          break;
      }
    }
  }

  Future<void> _takePhoto() async {
    try {
      // Save current state to draft before navigating
      await _saveCurrentStateToDraft();

      if (!mounted) return;

      // Navigate to camera moment screen for camera capture
      final result = await AppRoutes.toCameraMoment(
        context,
        isFromTextMoment: true,
        isEditingMode: widget.existingMoment != null,
      );
      if (result == true) {
        // Reload draft to get the media added by camera moment screen
        await _loadDraftIfNeeded(forceReload: true);
      }
    } catch (e) {
      AppLogger.error('Failed to take photo', e);
      if (mounted) {
        _showErrorSnackBar('Failed to take photo');
      }
    }
  }

  Future<void> _pickFromGallery() async {
    try {
      // Save current state to draft before media selection
      await _saveCurrentStateToDraft();

      if (!mounted) return;

      // Direct call to system gallery multi-select
      final CameraService cameraService = CameraService.instance;
      final List<String> mediaPaths = await cameraService
          .pickMultipleImagesFromGallery();

      if (mediaPaths.isNotEmpty && mounted) {
        // Create draft media data list
        final List<DraftMediaData> galleryMedia = [];

        for (final path in mediaPaths) {
          final media = DraftMediaData(
            filePath: path,
            mediaType: MediaType.image, // Default to image for gallery picks
          );
          galleryMedia.add(media);
        }

        // Add media based on editing mode
        if (widget.existingMoment != null) {
          // Editing mode: add to temporary editing state
          _draftService.addMultipleMediaToEditingTemp(galleryMedia);
        } else {
          // New moment mode: add to draft
          await _draftService.addMultipleMediaToDraft(galleryMedia);
        }

        AppLogger.userAction(
          '${mediaPaths.length} items selected from gallery and added',
          {'editing_mode': widget.existingMoment != null},
        );

        // Reload draft to show the newly added media
        await _loadDraftIfNeeded(forceReload: true);
      }
    } catch (e) {
      AppLogger.error('Failed to pick from gallery', e);
      if (mounted) {
        _showErrorSnackBar('Failed to pick from gallery');
      }
    }
  }

  Future<void> _recordVoice() async {
    // Save current state to draft before navigating
    await _saveCurrentStateToDraft();

    if (!mounted) return;

    // Navigate to voice moment screen - it will add audio to draft and return here
    final result = await AppRoutes.toVoiceMoment(
      context,
      isFromTextMoment: true,
      isEditingMode: widget.existingMoment != null,
    );
    if (result == true) {
      // Reload draft to get the audio added by voice moment screen
      await _loadDraftIfNeeded(forceReload: true);
    }
  }

  Future<void> _recordVideo() async {
    try {
      // Save current state to draft before navigating
      await _saveCurrentStateToDraft();

      if (!mounted) return;

      // Navigate to camera moment screen for video recording
      final result = await AppRoutes.toCameraMoment(
        context,
        isFromTextMoment: true,
        isEditingMode: widget.existingMoment != null,
      );
      if (result == true) {
        // Reload draft to get the media added by camera moment screen
        await _loadDraftIfNeeded(forceReload: true);
      }
    } catch (e) {
      AppLogger.error('Failed to record video', e);
      if (mounted) {
        _showErrorSnackBar('Failed to record video');
      }
    }
  }

  /// Save current state before navigating to other moment screens
  Future<void> _saveCurrentStateToDraft() async {
    try {
      if (widget.existingMoment != null) {
        // Editing mode: save to temporary editing state
        _draftService.saveEditingTemp(
          content: _textController.text,
          moods: _selectedMoods.isNotEmpty ? _selectedMoods : null,
          mediaAttachments: _mediaAttachments.isNotEmpty
              ? _mediaAttachments
              : null,
        );

        AppLogger.info(
          'Saved current state to editing temp before navigation: '
          '${_textController.text.length} chars, '
          '${_selectedMoods.length} moods, '
          '${_mediaAttachments.length} media',
        );
      } else {
        // New moment mode: save to draft
        await _draftService.saveDraft(
          content: _textController.text,
          moods: _selectedMoods.isNotEmpty ? _selectedMoods : null,
          mediaAttachments: _mediaAttachments.isNotEmpty
              ? _mediaAttachments
              : null,
        );

        AppLogger.info(
          'Saved current state to draft before navigation: '
          '${_textController.text.length} chars, '
          '${_selectedMoods.length} moods, '
          '${_mediaAttachments.length} media',
        );
      }
    } catch (e) {
      AppLogger.error('Failed to save current state', e);
    }
  }

  Future<void> _removeMediaAttachment(int index) async {
    if (index >= 0 && index < _mediaAttachments.length) {
      setState(() {
        _mediaAttachments.removeAt(index);
        _isUnsaved = true;
      });

      // Auto-save after removal
      if (widget.existingMoment == null) {
        await _draftService.saveDraft(
          content: _textController.text,
          moods: _selectedMoods.isNotEmpty ? _selectedMoods : null,
          mediaAttachments: _mediaAttachments.isNotEmpty
              ? _mediaAttachments
              : null,
        );
      }

      HapticFeedback.selectionClick();
      AppLogger.userAction('Media removed from text moment');
    }
  }

  void _showErrorSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red.shade600,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }

  /// Check if there are unsaved changes in editing mode
  bool _hasUnsavedChanges() {
    if (widget.existingMoment == null) {
      return false; // Only check in editing mode
    }

    final existingMoment = widget.existingMoment!;

    // Check text changes
    final currentText = _textController.text.trim();
    if (currentText != existingMoment.content.trim()) {
      return true;
    }

    // Check mood changes
    final currentMoods = _selectedMoods.toSet();
    final existingMoods = existingMoment.moods.toSet();
    if (currentMoods.length != existingMoods.length ||
        !currentMoods.every(existingMoods.contains)) {
      return true;
    }

    // Check media changes (simplified - check count for now)
    final currentMediaCount = _mediaAttachments.length;
    final existingMediaCount =
        existingMoment.images.length +
        existingMoment.audios.length +
        existingMoment.videos.length;
    if (currentMediaCount != existingMediaCount) {
      return true;
    }

    // Check if there's unsaved editing temp data
    if (_draftService.hasUnsavedEditingTemp()) {
      return true;
    }

    return false;
  }

  /// Show exit confirmation dialog for editing mode
  Future<bool> _showExitConfirmationDialog() async {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: isDark
            ? AppColors.darkSurface
            : AppColors.lightSurface,
        title: Text(
          'Unsaved Changes',
          style: TextStyle(
            color: isDark
                ? AppColors.darkTextPrimary
                : AppColors.lightTextPrimary,
          ),
        ),
        content: Text(
          'You have unsaved changes. Are you sure you want to exit without saving?',
          style: TextStyle(
            color: isDark
                ? AppColors.darkTextSecondary
                : AppColors.lightTextSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              'Exit Without Saving',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );

    return result ?? false;
  }

  /// Handle back button press for editing mode
  Future<bool> _onWillPop() async {
    // Only show confirmation in editing mode with unsaved changes
    if (widget.existingMoment != null && _hasUnsavedChanges()) {
      final shouldExit = await _showExitConfirmationDialog();
      if (shouldExit) {
        // Clear editing temp data on exit
        _draftService.clearEditingTemp();
        AppLogger.info('Exited editing mode, cleared editing temp data');
      }
      return shouldExit;
    }

    // For new moment mode or no changes, allow normal back
    return true;
  }

  @override
  void dispose() {
    _autoSaveTimer?.cancel();
    _draftService.cancelAutoSave();
    _textController.dispose();
    _textFocusNode.dispose();
    _fadeController.dispose();
    _scaleController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return PopScope(
      canPop: false, // Always handle pop manually
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          final shouldPop = await _onWillPop();
          if (shouldPop && context.mounted) {
            Navigator.of(context).pop();
          }
        }
      },
      child: SystemUiWrapper(
        child: AnimatedBuilder(
          animation: _fadeAnimation,
          builder: (context, child) {
            return FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: GestureDetector(
                  onTap: () {
                    // Tap empty area to dismiss keyboard
                    FocusScope.of(context).unfocus();
                  },
                  child: Scaffold(
                    extendBodyBehindAppBar: true,
                    resizeToAvoidBottomInset:
                        false, // Prevent background from moving when keyboard appears
                    appBar: _buildAppBar(isDark),
                    body: PremiumScreenBackground(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.only(
                          top:
                              MediaQuery.of(context).padding.top +
                              kToolbarHeight +
                              24,
                          bottom: 40,
                          left: 20,
                          right: 20,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header with enhanced animations
                            FadeInSlideUp(child: _buildHeader(isDark)),
                            const SizedBox(height: 24),

                            // Text editor with enhanced glass morphism
                            FadeInSlideUp(
                              delay: const Duration(milliseconds: 200),
                              child: _buildTextEditor(isDark),
                            ),
                            const SizedBox(height: 24),

                            // Media attachments display
                            if (_mediaAttachments.isNotEmpty)
                              FadeInSlideUp(
                                delay: const Duration(milliseconds: 300),
                                child: _buildMediaAttachments(isDark),
                              ),
                            if (_mediaAttachments.isNotEmpty)
                              const SizedBox(height: 16),

                            // Mood selector with enhanced design
                            FadeInSlideUp(
                              delay: const Duration(milliseconds: 400),
                              child: _buildMoodSelector(isDark),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(bool isDark) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      leadingWidth: 80, // Fixed width for consistent alignment
      leading: Container(
        padding: const EdgeInsets.only(left: 20, top: 8, bottom: 8),
        alignment: Alignment.centerLeft,
        child: GestureDetector(
          onTap: _handleBackNavigation,
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
        widget.existingMoment != null ? 'Edit Moment' : 'New Moment',
        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: isDark
              ? AppColors.darkTextPrimary
              : AppColors.lightTextPrimary,
        ),
      ),
      actions: [
        // Save button using PremiumButton component
        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: _isCreating
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
                  text: widget.existingMoment != null ? 'Update' : 'Create',
                  onPressed: _textController.text.trim().isNotEmpty
                      ? _createMoment
                      : null,
                  borderRadius: 18,
                  constraints: BoxConstraints(maxWidth: 100),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 8,
                  ),
                  textMaxLines: 1,
                  textStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.white, // Ensure text color is white
                  ),
                  animationDuration: const Duration(milliseconds: 200),
                ),
        ),
      ],
    );
  }

  Widget _buildHeader(bool isDark) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'What\'s on your mind?',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: isDark
                ? AppColors.darkTextPrimary
                : AppColors.lightTextPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Write down your thoughts, experiences, or anything you want to remember.',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: isDark
                ? AppColors.darkTextSecondary
                : AppColors.lightTextSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildTextEditor(bool isDark) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text input card
        PremiumGlassCard(
          child: TextField(
            controller: _textController,
            focusNode: _textFocusNode,
            maxLines: null,
            minLines: 8,
            decoration: InputDecoration(
              hintText: 'Start typing your moment...',
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
              // Remove any background color to match card
              filled: false,
            ),
            style: TextStyle(
              color: isDark
                  ? AppColors.darkTextPrimary
                  : AppColors.lightTextPrimary,
              fontSize: 16,
              height: 1.6,
              // Remove any background color
              backgroundColor: Colors.transparent,
            ),
            textCapitalization: TextCapitalization.sentences,
            keyboardType: TextInputType.multiline,
            autofocus:
                widget.existingMoment == null, // Auto focus for new moments
          ),
        ),

        // Auto-save status and add media button
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            children: [
              if (_lastSaveTime != null) ...[
                Icon(
                  Icons.check_circle_rounded,
                  size: 14,
                  color: Colors.green.shade600,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Saved ${_formatSaveTime(_lastSaveTime!)}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.green.shade600,
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                ),
              ] else if (_isSaving) ...[
                SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: isDark
                        ? AppColors.darkPrimary
                        : AppColors.lightPrimary,
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Saving...',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isDark
                          ? AppColors.darkPrimary
                          : AppColors.lightPrimary,
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                ),
              ] else ...[
                Icon(
                  Icons.auto_awesome_rounded,
                  size: 14,
                  color:
                      (isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary)
                          .withValues(alpha: 0.6),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    widget.existingMoment != null
                        ? 'Auto-saves'
                        : 'Draft auto-saved',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color:
                          (isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.lightTextSecondary)
                              .withValues(alpha: 0.6),
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
              // Add media button with premium glass morphism design
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      (isDark ? AppColors.darkPrimary : AppColors.lightPrimary)
                          .withValues(alpha: 0.15),
                      (isDark ? AppColors.darkAccent : AppColors.lightAccent)
                          .withValues(alpha: 0.08),
                    ],
                  ),
                  border: Border.all(
                    color:
                        (isDark
                                ? AppColors.darkPrimary
                                : AppColors.lightPrimary)
                            .withValues(alpha: 0.3),
                    width: 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color:
                          (isDark
                                  ? AppColors.darkPrimary
                                  : AppColors.lightPrimary)
                              .withValues(alpha: 0.2),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                      spreadRadius: -2,
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    onTap: _showMediaSelectionDialog,
                    borderRadius: BorderRadius.circular(12),
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
                    child: SizedBox(
                      width: 36,
                      height: 36,
                      child: Icon(
                        Icons.add_rounded,
                        size: 20,
                        color: isDark
                            ? AppColors.darkPrimary
                            : AppColors.lightPrimary,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMoodSelector(bool isDark) {
    final theme = Theme.of(context);
    final moodOptions = MoodUtils.allMoodOptions;

    return PremiumGlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'How are you feeling?',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: isDark
                  ? AppColors.darkTextPrimary
                  : AppColors.lightTextPrimary,
            ),
          ),
          const SizedBox(height: 16),
          // Mood options in organized rows (3x3 grid layout)
          Column(
            children: [
              // First row - 3 moods
              Row(
                children: [
                  Expanded(child: _buildMoodButton(moodOptions[0], isDark)),
                  const SizedBox(width: 12),
                  Expanded(child: _buildMoodButton(moodOptions[1], isDark)),
                  const SizedBox(width: 12),
                  Expanded(child: _buildMoodButton(moodOptions[2], isDark)),
                ],
              ),
              const SizedBox(height: 12),
              // Second row - 3 moods
              Row(
                children: [
                  Expanded(child: _buildMoodButton(moodOptions[3], isDark)),
                  const SizedBox(width: 12),
                  Expanded(child: _buildMoodButton(moodOptions[4], isDark)),
                  const SizedBox(width: 12),
                  Expanded(child: _buildMoodButton(moodOptions[5], isDark)),
                ],
              ),
              const SizedBox(height: 12),
              // Third row - 3 moods
              Row(
                children: [
                  Expanded(child: _buildMoodButton(moodOptions[6], isDark)),
                  const SizedBox(width: 12),
                  Expanded(child: _buildMoodButton(moodOptions[7], isDark)),
                  const SizedBox(width: 12),
                  Expanded(child: _buildMoodButton(moodOptions[8], isDark)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Build individual mood button matching capture screen style
  Widget _buildMoodButton(MoodOption moodOption, bool isDark) {
    final isSelected = _selectedMoods.contains(moodOption.value);

    return GestureDetector(
      onTap: () => _onMoodSelectedString(moodOption.value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 70, // Fixed height for consistency
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          // Use same background color consistently, no longer distinguish selected state by color depth
          color: moodOption.color.withValues(alpha: isSelected ? 0.15 : 0.08),
          border: Border.all(
            color: moodOption.color.withValues(alpha: isSelected ? 0.4 : 0.25),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Stack(
          children: [
            // Main content - use Center to ensure perfect centering
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(moodOption.emoji, style: const TextStyle(fontSize: 20)),
                  const SizedBox(height: 4),
                  Text(
                    moodOption.label,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: 11,
                      color:
                          (isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.lightTextSecondary)
                              .withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ),
            // Check mark for selected state
            if (isSelected)
              Positioned(
                top: 6,
                right: 6,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: moodOption.color,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 2,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    color: Colors.white,
                    size: 14,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMediaAttachments(bool isDark) {
    final theme = Theme.of(context);

    // Separate media by type, prioritizing audio first
    final audioAttachments = _mediaAttachments
        .asMap()
        .entries
        .where((entry) => entry.value.mediaType == MediaType.audio)
        .toList();

    final imageAttachments = _mediaAttachments
        .asMap()
        .entries
        .where((entry) => entry.value.mediaType == MediaType.image)
        .toList();

    final videoAttachments = _mediaAttachments
        .asMap()
        .entries
        .where((entry) => entry.value.mediaType == MediaType.video)
        .toList();

    return PremiumGlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with attachment count
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color:
                      (isDark ? AppColors.darkPrimary : AppColors.lightPrimary)
                          .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.attachment_rounded,
                  size: 16,
                  color: isDark
                      ? AppColors.darkPrimary
                      : AppColors.lightPrimary,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Attachments (${_mediaAttachments.length})',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary,
                ),
              ),
            ],
          ),

          if (_mediaAttachments.isNotEmpty) ...[
            const SizedBox(height: 16),

            // Audio attachments - full width with playback
            if (audioAttachments.isNotEmpty) ...[
              ...audioAttachments.map((entry) {
                final index = entry.key;
                final media = entry.value;
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: _buildAudioAttachment(media, index, isDark),
                );
              }),

              // Add spacing if there are other media types after audio
              if (imageAttachments.isNotEmpty || videoAttachments.isNotEmpty)
                const SizedBox(height: 8),
            ],

            // Image and video attachments - grid layout
            if (imageAttachments.isNotEmpty || videoAttachments.isNotEmpty) ...[
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.0,
                ),
                padding: EdgeInsets.zero,
                itemCount: imageAttachments.length + videoAttachments.length,
                itemBuilder: (context, gridIndex) {
                  // Combine image and video attachments for grid display
                  final allGridAttachments = [
                    ...imageAttachments,
                    ...videoAttachments,
                  ];
                  final entry = allGridAttachments[gridIndex];
                  final index = entry.key;
                  final media = entry.value;
                  return _buildMediaTile(media, index, isDark);
                },
              ),
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildAudioAttachment(DraftMediaData media, int index, bool isDark) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Audio player with its own glass background
        PremiumAudioPlayer(
          audioPath: media.filePath,
          showDuration: true,
          onPlayStateChanged: (isPlaying) {
            HapticFeedback.lightImpact();
          },
        ),

        // Subtle remove button at the right-top center
        Positioned(
          top: -5,
          right: -5,
          child: GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              _removeMediaAttachment(index);
            },
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: isDark ? Colors.black.withValues(alpha: 0.2) : null,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.3)
                      : Colors.black.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: Icon(
                Icons.close_rounded,
                color: isDark
                    ? Colors.white.withValues(alpha: 0.5)
                    : Colors.black.withValues(alpha: 0.2),
                size: 13,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMediaTile(DraftMediaData media, int index, bool isDark) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  (isDark ? Colors.white : Colors.black).withValues(
                    alpha: 0.08,
                  ),
                  (isDark ? Colors.white : Colors.black).withValues(
                    alpha: 0.02,
                  ),
                ],
              ),
              border: Border.all(
                color: (isDark ? Colors.white : Colors.black).withValues(
                  alpha: 0.12,
                ),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                  spreadRadius: -2,
                ),
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.1 : 0.04),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                  spreadRadius: -1,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: _buildMediaContent(media, isDark),
            ),
          ),
          // Subtle remove button consistent with audio player
          Positioned(
            top: -5,
            right: -5,
            child: GestureDetector(
              onTap: () {
                HapticFeedback.lightImpact();
                _removeMediaAttachment(index);
              },
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: isDark ? Colors.black.withValues(alpha: 0.2) : null,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.3)
                        : Colors.black.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                child: Icon(
                  Icons.close_rounded,
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.5)
                      : Colors.black.withValues(alpha: 0.2),
                  size: 13,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMediaContent(DraftMediaData media, bool isDark) {
    switch (media.mediaType) {
      case MediaType.image:
        return GestureDetector(
          onTap: () => _showImagePreview(media.filePath),
          child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Hero widget for smooth image preview transition
                Hero(
                  tag: 'image_${media.filePath}',
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.file(
                      File(media.filePath),
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                      errorBuilder: (context, error, stackTrace) {
                        return _buildMediaPlaceholder(
                          Icons.broken_image_rounded,
                          isDark,
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      case MediaType.video:
        return GestureDetector(
          onTap: () => _showVideoPreview(media),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Video thumbnail with hero animation support
              Hero(
                tag: 'video_${media.filePath}',
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.file(
                    File(media.thumbnailPath ?? media.filePath),
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                    errorBuilder: (context, error, stackTrace) {
                      return _buildMediaPlaceholder(
                        Icons.video_file_rounded,
                        isDark,
                      );
                    },
                  ),
                ),
              ),
              // Video play button with enhanced glass morphism
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.black.withValues(alpha: 0.7),
                      Colors.black.withValues(alpha: 0.5),
                    ],
                  ),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.3),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.play_arrow_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              // Video duration indicator
              if (media.duration != null)
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.2),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      _formatDuration(media.duration!),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      case MediaType.audio:
        // Audio attachments are handled separately in _buildAudioAttachment
        return _buildMediaPlaceholder(Icons.audio_file_rounded, isDark);
    }
  }

  Widget _buildMediaPlaceholder(IconData icon, bool isDark) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            (isDark ? Colors.white : Colors.black).withValues(alpha: 0.08),
            (isDark ? Colors.white : Colors.black).withValues(alpha: 0.03),
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color:
                  (isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary)
                      .withValues(alpha: 0.1),
            ),
            child: Icon(
              icon,
              size: 24,
              color:
                  (isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary)
                      .withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            icon == Icons.audio_file_rounded
                ? 'AUDIO'
                : icon == Icons.video_file_rounded
                ? 'VIDEO'
                : 'MEDIA',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color:
                  (isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary)
                      .withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  String _formatSaveTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inSeconds < 60) {
      return 'just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else {
      return '${difference.inHours}h ago';
    }
  }

  /// Show premium image gallery with smooth hero animation
  Future<void> _showImagePreview(String imagePath) async {
    try {
      HapticFeedback.lightImpact();
      AppLogger.userAction('Image preview opened from text moment');

      // Get all image paths from media attachments
      final allImagePaths = _mediaAttachments
          .where((media) => media.mediaType == MediaType.image)
          .map((media) => media.filePath)
          .toList();

      // Find the index of the clicked image
      final initialIndex = allImagePaths.indexOf(imagePath);

      if (allImagePaths.length == 1) {
        // Single image mode
        await PremiumImagePreview.showSingle(
          context,
          imagePath,
          heroTag: 'image_$imagePath',
          enableHeroAnimation: true,
        );
      } else if (allImagePaths.length > 1) {
        // Gallery mode for multiple images
        await PremiumImagePreview.showGallery(
          context,
          allImagePaths,
          initialIndex: initialIndex >= 0 ? initialIndex : 0,
          heroTag: 'image_$imagePath',
        );
      }
    } catch (e) {
      AppLogger.error('Failed to show image preview', e);
      _showErrorSnackBar('Failed to open image preview');
    }
  }

  /// Show video preview or player (placeholder for future implementation)
  Future<void> _showVideoPreview(DraftMediaData media) async {
    try {
      HapticFeedback.lightImpact();
      AppLogger.userAction('Video preview requested from text moment');

      // TODO: Implement video preview/player functionality
      // For now, show a message that video preview is coming soon
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Video preview coming soon'),
          backgroundColor: Colors.blue.shade600,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    } catch (e) {
      AppLogger.error('Failed to show video preview', e);
      _showErrorSnackBar('Failed to open video preview');
    }
  }

  /// Format duration in seconds to readable string (e.g., "1:23")
  String _formatDuration(double durationInSeconds) {
    final duration = Duration(seconds: durationInSeconds.round());
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }
}

/// Media selection bottom sheet with modern glass morphism design
class _MediaSelectionBottomSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: (isDark ? Colors.black : Colors.white).withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: (isDark ? Colors.white : Colors.black).withValues(
                alpha: 0.3,
              ),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Text(
                  'Add Media',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary,
                  ),
                ),
                const SizedBox(height: 24),

                // Media options
                Row(
                  children: [
                    Expanded(
                      child: _MediaOptionButton(
                        icon: Icons.camera_alt_rounded,
                        label: 'Camera',
                        color: Colors.green,
                        onTap: () => AppRoutes.pop(context, 'camera'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _MediaOptionButton(
                        icon: Icons.photo_library_rounded,
                        label: 'Gallery',
                        color: Colors.blue,
                        onTap: () => AppRoutes.pop(context, 'gallery'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _MediaOptionButton(
                        icon: Icons.mic_rounded,
                        label: 'Voice',
                        color: Colors.orange,
                        onTap: () => AppRoutes.pop(context, 'voice'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _MediaOptionButton(
                        icon: Icons.videocam_rounded,
                        label: 'Video',
                        color: Colors.purple,
                        onTap: () => AppRoutes.pop(context, 'video'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Modern media option button with glass morphism
class _MediaOptionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _MediaOptionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.2), width: 1),
        ),
        child: Column(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 24, color: color),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.lightTextPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
