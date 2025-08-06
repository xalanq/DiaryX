import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../widgets/premium_glass_card/premium_glass_card.dart';
import '../../../widgets/animations/premium_animations.dart';
import '../../../widgets/premium_button/premium_button.dart';
import '../../../models/ai_analysis_template.dart' as analysis;
import '../../../stores/moment_store.dart';
import '../../../stores/chat_store.dart';
import '../../../utils/app_logger.dart';
import '../../../routes.dart';
import '../../../models/moment.dart';

/// AI Analysis Templates Section
class AIAnalysisTemplates extends StatelessWidget {
  const AIAnalysisTemplates({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: FadeInSlideUp(
            child: Row(
              children: [
                Icon(
                  Icons.auto_awesome,
                  color: Theme.of(context).colorScheme.primary,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  'AI Analysis',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => AppRoutes.toChatConversations(context),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withValues(alpha: 0.2),
                        width: 1,
                      ),
                    ),
                    child: Icon(
                      Icons.chat,
                      color: Theme.of(context).colorScheme.primary,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Templates grid
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              for (
                int i = 0;
                i < analysis.AIAnalysisTemplates.templates.length;
                i += 2
              )
                FadeInSlideUp(
                  delay: Duration(milliseconds: 100 * (i ~/ 2)),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      children: [
                        Expanded(
                          child: _AnalysisTemplateCard(
                            template: analysis.AIAnalysisTemplates.templates[i],
                          ),
                        ),
                        const SizedBox(width: 12),
                        if (i + 1 <
                            analysis.AIAnalysisTemplates.templates.length)
                          Expanded(
                            child: _AnalysisTemplateCard(
                              template:
                                  analysis.AIAnalysisTemplates.templates[i + 1],
                            ),
                          )
                        else
                          const Expanded(child: SizedBox()),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),

        const SizedBox(height: 20),
      ],
    );
  }
}

/// Individual analysis template card
class _AnalysisTemplateCard extends StatelessWidget {
  final analysis.AIAnalysisTemplate template;

  const _AnalysisTemplateCard({required this.template});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PremiumGlassCard(
      padding: const EdgeInsets.all(16),
      child: InkWell(
        onTap: () => _showTimePeriodSelector(context),
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                template.icon,
                color: theme.colorScheme.primary,
                size: 24,
              ),
            ),

            const SizedBox(height: 12),

            // Title
            Text(
              template.title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 6),

            // Description
            Text(
              template.description,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                height: 1.4,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  void _showTimePeriodSelector(BuildContext context) {
    AppLogger.userAction('AI Analysis template selected', {
      'templateId': template.id,
    });

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _TimePeriodSelector(template: template),
    );
  }
}

/// Time period selector bottom sheet
class _TimePeriodSelector extends StatelessWidget {
  final analysis.AIAnalysisTemplate template;

  const _TimePeriodSelector({required this.template});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.6,
      ),
      child: PremiumGlassCard(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(template.icon, color: theme.colorScheme.primary, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    template.title,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(Icons.close, color: theme.colorScheme.onSurface),
                ),
              ],
            ),

            const SizedBox(height: 8),

            Text(
              'Select the time period for analysis:',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
              ),
            ),

            const SizedBox(height: 20),

            // Time period options
            ...template.availableTimePeriods.map(
              (period) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: SizedBox(
                  width: double.infinity,
                  child: PremiumButton(
                    text: period.displayName,
                    onPressed: () => _selectTimePeriod(context, period),
                    isOutlined: true,
                    hasGradient: false,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _selectTimePeriod(
    BuildContext context,
    analysis.AnalysisTimePeriod period,
  ) {
    Navigator.of(context).pop();

    if (period == analysis.AnalysisTimePeriod.custom) {
      _showCustomDatePicker(context);
    } else {
      _performAnalysis(context, period);
    }
  }

  void _showCustomDatePicker(BuildContext context) {
    showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: DateTimeRange(
        start: DateTime.now().subtract(const Duration(days: 30)),
        end: DateTime.now(),
      ),
    ).then((dateRange) {
      if (dateRange != null && context.mounted) {
        _performAnalysisWithDateRange(context, dateRange);
      }
    });
  }

  void _performAnalysis(
    BuildContext context,
    analysis.AnalysisTimePeriod period,
  ) {
    AppLogger.userAction('AI Analysis started', {
      'templateId': template.id,
      'period': period.displayName,
    });

    final momentStore = context.read<MomentStore>();

    // Get moments based on the selected period
    List<Moment> moments;
    switch (period) {
      case analysis.AnalysisTimePeriod.lastWeek:
        moments = momentStore.getLastWeekMoments();
        break;
      case analysis.AnalysisTimePeriod.lastMonth:
        moments = momentStore.getLastMonthMoments();
        break;
      case analysis.AnalysisTimePeriod.lastSixMonths:
        moments = momentStore.getLastSixMonthsMoments();
        break;
      case analysis.AnalysisTimePeriod.custom:
        // This should not happen as custom is handled separately
        moments = momentStore.getLastMonthMoments();
        break;
    }

    _createAnalysisChat(context, moments, period.displayName);
  }

  void _performAnalysisWithDateRange(
    BuildContext context,
    DateTimeRange dateRange,
  ) {
    AppLogger.userAction('AI Analysis started with custom range', {
      'templateId': template.id,
      'startDate': dateRange.start.toIso8601String(),
      'endDate': dateRange.end.toIso8601String(),
    });

    final momentStore = context.read<MomentStore>();
    final moments = momentStore.getMomentsInDateRange(
      dateRange.start,
      dateRange.end,
    );

    final periodDescription =
        'Custom Range (${_formatDate(dateRange.start)} - ${_formatDate(dateRange.end)})';
    _createAnalysisChat(context, moments, periodDescription);
  }

  void _createAnalysisChat(
    BuildContext context,
    List<Moment> moments,
    String periodDescription,
  ) async {
    if (moments.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No diary entries found for the selected period.'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    final chatStore = context.read<ChatStore>();

    // Create a new chat with a descriptive title
    final chatTitle = '${template.title} - $periodDescription';
    final newChat = await chatStore.createNewChat(title: chatTitle);

    if (newChat != null && context.mounted) {
      // Navigate to the chat conversation
      await AppRoutes.toChatConversation(context, chatId: newChat.id);

      // Send the analysis prompt with the moments
      final promptMessage =
          '${template.prompt}\n\nAnalyzing ${moments.length} diary entries from $periodDescription.';
      await chatStore.sendMessage(promptMessage, contextMoments: moments);
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
