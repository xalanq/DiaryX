import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:drift/drift.dart' hide Column;

import '../../../widgets/annotated_region/system_ui_wrapper.dart';
import '../../../widgets/premium_glass_card/premium_glass_card.dart';
import '../../../widgets/gradient_background/gradient_background.dart';
import '../../../widgets/animations/premium_animations.dart';
import '../../../widgets/premium_button/premium_button.dart';
import '../../../stores/moment_store.dart';
import '../../../models/moment.dart';
import '../../../models/mood.dart';
import '../../../databases/app_database.dart';
import '../../../services/draft_service.dart';
import '../../../themes/app_colors.dart';
import '../../../utils/app_logger.dart';

/// Premium text moment creation screen with auto-save and modern UI
class TextMomentScreen extends StatefulWidget {
  final MomentData? existingMoment;

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
      final moodsList = _parseMoodsFromJson(widget.existingMoment!.moods);
      _selectedMoods = List<String>.from(
        moodsList,
      ); // Load all existing moods with order
    }
  }

  Future<void> _loadDraftIfNeeded() async {
    // Only load draft for new moments (not editing existing ones)
    if (widget.existingMoment == null && !_isDraftLoaded) {
      try {
        final draft = await _draftService.loadDraft();
        if (draft != null && mounted) {
          setState(() {
            _textController.text = draft.content;
            // Load moods from draft
            _selectedMoods = List<String>.from(draft.moods);
            _isDraftLoaded = true;
            if (draft.content.isNotEmpty || draft.moods.isNotEmpty) {
              _isUnsaved = true;
            }
          });

          AppLogger.info(
            'Loaded draft: ${draft.content.length} chars, moods: ${_selectedMoods.join(", ")}',
          );
        }
      } catch (e) {
        AppLogger.error('Failed to load draft', e);
      }
    }
  }

  void _setupTextListener() {
    _textController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    setState(() {
      if (!_isUnsaved &&
          (_textController.text.isNotEmpty || _selectedMoods.isNotEmpty)) {
        _isUnsaved = true;
      } else if (_isUnsaved &&
          _textController.text.isEmpty &&
          _selectedMoods.isEmpty) {
        _isUnsaved = false;
      }
    });

    // Auto-save draft for new moments only
    if (widget.existingMoment == null) {
      _draftService.autoSaveDraft(
        content: _textController.text,
        moods: _selectedMoods.isNotEmpty ? _selectedMoods : null,
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

        final moodsJson = _selectedMoods.isNotEmpty
            ? jsonEncode(_selectedMoods)
            : null;
        final updatedMoment = widget.existingMoment!.copyWith(
          content: _textController.text.trim(),
          moods: Value(moodsJson),
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
        Navigator.of(context).pop();
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
        final moodsJson = _selectedMoods.isNotEmpty
            ? jsonEncode(_selectedMoods)
            : null;
        final updatedMoment = widget.existingMoment!.copyWith(
          content: _textController.text.trim(),
          moods: Value(moodsJson),
          updatedAt: DateTime.now(),
        );
        await momentStore.updateMoment(updatedMoment);
        AppLogger.info('Updated existing moment');
      } else {
        // Create new moment and clear draft
        final moods = _selectedMoods.isNotEmpty ? _selectedMoods : null;
        await momentStore.createMoment(
          content: _textController.text.trim(),
          contentType: ContentType.text,
          moods: moods,
        );

        // Clear draft after successful creation
        await _draftService.clearDraft();
        AppLogger.info('Created new moment and cleared draft');
      }

      HapticFeedback.mediumImpact();

      // Add success animation
      if (mounted) {
        await _scaleController.reverse();
        await _scaleController.forward();
      }

      if (mounted) {
        Navigator.of(
          context,
        ).pop(true); // Return true to indicate moment was saved
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
      );
    } else if (_isUnsaved && _textController.text.trim().isNotEmpty) {
      // Auto-save existing moment if unsaved
      await _performAutoSave();
    }

    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  /// Helper method to parse moods from JSON string
  List<String> _parseMoodsFromJson(String? moodsJson) {
    if (moodsJson == null || moodsJson.isEmpty) return [];
    try {
      final decoded = jsonDecode(moodsJson);
      if (decoded is List) {
        return decoded.cast<String>();
      }
      return [];
    } catch (e) {
      return [];
    }
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

    return SystemUiWrapper(
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
                      physics: const BouncingScrollPhysics(),
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
                          const SizedBox(height: 32),

                          // Text editor with enhanced glass morphism
                          FadeInSlideUp(
                            delay: const Duration(milliseconds: 200),
                            child: _buildTextEditor(isDark),
                          ),
                          const SizedBox(height: 32),

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
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
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

        // Auto-save status and character count
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
}
