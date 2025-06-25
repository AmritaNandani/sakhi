// lib/models/business_idea.dart

class BusinessIdea {
  final String id;
  final String title;
  final String description;
  final List<String> skillsNeeded;
  final String earningPotential;
  final String startupTips;
  final String requiredMaterials;

  BusinessIdea({
    required this.id,
    required this.title,
    required this.description,
    required this.skillsNeeded,
    required this.earningPotential,
    required this.startupTips,
    required this.requiredMaterials,
  });
}
