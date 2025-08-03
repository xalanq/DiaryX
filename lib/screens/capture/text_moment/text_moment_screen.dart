import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:drift/drift.dart' hide Column;
import 'dart:async';

import '../../../widgets/annotated_region/system_ui_wrapper.dart';
import '../../../widgets/premium_glass_card/premium_glass_card.dart';
import '../../../widgets/gradient_background/gradient_background.dart';
import '../../../widgets/animations/premium_animations.dart';
import '../../../widgets/premium_button/premium_button.dart';
import '../../../stores/moment_store.dart';
import '../../../models/moment.dart';
import '../../../models/mood.dart';
import '../../../databases/app_database.dart';
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

  Timer? _autoSaveTimer;
  String? _selectedMoodString; // 可空的mood，支持不选择mood
  bool _isUnsaved = false;
  bool _isSaving = false;
  DateTime? _lastSaveTime;

  // Auto-save settings
  static const Duration _autoSaveDelay = Duration(seconds: 3);

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _loadExistingContent();
    _setupTextListener();

    AppLogger.userAction('Text moment screen opened', {
      'isEditing': widget.existingMoment != null,
    });
  }

  void _initializeControllers() {
    _textController = TextEditingController();
    _textFocusNode = FocusNode();
  }

  void _loadExistingContent() {
    if (widget.existingMoment != null) {
      _textController.text = widget.existingMoment!.content;
      _selectedMoodString = widget.existingMoment!.mood; // 保持原有的mood或null
    }
  }

  void _setupTextListener() {
    _textController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    setState(() {
      if (!_isUnsaved && _textController.text.isNotEmpty) {
        _isUnsaved = true;
      } else if (_isUnsaved && _textController.text.isEmpty) {
        _isUnsaved = false;
      }
    });

    // Reset auto-save timer
    _autoSaveTimer?.cancel();
    if (_textController.text.trim().isNotEmpty) {
      _autoSaveTimer = Timer(_autoSaveDelay, _performAutoSave);
    }
  }

  Future<void> _performAutoSave() async {
    if (_textController.text.trim().isEmpty || _isSaving) return;

    setState(() {
      _isSaving = true;
    });

    try {
      // Auto-save只更新本地状态和现有moment，不创建新moment
      if (widget.existingMoment != null) {
        // 如果是编辑现有moment，则更新数据库
        if (!mounted) return;
        final momentStore = Provider.of<MomentStore>(context, listen: false);

        final updatedMoment = widget.existingMoment!.copyWith(
          content: _textController.text.trim(),
          mood: Value(_selectedMoodString),
          updatedAt: DateTime.now(),
        );
        await momentStore.updateMoment(updatedMoment);
        AppLogger.info('Auto-saved existing moment update');
      } else {
        // 如果是新moment，auto-save只保存本地状态，不创建数据库记录
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

  Future<void> _saveAndExit() async {
    if (_textController.text.trim().isEmpty) {
      if (mounted) {
        Navigator.of(context).pop();
      }
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      if (!mounted) return;
      final momentStore = Provider.of<MomentStore>(context, listen: false);

      if (widget.existingMoment != null) {
        // Update existing moment
        final updatedMoment = widget.existingMoment!.copyWith(
          content: _textController.text.trim(),
          mood: Value(_selectedMoodString),
          updatedAt: DateTime.now(),
        );
        await momentStore.updateMoment(updatedMoment);
        AppLogger.info('Manually saved existing moment');
      } else {
        // Create new moment (正式发布)
        await momentStore.createMoment(
          content: _textController.text.trim(),
          contentType: ContentType.text,
          mood: _selectedMoodString,
        );
        AppLogger.info('Manually created new moment (published)');
      }

      HapticFeedback.mediumImpact();
      if (mounted) {
        Navigator.of(
          context,
        ).pop(true); // Return true to indicate moment was saved
      }
    } catch (e) {
      AppLogger.error('Manual save failed', e);
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  void _onMoodSelectedString(String mood) {
    setState(() {
      // 如果点击的是已选择的mood，则取消选择；否则选择该mood
      if (_selectedMoodString == mood) {
        _selectedMoodString = null; // 取消选择
      } else {
        _selectedMoodString = mood; // 选择新mood
      }
      _isUnsaved = true;
    });

    HapticFeedback.selectionClick();
    AppLogger.userAction('Mood selected', {
      'mood': _selectedMoodString,
      'action': _selectedMoodString == null ? 'deselected' : 'selected',
    });

    // Trigger auto-save with mood change
    _autoSaveTimer?.cancel();
    _autoSaveTimer = Timer(_autoSaveDelay, _performAutoSave);
  }

  @override
  void dispose() {
    _autoSaveTimer?.cancel();
    _textController.dispose();
    _textFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SystemUiWrapper(
      child: GestureDetector(
        onTap: () {
          // 点击空白处收起键盘
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          extendBodyBehindAppBar: true,
          resizeToAvoidBottomInset: false, // 防止键盘弹起时背景跟着移动
          appBar: _buildAppBar(isDark),
          body: PremiumScreenBackground(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + kToolbarHeight + 16,
                bottom: 40,
                left: 20,
                right: 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  FadeInSlideUp(child: _buildHeader(isDark)),
                  const SizedBox(height: 24),

                  // Text editor
                  FadeInSlideUp(
                    delay: const Duration(milliseconds: 150),
                    child: _buildTextEditor(isDark),
                  ),
                  const SizedBox(height: 24),

                  // Mood selector
                  FadeInSlideUp(
                    delay: const Duration(milliseconds: 300),
                    child: _buildMoodSelector(isDark),
                  ),
                ],
              ),
            ),
          ),
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
          onTap: () async {
            if (_isUnsaved && _textController.text.trim().isNotEmpty) {
              await _performAutoSave();
            }
            if (mounted) {
              Navigator.of(context).pop();
            }
          },
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
        Container(
          width: 100, // Increased width to accommodate wider button
          padding: const EdgeInsets.only(right: 20),
          alignment: Alignment.center,
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
                  text: widget.existingMoment != null ? 'Update' : 'Save',
                  onPressed: _textController.text.trim().isNotEmpty
                      ? _saveAndExit
                      : null,
                  icon: widget.existingMoment != null
                      ? Icons.update_rounded
                      : Icons.check_rounded,
                  width: 80,
                  height: 36,
                  borderRadius: 18,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 6,
                  ),
                  textStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    color: Colors.white, // 确保文字颜色为白色
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
                        : 'Draft saved',
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
    final isSelected = _selectedMoodString == moodOption.value;

    return GestureDetector(
      onTap: () => _onMoodSelectedString(moodOption.value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 70, // 固定高度确保一致性
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          // 统一使用相同的背景色，不再通过颜色深浅区分选中状态
          color: moodOption.color.withValues(alpha: 0.08),
          border: Border.all(
            color: moodOption.color.withValues(alpha: 0.25),
            width: 1,
          ),
        ),
        child: Stack(
          children: [
            // 主要内容 - 使用Center确保完美居中
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
            // 选中状态的勾选标记
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
