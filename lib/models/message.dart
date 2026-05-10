enum MessageSender { user, bot }

class ChatMessage {
  final String text;
  final MessageSender sender;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.sender,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'sender': sender.index, // Store enum as index
      'timestamp': timestamp,
    };
  }

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      text: map['text'] ?? '',
      sender: MessageSender.values[map['sender'] ?? 0],
      timestamp: (map['timestamp'] as dynamic).toDate(),
    );
  }
}