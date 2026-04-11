import 'package:equatable/equatable.dart';

class ArticleEntity extends Equatable {
  final String id;
  final String authorId;
  final String author;
  final String title;
  final String description;
  final String content;
  final String thumbnailPath;
  final String thumbnailURL;
  final String? category;
  final DateTime publishedAt;
  final DateTime updatedAt;
  final bool isPublished;
  final bool isPremium;

  const ArticleEntity({
    required this.id,
    required this.authorId,
    required this.author,
    required this.title,
    required this.description,
    required this.content,
    required this.thumbnailPath,
    required this.thumbnailURL,
    this.category,
    required this.publishedAt,
    required this.updatedAt,
    required this.isPublished,
    this.isPremium = false,
  });

  @override
  List<Object?> get props => [
        id,
        authorId,
        author,
        title,
        description,
        content,
        thumbnailPath,
        thumbnailURL,
        category,
        publishedAt,
        updatedAt,
        isPublished,
        isPremium,
      ];
}
