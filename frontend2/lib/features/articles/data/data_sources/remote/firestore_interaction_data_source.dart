import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:newsly/features/articles/domain/entities/comment_entity.dart';
import 'package:uuid/uuid.dart';

class FirestoreInteractionDataSource {
  final FirebaseFirestore _firestore;

  FirestoreInteractionDataSource(this._firestore);

  // ── Likes ──────────────────────────────────────────────────────────────────

  Future<bool> isLiked(String articleId, String userId) async {
    if (userId.isEmpty) return false;
    final doc = await _firestore
        .collection('articles')
        .doc(articleId)
        .collection('likes')
        .doc(userId)
        .get();
    return doc.exists;
  }

  Future<int> getLikesCount(String articleId) async {
    final snap = await _firestore
        .collection('articles')
        .doc(articleId)
        .collection('likes')
        .count()
        .get();
    return snap.count ?? 0;
  }

  Future<void> likeArticle(String articleId, String userId) async {
    await _firestore
        .collection('articles')
        .doc(articleId)
        .collection('likes')
        .doc(userId)
        .set({'userId': userId, 'createdAt': FieldValue.serverTimestamp()});
  }

  Future<void> unlikeArticle(String articleId, String userId) async {
    await _firestore
        .collection('articles')
        .doc(articleId)
        .collection('likes')
        .doc(userId)
        .delete();
  }

  // ── Comments ───────────────────────────────────────────────────────────────

  Future<List<CommentEntity>> getComments(String articleId) async {
    final snap = await _firestore
        .collection('articles')
        .doc(articleId)
        .collection('comments')
        .orderBy('createdAt', descending: false)
        .get();

    return snap.docs.map((doc) {
      final data = doc.data();
      return CommentEntity(
        id: doc.id,
        articleId: articleId,
        authorId: data['authorId'] as String,
        author: data['author'] as String,
        content: data['content'] as String,
        createdAt: (data['createdAt'] as Timestamp).toDate(),
      );
    }).toList();
  }

  Future<void> addComment({
    required String articleId,
    required String authorId,
    required String author,
    required String content,
  }) async {
    final id = const Uuid().v4();
    await _firestore
        .collection('articles')
        .doc(articleId)
        .collection('comments')
        .doc(id)
        .set({
      'authorId': authorId,
      'author': author,
      'content': content,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteComment(String articleId, String commentId) async {
    await _firestore
        .collection('articles')
        .doc(articleId)
        .collection('comments')
        .doc(commentId)
        .delete();
  }
}
