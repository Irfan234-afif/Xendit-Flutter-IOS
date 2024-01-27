import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'xendit_ios_method_channel.dart';

abstract class XenditIosPlatform extends PlatformInterface {
  /// Constructs a XenditIosPlatform.
  XenditIosPlatform() : super(token: _token);

  static final Object _token = Object();

  static XenditIosPlatform _instance = MethodChannelXenditIos();

  /// The default instance of [XenditIosPlatform] to use.
  ///
  /// Defaults to [MethodChannelXenditIos].
  static XenditIosPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [XenditIosPlatform] when
  /// they register themselves.
  static set instance(XenditIosPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<Map<dynamic, dynamic>> createSingleToken() {
    throw UnimplementedError('createSingleToken() has not been implemented.');
  }
}
