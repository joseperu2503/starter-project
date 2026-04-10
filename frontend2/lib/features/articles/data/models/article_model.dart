import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:frontend2/features/articles/domain/entities/article_entity.dart';

class ArticleModel extends ArticleEntity {
  const ArticleModel({
    required super.id,
    required super.authorId,
    required super.author,
    required super.title,
    required super.description,
    required super.content,
    required super.thumbnailPath,
    required super.thumbnailURL,
    super.category,
    required super.publishedAt,
    required super.updatedAt,
    required super.isPublished,
  });

  factory ArticleModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ArticleModel(
      id: doc.id,
      authorId: data['authorId'] as String,
      author: data['author'] as String,
      title: data['title'] as String,
      description: data['description'] as String,
      content: data['content'] as String,
      thumbnailPath: data['thumbnailPath'] as String,
      thumbnailURL: data['thumbnailURL'] as String,
      category: data['category'] as String?,
      publishedAt: (data['publishedAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      isPublished: data['isPublished'] as bool,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'authorId': authorId,
      'author': author,
      'title': title,
      'description': description,
      'content': content,
      'thumbnailPath': thumbnailPath,
      'thumbnailURL': thumbnailURL,
      'category': category,
      'publishedAt': Timestamp.fromDate(publishedAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'isPublished': isPublished,
    };
  }

  factory ArticleModel.fromEntity(ArticleEntity entity) {
    return ArticleModel(
      id: entity.id,
      authorId: entity.authorId,
      author: entity.author,
      title: entity.title,
      description: entity.description,
      content: entity.content,
      thumbnailPath: entity.thumbnailPath,
      thumbnailURL: entity.thumbnailURL,
      category: entity.category,
      publishedAt: entity.publishedAt,
      updatedAt: entity.updatedAt,
      isPublished: entity.isPublished,
    );
  }

  ArticleModel copyWith({
    String? id,
    String? authorId,
    String? author,
    String? title,
    String? description,
    String? content,
    String? thumbnailPath,
    String? thumbnailURL,
    String? category,
    DateTime? publishedAt,
    DateTime? updatedAt,
    bool? isPublished,
  }) {
    return ArticleModel(
      id: id ?? this.id,
      authorId: authorId ?? this.authorId,
      author: author ?? this.author,
      title: title ?? this.title,
      description: description ?? this.description,
      content: content ?? this.content,
      thumbnailPath: thumbnailPath ?? this.thumbnailPath,
      thumbnailURL: thumbnailURL ?? this.thumbnailURL,
      category: category ?? this.category,
      publishedAt: publishedAt ?? this.publishedAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isPublished: isPublished ?? this.isPublished,
    );
  }
}
