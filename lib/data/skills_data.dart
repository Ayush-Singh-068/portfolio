import '../models/skill_model.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SkillsData {
  static List<SkillModel> get skills => [
    const SkillModel(
      name: 'Flutter',
      description: 'Cross-platform mobile development',
      icon: FontAwesomeIcons.mobileScreen,
    ),
    const SkillModel(
      name: 'Dart',
      description: 'Programming language expertise',
      icon: FontAwesomeIcons.code,
    ),
    const SkillModel(
      name: 'Swift',
      description: 'iOS native development',
      icon: FontAwesomeIcons.apple,
    ),
    const SkillModel(
      name: 'Objective-C',
      description: 'Legacy iOS development',
      icon: FontAwesomeIcons.laptopCode,
    ),
    const SkillModel(
      name: 'Firebase',
      description: 'Backend services & authentication',
      icon: FontAwesomeIcons.fire,
    ),
    const SkillModel(
      name: 'REST APIs',
      description: 'API integration & networking',
      icon: FontAwesomeIcons.globe,
    ),
    const SkillModel(
      name: 'JavaScript/TypeScript',
      description: 'Web development (beginner)',
      icon: FontAwesomeIcons.js,
    ),
  ];
}

