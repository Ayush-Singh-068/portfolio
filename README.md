# Ayush Portfolio

A modern, responsive Flutter portfolio app featuring glassmorphism UI design, smooth animations, and cross-platform support (Web, Android, iOS).

## Features

- **Modern UI**: Glassmorphism design with dark theme
- **Responsive Layout**: Adapts to desktop, tablet, and mobile screens
- **Smooth Animations**: Implicit animations and scroll-based effects
- **Single-Page Design**: Smooth scroll navigation between sections
- **State Management**: Hook Riverpod with MVVM architecture

## Sections

1. **Home**: Hero section with profile, name, tagline, and introduction
2. **Skills**: Grid display of technical skills with icons
3. **Projects**: Showcase of projects with tech stack and links
4. **Experience**: Timeline view of work experience
5. **Contact**: Contact form with validation and social links

## Tech Stack

- Flutter 3.8.1+
- Dart
- Hook Riverpod (State Management)
- Google Fonts (Poppins)
- Font Awesome Icons

## Getting Started

### Prerequisites

- Flutter SDK (3.8.1 or higher)
- Dart SDK
- Android Studio / VS Code with Flutter extensions
- Xcode (for iOS development)
- Chrome (for web development)

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd portfolio_app
```

2. Install dependencies:
```bash
flutter pub get
```

3. Add your profile image:
   - Place your profile image at `assets/images/profile.png`
   - Recommended size: 400x400px or larger (square)

4. Customize content:
   - Update `lib/data/skills_data.dart` with your skills
   - Update `lib/data/projects_data.dart` with your projects
   - Update `lib/data/experience_data.dart` with your experience
   - Update `lib/core/constants/app_constants.dart` with your name and tagline
   - Update social links in `lib/features/contact/presentation/widgets/contact_section.dart`

## Running the App

### Web
```bash
flutter run -d chrome
```

### Android
```bash
flutter run -d android
```

### iOS
```bash
flutter run -d ios
```

## Project Structure

```
lib/
├── main.dart
├── core/
│   ├── theme/          # Theme and colors
│   ├── constants/      # App constants and responsive utilities
│   └── widgets/        # Reusable widgets
├── features/
│   ├── home/           # Home/hero section
│   ├── skills/         # Skills section
│   ├── projects/       # Projects section
│   ├── experience/     # Experience timeline
│   └── contact/        # Contact form and social links
├── models/             # Data models
└── data/               # Static data (skills, projects, experience)
```

## Customization

### Colors
Edit `lib/core/theme/app_colors.dart` to change the color scheme.

### Responsive Breakpoints
Edit `lib/core/constants/app_constants.dart` to adjust breakpoints and padding.

### Fonts
The app uses Google Fonts (Poppins). To change, edit `lib/core/theme/app_theme.dart`.

## Building for Production

### Web
```bash
flutter build web
```

### Android
```bash
flutter build apk --release
```

### iOS
```bash
flutter build ios --release
```

## Projects

The portfolio showcases the following projects:

1. **Nana** - E-commerce app for groceries and daily needs
2. **North Ladder Customer App** - Product selling/mortgaging application
3. **Omega** - All-in-one service app with ASR/ML integration
4. **Smart PBC** - Healthcare records consolidation app
5. **AtCost** - Simple grocery ordering app

All projects are client projects and do not include source code links. Website links can be added to the `demoUrl` field in `lib/data/projects_data.dart`.

## Notes

- The contact form is a demo (no backend integration)
- Profile image is optional - a placeholder icon will show if missing

## License

This project is open source and available for personal use.
