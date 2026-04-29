# Digital Tasbeeh 📿

A beautifully designed digital tasbeeh (dhikr counter) app built with Flutter. Keep track of your daily Islamic remembrance with an elegant and feature-rich interface.

## ✨ Features

- **Interactive Counter**: Tap anywhere on the circle to count your dhikr
- **Multiple Dhikr Management**: Create and manage unlimited dhikr counters
- **Target Setting**: Set daily goals for each dhikr (e.g., 33, 100, 1000 times)
- **Prayer Sequence Mode**: Follow the traditional post-prayer dhikr sequence (SubhanAllah 33x, Alhamdulillah 33x, Allahu Akbar 34x)
- **Haptic Feedback**: Vibration feedback on each count
- **Sound Options**: Mute/unmute sound effects
- **Progress Tracking**: Visual progress indicators for target-based dhikr
- **Persistent Storage**: All your dhikr data is saved locally
- **Dark Theme**: Beautiful green-themed dark interface
- **Multi-language Support**: English and Urdu interface
- **Arabic Text Display**: Beautiful Arabic text for each dhikr

## 📱 Screens

1. **Counter Screen**: Main counting interface with large, easy-to-tap circle
2. **My Dhikrs**: List view of all your saved dhikrs with progress indicators
3. **Add/Edit Dhikr**: Create new dhikrs or edit existing ones
4. **Prayer Sequence**: Step-by-step guided dhikr sequence
5. **Settings**: Customize vibration, sound, language, and theme preferences

## 🎨 Design Features

- Clean, modern Islamic-inspired design
- Smooth animations and transitions
- Easy-to-read typography
- Color-coded progress indicators
- Icon-based navigation

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (>=3.9.2)
- Android Studio / VS Code
- Android SDK / iOS SDK

### Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/digital_tasbeeh.git
cd digital_tasbeeh
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

## 📦 Dependencies

- `shared_preferences`: ^2.2.2 - Local data persistence
- `vibration`: ^2.0.0 - Haptic feedback
- `audioplayers`: ^6.0.0 - Sound effects

## 🏗️ Project Structure

```
lib/
├── main.dart                 # App entry point
├── models/
│   └── dhikr.dart           # Dhikr data model
├── services/
│   └── storage_service.dart # Local storage handling
└── screens/
    ├── counter_screen.dart       # Main counting screen
    ├── my_dhikrs_screen.dart     # Dhikr list screen
    ├── add_dhikr_screen.dart     # Add/edit dhikr screen
    ├── prayer_sequence_screen.dart # Prayer sequence screen
    └── settings_screen.dart      # Settings screen
```

## 🎯 Usage

1. **Count Dhikr**: Tap the large circle on the main screen to increment the count
2. **Switch Dhikr**: Tap the menu icon to view and select different dhikrs
3. **Add New Dhikr**: Tap the + button in My Dhikrs screen
4. **Set Target**: Enable "Set Target" toggle when creating/editing a dhikr
5. **Reset Count**: Use the reset button to start over
6. **Prayer Sequence**: Complete traditional post-prayer dhikr in guided mode

## 🎨 Color Scheme

- Primary Green: `#4ADE80`
- Dark Background: `#1A2F2F`
- Card Background: `#234141`
- Accent Dark: `#2D4D4D`

## 📄 License

This project is open source and available under the MIT License.

## 🤲 Islamic Dhikr References

The app includes common Islamic dhikr:
- **SubhanAllah** (سُبْحَانَ اللّهِ) - Glory be to Allah
- **Alhamdulillah** (الْحَمْدُ لِلّهِ) - All praise is due to Allah
- **Allahu Akbar** (اللّهُ أَكْبَرُ) - Allah is the Greatest
- **La ilaha illallah** (لَا إِلٰهَ إِلَّا ٱللَّٰهُ) - There is no god but Allah
- **Istighfar** (أَسْتَغْفِرُ اللّهَ) - I seek forgiveness from Allah

## 👨‍💻 Author

FA23-BSE-130-5B

## 🙏 Acknowledgments

- Design inspired by modern Islamic app aesthetics
- Built with Flutter for cross-platform compatibility
- Includes traditional Islamic dhikr practices

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
