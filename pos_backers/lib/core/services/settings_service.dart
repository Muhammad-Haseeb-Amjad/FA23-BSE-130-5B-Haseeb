import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  SettingsService._();
  static final SettingsService instance = SettingsService._();
  final ValueNotifier<ThemeMode> themeMode = ValueNotifier(ThemeMode.light);
  final ValueNotifier<String> role = ValueNotifier('admin');

  Future<ThemeMode> loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final mode = prefs.getString('theme_mode');
    switch (mode) {
      case 'dark':
        themeMode.value = ThemeMode.dark;
        break;
      case 'system':
        themeMode.value = ThemeMode.system;
        break;
      default:
        themeMode.value = ThemeMode.light;
    }
    return themeMode.value;
  }

  Future<String> loadRole() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString('user_role') ?? 'admin';
    role.value = saved;
    return saved;
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    final val = mode == ThemeMode.dark ? 'dark' : mode == ThemeMode.system ? 'system' : 'light';
    await prefs.setString('theme_mode', val);
    themeMode.value = mode;
  }

  Future<void> setRole(String roleName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_role', roleName);
    role.value = roleName;
  }

  Future<String> currencyCode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('currency_code') ?? 'USD';
  }

  Future<String> currencySymbol() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('currency_symbol') ?? r'$';
  }

  Future<bool> taxEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('tax_enabled') ?? true;
  }

  Future<bool> taxExclusive() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('tax_exclusive') ?? true;
  }

  Future<List<Map<String, dynamic>>> taxRules() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString('tax_rules');
    if (stored == null) return [];
    try {
      final decoded = (jsonDecode(stored) as List).map((e) => Map<String, dynamic>.from(e)).toList();
      return decoded;
    } catch (_) {
      return [];
    }
  }
}
