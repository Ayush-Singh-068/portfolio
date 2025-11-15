import '../features/experience/models/experience_model.dart';

class ExperienceData {
  static List<ExperienceModel> get experiences => [
    const ExperienceModel(
      company: 'Calance Software',
      role: 'SDE-3',
      startDate: 'May 2024',
      endDate: 'Present',
      achievements: [
        'Develop and maintain scalable Flutter applications with a focus on clean architecture',
        'Implement advanced state management solutions using Riverpod and Flutter Hooks',
        'Optimize performance and ensure smooth API integrations using Dio and Retrofit',
      ],
    ),
    const ExperienceModel(
      company: 'Unthinkable Solutions',
      role: 'Associate - Software Engineering',
      startDate: 'Oct 2020',
      endDate: 'May 2024',
      achievements: [
        'Built and deployed Flutter applications for Android and iOS with responsive UI designs',
        'Integrated REST APIs and managed app state using Provider and BLoC',
        'Conducted dev-testing and debugging to deliver stable and efficient applications',
      ],
    ),
  ];
}

