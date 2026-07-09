import 'package:package_info_plus/package_info_plus.dart';

class AppVersionService {
  AppVersionService._();

  static final AppVersionService instance = AppVersionService._();

  PackageInfo? _packageInfo;

  Future<void> init() async {
    _packageInfo ??= await PackageInfo.fromPlatform();
  }

  String get version {
    if (_packageInfo == null) {
      throw Exception(
        'AppVersionService has not been initialized. Call init() first.',
      );
    }

    return _packageInfo!.version;
  }

  String get buildNumber {
    if (_packageInfo == null) {
      throw Exception(
        'AppVersionService has not been initialized. Call init() first.',
      );
    }

    return _packageInfo!.buildNumber;
  }

  String get fullVersion => '$version+$buildNumber';

  String get appName => _packageInfo?.appName ?? '';

  String get packageName => _packageInfo?.packageName ?? '';
}