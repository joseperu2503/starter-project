import 'package:firebase_remote_config/firebase_remote_config.dart';

class RemoteConfigService {
  final FirebaseRemoteConfig _remoteConfig;

  RemoteConfigService(this._remoteConfig);

  static const String articleCardStyleKey = 'article_card_style';
  static const String _defaultCardStyle = 'list';

  Future<void> init() async {
    await _remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: 10),
      minimumFetchInterval: Duration.zero,
    ));
    await _remoteConfig.setDefaults({
      articleCardStyleKey: _defaultCardStyle,
    });
    await _remoteConfig.fetchAndActivate();
  }

  /// Returns 'list' or 'card'
  String get articleCardStyle =>
      _remoteConfig.getString(articleCardStyleKey);
}
