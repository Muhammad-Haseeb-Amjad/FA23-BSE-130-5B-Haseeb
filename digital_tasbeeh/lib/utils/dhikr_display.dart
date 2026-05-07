/// Returns true if [text] contains any Arabic Unicode characters.
bool isArabic(String text) {
  return RegExp(r'[\u0600-\u06FF]').hasMatch(text);
}

/// Returns the Arabic display name for the 3 default dhikrs.
/// All other names are returned unchanged.
String getDhikrDisplayName(String name) {
  switch (name) {
    case 'SubhanAllah':
      return 'سُبْحَانَ ٱللّٰهِ';
    case 'Alhamdulillah':
      return 'ٱلْحَمْدُ لِلّٰهِ';
    case 'Allahu Akbar':
      return 'ٱللّٰهُ أَكْبَرُ';
    default:
      return name;
  }
}

/// Returns the font family to use for [text].
/// Arabic text uses Amiri; everything else uses the system default.
String? fontFamilyFor(String text) {
  return isArabic(text) ? 'Amiri' : null;
}
