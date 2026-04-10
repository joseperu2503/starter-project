import 'dart:io';

import 'package:newsly/features/articles/data/data_sources/local/app_database.dart';
import 'package:newsly/features/articles/data/data_sources/remote/firestore_article_data_source.dart';
import 'package:newsly/features/articles/domain/entities/article_entity.dart';
import 'package:newsly/features/articles/domain/repository/article_repository.dart';

class ArticleRepositoryImpl implements ArticleRepository {
  final FirestoreArticleDataSource _remote;
  final AppDatabase _local;

  ArticleRepositoryImpl(this._remote, this._local);

  @override
  Future<List<ArticleEntity>> getPublishedArticles() {
    return _remote.getPublishedArticles();
  }

  @override
  Future<List<ArticleEntity>> getMyArticles(String authorId) {
    return _remote.getMyArticles(authorId);
  }

  @override
  Future<void> uploadArticle(ArticleEntity article, File thumbnail) {
    return _remote.uploadArticle(article, thumbnail);
  }

  @override
  Future<void> updateArticle(ArticleEntity article, {File? newThumbnail}) {
    return _remote.updateArticle(article, newThumbnail: newThumbnail);
  }

  @override
  Future<void> deleteArticle(String articleId, String thumbnailPath) {
    return _remote.deleteArticle(articleId, thumbnailPath);
  }

  @override
  Future<List<ArticleEntity>> getSavedArticles() {
    return _local.getAllSavedArticles();
  }

  @override
  Future<void> saveArticle(ArticleEntity article) {
    return _local.insertArticle(article);
  }

  @override
  Future<void> removeSavedArticle(String articleId) {
    return _local.deleteArticle(articleId);
  }
}
