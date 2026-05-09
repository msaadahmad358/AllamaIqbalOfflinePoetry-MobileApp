# Kuliyat-E-Iqbal - Flutter App

A comprehensive Flutter application for reading and exploring the works of Allama Iqbal, one of the greatest Urdu poets of the 20th century. This app provides access to his complete poetry collections with multilingual support including Urdu, English, and Roman Urdu translations.

## About Allama Iqbal

Allama Sir Muhammad Iqbal (1877-1938) was a renowned poet, philosopher, and intellectual from the Indian subcontinent. His works have profoundly influenced Urdu literature and Islamic thought. This app showcases his complete poetry collections (Kuliyat-E-Iqbal) in an accessible digital format.

## Table of Contents

- [Features](#features)
- [Requirements](#requirements)
- [Installation](#installation)
- [Project Structure](#project-structure)
- [Usage](#usage)
- [Development](#development)
- [Data Format](#data-format)
- [Technologies Used](#technologies-used)
- [License](#license)

## Features

### 📚 Poetry Collections
- Access to 11+ complete poetry collections including:
  - Bang-e-Dara (The Call of the Marching Bell)
  - Bal-e-Jibreel (Wings of Gabriel)
  - Zarb-e-Kalim (Blows of the Staff of Moses)
  - Javid Nama (Book of Eternity)
  - And many more

### 🌐 Multilingual Support
- **Urdu (اردو)**: Original language texts
- **English**: Complete English translations
- **Roman Urdu**: Transliterated Urdu for readers unfamiliar with Urdu script

### 🎵 Audio Features
- Listen to poetry recitations via integrated audio player
- Audio playback with play/pause controls
- Stream audio from URLs

### 🎨 User Experience
- Clean, intuitive interface
- Easy navigation between collections and poems
- Language toggle (EN/UR/RU) for seamless switching
- Responsive design for various screen sizes

### 📝 Annotation Features
- Add personal notes and annotations on verses
- Bookmark favorite poems
- Save reading progress

### 🔍 Browse Features
- Browse complete collections
- Search and filter poems
- View detailed poem information
- Read translations side-by-side

## Requirements

Before you begin, ensure you have the following installed:

- **Flutter**: 3.10.0 or higher
  - [Flutter Installation Guide](https://flutter.dev/docs/get-started/install)
- **Dart**: 3.0.0 or higher (comes with Flutter)
- **Android SDK**: For Android development (API level 21+)
- **Xcode**: For iOS development (macOS only)
- **Java JDK**: 11 or higher for Android build tools

## Installation

### 1. Clone the Repository
```bash
git clone https://github.com/yourusername/iqbal.git
cd iqbal
```

### 2. Install Dependencies
```bash
flutter pub get
```

### 3. Generate Code (if needed)
```bash
flutter pub run build_runner build
```

### 4. Run the App
```bash
flutter run
```

### For Specific Platforms

**Android:**
```bash
flutter run -d android
```

**iOS:**
```bash
flutter run -d ios
```

**Web:**
```bash
flutter run -d web
```

**Windows:**
```bash
flutter run -d windows
```

**macOS:**
```bash
flutter run -d macos
```

**Linux:**
```bash
flutter run -d linux
```

## Project Structure

```
lib/
├── main.dart                          # Application entry point
├── config/                            # App configuration
│   ├── app_config.dart               # Global app settings
│   └── routes.dart                   # Navigation routes
├── models/                            # Data models
│   ├── localized_text.dart           # Multi-language text model
│   ├── poem.dart                     # Poem data model
│   └── collection.dart               # Collection data model
├── screens/                           # UI Screens
│   ├── home_screen.dart              # Home/Landing screen
│   ├── collection_list_screen.dart   # Collections listing
│   ├── poem_screen.dart              # Individual poem view
│   └── search_screen.dart            # Search functionality
├── widgets/                           # Reusable widgets
│   ├── poem_card.dart                # Poem card component
│   ├── language_toggle.dart          # Language selector
│   ├── audio_player.dart             # Audio player widget
│   └── annotation_panel.dart         # Notes/annotation panel
└── utils/                             # Utility functions
    ├── constants.dart                # App constants
    ├── theme.dart                    # App theming
    ├── locale_helper.dart            # Localization helpers
    └── audio_helper.dart             # Audio utilities

assets/
├── data/
│   ├── list-of-lists.yaml            # Collections index
│   └── lists/                        # Individual collection YAML files
├── images/                           # UI images and icons
├── poems/                            # Poetry text files
│   ├── 001/                          # Collection 1
│   ├── 002/                          # Collection 2
│   └── ...                           # More collections
└── fonts/                            # Custom fonts (Urdu support)

android/                              # Android native code
ios/                                  # iOS native code
web/                                  # Web platform files
windows/                              # Windows platform files
macos/                                # macOS platform files
linux/                                # Linux platform files
```

## Usage

### 1. Launch the App
After running `flutter run`, the app will start on your default device/emulator.

### 2. Browse Collections
- Tap on a collection from the home screen to view all poems in that collection
- Each collection shows the number of poems and a brief description

### 3. Read a Poem
- Tap on any poem to open the full poem view
- View the poem in your preferred language (Urdu, English, or Roman Urdu)
- Use the language toggle to switch between translations

### 4. Listen to Audio
- Tap the play button to listen to the poem recitation
- Use standard audio controls (play, pause, seek)
- Control volume using device controls

### 5. Make Notes
- Tap the annotation icon to add personal notes
- Save your notes for future reference
- Bookmark favorite poems for quick access

### 6. Search Poems
- Use the search feature to find poems by keywords
- Filter by collection or language
- View search results with highlighted matches

## Development

### Building APK (Android)
```bash
flutter build apk --release
```

### Building App Bundle (Android)
```bash
flutter build appbundle --release
```

### Building IPA (iOS)
```bash
flutter build ios --release
```

### Building Web Release
```bash
flutter build web --release
```

### Code Analysis
```bash
flutter analyze
```

### Run Tests
```bash
flutter test
```

### Format Code
```bash
dart format lib/
```

## Data Format

### YAML Data Structure

The app uses YAML files to store poetry data:

```yaml
collections:
  - id: "001"
    title: "Bang-e-Dara"
    title_urdu: "بانگِ درا"
    description: "The Call of the Marching Bell"
    poems:
      - id: "001_001"
        title: "Poem Title"
        text_urdu: "شاعری کا متن"
        text_english: "Poetry translation"
        text_roman_urdu: "Transliterated text"
        audio_url: "https://example.com/audio.mp3"
```

## Technologies Used

### Flutter & Dart
- **Flutter**: 3.10.0+ - UI framework
- **Dart**: 3.0.0+ - Programming language

### Key Dependencies
- `audioplayers`: Audio playback functionality
- `shared_preferences`: Local data persistence
- `yaml`: YAML file parsing
- `url_launcher`: Open URLs
- `google_fonts`: Typography

### Platforms Supported
- ✅ Android (API 21+)
- ✅ iOS (12.0+)
- ✅ Web
- ✅ Windows
- ✅ macOS
- ✅ Linux

## Configuration

### App Configuration File
Update `lib/config/app_config.dart` to customize:
- App name and version
- Default language
- Theme colors
- API endpoints (if applicable)
- Audio quality settings

### Theme Customization
Edit `lib/utils/theme.dart` to:
- Change color scheme
- Modify typography
- Adjust spacing and sizing
- Customize dark/light modes

## Troubleshooting

### Flutter Issues
- **Pub get fails**: Try `flutter clean` then `flutter pub get`
- **Build errors**: Run `flutter doctor` to check environment setup
- **Android issues**: Ensure SDK is properly configured

### App Issues
- **Audio not playing**: Check internet connection and audio URLs
- **Layout issues**: Try `flutter run --verbose` for detailed logs
- **Language not switching**: Clear app cache and restart

### Performance
- If app is slow, check device resources
- Consider building release version: `flutter run --release`

## Contributing

We welcome contributions! Please:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

### Development Guidelines
- Follow Dart style guide
- Write meaningful commit messages
- Add comments for complex logic
- Test thoroughly before submitting PR

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- Allama Muhammad Iqbal - For his timeless poetry and philosophy
- Flutter team - For the amazing framework
- Contributors and supporters of this project

## Contact & Support

For questions, suggestions, or issues:
- Open an issue on GitHub
- Contact the maintainers
- Visit the project wiki for more information

---

**Last Updated**: May 2026
**Version**: 1.0.0
**Maintained by**: Iqbal App Team
