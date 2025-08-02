import 'package:flutter/material.dart';

import 'app.dart';
import 'utils/app_logger.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  AppLogger.info('Starting DiaryX application');
  runApp(const DiaryXApp());
}
