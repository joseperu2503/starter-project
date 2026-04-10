import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:newsly/features/articles/data/models/article_model.dart';
import 'package:newsly/features/articles/domain/entities/article_entity.dart';

class FirestoreArticleDataSource {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  FirestoreArticleDataSource(this._firestore, this._storage);

  Future<List<ArticleEntity>> getPublishedArticles() async {
    final snapshot = await _firestore
        .collection('articles')
        .where('isPublished', isEqualTo: true)
        .orderBy('publishedAt', descending: true)
        .get();

    return snapshot.docs.map(ArticleModel.fromFirestore).toList();
  }

  Future<List<ArticleEntity>> getMyArticles(String authorId) async {
    final snapshot = await _firestore
        .collection('articles')
        .where('authorId', isEqualTo: authorId)
        .orderBy('publishedAt', descending: true)
        .get();

    return snapshot.docs.map(ArticleModel.fromFirestore).toList();
  }

  Future<void> uploadArticle(ArticleEntity article, File thumbnail) async {
    final thumbnailURL = await _uploadThumbnail(article.id, thumbnail);
    final model = ArticleModel.fromEntity(article).copyWith(
      thumbnailURL: thumbnailURL,
      thumbnailPath: 'media/articles/${article.id}/thumbnail.jpg',
    );
    await _firestore.collection('articles').doc(article.id).set(model.toFirestore());
  }

  Future<void> updateArticle(ArticleEntity article, {File? newThumbnail}) async {
    String thumbnailURL = article.thumbnailURL;
    String thumbnailPath = article.thumbnailPath;

    if (newThumbnail != null) {
      thumbnailURL = await _uploadThumbnail(article.id, newThumbnail);
      thumbnailPath = 'media/articles/${article.id}/thumbnail.jpg';
    }

    final model = ArticleModel.fromEntity(article).copyWith(
      thumbnailURL: thumbnailURL,
      thumbnailPath: thumbnailPath,
    );
    await _firestore.collection('articles').doc(article.id).update(model.toFirestore());
  }

  Future<void> deleteArticle(String articleId, String thumbnailPath) async {
    await Future.wait([
      _firestore.collection('articles').doc(articleId).delete(),
      _storage.ref(thumbnailPath).delete(),
    ]);
  }

  Future<String> _uploadThumbnail(String articleId, File file) async {
    final ref = _storage.ref('media/articles/$articleId/thumbnail.jpg');
    await ref.putFile(file);
    return ref.getDownloadURL();
  }
}
