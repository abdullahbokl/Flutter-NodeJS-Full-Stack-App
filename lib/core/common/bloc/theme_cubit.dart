import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kThemeKey = 'theme_mode';

class ThemeCubit extends Cubit<ThemeMode> {
  final SharedPreferences _prefs;

  ThemeCubit(this._prefs)
      : super(_load(_prefs));

  static ThemeMode _load(SharedPreferences prefs) {
    final saved = prefs.getString(_kThemeKey);
    return saved == 'dark' ? ThemeMode.dark : ThemeMode.light;
  }

  void toggle() {
    final next = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    _prefs.setString(_kThemeKey, next == ThemeMode.dark ? 'dark' : 'light');
    emit(next);
  }

  void setDark()  { _set(ThemeMode.dark);  }
  void setLight() { _set(ThemeMode.light); }

  void _set(ThemeMode mode) {
    _prefs.setString(_kThemeKey, mode == ThemeMode.dark ? 'dark' : 'light');
    emit(mode);
  }
}

