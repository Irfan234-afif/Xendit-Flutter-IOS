import 'package:flutter_test/flutter_test.dart';
import 'package:xendit_ios/xendit_ios.dart';
import 'package:xendit_ios/xendit_ios_platform_interface.dart';
import 'package:xendit_ios/xendit_ios_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockXenditIosPlatform
    with MockPlatformInterfaceMixin
    implements XenditIosPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final XenditIosPlatform initialPlatform = XenditIosPlatform.instance;

  test('$MethodChannelXenditIos is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelXenditIos>());
  });

  test('getPlatformVersion', () async {
    XenditIos xenditIosPlugin = XenditIos();
    MockXenditIosPlatform fakePlatform = MockXenditIosPlatform();
    XenditIosPlatform.instance = fakePlatform;

    expect(await xenditIosPlugin.getPlatformVersion(), '42');
  });
}
