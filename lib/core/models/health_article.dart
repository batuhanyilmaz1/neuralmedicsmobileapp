import 'package:flutter/material.dart';

class HealthArticle {
  const HealthArticle({
    required this.id,
    required this.title,
    required this.category,
    required this.readMinutes,
    required this.icon,
    required this.summary,
    required this.paragraphs,
  });

  final String id;
  final String title;
  final String category;
  final int readMinutes;
  final IconData icon;
  final String summary;
  final List<String> paragraphs;
}
