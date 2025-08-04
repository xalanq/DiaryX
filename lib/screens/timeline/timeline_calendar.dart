part of 'timeline_screen.dart';

/// Calendar dropdown modal that appears from button
class _CalendarDropdownModal extends StatefulWidget {
  final Function(DateTime) onDateSelected;
  final List<Moment> moments;

  const _CalendarDropdownModal({
    required this.onDateSelected,
    required this.moments,
  });

  @override
  State<_CalendarDropdownModal> createState() => _CalendarDropdownModalState();
}

class _CalendarDropdownModalState extends State<_CalendarDropdownModal>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  DateTime _focusedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // Get moments for a specific day to show markers
  List<Moment> _getMomentsForDay(DateTime day) {
    return widget.moments.where((moment) {
      final momentDate = DateTime(
        moment.createdAt.year,
        moment.createdAt.month,
        moment.createdAt.day,
      );
      final targetDate = DateTime(day.year, day.month, day.day);
      return momentDate == targetDate;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Stack(
      children: [
        // Dismiss area
        Positioned.fill(
          child: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(color: Colors.black.withValues(alpha: 0.3)),
          ),
        ),

        // Dropdown calendar positioned below header
        Positioned(
          top: MediaQuery.of(context).padding.top + 100,
          left: 20,
          right: 20,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              alignment: Alignment.topCenter,
              child: PremiumGlassCard(
                padding: const EdgeInsets.all(20),
                borderRadius: 24,
                hasGradient: true,
                gradientColors: isDark
                    ? [
                        AppColors.darkSurface.withValues(alpha: 0.95),
                        AppColors.darkSurface.withValues(alpha: 0.85),
                      ]
                    : [
                        AppColors.lightSurface.withValues(alpha: 0.98),
                        AppColors.lightSurface.withValues(alpha: 0.90),
                      ],
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Calendar header
                    Row(
                      children: [
                        // Previous month button
                        _buildCalendarNavButton(
                          context,
                          Icons.chevron_left_rounded,
                          () {
                            setState(() {
                              _focusedDay = DateTime(
                                _focusedDay.year,
                                _focusedDay.month - 1,
                                _focusedDay.day,
                              );
                            });
                          },
                          isDark,
                        ),

                        // Month and year display
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                _formatMonthYear(_focusedDay),
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: isDark
                                      ? AppColors.darkTextPrimary
                                      : AppColors.lightTextPrimary,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 6),
                              // View toggle
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _calendarFormat =
                                        _calendarFormat == CalendarFormat.month
                                        ? CalendarFormat.twoWeeks
                                        : CalendarFormat.month;
                                  });
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        isDark
                                            ? AppColors.darkPrimary.withValues(
                                                alpha: 0.15,
                                              )
                                            : AppColors.lightPrimary.withValues(
                                                alpha: 0.12,
                                              ),
                                        isDark
                                            ? AppColors.darkSecondary
                                                  .withValues(alpha: 0.08)
                                            : AppColors.lightSecondary
                                                  .withValues(alpha: 0.06),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: isDark
                                          ? AppColors.darkPrimary.withValues(
                                              alpha: 0.2,
                                            )
                                          : AppColors.lightPrimary.withValues(
                                              alpha: 0.2,
                                            ),
                                      width: 1,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        _calendarFormat == CalendarFormat.month
                                            ? Icons.calendar_view_month_rounded
                                            : Icons.view_week_rounded,
                                        size: 14,
                                        color: isDark
                                            ? AppColors.darkPrimary
                                            : AppColors.lightPrimary,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        _calendarFormat == CalendarFormat.month
                                            ? 'Month View'
                                            : 'Week View',
                                        style: theme.textTheme.bodySmall
                                            ?.copyWith(
                                              color: isDark
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
                          ),
                        ),

                        // Next month button
                        _buildCalendarNavButton(
                          context,
                          Icons.chevron_right_rounded,
                          () {
                            setState(() {
                              _focusedDay = DateTime(
                                _focusedDay.year,
                                _focusedDay.month + 1,
                                _focusedDay.day,
                              );
                            });
                          },
                          isDark,
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Calendar grid
                    TableCalendar(
                      firstDay: DateTime.utc(2020, 1, 1),
                      lastDay: DateTime.utc(2030, 12, 31),
                      focusedDay: _focusedDay,
                      selectedDayPredicate: (day) => false,
                      calendarFormat: _calendarFormat,
                      availableGestures: AvailableGestures.horizontalSwipe,
                      onDaySelected: (selectedDay, focusedDay) {
                        widget.onDateSelected(selectedDay);
                      },
                      onFormatChanged: (format) {
                        setState(() {
                          _calendarFormat = format;
                        });
                      },
                      onPageChanged: (focusedDay) {
                        setState(() {
                          _focusedDay = focusedDay;
                        });
                      },
                      calendarStyle: CalendarStyle(
                        cellMargin: const EdgeInsets.all(4),
                        cellPadding: const EdgeInsets.all(0),

                        // Text styles
                        outsideTextStyle:
                            theme.textTheme.bodyMedium?.copyWith(
                              color: isDark
                                  ? AppColors.darkTextSecondary.withValues(
                                      alpha: 0.4,
                                    )
                                  : AppColors.lightTextSecondary.withValues(
                                      alpha: 0.4,
                                    ),
                              fontWeight: FontWeight.w400,
                            ) ??
                            const TextStyle(),

                        weekendTextStyle:
                            theme.textTheme.bodyMedium?.copyWith(
                              color: isDark
                                  ? AppColors.darkTextPrimary.withValues(
                                      alpha: 0.9,
                                    )
                                  : AppColors.lightTextPrimary.withValues(
                                      alpha: 0.9,
                                    ),
                              fontWeight: FontWeight.w600,
                            ) ??
                            const TextStyle(),

                        defaultTextStyle:
                            theme.textTheme.bodyMedium?.copyWith(
                              color: isDark
                                  ? AppColors.darkTextPrimary.withValues(
                                      alpha: 0.8,
                                    )
                                  : AppColors.lightTextPrimary.withValues(
                                      alpha: 0.8,
                                    ),
                              fontWeight: FontWeight.w500,
                            ) ??
                            const TextStyle(),

                        // Day decorations
                        todayDecoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              isDark
                                  ? AppColors.darkAccent.withValues(alpha: 0.7)
                                  : AppColors.lightAccent.withValues(
                                      alpha: 0.7,
                                    ),
                              isDark
                                  ? AppColors.darkAccent.withValues(alpha: 0.5)
                                  : AppColors.lightAccent.withValues(
                                      alpha: 0.5,
                                    ),
                            ],
                          ),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isDark
                                ? AppColors.darkAccent.withValues(alpha: 0.3)
                                : AppColors.lightAccent.withValues(alpha: 0.3),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  (isDark
                                          ? AppColors.darkAccent
                                          : AppColors.lightAccent)
                                      .withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),

                        // Markers configuration
                        markersMaxCount: 3,
                        markerDecoration: BoxDecoration(
                          color: isDark
                              ? AppColors.darkPrimary
                              : AppColors.lightPrimary,
                          shape: BoxShape.circle,
                        ),
                        markersAnchor: 0.7,
                        markersOffset: const PositionedOffset(bottom: 6),
                        markerSize: 6,
                      ),

                      // Week format styling
                      daysOfWeekStyle: DaysOfWeekStyle(
                        weekdayStyle:
                            theme.textTheme.bodySmall?.copyWith(
                              color: isDark
                                  ? AppColors.darkTextSecondary.withValues(
                                      alpha: 0.8,
                                    )
                                  : AppColors.lightTextSecondary.withValues(
                                      alpha: 0.8,
                                    ),
                              fontWeight: FontWeight.w600,
                            ) ??
                            const TextStyle(),
                        weekendStyle:
                            theme.textTheme.bodySmall?.copyWith(
                              color: isDark
                                  ? AppColors.darkTextSecondary.withValues(
                                      alpha: 0.7,
                                    )
                                  : AppColors.lightTextSecondary.withValues(
                                      alpha: 0.7,
                                    ),
                              fontWeight: FontWeight.w600,
                            ) ??
                            const TextStyle(),
                      ),

                      // Event loader - show markers for days with moments
                      eventLoader: (day) {
                        final momentsForDay = _getMomentsForDay(day);
                        return List.generate(
                          momentsForDay.length.clamp(0, 3),
                          (index) => momentsForDay[index],
                        );
                      },

                      // Calendar builders for custom markers
                      calendarBuilders: CalendarBuilders(
                        markerBuilder: (context, date, events) {
                          if (events.isEmpty) return const SizedBox.shrink();
                          return Positioned(
                            bottom: 6,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: events.take(3).map((event) {
                                return Container(
                                  margin: const EdgeInsets.only(right: 2),
                                  decoration: BoxDecoration(
                                    color: isDark
                                        ? AppColors.darkPrimary
                                        : AppColors.lightPrimary,
                                    shape: BoxShape.circle,
                                  ),
                                  width: 6,
                                  height: 6,
                                );
                              }).toList(),
                            ),
                          );
                        },
                      ),

                      // Header configuration
                      headerVisible: false,
                      daysOfWeekVisible: true,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCalendarNavButton(
    BuildContext context,
    IconData icon,
    VoidCallback onPressed,
    bool isDark,
  ) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          gradient: RadialGradient(
            colors: [
              (isDark ? AppColors.darkSurface : AppColors.lightSurface)
                  .withValues(alpha: 0.8),
              (isDark ? AppColors.darkSurface : AppColors.lightSurface)
                  .withValues(alpha: 0.4),
            ],
          ),
          shape: BoxShape.circle,
          border: Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: 0.1)
                : Colors.black.withValues(alpha: 0.06),
            width: 1,
          ),
        ),
        child: Icon(
          icon,
          size: 18,
          color: isDark
              ? AppColors.darkTextPrimary.withValues(alpha: 0.8)
              : AppColors.lightTextPrimary.withValues(alpha: 0.8),
        ),
      ),
    );
  }

  String _formatMonthYear(DateTime date) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${months[date.month - 1]} ${date.year}';
  }
}
