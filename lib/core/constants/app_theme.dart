
import 'package:puntgpt_nick/core/app_imports.dart';

class AppTheme {
  AppTheme._();

  static final ThemeData appThemeData = ThemeData(
    scaffoldBackgroundColor: AppColors.white,
    fontFamily: AppFontFamily.primary,
    brightness: Brightness.light,
    textSelectionTheme: TextSelectionThemeData(
      selectionColor: AppColors.primary.setOpacity(0.5),
      cursorColor: AppColors.primary,
      selectionHandleColor: AppColors.primary,
    ),
    appBarTheme: AppBarTheme(
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      backgroundColor: AppColors.transparent,
      
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: AppColors.primary,
      ),
    ),
  );
}
