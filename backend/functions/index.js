const { onDocumentCreated } = require('firebase-functions/v2/firestore');
const { initializeApp } = require('firebase-admin/app');
const { getFirestore } = require('firebase-admin/firestore');
const { getMessaging } = require('firebase-admin/messaging');

initializeApp();

const db = getFirestore('newsly');

/**
 * Triggered when a new article is published.
 * Sends a push notification to all followers of the article's author.
 */
exports.notifyFollowersOnArticlePublished = onDocumentCreated(
  {
    document: 'articles/{articleId}',
    database: 'newsly',
  },
  async (event) => {
    const article = event.data.data();

    // Only notify for published articles
    if (!article.isPublished) return null;

    const authorId = article.authorId;
    const authorName = article.author;
    const articleTitle = article.title;
    const articleId = event.params.articleId;

    // Get all followers of this author
    const followsSnap = await db
      .collection('follows')
      .where('followingId', '==', authorId)
      .get();

    if (followsSnap.empty) return null;

    const followerIds = followsSnap.docs.map((doc) => doc.data().followerId);

    // Get FCM tokens for all followers
    const userSnaps = await Promise.all(
      followerIds.map((uid) => db.collection('users').doc(uid).get())
    );

    const tokens = userSnaps
      .filter((snap) => snap.exists && snap.data().fcmToken)
      .map((snap) => snap.data().fcmToken);

    if (tokens.length === 0) return null;

    // Send multicast notification
    const message = {
      notification: {
        title: `New article by ${authorName}`,
        body: articleTitle,
      },
      data: {
        articleId: articleId,
        type: 'new_article',
      },
      tokens,
    };

    const response = await getMessaging().sendEachForMulticast(message);
    console.log(
      `Sent ${response.successCount} notifications, ${response.failureCount} failures`
    );

    return null;
  }
);
