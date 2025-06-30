import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_state.dart';


// class ThemeCubit extends Cubit<ThemeMode> {
//   ThemeCubit() : super(ThemeMode.light);

//   void toggleTheme(bool isDark) {
//     emit(isDark ? ThemeMode.dark : ThemeMode.light);
//   }
// }




class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.light);

  static const String _themeKey = 'theme_mode';

  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final themeString = prefs.getString(_themeKey);

    if (themeString == 'dark') {
      emit(ThemeMode.dark);
    } else {
      emit(ThemeMode.light);
    }
  }

  Future<void> toggleTheme(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, isDark ? 'dark' : 'light');
    emit(isDark ? ThemeMode.dark : ThemeMode.light);
  }
}
