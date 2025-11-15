import '../features/projects/models/project_model.dart';

class ProjectsData {
  static List<ProjectModel> get projects => [
    const ProjectModel(
      title: 'AtCost App',
      description: 'A comprehensive cost management application built with Flutter. Features include expense tracking, budget planning, and financial analytics.',
      techStack: ['Flutter', 'Dart', 'Firebase', 'Provider'],
      codeUrl: 'https://github.com',
      demoUrl: null,
    ),
    const ProjectModel(
      title: 'Networking Demo',
      description: 'Demonstration app showcasing REST API integration, error handling, and state management patterns in Flutter applications.',
      techStack: ['Flutter', 'Dart', 'REST API', 'Riverpod'],
      codeUrl: 'https://github.com',
      demoUrl: null,
    ),
    const ProjectModel(
      title: 'Image Gallery App',
      description: 'Beautiful image gallery with smooth animations, lazy loading, and image caching. Built with modern Flutter practices.',
      techStack: ['Flutter', 'Dart', 'Cached Network Image', 'Hero Animations'],
      codeUrl: 'https://github.com',
      demoUrl: null,
    ),
    const ProjectModel(
      title: 'Method Channel Demos',
      description: 'Native platform integration examples demonstrating Flutter method channels for iOS and Android native code communication.',
      techStack: ['Flutter', 'Dart', 'Swift', 'Kotlin', 'Method Channels'],
      codeUrl: 'https://github.com',
      demoUrl: null,
    ),
  ];
}

