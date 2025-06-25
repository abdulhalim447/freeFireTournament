import 'package:flutter/material.dart';

// Legacy model classes for widget compatibility

class MatchCategory {
  final int id;
  final String name;
  final Color color;
  final bool isActive;
  final String? image;

  MatchCategory({
    required this.id,
    required this.name,
    required this.color,
    this.isActive = false,
    this.image,
  });
}

class TodayMatch {
  final String title;
  final String mode;
  final String map;
  final String game;
  final DateTime date;
  final String time;
  final String description;

  TodayMatch({
    required this.title,
    required this.mode,
    required this.map,
    required this.game,
    required this.date,
    required this.time,
    required this.description,
  });
}

class UpcomingMatch {
  final int id;
  final String title;
  final String time;
  final String entryFee;
  final String prize;

  UpcomingMatch({
    required this.id,
    required this.title,
    required this.time,
    required this.entryFee,
    required this.prize,
  });
}

// Extension methods for Color to support withValues
extension ColorExtension on Color {
  Color withValues({int? red, int? green, int? blue, double? alpha}) {
    return Color.fromRGBO(
      red ?? this.red,
      green ?? this.green,
      blue ?? this.blue,
      alpha ?? this.opacity,
    );
  }
}
