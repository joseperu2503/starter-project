import 'dart:io';

import 'package:newsly/features/articles/domain/entities/article_entity.dart';

abstract class RemoteArticleEvent {
  const RemoteArticleEvent();
}

class GetPublishedArticlesEvent extends RemoteArticleEvent {
  const GetPublishedArticlesEvent();
}

class GetMyArticlesEvent extends RemoteArticleEvent {
  final String authorId;
  const GetMyArticlesEvent(this.authorId);
}

class UploadArticleEvent extends RemoteArticleEvent {
  final ArticleEntity article;
  final File thumbnail;
  const UploadArticleEvent({required this.article, required this.thumbnail});
}

class UpdateArticleEvent extends RemoteArticleEvent {
  final ArticleEntity article;
  final File? newThumbnail;
  const UpdateArticleEvent({required this.article, this.newThumbnail});
}

class DeleteArticleEvent extends RemoteArticleEvent {
  final String articleId;
  final String thumbnailPath;
  const DeleteArticleEvent({required this.articleId, required this.thumbnailPath});
}
