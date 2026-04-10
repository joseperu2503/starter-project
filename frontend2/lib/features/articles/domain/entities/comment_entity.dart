class CommentEntity {
  final String id;
  final String articleId;
  final String authorId;
  final String author;
  final String content;
  final DateTime createdAt;

  const CommentEntity({
    required this.id,
    required this.articleId,
    required this.authorId,
    required this.author,
    required this.content,
    required this.createdAt,
  });
}
