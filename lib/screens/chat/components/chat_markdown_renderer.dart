part of '../chat_conversation_screen.dart';

/// Chat markdown renderer with gpt_markdown integration and selectable text
class _ChatMarkdownRenderer extends StatelessWidget {
  final String content;
  final bool isUser;

  const _ChatMarkdownRenderer({required this.content, required this.isUser});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SelectableRegion(
      focusNode: FocusNode(),
      selectionControls: MaterialTextSelectionControls(),
      child: GptMarkdown(
        content,
        style:
            theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface,
              height: 1.5,
            ) ??
            const TextStyle(),
      ),
    );
  }
}
