import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../themes/app_colors.dart';
import '../../widgets/premium_glass_card/premium_glass_card.dart';
import '../../utils/tag_validator.dart';

/// Premium tag editor widget with glass morphism design
class PremiumTagEditor extends StatefulWidget {
  final List<String> selectedTags;
  final Function(List<String>) onTagsChanged;
  final List<String>? allTags;
  final bool isDark;

  const PremiumTagEditor({
    super.key,
    required this.selectedTags,
    required this.onTagsChanged,
    this.allTags,
    this.isDark = false,
  });

  @override
  State<PremiumTagEditor> createState() => _PremiumTagEditorState();
}

class _PremiumTagEditorState extends State<PremiumTagEditor> {
  late TextEditingController _textController;
  List<String> _filteredSuggestions = [];
  String? _currentError;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    _updateFilteredSuggestions();
  }

  @override
  void didUpdateWidget(PremiumTagEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update filtered suggestions when allTags changes
    if (oldWidget.allTags != widget.allTags) {
      _updateFilteredSuggestions();
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _updateFilteredSuggestions() {
    final currentText = _textController.text;
    setState(() {
      if (currentText.isEmpty) {
        _filteredSuggestions = widget.allTags?.take(5).toList() ?? [];
      } else {
        _filteredSuggestions = (widget.allTags ?? [])
            .where(
              (tag) => tag.toLowerCase().contains(currentText.toLowerCase()),
            )
            .take(5)
            .toList();
      }
    });
  }

  void _onTextChanged(String text) {
    setState(() {
      _currentError = null; // Clear error when user types
    });
    _updateFilteredSuggestions();
  }

  void _addTag(String tagName) {
    if (tagName.trim().isEmpty) return;

    final trimmedName = tagName.trim();

    // Validate the tag
    final validationError = TagValidator.validateTag(trimmedName);
    if (validationError != null) {
      setState(() {
        _currentError = validationError;
      });
      return;
    }

    // Check if tag already exists in selected tags (case insensitive)
    if (widget.selectedTags.any(
      (tag) => tag.toLowerCase() == trimmedName.toLowerCase(),
    )) {
      setState(() {
        _currentError = 'Tag already exists';
      });
      return;
    }

    final updatedTags = [...widget.selectedTags, trimmedName];
    widget.onTagsChanged(updatedTags);

    _textController.clear();
    _updateFilteredSuggestions();

    HapticFeedback.lightImpact();
  }

  void _removeTag(String tag) {
    final updatedTags = widget.selectedTags.where((t) => t != tag).toList();
    widget.onTagsChanged(updatedTags);
    setState(() {
      _currentError = null; // Clear any error when removing tags
    });
    _updateFilteredSuggestions(); // Update suggestions when tags are removed
    HapticFeedback.lightImpact();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PremiumGlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            'Tags',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: widget.isDark
                  ? AppColors.darkTextPrimary
                  : AppColors.lightTextPrimary,
            ),
          ),
          const SizedBox(height: 16),

          // Selected tags display
          if (widget.selectedTags.isNotEmpty) ...[
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: widget.selectedTags
                  .map((tag) => _buildTagChip(tag))
                  .toList(),
            ),
            const SizedBox(height: 12),
          ],

          // Tag input field
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: widget.isDark
                    ? [
                        Colors.white.withValues(alpha: 0.05),
                        Colors.white.withValues(alpha: 0.02),
                      ]
                    : [
                        Colors.black.withValues(alpha: 0.03),
                        Colors.black.withValues(alpha: 0.01),
                      ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: (widget.isDark ? Colors.white : Colors.black).withValues(
                  alpha: 0.08,
                ),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: (widget.isDark ? Colors.black : Colors.grey)
                      .withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: TextField(
                controller: _textController,
                onChanged: _onTextChanged,
                onSubmitted: _addTag,
                decoration: InputDecoration(
                  hintText: 'Add a tag...',
                  hintStyle: TextStyle(
                    color:
                        (widget.isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.lightTextSecondary)
                            .withValues(alpha: 0.6),
                  ),
                  border: InputBorder.none,
                  filled: false,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  suffixIcon: _textController.text.isNotEmpty
                      ? IconButton(
                          onPressed: () => _addTag(_textController.text),
                          icon: Icon(
                            Icons.add_rounded,
                            color: widget.isDark
                                ? AppColors.darkPrimary
                                : AppColors.lightPrimary,
                          ),
                        )
                      : null,
                ),
                style: TextStyle(
                  color: widget.isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary,
                ),
              ),
            ),
          ),

          // Error display
          if (_currentError != null) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.red.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 16,
                    color: Colors.red.withValues(alpha: 0.8),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _currentError!,
                      style: TextStyle(
                        color: Colors.red.withValues(alpha: 0.8),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          // Suggestions (always show when available)
          if (_filteredSuggestions.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(
              'Suggestions',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color:
                    (widget.isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary)
                        .withValues(alpha: 0.8),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              constraints: const BoxConstraints(maxHeight: 120),
              child: SingleChildScrollView(
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _filteredSuggestions
                      .where(
                        (tag) => !widget.selectedTags.any(
                          (selected) => selected == tag,
                        ),
                      )
                      .map((tag) => _buildSuggestionChip(tag))
                      .toList(),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTagChip(String tag) {
    return GestureDetector(
      onTap: () => _removeTag(tag),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: widget.isDark
                ? [
                    AppColors.darkPrimary.withValues(alpha: 0.15),
                    AppColors.darkAccent.withValues(alpha: 0.08),
                  ]
                : [
                    AppColors.lightPrimary.withValues(alpha: 0.12),
                    AppColors.lightAccent.withValues(alpha: 0.06),
                  ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color:
                (widget.isDark ? AppColors.darkPrimary : AppColors.lightPrimary)
                    .withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '#$tag',
              style: TextStyle(
                fontSize: 14,
                color: widget.isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.lightTextPrimary,
              ),
            ),
            const SizedBox(width: 6),
            Icon(
              Icons.close_rounded,
              size: 18,
              color:
                  (widget.isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary)
                      .withValues(alpha: 0.8),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestionChip(String tag) {
    return GestureDetector(
      onTap: () => _addTag(tag),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color:
              (widget.isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary)
                  .withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color:
                (widget.isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary)
                    .withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Text(
          '#$tag',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 13,
            color:
                (widget.isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary)
                    .withValues(alpha: 0.8),
          ),
        ),
      ),
    );
  }
}
