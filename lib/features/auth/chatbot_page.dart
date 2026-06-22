import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:http/http.dart' as http;

class ChatbotPage extends StatefulWidget {
  const ChatbotPage({super.key});

  @override
  State<ChatbotPage> createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController       _scrollController  = ScrollController();

  final List<Map<String, dynamic>> _messages = [
    {
      'text': '👋 مرحباً بك في مكتبة الجامعة الهاشمية!\n\nأنا مساعدك الذكي، يسعدني مساعدتك في أي استفسار.\n\n🕐 ساعات الدوام:\nالأحد – الخميس\n٩:٠٠ ص حتى ٤:٠٠ م\n\nكيف يمكنني مساعدتك اليوم؟',
      'isBot': true,
    },
  ];

  bool _isTyping = false;

  // ─── System Prompt لأمين المكتبة الذكي ───
  static const String _systemPrompt = '''
أنت مساعد ذكي لمكتبة الجامعة الهاشمية في الأردن. مهمتك مساعدة الطلاب في استفساراتهم المتعلقة بالمكتبة.

معلومات المكتبة:
- اسم المكتبة: مكتبة الجامعة الهاشمية (The Academic Curator)
- أيام الدوام: الأحد إلى الخميس
- ساعات الدوام: من الساعة 9:00 صباحاً حتى 4:00 مساءً
- العطل الأسبوعية: الجمعة والسبت

تعليمات مهمة:
- رد دائماً بلغة المستخدم (عربي أو إنجليزي)
- كن ودوداً ومفيداً
- إذا سأل عن أي شيء يتعلق بساعات المكتبة أو زيارتها، ذكّره بأوقات الدوام دائماً
- إذا سأل عن خدمات المكتبة، اذكر: استعارة الكتب، حجز القاعات، اقتراح شراء كتب، الاطلاع على الرسائل العلمية
- إذا كان السؤال خارج نطاق المكتبة، اعتذر بلطف وأعد توجيهه لخدمات المكتبة
- استخدم إيموجي مناسبة لتجعل الرد أكثر تفاعلية
- الردود تكون مختصرة وواضحة
''';

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
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
    final text = _messageController.text.trim();
    if (text.isEmpty || _isTyping) return;

    setState(() {
      _messages.add({'text': text, 'isBot': false});
      _messageController.clear();
      _isTyping = true;
    });
    _scrollToBottom();

    try {
      // بناء تاريخ المحادثة لإرساله للـ API
      final conversationHistory = _messages
          .where((m) => m['text'] != _messages.first['text']) // استثناء رسالة الترحيب الأولى
          .map((m) => {
                'role': (m['isBot'] as bool) ? 'assistant' : 'user',
                'content': m['text'] as String,
              })
          .toList();

      final response = await http.post(
        Uri.parse('https://api.anthropic.com/v1/messages'),
        headers: {
          'Content-Type':      'application/json',
          'anthropic-version': '2023-06-01',
        },
        body: jsonEncode({
          'model':      'claude-sonnet-4-6',
          'max_tokens': 1024,
          'system':     _systemPrompt,
          'messages':   conversationHistory,
        }),
      );

      if (response.statusCode == 200) {
        final data    = jsonDecode(response.body);
        final botReply = (data['content'] as List).first['text'] as String;

        if (mounted) {
          setState(() {
            _messages.add({'text': botReply, 'isBot': true});
            _isTyping = false;
          });
          _scrollToBottom();
        }
      } else {
        _addErrorMessage();
      }
    } catch (e) {
      _addErrorMessage();
    }
  }

  void _addErrorMessage() {
    if (mounted) {
      setState(() {
        _messages.add({
          'text': '⚠️ عذراً، حدث خطأ في الاتصال. يرجى المحاولة مرة أخرى.\n\n📞 يمكنك التواصل مع المكتبة مباشرة خلال أوقات الدوام:\nالأحد – الخميس | ٩ص – ٤م',
          'isBot': true,
        });
        _isTyping = false;
      });
      _scrollToBottom();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded,
              color: Theme.of(context).colorScheme.onSurface),
          onPressed: () => context.pop(),
        ),
        title: Row(mainAxisSize: MainAxisSize.min, children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
                color: const Color(0xFFCC3333),
                borderRadius: BorderRadius.circular(10)),
            child: const Icon(Icons.smart_toy_outlined, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 10),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Library Assistant'.tr(),
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                    fontSize: 15)),
            Row(children: [
              Container(
                  width: 7, height: 7,
                  decoration: const BoxDecoration(
                      color: Colors.green, shape: BoxShape.circle)),
              const SizedBox(width: 4),
              Text('Online'.tr(),
                  style: const TextStyle(color: Colors.green, fontSize: 11)),
            ]),
          ]),
        ]),
        centerTitle: true,
        // زر مسح المحادثة
        actions: [
          IconButton(
            icon: Icon(Icons.refresh_rounded,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6)),
            tooltip: 'Clear chat',
            onPressed: () {
              setState(() {
                _messages.clear();
                _messages.add({
                  'text': '👋 مرحباً بك في مكتبة الجامعة الهاشمية!\n\nأنا مساعدك الذكي، يسعدني مساعدتك في أي استفسار.\n\n🕐 ساعات الدوام:\nالأحد – الخميس\n٩:٠٠ ص حتى ٤:٠٠ م\n\nكيف يمكنني مساعدتك اليوم؟',
                  'isBot': true,
                });
              });
            },
          ),
        ],
      ),
      body: Column(children: [
        // ─── قائمة الرسائل ───
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            itemCount: _messages.length + (_isTyping ? 1 : 0),
            itemBuilder: (context, index) {
              // مؤشر الكتابة
              if (_isTyping && index == _messages.length) {
                return _buildTypingIndicator();
              }

              final msg   = _messages[index];
              final isBot = msg['isBot'] as bool;

              return Align(
                alignment: isBot ? Alignment.centerLeft : Alignment.centerRight,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.78),
                  decoration: BoxDecoration(
                    color: isBot
                        ? Theme.of(context).colorScheme.surfaceContainerHighest
                        : const Color(0xFFCC3333),
                    borderRadius: BorderRadius.only(
                      topLeft:     const Radius.circular(16),
                      topRight:    const Radius.circular(16),
                      bottomLeft:  Radius.circular(isBot ? 4 : 16),
                      bottomRight: Radius.circular(isBot ? 16 : 4),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      )
                    ],
                  ),
                  child: Text(
                    msg['text'] as String,
                    style: TextStyle(
                        fontSize: 14,
                        height: 1.5,
                        color: isBot
                            ? Theme.of(context).colorScheme.onSurface
                            : Colors.white),
                  ),
                ),
              );
            },
          ),
        ),

        // ─── أسئلة مقترحة (تظهر بس لو المحادثة جديدة) ───
        if (_messages.length == 1) _buildSuggestedQuestions(),

        // ─── حقل الإدخال ───
        Container(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            border: Border(
                top: BorderSide(
                    color: Theme.of(context).colorScheme.outlineVariant,
                    width: 0.8)),
          ),
          child: Row(children: [
            Expanded(
              child: TextField(
                controller: _messageController,
                enabled: !_isTyping,
                maxLines: null,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _sendMessage(),
                decoration: InputDecoration(
                  hintText: _isTyping ? 'الذكاء الاصطناعي يكتب...' : 'اكتب رسالتك...'.tr(),
                  hintStyle: TextStyle(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.4),
                      fontSize: 13),
                  filled: true,
                  fillColor:
                      Theme.of(context).colorScheme.surfaceContainerHighest,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide.none),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 18, vertical: 12),
                ),
              ),
            ),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: _isTyping ? null : _sendMessage,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 46, height: 46,
                decoration: BoxDecoration(
                  color: _isTyping
                      ? Colors.grey.shade300
                      : const Color(0xFFCC3333),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _isTyping ? Icons.hourglass_top_rounded : Icons.send_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ]),
        ),
      ]),
    );
  }

  // مؤشر الكتابة (ثلاث نقاط)
  Widget _buildTypingIndicator() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: const BorderRadius.only(
            topLeft:     Radius.circular(16),
            topRight:    Radius.circular(16),
            bottomRight: Radius.circular(16),
            bottomLeft:  Radius.circular(4),
          ),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          _dot(delay: 0),
          const SizedBox(width: 4),
          _dot(delay: 200),
          const SizedBox(width: 4),
          _dot(delay: 400),
        ]),
      ),
    );
  }

  Widget _dot({required int delay}) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 600 + delay),
      builder: (ctx, v, _) => AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 8, height: 8,
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.4 + v * 0.6),
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  // ─── الأسئلة المقترحة مع أجوبتها الجاهزة ───
  static const List<Map<String, String>> _quickReplies = [
    {
      'question': '📅 متى تفتح المكتبة؟',
      'answer':
          '🕐 ساعات دوام المكتبة:\n\n📆 الأيام: الأحد – الخميس\n⏰ الوقت: ٩:٠٠ ص – ٤:٠٠ م\n\n🚫 مغلقة: الجمعة والسبت\n\nيسعدنا استقبالك في أي وقت خلال ساعات الدوام! 😊',
    },
    {
      'question': '📚 كيف أستعير كتاب؟',
      'answer':
          '📚 خطوات استعارة كتاب:\n\n1️⃣ ابحث عن الكتاب من صفحة "الكتب" بالتطبيق\n2️⃣ اضغط على الكتاب واختر "استعارة"\n3️⃣ سيصل طلبك لأمين المكتبة للمراجعة\n4️⃣ بعد الموافقة، تفضّل للمكتبة لاستلام الكتاب\n\n🕐 تذكّر: الدوام الأحد–الخميس ٩ص–٤م',
    },
    {
      'question': '🏛️ هل يمكنني حجز قاعة؟',
      'answer':
          '🏛️ نعم! يمكنك حجز قاعة دراسية بسهولة:\n\n1️⃣ اذهب لقسم "الخدمات" بالتطبيق\n2️⃣ اختر "حجز قاعة"\n3️⃣ حدد اليوم والوقت المناسب\n4️⃣ انتظر تأكيد أمين المكتبة\n\n📌 القاعات متاحة:\nالأحد–الخميس | ٩:٠٠ ص – ٤:٠٠ م',
    },
  ];

  // إرسال السؤال والجواب الجاهز مباشرة بدون API
  void _sendQuickReply(String question, String answer) {
    if (_isTyping) return;
    setState(() {
      _messages.add({'text': question, 'isBot': false});
      _messages.add({'text': answer,   'isBot': true});
    });
    _scrollToBottom();
  }

  Widget _buildSuggestedQuestions() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('اقتراحات سريعة:',
              style: TextStyle(
                  fontSize: 11,
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5))),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: _quickReplies.map((item) {
              return GestureDetector(
                onTap: () => _sendQuickReply(item['question']!, item['answer']!),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFCC3333).withOpacity(0.08),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: const Color(0xFFCC3333).withOpacity(0.3)),
                  ),
                  child: Text(item['question']!,
                      style: const TextStyle(
                          fontSize: 12, color: Color(0xFFCC3333))),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}