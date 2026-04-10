import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class SocialRemoteDataSource {
  final FirebaseFirestore _firestore;
  final FirebaseMessaging _messaging;

  SocialRemoteDataSource(this._firestore, this._messaging);

  /// Saves or updates the FCM token for the current user in Firestore.
  Future<void> saveUserToken(String uid, String displayName) async {
    final token = await _messaging.getToken();
    if (token == null) return;
    await _firestore.collection('users').doc(uid).set({
      'uid': uid,
      'displayName': displayName,
      'fcmToken': token,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  /// Follow an author.
  Future<void> followUser(String followerId, String followingId) async {
    final id = '${followerId}_$followingId';
    await _firestore.collection('follows').doc(id).set({
      'followerId': followerId,
      'followingId': followingId,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  /// Unfollow an author.
  Future<void> unfollowUser(String followerId, String followingId) async {
    final id = '${followerId}_$followingId';
    await _firestore.collection('follows').doc(id).delete();
  }

  /// Check if [followerId] follows [followingId].
  Future<bool> isFollowing(String followerId, String followingId) async {
    if (followerId.isEmpty) return false;
    final id = '${followerId}_$followingId';
    final doc = await _firestore.collection('follows').doc(id).get();
    return doc.exists;
  }

  /// Get follower count for [userId].
  Future<int> getFollowerCount(String userId) async {
    final snap = await _firestore
        .collection('follows')
        .where('followingId', isEqualTo: userId)
        .count()
        .get();
    return snap.count ?? 0;
  }
}
