enum Role { user, assiatant }

class MessagesModel {
  final Role role;
  final String content;
  const MessagesModel({required this.role, required this.content});

  Map<String, String> toMap() => {
        'role': role == Role.user ? 'user' : 'assistant',
        'content': content,
      };

  static List<Map<String, String>> listToMapList(List<MessagesModel> messages) {
    List<Map<String, String>> messagesMap = [];
    messages.forEach((message) {
      messagesMap.add(message.toMap());
    });
    return messagesMap;
  }
}
