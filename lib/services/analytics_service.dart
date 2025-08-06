import '../databases/app_database.dart';
import '../models/moment.dart';
import '../models/mood.dart';
import '../utils/app_logger.dart';

/// Service for calculating analytics and insights data
class AnalyticsService {
  static AnalyticsService? _instance;
  static AnalyticsService get instance {
    _instance ??= AnalyticsService._();
    return _instance!;
  }

  AnalyticsService._();

  final AppDatabase _database = AppDatabase.instance;

  /// Get basic statistics overview
  Future<AnalyticsOverview> getAnalyticsOverview() async {
    try {
      AppLogger.info('Calculating analytics overview');

      final momentsData = await _database.getAllMoments();
      final now = DateTime.now();
      final weekStart = now.subtract(Duration(days: now.weekday - 1));
      final weekEnd = weekStart.add(const Duration(days: 6));

      // Convert to Moment objects
      final moments = <Moment>[];
      for (final momentData in momentsData) {
        final moment = await MomentExtensions.fromMomentData(
          momentData,
          _database,
        );
        moments.add(moment);
      }

      // Calculate total moments
      final totalMoments = moments.length;

      // Calculate this week's moments
      final thisWeekMoments = moments.where((moment) {
        return moment.createdAt.isAfter(weekStart) &&
            moment.createdAt.isBefore(weekEnd);
      }).length;

      // Calculate writing streak
      final streak = _calculateWritingStreak(moments);

      // Calculate average mood
      final avgMood = await _calculateAverageMood(moments);

      // Calculate mood trends for the last 30 days
      final moodTrends = await _calculateMoodTrends(moments, 30);

      // Calculate writing frequency for the last 30 days
      final writingFrequency = _calculateWritingFrequency(moments, 30);

      // Calculate content type distribution
      final contentDistribution = await _calculateContentDistribution(moments);

      final overview = AnalyticsOverview(
        totalMoments: totalMoments,
        thisWeekMoments: thisWeekMoments,
        writingStreak: streak,
        averageMood: avgMood,
        moodTrends: moodTrends,
        writingFrequency: writingFrequency,
        contentDistribution: contentDistribution,
      );

      AppLogger.info('Analytics overview calculated successfully');
      return overview;
    } catch (e, stackTrace) {
      AppLogger.error('Failed to calculate analytics overview', e, stackTrace);
      return AnalyticsOverview.empty();
    }
  }

  /// Calculate writing streak in days
  int _calculateWritingStreak(List<Moment> moments) {
    if (moments.isEmpty) return 0;

    // Sort moments by date (newest first)
    final sortedMoments = [...moments]
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    final today = DateTime.now();
    final yesterday = today.subtract(const Duration(days: 1));

    // Check if user wrote today or yesterday to start streak
    bool hasRecentEntry = sortedMoments.any((moment) {
      final momentDate = DateTime(
        moment.createdAt.year,
        moment.createdAt.month,
        moment.createdAt.day,
      );
      final todayDate = DateTime(today.year, today.month, today.day);
      final yesterdayDate = DateTime(
        yesterday.year,
        yesterday.month,
        yesterday.day,
      );
      return momentDate.isAtSameMomentAs(todayDate) ||
          momentDate.isAtSameMomentAs(yesterdayDate);
    });

    if (!hasRecentEntry) return 0;

    // Group moments by date
    final momentsByDate = <DateTime, List<Moment>>{};
    for (final moment in sortedMoments) {
      final date = DateTime(
        moment.createdAt.year,
        moment.createdAt.month,
        moment.createdAt.day,
      );
      momentsByDate.putIfAbsent(date, () => []).add(moment);
    }

    // Calculate consecutive days
    int streak = 0;
    DateTime currentDate = DateTime(today.year, today.month, today.day);

    while (momentsByDate.containsKey(currentDate)) {
      streak++;
      currentDate = currentDate.subtract(const Duration(days: 1));
    }

    return streak;
  }

  /// Calculate average mood score
  Future<double?> _calculateAverageMood(List<Moment> moments) async {
    if (moments.isEmpty) return null;

    final moodScores = <double>[];

    for (final moment in moments) {
      if (moment.moods.isNotEmpty) {
        // Convert mood names to scores (simplified mapping)
        double totalScore = 0;
        int validMoods = 0;

        for (final mood in moment.moods) {
          final score = _getMoodScore(mood);
          if (score != null) {
            totalScore += score;
            validMoods++;
          }
        }

        if (validMoods > 0) {
          moodScores.add(totalScore / validMoods);
        }
      }
    }

    if (moodScores.isEmpty) return null;

    return moodScores.reduce((a, b) => a + b) / moodScores.length;
  }

  /// Convert mood name to numeric score (1-5 scale) using the standard mood system
  double? _getMoodScore(String moodName) {
    // Use the standard mood types from mood.dart
    final moodType = MoodUtils.fromString(moodName);
    if (moodType == null) return null;

    // Score based on the 9 standard moods (1-5 scale for analytics)
    switch (moodType) {
      case MoodType.happy:
        return 5.0; // Very positive
      case MoodType.excited:
        return 5.0; // Very positive
      case MoodType.grateful:
        return 4.5; // Positive
      case MoodType.calm:
        return 4.0; // Peaceful positive
      case MoodType.thoughtful:
        return 3.0; // Neutral/reflective
      case MoodType.bored:
        return 2.5; // Slightly negative
      case MoodType.anxious:
        return 2.0; // Negative
      case MoodType.sad:
        return 1.5; // Very negative
      case MoodType.angry:
        return 1.0; // Very negative
    }
  }

  /// Calculate mood trends over the last N days
  Future<List<MoodTrendPoint>> _calculateMoodTrends(
    List<Moment> moments,
    int days,
  ) async {
    final trends = <MoodTrendPoint>[];
    final now = DateTime.now();

    for (int i = days - 1; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final dayStart = DateTime(date.year, date.month, date.day);
      final dayEnd = dayStart.add(const Duration(days: 1));

      final dayMoments = moments.where((moment) {
        return moment.createdAt.isAfter(dayStart) &&
            moment.createdAt.isBefore(dayEnd);
      }).toList();

      double? avgMoodScore;
      if (dayMoments.isNotEmpty) {
        final moodScores = <double>[];
        for (final moment in dayMoments) {
          for (final mood in moment.moods) {
            final score = _getMoodScore(mood);
            if (score != null) {
              moodScores.add(score);
            }
          }
        }

        if (moodScores.isNotEmpty) {
          avgMoodScore = moodScores.reduce((a, b) => a + b) / moodScores.length;
        }
      }

      trends.add(
        MoodTrendPoint(
          date: dayStart,
          moodScore: avgMoodScore,
          momentCount: dayMoments.length,
        ),
      );
    }

    return trends;
  }

  /// Calculate writing frequency over the last N days
  List<WritingFrequencyPoint> _calculateWritingFrequency(
    List<Moment> moments,
    int days,
  ) {
    final frequency = <WritingFrequencyPoint>[];
    final now = DateTime.now();

    for (int i = days - 1; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final dayStart = DateTime(date.year, date.month, date.day);
      final dayEnd = dayStart.add(const Duration(days: 1));

      final dayMoments = moments.where((moment) {
        return moment.createdAt.isAfter(dayStart) &&
            moment.createdAt.isBefore(dayEnd);
      }).length;

      frequency.add(
        WritingFrequencyPoint(date: dayStart, momentCount: dayMoments),
      );
    }

    return frequency;
  }

  /// Calculate content type distribution
  Future<ContentDistribution> _calculateContentDistribution(
    List<Moment> moments,
  ) async {
    int textOnly = 0;
    int withImages = 0;
    int withAudio = 0;
    int withVideo = 0;
    int multimedia = 0;

    for (final moment in moments) {
      bool hasImage = moment.images.isNotEmpty;
      bool hasAudio = moment.audios.isNotEmpty;
      bool hasVideo = moment.videos.isNotEmpty;

      final mediaTypesCount = [
        hasImage,
        hasAudio,
        hasVideo,
      ].where((x) => x).length;

      if (mediaTypesCount == 0) {
        textOnly++;
      } else if (mediaTypesCount == 1) {
        if (hasImage) {
          withImages++;
        } else if (hasAudio) {
          withAudio++;
        } else if (hasVideo) {
          withVideo++;
        }
      } else {
        multimedia++;
      }
    }

    return ContentDistribution(
      textOnly: textOnly,
      withImages: withImages,
      withAudio: withAudio,
      withVideo: withVideo,
      multimedia: multimedia,
    );
  }
}

/// Analytics overview model
class AnalyticsOverview {
  final int totalMoments;
  final int thisWeekMoments;
  final int writingStreak;
  final double? averageMood;
  final List<MoodTrendPoint> moodTrends;
  final List<WritingFrequencyPoint> writingFrequency;
  final ContentDistribution contentDistribution;

  const AnalyticsOverview({
    required this.totalMoments,
    required this.thisWeekMoments,
    required this.writingStreak,
    required this.averageMood,
    required this.moodTrends,
    required this.writingFrequency,
    required this.contentDistribution,
  });

  factory AnalyticsOverview.empty() {
    return const AnalyticsOverview(
      totalMoments: 0,
      thisWeekMoments: 0,
      writingStreak: 0,
      averageMood: null,
      moodTrends: [],
      writingFrequency: [],
      contentDistribution: ContentDistribution(
        textOnly: 0,
        withImages: 0,
        withAudio: 0,
        withVideo: 0,
        multimedia: 0,
      ),
    );
  }
}

/// Mood trend data point
class MoodTrendPoint {
  final DateTime date;
  final double? moodScore;
  final int momentCount;

  const MoodTrendPoint({
    required this.date,
    required this.moodScore,
    required this.momentCount,
  });
}

/// Writing frequency data point
class WritingFrequencyPoint {
  final DateTime date;
  final int momentCount;

  const WritingFrequencyPoint({required this.date, required this.momentCount});
}

/// Content distribution model
class ContentDistribution {
  final int textOnly;
  final int withImages;
  final int withAudio;
  final int withVideo;
  final int multimedia;

  const ContentDistribution({
    required this.textOnly,
    required this.withImages,
    required this.withAudio,
    required this.withVideo,
    required this.multimedia,
  });

  int get total => textOnly + withImages + withAudio + withVideo + multimedia;
}
