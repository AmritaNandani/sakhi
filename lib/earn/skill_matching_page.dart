// lib/pages/skill_matching_page.dart
import 'package:sakhi/earn/business_idea_detail_page.dart';
import 'package:sakhi/services/api_service.dart';
import 'package:sakhi/theme/save_theme.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sakhi/earn/business_idea.dart';

class SkillMatchingPage extends StatefulWidget {
  const SkillMatchingPage({super.key});

  @override
  State<SkillMatchingPage> createState() => _SkillMatchingPageState();
}

class _SkillMatchingPageState extends State<SkillMatchingPage> {
  final TextEditingController _skillsController = TextEditingController();
  List<BusinessIdea> _suggestedIdeas = [];
  bool _isLoading = false;

  // Mock data for demonstration. In a real app, this would come from the backend/AI.
  final List<BusinessIdea> _mockIdeas = [
    BusinessIdea(
      id: '1',
      title: 'Home-based Tiffin Service',
      description: 'Prepare and deliver healthy home-cooked meals to offices or residents. High demand in urban areas for fresh, hygienic food.',
      skillsNeeded: ['Cooking', 'Meal Planning', 'Time Management', 'Hygiene'],
      earningPotential: '₹5,000 - ₹25,000+ per month (depends on scale)',
      startupTips: 'Start with a few loyal customers. Focus on hygiene and quality. Use social media (WhatsApp groups) for marketing. Offer daily/weekly subscription plans.',
      requiredMaterials: 'Cooking utensils, lunchboxes, fresh ingredients, delivery containers (optional if pick-up).'
    ),
    BusinessIdea(
      id: '2',
      title: 'Custom Blouse Stitching',
      description: 'Offer tailoring services for women\'s blouses, especially custom designs for sarees. Many women prefer bespoke fitting.',
      skillsNeeded: ['Stitching', 'Pattern Making', 'Measurement Taking', 'Design Sense', 'Client Communication'],
      earningPotential: '₹3,000 - ₹15,000+ per month (depends on volume and intricacy)',
      startupTips: 'Start with friends and family. Show your work on WhatsApp/Instagram. Offer alterations initially to build clientele. Invest in a good sewing machine.',
      requiredMaterials: 'Sewing machine, fabric, threads, measuring tape, scissors, design books/samples.'
    ),
    BusinessIdea(
      id: '3',
      title: 'Handmade Jewelry Business',
      description: 'Create unique handmade jewelry pieces like earrings, necklaces, and bracelets. Can be sold online or at local markets.',
      skillsNeeded: ['Crafting', 'Creativity', 'Design', 'Attention to Detail', 'Marketing Basics'],
      earningPotential: '₹2,000 - ₹10,000+ per month (depends on uniqueness and marketing)',
      startupTips: 'Find a niche (e.g., traditional, modern, eco-friendly). Use affordable materials to start. Take good product photos for online selling. Participate in local craft fairs.',
      requiredMaterials: 'Beads, wires, tools, clasps, pliers, packaging materials.'
    ),
    BusinessIdea(
      id: '4',
      title: 'Tuition/Coaching at Home',
      description: 'Provide academic support or skill-based coaching (e.g., languages, music, art) to students of various age groups from your home.',
      skillsNeeded: ['Subject Expertise', 'Teaching Skills', 'Patience', 'Communication', 'Curriculum Planning'],
      earningPotential: '₹4,000 - ₹20,000+ per month (depends on number of students and subjects)',
      startupTips: 'Identify your strongest subjects. Start with students in your neighborhood. Offer a demo class. Ask for referrals from satisfied parents.',
      requiredMaterials: 'Textbooks, notebooks, whiteboard/blackboard, stationery.'
    ),
    BusinessIdea(
      id: '5',
      title: 'Event Decorator (Small Scale)',
      description: 'Offer services for small event decorations like birthday parties, anniversaries, or baby showers. Focus on budget-friendly, creative designs.',
      skillsNeeded: ['Creativity', 'Design', 'Organization', 'Budget Management', 'Vendor Negotiation'],
      earningPotential: '₹3,000 - ₹10,000 per event',
      startupTips: 'Start with small family events to build a portfolio. Use online platforms for inspiration. Partner with local florists or balloon suppliers. Offer packages to clients.',
      requiredMaterials: 'Balloons, fabric, lights, flowers, small props, basic tools.'
    ),
  ];

 void _getJobIdeas() async {
  FocusScope.of(context).unfocus(); // Dismiss keyboard
  final String skillsInput = _skillsController.text.trim();

  if (skillsInput.isEmpty) {
    _showSnackBar('Please tell me what skills you have!', error: true);
    return;
  }

  setState(() {
    _isLoading = true;
    _suggestedIdeas = [];
  });

  try {
    final response = await ApiService().post("/earn/", {"skill": skillsInput});

    final BusinessIdea idea = BusinessIdea(
      id: response['id'],
      title: response['title'],
      description: response['description'],
      skillsNeeded: List<String>.from(response['skillsNeeded']),
      earningPotential: response['earningPotential in rupees'],
      startupTips: response['startupTips'],
      requiredMaterials: response['requiredMaterials'],
    );

    setState(() {
      _isLoading = false;
      _suggestedIdeas = [idea];
    });

    _showSnackBar('Here’s a business idea matched to your skills!');
  } catch (e) {
    setState(() {
      _isLoading = false;
    });
    _showSnackBar('Something went wrong: $e', error: true);
  }
}

  void _showSnackBar(String message, {bool error = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: error ? AppTheme.errorColor : AppTheme.primaryColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(10),
      ),
    );
  }

  @override
  void dispose() {
    _skillsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          Text(
            'Convert Your Skills to Income',
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextFormField(
                    controller: _skillsController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: 'What are you good at?',
                      hintText: 'e.g., I can cook, stitch, and teach.',
                      prefixIcon: const Icon(Icons.psychology_alt_rounded, color: AppTheme.primaryColor),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.mic_rounded, color: AppTheme.primaryColor),
                        onPressed: () {
                          // Simulate voice input for skills
                          _skillsController.text = 'I can cook and stitch'; // Example voice input
                          _showSnackBar('Voice input simulated: "I can cook and stitch"');
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: _isLoading ? null : _getJobIdeas,
                    icon: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                          )
                        : const Icon(Icons.search_rounded),
                    label: Text(_isLoading ? 'Finding Ideas...' : 'Find Income Ideas'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          if (_suggestedIdeas.isNotEmpty)
            Text(
              'Suggested Income Opportunities',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
          const SizedBox(height: 16),
          ..._suggestedIdeas.map((idea) {
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                leading: CircleAvatar(
                  backgroundColor: AppTheme.accentColor.withOpacity(0.2),
                  child: Icon(FontAwesomeIcons.handshake, color: AppTheme.primaryColor, size: 24), // Relevant icon
                ),
                title: Text(
                  idea.title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppTheme.primaryColor),
                ),
                subtitle: Text(
                  idea.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 18, color: AppTheme.textColor),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BusinessIdeaDetailPage(idea: idea),
                    ),
                  );
                },
              ),
            );
          }).toList(),
          if (_suggestedIdeas.isEmpty && !_isLoading)
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  Icon(Icons.lightbulb_outline, size: 60, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'No specific ideas yet. Try describing your skills more!',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          const SizedBox(height: 20),
          Text(
            'Unlock your potential, build your independence.',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
