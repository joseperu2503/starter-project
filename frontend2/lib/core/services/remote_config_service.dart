import 'package:firebase_remote_config/firebase_remote_config.dart';

class RemoteConfigService {
  final FirebaseRemoteConfig _remoteConfig;

  RemoteConfigService(this._remoteConfig);

  static const String articleCardStyleKey = 'article_card_style';
  static const String _defaultCardStyle = 'list';

  static const String premiumRemarketingKey = 'premium_remarketing_offer';
  static const String _defaultRemarketingOffer = 'none';

  Future<void> init() async {
    await _remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: 10),
      minimumFetchInterval: Duration.zero,
    ));
    await _remoteConfig.setDefaults({
      articleCardStyleKey: _defaultCardStyle,
      premiumRemarketingKey: _defaultRemarketingOffer,
    });
    await _remoteConfig.fetchAndActivate();
  }

  /// Returns 'list' or 'card'
  String get articleCardStyle =>
      _remoteConfig.getString(articleCardStyleKey);

  /// Returns 'none', 'discount_20', etc.
  String get premiumRemarketingOffer =>
      _remoteConfig.getString(premiumRemarketingKey);
}
