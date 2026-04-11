import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  final FirebaseAnalytics _analytics;

  AnalyticsService(this._analytics);

  Future<void> logArticleOpened({
    required String articleId,
    required String category,
    required String cardStyle,
  }) async {
    await _analytics.logEvent(
      name: 'article_opened',
      parameters: {
        'article_id': articleId,
        'category': category.isEmpty ? 'none' : category,
        'card_style': cardStyle,
      },
    );
  }
}
