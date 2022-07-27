import 'package:flutter/material.dart';
import 'package:weight_tracker_task_app/logic/logic.dart';
import 'package:weight_tracker_task_app/ui/ui.dart';

List<Page> onGenerateWeightTrackerAppViewPages(
  AppStatus status,
  List<Page<dynamic>> pages,
) {
  switch (status) {
    case AppStatus.authenticated:
      return [HomeScreen.page()];
    case AppStatus.unauthenticated:
      return [SignInScreen.page()];
  }
}
