class ConversationModel {
  final String id;
  final String name;
  final String? avatarUrl;
  final String lastMessage;
  final String time;
  final bool isOnline;
  final bool hasUnread;
  final bool isGroup;

  const ConversationModel({
    required this.id,
    required this.name,
    this.avatarUrl,
    required this.lastMessage,
    required this.time,
    this.isOnline = false,
    this.hasUnread = false,
    this.isGroup = false,
  });
}
