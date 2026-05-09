import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';

class ChatbotPage extends StatefulWidget {
  const ChatbotPage({super.key});

  @override
  State<ChatbotPage> createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, dynamic>> _messages = [
    {'text': 'Hello! I\'m the library assistant. How can I help you today?', 'isBot': true},
  ];

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add({'text': text, 'isBot': false});
      _messageController.clear();
    });
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() {
          _messages.add({'text': 'Thank you for your message. A librarian will respond shortly.', 'isBot': true});
        });
        Future.delayed(const Duration(milliseconds: 100), () {
          _scrollController.animateTo(_scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
        });
      }
    });
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
            width: 32, height: 32,
            decoration: BoxDecoration(color: const Color(0xFFCC3333), borderRadius: BorderRadius.circular(8)),
            child: const Icon(Icons.smart_toy_outlined, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 10),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Library Assistant'.tr(), style: TextStyle(color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.bold, fontSize: 15)),
            Text('Online'.tr(), style: const TextStyle(color: Colors.green, fontSize: 11)),
          ]),
        ]),
        centerTitle: true,
      ),
      body: Column(children: [
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(16),
            itemCount: _messages.length,
            itemBuilder: (context, index) {
              final msg = _messages[index];
              final isBot = msg['isBot'] as bool;
              return Align(
                alignment: isBot ? Alignment.centerLeft : Alignment.centerRight,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                  decoration: BoxDecoration(
                    color: isBot
                        ? Theme.of(context).colorScheme.surfaceContainerHighest
                        : const Color(0xFFCC3333),
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(14),
                      topRight: const Radius.circular(14),
                      bottomLeft: Radius.circular(isBot ? 4 : 14),
                      bottomRight: Radius.circular(isBot ? 14 : 4),
                    ),
                  ),
                  child: Text(msg['text']!,
                    style: TextStyle(fontSize: 14, height: 1.4,
                      color: isBot ? Theme.of(context).colorScheme.onSurface : Colors.white)),
                ),
              );
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            border: Border(top: BorderSide(color: Theme.of(context).colorScheme.outlineVariant, width: 0.8)),
          ),
          child: Row(children: [
            Expanded(
              child: TextField(
                controller: _messageController,
                decoration: InputDecoration(
                  hintText: 'Type a message...'.tr(),
                  hintStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4)),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: _sendMessage,
              child: Container(
                width: 44, height: 44,
                decoration: BoxDecoration(color: const Color(0xFFCC3333), shape: BoxShape.circle),
                child: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
              ),
            ),
          ]),
        ),
      ]),
    );
  }
}