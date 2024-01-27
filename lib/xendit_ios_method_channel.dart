import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:xendit_ios/model/billing.dart';
import 'package:xendit_ios/model/card.dart';
import 'package:xendit_ios/model/customer.dart';

import 'xendit_ios_platform_interface.dart';

/// An implementation of [XenditIosPlatform] that uses method channels.
class MethodChannelXenditIos extends XenditIosPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('xendit_ios');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  // @override
  // Future<Map<dynamic, dynamic>> createSingleToken(
  //   XCard card, {
  //   required int amount,
  //   bool shouldAuthenticate = true,
  //   String onBehalfOf = '',
  //   BillingDetails? billingDetails,
  //   Customer? customer,
  //   String? currency,
  // }) async {
  //   final result = await methodChannel.invokeMethod('createSingleToken');
  //   return result;
  //   // return super.createSingleToken();
  // }
}
