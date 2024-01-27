import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:xendit_ios/model/billing.dart';
import 'package:xendit_ios/model/card.dart';
import 'package:xendit_ios/model/customer.dart';
import 'package:xendit_ios/model/token.dart';
import 'package:xendit_ios/model/token_result.dart';
export './model/card.dart';
export './model/token.dart';
export './model/customer.dart';
// import 'package:xendit_ios/webview.dart';

import 'xendit_ios_platform_interface.dart';

class XenditIos {
  final String publishableKey;
  XenditIos(this.publishableKey);
  final _channel = const MethodChannel('xendit_ios');
  static final XenditIosPlatform instance = XenditIosPlatform.instance;
  Future<String?> getPlatformVersion() {
    return XenditIosPlatform.instance.getPlatformVersion();
  }

  // Future<Map<dynamic, dynamic>> createSingleToken() {
  //   return XenditIosPlatform.instance.createSingleToken();
  // }

  Future<TokenResult> createToken(
    XCardIos card, {
    required int amount,
    bool shouldAuthenticate = true,
    String onBehalfOf = '',
    BillingDetails? billingDetails,
    XCustomerIos? customer,
    String? currency,
  }) async {
    var params = <String, dynamic>{
      'publishedKey': publishableKey,
      'card': card.to(),
      'amount': amount,
      'shouldAuthenticate': shouldAuthenticate,
      'onBehalfOf': onBehalfOf,
    };

    if (billingDetails != null) {
      params['billingDetails'] = billingDetails.to();
    }

    if (customer != null) {
      params['customer'] = customer.to();
    }

    if (currency != null) {
      params['currency'] = currency;
    }
    try {
      var result = await _channel.invokeMethod("createSingleToken", params);
      print(result);
      return TokenResult(token: XTokenIos.from(result));
    } on PlatformException catch (e) {
      print(e);
      return TokenResult(errorCode: e.code, errorMessage: e.message);
    }
  }
  // Future<Map<dynamic, dynamic>> createSingleToken(
  //   XCardIos card, {
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

  Future<TokenResult> createSingleToken(
    XCardIos card, {
    // required BuildContext context,
    required int amount,
    bool shouldAuthenticate = true,
    String onBehalfOf = '',
    BillingDetails? billingDetails,
    XCustomerIos? customer,
    String? currency,
  }) async {
    return await createToken(card,
        amount: amount,
        billingDetails: billingDetails,
        currency: currency,
        customer: customer,
        onBehalfOf: onBehalfOf,
        shouldAuthenticate: shouldAuthenticate);
    // print(result);
    // ignore: use_build_context_synchronousl, use_build_context_synchronously
    // Scaffold.of(context).showBottomSheet(
    //   (context) => WebViewIos(url: result.redirectUrl!),
    // );
    // return showModalBottomSheet(
    //   context: context,
    //   showDragHandle: true,
    //   isScrollControlled: true,
    //   enableDrag: true,
    //   scrollControlDisabledMaxHeightRatio: .9,
    //   builder: (context) => WebViewIos(
    //     url: result.redirectUrl!,
    //   ),
    // );
  }
}
