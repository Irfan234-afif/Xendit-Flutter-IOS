import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:xendit_ios/xendit_ios_platform_interface.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class WebViewIos extends StatefulWidget {
  const WebViewIos({super.key, required this.url});
  final String url;

  @override
  State<WebViewIos> createState() => _WebViewIosState();
}

class _WebViewIosState extends State<WebViewIos> {
  late WebViewController webViewController;

  final instance = XenditIosPlatform.instance;

  @override
  void initState() {
    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }
    // webViewController = WebViewController()..loadRequest(Uri.parse(widget.url));
    webViewController = WebViewController.fromPlatformCreationParams(params)
      ..loadRequest(Uri.parse(widget.url));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WebViewWidget(
        controller: webViewController,
      ),
    );
  }
}

class AuthResultModel {
  final String? id;
  final String? status;
  final String? redirectUrl;

  const AuthResultModel({this.id, this.redirectUrl, this.status});

  factory AuthResultModel.fromJson(Map<dynamic, dynamic> json) =>
      AuthResultModel(
        id: json['id'],
        redirectUrl: json['payer_authentication_url'],
        status: json['status'],
      );
}
