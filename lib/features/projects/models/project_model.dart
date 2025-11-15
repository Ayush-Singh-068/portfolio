class ProjectModel {
  final String title;
  final String description;
  final List<String> techStack;
  final String? codeUrl;
  final String? demoUrl;

  const ProjectModel({
    required this.title,
    required this.description,
    required this.techStack,
    this.codeUrl,
    this.demoUrl,
  });
}

