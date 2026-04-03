class CommentModel {
  final String id;
  final String authorName;
  final String authorInitials;
  final int avatarColorValue;
  String content; // non-final để có thể chỉnh sửa
  final String timeAgo;
  final bool isOwner;
  final bool isPostOwner;
  int likes;
  bool liked;
  final List<CommentModel> replies;

  CommentModel({
    required this.id,
    required this.authorName,
    required this.authorInitials,
    required this.avatarColorValue,
    required this.content,
    required this.timeAgo,
    this.isOwner = false,
    this.isPostOwner = false,
    this.likes = 0,
    this.liked = false,
    List<CommentModel>? replies,
  }) : replies = replies ?? [];
}
