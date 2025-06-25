// lib/pages/ask_sakhi_chatbot_page.dart

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sakhi/theme/save_theme.dart';

class AskSakhiChatbotPage extends StatefulWidget {
  const AskSakhiChatbotPage({super.key});

  @override
  State<AskSakhiChatbotPage> createState() => _AskSakhiChatbotPageState();
}

class _AskSakhiChatbotPageState extends State<AskSakhiChatbotPage> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, String>> _messages = [];
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _addBotMessage("नमस्ते! मैं सखी हूँ। मैं आपकी वित्तीय जानकारी में कैसे मदद कर सकती हूँ?"); 
  }

  void _addBotMessage(String text) {
    setState(() {
      _messages.add({'sender': 'bot', 'text': text});
    });
  }

  void _addUserMessage(String text) {
    setState(() {
      _messages.add({'sender': 'user', 'text': text});
    });
  }

  void _handleSendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    _addUserMessage(text);
    _messageController.clear();
    setState(() {
      _isTyping = true;
    });

    // Simulate AI response
    await Future.delayed(const Duration(seconds: 2));

    String botResponse = 'माफ़ करना, मैं अभी केवल कुछ वित्तीय विषयों पर ही बात कर सकती हूँ। आप मुझसे ब्याज, लोन, यूपीआई, या बजटिंग के बारे में पूछ सकते हैं।'; // Sorry, I can only talk about a few financial topics right now. You can ask me about interest, loan, UPI, or budgeting.

    if (text.toLowerCase().contains('ब्याज') || text.toLowerCase().contains('interest')) {
      botResponse = 'ब्याज वह अतिरिक्त पैसा होता है जो आप उधार ली गई राशि पर चुकाते हैं, या वह पैसा जो आप अपनी बचत पर कमाते हैं।'; // Interest is the extra money you pay on borrowed amount, or the money you earn on your savings.
    } else if (text.toLowerCase().contains('लोन') || text.toLowerCase().contains('loan')) {
      botResponse = 'लोन एक निश्चित अवधि के लिए उधार ली गई राशि होती है, जिसे ब्याज के साथ वापस चुकाया जाता है।'; // A loan is an amount borrowed for a fixed period, which is paid back with interest.
    } else if (text.toLowerCase().contains('यूपीआई') || text.toLowerCase().contains('upi')) {
      botResponse = 'यूपीआई भारत में एक इंस्टेंट पेमेंट सिस्टम है जो आपको मोबाइल नंबर का उपयोग करके तुरंत पैसे भेजने और प्राप्त करने की सुविधा देता है।'; // UPI is an instant payment system in India that allows you to send and receive money instantly using a mobile number.
    } else if (text.toLowerCase().contains('बजटिंग') || text.toLowerCase().contains('budgeting')) {
      botResponse = 'बजटिंग अपनी आय और खर्चों की योजना बनाने की प्रक्रिया है ताकि आप अपने वित्तीय लक्ष्यों को प्राप्त कर सकें।'; // Budgeting is the process of planning your income and expenses to achieve your financial goals.
    } else if (text.toLowerCase().contains('नमस्ते') || text.toLowerCase().contains('hello') || text.toLowerCase().contains('hi')) {
      botResponse = 'नमस्ते! मैं आपकी कैसे मदद कर सकती हूँ?'; // Hello! How can I help you?
    }

    _addBotMessage(botResponse);
    setState(() {
      _isTyping = false;
    });
  }

  void _simulateVoiceInput() {
    _messageController.text = 'ब्याज क्या है?'; // Example voice input in Hindi
    _showSnackBar('Voice input simulated: "ब्याज क्या है?"');
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.primaryColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(10),
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold( // Wrap with Scaffold to have an AppBar
      appBar: AppBar(
        title: const Text('Sakhi Bot'), // Your desired header title
        centerTitle: true,
        backgroundColor: AppTheme.primaryColor, // Match your theme's primary color
        foregroundColor: Colors.white, // White text for the title
        elevation: 4, // Add a subtle shadow
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final bool isUser = message['sender'] == 'user';
                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                    margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    decoration: BoxDecoration(
                      color: isUser ? AppTheme.primaryColor.withOpacity(0.8) : AppTheme.accentColor.withOpacity(0.2),
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(16),
                        topRight: const Radius.circular(16),
                        bottomLeft: isUser ? const Radius.circular(16) : const Radius.circular(4),
                        bottomRight: isUser ? const Radius.circular(4) : const Radius.circular(16),
                      ),
                    ),
                    child: Text(
                      message['text']!,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: isUser ? Colors.white : AppTheme.textColor,
                          ),
                    ),
                  ),
                );
              },
            ),
          ),
          if (_isTyping)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Sakhi is typing...',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(fontStyle: FontStyle.italic),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type your question...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: AppTheme.cardColor,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    ),
                    onSubmitted: (_) => _handleSendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: AppTheme.primaryColor,
                  radius: 24,
                  child: IconButton(
                    icon: const Icon(Icons.mic_rounded, color: Colors.white),
                    onPressed: _simulateVoiceInput,
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: AppTheme.primaryColor,
                  radius: 24,
                  child: IconButton(
                    icon: const Icon(Icons.send_rounded, color: Colors.white),
                    onPressed: _handleSendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}