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
      name: 'Riverpod',
      description: 'State management solution',
      icon: FontAwesomeIcons.layerGroup,
    ),
    const SkillModel(
      name: 'Flutter Hooks',
      description: 'Reusable stateful logic',
      icon: FontAwesomeIcons.codeBranch,
    ),
    const SkillModel(
      name: 'BLoC',
      description: 'Business logic component pattern',
      icon: FontAwesomeIcons.diagramProject,
    ),
    const SkillModel(
      name: 'Provider',
      description: 'State management pattern',
      icon: FontAwesomeIcons.box,
    ),
    const SkillModel(
      name: 'Dio',
      description: 'HTTP client for API calls',
      icon: FontAwesomeIcons.networkWired,
    ),
    const SkillModel(
      name: 'Retrofit',
      description: 'Type-safe HTTP client',
      icon: FontAwesomeIcons.arrowsRotate,
    ),
    const SkillModel(
      name: 'Clean Architecture',
      description: 'Scalable app architecture',
      icon: FontAwesomeIcons.building,
    ),
    const SkillModel(
      name: 'Firebase',
      description: 'Backend services & push notifications',
      icon: FontAwesomeIcons.fire,
    ),
    const SkillModel(
      name: 'REST APIs',
      description: 'API integration & networking',
      icon: FontAwesomeIcons.globe,
    ),
  ];
}

