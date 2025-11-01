import 'package:flutter/material.dart';

// Got Help from ChatGPT for colors

class AppColors {
  AppColors._();

  // Primary Colors
  static const Color indigo = Color(0xFF6366F1);
  static const Color emerald = Color(0xFF10B981);
  
  // Neutral Colors
  static const Color gray900 = Color(0xFF111827);
  static const Color gray600 = Color(0xFF6B7280);
  static const Color gray500 = Color(0xFF9CA3AF);
  static const Color gray300 = Color(0xFFE5E7EB);
  static const Color gray200 = Color(0xFFF3F4F6);
  static const Color gray100 = Color(0xFFF8F9FA);
  static const Color gray50 = Color(0xFFFAFAFA);
  
  // Background Colors
  static const Color background = gray100;
  static const Color surface = Colors.white;
  
  // Border Colors
  static const Color border = gray300;
  static const Color divider = gray200;
  
  // Text Colors
  static const Color textPrimary = gray900;
  static const Color textSecondary = gray600;
  static const Color textTertiary = gray500;
  
  // Status Colors
  static const Color success = emerald;
  static const Color online = emerald;
  
  // Component Colors
  static const Color selectedTab = indigo;
  static const Color unselectedTab = gray500;
  static const Color fabBackground = indigo;
  static const Color scrollToTopFab = Colors.black;

  // Timeline Colors
  static const Color timelineAudit = indigo;
  static const Color timelineNote = emerald;
  static const Color timelineAuditBg = Color(0xFFEEF2FF);
  static const Color timelineNoteBg = Color(0xFFECFDF5);
  static const Color timelineAuditLight = Color(0xFFC7D2FE);
  static const Color timelineNoteLight = Color(0xFFD1FAE5);
}

