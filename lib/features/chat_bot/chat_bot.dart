import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:graduation_project/core/const/widgets.dart';

class CareerCoachScreen extends StatefulWidget {
  const CareerCoachScreen({super.key});

  @override
  State<CareerCoachScreen> createState() => _CareerCoachScreenState();
}

class _ChatMessage {
  final String text;
  final bool isUser;
  _ChatMessage({required this.text, required this.isUser});
}

class _ChatHistoryStore {
  static final List<_ChatMessage> messages = [];
}

class _CareerCoachScreenState extends State<CareerCoachScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<_ChatMessage> _messages = _ChatHistoryStore.messages;
  bool _isLoading = false;

  static const Color _primaryColor = Color(0xFF0052D4);

  // بيكتشف لو النص فيه حروف عربية عشان يحدد اتجاه الكتابة المناسب
  bool _isArabic(String text) {
    return RegExp(r'[\u0600-\u06FF]').hasMatch(text);
  }

  // إعداد الموديل (تأكد من وضع الـ API Key الخاص بك هنا من Google AI Studio)
  final model = GenerativeModel(
    model: 'gemini-flash-latest',
    apiKey: dotenv.env['GEMINI_API_KEY'] ?? '',
  );

  @override
  void initState() {
    super.initState();
    if (_messages.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        }
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage() async {
    final userText = _controller.text.trim();
    if (userText.isEmpty || _isLoading) return;

    setState(() {
      _messages.add(_ChatMessage(text: userText, isUser: true));
      _isLoading = true;
      _controller.clear();
    });
    _scrollToBottom();

    final prompt = """
أنت مساعد مهني خبير ومحترف لموقع توظيف. 
مهمتك مساعدة المستخدمين في الحصول على وظائف أحلامهم. 
قواعد الرد:
1. رد دائماً بنفس لغة سؤال المستخدم بالضبط: لو السؤال بالإنجليزية رد بالإنجليزية بالكامل، ولو السؤال بالعربية رد بالعربية بالكامل. لا تخلط بين اللغتين في نفس الرد أبداً.
2. كن إيجابياً ومحفزاً دائماً.
3. قدم نصائح عملية ومحددة (Actionable advice)، لا تعطي كلاماً إنشائياً.
4. إذا سأل المستخدم عن الـ CV، اطلب منه ذكر مهاراته أولاً.
5. اجعل الإجابة مختصرة ومرتبة في نقاط.

سؤال المستخدم هو: $userText
""";

    try {
      final response = await model.generateContent([Content.text(prompt)]);
      setState(() {
        _messages.add(_ChatMessage(
          text: response.text ?? "عذراً، لم أستطع الرد.",
          isUser: false,
        ));
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _messages.add(_ChatMessage(
          text: "حدث خطأ أثناء الاتصال بالمساعد. حاول مرة أخرى.",
          isUser: false,
        ));
        _isLoading = false;
      });
    }
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          "Chatbot AI",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: _primaryColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Expanded(
            child: _messages.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        "👋 Welcome to your Chatbot AI! I'm here to help you ",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey[600], fontSize: 15),
                      ),
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 16),
                    itemCount: _messages.length + (_isLoading ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == _messages.length) {
                        return _buildTypingIndicator();
                      }
                      return _buildMessageBubble(_messages[index]);
                    },
                  ),
          ),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(_ChatMessage message) {
    final isUser = message.isUser;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser) _buildAvatar(isUser: false),
          Flexible(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              decoration: BoxDecoration(
                color: isUser ? _primaryColor : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isUser ? 16 : 4),
                  bottomRight: Radius.circular(isUser ? 4 : 16),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: isUser
                  ? Text(
                      message.text,
                      textDirection: _isArabic(message.text)
                          ? TextDirection.rtl
                          : TextDirection.ltr,
                      textAlign: _isArabic(message.text)
                          ? TextAlign.right
                          : TextAlign.left,
                      style:
                          const TextStyle(color: Colors.white, fontSize: 14.5),
                    )
                  : Directionality(
                      textDirection: _isArabic(message.text)
                          ? TextDirection.rtl
                          : TextDirection.ltr,
                      child: MarkdownBody(
                        data: message.text,
                        styleSheet: MarkdownStyleSheet(
                          p: const TextStyle(
                              color: Colors.black87,
                              fontSize: 14.5,
                              height: 1.4),
                          strong: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 14.5),
                          listBullet: const TextStyle(
                              color: Colors.black87, fontSize: 14.5),
                        ),
                      ),
                    ),
            ),
          ),
          if (isUser) _buildAvatar(isUser: true),
        ],
      ),
    );
  }

  Widget _buildAvatar({required bool isUser}) {
    return CircleAvatar(
      radius: 14,
      backgroundColor: isUser
          ? _primaryColor.withOpacity(0.15)
          : Colors.blueGrey.withOpacity(0.15),
      child: Icon(
        isUser ? Icons.person : Icons.smart_toy,
        size: 16,
        color: isUser ? _primaryColor : Colors.blueGrey,
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildAvatar(isUser: false),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const SizedBox(
              width: 34,
              height: 12,
              child: _TypingDots(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: TextField(
                  controller: _controller,
                  minLines: 1,
                  maxLines: 4,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => _sendMessage(),
                  decoration: const InputDecoration(
                    hintText: "Type your question...",
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              decoration: const BoxDecoration(
                color: _primaryColor,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: _isLoading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: loading,
                      )
                    : const Icon(Icons.send, color: Colors.white, size: 20),
                onPressed: _isLoading ? null : _sendMessage,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// نقط متحركة بسيطة لمؤشر "بيكتب..."
class _TypingDots extends StatefulWidget {
  const _TypingDots();

  @override
  State<_TypingDots> createState() => _TypingDotsState();
}

class _TypingDotsState extends State<_TypingDots>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) {
            final delay = i * 0.2;
            final t = ((_controller.value - delay) % 1.0).clamp(0.0, 1.0);
            final scale = 0.5 + 0.5 * (1 - (t - 0.5).abs() * 2).clamp(0.0, 1.0);
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Transform.scale(
                scale: scale,
                child: Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: Colors.blueGrey,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
