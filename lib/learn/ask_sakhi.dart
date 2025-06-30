import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sakhi/services/api_service.dart';
import 'package:sakhi/theme/save_theme.dart';

class AskSakhiChatbotPage extends StatefulWidget {
  const AskSakhiChatbotPage({super.key});

  @override
  State<AskSakhiChatbotPage> createState() => _AskSakhiChatbotPageState();
}

class _AskSakhiChatbotPageState extends State<AskSakhiChatbotPage> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, String>> _messages = [];
  final ApiService _apiService = ApiService();
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

    try {
      final response = await _apiService.post('/chat/', {'message': text});
      final botResponse = response['reply'] ?? 'माफ़ कीजिए, मैं आपकी सहायता नहीं कर पाई।';
      _addBotMessage(botResponse);
    } catch (e) {
      print('Chatbot error: $e');
      _addBotMessage('कुछ गड़बड़ हो गई है। कृपया बाद में प्रयास करें।');
    }

    setState(() {
      _isTyping = false;
    });
  }

  void _simulateVoiceInput() {
    _messageController.text = 'ब्याज क्या है?'; // Simulated voice input
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sakhi Bot'),
        centerTitle: true,
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 4,
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
                      color: isUser
                          ? AppTheme.primaryColor.withOpacity(0.8)
                          : AppTheme.accentColor.withOpacity(0.2),
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
