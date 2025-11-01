import 'package:caremixer/ui/chat/models/chat_message.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatState {
  final List<ChatMessage> messages;
  final bool isTyping;

  ChatState({
    required this.messages,
    this.isTyping = false,
  });

  ChatState copyWith({
    List<ChatMessage>? messages,
    bool? isTyping,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      isTyping: isTyping ?? this.isTyping,
    );
  }
}

class ChatNotifier extends StateNotifier<ChatState> {
  ChatNotifier()
      : super(ChatState(
          messages: [
            ChatMessage.bot('Hello! How can I help you today?'),
          ],
        ));

  void sendMessage(String text) {
    if (text.trim().isEmpty) return;

    final userMessage = ChatMessage.user(text);
    state = state.copyWith(
      messages: [...state.messages, userMessage],
    );

    state = state.copyWith(isTyping: true);

    Future.delayed(const Duration(milliseconds: 1500), () {
      final botResponse = _generateBotResponse(text);
      final botMessage = ChatMessage.bot(botResponse);

      state = state.copyWith(
        messages: [...state.messages, botMessage],
        isTyping: false,
      );
    });
  }

  String _generateBotResponse(String userMessage) {
    final lowerMessage = userMessage.toLowerCase();

    if (lowerMessage.contains('hello') || lowerMessage.contains('hi')) {
      return 'Hello! Nice to meet you! 👋';
    } else if (lowerMessage.contains('how are you')) {
      return 'I\'m doing great, thank you for asking! How can I assist you?';
    } else if (lowerMessage.contains('pokemon')) {
      return 'I see you\'re interested in Pokemon! Check out the Pokemon tab to explore more! 🎮';
    } else if (lowerMessage.contains('timeline')) {
      return 'You can view your timeline in the Timeline tab. It shows all your recent activities! 📅';
    } else if (lowerMessage.contains('help')) {
      return 'I\'m here to help! You can ask me about Pokemon, Timeline, or anything else! 💡';
    } else if (lowerMessage.contains('bye') || lowerMessage.contains('goodbye')) {
      return 'Goodbye! Have a great day! 👋';
    } else {
      return 'That\'s interesting! Tell me more about that. 🤔';
    }
  }
}

final chatProvider = StateNotifierProvider<ChatNotifier, ChatState>((ref) {
  return ChatNotifier();
});

