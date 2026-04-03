enum MessageType { text, image }
enum MessageStatus { normal, deleted, recalled }

class MessageModel {
  final String id;
  final String content;
  final bool isMine;
  final DateTime time;
  final MessageType type;
  final MessageStatus status;
  final bool isEdited;

  const MessageModel({
    required this.id,
    required this.content,
    required this.isMine,
    required this.time,
    this.type = MessageType.text,
    this.status = MessageStatus.normal,
    this.isEdited = false,
  });

  MessageModel copyWith({
    String? content,
    MessageStatus? status,
    bool? isEdited,
  }) {
    return MessageModel(
      id: id,
      content: content ?? this.content,
      isMine: isMine,
      time: time,
      type: type,
      status: status ?? this.status,
      isEdited: isEdited ?? this.isEdited,
    );
  }
}
