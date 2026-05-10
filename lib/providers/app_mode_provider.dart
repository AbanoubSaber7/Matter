import 'package:flutter/material.dart';
import '../models/risk_assessment.dart';

enum AppMode { private, emergency }

class AppModeProvider with ChangeNotifier {
  AppMode _currentMode = AppMode.private;
  RiskLevel _currentRisk = RiskLevel.low;

  AppMode get currentMode => _currentMode;
  RiskLevel get currentRisk => _currentRisk;

  void setMode(AppMode mode) {
    _currentMode = mode;
    notifyListeners();
  }

  void setRiskLevel(RiskLevel level) {
    _currentRisk = level;
    notifyListeners();
  }
}