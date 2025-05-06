# InTune - Guitar Utility App

<img src="https://www.dropbox.com/scl/fi/xbw45n5r2zk53coqq0dz7/intune.jpg?rlkey=bzyfng9uvc9bc5fugr2mhzj4j&raw=1" alt="InTune App Screenshot" width="500" height="900">

## Overview

InTune is a comprehensive guitar utility application built with Flutter, designed to help guitarists tune their instruments, practice with a metronome, learn chord shapes, and explore songs with tablature. With a clean, intuitive interface and professional features, InTune serves as an all-in-one toolkit for guitarists of all skill levels.

## Platforms

- ✅ Android
- 🔜 iOS (Coming Soon)

## Download

- [Android APK](https://dennis-tomno.onrender.com/intune-release.apk) - Coming soon to Play Store
- iOS: Coming Soon to App Store

## Features

### 🎸 Guitar Tuner
- Precision pitch detection
- 12 different tuning options:
  - Standard
  - Drop D
  - Drop A
  - Half step down
  - Open C/D/F/G
  - Bass (4, 5, and 6 string)
- Visual tuning indicator
- Audio feedback

### ⏱️ Metronome
- Tempo range from 30 to 240 BPM
- Visual beat indication
- First beat emphasis
- Adjustable beat count

### 📚 Chord Library
- 9 different chord types with multiple variations
- Clear chord diagrams
- Finger positioning guides
- Swipeable interface with carousel navigation

### 🎵 Song Explorer
- Search for songs by title or artist
- View tablature for popular songs
- Download and play Guitar Pro files (.gp4, .gp5)
- Text-based tablature display

### 🎨 User Interface
- Modern, clean design
- Dark and light theme options
- System theme integration
- Responsive layout for different screen sizes

## Technical Implementation

InTune leverages several specialized packages to deliver its functionality:

- **Guitar Tuning**: Utilizes `pitch_detector_dart` and `flutter_voice_processor` for accurate real-time pitch detection
- **Chord Library**: Implements `carousel_slider` for smooth navigation between chord diagrams
- **Metronome**: Powered by `metronome` for precise timing and beat control
- **Song Explorer**: Features custom tab rendering and file management with `path_provider` and `url_launcher`

## Development

### Setup
```bash
# Clone repository
git clone https://github.com/yourusername/intune.git

# Run setup.bat(windows)
setup.bat
# Or setup.sh(linux) 
setup.sh

# Run the app
flutter run
```

## Future Roadmap

- Expanded chord library with advanced variations
- Interactive guitar lessons
- Custom backing track generator
- Chord progression builder
- Audio recording and playback features

## Contact

For collaboration or inquiries, please contact:
- Email: deni.tomno@gmail.com
- GitHub: (https://github.com/dtomno)

## License

## License

This project is licensed under the [GNU General Public License v3.0](LICENSE).

