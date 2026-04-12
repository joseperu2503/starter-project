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

  Future<void> logPremiumPaywallShown({required String articleId}) async {
    await _analytics.logEvent(
      name: 'premium_paywall_shown',
      parameters: {'article_id': articleId},
    );
  }

  Future<void> logPremiumDismissed({required String articleId}) async {
    await _analytics.logEvent(
      name: 'premium_dismissed',
      parameters: {'article_id': articleId},
    );
  }

  Future<void> logPremiumRemarketingShown({
    required String articleId,
    required String offer,
  }) async {
    await _analytics.logEvent(
      name: 'premium_remarketing_shown',
      parameters: {'article_id': articleId, 'offer': offer},
    );
  }

  Future<void> logPremiumSubscribeTapped({
    required String articleId,
    required String source, // 'paywall' or 'remarketing'
    required String offer,
  }) async {
    await _analytics.logEvent(
      name: 'premium_subscribe_tapped',
      parameters: {
        'article_id': articleId,
        'source': source,
        'offer': offer,
      },
    );
  }
}
