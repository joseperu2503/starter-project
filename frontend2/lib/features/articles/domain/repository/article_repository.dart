import 'dart:io';

import 'package:newsly/features/articles/domain/entities/article_entity.dart';

abstract class ArticleRepository {
  // Firestore — remote
  Future<List<ArticleEntity>> getPublishedArticles();
  Future<List<ArticleEntity>> getMyArticles(String authorId);
  Future<void> uploadArticle(ArticleEntity article, File thumbnail);
  Future<void> updateArticle(ArticleEntity article, {File? newThumbnail});
  Future<void> deleteArticle(String articleId, String thumbnailPath);

  // Drift — local (saved/bookmarked articles)
  Future<List<ArticleEntity>> getSavedArticles();
  Future<void> saveArticle(ArticleEntity article);
  Future<void> removeSavedArticle(String articleId);
}
