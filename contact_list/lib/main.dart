import 'dart:ui';

import 'package:contact_list/my_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load();

  runApp(const MyApp());
}

void initializeLocale() {
  Locale systemLocale = PlatformDispatcher.instance.locale;
  initializeDateFormatting('pt_BR', null);
  Intl.defaultLocale = systemLocale.languageCode;
}
