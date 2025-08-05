import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/material.dart';

part 'ai_analysis_template.freezed.dart';

/// Time period options for AI analysis
enum AnalysisTimePeriod { lastWeek, lastMonth, lastSixMonths, custom }

extension AnalysisTimePeriodExtension on AnalysisTimePeriod {
  String get displayName {
    switch (this) {
      case AnalysisTimePeriod.lastWeek:
        return 'Last Week';
      case AnalysisTimePeriod.lastMonth:
        return 'Last Month';
      case AnalysisTimePeriod.lastSixMonths:
        return 'Last 6 Months';
      case AnalysisTimePeriod.custom:
        return 'Custom Range';
    }
  }

  int get days {
    switch (this) {
      case AnalysisTimePeriod.lastWeek:
        return 7;
      case AnalysisTimePeriod.lastMonth:
        return 30;
      case AnalysisTimePeriod.lastSixMonths:
        return 180;
      case AnalysisTimePeriod.custom:
        return 0; // Will be handled separately
    }
  }
}

/// AI analysis template model
@freezed
class AIAnalysisTemplate with _$AIAnalysisTemplate {
  const factory AIAnalysisTemplate({
    required String id,
    required String title,
    required String description,
    required IconData icon,
    required String prompt,
    @Default([
      AnalysisTimePeriod.lastWeek,
      AnalysisTimePeriod.lastMonth,
      AnalysisTimePeriod.lastSixMonths,
      AnalysisTimePeriod.custom,
    ])
    List<AnalysisTimePeriod> availableTimePeriods,
  }) = _AIAnalysisTemplate;
}

/// Pre-defined AI analysis templates
class AIAnalysisTemplates {
  static const List<AIAnalysisTemplate> templates = [
    AIAnalysisTemplate(
      id: 'mood_analysis',
      title: 'Analyze Mood Patterns',
      description: 'Discover emotional trends and psychological insights',
      icon: Icons.psychology,
      prompt:
          'Please analyze my emotional patterns and psychological state based on my diary entries. Focus on mood trends, emotional triggers, and overall mental wellbeing.',
    ),
    AIAnalysisTemplate(
      id: 'life_events_summary',
      title: 'Summarize Life Events',
      description: 'Get a comprehensive overview of recent happenings',
      icon: Icons.event_note,
      prompt:
          'Please summarize the significant events and experiences from my diary entries. Highlight key moments, achievements, challenges, and important developments.',
    ),
    AIAnalysisTemplate(
      id: 'emotional_trends',
      title: 'Emotional Growth Journey',
      description: 'Track your emotional development and resilience',
      icon: Icons.trending_up,
      prompt:
          'Analyze my emotional growth and development patterns. Identify areas of resilience, emotional intelligence improvements, and personal insights.',
    ),
    AIAnalysisTemplate(
      id: 'life_patterns',
      title: 'Discover Life Patterns',
      description: 'Identify recurring themes and behavioral patterns',
      icon: Icons.pattern,
      prompt:
          'Help me identify recurring patterns, habits, and themes in my daily life. What cycles or trends do you notice in my behaviors and experiences?',
    ),
    AIAnalysisTemplate(
      id: 'personal_growth',
      title: 'Personal Growth Analysis',
      description: 'Evaluate progress on goals and self-development',
      icon: Icons.self_improvement,
      prompt:
          'Analyze my personal growth journey based on my diary entries. What progress have I made? What areas show development and what challenges remain?',
    ),
    AIAnalysisTemplate(
      id: 'relationship_insights',
      title: 'Relationship Insights',
      description: 'Understand social connections and interactions',
      icon: Icons.people,
      prompt:
          'Provide insights about my relationships and social interactions based on my diary entries. How are my connections with others evolving?',
    ),
    AIAnalysisTemplate(
      id: 'productivity_analysis',
      title: 'Work & Productivity Review',
      description: 'Assess work patterns and achievement trends',
      icon: Icons.work,
      prompt:
          'Analyze my work patterns, productivity levels, and professional development based on my diary entries. What trends do you see in my career journey?',
    ),
    AIAnalysisTemplate(
      id: 'wellness_check',
      title: 'Wellness & Health Check',
      description: 'Review physical and mental health indicators',
      icon: Icons.health_and_safety,
      prompt:
          'Review my overall wellness based on my diary entries. Analyze physical health mentions, mental health indicators, and lifestyle patterns.',
    ),
  ];

  static AIAnalysisTemplate? getTemplateById(String id) {
    try {
      return templates.firstWhere((template) => template.id == id);
    } catch (e) {
      return null;
    }
  }
}
