import '../features/projects/models/project_model.dart';

class ProjectsData {
  static List<ProjectModel> get projects => [
    const ProjectModel(
      title: 'Nana',
      description: 'E-commerce app designed for online shopping delivery of groceries, fruits, and daily needs. Features server-driven UI, clean architecture, responsive UI development, and comprehensive state management with BLoC pattern.',
      techStack: ['Flutter', 'Dart', 'BLoC', 'Dio', 'RudderStack', 'HiveDB', 'Firebase'],
      codeUrl: null,
      demoUrl: null,
    ),
    const ProjectModel(
      title: 'North Ladder Customer App',
      description: 'Application to help users sell or mortgage their products. Users can buyback their products by giving the right amount. If users wish to extend the date, they can pay extension fees and increase the days within which they are required to buyback the product.',
      techStack: ['Flutter', 'Dart', 'BLoC', 'Provider', 'Dio', 'Retrofit', 'Firebase', 'GitHub Actions'],
      codeUrl: null,
      demoUrl: null,
    ),
    const ProjectModel(
      title: 'Omega',
      description: 'Mobile application that offers users an all-in-one experience. Allows users to order various services including food, groceries, movie tickets, flight tickets, hotels, and weather updates, all with the convenience of integrated Automatic Speech Recognition (ASR) and Machine Learning (ML) technologies.',
      techStack: ['Flutter', 'Dart', 'BLoC', 'Dio', 'Retrofit', 'Clean Architecture', 'TDD'],
      codeUrl: null,
      demoUrl: null,
    ),
    const ProjectModel(
      title: 'Smart PBC',
      description: 'Healthcare app that consolidates all healthcare documents and records in one place, ensuring quick access during health emergencies without the need to gather insurance details, past test reports, etc.',
      techStack: ['Flutter', 'Dart', 'Riverpod', 'Flutter Hooks', 'Dio', 'Retrofit'],
      codeUrl: null,
      demoUrl: null,
    ),
    const ProjectModel(
      title: 'AtCost',
      description: 'A simple and straightforward grocery ordering app that allows users to browse products, add items to cart, and place orders with ease. Focuses on clean design and smooth user experience for everyday grocery shopping needs.',
      techStack: ['Flutter', 'Dart', 'State Management', 'REST API'],
      codeUrl: null,
      demoUrl: null,
    ),
  ];
}

