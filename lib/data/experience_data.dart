import '../features/experience/models/experience_model.dart';

class ExperienceData {
  static List<ExperienceModel> get experiences => [
    const ExperienceModel(
      company: 'Tech Company',
      role: 'Flutter Developer',
      startDate: 'Jan 2023',
      endDate: 'Present',
      achievements: [
        'Developed and maintained cross-platform mobile applications',
        'Implemented clean architecture patterns and state management',
        'Collaborated with design and backend teams',
        'Optimized app performance and reduced crash rates',
      ],
    ),
    const ExperienceModel(
      company: 'Startup Inc',
      role: 'Mobile Developer',
      startDate: 'Jun 2021',
      endDate: 'Dec 2022',
      achievements: [
        'Built native iOS applications using Swift and Objective-C',
        'Integrated REST APIs and third-party SDKs',
        'Participated in code reviews and agile development',
        'Delivered features on time with high code quality',
      ],
    ),
  ];
}

