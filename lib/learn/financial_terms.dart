// lib/pages/financial_terms_page.dart

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sakhi/theme/save_theme.dart';

class FinancialTermsPage extends StatefulWidget {
  const FinancialTermsPage({super.key});

  @override
  State<FinancialTermsPage> createState() => _FinancialTermsPageState();
}

class _FinancialTermsPageState extends State<FinancialTermsPage> {
  final TextEditingController _termController = TextEditingController();
  String _explanation = '';
  bool _isLoading = false;

  // Mock explanations
  final Map<String, String> _mockExplanations = {
    'interest': 'ब्याज वह अतिरिक्त पैसा होता है जो आप उधार ली गई राशि पर चुकाते हैं, या वह पैसा जो आप अपनी बचत पर कमाते हैं। यह पैसे का उपयोग करने की लागत या लाभ है। उदाहरण के लिए, यदि आप बैंक से ₹1000 उधार लेते हैं और ब्याज दर 10% है, तो आपको ₹1000 के अलावा ₹100 अतिरिक्त चुकाने होंगे। इसी तरह, यदि आप बैंक में ₹1000 जमा करते हैं और ब्याज दर 5% है, तो आपको ₹1000 के अलावा ₹50 अतिरिक्त मिलेंगे।',
    'loan': 'लोन एक निश्चित अवधि के लिए उधार ली गई राशि होती है, जिसे ब्याज के साथ वापस चुकाया जाता है। यह अक्सर घर खरीदने, व्यवसाय शुरू करने या शिक्षा के लिए उपयोग किया जाता है।',
    'upi': 'UPI (Unified Payments Interface) भारत में एक इंस्टेंट पेमेंट सिस्टम है। यह आपको मोबाइल नंबर या वर्चुअल पेमेंट एड्रेस (VPA) का उपयोग करके तुरंत पैसे भेजने और प्राप्त करने की सुविधा देता है।',
    'budgeting': 'बजटिंग अपनी आय और खर्चों की योजना बनाने की प्रक्रिया है ताकि आप अपने वित्तीय लक्ष्यों को प्राप्त कर सकें। इसमें यह ट्रैक करना शामिल है कि आपका पैसा कहाँ जा रहा है और यह सुनिश्चित करना कि आप अपनी आय से अधिक खर्च न करें।',
    'sip': 'SIP (Systematic Investment Plan) म्यूचुअल फंड में निवेश करने का एक तरीका है जहाँ आप नियमित अंतराल पर (जैसे मासिक) एक निश्चित राशि का निवेश करते हैं। यह छोटे अमाउंट से निवेश शुरू करने और बाजार के उतार-चढ़ाव को मैनेज करने में मदद करता है।',
  };

  void _getExplanation() {
    FocusScope.of(context).unfocus(); // Dismiss keyboard
    final String term = _termController.text.trim().toLowerCase();

    if (term.isEmpty) {
      _showSnackBar('Please type a financial term to explain.', error: true);
      setState(() {
        _explanation = '';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _explanation = '';
    });

    // Simulate AI processing delay
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
        _explanation = _mockExplanations[term] ?? 'क्षमा करें, मुझे इस शब्द के बारे में जानकारी नहीं मिल पाई। कृपया कोई और शब्द आज़माएँ।'; // Default message in Hindi
        _showSnackBar(_explanation.contains('क्षमा करें') ? 'No explanation found.' : 'Explanation ready!');
      });
    });
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
    _termController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          Text(
            'Understand Financial Terms',
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
                    controller: _termController,
                    decoration: InputDecoration(
                      labelText: 'Ask me about a money term!',
                      hintText: 'e.g., What is interest?',
                      prefixIcon: const Icon(Icons.help_outline_rounded, color: AppTheme.primaryColor),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.mic_rounded, color: AppTheme.primaryColor),
                        onPressed: () {
                          // Simulate voice input
                          _termController.text = 'What is interest?'; // Example voice input
                          _showSnackBar('Voice input simulated: "What is interest?"');
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: _isLoading ? null : _getExplanation,
                    icon: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                          )
                        : const Icon(Icons.question_answer_rounded),
                    label: Text(_isLoading ? 'Getting Answer...' : 'Get Answer'),
                  ),
                ],
              ),
            ),
          ),
          if (_explanation.isNotEmpty) ...[
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Explanation:',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const Divider(height: 20),
                    Text(
                      _explanation,
                      style: Theme.of(context).textTheme.bodyLarge,
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Simulating PDF download... (Backend to generate)'),
                                backgroundColor: AppTheme.primaryColor,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                margin: const EdgeInsets.all(10),
                              ),
                            );
                          },
                          icon: const Icon(Icons.picture_as_pdf_rounded),
                          label: const Text('Download PDF'),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                              ),
                              builder: (context) => Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                Icon(Icons.audiotrack_rounded, size: 40, color: AppTheme.primaryColor),
                                const SizedBox(height: 16),
                                Text(
                                  'Simulating Audio playback/download...\n(Backend to generate)',
                                  style: Theme.of(context).textTheme.bodyLarge,
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 24),
                                ElevatedButton.icon(
                                  onPressed: () => Navigator.pop(context),
                                  icon: const Icon(Icons.close_rounded),
                                  label: const Text('Close'),
                                ),
                                ],
                              ),
                              ),
                            );
                          },
                          icon: const Icon(Icons.audiotrack_rounded),
                          label: const Text('Play/Download Audio'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
          const SizedBox(height: 20),
          Text(
            'Knowledge is your greatest asset.',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
