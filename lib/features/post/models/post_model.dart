class PostData {
  final String? id;
  final String authorName;
  final String authorInitials;
  final int avatarColorValue;
  final String? badge;
  final int? badgeColorValue;
  final String role;
  final String timeAgo;
  final String title;
  final String content;
  final int likes;
  final int comments;
  final int shares;
  final String? emotion;
  final List<String> taggedUsers;
  final String? imagePath;
  final String? audience;

  const PostData({
    this.id,
    required this.authorName,
    required this.authorInitials,
    required this.avatarColorValue,
    this.badge,
    this.badgeColorValue,
    required this.role,
    required this.timeAgo,
    required this.title,
    required this.content,
    this.likes = 0,
    this.comments = 0,
    this.shares = 0,
    this.emotion,
    this.taggedUsers = const [],
    this.imagePath,
    this.audience,
  });
}
