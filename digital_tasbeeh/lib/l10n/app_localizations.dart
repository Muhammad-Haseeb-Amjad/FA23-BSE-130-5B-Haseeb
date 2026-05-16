import 'package:flutter/material.dart';
import 'package:digital_tasbeeh/main.dart';

class AppLocalizations {
  final String languageCode;

  AppLocalizations(this.languageCode);

  static AppLocalizations of(BuildContext context) {
    return AppLocalizations(appSettingsProvider.language);
  }

  static const Map<String, Map<String, String>> _localizedValues = {
    'eng': {
      'settings': 'Settings',
      'preferences': 'PREFERENCES',
      'vibration': 'Vibration',
      'mute': 'Mute',
      'language': 'Language',
      'appearance': 'APPEARANCE',
      'theme': 'Theme',
      'dark': 'Dark',
      'black': 'Black',
      'support': 'SUPPORT',
      'rate_app': 'Rate App',
      'share_app': 'Share App',
      'other_apps': 'Other Apps',
      'privacy_policy': 'Privacy Policy',
      'terms_conditions': 'Terms & Conditions',
      'coming_soon': 'Coming soon',
      'developed_by': 'Developed by Muhammad Haseeb Amjad',
      'select_theme': 'Select Theme',
      'cancel': 'Cancel',
      'reset_count': 'Reset Count?',
      'reset': 'Reset',
      'prayer_dhikr': 'Prayer Dhikr',
      'dhikr_list': 'Dhikr List',
      'add_new_dhikr': 'Add New Dhikr',
      'enter_dhikr_name': 'Enter Dhikr name',
      'target_count_optional': 'Target Count (Optional)',
      'save_dhikr': 'Save Dhikr',
      'scan_from_image': 'Scan from Image',
      'speak_dhikr': 'Speak Dhikr',
      'listening': 'Listening...',
      'name_cannot_be_empty': 'Name cannot be empty',
      'edit_dhikr': 'Edit Dhikr',
      'my_dhikrs': 'My Dhikrs',
      'completed': 'Completed',
      'no_dhikrs_found': 'No dhikrs found',
      'search_dhikrs': 'Search dhikrs...',
      'delete_dhikr': 'Delete Dhikr?',
      'delete': 'Delete',
      'continue_text': 'Continue',
      'count_your_dhikr': 'Count Your Dhikr with Peace',
      'prayer_sequence': 'Prayer Sequence',
      'start': 'Start',
      'finish': 'Finish',
      'choose_language': 'Choose Language',
    },
    'urdu': {
      'settings': 'ترتیبات',
      'preferences': 'ترجیحات',
      'vibration': 'تھرتھراہٹ',
      'mute': 'آواز بند',
      'language': 'زبان',
      'appearance': 'دکھاوٹ',
      'theme': 'تھیم',
      'dark': 'تاریک',
      'black': 'سیاہ',
      'support': 'مدد',
      'rate_app': 'ایپ کو ریٹ کریں',
      'share_app': 'ایپ شیئر کریں',
      'other_apps': 'مزید ایپس',
      'privacy_policy': 'رازداری کی پالیسی',
      'terms_conditions': 'شرائط و ضوابط',
      'coming_soon': 'جلد آ رہا ہے',
      'developed_by': 'تیار کردہ: محمد حسیب امجد',
      'select_theme': 'تھیم منتخب کریں',
      'cancel': 'منسوخ کریں',
      'reset_count': 'گِنتی صفر کریں؟',
      'reset': 'صفر کریں',
      'prayer_dhikr': 'نماز کا ذکر',
      'dhikr_list': 'اذکار کی فہرست',
      'add_new_dhikr': 'نیا ذکر شامل کریں',
      'enter_dhikr_name': 'ذکر کا نام درج کریں',
      'target_count_optional': 'ہدف کی تعداد (اختیاری)',
      'save_dhikr': 'ذکر محفوظ کریں',
      'scan_from_image': 'تصویر سے اسکین کریں',
      'speak_dhikr': 'ذکر بولیں',
      'listening': 'سن رہا ہے...',
      'name_cannot_be_empty': 'نام خالی نہیں ہو سکتا',
      'edit_dhikr': 'ذکر میں ترمیم کریں',
      'my_dhikrs': 'میرے اذکار',
      'completed': 'مکمل',
      'no_dhikrs_found': 'کوئی ذکر نہیں ملا',
      'search_dhikrs': 'اذکار تلاش کریں...',
      'delete_dhikr': 'ذکر حذف کریں؟',
      'delete': 'حذف کریں',
      'continue_text': 'جاری رکھیں',
      'count_your_dhikr': 'اپنے ذکر کو سکون سے گنیں',
      'prayer_sequence': 'نماز کی ترتیب',
      'start': 'شروع',
      'finish': 'ختم',
      'choose_language': 'زبان منتخب کریں',
    },
  };

  String translate(String key) {
    // Fallback to english if key or language not found
    final map = _localizedValues[languageCode] ?? _localizedValues['eng']!;
    return map[key] ?? _localizedValues['eng']![key] ?? key;
  }
}
