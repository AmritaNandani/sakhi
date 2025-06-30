import 'package:sakhi/earn/business_idea.dart';
import 'package:sakhi/services/api_service.dart';

final ApiService _api = ApiService();

Future<List<BusinessIdea>> getEarnIdeas(String skill) async {
  final response = await _api.post("/earn/ideas/", {"skill": skill});

  final List<dynamic> ideasRaw = response['ideas'];

  return ideasRaw.map((json) {
    return BusinessIdea(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      skillsNeeded: List<String>.from(json['skillsNeeded']),
      earningPotential: json['earningPotential in rupees'],
      startupTips: json['startupTips'],
      requiredMaterials: json['requiredMaterials'],
    );
  }).toList();
}
