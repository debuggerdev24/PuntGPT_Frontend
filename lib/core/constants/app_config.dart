import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  AppConfig._();
  static String get baseurl => dotenv.env['BASE_URL'] ?? 'http://170.64.236.188';
  static String get apiBaseurl => "$baseurl/api";
}