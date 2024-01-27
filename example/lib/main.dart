import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:xendit_ios/model/card.dart';
import 'package:xendit_ios/xendit_ios.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  // final _xenditIosPlugin = XenditIos();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    // try {
    //   platformVersion = await _xenditIosPlugin.getPlatformVersion() ??
    //       'Unknown platform version';
    // } on PlatformException {
    //   platformVersion = 'Failed to get platform version.';
    // }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    // setState(() {
    //   _platformVersion = platformVersion;
    // });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(localizationsDelegates: [
      DefaultWidgetsLocalizations.delegate,
      DefaultCupertinoLocalizations.delegate,
      DefaultMaterialLocalizations.delegate,
    ], home: HomePage());
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: Center(
        child: Builder(builder: (context) {
          return ElevatedButton(
            onPressed: () async {
              // try {
              final xenditIos = XenditIos(
                  "xnd_public_development_9aXTOZaH7x18wIOnQmS46duJe6n8I72vneT12v1APsVHPT4xpEdjmyT2HLwQHU");
              final card = XCardIos(
                creditCardNumber: "4000000000001091",
                creditCardCVN: "123",
                expirationMonth: "12",
                expirationYear: "2024",
              );
              final customer = XCustomerIos(
                id: "cust-9d5e09e3-c70a-4205-a01b-0fcdade79275",
                referenceId: "2d3f8",
                email: "irfanD@gmail.com",
                givenNames: "irfam",
                surname: "irfam",
                description: null,
                mobileNumber: "+6282132263308",
                phoneNumber: "+6282132263308",
                nationality: "ID",
                dateOfBirth: null,
              );
              await xenditIos.createSingleToken(card, amount: 50000, customer: customer);
              // print(result);
              // } catch (e) {
              // print(e);
              // }
            },
            child: Text('Create Single Token'),
          );
        }),
      ),
    );
  }
}
